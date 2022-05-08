/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-11-30
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/

/*
* @description Test Integration Handler for OnboardingRelatedPartiesControlerTest service
* @author Vladimir Panajic 
* @created 2020-02-21
*/

@ isTest
public class OnboardingRelatedPartiesControlerTest {
    /*
    * @description getRelatedPartiesTest
    */
    @ isTest static void getRelatedPartiesTest() {
    //insert acct;
    Account acctPrimary = new Account(Name = 'Test Primary Account');    
    insert acctPrimary;
    //insert related acct;
    Account acctSecondary = new Account();
    acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
    acctSecondary.ID_Number__pc = '6803037015089';
    acctSecondary.ID_Type__pc = 'SA Identity Document';
    acctSecondary.FirstName = 'First Name';
    acctSecondary.LastName = 'Test Last Name';
    acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.ID_Number__pc='6211275132089';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';
        
    insert acctSecondary;        
    Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
    Id personContactId = acc.PersonContactId;
    AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, Primary_Entity_Id__c = acctPrimary.Id, ContactId = personContactId,Roles = 'Director;Shareholder/Controller;Individual with Authority to Act;Managing Director/Chief Executive Officer');
    insert accConRel;
    Test.startTest();
        OnboardingRelatedPartiesControler.getRelatedParties(acctPrimary.id);
        OnboardingRelatedPartiesControler.removeRelatedParty(accConRel.Id);
        OnboardingRelatedPartiesControler.validateRelatedParties(acctPrimary.id);
        OnboardingRelatedPartiesControler.fetchPersonAccDetails(personContactId);
        OnboardingRelatedPartiesControler.updatePersonAccDetails(acc);
        System.assertNotEquals(null, accConRel);
    Test.stopTest();
    }
    /*
    * @description getRelatedPartiesTest2
    */
   @isTest static void getRelatedPartiesTest2() {   
    //insert acct;
    Account acctPrimary = new Account(Name = 'Test Primary Account');    
    insert acctPrimary;
    
    //insert related acct;
    Account acctSecondary = new Account();
    acctSecondary.ID_Number__pc = '6803037015089';
    acctSecondary.ID_Type__pc = 'SA Identity Document';
    acctSecondary.FirstName = 'First Name';
    acctSecondary.LastName = 'Test Last Name';
    acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.ID_Number__pc='6211275132089';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';
    insert acctSecondary;        
    Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
    Id personContactId = acc.PersonContactId;
    AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, ContactId = personContactId,Roles = 'Director;Shareholder/Controller;Individual with Authority to Act;Managing Director/Chief Executive Officer');
    insert accConRel;
       Test.startTest();
       OnboardingRelatedPartiesControler.fetchAddressList(accConRel.Id);
       
       OnboardingRelatedPartiesControler.deleteRelatedParty(accConRel.Id);
               OnboardingRelatedPartiesControler.getPickListValues();
       OnboardingRelatedPartiesControler.getClientRecordTypeByName('Individual_Prospect');

       OnboardingRelatedPartiesControler.getselectOptions(new AccountContactRelation(),'Designation__c');
        System.assertNotEquals(null, accConRel);
       Test.stopTest();
    }

    //Test Method to calculate calculateControllingPercentage on Account Contact Relationship
    //@author: Chandra
    //@Date: 16/07/2020
     /*
    * @description calculate calculateControllingPercentage on Account Contact Relationship
    */
    @testSetup
    static void dataCreation(){
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)']; 
        
        User sysAdminUser = new User();
        sysAdminUser.FirstName = 'test';
        sysAdminUser.LastName = 'last_test';
        sysAdminUser.Email = 'testSf@test.com';
        sysAdminUser.Phone = '111-111-1111';
        sysAdminUser.Alias = 'test';
        sysAdminUser.EmailEncodingKey = 'UTF-8';
        sysAdminUser.ProfileId = profile.Id;
        sysAdminUser.LanguageLocaleKey = 'en_US';
        sysAdminUser.LocaleSidKey = 'en_US';
        sysAdminUser.TimeZoneSidKey = 'America/Los_Angeles';
        sysAdminUser.UserName = 'sftestCase@test.com';
        sysAdminUser.IsActive = true;
        insert sysAdminUser; 
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Advisor'];
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = ps.Id);
        
        PermissionSet fsps = [SELECT Id FROM PermissionSet WHERE Name = 'FinancialServicesCloudStandard'];
        insert new PermissionSetAssignment(AssigneeId = sysAdminUser.id, PermissionSetId = fsps.Id);
         System.assertNotEquals(null, sysAdminUser);
    }

    /*
    * @description calculateControllingPercentageTest
    */
    @isTest 
    static void calculateControllingPercentageTest(){
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            Account acct = new Account();
            acct.Name = 'Test';
            insert acct;
    
            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            insert accRecord2;
            
            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata'; 
            con.firstname ='testdata1';
            insert con;
            
            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord2.id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = accRecord2.id;
            acctcr.Share_Percentage__c = 10.0;
            insert acctcr;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = acct.id;
            finservAccount.FinServ__RelatedAccount__c = acctcr.AccountId;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = accRecord2.id;
            finservAccount.Shareholding_Percentage__c = 2;
            insert finservAccount;
            Test.startTest();
                OnboardingRelatedPartiesControler.calculateControllingPercentage(acctcr.id,acctcr.Share_Percentage__c,'Shareholder/Controller',accRecord2.id );
             System.assertNotEquals(null, acctcr);
             OnboardingRelatedPartiesControler.getselectectedRoleVal(acctcr.id);
            OnboardingRelatedPartiesControler.updateAccConRelationship(acctcr.id, 10, 'Director', '1223', 'test');
            OnboardingRelatedPartiesControler.getClientTypeByaccContRelId(acctcr.id);
            OnboardingRelatedPartiesControler.updateAccountAccountRelationship(finservAccount.id, 10, 'Director');
            Test.stopTest();
        }
        
    }
    
    //Test Method to Hanis Certificate for related Party
    //@author: Sandeep Golla
    //@Date: 04/01/2021
    /*
    * @description Test Method to Hanis Certificate for related Party
    */
    @ isTest static void HanisCertificatesTest() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        // Document template record for Hanis
        List<Document_Template__c> dtList = new List<Document_Template__c>();
        dtList.add(new Document_Template__c(Name='HANIS Certificate',Document_Type__c='HANIS Certificate',ECM_Filing_Date_Metadata__c=true,
                                            ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
                                            ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
                                            ECM_Account_Number_Metadata__c=true));
        upsert dtList;
        //Integration Services records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String>{StringConstants.HANIS_VALIDATE, 'ECM Authenication Path', 'ECM Add Path'});
        
        Account acctPrimary = new Account(Name = 'Test Primary Account');    
        insert acctPrimary;
        
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '7707077777087';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'GLENTON';
        acctSecondary.LastName = 'REBELLO';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';
        insert acctSecondary;
        
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, ContactId = personContactId,Roles = 'Director;Shareholder/Controller;Individual with Authority to Act;Managing Director/Chief Executive Officer');
        insert accConRel;
         
        AccountContactRelation acccon = [SELECT Id,AccountId,ContactId,Contact.FirstName,Contact.LastName FROM AccountContactRelation WHERE Id =: accConRel.Id];
        Test.startTest();
        String hanisResponse = OnboardingRelatedPartiesControler.callHanisServiceForRelatedParties(accConRel.Contact.ID_Number__c);
        OnboardingRelatedPartiesControler.GenerateHanisCertificate(hanisResponse,acctPrimary.id,acccon.Contact.FirstName+acccon.Contact.LastName);
        System.assertNotEquals(null, accConRel);
        Test.stopTest();
    }
    
    //Test Method to CPB Certificate for related Party
    //@author: Sandeep Golla
    //@Date: 04/01/2021
    /*
    * @description Test Method to CPB Certificate for related Party
    */
    @ isTest static void cpbCertificatesTest() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CPBValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        //Document Template record for CPB
        List<Document_Template__c> dtList = new List<Document_Template__c>();
        dtList.add(new Document_Template__c(Name='CPB Certificate',Document_Type__c='CPB Certificate',ECM_Filing_Date_Metadata__c=true,
                                            ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
                                            ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
                                            ECM_Account_Number_Metadata__c=true));
        upsert dtList;
        //Integration Services record for CPB
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String>{StringConstants.CPB_VALIDATE, 'ECM Authenication Path', 'ECM Add Path'});
        
        Account acctPrimary = new Account(Name = 'Test Primary Account');    
        insert acctPrimary;
        
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '7707077777087';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'GLENTON';
        acctSecondary.LastName = 'BURGER';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.Country_of_Citizenship__c =  'South Africa';
        acctSecondary.PersonBirthdate = Date.valueOf('1962-11-27');
        acctSecondary.Gender__pc = 'Male';
        insert acctSecondary;
        
        Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = acctPrimary.Id, ContactId = personContactId,Roles = 'Director;Shareholder/Controller;Individual with Authority to Act;Managing Director/Chief Executive Officer');
        insert accConRel;
        
        AccountContactRelation acccon = [SELECT Id,AccountId,ContactId,Contact.FirstName,Contact.LastName FROM AccountContactRelation WHERE Id =: accConRel.Id];
         
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        testOpp.accountId = acctPrimary.Id;
        insert testOpp;
        Test.startTest();
        String cpbResponse = OnboardingRelatedPartiesControler.callCPBServiceForRelatedParties(accConRel.Contact.ID_Number__c,acccon.Contact.LastName);
        OnboardingRelatedPartiesControler.GenerateCPBCertificate(cpbResponse,acctPrimary.id,acccon.Contact.FirstName+acccon.Contact.LastName);
        OnboardingRelatedPartiesControler.getClientTypeByaccContRelId(accConRel.Id);
        OnboardingRelatedPartiesControler.OpportunityStage(acctPrimary.Id);
        OnboardingRelatedPartiesControler.updateAccConRelationship(accConRel.Id, accConRel.Share_Percentage__c,accConRel.Roles, accConRel.Tax_Number__c, accConRel.Tax_Residency__c);
        System.assertNotEquals(null, testOpp);
        Test.stopTest();
    }

    
    //Test Method to Experian Certificate for related Party
    @ isTest static void experianCertificatesTest() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ExperianBusinessDetailsGet_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        // Document template record for Hanis
        List<Document_Template__c> dtList = new List<Document_Template__c>();
        dtList.add(new Document_Template__c(Name='Experian Certificate',Document_Type__c='Experian Certificate',ECM_Filing_Date_Metadata__c=true,
                                            ECM_ID_Number_Metadata__c=true,ECM_CIF_Code_Metadata__c=true,
                                            ECM_Origin_Metadata__c=true,ECM_Business_Unit_Metadata__c=true,
                                            ECM_Account_Number_Metadata__c=true));
        upsert dtList;
        //Integration Services records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String>{StringConstants.HANIS_VALIDATE, 'ECM Authenication Path', 'ECM Add Path'});       
        Account acctPrimary = new Account(Name = 'Test Primary Account');    
        insert acctPrimary;
        
        Test.startTest();
         String respStr = OnboardingRelatedPartiesControler.callExperianHandler('1971/011503/07'); 
         OnboardingRelatedPartiesControler.GenerateExperianCertificate(respStr,acctPrimary.id);
         System.assertNotEquals(null, respStr); 
         Test.stopTest();
        
    }
}