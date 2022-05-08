/**
* @description AccountContactRelationControllerTest class for AccountContactRelationController 
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2020-17-07
* @W-004945
*/

@isTest
public class AccountContactRelationControllerTest {
    
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
    static void ControllingPercentageTest(){
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
            Account acct = new Account();
            acct.Name = 'Absa';
            insert acct;
            
            Account accRecord2=new account();
            accRecord2.Name='Test Acc2';
            insert accRecord2;
            
            Account accRecord3 = new account();
            accRecord3.Name = 'Test Acc3';
            insert accRecord3;
            
            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata'; 
            con.firstname ='testdata1';
            insert con;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
        Controlling_Interest__c controllingInterestRec = new Controlling_Interest__c();
        controllingInterestRec.Primary_Entity__c = accRecord2.id;
        controllingInterestRec.Parent_Account__c = acct.id;
	    controllingInterestRec.Related_Account__c = accRecord3.Id;
        controllingInterestRec.Controlling_Interest__c = 0;
        controllingInterestRec.UBO__c = 'No';
        controllingInterestRec.Other_Primary_Entity_Id__c = '';
        insert controllingInterestRec;
            
            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = accRecord2.id;
            finservAccount.FinServ__RelatedAccount__c = accRecord3.Id;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = accRecord2.id;
            finservAccount.Shareholding_Percentage__c = 20;
        	finservAccount.Controlling_Percentage__c = 20;
            finservAccount.ParentRelationshipId__c = '';
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);
            AccountAccountRelationController.calculateControllingPercentageVal2(finservAccount,accRecord2.id );
                
            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord3.Id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = accRecord2.id;
            acctcr.Share_Percentage__c = 10.0;
            acctcr.ParentRelationshipId__c = finservAccount.id;
            AccountContactRelationController.calculateControllingPercentageVal(acctcr);
            AccountContactRelationController.calculateControllingPercentageVal2(acctcr, accRecord2.id);
            System.assert(acctcr.UBO__c == 'No');
        }
        
        
        
    }
    
    @isTest 
    static void ControllingPercentageTest1(){
        
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
        	Account acct = new Account();
            acct.Name = 'Absa';
            insert acct;
            
            Account accRecord2 = new account();
            accRecord2.Name = 'Test Acc2';
            insert accRecord2;
            
            Account accRecord3 = new account();
            accRecord3.Name = 'Test Acc3';
            insert accRecord3;
    
            Contact con = new Contact();
            con.AccountId = acct.id;
            con.lastname = 'testdata'; 
            con.firstname ='testdata1';
            insert con;
            
            Contact con2 = new Contact();
            con2.AccountId = accRecord3.id;
            con2.lastname = 'testdata'; 
            con2.firstname ='testdata1';
            insert con2;
            
            AccountContactRelation acctcr = new AccountContactRelation();
            acctcr.AccountId = accRecord2.id;
            acctcr.ContactId = con.id;
            acctcr.Primary_Entity_Id__c = accRecord2.id;
            acctcr.Share_Percentage__c = 10.0;
            AccountContactRelationController.calculateControllingPercentageVal(acctcr);
            System.assert(acctcr.UBO__c == 'Yes');
            
            AccountContactRelation acctcr3 = new AccountContactRelation();
            acctcr3.AccountId = accRecord2.id;
            acctcr3.ContactId = con2.id;
            acctcr3.Primary_Entity_Id__c = accRecord2.id;
            acctcr3.Share_Percentage__c = 5.0;
            AccountContactRelationController.calculateControllingPercentageVal(acctcr3);
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = accRecord2.id;
            finservAccount.FinServ__RelatedAccount__c = accRecord3.Id;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = accRecord2.id;
            finservAccount.Shareholding_Percentage__c = 2;
        	finservAccount.Controlling_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);
            
            AccountContactRelation acctcr2 = new AccountContactRelation();
            acctcr2.AccountId = accRecord3.Id;
            acctcr2.ContactId = con.id;
            acctcr2.Primary_Entity_Id__c = accRecord2.id;
            acctcr2.Share_Percentage__c = 10.0;
            insert acctcr2;
            
            AccountContactRelationController.calculateControllingPercentageVal(acctcr2);
            
            acctcr.Share_Percentage__c = 20;
            AccountContactRelationController.calculateControllingPercentageValOnUpdate(acctcr);
            
            acctcr3.Share_Percentage__c = 30;
            AccountContactRelationController.calculateControllingPercentageValOnUpdate(acctcr3);
            
            acctcr2.Share_Percentage__c = 5;
            AccountContactRelationController.calculateControllingPercentageValOnUpdate(acctcr2);
        }
        
    }
    
    @isTest 
    static void ControllingPercentageAccountAccount(){
        User sysUser = [Select Id,FirstName from User where FirstName='test'];
        
        System.runAs(sysUser) {
        	Account acct = new Account();
            acct.Name = 'Absa';
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
            acctcr.Primary_Entity_Id__c = acct.id;
            acctcr.Share_Percentage__c = 10.0;
            insert acctcr;
            
            FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
            resRole.FinServ__CreateInverseRole__c = true;
            resRole.FinServ__InverseRole__c = 'Director';
            insert resRole;
            
            System.assert(acctcr.UBO__c == null);
            
            FinServ__AccountAccountRelation__c finservAccount = new FinServ__AccountAccountRelation__c();
            finservAccount.FinServ__Account__c = acct.id;
            finservAccount.FinServ__RelatedAccount__c = acctcr.AccountId;
            finservAccount.FinServ__Role__c = resRole.id;
            finservAccount.Primary_Entity_Id__c = acct.id;
            finservAccount.Shareholding_Percentage__c = 2;
        	finservAccount.Controlling_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount);
            
            FinServ__AccountAccountRelation__c finservAccount2 = new FinServ__AccountAccountRelation__c();
            finservAccount2.FinServ__Account__c = acct.id;
            finservAccount2.FinServ__RelatedAccount__c = accRecord2.id;
            finservAccount2.FinServ__Role__c = resRole.id;
            finservAccount2.Primary_Entity_Id__c = acct.id;
            finservAccount2.Shareholding_Percentage__c = 2;
            finservAccount2.Controlling_Percentage__c = 2;
            AccountAccountRelationController.calculateControllingPercentageVal(finservAccount2);
            
            List<FinServ__AccountAccountRelation__c> accAccRelProcessList = new List<FinServ__AccountAccountRelation__c>();
            accAccRelProcessList.add(finservAccount);
            accAccRelProcessList.add(finservAccount2);
            AccountAccountRelationController.processRelatedAccAccRecord(accAccRelProcessList,30);

            finservAccount.Shareholding_Percentage__c = 20;
            AccountAccountRelationController.calculateControllingPercentageValOnUpdate(finservAccount);
            
            finservAccount2.Shareholding_Percentage__c = 20;
            AccountAccountRelationController.calculateControllingPercentageValOnUpdate(finservAccount2);
        }
    }
}