/**
* @description       : DirectDeliveryLeadOutcomesController
* @author            : MinalRama
* @group             :
* @last modified on  : 2021-11-24
* @last modified by  : Vinod.Thupakula@absa.africa
**/
public class DirectDeliveryLeadOutcomesController {
    /**
* @description       : leadException
* @author            : MinalRama
**/
    public class leadException extends Exception {}
    /** @description getOutcomes
     * @param recordId
     * @return Map<String,List<String>>
     **/
    @AuraEnabled
    public static Map<String,List<String>> getOutcomes(Id recordId){
        
        Lead lead = [SELECT Id,Is_Inbound__c ,Financial_Product__r.Name,recordtype.developername,Name FROM Lead WHERE Id =: recordId LIMIT 1];
        Map<String,List<String>> outcomesAndReasons = new Map<String,List<String>>();
        
        if (lead.Is_Inbound__c) {
            for (Direct_Delivery_Outcomes_Setting__mdt outcome : [SELECT Inbound_Outcome__c,Inbound_Primary_Reason__c FROM Direct_Delivery_Outcomes_Setting__mdt WHERE Product__c = :lead.Financial_Product__r.Name ORDER BY Inbound_Outcome__c ASC ]) {
                
                List<String> primaryOutcomes = new List<String>();
                if (outcome.Inbound_Outcome__c != null) {
                    if(outcome.Inbound_Primary_Reason__c != null) {
                        primaryOutcomes = outcome.Inbound_Primary_Reason__c.split(',');
                    }
                    outcomesAndReasons.put(outcome.Inbound_Outcome__c, primaryOutcomes);
                }
            }
        }
        //commented for dd Deploymenent
        else if(lead.recordtype.developername == 'STI_Lead'){
            String product='STI C1';
            for (STI_outcome_setting__mdt outcome : [SELECT Outbound_Outcome__c,Inbound_Outcome__c,Inbound_Primary_Reason__c,Outbound_Primary_Reason__c FROM STI_outcome_setting__mdt WHERE Product__c =:product ORDER BY Outbound_Outcome__c ASC]) {
                
                List<String> primaryOutcomes = new List<String>();
                if (outcome.Outbound_Outcome__c != null) {
                    if(outcome.Outbound_Primary_Reason__c != null) {
                        primaryOutcomes = outcome.Outbound_Primary_Reason__c.split(',');
                    }
                    outcomesAndReasons.put(outcome.Outbound_Outcome__c, primaryOutcomes);
                }
                
            }
        }
        //Added By Divya
        else if(lead.recordtype.developername == 'Investment_Lead'){
            String product='Investment Product';
            for (Inv_outcome_setting__mdt outcome : [SELECT Outbound_Outcome__c,Inbound_Outcome__c,Inbound_Primary_Reason__c,Outbound_Primary_Reason__c FROM Inv_outcome_setting__mdt WHERE Product__c =:product ORDER BY Outbound_Outcome__c ASC]) {
                
                List<String> primaryOutcomes = new List<String>();
                if (outcome.Outbound_Outcome__c != null) {
                    if(outcome.Outbound_Primary_Reason__c != null) {
                        primaryOutcomes = outcome.Outbound_Primary_Reason__c.split(',');
                    }
                    outcomesAndReasons.put(outcome.Outbound_Outcome__c, primaryOutcomes);
                }
                
            }
        }
        else
        {
            for (Direct_Delivery_Outcomes_Setting__mdt outcome : [SELECT Outbound_Outcome__c,Outbound_Primary_Reason__c FROM Direct_Delivery_Outcomes_Setting__mdt WHERE Product__c = :lead.Financial_Product__r.Name ORDER BY Outbound_Outcome__c ASC]) {
                
                List<String> primaryOutcomes = new List<String>();
                if (outcome.Outbound_Outcome__c != null) {
                    if(outcome.Outbound_Primary_Reason__c != null) {
                        primaryOutcomes = outcome.Outbound_Primary_Reason__c.split(',');
                    }
                    outcomesAndReasons.put(outcome.Outbound_Outcome__c, primaryOutcomes);
                }
                
            }
        }
        return outcomesAndReasons;
    }
    /** @description getAttachments
     * @param recordId
     * @param outcome
     * @param reason
     * @param callBackTime
     * @param callBackLanguage
     * @param Note
     * @return string
     **/
    @AuraEnabled
    public static string saveOutcome(Id recordId, String outcome, String reason, Datetime callBackTime, String callBackLanguage,String Note){
        Lead lead1=[select id,recordtype.developername,Name,owner.type from Lead where id =: recordId];
        Lead lead;
        Task outcomeTask = new Task();
        
        if(lead1.recordtype.developername == 'STI_Lead'){
            
            string u=userinfo.getUserId();
            Set<String> permissionSetNames=new Set<String>();
            permissionSetNames.add('STI_VA_Banker_Permission_set');
            PermissionSetAssignmentsSelector pm=new PermissionSetAssignmentsSelector();
            List<PermissionSetAssignment> plist = pm.selectByNameAndUserId(permissionSetNames,u);
            if (plist.size() > 0) {
                throw new leadException('You do not have authorization to work on this leads');
            }
            
            //  id  eventRecordType = Schema.SObjectType.event.getRecordTypeInfosByDeveloperName().get('STI_Call_Event').getRecordTypeId();
            id  ddTaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('STI_Call_Task').getRecordTypeId();
            outcomeTask.TaskSubtype = 'Call';
            outcomeTask.ActivityDate = System.today();
            outcomeTask.Status = 'Completed';
            outcomeTask.Subject = 'Call';
            outcomeTask.OwnerId = UserInfo.getUserId();
            outcomeTask.Client_Name__c=lead1.Name;
            outcomeTask.Outcome__c = outcome;
            outcomeTask.Description=Note;
            //   outcomeTask.Event_RecortType_ID__c=eventRecordType;
            //   system.debug('eventRecordType'+eventRecordType);
            
            if(lead1.Owner.type == 'Queue'){
                throw new leadException('Please Assign case from Queue to user before selecting outcome');
            }
            if(!reason.contains('None')){
                //   outcomeTask.Primary_outcome_reason__c = reason;
                outcomeTask.Primary_Lead_Outcome_reasons__c=reason;
            }
            outcomeTask.WhoId = lead1.Id;
            outcomeTask.Type = 'Call';
            outcomeTask.RecordTypeId = ddTaskRecordType;
            
            if (outcome == 'Call Back') {
                if (callBackTime == null) {
                    throw new leadException('Please enter a callback date');
                }
                if (String.isBlank(callBackLanguage)) {
                    throw new leadException('Please enter a call back language');
                }
                if (callBackTime != null && String.isNotBlank(callBackLanguage)) {
                    
                    if (System.now() > callBackTime) {
                        throw new leadException('Call back date cannot be in the past');
                    }
                    outcomeTask.Call_Back_Language__c = callBackLanguage;
                    outcomeTask.Call_Back_Date__c = callBackTime;
                    //  outcomeTask.Primary_outcome_reason__c = 'Call Back';
                }
            }
            
            
        }else{      
             lead = [SELECT Id,
                         OwnerId,
                         Salutation,
                         DD_Mandatory_Fields_Completed__c,
                         DD_Source_of_Funds__c,
                         DD_Source_of_Income__c,
                         DD_AVAF_Account_Number__c,
                         Financial_Product__r.Name,                         
                         Outstanding_Capital__c,
                         Outstanding_Term__c,
                         DD_Vehicle_Description__c,
                         Interest_Rate__c,
                         Monthly_Instalment__c,
                         Deposit_Amount__c,
                         Retail_Value_MM_Code__c,
                         Contract_Start_Date__c,
                         DD_Market_Value__c,
                         Balloon_Payment__c,
                         STI_Product_Provider_Details__c,
                         Status
                         FROM Lead
                         WHERE Id = :recordId LIMIT 1];
            
            
            if(lead1.recordtype.developername == 'Investment_Lead')
            {
                //ddTaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Investment_Call_Task').getRecordTypeId();
            	outcomeTask.Task_Type__c='Investment';
            }
            
            Id ddTaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Task').getRecordTypeId();
            
            
            //     Task outcomeTask = new Task();
            
            outcomeTask.TaskSubtype = 'Call';
            outcomeTask.ActivityDate = System.today();
            outcomeTask.Status = 'Completed';
            outcomeTask.Subject = 'Call';
            outcomeTask.OwnerId = UserInfo.getUserId();
            if( outcome == 'Client Interested' && (lead.Financial_Product__r.Name == 'Extended Cover' || lead.Financial_Product__r.Name == 'AVAF Credit Life') && (                
                lead.DD_AVAF_Account_Number__c == null
                || lead.Outstanding_Capital__c == null
                || lead.DD_Vehicle_Description__c == null
                || lead.DD_Market_Value__c == null
            )){
                throw new leadException('Please complete \n AVAF Account Number, Outstanding Capital, Vehicle Description, Market Value  ');
            }
            
            if( outcome == 'Client Interested'&& (lead.DD_Source_of_Income__c == null || lead.DD_Source_of_Funds__c == null)){
                if(        lead.Financial_Product__r.Name == 'Flexi Funeral'
                   || lead.Financial_Product__r.Name == 'Health Assistance'
                   || lead.Financial_Product__r.Name == 'Road Cover'
                   || lead.Financial_Product__r.Name == 'Law 4 U'
                   || lead.Financial_Product__r.Name == 'Ultimate Protector'
                   || lead.Financial_Product__r.Name == 'Card Life')
                {
                    throw new leadException('Please complete Source of Income and Source of Funds');
                }
                
            }
            if( outcome == 'Client Interested'&& (lead.Salutation == null || lead.Salutation == null)){
                throw new leadException('Please complete Salutation.');
            }
            if(outcome == 'Client Interested' && lead.DD_Mandatory_Fields_Completed__c == false){
                //updated By Divya
                throw new leadException('Please ensure all mandatory fields are completed including ALL fields on the address,email,phone number,gender,initials,Id type,date of birth.');
            }
            
            //Added By Divya
            if(lead1.recordtype.developername == 'Investment_Lead')
            {
                List<task> listOfTask=[select Call_ID__c, Call_Start_Time__c,Call_Duration__c from task where whoId =: recordId AND GlobalRefId__c != null order by Call_Start_Time__c ASC]; 
                if(outcome == 'Uncontactable')
                {
                    if(listOfTask.size()< 3){
                        throw new leadException('Three call activity not found on Lead, please call the client 3 times before selecting Uncontactable outcome.');   
                    }
                    lead.Status='Closed';
                    lead.SubStatus__c='Customer Uncontactable';
                }
                else if(outcome == 'Client not interested')
                {
                    if(listOfTask.size()< 1){
                        throw new leadException('Please call the client One time before selecting Client Not Interested outcome.');   
                    }
                    lead.Status='Closed';
                    lead.SubStatus__c='Customer not interested';
                }
                else if(outcome == 'Call Back')
                {
                    if(listOfTask.size()< 1){
                        throw new leadException('Please call the client One time before creating a Call back task.');   
                    }
                }
            }
            
            //Owner Check
            if(lead1.recordtype.developername == 'Investment_Lead' && lead1.owner.type == 'Queue' && outcome == 'Client Interested')
            {
                throw new leadException('Please change the Owner.'); 
            }
            outcomeTask.Outcome__c = outcome;
            if(!reason.contains('None')){
                outcomeTask.Primary_outcome_reason__c = reason;
            }
            outcomeTask.WhoId = lead.Id;
            outcomeTask.Type = 'Call';
            outcomeTask.RecordTypeId = ddTaskRecordType;
            
            if (outcome == 'Call Back') {
                if (callBackTime == null) {
                    throw new leadException('Please enter a callback date');
                }
                if (String.isBlank(callBackLanguage) && lead1.recordtype.developername != 'Investment_Lead') {
                    throw new leadException('Please enter a call back language');
                }
                if (callBackTime != null && String.isNotBlank(callBackLanguage)) {
                    
                    if (System.now() > callBackTime) {
                        throw new leadException('Call back date cannot be in the past');
                    }
                    outcomeTask.Call_Back_Language__c = callBackLanguage;
                    outcomeTask.Call_Back_Date__c = callBackTime;
                    outcomeTask.Primary_outcome_reason__c = 'Call Back';
                }
            }
            
        }    
        try {
             //Added By Divya
            if(lead1.recordtype.developername == 'Investment_Lead')
            {
             	update lead;
            }
            insert outcomeTask;
        }
        catch ( Exception ex)
        {
            throw new leadException('There was an error converting the lead in AutoConvertClosedLead '
                                    + ex.getMessage() + 'Line: ' + ex.getLineNumber() + ' Cause :' +  ex.getCause() + '  type:' + ex.getTypeName(), ex);
        }
        
        return outcomeTask.Id;
    }
    
    /** @description getSitRecordType
     * @param leadId
     * @return String
     **/
    @AuraEnabled
    public static String getSitRecordType(String leadId){
        Lead lead = [SELECT Id,recordtype.developername,Name FROM Lead WHERE Id =: leadId LIMIT 1];
        String RecType=lead.recordtype.developername;
        return RecType;
    }
}