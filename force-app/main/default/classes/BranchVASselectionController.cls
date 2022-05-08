/**
 * @description       : BranchVASselectionController
 * @author            : Jabulani Mashia
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-23   André Pietersen (IQ Business)   Initial Version
 * 1.0   2021-08-04   André Pietersen (IQ Business)   Marketing consent fix
 * 1.0   2021-08-05   PaulJohn.duRand@absa.africa     Update VAS Indicators
**/

public without sharing class BranchVASselectionController
{
    /**
     * @description get credit consent labels
     * @return Map<String, String>
     */
    @AuraEnabled
    public static Map<String, String> getCreditConsent(){
        Map<String, String> options = new Map<String, String>();
        //get makertingconsent Industry Field Describe
        Schema.DescribeFieldResult fieldResult = Contact.Credit_Marketing_Indicator__c.getDescribe();
        //get  makertingconsent Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

    /**
     * @description get non credit consent labels
     * @return Map<String, String>
     */
    @AuraEnabled
    public static Map<String, String> getNonCreditConsent(){
        Map<String, String> options = new Map<String, String>();
        //get Account makertingconsent Field Describe
        Schema.DescribeFieldResult fieldResult = Contact.Non_Credit_Marketing_Indicator__c.getDescribe();
        //get Account makertingconsent Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }

    /**
     * @description get contact details from account
     * @return string
     * @param recordId
     */
    @AuraEnabled
    public static string getContactDetails(string recordId){
        try {
            Account acc = [SELECT PersonEmail, PersonMobilePhone, PersonOtherPhone, Phone, Active_Email__c, Employer_Phone__c, RecordType.Name
                FROM Account WHERE Id =: recordId WITH SECURITY_ENFORCED];

            string email = '';
            string phone = '';
            string alternativeNumber = '';
            if (acc.RecordType.Name == 'Business Prospect') {
                email = acc.Active_Email__c;
                phone = acc.Phone;
                alternativeNumber = acc.Employer_Phone__c;
            } else {
                email = acc.PersonEmail;
                phone = acc.PersonMobilePhone;
                alternativeNumber = acc.PersonOtherPhone;
            }

            ContactDetails contactDetails = new ContactDetails();
            contactDetails.email = email;
            contactDetails.cellphone = phone;
            contactDetails.alternativeNumber = alternativeNumber;
            return JSON.serialize(contactDetails);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description update contact details to account
     * @return string
     * @param contactObj
     */
    @AuraEnabled
    public static string updateContactDetails(string contactObj){
        try {
            String response = '';
            ContactDetails contactDetails = (ContactDetails)JSON.deserialize(contactObj, ContactDetails.class);

            Account acc = [SELECT PersonEmail, PersonMobilePhone, PersonOtherPhone, Phone, Active_Email__c, Employer_Phone__c, RecordType.Name
                FROM Account WHERE Id =: contactDetails.recordId WITH SECURITY_ENFORCED];

            Boolean isIndividualClient = (acc.RecordType.Name != 'Business Prospect');
            if (isIndividualClient) {
                acc.PersonEmail = contactDetails.email;
                acc.PersonMobilePhone = contactDetails.cellphone;
                acc.PersonOtherPhone = contactDetails.alternativeNumber;
            } else {
                acc.Active_Email__c = contactDetails.email;
                acc.Phone = contactDetails.cellphone;
                acc.Employer_Phone__c = contactDetails.alternativeNumber;
            }
            update acc;
            return 'Success';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private class ContactDetails {
        string recordId;
        string email;
        string cellphone;
        string alternativeNumber;
    }

    /**
     * @description update marketing consent indicators
     * @return string
     * @param marConObj
     */
    @AuraEnabled
    public static string updateMarketConsent(String marConObj) {
        String result = '';
        MarketingConsentObject mco = (MarketingConsentObject)JSON.deserialize(marConObj, MarketingConsentObject.class);
        Account acc = [SELECT Id, RecordType.Name
                FROM Account WHERE Id =: mco.recordId WITH SECURITY_ENFORCED];

        if (acc.RecordType.Name == 'Business Prospect') {
            //TODO: Business Prospects do not have contact related objects and needs to save marketing consent else where
            return 'Success';
        }

        Contact contact = [select Credit_Marketing_Consent__c, Credit_Marketing_Indicator__c, Non_Credit_Marketing_Consent__c, Non_Credit_Marketing_Indicator__c from Contact where AccountId = :acc.Id WITH SECURITY_ENFORCED];

        //Marketing Consent
        if (mco.yesNoProductGroup == 'yes') {
            contact.Non_Credit_Marketing_Consent__c = 'Yes';
            contact.Non_Credit_Marketing_Indicator__c = 'Email;SMS;Voice Recording';
        } else if (mco.answerFirstQuestion != null) {
            contact.Non_Credit_Marketing_Consent__c = 'Yes';
            contact.Non_Credit_Marketing_Indicator__c = null;
            for (String selection : mco.answerFirstQuestion) {
                switch on selection {
                    when 'Email' {
                        if (contact.Non_Credit_Marketing_Indicator__c == null) {
                            contact.Non_Credit_Marketing_Indicator__c = 'Email';
                        } else {
                            contact.Non_Credit_Marketing_Indicator__c = contact.Non_Credit_Marketing_Indicator__c + ';Email';
                        }
                    }
                    when 'SMS' {
                        if (contact.Non_Credit_Marketing_Indicator__c == null) {
                            contact.Non_Credit_Marketing_Indicator__c = 'SMS';
                        } else {
                            contact.Non_Credit_Marketing_Indicator__c = contact.Non_Credit_Marketing_Indicator__c + ';SMS';
                        }
                    }
                    when 'Voice Recording' {
                        if (contact.Non_Credit_Marketing_Indicator__c == null) {
                            contact.Non_Credit_Marketing_Indicator__c = 'Voice Recording';
                        } else {
                            contact.Non_Credit_Marketing_Indicator__c = contact.Non_Credit_Marketing_Indicator__c + ';Voice Recording';
                        }
                    }
                    when 'No thanks' {
                        contact.Non_Credit_Marketing_Consent__c = 'No';
                        contact.Non_Credit_Marketing_Indicator__c = 'No thanks';
                    }
                    when else {
                        break;
                    }
                }
            }
        } else {
            contact.Non_Credit_Marketing_Consent__c = 'No';
            contact.Non_Credit_Marketing_Indicator__c = null;
        }

        if (mco.yesNoCreditGroup == 'yes') {
            contact.Credit_Marketing_Consent__c = 'Yes';
       		if (mco.answerSecondQuestion != null) {
                contact.Credit_Marketing_Consent__c = 'Yes';
                contact.Credit_Marketing_Indicator__c = null;
                for (String selection : mco.answerSecondQuestion) {
                    switch on selection {
                        when 'Email' {
                            if (contact.Credit_Marketing_Indicator__c == null) {
                                contact.Credit_Marketing_Indicator__c = 'Email';
                            } else {
                                contact.Credit_Marketing_Indicator__c = contact.Credit_Marketing_Indicator__c + ';Email';
                            }
                        }
                        when 'SMS' {
                            if (contact.Credit_Marketing_Indicator__c == null) {
                                contact.Credit_Marketing_Indicator__c = 'SMS';
                            } else {
                                contact.Credit_Marketing_Indicator__c = contact.Credit_Marketing_Indicator__c + ';SMS';
                            }
                        }
                        when 'Telephone' {
                            if (contact.Credit_Marketing_Indicator__c == null) {
                                contact.Credit_Marketing_Indicator__c = 'Telephone';
                            } else {
                                contact.Credit_Marketing_Indicator__c = contact.Credit_Marketing_Indicator__c + ';Telephone';
                            }
                        }
                        when else {
                            break;
                        }
                    }
                }
            }
        } else {
            contact.Credit_Marketing_Consent__c = 'No';
            contact.Credit_Marketing_Indicator__c = null;
        }

        //VAS fulfillments
        Application__c app = [SELECT Id, Internet_Banking__c, Notifyme__c, Absa_Reward__c, Electronic_Statements__c
            FROM Application__c WHERE Opportunity__c =: mco.oppId WITH SECURITY_ENFORCED];

        if (mco.digitalBankingInd != null) {
            if (mco.digitalBankingInd == 'Y') {
                app.Internet_Banking__c = true;
            }
        }
        if (mco.notifyMeInd != null) {
            if (mco.notifyMeInd == 'Y') {
                app.Notifyme__c = 'Yes';
            } else {
                app.Notifyme__c = 'No';
            }
        }
        if (mco.rewardsInd != null) {
            if (mco.rewardsInd == 'Y') {
                app.Absa_Reward__c = true;
            }
        }
        if (mco.eStatementInd != null) {
            if (mco.eStatementInd == 'Y') {
                app.Electronic_Statements__c = true;
            }
        }
        try {
            update contact;
            update app;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return 'Success';
    }

    /**
     * @description update CIF details
     * @return string
     * @param recordId
     * @param oppId
     */
    @AuraEnabled
    public static string updateCIFRecord(string recordId,string oppId) {
        try {
            String response;
            Account acc = [SELECT Id, CIF__c, RecordType.Name FROM Account WHERE Id =: recordId WITH SECURITY_ENFORCED];
            if (acc.RecordType.Name != 'Business Prospect') {
                response = CVSServicesHelper.updateCIF(acc.Id, acc.CIF__c,oppId);
            } else {
                //TODO: call S&I specific CIF update
                response = 'Success';
            }
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private class MarketingConsentObject {
        public String oppId;
        public String recordId;
        public String digitalBankingInd;
        public String notifyMeInd;
        public String eStatementInd;
        public String rewardsInd;
        public String yesNoProductGroup;
        public String yesNoCreditGroup;
        public String[] answerFirstQuestion;
        public String[] answerSecondQuestion;
    }
}