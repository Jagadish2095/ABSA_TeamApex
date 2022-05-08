/*
 * Test class for OnboardingClientDetailsController 
 * @author Srikanth N
 * @created 2019-12-04
 */   

@isTest
public class OnboardingClientDetailsController_Test {   
    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    @testSetup static void setup() {
        Account testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST MR JA & TEST MRS J';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'NAIARA+001';
        insert testJointAccount;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.AccountId = testJointAccount.Id;         
        insert testContact;
        IntegrationTestDataFactory.insertIntegrationTranslations();
    }
   /*@isTest static void saveAccountInfoTest() {        
        Account testJointAccount = [SELECT Id FROM Account Limit 1];
        OnboardingClientDetailsController.clientDetailsWrapper wrapper =  new OnboardingClientDetailsController.clientDetailsWrapper();
        wrapper.Id = testJointAccount.Id;
        wrapper.vatRegNo = integer.valueOf('12354');
        OnboardingClientDetailsController.saveAccountInfo(JSON.serialize(wrapper) );
        wrapper.Name = 'testAccount';
        wrapper.itnumber = integer.valueOf('9876435');
        OnboardingClientDetailsController.saveAccountInfo(JSON.serialize(wrapper) );
        
    }
    @isTest static void saveRikInfoTest() {      
        Account testJointAccount = [SELECT Id FROM Account Limit 1];
        OnboardingClientDetailsController.saveRikInfo(''+testJointAccount.Id,'');
        OnboardingClientDetailsController.saveRikInfo('','');
    }
    @isTest static void callToCASAScreeningTest() {      
        Account testJointAccount = [SELECT Id FROM Account Limit 1];
        OnboardingClientDetailsController.callToCASAScreening(testJointAccount.Id);
    }
    
    @isTest static void callToCrateCIFTest() {      
        Account testJointAccount = [SELECT Id FROM Account Limit 1];
        OnboardingClientDetailsController.callToCrateCIF(testJointAccount.Id);
    }
    @isTest static void getCurrentUserDetailTest() {      
        OnboardingClientDetailsController.getCurrentUserDetail();
    }
    
    @isTest static void getSiteCodeDetailTest() {      
        OnboardingClientDetailsController.getSiteCodeDetail('');
    }
    @isTest static void validateClientInfoTest() {     
        Account testJointAccount = [SELECT Id FROM Account Limit 1]; 
        OnboardingClientDetailsController.validateClientInfo(testJointAccount.Id);
    }
    @isTest static void getSICCodesTest() {
        Integration_Translation__c It = [SELECT Id,system_Name__c,Value_Type__c FROM Integration_Translation__c LIMIT 1];
        It.system_Name__c = 'Onboarding';
         It.Value_Type__c = 'Onboarding Standard SIC Code';
        update It;
        OnboardingClientDetailsController.getSICCodes();
    }    
    @isTest static void getBusinessUnitsTest() {  
        Integration_Translation__c It = [SELECT Id,system_Name__c,Value_Type__c FROM Integration_Translation__c LIMIT 1];
        It.system_Name__c = 'Onboarding';
         It.Value_Type__c = 'Onboarding Business Unit';
        update It;    
        //OnboardingClientDetailsController.getBusinessUnits();
    }  */
    
    @isTest static void getFinancialYearsTest() {  
           Integration_Translation__c It = [SELECT Id,system_Name__c,Value_Type__c FROM Integration_Translation__c LIMIT 1];
        It.system_Name__c = 'Onboarding';
         It.Value_Type__c = 'Onboarding Financial Year End';
        update It;
        //OnboardingClientDetailsController.getFinancialYears();
    } 
    @isTest static void getSourceOfIncomeTest() { 
           Integration_Translation__c It = [SELECT Id,system_Name__c,Value_Type__c FROM Integration_Translation__c LIMIT 1];
        It.system_Name__c = 'Onboarding';
         It.Value_Type__c = 'Onboarding Source of Income';
        update It;
        //OnboardingClientDetailsController.getSourceOfIncome();
    } 
   
    @isTest
    static void TestUpdatedAccountTest(){
		Test.setMock(HttpCalloutMock.class, new ciupdateAccountUpdateMock_ApiRest(StringConstants.POSITIVE_STRING));
   
        Test.startTest();
         Account testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST22';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c='South Africa';
        testJointAccount.CIF__c = 'GREENJ 153';
        insert testJointAccount;
        

        Integration_Translation__c It = [SELECT Id,system_Name__c,Value_Type__c FROM Integration_Translation__c LIMIT 1];
        It.system_Name__c = 'Onboarding';
  		Account Acc = [Select Id,Name,LastName FROM Account WHERE Id =: testJointAccount.Id];  
        Acc.CASA_Reference_Number__c = '4589653';
        update Acc;
        
        Test.stopTest();
        Account updatedAcc = [SELECT Id,LastName FROM Account LIMIT 1];
        System.assertEquals(updatedAcc.LastName,testJointAccount.LastName  , 'update Operation Failed');
    }
    
}