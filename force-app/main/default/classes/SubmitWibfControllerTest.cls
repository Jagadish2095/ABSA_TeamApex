/**
* Test class for SubmitWibfController
* @author  Kyle Alexander
* @created 2018-10-24
*/

@IsTest
public class SubmitWibfControllerTest {

    public static testMethod void testWbifController(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        
        SubmitWibfController.checkInitValidity(testDataFactory.testOpportunity.Id);
        SubmitWibfController.checkPRIValidity(testDataFactory.testOpportunity.Id);
        SubmitWibfController.getWBIFErrors(testDataFactory.testOpportunity.Id);
        SubmitWibfController.validateWibf(testDataFactory.testOpportunity.Id);
        SubmitWibfController.retrievePriNumber(testDataFactory.testOpportunity.Id);
        SubmitWibfController.submitWibf(testDataFactory.testOpportunity.Id);
        SubmitWibfController.validateWibf(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
    }    
    
    public static testMethod void testWbifControllerRetrievePri(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
                
        Test.setMock(HttpCalloutMock.class, new InsertOrUpdatePRICASAMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        
        SubmitWibfController.retrievePriNumber(testDataFactory.testOpportunity.Id);
        
        testDataFactory.testOpportunity.Will_Number__c = null;
        update testDataFactory.testOpportunity;
        
        SubmitWibfController.validateWibf(testDataFactory.testOpportunity.Id);
        SubmitWibfController.submitWibf(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
    }    
    
    public static testMethod void testWbifControllerSubmit(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        
        SubmitWibfController.submitWibf(testDataFactory.testOpportunity.Id);
        
        SubmitWibfController.updateOpportunityStatus(testDataFactory.testOpportunity.Id);
        
        SubmitWibfController.checkUltimateProtectorStatus(testDataFactory.testOpportunity.Id);
        
        Test.stopTest();
    }
    
    @isTest static void insertIntegrationTranslations(){
        //Create countryOfBirth record
        Integration_Translation__c countryOfBirth = new Integration_Translation__c();
        countryOfBirth.Name = 'South Africa';
        countryOfBirth.Internal_Value__c = 'South Africa';
        countryOfBirth.External_Value__c = 'SO003';
        countryOfBirth.System_Name__c = StringConstants.WBIF_STRING;
        countryOfBirth.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfBirth.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        
        
        //Create countryOfResidence record
        Integration_Translation__c countryOfResidence = new Integration_Translation__c();
        countryOfResidence.Name = 'South Africa';
        countryOfResidence.Internal_Value__c = 'South Africa';
        countryOfResidence.External_Value__c = 'SO003';
        countryOfResidence.System_Name__c = StringConstants.WBIF_STRING;
        countryOfResidence.Value_Type__c = StringConstants.FIELD_COUNTRY_STRING;
        countryOfResidence.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        
        //Create maritalStatus record
        Integration_Translation__c maritalStatus = new Integration_Translation__c();
        maritalStatus.Name = 'Married';
        maritalStatus.Internal_Value__c = 'Married';
        maritalStatus.External_Value__c = 'Married';
        maritalStatus.System_Name__c = StringConstants.WBIF_STRING;
        maritalStatus.Value_Type__c = StringConstants.FIELD_MARITAL_STATUS_STRING;
        maritalStatus.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;   
        
        //Create nationality record
        Integration_Translation__c nationality = new Integration_Translation__c();
        nationality.Name = 'South African';
        nationality.Internal_Value__c = 'South Africa';
        nationality.External_Value__c = 'SOU01';
        nationality.System_Name__c = StringConstants.WBIF_STRING;
        nationality.Value_Type__c = StringConstants.FIELD_NATIONALITY_STRING;
        nationality.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        
        //Create incomeSource record
        Integration_Translation__c incomeSource = new Integration_Translation__c();
        incomeSource.Name = 'Bonus';
        incomeSource.Internal_Value__c = 'Bonus';
        incomeSource.External_Value__c = '22';
        incomeSource.System_Name__c = StringConstants.WBIF_STRING;
        incomeSource.Value_Type__c = StringConstants.FIELD_SOURCE_OF_INCOME_STRING;
        incomeSource.Direction__c = StringConstants.OUTBOUND_RECORD_TYPE;
        
        insert countryOfBirth;
        insert countryOfResidence;
        insert maritalStatus;
        insert nationality;
        insert incomeSource;
    }
}