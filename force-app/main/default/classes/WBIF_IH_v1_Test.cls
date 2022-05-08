/**
 * @description       : 
 * @author            : poulami.banerjee@absa.africa
 * @last modified on  : 2021-09-28
 * @last modified by  : poulami.banerjee@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-07-12   poulami.banerjee@absa.africa   Initial Version
**/
@IsTest
public class WBIF_IH_v1_Test {
        
    @isTest 
    static void getWBIFQuoteSummaryPositiveResponse() {
        
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
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);

        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest(); 
    }
    
    @isTest 
    static void getWBIFQuoteSummaryNegativeQuoteIdResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        testDataFactory.testOpportunity.SyncedQuoteId = null;
        Update testDataFactory.testOpportunity;

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);

        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    
    @isTest 
    static void getWBIFQuoteSummaryNegativeUnableToFindOppResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Opportunity
        Opportunity testOpportunity1 = new Opportunity();
        testOpportunity1.Adviser_AB_Number__c = 'TEST001';
        testOpportunity1.Name = 'EPP';
        testOpportunity1.Product__c = 'Estate Provider Plan';
        testOpportunity1.LeadSource = 'Siebel Campaign';
        testOpportunity1.Sub_Product__c = 'Estate Provider Plan';
        testOpportunity1.Type = 'Cross Sell';
        testOpportunity1.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunity1.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunity1.StageName = 'Intro/Purpose';
        testOpportunity1.CloseDate = Date.today() + 10;
        testOpportunity1.Will_Number__c = '12345678912';
        testOpportunity1.Commission_1st_Year__c = 2000;
        testOpportunity1.Commission_2nd_Year__c = 590;
        testOpportunity1.Debit_Order_Debit_Day__c='30';
        testOpportunity1.Debit_Order_Salary_Day__c='10';
        testOpportunity1.DebitOrderThirdParty__c=true;
        testOpportunity1.Commencement_Date__c = Date.today();
        testOpportunity1.Debit_Order_Date__c = Date.today();
        insert testOpportunity1;

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testOpportunity1);
        
        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    
    @isTest
    static void getWBIFQuoteSummaryNoTranslationsResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void getWBIFQuoteSummaryNoIntegrationSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    
    @isTest
    static void getWBIFValidatePositiveResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        System.assertNotEquals(null, tuser);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFValidate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        //System.assertEquals(200, initialResponse.statusCode);
        //System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    
    @isTest 
    static void getWBIFValidateNoIntegrationSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        /**** Added by chenna as part of DD Outbound success sale on 19/11/2020 ******/
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFValidate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    /**
     * @description getWBIFSubmitPolicyPositiveResponse description
     *
     */
    @isTest 
    static void getWBIFSubmitPolicyPositiveResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
		/**** Added by chenna as part of DD Outbound success sale on 19/11/2020 ******/
        list<Quotelineitem> listQLI = new list<QuoteLineItem>();
        for(Quotelineitem q: [select id,benefit__c from quotelineitem]){
            q.benefit__c='Grocery Benefit';
            listQLI.add(q);
        }
        update listQLI;
        
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));

        Test.startTest();
        
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFSubmitPolicy(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(200, initialResponse.statusCode);

        Test.stopTest();
    }
    /**
     * @description getWBIFSubmitPolicyNoIntegrationSettings description
     *
     */
    @isTest 
    static void getWBIFSubmitPolicyNoIntegrationSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        /**** Added by chenna as part of DD Outbound success sale on 19/11/2020 ******/
		Opportunity opp=new Opportunity();
        opp=testDataFactory.testOpportunity;
        opp.recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();   
        update opp;
        opp = [select id, recordtype.name, SyncedQuoteId  from opportunity where recordtypeid =: opp.recordtypeid limit 1];
        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFSubmitPolicy(tuser,testDataFactory.testAccount,opp);
        
        System.assertEquals(500, initialResponse.statusCode);

        Test.stopTest();
    }
    /**
     * @description PolicyCreateFailResponse description
     *
     */
    @isTest
    static void PolicyCreateFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Policy Create Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void AddDependentSpouseFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Add Dependent Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void AddBenefitFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__c,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Add Benefit Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void CalculateFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__c,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        System.assertNotEquals(null, tuser);
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Calculate Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFQuoteSummary(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        //System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void AddBeneficicaryFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__c,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Add Beneficiary Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFValidate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void ValidateFailResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__c,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, 'Validate Fail'));

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.getWBIFValidate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest
    static void PolicySubmitNoMock() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2, StringConstants.WBIF_POLICY_ADD_BENEFIT_V2, StringConstants.WBIF_POLICY_ADD_DEPENDENT, StringConstants.WBIF_POLICY_ADD_BENEFICIARY, StringConstants.WBIF_VALIDATE_POLICY, StringConstants.WBIF_SUBMIT_POLICY, StringConstants.GET_JOINT_PARTICIPANT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});

        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__c,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];

        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 submitResponse = WBIF_IH_v1.getWBIFSubmitPolicy(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, submitResponse.statusCode);
        Test.stopTest();
        
    }
    
    @isTest 
    static void wbifPolicyCreatePositiveResponse(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.wbifPolicyCreate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(200, initialResponse.statusCode);
        
        Test.stopTest(); 
    }
    
    @isTest 
    static void wbifPolicyCreateNoTranslations(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration records
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.NEGATIVE_STRING, ''));
        
        Test.startTest();
        //1 - 5 services
        WBIF_IB_String_v1 initialResponse = WBIF_IH_v1.wbifPolicyCreate(tuser,testDataFactory.testAccount,testDataFactory.testOpportunity);
        
        System.assertEquals(500, initialResponse.statusCode);
        
        Test.stopTest(); 
    }
     @isTest
     static void wbifCalculatePositiveResponse(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        //Create ProductCode Map
        Map<String, String> productCodePriceMap = new Map<String, String>();
        productCodePriceMap.put('UEF', '10000') ;
        productCodePriceMap.put('UEFS', '10000') ;
        productCodePriceMap.put('UBR', '10000') ;
        productCodePriceMap.put('UBRS', '10000') ;
        productCodePriceMap.put('UFN', '30000') ;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        Test.startTest();
        
        String policyCreateString = '{"Policy_CreateResponse":{"Policy_CreateResult":{"GUID":"eadf8b9e-3df8-4858-b429-1dce5a294078","Application":{"GUID":"b0f6e622-b6d1-4a6f-9c9d-b3156d354600","Agent":{"GUID":"11061b56-17de-43c2-b3b8-769fa2b68e52","DistributionChannel":"BranchSales"},"Consultant":{"GUID":"a99cde03-cefa-4b8c-a907-fd112625e7b3","ABNumber":"ABNMAYW","Branch":"NOT USING ARAS","EmployeeNumber":"9563284","Name":"BDP DEVELOPER","SiteCode":"8392"},"Declaration":{"GUID":"8b154aa6-976f-4967-9ef7-72a4a359b35f","IsFit":"true","IsSupervised":"true","Advice":"false"},"DistributionChannel":"BranchSales","IsBranchSales":"true","IsClientPresent":"true","Replacement":{"GUID":"0059bea9-bfa7-410c-af4e-ee1e6a09287c","Date":"2019-10-07T13:24:48.4937319+02:00","IsReplacement":"false"}},"Cover":"0","Loadings":"0","MainMember":{"GUID":"f2b94e4b-eaa7-4938-82f8-b91485a59a02","Age":"49","DateOfBirth":"1970-06-12T00:00:00","FirstName":"BRIAN","FullName":"PICASSO, BRIAN","Gender":"Male","Initials":"B","MemberType":"Individual","Name":"PICASSO, BRIAN","Names":"BRIAN, B","RsaIdNumber":"7006129667134","ShortName":"B PICASSO","Surname":"PICASSO","Title":"Mr","Benefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"BenefitOption":"0","Benefits":{"Benefit":[{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"}]},"Cover":"0","Loadings":"0","Premium":"0","CasaReferenceNumber":"1629135","CifClientCode":"PICASB 001","ContactDetails":{"GUID":"2e3603c6-360d-4ce0-8d38-0969342169ac","CellTelephone":"0791818451","HomeTelephone":"(011) 1245789","OptIn":"false","PhysicalAddress":{"GUID":"d5abed63-c7cd-4e3f-84e8-c5445c59766c","Line1":"233 LUPHONDWANA STREET","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"233 LUPHONDWANA STREET, KING WILLIAMS TOWN"},"PostalAddress":{"GUID":"6e3c1dd5-d9e6-410f-8a14-d0889f8d83a3","Line1":"34 LUPHONDWENI LOCATION STREE","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"34 LUPHONDWENI LOCATION STREE, KING WILLIAMS TOWN"}},"CountryOfBirth":"SO003","CountryOfResidence":"SO003","IncomeBand":"Band1","IsIndividual":"true","IsSouthAfrican":"true","Language":"English","MaritalStatus":"Single","Nationality":"SOU01","SourceOfFunds":"20","SourceOfIncome":"20","IsStaff":"false"},"PolicyBenefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"PolicyInfo":{"GUID":"b18a0292-c4a4-4d34-bec4-d3101e749134","Application":"2019-10-07T13:24:48.4937319+02:00","ContractID":"UL01","ContractOptionID":"10000001","Disclosure":"false"},"Premium":"0","TotalCommission":"0","TotalCover":"0","TotalPremium":"0","ModuleID":"WIMAL00500"}}}';
        WBIF_IB_String_v1 policyCreateResp = new WBIF_IB_String_v1();
        policyCreateResp = (WBIF_IB_String_v1)policyCreateResp.deserialize( policyCreateString, WBIF_IB_String_v1.class );
        
        WBIF_IB_String_v1 calculateResp = WBIF_IH_v1.wbifPolicyCalculate(policyCreateResp, productCodePriceMap, '1990-09-01', '29');
        
        System.assertEquals(200, calculateResp.statusCode);
        
        Test.stopTest();
    }
    
     /***** Added By Chenna as part of DD Outbound Success sale on 19/11/2020 ****/
    /**
     * @description wbifCalculateNegativeResponse description
     *
     */
     @isTest
     static void wbifCalculateNegativeResponse(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.WBIF_POLICY_CREATE, StringConstants.WBIF_CALCULATE_V2});
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER_ADAPT360, new list<String> {StringConstants.ADAPT360_STRING});
        
        //Creating user record
        User tuser = [SELECT Id,Name,Advisor_Code__C,ProfileId,AB_Number__c,Email,UserRoleId,EmployeeNumber,UserType,ManagerId,IsFit__c,IsSupervised__c,BRID__c,SiteCode__c FROM User WHERE id = :Userinfo.getUserId()];
        //Create ProductCode Map
        Map<String, String> productCodePriceMap = new Map<String, String>();
        productCodePriceMap.put('UEF', '10000') ;
        productCodePriceMap.put('UEFS', '10000') ;
        productCodePriceMap.put('UBR', '10000') ;
        productCodePriceMap.put('UBRS', '10000') ;
        productCodePriceMap.put('UFN', '30000') ;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new WBIFMock_ApiRest(StringConstants.POSITIVE_STRING, ''));
        
        Test.startTest();
        
        String policyCreateString = '{"Policy_CreateResponse":{"Policy_CreateResult":{"GUID":"eadf8b9e-3df8-4858-b429-1dce5a294078","Application":{"GUID":"b0f6e622-b6d1-4a6f-9c9d-b3156d354600","Agent":{"GUID":"11061b56-17de-43c2-b3b8-769fa2b68e52","DistributionChannel":"BranchSales"},"Consultant":{"GUID":"a99cde03-cefa-4b8c-a907-fd112625e7b3","ABNumber":"ABNMAYW","Branch":"NOT USING ARAS","EmployeeNumber":"9563284","Name":"BDP DEVELOPER","SiteCode":"8392"},"Declaration":{"GUID":"8b154aa6-976f-4967-9ef7-72a4a359b35f","IsFit":"true","IsSupervised":"true","Advice":"false"},"DistributionChannel":"BranchSales","IsBranchSales":"true","IsClientPresent":"true","Replacement":{"GUID":"0059bea9-bfa7-410c-af4e-ee1e6a09287c","Date":"2019-10-07T13:24:48.4937319+02:00","IsReplacement":"false"}},"Cover":"0","Loadings":"0","MainMember":{"GUID":"f2b94e4b-eaa7-4938-82f8-b91485a59a02","Age":"49","DateOfBirth":"1970-06-12T00:00:00","FirstName":"BRIAN","FullName":"PICASSO, BRIAN","Gender":"Male","Initials":"B","MemberType":"Individual","Name":"PICASSO, BRIAN","Names":"BRIAN, B","RsaIdNumber":"7006129667134","ShortName":"B PICASSO","Surname":"PICASSO","Title":"Mr","Benefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"BenefitOption":"0","Benefits":{"Benefit":[{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"}]},"Cover":"0","Loadings":"0","Premium":"0","CasaReferenceNumber":"1629135","CifClientCode":"PICASB 001","ContactDetails":{"GUID":"2e3603c6-360d-4ce0-8d38-0969342169ac","CellTelephone":"0791818451","HomeTelephone":"(011) 1245789","OptIn":"false","PhysicalAddress":{"GUID":"d5abed63-c7cd-4e3f-84e8-c5445c59766c","Line1":"233 LUPHONDWANA STREET","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"233 LUPHONDWANA STREET, KING WILLIAMS TOWN"},"PostalAddress":{"GUID":"6e3c1dd5-d9e6-410f-8a14-d0889f8d83a3","Line1":"34 LUPHONDWENI LOCATION STREE","Line3":"KING WILLIAMS TOWN","PostalCode":"5601","SingleLine":"34 LUPHONDWENI LOCATION STREE, KING WILLIAMS TOWN"}},"CountryOfBirth":"SO003","CountryOfResidence":"SO003","IncomeBand":"Band1","IsIndividual":"true","IsSouthAfrican":"true","Language":"English","MaritalStatus":"Single","Nationality":"SOU01","SourceOfFunds":"20","SourceOfIncome":"20","IsStaff":"false"},"PolicyBenefit":{"GUID":"41defdcd-d932-4b85-8d55-edc7b73ff232","Cover":"0","CoverIncrease":"0","Loadings":"0","Option":"0","Premium":"0","PremiumIncrease":"0","TotalPremium":"0"},"PolicyInfo":{"GUID":"b18a0292-c4a4-4d34-bec4-d3101e749134","Application":"2019-10-07T13:24:48.4937319+02:00","ContractID":"UL01","ContractOptionID":"10000001","Disclosure":"false"},"Premium":"0","TotalCommission":"0","TotalCover":"0","TotalPremium":"0","ModuleID":"WIMAL00500"}}}';
        WBIF_IB_String_v1 policyCreateResp = new WBIF_IB_String_v1();
        policyCreateResp = (WBIF_IB_String_v1)policyCreateResp.deserialize( policyCreateString, WBIF_IB_String_v1.class );
        
        WBIF_IB_String_v1 calculateResp = WBIF_IH_v1.wbifPolicyCalculate(policyCreateResp, productCodePriceMap, '1990-09-01', '29');
        
        System.assertEquals(500, calculateResp.statusCode);
        
        Test.stopTest();
    }
    
}