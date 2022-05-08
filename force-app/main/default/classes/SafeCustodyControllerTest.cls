@isTest
public class SafeCustodyControllerTest {
    
    public static testMethod void testcheckPaymentPreferenceSetTypeonApplication(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();        
        SafeCustodyController.checkPaymentPreferenceSetTypeonApplication(testDataFactory.testOpportunity.id);
        Test.stopTest();
        
    }
    
    public static testMethod void testapplicationExistsByOpportunityId() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();        
        SafeCustodyController.applicationExistsByOpportunityId(testDataFactory.testOpportunity.id);
        Test.stopTest();
    }
    
    public static testMethod void testCheckBankAccount() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.checkBankAccount('4048075451', '632005', 'Cheque');
        Test.stopTest();
    }
    
    public static testMethod void testCheckIfBankIsOnAVSList() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.checkIfBankIsOnAVSList('NEDBANK');
        Test.stopTest();
    }
    
    static testMethod void testCheckBankingDetailsValidated() {

        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        
        //Submit Pending on Drafting Fee
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);
        
        //Submit Pending on Safe Custody
        SafeCustodyController.updateSafeCustodyFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);

        SafeCustodyController.checkBankingDetailsValidated(testOpportunity.Id);
        System.assertEquals(false, SafeCustodyController.checkBankingDetailsValidated(testOpportunity.Id));

    }

    static testMethod void testSetBankingDetailsValidationStatus() {

        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        //Submit Pending
        DraftingFeeController.submitDraftingFeeStatus(testOpportunity.Id, 'Pending');
        //Actual
        String result = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id).get(0).Drafting_Fee_Status__c;
        System.assertEquals('Valid', result);

        SafeCustodyController.setBankingDetailsValidationStatus(testOpportunity.Id, 'Valid');
        List<Application__c> applicationsList = new ApplicationsSelector().selectByOpportunityId(testOpportunity.Id);

        if (!applicationsList.isEmpty()) {

            System.assertEquals(true, applicationsList.get(0).Safe_Custody_Banking_Details_Validated__c);
            
        }

    }
    
    public static testMethod void testCopyDraftingPaymentPlanAsSafeCustodyPaymentPlan() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Test.startTest();
        SafeCustodyController.copyDraftingPaymentPlanAsSafeCustodyPaymentPlan(testDataFactory.testOpportunity.id);
        Test.stopTest();
    }
    
    public static testMethod void testCopyPaymentPlanDetail() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Test.startTest();
        SafeCustodyController.copyPaymentPlanDetail(testDataFactory.testOpportunity.id, '4048075451', 'Cheque', 'NEDBANK', '632005', 'ABSA ELECTRONIC SETTL (632005)', 'Cheque - 1573017159', 'Monthly', 150.00, 'Debit Order', 'New', 'Will Safe Custody Fee');
        Test.stopTest();
    }
    public static testMethod void NegativetestCopyPaymentPlanDetail() {
        
        Test.startTest();
        SafeCustodyController.copyPaymentPlanDetail('0061l00000Dqk4xAAB', '4048075451', 'Cheque', 'NEDBANK', '632005', 'ABSA ELECTRONIC SETTL (632005)', 'Cheque - 1573017159', 'Monthly', 150.00, 'Debit Order', 'New', 'Will Safe Custody Fee');
        Test.stopTest();
    }
    
    public static testMethod void testExistsPaymentPlan() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.existsPaymentPlan(testDataFactory.testOpportunity.id, 'Will Safe Custody Fee');
        Test.stopTest();
    }
    
    public static testMethod void testgGetPaymentMethod() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.getPaymentMethod(testDataFactory.testOpportunity.id, 'Will Safe Custody Fee');
        Test.stopTest();
    }
    
    public static testMethod void testGetSelectOptions() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.getSelectOptions(testDataFactory.testPaymentPlan, 'Method__c');
        Test.stopTest();
    }
    
    public static testMethod void testSelectByOpportunityId() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.selectByOpportunityId(testDataFactory.testOpportunity.id);
        Test.stopTest();
    }
    
    public static testMethod void testSubmitPaymentPlanDetail() {
        // WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Test.startTest();
        SafeCustodyController.submitPaymentPlanDetail(testDataFactory.testOpportunity.id, '4048075451', 'Cheque', 'NEDBANK', '632005', 'ABSA ELECTRONIC SETTL (632005)', 'Cheque - 1573017159', 'Monthly', 150.00, 'Debit Order', 'New', 'Will Safe Custody Fee');
        Test.stopTest();
    }
    
    public static testMethod void negativeTestSubmitPaymentPlanDetail() {
        
        Map <String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map <String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map <String, Schema.RecordTypeInfo> AssetRecordTypeMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map <String, Schema.RecordTypeInfo> LookupRecordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Map <String, Schema.RecordTypeInfo> AplicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        //User
        String orgId = userInfo.getOrganizationId();
        String dateString = Datetime.now().format('yyyMMddHHmmss');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = dateString + randomInt + '@test' + orgId + '.org';
        User testUser = new User();
        testUser.FirstName = 'WillTestUser';
        testUser.LastName = 'WillTtestData';
        testUser.Email = uniqueName;
        testUser.Username = uniqueName;
        testUser.BRID__c = '45789';
        testUser.EmailEncodingKey = 'ISO-8859-1';
        testUser.Alias = 'WillUser';
        testUser.TimeZoneSidKey = 'Africa/Johannesburg';
        testUser.LocaleSidKey = 'en_US';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.ProfileId = '00e1r000001zvFKAAY' ;
        testUser.Advisor_Code__c ='A12345';
        testUser.mobilePhone='0658992600';
        insert testUser;
        
         
        //testSite
        Site__c testSite=new Site__c();
        testSite.Name='Absa Regional Office Private Bank,(B2509),Umhlanga Ridgeside,33 Richefond Circle';
        testSite.Unique_Site_Code__c='B2509';
       // testSite.RecordTypeId =SiteRecordTypeMap.get('Branch Site').getRecordTypeId();
        testSite.Active__c= true;
        testSite.Site_Code__c='2509';
        insert testSite;
        
        //testAdviser
        Employee__c testAdviser=new Employee__c();
        testAdviser.Name='testUser';
        testAdviser.Initials__c='Test';
        testAdviser.Surname__c='UserTest';
        testAdviser.AB_Number__c='abit456';
        testAdviser.Advisor_Code__c='A12345';
        testAdviser.BRID__c='BO345633';
        testAdviser.Email__c='TestUser@gmail.com';
        testAdviser.Employee_Number__c='435435435';
        testAdviser.Mobile__c='0658992600';
        insert testAdviser;
        //Account
        Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        system.debug('testAccount.RecordTypeId: '+testAccount.RecordTypeId);
        testAccount.CASA_Reference_Number__c = '1712994';
        testAccount.CASA_Risk_Status__c = 'Low';
        testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccount.CASA_Screening_Status__c = 'Approved';
        testAccount.CASA_Analyst_Comments__c = '30406';
        testAccount.PersonMobilePhone = '+270747003747';
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
        testAccount.PersonTitle = 'Mr';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.Phone = '+270114453322';
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
        insert testAccount;
        
        //Opportunity
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAccount.id;
        testOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('Wills').getRecordTypeId();
        testOpportunity.Adviser_AB_Number__c = 'TEST001';
        testOpportunity.Name = 'TestClass Wills';
        // testOpportunity.Product__c = 'ANY AMOUNT - ANY AMOUNT (NOT LISTED)';
        testOpportunity.LeadSource = 'Siebel Campaign';
        // testOpportunity.Sub_Product__c = '';
        testOpportunity.Type = 'Cross Sell';
        testOpportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunity.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunity.StageName = 'Registration';
        testOpportunity.CloseDate = Date.today() + 10;
        testOpportunity.Will_Number__c = '41000049999';
        testOpportunity.Commission_1st_Year__c = 2000;
        testOpportunity.Commission_2nd_Year__c = 590;
        testOpportunity.Debit_Order_Debit_Day__c='30';
        testOpportunity.Debit_Order_Salary_Day__c='10';
        testOpportunity.DebitOrderThirdParty__c=true;
        testOpportunity.Commencement_Date__c = Date.today();
        testOpportunity.Debit_Order_Date__c = Date.today();
        testOpportunity.CASA_Status__c='Valid';
        testOpportunity.Risk_Status__c = 'Valid';
        testOpportunity.Adviser__c=testUser.Id;
        testOpportunity.Adviser_Employee__c=testAdviser.Id;
        testOpportunity.Site__c=testSite.Id;
        insert testOpportunity;
        
        //Application__c
        Application__c testApplication = new Application__c();
        testApplication.Opportunity__c = testOpportunity.Id;
        testApplication.Preferred_Email__c='himanshu.nimje@absa.africa';
        testApplication.Preferred_SMS__c='065892600';
        testApplication.Preferred_Communication_Method__c='Email';
        testApplication.RecordTypeId= AplicationRecordTypeMap.get('Wills').getRecordTypeId();
        testApplication.Drafting_Fee_Status__c = 'Valid';
        testApplication.Communication_Preference_Status__c = 'Valid';
        testApplication.Safe_Custody_Status__c = 'Valid';
        testApplication.Registration_Status__c = 'New';
        testApplication.Will_Stock_Confirmation__c=false; 
        insert testApplication;
        
        Test.startTest();
        SafeCustodyController.submitPaymentPlanDetail(testOpportunity.id, '4048075451', 'Cheque', 'NEDBANK', '632005', 'ABSA ELECTRONIC SETTL (632005)', 'Cheque - 1573017159', 'Monthly', 150.00, 'Debit Order', 'New', 'Will Safe Custody Fee');
        Test.stopTest();
    }    
    
    public static testMethod void testUpdateApplication() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.updateApplication(testDataFactory.testOpportunity.id, 'Yes', 'Yes');
        Test.stopTest();
    }
    
    public static testMethod void testValidateAbsaBankAccount() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        SafeCustodyController.validateAbsaBankAccount('4048075451', 'Cheque', '632005', '150.00');
        Test.stopTest();
    }
    
    /*   public static testMethod void testValidateAVSBankAccount() {
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
Test.startTest();
SafeCustodyController.validateAVSBankAccount(testDataFactory.testOpportunity.id, '4048075451', '632005', 'ABSA BANK LIMITED', 'Cheque');        
Test.stopTest();
} */
    
    /* public static testMethod void testSubmitSafeCustodyStatus() {
WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
Test.startTest();      
SafeCustodyController.submitSafeCustodyStatus(testDataFactory.testOpportunity.id, 'Valid');
Test.stopTest();
} */
    
    public static testMethod void testSelectByTypeByApplicationId() {
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Test.startTest();        
        SafeCustodyController.selectByTypeByApplicationId(testDataFactory.testOpportunity.id, 'Will Safe Custody Fee');
        Test.stopTest();
    }
    
    
    public static testMethod void testvalidateAVSBankAccount() {
        new WillsTestDataFactory();
        Opportunity testOpportunity = [SELECT Id FROM Opportunity LIMIT 1];
        //new WimiTestDataFactory();
        //Opportunity testOpportunity = []
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Test.startTest();
        SafeCustodyController.validateAVSBankAccount(testOpportunity.Id, '4048075451', '632005', 'ABSA BANK LIMITED', 'Savings');
        Test.stopTest();
        
    } 
    
    public static testMethod void testcheckIfBankIsOnAVSList2(){
        Test.startTest();        
        //SafeCustodyController.checkIfBankIsOnAVSList('NEDBANK');
        Test.stopTest();
    }
    
    public class QueueHttpMock implements HttpCalloutMock {
        
        HttpResponse[] responses = new HttpResponse[0];
        
        public void addResponse(HttpResponse response) {
            responses.add(response);
        }
        
        public void addResponse(String response) {
            addResponse(response, 200, 'application/json');
        }
        
        public void addResponse(String response, Integer code, String contentType) {
            HttpResponse res = new HttpResponse();
            res.setBody(response);
            res.setStatusCode(code);
            res.setHeader('Content-Type', contentType);
            responses.add(res);
        }
        
        public HttpResponse respond(HttpRequest request) {
            return responses.remove(0);
        }
    }
}