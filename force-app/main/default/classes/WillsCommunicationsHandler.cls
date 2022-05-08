/**
* Class to manage SMS communications for Wills
*
* @author Vladimir Panajic
* @created 2019-03-01
* @Updated Himanshu Nimje (Mphatek)
* @Updated on 2019-04-25
*/
public class WillsCommunicationsHandler {
    /**
    * Sends the SMS and Email communication to the client, adviser on Will registration confirmation
    *
    * @param opportunityId
    * 
    */
    public static void sendWillRegisteredCommunication(Id opportunityId) {
        String targetObjectId;
        List<Opportunity> opportunitiesList = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
        if (!opportunitiesList.isEmpty()) {
            Set<Id> idSet = new Set<Id>();
            idSet.add(opportunitiesList.get(0).AccountId);
            List<Account> accountsList = new AccountsSelector().selectById(idSet, 1);             
            if (!accountsList.isEmpty()) {
                String clientLanguage = accountsList.get(0).Communication_Language__pc;
                List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);                
                if (!applicationsList.isEmpty()) {
                    String preferredEmail = applicationsList.get(0).Preferred_Email__c;
                    //client communication, can be SMS or Email, in English or Afrikaans
                    if(accountsList.get(0).Client_Type__c == 'Joint & Several'){
                        List<Contact> contactList = new AccountContactRelationSelector().selectContactListByAccId(accountsList.get(0).Id);
                        Integer contactListNum = -1;
                        Boolean primaryContact = false;
                        for(Contact accContact : contactList){
                            contactListNum = contactListNum+1;
                            if(accContact.Email != null && !primaryContact){
                                targetObjectId = contactList.get(contactListNum).Id;
                                clientLanguage = contactList.get(contactListNum).Communication_Language__c;                          
                                if(accContact.Email == preferredEmail){
                                    primaryContact = true;                                
                                }
                            }                            
                        }
                    }
                    else{
                        targetObjectId = accountsList.get(0).PersonContactId;
                    }
                    String templateName;
                    if (applicationsList.get(0).Preferred_Communication_Method__c == 'SMS') {
                        String personMobilePhone = applicationsList.get(0).Preferred_SMS__c;
                        if (clientLanguage == 'Afrikaans') {
                            templateName = StringConstants.CLIENT_WILL_REGISTERED_SMS_AFRIKAANS;
                        } else {
                            templateName = StringConstants.CLIENT_WILL_REGISTERED_SMS_ENGLISH;
                        }
                        if (templateName != '' && templateName != null && personMobilePhone != '' && personMobilePhone != null) {
                            dispatchSMS(null, opportunityId, personMobilePhone, accountsList.get(0).Name, templateName, StringConstants.WILLS_ITOUCH_SMS_INTEGRATION_SERVICE, true);
                        }
                    } else if (applicationsList.get(0).Preferred_Communication_Method__c == 'Email') {
                        String emailAddress = applicationsList.get(0).Preferred_Email__c;
                        if (clientLanguage == 'Afrikaans') {
                            templateName = 'Client_Will_Registered_Email_Afrikaans1';
                        } else {
                            templateName = 'Client_Will_Registered_Email_English1';
                        }
                        if (templateName != '' && templateName != null && emailAddress != '' && emailAddress != null) {
                            EmailHandler.SendEmail(opportunityId, targetObjectId, emailAddress, templateName);
                        }
                    }
                    //employee object to store Adviser
                    Id advisorId = opportunitiesList.get(0).Adviser_Employee__c;
                    if(advisorId != null){
                        Employee__c adviser = new EmployeesSelector().selectById(advisorId);
                        if(adviser != null){
                            String mobilePhone=adviser.Mobile__c;                        
                            if (mobilePhone != '' && mobilePhone != null) {                    
                                dispatchSMS(null, opportunityId, mobilePhone, adviser.Name, StringConstants.ADVISER_WILL_REGISTERED_SMS_ENGLISH, StringConstants.WILLS_ITOUCH_SMS_INTEGRATION_SERVICE, true);
                            }
                        }
                    }
                }
            }
        }
    }    
    
    /**
    * Method that sends the SMS - Successful Sale to the Client
    * 
    * @param whoId - Person Contact Id
    * @param whatId - Opportunity Id
    * @param phoneNumberOverride - mobile number override
    * @param recipientNameOverride - full name override
    * @param quickTextName - Quick Text template name
    * @param integrationService - The integration service to be used, it is defined for a business unit
    * @param saveAsActivity - indicates if the Task SMS activity is to be created 
    * 
    */
    
    @Future(callout=true)
    private static void dispatchSMS(Id whoId, Id whatId, String phoneNumberOverride, String recipientNameOverride, String quickTextName, String integrationService, boolean saveAsActivity) {
    	SMSHandler.sendSMS(whoId, whatId, phoneNumberOverride, recipientNameOverride, quickTextName, integrationService, saveAsActivity);
    }
}