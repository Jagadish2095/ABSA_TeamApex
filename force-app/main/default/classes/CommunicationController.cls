/**
* This is Communication Lightning component Apex Controller Class
*
* @author Lulu Rankwe & Makgotso Lebajoa(Absa)
* @since 2019/02/13
*/ 
public class CommunicationController {
    
    /**
    * Retrieves an application record based on the opportunity Id
    *
    * @param   opportunityId  The opportunity Id
    * @return  application The application record getApplicationByOpportunityId
    */    
    @AuraEnabled
    public static Application__c getApplicationByOpportunityId (Id opportunityId) {
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        Application__c application;
        if (!applicationsList.isEmpty())
        	application = applicationsList.get(0);
        return application;
    }
    
   	/**
    * Checks whether a communication preference has been set
    *
    * @param    opportunityId  The opportunity Id
    * @return   boolean     Whether a communication preference has been set (true/false)
    */
    @AuraEnabled
    public static boolean checkCommunicationPreferenceSet(Id opportunityId) {        
        List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        Boolean communicationPreferenceSet = false;
        if (!applicationsList.isEmpty()) {
            Application__c application = applicationsList.get(0);
            if (application.Preferred_Email__c != null || application.Preferred_SMS__c != null) {
                communicationPreferenceSet = true;
            }
        }
        return communicationPreferenceSet;
    }
    
    /**
    * Returns the communication preference type that has been set
    *
    * @param   opportunityId  The opportunity Id
    * @return   String      The communication preference type that has been set
    */ 
    @AuraEnabled
    public static String checkCommunicationPreferenceSetType(Id opportunityId) {   
        List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        String communicationPreferenceSetType;        
        if (!applicationsList.isEmpty()) {
            Application__c application = applicationsList.get(0);            
            if (application.Preferred_Email__c != null) {
                communicationPreferenceSetType = 'Email';
            } 
            else if (application.Preferred_SMS__c != null) {
                communicationPreferenceSetType = 'SMS';
            }
        }        
        return communicationPreferenceSetType; 
    } 
 
   	/**
    * Retrieves the associated client's emails as well as previously entered preferred communication email
    *
    * @param    opportunityId  The opportunity Id
    * @return  List<String>    A list of emails
    */
    @AuraEnabled
    public static List<String> getEmailsList(Id opportunityId) {
		List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
	   	List<Account> accountsList = new AccountsSelector().selectEmailFieldsById(new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0).AccountId, 1);
        List<String> emailsList = new List<String>();
        sET<String> emailsSet = new Set<String>();
        if (!accountsList.isEmpty()) {
            if(accountsList.get(0).Client_Type__c == 'Joint & Several'){
                List<Contact> contactList = new AccountContactRelationSelector().selectContactListByAccId(accountsList.get(0).Id);
                for(Contact accContact:contactList){
                    emailsSet.add(accContact.Email);
                }               
            }
            emailsSet.add(accountsList.get(0).PersonEmail);
            emailsSet.add(accountsList.get(0).Active_Email__c);
            if (!applicationsList.isEmpty()) {
                if (applicationsList.get(0).Preferred_Email__c != null && applicationsList.get(0).Preferred_Email__c != accountsList.get(0).PersonEmail) {
                    emailsSet.add(applicationsList.get(0).Preferred_Email__c);
                }
            }
        }
        for(String email : emailsSet){
            emailsList.add(email);
        }
        return emailsList;
  	}  
    
    /**
    * Retrieves the associated client's phones as well as previously entered preferred communication phone
    *
    * @param   opportunityId  The opportunity Id
    * @return  List<String>    A list of phones
    */   
    @AuraEnabled
    public static List<String> getPhonesList(Id opportunityId) {       	
		List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
	    List<Account> accountsList = new AccountsSelector().selectPhoneFieldsById(new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0).AccountId, 1);
        List<String> phonesList  = new List<String>();
        sET<String> phonesSet = new Set<String>();
        if (!accountsList.isEmpty()) {
            if(accountsList.get(0).Client_Type__c == 'Joint & Several'){
                List<Contact> contactList = new AccountContactRelationSelector().selectContactListByAccId(accountsList.get(0).Id);
                for(Contact accContact:contactList){
                    phonesSet.add(accContact.MobilePhone);
                }               
            }
            phonesSet.add(accountsList.get(0).PersonMobilePhone);
            if (applicationsList.get(0).Preferred_SMS__c != null && applicationsList.get(0).Preferred_SMS__c != accountsList.get(0).PersonMobilePhone) {
                phonesList.add(applicationsList.get(0).Preferred_SMS__c);
            }
        }
        for(String phone : phonesSet){
            phonesList.add(phone);
        }
        return phonesList;
  	}        

    /**
    * Updates the application record with the communication preference
    *
    * @param    opportunityId                   The opportunity Id
    * @param    communicationPreferenceType     The communication preference type
    * @param    value                           The value for the communication preference type
    */ 
    @AuraEnabled
    public static void updateApplication(Id opportunityId, String communicationPreferenceType, String value) {
        List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);        
        if (!applicationsList.isEmpty()) {            
            Application__c application = applicationsList.get(0);
            switch on communicationPreferenceType {
                when 'Email'{
                    application.Preferred_Email__c = value;
                    application.Preferred_SMS__c = null;
                    application.Preferred_Communication_Method__c = 'Email';
                } 
                when 'SMS' {
                    application.Preferred_SMS__c = value;
                    application.Preferred_Email__c = null;
                    application.Preferred_Communication_Method__c = 'SMS';
                }
            }
            try {
                //Set communication preference status
                application.Communication_Preference_Status__c = 'Valid';
                update application;
            } 
            catch(DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }
    
    /**
    * Validate email adrresses 
    *
    * @param opportunityId The opportunity Id
    */
    @AuraEnabled
    public static Map<String, String> validEmailPhone(Id opportunityId) {
        List<Application__c>  applicationsList = new ApplicationsSelector().selectByOpportunityId(opportunityId);
        List<Account> accountsList = new AccountsSelector().selectEmailFieldsById(new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0).AccountId, 1);
        Map<String, String> validEmailMap = new Map<String, String> ();
        String hasValidEmail = 'false';
        String hasValidPhone = 'false';
        validEmailMap.put('ClientType',accountsList.get(0).Client_Type__c);
        if (!accountsList.isEmpty()) {
            if(accountsList.get(0).Client_Type__c == 'Joint & Several'){
                List<Contact> contactList = new AccountContactRelationSelector().selectContactListByAccId(accountsList.get(0).Id);
                for(Contact accContact:contactList){
                    if(accContact.Email != null){
                        hasValidEmail = 'true';
                    }
                    if(accContact.MobilePhone != null){
                        hasValidPhone = 'true';
                    }
                }               
            } else {
                if(accountsList.get(0).PersonEmail != null){
                    hasValidEmail = 'true';
                    }
                if(accountsList.get(0).PersonMobilePhone != null){
                    hasValidPhone = 'true';
                    }
            }
            validEmailMap.put('hasValidEmail',hasValidEmail);
            validEmailMap.put('hasValidPhone',hasValidPhone);
        }
        return validEmailMap;
    }
}