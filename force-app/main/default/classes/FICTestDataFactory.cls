/*Description: Test Data Factory for FIC Remediation team that can be used everyone
* NOTE: All the methods would return the data which is not inserted/saved to database
* @Author: Mohammed Junaid U
* @Created Date: 2021-08-16
* CHANGE LOG:
*=======================================================================================================
* 
*=======================================================================================================
* */
@isTest
public class FICTestDataFactory {
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-08-16 
    * @param clientType 
    * @param clientGroup 
    * @param recordId 
    * @return Account 
    **/
    public static Account getAccount(String clientType, string clientGroup, String recordId){
        Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get(recordId).getRecordTypeId();
        //testAccount.CASA_Reference_Number__c = '1712994';
        testAccount.CASA_Risk_Status__c = 'Low';
        testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccount.CASA_Screening_Status__c = 'Approved';
        testAccount.CASA_Analyst_Comments__c = '30406';
        testAccount.PersonMobilePhone = '0747003747';
       // testAccount.Country_of_Residence__c = 'South Africa';
        testAccount.Country_of_Residence__pc='South Africa';
        testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccount.PersonEmail = 'test@test.co.za';
        testAccount.FirstName = 'Tony';
        testAccount.External_Siebel_ID__c = '1-1IV9MC';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Nationality__pc = 'South Africa';
        testAccount.Occupation__pc = 'Engineer';
        testAccount.Onboarding_Channel__c = 'Test';
        testAccount.Communication_Language__pc = 'Afrikaans';
        testAccount.PersonTitle = 'Mr.';
        testAccount.Client_Type__c = clientType;
        testAccount.Client_group__c = clientGroup;
        testAccount.Phone = '0114453322';
        testAccount.Gender__pc = 'Male';
        testAccount.Initials__pc = 'T';
        testAccount.Country_of_Birth__pc = 'South Africa';
        testAccount.Marital_Status__pc = 'Married';
        testAccount.Marital_Contract_Type__pc = 'Community of Property';
        testAccount.Income_Source__pc = 'Bonus';
        testAccount.Occupation_Status__pc = 'Full Time Employed';
        testAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        testAccount.Occupation_Category__pc = 'Advertising';
        testAccount.ShippingCity = 'CAPE TOWN';
        testAccount.ShippingCountry = 'South Africa';
        testAccount.ShippingStreet = '01 PUERTA DEL SOL';
        testAccount.ShippingPostalCode = '8001';
        testAccount.BillingCity = 'GROBLERSDAL';
        testAccount.BillingCountry = 'South Africa';
        testAccount.BillingStreet = '01 MABOPANE SECTION';
        testAccount.BillingPostalCode = '1060';
        testAccount.CIF__c = 'AFIFTAP001';
        testAccount.Alternative_Email__c = 'test@test.com';
        testAccount.Alternative_Email_1__c = 'test@test.com';
        testAccount.Alternative_Email_2__c = 'test@test.com';
        testAccount.Alternative_Email_3__c = 'test@test.com';
        testAccount.Alternative_Email_4__c = 'test@test.com';
        testAccount.PersonAssistantPhone = '0114453322';
        testAccount.PersonAssistantName = 'Test Name';
        testAccount.PersonHomePhone = '0114453322';
        testAccount.PersonOtherPhone = '0114453322';
        testAccount.Phone = '0114453322';
        testAccount.Fax = '0114453322';
        testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
        testAccount.Identify_the_account_holder_type__c = 'Active Non Financial  Entity (ANFE)';
        testAccount.PEP_Status__pc = 'casino'; 
        testAccount.Country_of_Registration__c='South Africa';
        insert testAccount;
        return testAccount;
        
    }
    /**
    * @description 
    * @author mohammedjunaid.usman@absa.africa | 2021-08-16 
    * @param clientType 
    * @param clientGroup 
    * @return Account 
    **/
    public static Account getjointAccount(String clientType, string clientGroup){
        Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST MR JA & TEST MRS J';
        testJointAccount.Client_Type__c = clientType;
        testJointAccount.Client_group__c = clientGroup;
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'NAIARA+001';
        insert testJointAccount;
        return testJointAccount;
    }

}