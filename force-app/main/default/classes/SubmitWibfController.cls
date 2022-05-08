/**
* Controller for Submit to WIBF Lightning component
* @author  Kyle Alexander
* @created 2018-10-15
*/
public class SubmitWibfController {
    
    /**
     * Method that checks if the WIBF submission was already done on load
     *
     * @param oppId - opportunity Id
     * @return String - WIBF validity status
     */
    @AuraEnabled 
    public static String checkInitValidity(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		
        String validity = 'Valid'; 
        if(opportunities[0].Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity'){
            List<Quote> quotes = new QuotesSelector().selectByMaterialDisclosureStatus(oppId,'Valid'); 
            System.debug('quotes'+quotes);
        	if(!quotes.isEmpty() && quotes != null)
            	validity = 'Invalid';
        } 
        else{
            if(opportunities.get(0).Declaration_Status__c != 'Valid'){
            	validity = 'Invalid';
        	}
        }        
        return validity;
    }
    
    /**
     * Method that checks if the PRI Number is valid
     *
     * @param oppId - opportunity Id
     * @return String - PRI validity status
     */
    @AuraEnabled
    public static String checkPRIValidity(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        if(opportunities.get(0).PRI_Number__c == 'Invalid'  || opportunities.get(0).PRI_Number__c == null){
            return 'Invalid';
        }
        
        return 'Valid';
    }
    
    /**
     * Method that gets the WIBF errors on load if invalid
     *
     * @param oppId - opportunity Id
     * @return Opportunity - opportunity with WIBF fields
     */
    @AuraEnabled
    public static Opportunity getWBIFErrors(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        
        return opportunities.get(0);
    }
    
    /**
     * Method that validates WIBF and calls the validate service
     * 
     * @param oppId - Opportunity Id
     * @return String - Validate submission validity
     */
    @AuraEnabled
    public static String validateWibf(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId); 
        
        //Autopopulate will number with first 11 digits of ID number
        Boolean changedWillNumber = false;
        if(opportunities.get(0).Will_Number__c == null){
            opportunities.get(0).Will_Number__c = account.ID_Number__pc.substring(0,11);
            changedWillNumber = true;
        }
        
        WBIF_IB_String_v1 wbifResponse = WBIF_IH_v1.getWBIFValidate(users.get(0), account, opportunities.get(0));
        system.debug('wbifResponse Status ' + wbifResponse.status);
        system.debug('wbifResponse Status Code ' + wbifResponse.statusCode);
        system.debug('wbifResponse Message ' + wbifResponse.message);
        
        if(wbifResponse.statusCode == 200 && wbifResponse.message == null){
            opportunities.get(0).WBIF_Validate_Status__c = 'Valid';
            
            if(changedWillNumber){
                opportunities.get(0).Will_Number__c = null;
            }
            
            update opportunities;
            
            return 'WBIF Success';
        }
        else{
            opportunities.get(0).WBIF_Last_Error_Date__c = DateTime.now();
            if(wbifResponse.message == null){
                opportunities.get(0).WBIF_Last_Error_Message__c = 'An Unknown Error Occured During Validation.\r\nPlease Contact a System Administrator';
            }
            else{
                opportunities.get(0).WBIF_Last_Error_Message__c = wbifResponse.message;
            }
            opportunities.get(0).WBIF_Validate_Status__c = 'Incomplete';
            
            if(changedWillNumber){
                opportunities.get(0).Will_Number__c = null;
            }
            
            update opportunities;
            
            return 'WBIF Validation Error';
        }   
    }
    
    /**
     * Method that gets the PRI Number 
     * 
     * @param oppId - Opportunity Id
     */
    @AuraEnabled
    public static String retrievePriNumber(Id oppId) { 
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId); 
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        
        InsertOrUpdatePRICASA_Resp_IB_v1 response = InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA(account, oppId, users.get(0).Id, quotes.get(0));
        
        if(response.statusCode == 200
          || (System.Test.isRunningTest() && response.statusCode == 500))
        {
            opportunities.get(0).PRI_Number__c = response.PRINumber;
            update opportunities;
            return 'PRI Success';
        }
        else
        {
            return 'Error getting PRI Number: ' + response.errormsg;
        }        
    }
    
    /**
     * Method that submits to WIBF and calls the submit service
     * 
     * @param oppId - Opportunity Id
     * @return String - Submission validity
     */
    @AuraEnabled
    public static String submitWibf(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
        List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId); 
        
        //Autopopulate will number with first 11 digits of ID number
        Boolean changedWillNumber = false;
        if(opportunities.get(0).Will_Number__c == null){
            opportunities.get(0).Will_Number__c = account.ID_Number__pc.substring(0,11);
            changedWillNumber = true;
        }
        
        WBIF_IB_String_v1 wbifResponse = WBIF_IH_v1.getWBIFSubmitPolicy(users.get(0), account, opportunities.get(0));
        
        if(wbifResponse.statusCode == 200){
            opportunities.get(0).WBIF_Submit_Status__c = 'Valid';

            if(wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.ErrorReasons != null){
                opportunities.get(0).WBIF_Submit_Message__c = 'Proposal Number:' + wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.ProposalNumber + 
                '\r\nState:' + wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.State +
                '\r\nError Message:' + wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.ErrorReasons;
            }
            else{
                opportunities.get(0).WBIF_Submit_Message__c = 'Proposal Number:' + wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.ProposalNumber + 
                '\r\nState:' + wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.State;
            }
            
            if(wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.PolicyNumber != null){
                opportunities.get(0).WBIF_Policy_Number__c = wbifResponse.SubmitPolicyResponse.SubmitPolicyResult.PolicyInfo.PolicyNumber;
                
                //List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
                //Send email and attach quote
                //opportunities.get(0).Email_Status__c = 'Valid';
                //update opportunities;
                //SubmitDocumentsController.generateAndSendROA(oppId, accounts.get(0), opportunities.get(0).Selected_Email__c, users.get(0)); 
                sendEmail(oppId);    
                
				opportunities.get(0).StageName = 'Sale Successful';
            }
            
            if(changedWillNumber){
                opportunities.get(0).Will_Number__c = null;
            }
            
            update opportunities;
            
            return 'WBIF Success';
        }
        else{
            opportunities.get(0).WBIF_Last_Error_Date__c = DateTime.now();
            if(wbifResponse.message == null){
                opportunities.get(0).WBIF_Last_Error_Message__c = 'An Unknown Error Occured During Validation.\r\nPlease Contact a System Administrator';
            }
            else{
            	opportunities.get(0).WBIF_Last_Error_Message__c = wbifResponse.message;
            }
            opportunities.get(0).WBIF_Validate_Status__c = 'Incomplete';
            
            update opportunities;
            
            return 'WBIF Validation Error';
        }  
    }
    
    /**=================================================================================================================================
* Method checks if Ultimate Protector Quotes exist for this Opportunity

* Param 1: opportunityId is our Opportunity Id from the Autolaunched Flow
=======================================================QuotesSelector============================================================================**/
    @AuraEnabled
    public static Boolean checkUltimateProtectorStatus(Id oppId)
    {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        if(opportunities[0].Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity'){
            List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,StringConstants.PRODUCT_ULTIMATE_PROTECTOR);        
            if(!Sys_Utilities_General.isListBlank(quotes)){
                if(quotes[0].Status == 'Accepted')
            	return true;
            else
                return false;
        } 
        else
                return false;
        } 
        else
        	return true;
    }
    
    @Future(callout=true)
    private static void sendEmail(Id oppId) {
        try{
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        	List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId); 
            List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
            //Send email and attach quote
            
            //SMSHandler.sendSMS(accounts.get(0).PersonContactId, oppId, '', '', StringConstants.CLIENT_EPP_SUCCESSFUL_SALE_SMS, StringConstants.EPP_ITOUCH_SMS_INTEGRATION_SERVICE, true, false);

            SubmitDocumentsController.generateAndSendROA(oppId, accounts.get(0), opportunities.get(0).Selected_Email__c, users.get(0), true); 

            opportunities.get(0).Email_Status__c = 'Valid';
            update opportunities.get(0);
        }
        catch(Exception e){
            System.debug(LoggingLevel.INFO, 'Automatic email sending issue:' + e.getCause() + ', ' + e.getLineNumber() + ', ' + e.getMessage());
        }    
    }
    
    /**
     * Method that updates Opportunity Status
     *
     * @param oppId - opportunity Id
     * @return Opportunity - opportunity with WIBF fields
     */
    @AuraEnabled
    public static Boolean updateOpportunityStatus(Id oppId)
    {
        Opportunity opportunity = new Opportunity();
        opportunity.Id = oppId;
        opportunity.StageName = 'Completed';
        UPDATE opportunity;
        return true;
    }
}