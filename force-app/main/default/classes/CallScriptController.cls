/**
* @author Minal Rama (BlueSky)
* @date 2020/10/20
* @description Call script controller to retrieve records of scripts in the Call_Script__c object
*/
public class CallScriptController {
    
    private static final String FLEXI_FUNERAL = 'Flexi Funeral';
    private static final String FLEXI_FUNERAL_ONLINE = 'DD Flexi Funeral - Online';
    private static final String AIP_PRODUCT = 'AIP';
    /**
* @param count the Step__c field
* @param financialProductName the financial product name from Financial_Product__c
* @param campaign the campaignId
* @description
* @return Single call script record
*/
    @AuraEnabled
    public static Call_Script__c getScript(Integer count, String financialProductName, String campaign) {
        List<Call_Script__c> callScripts = new List<Call_Script__c>();
        List<Integer> steps = new List<Integer>();
        steps.add(count);
        CallScriptsSelector scriptsSelector = new CallScriptsSelector();
        
        if(financialProductName == FLEXI_FUNERAL)
        {
            if(String.isNotBlank(campaign))
            {
                callScripts = scriptsSelector.selectByStepsAndProductNameAndCampaign(steps, financialProductName, campaign);
                if (callScripts.isEmpty()) {
                    //Added by Minal 2021-01-18
                    //If Flexi is cross sell default to online campaign
                    List<Campaign> ffOnline = [SELECT Id FROM Campaign WHERE Name =: FLEXI_FUNERAL_ONLINE LIMIT 1];
                    if(!ffOnline.isEmpty()){
                        callScripts = scriptsSelector.selectByStepsAndProductNameAndCampaign(steps, financialProductName, ffOnline[0].Id);
                    }
                }
            }else {
                List<Campaign> ffOnline = [SELECT Id FROM Campaign WHERE Name =: FLEXI_FUNERAL_ONLINE LIMIT 1];
                if(!ffOnline.isEmpty()){
                    callScripts = scriptsSelector.selectByStepsAndProductNameAndCampaign(steps, financialProductName, ffOnline[0].Id);
                }
            }
        }
        else If(financialProductName == AIP_PRODUCT)
        {
            //added for AIP
            callScripts = scriptsSelector.selectByStepsAndProductNameAndCampaign(steps, financialProductName, campaign);
                if (callScripts.isEmpty()) {
                    
                    List<Campaign> ffOnline = [SELECT Id FROM Campaign WHERE Name =: FLEXI_FUNERAL_ONLINE LIMIT 1];
                    if(!ffOnline.isEmpty()){
                        callScripts = scriptsSelector.selectByStepsAndProductNameAndCampaign(steps, financialProductName, ffOnline[0].Id);
                    }
                }
        }
        else
        {
            callScripts = scriptsSelector.selectByStepAndProductName(count, financialProductName);
        }
        if (!callScripts.isEmpty()) {
            //system.debug('callScripts: ' + callScripts[0].Id);
            return callScripts[0];
        } else
            return null;
    }
    
    /**
* @param steps the Step__c field
* @param financialProductName the financial product name from Financial_Product__c
* @param campaign the campaignId
* @description
* @return multiple call script records
*/
    @AuraEnabled
    public static List<Call_Script__c> getScripts(String steps, String financialProductName, String campaign) {
        List<Call_Script__c> callScripts = new List<Call_Script__c>();
        if (String.isNotBlank(steps)) {
            List<Integer> stepsToInteger = getDigits(steps); 
            if (financialProductName == FLEXI_FUNERAL) {
                if (String.isNotBlank(campaign)) {
                    callScripts = new CallScriptsSelector().selectByStepsAndProductNameAndCampaign(stepsToInteger, financialProductName, campaign);
                    if (!callScripts.isEmpty()) {
                        return callScripts;
                    } else {
                        //Added by Minal 2021-01-18
                        //If Flexi is cross sell default to online campaign
                        List<Campaign> ffOnline = [SELECT Id FROM Campaign WHERE Name = :FLEXI_FUNERAL_ONLINE LIMIT 1];
                        callScripts = new CallScriptsSelector().selectByStepsAndProductNameAndCampaign(stepsToInteger, financialProductName, ffOnline[0].Id);
                        if (!callScripts.isEmpty()){
                            return callScripts;
                        } else return null;
                    }
                } else {
                    List<Campaign> ffOnline = [SELECT Id FROM Campaign WHERE Name = :FLEXI_FUNERAL_ONLINE LIMIT 1];
                    callScripts = new CallScriptsSelector().selectByStepsAndProductNameAndCampaign(stepsToInteger, financialProductName, ffOnline[0].Id);
                    if (!callScripts.isEmpty()){
                        return callScripts;
                    } else return null;
                }
            } else if(financialProductName == AIP_PRODUCT){
                // added for AIP call scripts
                // 2021/06/28
                // Divya
                callScripts = new CallScriptsSelector().selectByStepsAndProductNameAndCampaign(stepsToInteger, financialProductName,campaign);
                
            } 
            else{
                callScripts = new CallScriptsSelector().selectByStepsAndProductName(stepsToInteger, financialProductName);
            }
            if (!callScripts.isEmpty()) {
                return callScripts;
            } else {
                return null;
            }
            
        } else {
            return null;
        }
    }
    
    /**
* @param input strings, comma separated
* @description 
* @return list of integer
*/
    private static List<Integer> getDigits(String input)
    {
        List<Integer> digits = new List<Integer>();
        Matcher m = Pattern.compile('\\d{1,2}(?=)').matcher(input);
        while (m.find()) digits.add(Integer.valueOf(m.group()));
        return digits;
    }
    
    //Ashok added this method for AHP
  /*  @AuraEnabled
    public static opportunity getLeadInfo(String opptyId) {
        return [SELECT id,CampaignId,ownerId,AccountId,Converted_Lead__c,Converted_Lead__r.RecordTypeId,
                Converted_Lead__r.Name,Converted_Lead__r.Highest_Qualification__c,
                Converted_Lead__r.Affordable_House_Indicator__c, Converted_Lead__r.Application_Amount__c, 
                Converted_Lead__r.Attorney__c, Converted_Lead__r.Bond_Originator__c,Converted_lead__r.DD_Sum_Assured__c, 
                Converted_Lead__r.Borrower_Monthly_Income__c, Converted_Lead__r.Customer_Type__c, 
                Converted_Lead__r.Date_Granted__c, Converted_Lead__r.Loan_Amount_Granted__c, 
                Converted_Lead__r.Loan_Type_Code__c, Converted_Lead__r.My_Home_Indicator__c, 
                Converted_Lead__r.Property_Type__c, Converted_Lead__r.SBU_Code_branch__c, 
                Converted_Lead__r.Term__c,Person_Occupation__c,smoker__c,
                Monthly_Income__c,Duties_Admin__c,Duties_Supervisory__c,Duties_Travel__c,Duties_Manual__c,
                Payment_Frequency__c,Commencement_Date__c,Sum_Assured_for_Disability_Cover__c,Bond_Account_Number__c,
                Heart_High_BP_Diabetes_or_Cancer__c,Diagnosed_with_any_chronic_conditions__c,
                Consult_a_doctor_or_need_an_Operation__c,Have_you_ever_tested_positive_for_HIV__c,
                Grant_access_to_ABSA_to_assess_the_risk__c,Confirm_the_information_provided_is_true__c,
                Have_the_client_referred_to_instant_life__c,Product_Interest__c,
                (SELECT Id, Name, RecordTypeId, Title, Is_this_a_joint_bond__c, Highest_Income__c, FirstName, LastName, 
                 DD_Gender__c, ID_Type__c, ID_Number__c, Passport_Number__c, DD_Date_of_Birth__c, 
                 DD_Work_Phone__c, DD_Home_Phone__c, MobilePhone,Term__c from LeadsSTI2__r)
                FROM opportunity WHERE id =:opptyId];
    }*/
       /**
* @param oppty 
* @param lead 
* @description 
* @return list of integer
*/
   /* @AuraEnabled
    public static string updateOpportunityInfo(Opportunity oppty, Lead lead) {
        string resp = '';
        Database.UpsertResult[] results = new Database.UpsertResult[]{} ;
            boolean isInsertlead = (lead != null && lead.Is_this_a_joint_bond__c)? true:false;
        boolean isUpdateOpty = oppty!=null?true:false;
        /Lead newLead = new lead();
        lead.Campaign__c = oppty.CampaignId;
        lead.ownerId = oppty.ownerId;
        lead.RecordTypeId = oppty.Converted_Lead__r.RecordTypeId;
        lead.FinServ__RelatedAccount__c = oppty.AccountId;
        lead.Financial_Product__c = oppty.Product_Interest__c;
        lead.Parent_Opportunity__c = oppty.id; //new Opportunity(id=oppty.Id);
        if(isInsertlead){
            results = Database.upsert(new SObject[] {
                oppty,lead});
        }
        else{
            results = Database.upsert(new SObject[] {
                oppty});
        }
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Upsert successful created ID: '+ results[i].getId());
                resp = 'SUCCESS';
            } else {
                System.debug('Error: could not create sobject ' + 'for array element ' + i + '.');
                System.debug('   The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n');
                resp = 'Error in upserting the details.';
            }
        }*/
        /* }catch(DmlException err){
system.debug('Error in Updating Opportunity' + err.getMessage());
resp = err.getMessage();
}
        return resp;
    }*/
           /**
* @param objectName 
* @param fieldAPIName 
* @description 
* @return picklistValueMap
*/
    @AuraEnabled
    public static map<string,string> getPicklistValuesMap(string objectName, string fieldAPIName) {
        map<string,string> picklistValueMap = new map<string,string>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldAPIName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            picklistValueMap.put(pickListVal.getLabel(), pickListVal.getValue());
        }
        return picklistValueMap;
    }
}