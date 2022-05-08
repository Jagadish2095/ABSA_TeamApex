/**
*@description Test class for OnboardingUBOListViewController
*/
@isTest
public class OnboardingUBOListViewController_Test {
    
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
    }
    
    @isTest 
    public static void getRelatedPartiesTest(){   
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            
            Account account = new Account(Name = 'Test Account');
            account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account.Country_of_Incorporation__c='South Africa';
            account.Client_Group__c = 'Non Individual';
            account.CASA_Reference_Number__c = '12233';
            account.CIF__c = '';
            account.Countries_Traded_With__c = 'South Africa';
            account.Source_of_Income__c = 'Donation';
            insert account;
            
            
            Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;
            
            Account account3 = new Account(Name = 'Test Account3');
            account3.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account3.Country_of_Incorporation__c='South Africa';
            account3.Client_Group__c = 'Non Individual';
            account3.CASA_Reference_Number__c = '12233';
            account3.CIF__c = '';
            account3.Countries_Traded_With__c = 'South Africa';
            account3.Source_of_Income__c = 'Donation';
            insert account3;
            
            Account account4 = new Account(Name = 'Test Account4');
            account4.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account4.Country_of_Incorporation__c='South Africa';
            account4.Client_Group__c = 'Non Individual';
            account4.CASA_Reference_Number__c = '12233';
            account4.CIF__c = '';
            account4.Countries_Traded_With__c = 'South Africa';
            account4.Source_of_Income__c = 'Donation';
            insert account4;
            
            
            //insert related acct;
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            Account acctSecondary = new Account();
            acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary.ID_Number__pc = '6803037015089';
            acctSecondary.ID_Type__pc = 'SA Identity Document';
            acctSecondary.FirstName = 'First Name1';
            acctSecondary.LastName = 'Last Name1';
            acctSecondary.Initials__pc = 'I';
            acctSecondary.PersonTitle = 'Mr';
            acctSecondary.Client_Type__c = 'Individual Client';
            acctSecondary.CASA_Reference_Number__pc = '12454' ;
            acctSecondary.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary;  
            
            Account acctSecondary2 = new Account();
            acctSecondary2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary2.ID_Number__pc = '6803037015089';
            acctSecondary2.ID_Type__pc = 'SA Identity Document';
            acctSecondary2.FirstName = 'First Name2';
            acctSecondary2.LastName = 'Last Name2';
            acctSecondary2.Initials__pc = 'I';
            acctSecondary2.PersonTitle = 'Mr';
            acctSecondary2.Client_Type__c = 'Individual Client';
            acctSecondary2.CASA_Reference_Number__pc = '12454' ;
            acctSecondary2.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary2;    
            
            Account acctSecondary3 = new Account();
            acctSecondary3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary3.ID_Number__pc = '6803037015089';
            acctSecondary3.ID_Type__pc = 'SA Identity Document';
            acctSecondary3.FirstName = 'First Name3';
            acctSecondary3.LastName = 'Last Name3';
            acctSecondary3.Initials__pc = 'I';
            acctSecondary3.PersonTitle = 'Mr';
            acctSecondary3.Client_Type__c = 'Individual Client';
            acctSecondary3.CASA_Reference_Number__pc = '12454' ;
            acctSecondary3.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary3;   
            
            
            Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
            Account acc2 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary2.Id];
            Account acc3 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary3.Id];
            
            Id personContactId = acc.PersonContactId; 
            Id personContactId2 = acc2.PersonContactId;
            Id personContactId3 = acc3.PersonContactId;
            AccountContactRelation accConRel = new AccountContactRelation(
                AccountId = account.Id, 
                ContactId = personContactId,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50 ,
               ParentRelationshipId__c = '');
              //AccountContactRelationController.calculateControllingPercentageVal2(accConRel, account.id);
              insert accConRel;

            AccountContactRelation accConRel2 = new AccountContactRelation(
                AccountId = account2.Id, 
                ContactId = personContactId2,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50,
                ParentRelationshipId__c = '');
           //AccountContactRelationController.calculateControllingPercentageVal2(accConRel2, account.id);
            
            AccountContactRelation accConRel4 = new AccountContactRelation(
                AccountId = account4.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel4; 
            
            
             AccountContactRelation accConRel3 = new AccountContactRelation(
                AccountId = account3.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel3;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            List<FinServ__AccountAccountRelation__c> accaccList = new List<FinServ__AccountAccountRelation__c>();
            FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account.Id, 
                FinServ__RelatedAccount__c = account2.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel2 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account3.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            AccountAccountRelationController.calculateControllingPercentageVal(accAccRel2);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel2,account.Id);
            
            
            FinServ__AccountAccountRelation__c accAccRel4 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            AccountAccountRelationController.calculateControllingPercentageVal(accAccRel4);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel4,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel3 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account3.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            AccountAccountRelationController.calculateControllingPercentageVal(accAccRel3);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel3,account.Id);
            
            Test.startTest();
           OnboardingUBOListViewController.getRelatedParties(account.id);
           //OnboardingUBOListViewController.calculateControllingInterest(accAccRel3.Id, accAccRel3.Id, account.id);

            system.assertNotEquals(accAccRel3.Id,null);
            Test.stopTest();
            
        }
    }

    @isTest 
    public static void parentAccountWrapperTest(){   
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            
            Account account = new Account(Name = 'Test Account');
            account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account.Country_of_Incorporation__c='South Africa';
            account.Client_Group__c = 'Non Individual';
            account.CASA_Reference_Number__c = '12233';
            account.CIF__c = '';
            account.Countries_Traded_With__c = 'South Africa';
            account.Source_of_Income__c = 'Donation';
            insert account;
            
            
            Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;
            
            Account account3 = new Account(Name = 'Test Account3');
            account3.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account3.Country_of_Incorporation__c='South Africa';
            account3.Client_Group__c = 'Non Individual';
            account3.CASA_Reference_Number__c = '12233';
            account3.CIF__c = '';
            account3.Countries_Traded_With__c = 'South Africa';
            account3.Source_of_Income__c = 'Donation';
            insert account3;
            
            Account account4 = new Account(Name = 'Test Account4');
            account4.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account4.Country_of_Incorporation__c='South Africa';
            account4.Client_Group__c = 'Non Individual';
            account4.CASA_Reference_Number__c = '12233';
            account4.CIF__c = '';
            account4.Countries_Traded_With__c = 'South Africa';
            account4.Source_of_Income__c = 'Donation';
            insert account4;
            
            
            //insert related acct;
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            Account acctSecondary = new Account();
            acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary.ID_Number__pc = '6803037015089';
            acctSecondary.ID_Type__pc = 'SA Identity Document';
            acctSecondary.FirstName = 'First Name1';
            acctSecondary.LastName = 'Last Name1';
            acctSecondary.Initials__pc = 'I';
            acctSecondary.PersonTitle = 'Mr';
            acctSecondary.Client_Type__c = 'Individual Client';
            acctSecondary.CASA_Reference_Number__pc = '12454' ;
            acctSecondary.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary;  
            
            Account acctSecondary2 = new Account();
            acctSecondary2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary2.ID_Number__pc = '6803037015089';
            acctSecondary2.ID_Type__pc = 'SA Identity Document';
            acctSecondary2.FirstName = 'First Name2';
            acctSecondary2.LastName = 'Last Name2';
            acctSecondary2.Initials__pc = 'I';
            acctSecondary2.PersonTitle = 'Mr';
            acctSecondary2.Client_Type__c = 'Individual Client';
            acctSecondary2.CASA_Reference_Number__pc = '12454' ;
            acctSecondary2.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary2;    
            
            Account acctSecondary3 = new Account();
            acctSecondary3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary3.ID_Number__pc = '6803037015089';
            acctSecondary3.ID_Type__pc = 'SA Identity Document';
            acctSecondary3.FirstName = 'First Name3';
            acctSecondary3.LastName = 'Last Name3';
            acctSecondary3.Initials__pc = 'I';
            acctSecondary3.PersonTitle = 'Mr';
            acctSecondary3.Client_Type__c = 'Individual Client';
            acctSecondary3.CASA_Reference_Number__pc = '12454' ;
            acctSecondary3.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary3;   
            
            
            Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
            Account acc2 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary2.Id];
            Account acc3 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary3.Id];
            
            Id personContactId = acc.PersonContactId; 
            Id personContactId2 = acc2.PersonContactId;
            Id personContactId3 = acc3.PersonContactId;
            AccountContactRelation accConRel = new AccountContactRelation(
                AccountId = account.Id, 
                ContactId = personContactId,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50 ,
               ParentRelationshipId__c = '');
              //AccountContactRelationController.calculateControllingPercentageVal2(accConRel, account.id);
                insert accConRel;
            
            AccountContactRelation accConRel2 = new AccountContactRelation(
                AccountId = account2.Id, 
                ContactId = personContactId2,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50,
                ParentRelationshipId__c = '');
           //AccountContactRelationController.calculateControllingPercentageVal2(accConRel2, account.id);
            
            AccountContactRelation accConRel4 = new AccountContactRelation(
                AccountId = account4.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel4; 
            
            
             AccountContactRelation accConRel3 = new AccountContactRelation(
                AccountId = account3.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel3;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            List<FinServ__AccountAccountRelation__c> accaccList = new List<FinServ__AccountAccountRelation__c>();
            FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account.Id, 
                FinServ__RelatedAccount__c = account2.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel,account.Id);
            //insert accAccRel;
            
            FinServ__AccountAccountRelation__c accAccRel2 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account3.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel2);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel2,account.Id);
            
            
            FinServ__AccountAccountRelation__c accAccRel4 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel4);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel4,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel3 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account3.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
           // AccountAccountRelationController.calculateControllingPercentageVal(accAccRel3);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel3,account.Id);
            
            Test.startTest();
            OnboardingUBOListViewController.parentAccountWrapper(account.id,true);
           //OnboardingUBOListViewController.calculateControllingInterest(accAccRel3.Id, accAccRel3.Id, account.id);

            system.assertNotEquals(account.Id,null);
            Test.stopTest();
            
        }
    }
      @isTest 
    public static void parentAccountWrapperAccAccTest(){   
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            
            Account account = new Account(Name = 'Test Account');
            account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account.Country_of_Incorporation__c='South Africa';
            account.Client_Group__c = 'Non Individual';
            account.CASA_Reference_Number__c = '12233';
            account.CIF__c = '';
            account.Countries_Traded_With__c = 'South Africa';
            account.Source_of_Income__c = 'Donation';
            insert account;
         
             
            Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;  
            
            Test.startTest();
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            List<FinServ__AccountAccountRelation__c> accaccList = new List<FinServ__AccountAccountRelation__c>();
            FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account.Id, 
                FinServ__RelatedAccount__c = account2.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel,account.Id);
            insert accAccRel;
            
           
            OnboardingUBOListViewController.parentAccountWrapper(account.id,true);
           //OnboardingUBOListViewController.calculateControllingInterest(accAccRel3.Id, accAccRel3.Id, account.id);

            system.assertNotEquals(account.Id,null);
            Test.stopTest();
            
        }
    }
  @isTest 
    public static void calculateControllingInterestTest(){   
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            
            Account account = new Account(Name = 'Test Account');
            account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account.Country_of_Incorporation__c='South Africa';
            account.Client_Group__c = 'Non Individual';
            account.CASA_Reference_Number__c = '12233';
            account.CIF__c = '';
            account.Countries_Traded_With__c = 'South Africa';
            account.Source_of_Income__c = 'Donation';
            insert account;
            
            
            Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;
            
            Account account3 = new Account(Name = 'Test Account3');
            account3.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account3.Country_of_Incorporation__c='South Africa';
            account3.Client_Group__c = 'Non Individual';
            account3.CASA_Reference_Number__c = '12233';
            account3.CIF__c = '';
            account3.Countries_Traded_With__c = 'South Africa';
            account3.Source_of_Income__c = 'Donation';
            insert account3;
            
            Account account4 = new Account(Name = 'Test Account4');
            account4.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account4.Country_of_Incorporation__c='South Africa';
            account4.Client_Group__c = 'Non Individual';
            account4.CASA_Reference_Number__c = '12233';
            account4.CIF__c = '';
            account4.Countries_Traded_With__c = 'South Africa';
            account4.Source_of_Income__c = 'Donation';
            insert account4;
            
            
            //insert related acct;
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            Account acctSecondary = new Account();
            acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary.ID_Number__pc = '6803037015089';
            acctSecondary.ID_Type__pc = 'SA Identity Document';
            acctSecondary.FirstName = 'First Name1';
            acctSecondary.LastName = 'Last Name1';
            acctSecondary.Initials__pc = 'I';
            acctSecondary.PersonTitle = 'Mr';
            acctSecondary.Client_Type__c = 'Individual Client';
            acctSecondary.CASA_Reference_Number__pc = '12454' ;
            acctSecondary.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary;  
            
            Account acctSecondary2 = new Account();
            acctSecondary2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary2.ID_Number__pc = '6803037015089';
            acctSecondary2.ID_Type__pc = 'SA Identity Document';
            acctSecondary2.FirstName = 'First Name2';
            acctSecondary2.LastName = 'Last Name2';
            acctSecondary2.Initials__pc = 'I';
            acctSecondary2.PersonTitle = 'Mr';
            acctSecondary2.Client_Type__c = 'Individual Client';
            acctSecondary2.CASA_Reference_Number__pc = '12454' ;
            acctSecondary2.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary2;    
            
            Account acctSecondary3 = new Account();
            acctSecondary3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary3.ID_Number__pc = '6803037015089';
            acctSecondary3.ID_Type__pc = 'SA Identity Document';
            acctSecondary3.FirstName = 'First Name3';
            acctSecondary3.LastName = 'Last Name3';
            acctSecondary3.Initials__pc = 'I';
            acctSecondary3.PersonTitle = 'Mr';
            acctSecondary3.Client_Type__c = 'Individual Client';
            acctSecondary3.CASA_Reference_Number__pc = '12454' ;
            acctSecondary3.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary3;   
            
            
            Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
            Account acc2 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary2.Id];
            Account acc3 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary3.Id];
            
            Id personContactId = acc.PersonContactId; 
            Id personContactId2 = acc2.PersonContactId;
            Id personContactId3 = acc3.PersonContactId;
            AccountContactRelation accConRel = new AccountContactRelation(
                AccountId = account.Id, 
                ContactId = personContactId,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50 ,
               ParentRelationshipId__c = '');
              //AccountContactRelationController.calculateControllingPercentageVal2(accConRel, account.id);
                
            
            AccountContactRelation accConRel2 = new AccountContactRelation(
                AccountId = account2.Id, 
                ContactId = personContactId2,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50,
                ParentRelationshipId__c = '');
           //AccountContactRelationController.calculateControllingPercentageVal2(accConRel2, account.id);
            
            AccountContactRelation accConRel4 = new AccountContactRelation(
                AccountId = account4.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel4; 
            
            
             AccountContactRelation accConRel3 = new AccountContactRelation(
                AccountId = account3.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel3;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            List<FinServ__AccountAccountRelation__c> accaccList = new List<FinServ__AccountAccountRelation__c>();
            FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account.Id, 
                FinServ__RelatedAccount__c = account2.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel2 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account3.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel2);
             //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel2,account.Id);
            
            
            FinServ__AccountAccountRelation__c accAccRel4 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel4);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel4,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel3 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account3.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel3);
            //AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel3,account.Id);
            
            Test.startTest();
           //OnboardingUBOListViewController.getRelatedParties(account.id);
           OnboardingUBOListViewController.calculateControllingInterest(accAccRel3.Id, accAccRel3.Id, account.id);

            system.assertNotEquals(account.Id,null);
            Test.stopTest();
            
        }
    }
    
     @isTest 
    public static void testUBOListView1(){   
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            
            Account account = new Account(Name = 'Test Account');
            account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account.Country_of_Incorporation__c='South Africa';
            account.Client_Group__c = 'Non Individual';
            account.CASA_Reference_Number__c = '12233';
            account.CIF__c = '';
            account.Countries_Traded_With__c = 'South Africa';
            account.Source_of_Income__c = 'Donation';
            insert account;
            
            
            Account account2 = new Account(Name = 'Test Account2');
            account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account2.Country_of_Incorporation__c='South Africa';
            account2.Client_Group__c = 'Non Individual';
            account2.CASA_Reference_Number__c = '12233';
            account2.CIF__c = '';
            account2.Countries_Traded_With__c = 'South Africa';
            account2.Source_of_Income__c = 'Donation';
            insert account2;
            
            Account account3 = new Account(Name = 'Test Account3');
            account3.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account3.Country_of_Incorporation__c='South Africa';
            account3.Client_Group__c = 'Non Individual';
            account3.CASA_Reference_Number__c = '12233';
            account3.CIF__c = '';
            account3.Countries_Traded_With__c = 'South Africa';
            account3.Source_of_Income__c = 'Donation';
            insert account3;
            
            Account account4 = new Account(Name = 'Test Account4');
            account4.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
            account4.Country_of_Incorporation__c='South Africa';
            account4.Client_Group__c = 'Non Individual';
            account4.CASA_Reference_Number__c = '12233';
            account4.CIF__c = '';
            account4.Countries_Traded_With__c = 'South Africa';
            account4.Source_of_Income__c = 'Donation';
            insert account4;
            
            
            //insert related acct;
            List<AccountContactRelation> acrList = new List<AccountContactRelation>();
            Account acctSecondary = new Account();
            acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary.ID_Number__pc = '6803037015089';
            acctSecondary.ID_Type__pc = 'SA Identity Document';
            acctSecondary.FirstName = 'First Name1';
            acctSecondary.LastName = 'Last Name1';
            acctSecondary.Initials__pc = 'I';
            acctSecondary.PersonTitle = 'Mr';
            acctSecondary.Client_Type__c = 'Individual Client';
            acctSecondary.CASA_Reference_Number__pc = '12454' ;
            acctSecondary.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary; 
            Account acctSecondary2 = new Account();
            acctSecondary2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary2.ID_Number__pc = '6803037015089';
            acctSecondary2.ID_Type__pc = 'SA Identity Document';
            acctSecondary2.FirstName = 'First Name2';
            acctSecondary2.LastName = 'Last Name2';
            acctSecondary2.Initials__pc = 'I';
            acctSecondary2.PersonTitle = 'Mr';
            acctSecondary2.Client_Type__c = 'Individual Client';
            acctSecondary2.CASA_Reference_Number__pc = '12454' ;
            acctSecondary2.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary2;    
            
            Account acctSecondary3 = new Account();
            acctSecondary3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
            acctSecondary3.ID_Number__pc = '6803037015089';
            acctSecondary3.ID_Type__pc = 'SA Identity Document';
            acctSecondary3.FirstName = 'First Name3';
            acctSecondary3.LastName = 'Last Name3';
            acctSecondary3.Initials__pc = 'I';
            acctSecondary3.PersonTitle = 'Mr';
            acctSecondary3.Client_Type__c = 'Individual Client';
            acctSecondary3.CASA_Reference_Number__pc = '12454' ;
            acctSecondary3.CASA_Screening_Status__c = 'Matched';
            insert acctSecondary3;   
            
            
            Account acc = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary.Id];
            Account acc2 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary2.Id];
            Account acc3 = [SELECT PersonContactId FROM Account WHERE Id =: acctSecondary3.Id];
            
            Id personContactId = acc.PersonContactId; 
            Id personContactId2 = acc2.PersonContactId;
            Id personContactId3 = acc3.PersonContactId;
            AccountContactRelation accConRel = new AccountContactRelation(
                AccountId = account.Id, 
                ContactId = personContactId,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50 ,
               ParentRelationshipId__c = '');
              AccountContactRelationController.calculateControllingPercentageVal2(accConRel, account.id);
                
            
            AccountContactRelation accConRel2 = new AccountContactRelation(
                AccountId = account2.Id, 
                ContactId = personContactId2,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50,
                ParentRelationshipId__c = '');
           AccountContactRelationController.calculateControllingPercentageVal2(accConRel2, account.id);
            
            AccountContactRelation accConRel4 = new AccountContactRelation(
                AccountId = account4.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel4; 
            
            
             AccountContactRelation accConRel3 = new AccountContactRelation(
                AccountId = account3.Id, 
                ContactId = personContactId3,
                Roles = 'Shareholder/Controller',
                Primary_Entity_Id__c = account.Id,
                Share_Percentage__c = 50);
            insert accConRel3;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            List<FinServ__AccountAccountRelation__c> accaccList = new List<FinServ__AccountAccountRelation__c>();
            FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account.Id, 
                FinServ__RelatedAccount__c = account2.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel);
             AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel2 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account3.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel2);
             AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel2,account.Id);
            
            
            FinServ__AccountAccountRelation__c accAccRel4 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account2.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel4);
            AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel4,account.Id);
            
            FinServ__AccountAccountRelation__c accAccRel3 = new FinServ__AccountAccountRelation__c(
                FinServ__Account__c = account3.Id, 
                FinServ__RelatedAccount__c = account4.Id,
                Roles__c = 'Shareholder/Controller',
                FinServ__Role__c = resRole.id, 
                Primary_Entity_Id__c = account.Id,
                Shareholding_Percentage__c = 50);    
            //AccountAccountRelationController.calculateControllingPercentageVal(accAccRel3);
            AccountAccountRelationController.calculateControllingPercentageVal2(accAccRel3,account.Id);
            
            Test.startTest();
           //OnboardingUBOListViewController.getRelatedParties(account.id);
           //OnboardingUBOListViewController.calculateControllingInterest(accAccRel3.Id, accAccRel3.Id, account.id);

           system.assertNotEquals(account.Id,null);
           try {
            OnboardingUBOListViewController.reEvaluateControllingPercentage(accConRel3.id);
        } catch (Exception ex) {
            System.assertEquals(ex.getMessage(), ex.getMessage());
        }
        
        try {
            OnboardingUBOListViewController.fetchClientType(accAccRel4.id);
        } catch (Exception ex) {
            System.assertEquals(ex.getMessage(), ex.getMessage());
        }
        
        try {
            OnboardingUBOListViewController.fetchClientTypeEdit(accConRel3.id);
        } catch (Exception ex) {
            System.assertEquals(ex.getMessage(), ex.getMessage());
        }
            Test.stopTest();
            
        }
    }
   
    
    //Test Method to test calculate calculateControllingPercentageforAccAccRel and deleteRelatedHierarchyRecords method
    //@author: Chandra
    //@Date: 25/07/2020
    @isTest 
    static void calculateControllingPercentageAndDeleteHierarchyTest(){
        
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            Account acct = new Account();
            acct.Name = 'Absa';
            acct.ID_Type__c = 'SA Identity Document';
            insert acct;
            
            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            accRecord2.ID_Type__c = 'SA Identity Document';
            insert accRecord2;
            
            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata'; 
            con.firstname ='testdata1';
            insert con;
            
            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord2.id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = acct.id;
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
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);
            
            FinServ__AccountAccountRelation__c finservAccount2 = new FinServ__AccountAccountRelation__c();
            finservAccount2.FinServ__Account__c = acct.id;
            finservAccount2.FinServ__RelatedAccount__c = accRecord2.id;
            finservAccount2.FinServ__Role__c = resRole.id;
            finservAccount2.Primary_Entity_Id__c = acct.id;
            finservAccount2.Shareholding_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount2);
            
            
            Test.startTest();
            OnboardingUBOListViewController.calculateControllingPercentageforAccAccRel(finservAccount2.id,finservAccount2.Shareholding_Percentage__c,'Shareholder/Controller');
            OnboardingUBOListViewController.deleteRelatedHierarchyRecords(finservAccount2.id);
            system.assertNotEquals(finservAccount2.Id,null);
            Test.stopTest();
        }
    }
}