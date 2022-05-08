/**
* Test Class Name: SMSHandlerTest
* @descripton: SMSHandler
* @Author:  
* @CreateDate: 
* CHANGE LOG:
**/
/**
 * @description  Testing SMSHandler functionality
 */
public class SMSHandler {
	/**
	* Class to manage SMS communications
	* @author Vladimir Panajic
	* @created 2019-02-22
	*/
    
    /**
    * Does the Quick Text template merge and then sends the SMS using a service provider, i.e iTouch etc...
    *
	* @param whoId - Optional. Identifies an object in the database, restricted by the SFDC platform to Contact, Lead or User. The database record for that object is read and used in merge field processing
    * @param whatId - Optional. Identifies an object in the database like an Account, Case or Opportunity. The record for that object is read and used in merge field processing
    * @param phoneNumberOverride - Optional. If supplied then SMS is sent to this mobile number, otherwise SMS is sent to the default phoneNumber of the whoId
    * @param recipientNameOverride - Optional. If supplied then it is part of the Task Subject, otherwise it is set to the name of the whoId
    * @param quickTextName - Required. Quick Text template name representing the SMS text (including the merge fields)
    * @param integrationService - Required. Indicates the integration service to be used, it is defined for a business unit
    * @param saveAsActivity - Required. Indicates if the SMS Task activity is to be created, and in turn related to the whoId and the whatId
    * @description
    * @return reference
    */
    public static string sendSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
        String reference = '';
        String phoneNumber = phoneNumberOverride;
        String recipientName = recipientNameOverride;
        //If phoneNumberOverride is supplied it should be used, otherwise get the default phoneNumber of the whoId
        //'003' is Contact
        //'00Q' is Lead
        //'005' is User
        if (phoneNumberOverride == '') {
            if (String.valueOf(whoId).substring(0, 3) == '003') {
                Contact contact = new ContactsSelector().selectByPersonId(whoId, 1);
                phoneNumber = contact.MobilePhone;
            } else if (String.valueOf(whoId).substring(0, 3) == '00Q') {
                Set<Id> idSet = new Set<Id>();
                idSet.add(whoId);
                List<Lead> leadsList = new LeadsSelector().selectById(idSet);
                if (!leadsList.isEmpty()) {
                    phoneNumber = leadsList.get(0).MobilePhone;
                }
            } else if (String.valueOf(whoId).substring(0, 3) == '005') {
                User user = new UsersSelector().selectById(whoId);
                phoneNumber = user.MobilePhone;
            }
        }
        
        //Verify User's mobile number format is compatible with iTouch format. Salesforce User's mobile number format is '+27 0600000000' 
        if (phoneNumber.substring(0, 4) == '+27 ') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(5, 14);
        }
        
        
        //'+270600000000' format is not supported by iTouch, so remove 0
        if (phoneNumber.substring(0, 4) == '+270') {
            phoneNumber = phoneNumber.substring(0, 3) + phoneNumber.substring(4, 13);
        }
        
        //Get the recipientName to be used in tsk.Subject
        //'003' is Contact
        //'00Q' is Lead
        //'005' is User
        if (whoId != null) {
            if (String.valueOf(whoId).substring(0, 3) == '003') {
            Contact contact = new ContactsSelector().selectByPersonId(whoId, 1);
            recipientName = contact.Name;
            } else if (String.valueOf(whoId).substring(0, 3) == '00Q') {
                Set<Id> idSet = new Set<Id>();
                idSet.add(whoId);
                List<Lead> leadsList = new LeadsSelector().selectById(idSet);
                if (!leadsList.isEmpty()) {
                    recipientName = leadsList.get(0).Name;
                }
            } else if (String.valueOf(whoId).substring(0, 3) == '005') {
                User user = new UsersSelector().selectById(whoId);
                recipientName = user.Name;
            }
        }
        
        //Get plain text SMS body
        String mergedBody = getPlainTextSMSBody(whoId, whatId, quickTextName);
        //Send sms
        Integer statusCode;
        if (mergedBody != null) {
            SMSGateway_Resp_IB_v1 bean = dispatchSMS(phoneNumber, mergedBody, integrationService);
            statusCode = bean.statusCode;
            if (bean.statusCode == 200) {
                reference = bean.MessageReference;
            }
        }
        
        //Create SMS task. Only Contact (003) and Lead (00Q) can be whoId for a Task
        if (saveAsActivity && statusCode == 200) {
            Id taskWhoId = null;
            if (whoId != null) {
                if (String.valueOf(whoId).substring(0, 3) == '003' || String.valueOf(whoId).substring(0, 3) == '00Q') {
                	taskWhoId = whoId;
            	}	
            }
            createTask(recipientName, phoneNumber, taskWhoId, whatId, UserInfo.getUserId(), mergedBody, reference);
        }
        
        return reference;
    }
    
    /**
    * Does the Quick Text merge
    *
	* @param whoId - The ID of the Contact, Lead, or User the SMS is related to
	* @param whatId - The ID of the object that the Task is related to, i.e. Opportunity, Case etc... 
	* @param quickTextName - Quick Text template name
	* @description
    * @return mergedBody
    */
    @TestVisible private static String getPlainTextSMSBody(Id whoId, Id whatId, String quickTextName) {
        //An array of strings that are examined for merge field references. The corresponding data from the object referenced by the whoId or whatId replaces the merge field reference
        String mergedBody;
        try {
        	String quickTextMessage = [select Message from QuickText where Name =: quickTextName].Message;
        	List<Messaging.RenderEmailTemplateBodyResult> renderResults = Messaging.renderEmailTemplate(whoId, whatId, new List<String>{quickTextMessage});
        	mergedBody = renderResults[0].getMergedBody();
        } catch(Exception e) {
        	//System.debug('An unexpected error has occurred: ' + e.getMessage());
            AuditTrailLog.logException(e,  'New', 'Error', 'SMSHandler', 'getPlainTextSMSBody', 'Error in getting the Email template body');
        }
        return mergedBody;
    }
    
    /**
    * Creates the Task (of SMS type)
    *
	* @param recipientName
	* @param phoneNumber
	* @param taskWhoId
	* @param whatId
	* @param ownerId
    * @param messageText
    * @param messageReference
    * @description
    * 
    */
    @TestVisible private static void createTask(String recipientName, String phoneNumber, Id taskWhoId, Id whatId, Id ownerId, String messageText, String messageReference) {
        string strTaskWhoId = taskWhoId;
        Task tsk = new Task();
        tsk.Subject = recipientName + ' ' + phoneNumber; 
        tsk.Message_Reference__c = messageReference;
      //  if (strTaskWhoId != null && strTaskWhoId.startsWith('00Q') == false) // task can not have whatid, for lead as who id
      // 	 tsk.WhatId = whatId;
        if (taskWhoId != null ) {
            tsk.WhoId = taskWhoId;
        }
        //Ashok - added below to link the task if WhatId (Case) is passed.
        if(whatId != null){
            tsk.whatId = whatId;
        }
        tsk.OwnerId = ownerId;
        tsk.Description = messageText;
        tsk.status = 'Completed';
        tsk.RecordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
        try {
        	insert tsk;
            //system.debug('tsk: ' + tsk);
        } catch (DmlException e) {
			//System.debug('An unexpected error has occurred: ' + e.getMessage());
            AuditTrailLog.logException(e,  'New', 'Error', 'SMSHandler', 'getPlainTextSMSBody', 'Error in getting the Email template body');
        }
    }
    
    /**
    * Sends the SMS calling the SMS by calling the SMS gateway, i.e. iTouch etc...
    *
	* @param phoneNumber - SMS is sent to this mobile number
	* @param messageText - This is the text of the SMS 
    * @param integrationService - Indicates the integration service to be used, it is defined for a business unit
    * @return bean - SMSGateway_Resp_IB_v1
    * @description
    */
    
    @TestVisible private static SMSGateway_Resp_IB_v1 dispatchSMS(String phoneNumber, String messageText, String integrationService) {
        SMSGateway_Resp_IB_v1 bean = SMSGateway_IH_v1.submit(phoneNumber, messageText, integrationService);
        return bean;
    }
}