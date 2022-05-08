/**
 * @description       : SendSMS Server Side Controller Class
 * @author            : Ignecious Mushanguri
 * @group             : Cloudsmiths
 * @last modified on  : 11-23-2020
 * Modifications Log 
 * Ver   Date         Author                        Modification
 * 1.0   11-17-2020   Ignecious Mushanguri        Initial Version
**/
public with sharing class SendSMSController {

    public static final String ITOUCH_SMS_SUBMIT = StringConstants.ITOUCH_SUBMIT_CC;
    /**
    * @description Method to retrieve the account and phone number linked to case 
    * @author Ignecious Mushanguri | 11-17-2020 
    * @param caseId 
    * @return List<String> 
    **/
    @AuraEnabled
    public static List<String> getLinkedAccount(Id caseId){

        System.debug(LoggingLevel.DEBUG,'SendSMSController.getLinkedAccount.......');

        System.debug(LoggingLevel.DEBUG,'Case Id:'+caseId);

        List<String> relatedInfo = new List<String>();

        try { 

            String linkedAccId = new CasesSelector().selectByIdWithAccountInfo( new set<Id> {caseId}, 1).get(0).AccountId;
            String mobileNumber = '';
  
           if(String.isNotBlank(linkedAccId)){
             
            Id accId = linkedAccId;

            mobileNumber = new AccountsSelector().selectById( new set<Id> {accId}).get(0).PersonMobilePhone;
           }
            
           relatedInfo.add(linkedAccId);
           relatedInfo.add(mobileNumber);  

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,'Exception' + e.getMessage());
            throw new AuraHandledException('No Account Linked to Case, Please add link an account to this case' +e.getMessage());
        }
        
        return relatedInfo;
    }

    /**
    * @description Method to get the quickTextTemplates
    * @author Ignecious Mushanguri | 11-17-2020 
    * @param folderName 
    * @return List<QuickText> 
    **/
    @AuraEnabled
    public static List<QuickText> getQuickTextTemplates(String folderName){

        System.debug(LoggingLevel.DEBUG,'SendSMSController.getQuickTextTemplates.......');

        System.debug(LoggingLevel.DEBUG,'Folder Name:'+folderName);

        try {
            return[select Name , Message from QuickText where Folder.Name = :folderName];
        } 
        
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Method that calls the SMSHandler to Send sms
    * @author Ignecious Mushanguri | 11-20-2020 
    * @param caseId 
    * @param phoneNumber 
    * @param quickTextName 
    **/
    @Future(callout=true)
    @AuraEnabled
    @TestVisible
    public static void sendSMSQuickAction(Id caseId, String phoneNumber , String quickTextName ){

        System.debug(LoggingLevel.DEBUG,'SendSMSController.sendSMSQuickAction method.......');

        String messageReference = '';

        messageReference = SMSHandler.sendSMS(null, caseId, phoneNumber,null, quickTextName, ITOUCH_SMS_SUBMIT, false);

        if(String.isBlank(messageReference) && !Test.isRunningTest()){

            System.debug(LoggingLevel.ERROR, 'Error: MessageReference returned from SMSGateway_Resp_IB_v1 is null');
            throw new AuraHandledException('Invalid Phone Number');
        }
        System.debug(LoggingLevel.DEBUG,'MessageReference returned from SMSGateway_Resp_IB_v1:' +messageReference);                     
    }
}