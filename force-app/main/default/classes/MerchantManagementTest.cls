/*** This is a test class for MerchantManagement
* @author   Englarmerdge Mongwe, Jason Quevauvilliers, Danie Booysen
* @since    2020/05/28*/
@isTest
public class MerchantManagementTest {

    @isTest
    public static void testGetIdsMap() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        test.startTest();
        Map<String, String> responseMap = MerchantManagement.getIdsMap(opp.Id);
        test.stopTest();

        System.assertNotEquals(null, responseMap.get('applicationId'));
        System.assertNotEquals(null, responseMap.get('applicationProductMerchantId'));
    }

    //All Positive Cases
    @isTest
    private static void testCreateMASSAccount_AllPositive() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, true, true, true));

        test.startTest();
        MerchantManagement.createMASSAccount(opp.Id);
        test.stopTest();

        Application_Product_Merchant__c appProdMerchResp = [SELECT Status_MASS_Account__c, Status_Merchant_Plan__c, Status_POSH_Merchant__c FROM Application_Product_Merchant__c];
        System.assertEquals(StringConstants.INTEGRATION_STATUS_SUCCESS, appProdMerchResp.Status_MASS_Account__c);
        System.assertEquals(StringConstants.INTEGRATION_STATUS_SUCCESS, appProdMerchResp.Status_Merchant_Plan__c);
        // System.assertEquals(StringConstants.INTEGRATION_STATUS_SUCCESS, appProdMerchResp.Status_POSH_Merchant__c); // PJAIN: 20200721: Commented for Story W-005302
    }

    @IsTest
    //MASS Account negative response code, Merch Plan & POSH will not run
    private static void testCreateMASSAccount_NegativeMASSAccount1() {
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        OpportunityLineItem oppProd = [SELECT Id, Contact_Person__c FROM OpportunityLineItem WHERE OpportunityId =: opp.Id LIMIT 1];
        oppProd.Contact_Person__c = opp.AccountId;
        update oppProd;

        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, true, true, true));

        test.startTest();
        MerchantManagement.createMASSAccount(opp.Id);
        test.stopTest();

        Application_Product_Merchant__c appProdMerchResp = [SELECT Status_MASS_Account__c, Status_Merchant_Plan__c, Status_POSH_Merchant__c FROM Application_Product_Merchant__c];
        System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_MASS_Account__c);
        System.assertEquals(null, appProdMerchResp.Status_Merchant_Plan__c);
        System.assertEquals(null, appProdMerchResp.Status_POSH_Merchant__c);
    }

    //MASS Account negative response body, Merch Plan & POSH will not run
    @isTest
    private static void testCreateMASSAccount_NegativeMASSAccount2() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, false, false, false));

        test.startTest();
        MerchantManagement.createMASSAccount(opp.Id);
        test.stopTest();

        Application_Product_Merchant__c appProdMerchResp = [SELECT Status_MASS_Account__c, Status_Merchant_Plan__c, Status_POSH_Merchant__c FROM Application_Product_Merchant__c];
        System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_MASS_Account__c);
        System.assertEquals(null, appProdMerchResp.Status_Merchant_Plan__c);
        System.assertEquals(null, appProdMerchResp.Status_POSH_Merchant__c);
    }

    //MASS Account positive, Merch Plan & POSH negative response code
    @isTest
    private static void testCreateMASSAccount_NegativeMerchPlanAndPOSH() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.NEGATIVE_STRING, StringConstants.NEGATIVE_STRING, true, true, true));

        test.startTest();
        MerchantManagement.createMASSAccount(opp.Id);
        test.stopTest();

        Application_Product_Merchant__c appProdMerchResp = [SELECT Status_MASS_Account__c, Status_Merchant_Plan__c, Status_POSH_Merchant__c FROM Application_Product_Merchant__c];
        System.assertEquals(StringConstants.INTEGRATION_STATUS_SUCCESS, appProdMerchResp.Status_MASS_Account__c);
        System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_Merchant_Plan__c);
        // System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_POSH_Merchant__c); // PJAIN: 20200721: Commented for Story W-005302
    }

    //MASS Account already success, Merch Plan & POSH negative response body
    @isTest
    private static void testCreateMASSAccount_MASSAccountAlreadySuccessNegativeMerchPlanAndPOSH() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product_Merchant__c appProdMerch = [SELECT Id, Status_MASS_Account__c FROM Application_Product_Merchant__c LIMIT 1];
        appProdMerch.Status_MASS_Account__c = StringConstants.INTEGRATION_STATUS_SUCCESS;
        update appProdMerch;

        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, true, false, false));

        test.startTest();
        MerchantManagement.createMASSAccount(opp.Id);
        test.stopTest();

        Application_Product_Merchant__c appProdMerchResp = [SELECT Status_MASS_Account__c, Status_Merchant_Plan__c, Status_POSH_Merchant__c FROM Application_Product_Merchant__c];
        System.assertEquals(StringConstants.INTEGRATION_STATUS_SUCCESS, appProdMerchResp.Status_MASS_Account__c);
        System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_Merchant_Plan__c);
        // System.assertEquals(StringConstants.INTEGRATION_STATUS_FAILED, appProdMerchResp.Status_POSH_Merchant__c); // PJAIN: 20200721: Commented for Story W-005302
    }

    // PJAIN: 20200721: Added test methods to increase test coverage
    // Exception case 1
    @isTest
    private static void testCreateMASSAccount_Exception1() {
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, true, true, true));

        MerchantManagement createMASSAccountQueueable = new MerchantManagement(UserInfo.getUserId());

        test.startTest();
        System.enqueueJob(createMASSAccountQueueable);
        test.stopTest();
    }

    // PJAIN: 20200721: Added test methods to increase test coverage
    // Exception case 2
    @isTest
    private static void testCreateMASSAccount_Exception2() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, true, true, true));

        List<OpportunityLineItem> oppProdList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opp.Id, 1);
        delete oppProdList;
        MerchantManagement createMASSAccountQueueable = new MerchantManagement(opp.Id);

        test.startTest();
        System.enqueueJob(createMASSAccountQueueable);
        test.stopTest();
    }

    // PJAIN: 20200721: Added test methods to increase test coverage
    // Exception case 3
    @isTest
    private static void testCreateMASSAccount_Exception3() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MerchantManagement_Mock_ApiRest(StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, StringConstants.POSITIVE_STRING, true, true, true));

        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityOnboardId(opp.Id);
        delete appList;
        MerchantManagement createMASSAccountQueueable = new MerchantManagement(opp.Id);

        test.startTest();
        System.enqueueJob(createMASSAccountQueueable);
        test.stopTest();
    }

    @TestSetup
    static void createTestData(){

        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
        Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        //Address__c
        Address__c add = new Address__c();
        add.Address1__c = '12 Byls Bridge Boulevard';
        add.Address2__c = 'Highveld Ext 73';
        add.Address3__c = 'Centurion';
        add.Address4__c = 'Mpumalanga';
        add.Address5__c = '2200';
        insert add;

        //Merchant_Id__c
        Merchant_Id__c merchId = new Merchant_Id__c();
        merchId.Merchant_Id__c = '1037902';
        merchId.Merchant_Class__c = pricingTestDataFactory.parentOpportunityLineItem.Merchant_Class__c;
        insert merchId;

        //Application__c
        Application__c app = new Application__c();
        app.Opportunity__c = pricingTestDataFactory.opportunity.Id;
        app.Trading_Address__c = add.Id;
        app.Merchant_Id_Ref__c = merchId.Id;
        app.Source_of_Funds_Savings__c = 'SALARY/WAGES;COMMISION;MAINTENANCE/ ALIMONY;INVESTMENTS';
        insert app;

        //Contact
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Title = 'Mr.';
        testContact.Salutation = 'Mr.';
        testContact.CASA_Reference_Number__c = '1712994';
        testContact.CASA_Risk_Status__c = 'Low';
        testContact.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testContact.CASA_Screening_Status__c = 'Approved';
        testContact.CASA_Analyst_Comments__c = '30406';
        testContact.Occupation__c ='South Africa';
        testContact.Income_Source__c = 'Bonus';
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Income_Bracket__c = 'R20;000 - R75;000 pm';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Communication_Language__c = 'Afrikaans';
        testContact.ID_Type__c = 'SA Identity Document';
        testContact.Nationality__c = 'South Africa';
        testContact.Country_of_Origin__c = 'South Africa';
        testContact.Country_of_Residence__c = 'South Africa';
        testContact.Country_of_Birth__c = 'South Africa';
        testContact.MobilePhone = '0747003747';
        testContact.AssistantPhone = '0112232233';
        testContact.Fax = '0112232233';
        testContact.HomePhone = '0112232233';
        testContact.OtherPhone = '0112232233';
        testContact.Phone = '0112232233';
        testContact.AssistantName = 'Test Assistant';
        testContact.Email = 'test123@test.com';
        testContact.FinServ__CurrentEmployer__c = 'Current Employer';
        testContact.Initials__c = 'JJ';
        testContact.Maiden_Name__c = 'Monroe';
        testContact.MailingStreet = 'Test Mailing';
        testContact.OtherStreet = 'Test Other';
        insert testContact;

        //Prospect Account
        Account testProspectAccount = new Account();
        testProspectAccount.FirstName = 'Test';
        testProspectAccount.MiddleName = 'Test';
        testProspectAccount.LastName = 'Contact';
        testProspectAccount.PersonTitle = 'Mr.';
        testProspectAccount.CASA_Reference_Number__pc = '1712994';
        testProspectAccount.CASA_Risk_Status__pc = 'Low';
        testProspectAccount.CASA_Screening_Date__pc = Date.valueOf('2018-06-30');
        testProspectAccount.CASA_Screening_Status__pc = 'Approved';
        testProspectAccount.CASA_Analyst_Comments__pc = '30406';
        testProspectAccount.Occupation__pc = 'South Africa';
        testProspectAccount.Income_Source__pc = 'Bonus';
        testProspectAccount.Occupation_Status__pc = 'Full Time Employed';
        testProspectAccount.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        testProspectAccount.Occupation_Category__pc = 'Advertising';
        testProspectAccount.Communication_Language__pc = 'Afrikaans';
        testProspectAccount.ID_Type__pc = 'SA Identity Document';
        testProspectAccount.Nationality__pc = 'South Africa';
        testProspectAccount.Country_of_Origin__pc = 'South Africa';
        testProspectAccount.Country_of_Residence__pc = 'South Africa';
        testProspectAccount.Country_of_Birth__pc = 'South Africa';
        testProspectAccount.PersonMobilePhone = '0747003747';
        testProspectAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        testProspectAccount.ShippingCity = 'CAPE TOWN';
        testProspectAccount.ShippingCountry = 'South Africa';
        testProspectAccount.ShippingStreet = '01 PUERTA DEL SOL';
        testProspectAccount.ShippingPostalCode = '8001';
        testProspectAccount.BillingCity = 'GROBLERSDAL';
        testProspectAccount.BillingCountry = 'South Africa';
        testProspectAccount.BillingStreet = '01 MABOPANE SECTION';
        testProspectAccount.BillingPostalCode = '1060';
        insert testProspectAccount;

        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id =: testProspectAccount.Id].PersonContactId;

        //AccountContactRelation
        AccountContactRelation acr = new AccountContactRelation();
        acr.ContactId = testProspectAccountContactId;
        acr.AccountId = pricingTestDataFactory.account.Id;
        insert acr;

        //OpportunityLineItem
        PricingTestDataFactory.parentOpportunityLineItem.Contact_Person__c = acr.Id;
        update PricingTestDataFactory.parentOpportunityLineItem;

        //Application_Product_Merchant__c
        Application_Product_Merchant__c testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = pricingTestDataFactory.parentOpportunityLineItem.Id;
        //testAppProdMerch.Authorised_Signatory__c = acr.Id;
        testAppProdMerch.Cost_Centre__c = '9760';
        testAppProdMerch.Region__c = 'Eastern Cape';
        testAppProdMerch.Officer_Code__c = 'BB Eastern Cape';
        testAppProdMerch.MCC__c = '1761 - Roofing, Siding, and Sheet Metal Work Contractors';
        testAppProdMerch.Nett_Settlement__c = true;
        testAppProdMerch.Site_Code__c = '9790';
        testAppProdMerch.Waive_Stationery_Fee__c = true;
        testAppProdMerch.Deposit_Monitoring__c = true;
        testAppProdMerch.Number_of_Days__c = '30 days';
        testAppProdMerch.Selected_Cards__c = 'Cash Send;Electron (Visa Debit cards);Fleet;Garage Card and Petrol;Mastercard Debit;Mastercard Maestro;Mastercard Pre-paid;Pure Cash;Visa Debit Card;Visa pre-paid';
        testAppProdMerch.AMEX_Merchant_Number__c = '123';
        testAppProdMerch.Group_ID__c = 'A00 - GENERAL';
        testAppProdMerch.Configuration__c = 'ABSA DEVICES-P';
        insert testAppProdMerch;

        //Device_Merchant__c
        Device_Merchant__c device = new Device_Merchant__c();
        device.Application_Product_Merchant__c = testAppProdMerch.Id;
        device.Branch_ID__c = '123';
        device.Dial_Time__c = '6:00 PM';
        device.Serial_Number__c = '1234567';
        insert device;

        //Payment_Plan__c
        Payment_Plan__c paymentPlan = new Payment_Plan__c();
        paymentPlan.Branch_Code__c = 632005;
        paymentPlan.Account_Number__c = '001';
        paymentPlan.Method__c = 'EFT';
        paymentPlan.Status__c = 'New';
        paymentPlan.Application__c = app.Id;
        paymentPlan.Type__c = 'Merchant Product';
        paymentPlan.Type_of_Details__c = 'Business Bank';
        insert paymentPlan;

        //Accepted_Card__c
        Accepted_Card__c acceptedCard = new Accepted_Card__c();
        acceptedCard.Name = StringConstants.MERCHANT_AMERICAN_EXPRESS_CARD;
        acceptedCard.Price_Override__c = 0;
        acceptedCard.Plan_Type__c = 'S01';
        acceptedCard.Transaction_Group__c = pricingTestDataFactory.transactionGroup.Id;
        acceptedCard.Type__c = StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD + ';' +  StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_FEE_CATEGORY;
        insert acceptedCard;

        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new List<String> {
            MPScreateMASSAccountV2_IH_v1.INTEGRATION_SERVICE_NAME, MpsCreateMerchantPlanv1_IH_v1.INTEGRATION_SERVICE_NAME, MpsCreatePoshMerchantv3_IH_v1.INTEGRATION_SERVICE_NAME
        });
    }
}