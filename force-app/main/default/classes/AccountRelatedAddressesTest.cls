/**
 * @description       : AccountRelatedAddresses class test
 * @author            : Monde Masiza
 * @last modified on  : 2021-07-14
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-07   Monde Masiza   Initial Version
**/
@isTest
public  class AccountRelatedAddressesTest {

/**
 * @description       : AccountRelatedAddresses class method
 * @author            : Monde Masiza
 * @last modified on  : 2021-07-14
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-07   Monde Masiza   Initial Version
**/
 @isTest   
public static void AccountRelatedAddressesCreate(){

 //Account
 Account testAccount = new Account();
 Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
 testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Prospect').getRecordTypeId();
 testAccount.CASA_Reference_Number__c = '1712994';
 testAccount.CASA_Risk_Status__c = 'Low';
 testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
 testAccount.CASA_Screening_Status__c = 'Approved';
 testAccount.CASA_Analyst_Comments__c = '30406';
 testAccount.PersonMobilePhone = '0747003747';
 testAccount.Country_of_Residence__c = 'South Africa';
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
 testAccount.Client_Type__c = 'Individual Client';
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
 testAccount.PersonAssistantPhone = '0114453322';
 testAccount.PersonAssistantName = 'Test Name';
 testAccount.PersonHomePhone = '0114453322';
 testAccount.PersonOtherPhone = '0114453322';
 testAccount.Phone = '0114453322';
 testAccount.Fax = '0114453322';
 testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
 testAccount.AccountNumber = '1234567890';//previous value: 0011j00000WkXuGAAV
 testAccount.Identify_the_account_holder_type__c = 'Active Non Financial  Entity (ANFE)';
 testAccount.Date_Established__c = system.today();
 testAccount.registration_number__c = '123456789';
 insert testAccount;
 system.assertEquals(testAccount.Country_of_Residence__c, 'South Africa', 'Account did not create');
 test.startTest();
 AccountRelatedAddresses.createAccountRelatedAddresses(new List<Id>{testAccount.id});
 testAccount.Occupation_Status__pc = 'Unemployed';
  update testAccount;
 AccountRelatedAddresses.createAccountRelatedAddresses(new List<Id>{testAccount.id});
 test.stopTest();


}  
}