/**
* @description MVP2_NoContactNoticeController
*/
public class MVP2_NoContactNoticeController {
    
    /**
* @description sendNoConnectSms method is created to call from process builder
* @param ListOflead   list of leads for start
**/
    @InvocableMethod 
    public static void sendNoConnectSms(List<Id> ListOflead) {
        //sendNoConnectEmailToLead(ListOflead[0]);
        dispatchSMS(ListOflead[0]);
    }
    
    /**
* @description  dispatchSMS method is created to get and build SMS Body
* @param leadRecordID   current lead id to send sms
**/    
    Public static void dispatchSMS(Id leadRecordID){
        Lead leadObj=new LeadsSelector().selectLeadById(leadRecordId);
        String whoId=leadRecordID;
        String WhatId=leadObj.Parent_Account__c;
        String quickTextName='MVP2_NoContactSMS';
        String IntegrationService='iTouch SMS Submit - VA';
        Boolean saveAsActivity=true;
        String recipientNameOverride=leadObj.Owner.Name;
        String phoneNumberOverride=leadObj.MobilePhone;  
        
        sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
        String mergedBody = getPlainTextSMSBody(whoId, whatId, quickTextName,recipientNameOverride);
        String reference = '';
        String phoneNumber = phoneNumberOverride.split('-')[0];
        if(phoneNumber.length()==9){
            phoneNumber= '+27'+ phoneNumber;
        }
        else{
            phoneNumber= '+27'+phoneNumber;
        }
        if (phoneNumber.substring(0, 4) == '+27 ') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
        } 
        if (phoneNumber.substring(0, 4) == '+270') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(4, 13);
        } 
        createTask(recipientNameOverride, phoneNumber, whoId, whatId, UserInfo.getUserId(), mergedBody, reference);
    }   
    
    
    /**
* @description  sendSMS method is created to call I-Tuch And send SMS
* @param whoId   relatead name id of lead  
* @param whatId  related to id of lead
* @param phoneNumberOverride    recipient phone number
* @param recipientNameOverride   recipient name of client
* @param quickTextName  quicktext massage of lead
* @param integrationService  integration service for sms
* @param saveAsActivity  Save as activity once sms is send
*  
*/  
    @future (callout=true)
    public static void sendSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
        String reference = '';
        String phoneNumber = phoneNumberOverride.split('-')[0];
        if(phoneNumber.length()==9){
            phoneNumber= '+27'+ phoneNumber;
        }
        else{
            phoneNumber= '+27'+phoneNumber;
        }
        String recipientName = recipientNameOverride;
        //Verify User's mobile number format is compatible with iTouch format. Salesforce User's mobile number format is '+27 0600000000' 
        if (phoneNumber.substring(0, 4) == '+27 ') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
        } 
        
        //'+270600000000' format is not supported by iTouch, so remove 0
        if (phoneNumber.substring(0, 4) == '+270') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(4, 13);
        }
        //Get plain text SMS body
        String mergedBody = getPlainTextSMSBody(whoId, whatId, quickTextName,recipientName);
        
        //Send sms
        Integer statusCode;
        
        if (mergedBody != null) {
            SMSGateway_Resp_IB_v1 bean = dispatchSMS(phoneNumber, mergedBody, integrationService);
            statusCode = bean.statusCode;
            if (bean.statusCode == 200) {
                reference = bean.MessageReference;
            }
        } 
        
        
    }
    
    /**
* @description  sendSMS method build SMS body
* @param whoId   name id of lead
* @param whatId    related to id of lead
* @param quickTextName	quick text message 
* @param recipientName   receipent name of client
* @return string
**/  
    public static String getPlainTextSMSBody(Id whoId, Id whatId, String quickTextName,String recipientName) {
        //An array of strings that are examined for merge field references. The corresponding data from the object referenced by the whoId or whatId replaces the merge field reference
        String mergedBody;
        try {
            String quickTextMessage = [select Message from QuickText where Name =: quickTextName].Message;
            quickTextMessage=quickTextMessage.replace('#', recipientName);
            List<Messaging.RenderEmailTemplateBodyResult> renderResults = Messaging.renderEmailTemplate(whoId, whatId, new List<String>{quickTextMessage});
            mergedBody = renderResults[0].getMergedBody();
        } catch(Exception e) {
           String ex = e.getMessage();
        }
        return mergedBody;
    }
    
    
    /**
* @description  dispatchSMS method is created to call I-Tuch ,send SMS and read responce
* @param phoneNumber   phone number of client
* @param messageText   quick text message for sms
* @param integrationService   service for sms
* @return responce 
**/ 
    public static SMSGateway_Resp_IB_v1 dispatchSMS(String phoneNumber, String messageText, String integrationService) {
        SMSGateway_Resp_IB_v1 bean;
        if(!Test.isRunningTest()){
            bean = SMSGateway_IH_v1.submit(phoneNumber, messageText, integrationService);
        }
        return bean;
    }
    
    /**
* @description  createTask method is created to create task once sms is sent
* @param recipientName name of cliet
* @param phoneNumber  phone number of client
* @param taskWhoId   name id of lead
* @param whatId    related to id of lead
* @param ownerId   owner of lead 
* @param messageText   massage of sms
* @param messageReference   massage reference
*/ 
    @TestVisible private static void createTask(String recipientName, String phoneNumber, Id taskWhoId, Id whatId, Id ownerId, String messageText, String messageReference) {
        Task tsk = new Task();
        tsk.Subject = recipientName + ' ' + phoneNumber;
        tsk.Message_Reference__c = messageReference;
        if (taskWhoId != null) {
            tsk.WhoId = taskWhoId;
        }
        tsk.OwnerId = ownerId;
        tsk.ActivityDate=date.today();
        tsk.Description = messageText;
        tsk.status = 'Completed';
        tsk.RecordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
        try {
            insert tsk;
        } catch (DmlException e) {
            String ex = e.getMessage();
        }
    }
    
    
    /*  public static void sendNoConnectEmailToLead(String leadRecordId){

List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();       
list<EmailTemplate> em = new list<EmailTemplate>();

em = [SELECT Id,Subject,Body,HtmlValue From EmailTemplate where Name ='MVP2 - No Contact Notification' limit 1];

Lead leadObj=new LeadsSelector().selectLeadById(leadRecordId);

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
String toadress = leadObj.Email;
system.debug('Email id To Address--->'+toadress);

List<String> sendTo = new List<String>();
sendTo.add(toadress);
mail.setToAddresses(sendTo); 
mail.setTargetObjectId(leadObj.id);

if(leadObj.Parent_Account__c != Null){
mail.setWhatId(leadObj.Parent_Account__c);
}
else{            
mail.setWhatId(leadObj.Parent_Account__c);
}

mail.setTreatTargetObjectAsRecipient(false);
mail.setSaveAsActivity(true);
mail.setTemplateId(em.get(0).id);      
mails.add(mail);

system.debug('Email--->'+mail);
system.debug('Size--->'+mails.size());
Messaging.sendEmail(mails);

}  */
    
    /**
* @description  Method will call ecm upload api and uplode doc on ecm
* @param docId   document id of leadrecord
*/ 
    @auraEnabled
    public static void getUplodeEcm(String docId){
        
        List<ContentDocumentLink> listOfContentDocList=New List<ContentDocumentLink>();
        listOfContentDocList=[SELECT ContentDocument.Id, LinkedEntityId FROM ContentDocumentLink where ContentDocument.Id=:docId];
        
        String parentQuoteId;  
        String parentOppId; 
        for(ContentDocumentLink cl:listOfContentDocList){
            String objName=cl.LinkedEntityId.getSObjectType().getDescribe().getName();
            if(objName == 'Quote'){
                parentQuoteId=cl.LinkedEntityId;
            } 
            else if(objName == 'Opportunity'){
                parentOppId=cl.LinkedEntityId;
            }
        }
        list<ContentVersion> listofCV=[SELECT id,title,ContentDocumentId,VersionData,FileType,FileExtension,Description  from ContentVersion where ContentDocumentId=:docId];
        if(parentQuoteId !=null){
            Quote objQuote=[select id,RecordType.developerName,OpportunityId from Quote where id=:parentQuoteId limit 1];
            Opportunity opp=[select id,Accountid,ownerId from Opportunity where id =:objQuote.OpportunityId LIMIT 1];            
            if(objQuote.RecordType.developerName == 'STI_Quote'){
                String Filename=listofCV[0].title;
                Blob data=listofCV[0].VersionData;
                String parentId=opp.Id;
                String accID=opp.AccountId;
                String usrId=opp.OwnerId;   
                if(!Test.isRunningTest()){
                    MVP2_DocumentUploadECM.uploadtoECM(Filename,data,parentId,accID,usrId);
                }
            }
        }
        if(parentOppId != null){
            Opportunity Opp=[select id,RecordType.developerName,Accountid,ownerId from Opportunity where id =:parentOppId limit 1]; 
            if(Opp.RecordType.developerName == 'STI' || Opp.RecordType.developerName == 'Investment_Opportunity'){

                String FileType = listofCV[0].title +'.'+ listofCV[0].FileExtension +'#@#'+listofCV[0].Description;
                String Filename = Opp.RecordType.developerName == 'Investment_Opportunity'?FileType:listofCV[0].title;
                Blob data=listofCV[0].VersionData;
                String parentId=opp.Id;
                String accID=opp.AccountId;
                String usrId=opp.OwnerId; 
                if(!Test.isRunningTest()){
                    MVP2_DocumentUploadECM.uploadtoECM(Filename,data,parentId,accID,usrId);
                }
            }
        }
        
    }
}