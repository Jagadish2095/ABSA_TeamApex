/**
* Controller for Risk Screening Lightning component
* @author  Kyle Alexander
* @created 2018-09-26 
*/
public class RiskScreeningController {
    
    private static Map <String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    
    /**
     * Method that gets a an account from an opportunity
     *
     * @param oppId - opportunity Id
     * @return Account - specific account related to opportunity
     */
	@AuraEnabled 
    public static Account getAccountData(Id oppId) {
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectRiskFieldsById(opportunity.AccountId, 1);

        return accounts.get(0);
    }
    
    /**
     * Method that gets a an account from an opportunity
     *
     * @param oppId - opportunity Id
     * @return Account - specific account related to opportunity
     */
	@AuraEnabled
    public static List<String> getCountriesTradedData(Id oppId) {
		Opportunity opportunity = new OpportunitiesSelector().selectByActivityId(oppId, 1);
        List<Account> accounts = new AccountsSelector().selectRiskFieldsById(opportunity.AccountId, 1);
		
        if(accounts.get(0).Countries_Traded_With__c != null){
            return accounts.get(0).Countries_Traded_With__c.split(';');
        }
        return null;
    }
    
    /**
     * Method that checks if the risk screening has been done on init
     *
     * @param oppId - opportunity Id
     * @return String - the risk status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String checkInitValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        return opportunities.get(0).Risk_Status__c;
    }
    
    /**
     * Method that checks if the casa screening has been done on init
     *
     * @param oppId - opportunity Id
     * @return String - casa status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String checkCASAValidity(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        return opportunities.get(0).CASA_Status__c;
    }
    
    /**
     * Method that checks what the CASA status is and if Pending then show refresh button
     *
     * @param oppId - opportunity Id
     * @return String - the risk status i.e. valid, invalid etc.
     */
    @AuraEnabled
    public static String getCasaStatus(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            return accounts.get(0).CASA_Screening_Status__c;
        }
        else{
            return accounts.get(0).CASA_Screening_Status__pc;
        }
    }
    
    /**
     * Method that gets the risk rating data
     *
     * @param oppId - opportunity Id
     * @return opportunity - that contains risk data
     */
    @AuraEnabled
    public static Opportunity getRiskRatingData(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
       

        if(opportunities.get(0).Risk_Rating__c != null && opportunities.get(0).Risk_Rating_Date__c != null){
            return opportunities.get(0);
        }
        return null;
    }
    
    /**
     * Method that checks what the Account record type is
     *
     * @param oppId - opportunity Id
     * @return String - account record type i.e. Individual/Business client
     */
    @AuraEnabled
    public static String getAccountRecordType(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        System.debug(accounts.get(0).RecordType.Name);
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            return 'Business Client';
        }
        else if(accounts.get(0).RecordType.Name == 'Individual Client' || accounts.get(0).RecordType.Name == 'Individual Prospect'){
            return 'Individual Client';
        }
        else{
          	return null;  
        } 
    }
    
    /**
     * Method that updates the account and does callout to risk service 
     *
     * @param oppId - opportunity Id
     * @return Account - updated account
     */
    @AuraEnabled
    public static String updateAccountAndDoRiskScreening(Id oppId, Account updatedAccount) {
                
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
           
        List<User> originatingUsers = new UsersSelector().selectByBridNumber(opportunities.get(0).Adviser_BRID_Number__c);
        System.debug('originatingUsers: ' + originatingUsers);
        
        List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
        System.debug(accounts.get(0).RecordType.Name);
        if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
            RiskProfileJointClient_Resp_IB_v1 riskResponse = new RiskProfileJointClient_Resp_IB_v1();
            //Robert McLean 10152019 -- interim fix
            List<String> productCodeList = new List<String>(); 
            List<String> subProductCodeList = new List<String>(); 
            String OppRecType = opportunities.get(0).RecordType.Name;
            String sbu = '61' ;
			if(OppRecType == 'Wills'){
                productCodeList.add('BWILL'); 
                subProductCodeList.add(''); 
                sbu = '102';
            } else {
                productCodeList.add('EPP1'); 
                subProductCodeList.add(''); 
      		}

            //List<Contact> contacts = [SELECT Id, FirstName, LastName, Occupation__c, Occupation_Category__c, Occupation_Status__c, CASA_Reference_Number__c, Income_Source__c FROM Contact WHERE AccountId = :accounts.get(0).Id];
            //List<Contact> contacts = new AccountContactRelationSelector().selectListByAccId(accounts.get(0).Id);
            List<Account> participantAccounts = new AccountContactRelationSelector().selectListByAccId(accounts.get(0).Id);
            
            System.debug('participantAccounts: ' + participantAccounts);
            String errorMessage = 'The following related contacts have missing data required for Risk Rating!';
            Boolean isMissingData = false;
            for(Account a : participantAccounts){
                errorMessage += '\r\n - ' + a.FirstName + ' ' + a.LastName + ':';
                if(a.Occupation__pc == null){
                    isMissingData = true;
                    errorMessage += 'Occupation;';
                }
                if(a.Occupation_Category__pc == null){
                    isMissingData = true;
                    errorMessage += 'Occupation Category;';
                }
                if(a.Occupation_Status__pc == null){
                    isMissingData = true;
                    errorMessage += 'Occupation Status;';
                }
                if(a.Income_Source__pc == null){
                    isMissingData = true;
                    errorMessage += 'Income Source;';
                }
                if(a.CASA_Reference_Number__pc == null){
                    isMissingData = true;
                    errorMessage += 'CASA Reference Number;';
                }
            }
            
            if(!isMissingData){
                List<String> countriesList;
                if(accounts.get(0).Countries_Traded_With__c != null){
                    countriesList = accounts.get(0).Countries_Traded_With__c.split(';');
                }
                else{
                    countriesList = new List<String>{'South Africa'};
                }               
                //Call service
                riskResponse = RiskProfileJointClient_IH_v1.riskProfileJntClient(accounts.get(0), participantAccounts, productCodeList, subProductCodeList, countriesList, originatingUsers.get(0).id, sbu);
                //riskResponse = RiskProfileJointClient_IH_v1.riskProfileJntClient(accounts.get(0), null, productCodeList, subProductCodeList, countriesList, originatingUsers.get(0).id);

                System.debug('riskResponseJoint: ' + riskResponse);
                
                if(riskResponse.msgNo == 200){
                    opportunities.get(0).Risk_Status__c = 'Valid';
                    opportunities.get(0).Risk_Rating__c = riskResponse.riskRating;
                    opportunities.get(0).Risk_Rating_Date__c = DateTime.now();
                    opportunities.get(0).Risk_Rating_Message__c = riskResponse.msg;
                    
                    update updatedAccount;
                    update opportunities;
                    
                    return 'Success';
                }
                else{
                    return 'Error: ' + riskResponse.msg;
                }    
            }
            else{
                return 'Error: ' + errorMessage;
            }
        }
        else if(accounts.get(0).RecordType.Name == 'Individual Client' || accounts.get(0).RecordType.Name == 'Individual Prospect'){
            
            GetRiskProfileClient_Resp_IB_v1 riskResponse = new GetRiskProfileClient_Resp_IB_v1();
            //Robert McLean 10152019 -- interim fix
            List<String> productCodeList = new List<String>(); 
            List<String> subProductCodeList = new List<String>(); 
            String OppRecType = opportunities.get(0).RecordType.Name;
            String sbu = '61' ;
			if(OppRecType == 'Wills'){
                productCodeList.add('BWILL'); 
                subProductCodeList.add(''); 
                sbu = '102';
            } else {
                productCodeList.add('EPP1'); 
                subProductCodeList.add(''); 
      		}
            List<String> countriesList;
            if(accounts.get(0).Countries_Traded_With__c != null){
                countriesList = accounts.get(0).Countries_Traded_With__c.split(';');
            }
            else{
                countriesList = new List<String>{'South Africa'};
            }
            riskResponse = GetRiskProfileClient_IH_v1.getRiskProfileClient(updatedAccount, originatingUsers.get(0).id, productCodeList, subProductCodeList, countriesList, sbu); 
            
            if(riskResponse.WQriskProfileClientV7Response.msgNo == 200){
                opportunities.get(0).Risk_Status__c = 'Valid';
                opportunities.get(0).Risk_Rating__c = riskResponse.WQriskProfileClientV7Response.riskRating;
                opportunities.get(0).Risk_Rating_Date__c = DateTime.now();
                opportunities.get(0).Risk_Rating_Message__c = riskResponse.WQriskProfileClientV7Response.msg;
                
                if (opportunities.get(0).RecordTypeId == opportunityRecordTypeMap.get('Virtual_Advisor').getRecordTypeId()) {
                    //update Stage Name for Virtual Advisor Opportunity
                    opportunities.get(0).StageName = 'Proposal';
                }
                
                update updatedAccount;
                update opportunities;
                
                return 'Success';
            }
            else{
                return 'Error: ' + riskResponse.WQriskProfileClientV7Response.msg;
            }    
        }
        return null;
    }
    
    /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
     */
    @AuraEnabled
    public static List <String> getselectOptions(sObject objObject, string fld) {
        List <String> allOpts = new list <String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //allOpts.sort();
        return allOpts;
    }
}