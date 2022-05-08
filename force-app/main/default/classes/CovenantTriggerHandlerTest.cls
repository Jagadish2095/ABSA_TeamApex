/**
 * @description       :
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-05
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log
 * Ver   Date         Author                         Modification
 * 1.0   2021-06-22   muvhuso.nekhubvi@absa.africa   Initial Version
**/
@IsTest
public with sharing class CovenantTriggerHandlerTest {
    @testSetup static void dataCreation(){
        User adm = new User();
        String uniqueUserName = 'Test' + DateTime.now().getTime() + '@absa2.com';
        String email = 'UserAdmin@absa.co.za';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', Username=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
    	Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
    	insert account;
        Covenant__c covenant = new Covenant__c();
    	covenant.Account__c = account.Id;
    	covenant.Account_Number__c = 2132121;
        covenant.Additional_information__c = 'Muvhuso';
        covenant.Area_Manager_Coverage__c = adm.Id;
        covenant.Covenant_Amount__c = 45000000;
        covenant.Covenant_Status__c = 'MET';
        covenant.Covenant_type__c = 'Asset Cover Ratio';
        covenant.Fromula__c = 'Account receivables and/or stock/overdraft (facility)';
        covenant.CPF__c = 'No';
        covenant.Required_level__c = 'Test';
        covenant.Regions__c = 'CAPE';
        covenant.Frequency__c = 'Monthly';
        covenant.Credit_Application_Type__c = 'Lite Credit App';
        covenant.Report_Date__c = Date.today();
        covenant.Date_Covenant_Captured__c = Date.today();
        covenant.Information_required_to_measure_covenant__c = 'TEST';
        covenant.Fields_Editable__c = true;
        insert covenant;

    }
    @IsTest public static void testCovenantTrigger() {
        User adm = new User();
        String uniqueUserName = 'Test' + DateTime.now().getTime() + '@absa2.com';
        String email = 'UserAdmin@absa.co.za';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', Username=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
        Account account = new Account(Name = 'Test Account Muvhuso', CIF__c = 'cif12111');
    	insert account;
        Covenant__c covenant = new Covenant__c();
    	covenant.Account__c = account.Id;
    	covenant.Account_Number__c = 2132121;
        covenant.Additional_information__c = 'Muvhuso';
        covenant.Area_Manager_Coverage__c = adm.Id;
        covenant.Covenant_Amount__c = 45000000;
        covenant.Covenant_Status__c = 'MET';
        covenant.Covenant_type__c = 'Asset Cover Ratio';
        covenant.Fromula__c = 'Account receivables and/or stock/overdraft (facility)';
        covenant.CPF__c = 'No';
        covenant.Required_level__c = 'Test';
        covenant.Regions__c = 'CAPE';
        covenant.Frequency__c = 'Monthly';
        covenant.Credit_Application_Type__c = 'Lite Credit App';
        covenant.Report_Date__c = Date.today();
        covenant.Date_Covenant_Captured__c = Date.today();
        covenant.Information_required_to_measure_covenant__c = 'TEST';
        covenant.Fields_Editable__c = true;
        insert covenant;
        System.assertNotEquals(covenant, null,'Covenant should not be null');

    }

    @IsTest public static void testCovenantUpdateTrigger() {
        Covenant__c covenant = [SELECT Id FROM Covenant__c LIMIT 1];
        covenant.Covenant_Approved__c = true;
         update covenant;
         System.assertNotEquals(covenant, null,'Covenant should not be null');

 }

	 @IsTest public static void testCovenantQuarterlyTrigger() {
        User adm = new User();
        String uniqueUserName = 'Test' + DateTime.now().getTime() + '@absa2.com';
        String email = 'UserAdmin@absa.co.za';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', Username=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
        Account account = new Account(Name = 'Test Account Muvhuso', CIF__c = 'cif12100');
    	insert account;
        Covenant__c covenant = new Covenant__c();
    	covenant.Account__c = account.Id;
    	covenant.Account_Number__c = 2132121;
        covenant.Additional_information__c = 'Muvhuso';
        covenant.Area_Manager_Coverage__c = adm.Id;
        covenant.Covenant_Amount__c = 45000000;
        covenant.Covenant_Status__c = 'MET';
        covenant.Covenant_type__c = 'Asset Cover Ratio';
        covenant.Fromula__c = 'Account receivables and/or stock/overdraft (facility)';
        covenant.CPF__c = 'No';
        covenant.Required_level__c = 'Test';
        covenant.Regions__c = 'CAPE';
        covenant.Frequency__c = 'Quarterly';
        covenant.Credit_Application_Type__c = 'Lite Credit App';
        covenant.Report_Date__c = Date.today();
        covenant.Date_Covenant_Captured__c = Date.today();
        covenant.Information_required_to_measure_covenant__c = 'TEST';
        covenant.Fields_Editable__c = true;
        insert covenant;
        System.assertNotEquals(covenant, null,'Covenant should not be null');

         CovenantTriggerFunctions.createTask(covenant.Id, 'update');
    }
    @IsTest public static void testCovenantAnnuallyTrigger() {
        User adm = new User();
        String uniqueUserName = 'Test' + DateTime.now().getTime() + '@absa2.com';
        String email = 'UserAdmin@absa.co.za';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', Username=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
        Account account = new Account(Name = 'Test Account Muvhuso', CIF__c = 'cif12100');
    	insert account;
        Covenant__c covenant = new Covenant__c();
    	covenant.Account__c = account.Id;
    	covenant.Account_Number__c = 2132121;
        covenant.Additional_information__c = 'Muvhuso';
        covenant.Area_Manager_Coverage__c = adm.Id;
        covenant.Covenant_Amount__c = 45000000;
        covenant.Covenant_Status__c = 'MET';
        covenant.Covenant_type__c = 'Asset Cover Ratio';
        covenant.Fromula__c = 'Account receivables and/or stock/overdraft (facility)';
        covenant.CPF__c = 'No';
        covenant.Required_level__c = 'Test';
        covenant.Regions__c = 'CAPE';
        covenant.Frequency__c = 'Annually';
        covenant.Credit_Application_Type__c = 'Lite Credit App';
        covenant.Report_Date__c = Date.today();
        covenant.Date_Covenant_Captured__c = Date.today();
        covenant.Information_required_to_measure_covenant__c = 'TEST';
        insert covenant;
        System.assertNotEquals(covenant, null,'Covenant should not be null');

         CovenantTriggerFunctions.createTask(covenant.Id, 'update');
    }

    @IsTest public static void testCovenantBiAnnuallyTrigger() {
        User adm = new User();
        String uniqueUserName = 'Test' + DateTime.now().getTime() + '@absa2.com';
        String email = 'UserAdmin@absa.co.za';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
        adm = new User(Alias = 'standt', Email=email,EmailEncodingKey='UTF-8', LastName='UserAdmin', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='Africa/Johannesburg', Username=uniqueUserName, MobilePhone='0823389021');
        Insert adm;
        Account account = new Account(Name = 'Test Account Muvhuso', CIF__c = 'cif12100');
    	insert account;
        Covenant__c covenant = new Covenant__c();
    	covenant.Account__c = account.Id;
    	covenant.Account_Number__c = 2132121;
        covenant.Additional_information__c = 'Muvhuso';
        covenant.Area_Manager_Coverage__c = adm.Id;
        covenant.Covenant_Amount__c = 45000000;
        covenant.Covenant_Status__c = 'MET';
        covenant.Covenant_type__c = 'Asset Cover Ratio';
        covenant.Fromula__c = 'Account receivables and/or stock/overdraft (facility)';
        covenant.CPF__c = 'No';
        covenant.Required_level__c = 'Test';
        covenant.Regions__c = 'CAPE';
        covenant.Frequency__c = 'Bi-Annually';
        covenant.Credit_Application_Type__c = 'Lite Credit App';
        covenant.Report_Date__c = Date.today();
        covenant.Date_Covenant_Captured__c = Date.today();
        covenant.Information_required_to_measure_covenant__c = 'TEST';
        insert covenant;
        System.assertNotEquals(covenant, null,'Covenant should not be null');
        CovenantTriggerFunctions.createTask(covenant.Id, 'update');
    }
    @IsTest public static void testCovenantUpdateTriggerAfterApproval() {
        Covenant__c covenant = [SELECT Id FROM Covenant__c LIMIT 1];
        covenant.Fields_Editable__c = true;
        update covenant;
        System.assertNotEquals(covenant, null,'Covenant should not be null');

 }


}