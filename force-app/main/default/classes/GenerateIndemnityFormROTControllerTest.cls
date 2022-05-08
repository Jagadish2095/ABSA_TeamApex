@isTest
public class GenerateIndemnityFormROTControllerTest {
    
    /*
     * Purpose : Method to create test data
     */
    
    @TestSetup
    static void TestData(){
        
        Account account = new Account(Name = 'Test Account', CIF__c = 'cif12345');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        Case testCase = new Case(RecordTypeId = caseRecordTypeId, accountId = account.Id);
        insert testCase;
        
        RestrictionGroup__c currentRestriction = new RestrictionGroup__c();
        currentRestriction.Status__c = 'Added';
        currentRestriction.GroupID__c = 'TestMuvhuso';
        currentRestriction.Case__c = testCase.Id;
        insert currentRestriction;
        
        RestrictionGroupCustomer__c objGrpCustomer = new RestrictionGroupCustomer__c();
        objGrpCustomer.EffectiveStartDate__c = system.today() - 10;
        objGrpCustomer.EffectiveEndDate__c = system.today();
        objGrpCustomer.RestrictionGroupId__c = currentRestriction.Id;
        objGrpCustomer.CustomerKey__c = '121Sd';
        insert objGrpCustomer;
        
        List<RestrictionGroupAccount__c> grpRestrictionList = new List<RestrictionGroupAccount__c>();
        RestrictionGroupAccount__c objGrpRestriction = new RestrictionGroupAccount__c();
        objGrpRestriction.AccountNumber__c = '212345';
        objGrpRestriction.Excluded_Account__c = false;
        objGrpRestriction.EffectiveStartDate__c = system.today() - 10;
        objGrpRestriction.EffectiveEndDate__c = system.today();
        objGrpRestriction.RestrictionGroupId__c = currentRestriction.Id;
        grpRestrictionList.add(objGrpRestriction);
        RestrictionGroupAccount__c objGrpRestriction1 = new RestrictionGroupAccount__c();
        objGrpRestriction1.AccountNumber__c = '217890';
        objGrpRestriction1.Excluded_Account__c = true;
        objGrpRestriction1.EffectiveStartDate__c = system.today() - 10;
        objGrpRestriction1.EffectiveEndDate__c = system.today();
        objGrpRestriction1.RestrictionGroupId__c = currentRestriction.Id;
        grpRestrictionList.add(objGrpRestriction1);
        insert grpRestrictionList;
        
        RestrictionGroupTransactionType__c objTransactionType = new RestrictionGroupTransactionType__c();
        objTransactionType.Effective_Start_Date__c = system.today() - 10;
        objTransactionType.Effective_End_Date__c = system.today();
        objTransactionType.Restriction_Group_ID__c = currentRestriction.Id;
        objTransactionType.Description__c = 'Test Description';
        insert objTransactionType;
    }
    
    @IsTest
    static void testMethodDocument(){
        Case caseRecord = [SELECT Id,AccountId FROM Case LIMIT 1];
        Test.StartTest(); 
        PageReference pageRef = Page.GenerateIndemnityFormROT;
        pageRef.getParameters().put('Id', caseRecord.Id);
        Test.setCurrentPage(pageRef);
        GenerateIndemnityFormROTController testAccPlan = new GenerateIndemnityFormROTController();
        Test.StopTest();
    }
}