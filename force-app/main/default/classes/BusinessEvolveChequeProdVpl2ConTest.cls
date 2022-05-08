/**
 * @description       :
 * @last modified on  : 2021-11-29
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 *
**/
@isTest
public class BusinessEvolveChequeProdVpl2ConTest{
    /**
* @description dataCreation
*/
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

        Financial_Product__c finProd = new Financial_Product__c();
        finProd.Name = 'Test Product';
        finProd.Business_Unit__c = 'Retail Banking';
        finProd.Product_Type__c = 'Retail Banking';
        insert finProd;

        Lead leadRec = new Lead();
        leadRec.FirstName = 'Jane';
        leadRec.LastName = 'Doe';
        leadRec.Financial_Product__c = finProd.Id;
        insert leadRec;

        Application__c app = new Application__c();
        app.Opportunity__c = testOpp.id;
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = 'Mega U';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
        app.Surplus_Cash__c = 'Fixed Deposits';
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-BACKED Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();

        insert app;

        Account testJointAccount = new Account();
        //testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST MR JA & TEST MRS J';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c = 'South Africa';
        testJointAccount.CIF__c = 'NAIARA+001';
        insert testJointAccount;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.AccountId = account.Id;
        insert testContact;

        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = testJointAccount.Id;
        acr.ContactId = testContact.Id;
        insert acr;

        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Onboarding';
        opp2.CloseDate = Date.today();
        opp2.StageName = 'New';
        opp2.AccountId = account.Id;
        insert opp2;

        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Sales';
        opp3.CloseDate = Date.today();
        opp3.StageName = 'New';
        opp3.AccountId = account.Id;
        insert opp3;

        IntegrationTestDataFactory.insertIntegrationTranslations();
    }

     /** 
* @description updateOpportunityAndApplicationTest
*/
    @isTest static void updateOpportunityAndApplicationTest(){
        Account newClientRecord = [SELECT id, Name
                                   FROM Account
                                   LIMIT 1];
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    LIMIT 1];
        Application__c applicationRecord = [SELECT Id, Name
                                            From Application__c
                                            LIMIT 1];

        Test.startTest();
        applicationRecord.Decision__c = 'Request New Terms';
        update applicationRecord;
        newOppRecord.StageName = 'Price Negotiation';
        update newOppRecord;
        try{
            String applicationId = BusinessEvolveChequeProdVpl2Con.updateOpportunityAndApplication(newOppRecord.id, applicationRecord);
        } catch (Exception e){
            //System.debug('Exception::' + e.getMessage());
            string str = e.getMessage();
        }
        Test.stopTest();
        System.assertNotEquals(newOppRecord,null);
    }

    /** 
* @description getAccountByOppIdTest
*/
    @isTest static void getAccountByOppIdTest(){
        Test.startTest();

        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Group__c = 'SOLE TRADER CLIENT';
        insert account;

        Contact contact = New Contact();

        contact.AccountId = account.Id;
        contact.FirstName = 'testName';
        contact.LastName = 'testSurname';
        contact.Email = 'ActiveEmail@gmail.com';
        contact.Phone = '0761116754';
        contact.Communication_Language__c = 'English';
        insert contact;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;

        try{
            String getAccount = BusinessEvolveChequeProdVpl2Con.getAccountByOppId(testOpp.Id);
        } catch (Exception e){
            //System.debug('Exception::' + e.getMessage());
            string str = e.getMessage();
        }
        Test.stopTest();
        System.assertNotEquals(testOpp,null);
    }

    /** 
* @description getApplicationProductsTest
*/
    @isTest static void getApplicationProductsTest(){
        Account newClientRecord = [SELECT id, Name
                                   FROM Account
                                   LIMIT 1];
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    LIMIT 1];
        Application__c applicationRecord = [SELECT Id, Name
                                            FROM Application__c
                                            LIMIT 1];
        List<OpportunityLineItem> oppLine = [SELECT Id, Name
                                             FROM OpportunityLineItem
                                             LIMIT 1];

        Test.startTest();

        try{
            List<OpportunityLineItem> applicationProducts = BusinessEvolveChequeProdVpl2Con.getApplicationProducts(newOppRecord.Id);
        } catch (Exception e){
            //System.debug('Exception::' + e.getMessage());
            string str = e.getMessage();
        }
        Test.stopTest();
        System.assertNotEquals(newOppRecord,null);
    }

     /** 
* @description getApplicationRecordTest
*/
    @isTest static void getApplicationRecordTest(){
        Account newClientRecord = [SELECT id, Name
                                   FROM Account
                                   LIMIT 1];
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    LIMIT 1];
        Application__c applicationRecord = [SELECT Id, Name
                                            FROM Application__c
                                            LIMIT 1];
        OpportunityLineItem oppLine = [SELECT Id, Name
                                       FROM OpportunityLineItem
                                       LIMIT 1];

        Test.startTest();

        try{
            BusinessEvolveChequeProdVpl2Con.getApplicationRecord(newOppRecord.Id);
        } catch (Exception e){
            //System.debug('Exception::' + e.getMessage());
            string str = e.getMessage();
        }
        Test.stopTest();
        System.assertNotEquals(newOppRecord,null);
    }
  /** 
* @description insertEmailTemplate
*/
    @future
    public static void insertEmailTemplate(){
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'WelcomePackage';
        validEmailTemplate.DeveloperName = 'WelcomePackage';
        validEmailTemplate.TemplateType = 'html';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.Subject = 'Your Subject Here';
        //validEmailTemplate.BrandTemplateId = '';
        validEmailTemplate.Body = '';

        insert validEmailTemplate;
        System.assertNotEquals(validEmailTemplate,null);
    }

       /** 
* @description acceptProductTermsTest
*/
    @isTest static void acceptProductTermsTest(){
        Account newClientRecord = [SELECT id, Name
                                   FROM Account
                                   LIMIT 1];
        Contact contactRecord = [Select id, Name
                                 from Contact
                                 limit 1];
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    LIMIT 1];
        Application__c applicationRecord = [SELECT Id, Name
                                            FROM Application__c
                                            LIMIT 1];
        OpportunityLineItem oppLine = [SELECT Id, Name
                                       FROM OpportunityLineItem
                                       LIMIT 1];
        BusinessEvolveChequeProdVpl2Con.getApplicationDetails(newOppRecord.Id);
        Double DD1 = double.valueOf('14');
        String test14 = 'productPurposeText';
        String objType = JSON.serialize(applicationRecord);
        //insertEmailTemplate();
        EmailTemplate recTemplate = [Select DeveloperName
                                     From EmailTemplate
                                     LIMIT 1];
        String templateName = recTemplate.DeveloperName;

        Test.startTest();
            applicationRecord.Meeting_Of__c = 'test';
            applicationRecord.Meeting_Held_At__c = 'test';
            applicationRecord.Signing_Date__c = System.today();
            applicationRecord.Signing_Authority_From_Date__c = system.today();
            applicationRecord.Signature_Type__c = 'new signatories';
            applicationRecord.Special_Instruction__c = 'test';
            applicationRecord.Issue_New_or_Replacement_Cards__c = true;
            applicationRecord.Change_Limits__c = true;
            applicationRecord.In_Terms_Of_Resolution_Dated__c = system.today();
            applicationRecord.Account_Maintenance__c = true;
            applicationRecord.Number_of_Signatories_for_account_Operat__c = '1';
            update applicationRecord;
        
            Application_Product__c testAppProdCred = new Application_Product__c();
            testAppProdCred.Application__c = applicationRecord.Id;
            testAppProdCred.Opportunity_Product_Id__c = oppLine.Id;
            testAppProdCred.Account_Number__c = 1234;
            insert testAppProdCred;
        
            newOppRecord.StageName = 'Apply Product';
            update newOppRecord;
            
            try{
                String application = BusinessEvolveChequeProdVpl2Con.acceptProductTerms(newOppRecord.Id, applicationRecord);
            } catch (Exception e){
                //System.debug('Exception::' + e.getMessage());
                string str = e.getMessage();
            }
    
            string htmlBody = '<table border="1" style="border-collapse: collapse"><caption>{!Opportunity.Account} {!TODAY()} </caption><tr><th>Name</th><th>{!OpportunityLineItem.Policy_Number__c}</th></tr>';
            //(String value1,Double value2, Double value3, string value4, String value5, Double value6, Date value7,Double value8,Double value9, String value10,Double value11, String value12, string value13, Id value14)
           // BusinessEvolveChequeProdVpl2Con.saveApplicationDetails('', DD1, DD1, 'test', 'test5', DD1, system.today(), DD1, DD1, 'test10', DD1, 'test12', 'test13', 'test14', applicationRecord.id);
           BusinessEvolveChequeProdVpl2Con.saveApplicationDetails('', DD1, DD1, 'test', 'test5', DD1, system.today(), DD1, DD1, 'test10', DD1, 'test12', 'test13', 'test14', applicationRecord.id, 'Fixed Amount', 'Specific Date', 'Monthly', 04); 
           //BusinessEvolveChequeProdVpl2Con.updateApplicationDetails(newOppRecord.Id,applicationRecord);
            BusinessEvolveChequeProdVpl2Con.updateApplicationROADetails(Date.today(), '', DD1, '', '', '', '', '', 'test', '', '', '', '', '', '', system.today(), '', '', 'test', 'surname', '', system.today(), 'N', 'N', 'Y', testAppProdCred.Id);
            // BusinessEvolveChequeProdVpl2Con.updateApplicationROADetails( '',DD1,'','',
            //  '','','','test','','','','','','',system.today(),'','','test','surname','',system.today(),applicationRecord.id);
            BusinessEvolveChequeProdVpl2Con.updateSavingsAccountGeneral(newOppRecord.Id, objType);
            BusinessEvolveChequeProdVpl2Con.sendWelcomePackage(newOppRecord.Id);
            //BusinessEvolveChequeProdVpl2Con.updateApplication('','','','','','', '', '','Test','Surname', system.today(),applicationRecord.id);
            BusinessEvolveChequeProdVpl2Con.ComposeEmail(newOppRecord.Id, contactRecord.Id, templateName, 'saurabh.pandey@absa.africa'
                                                         , htmlbody,'test');
            //BusinessEvolveChequeProdVpl2Con.updateApplicationDetails('CURRENT / CHEQUE / SAVINGS - INDIVIDUAL ACCOUNT','THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE INDIVIDUAL AFFAIRS',True, True, 'test', True, 'test', 'test', 'test', 'test', 'test', 'test', 'test', 'test', 'test', '', '', '', '', '',  applicationRecord.id);//Changed against W-004995 by Chandra dated 12/06/2020
            // BusinessEvolveChequeProdVpl2Con.updateSigningInstructionDetail(applicationRecord.Signing_Authority_From_Date__c, applicationRecord.In_Terms_Of_Resolution_Dated__c, applicationRecord.Signature_Type__c, applicationRecord.Number_of_Signatories_for_account_Operat__c, applicationRecord.Special_Instruction__c, applicationRecord.Change_Limits__c, applicationRecord.Issue_New_or_Replacement_Cards__c, applicationRecord.Account_Maintenance__c, applicationRecord.id);
            // BusinessEvolveChequeProdVpl2Con.getoppRec(newOppRecord.Id);
            BusinessEvolveChequeProdVpl2Con.updateApplicationRec(testAppProdCred);
        Test.stopTest();
        System.assertNotEquals(newOppRecord,null);
    }

     /** 
* @description createAcctNumberForCQ
*/
    @isTest static void createAcctNumberForCQ(){

        Test.startTest();
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account acc = new Account();
        acc.Name = 'test acc';
        acc.CIF__c = 'LTD 933';
        insert acc;

        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id = pb.id;
        opp.AccountId = acc.id;
        opp.Site__c = siteRec.id;
        insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.Client_Entity_Type__c = 'None';
        app.Source_of_Funds_Savings__c = 'ALLOWANCE';
        insert app;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        //  oppLineItem.Policy_Number__c='000004048272164';
        insert oppLineItem;


        oppLineItem.Policy_Number__c = '4048272164';
        update oppLineItem;

        Price_Scheme__c prScheme = new Price_Scheme__c();
        prScheme.Name = 'Business Essentials Smart - CQT02S33';
        prScheme.Product_Family__c = 'Cheque';
        prScheme.Product_Name__c = 'Business Essentials';
        prScheme.Start_Date__c = System.today();
        prScheme.Scheme_Code__c = 'CQT02S33';
        insert prScheme;

        Profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Standard User'];

        User userRec = new User();
        userRec.email = 'diksha.wasekar@absa.africa';
        userRec.ProfileId = p.id;
        userRec.SiteCode__c = siteRec.Site_Code__c;
        userRec.Teller_Operator_Code__c = '042030';
        userRec.Username = 'usertest@absa.africa';
        userRec.Alias = 'grang';
        userRec.EmployeeNumber = '087699900';
        userRec.EmailEncodingKey = 'UTF-8';
        userRec.LastName = 'gaurav.bb@absa2.com';
        userRec.TimeZoneSidKey = 'America/New_York';
        userRec.LocaleSidKey = 'en_US';
        userRec.LanguageLocaleKey = 'en_US';
        insert userRec;

        BusinessEvolveChequeProdVpl2Con.getOppData(opp.Id, prScheme.Scheme_Code__c);
        try{
            BusinessEvolveChequeProdVpl2Con.callCQcreateAcct(0, 6069, 6069, acc.CIF__c, Integer.valueOf(userRec.Teller_Operator_Code__c), 999999, 0, 11077, 0, '034', '034', Integer.valueOf((string.valueof(System.today())).replace('-', '')), 0, 'N', 'CQT02S30', 0, app.Source_of_Funds_Savings__c, app.Source_of_Funds_Savings__c, app.Source_of_Funds_Savings__c, app.Source_of_Funds_Savings__c, app.Source_of_Funds_Savings__c, 'B', '');
        } catch (Exception ex){
            string str = ex.getMessage();
        }
        // OnboardingProductCQcreateAcctSummaryCon.getAccountNumber(opp.Id, oppLineItem.id);
        Test.stopTest();
        System.assertNotEquals(userRec,null);
    }

    
/* @description createAcctNumberForSAVINGS
*/
    @isTest static void createAcctNumberForSAVINGS(){
        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'SAVINGS', ProductCode = '09007');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Account acc = new Account();
        acc.Name = 'test acc';
        acc.CIF__c = 'AATTORN008';
        insert acc;

        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.Pricebook2Id = pb.id;
        opp.AccountId = acc.id;
        opp.Site__c = siteRec.id;
        insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.Client_Entity_Type__c = 'None';
        app.Source_of_Funds_Savings__c = 'ALLOWANCE';
        insert app;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

        oppLineItem.Policy_Number__c = '9054538';
        update oppLineItem;

        Profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Standard User'];

        User userRec = new User();
        userRec.email = 'diksha.wasekar@absa.africa';
        userRec.ProfileId = p.id;
        userRec.SiteCode__c = siteRec.Site_Code__c;
        userRec.Teller_Operator_Code__c = '042030';
        userRec.Username = 'usertest@absa.africa';
        userRec.Alias = 'grang';
        userRec.EmailEncodingKey = 'UTF-8';
        userRec.LastName = 'gaurav.bb@absa2.com';
        userRec.TimeZoneSidKey = 'America/New_York';
        userRec.LocaleSidKey = 'en_US';
        userRec.LanguageLocaleKey = 'en_US';
        insert userRec;

        Test.startTest();
        BusinessEvolveChequeProdVpl2Con.getAccountNumber(opp.Id, oppLineItem.id, '39', '39', '', '', '', 'L');
        Test.stopTest();
        System.assertNotEquals(opp,null);
    }

        /** 
* @description updateApplicationTest
*/
     @isTest static void updateApplicationTest(){
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

        Application__c appRec = new Application__c();
        appRec.Transactional_Account__c = '11016 Bussines Essentials';
        appRec.Account_Access__c = 'Cellphone';
        appRec.Foreign_Services__c = 'Curency SWAP (Hedging Instruments)';
        appRec.Surplus_Cash__c = 'Fixed Deposits';
        appRec.Borrowing_Requiment_General__c = 'Credit Card';
        appRec.Borrowing_requiment_Assest_Acquisition__c = 'Business /BACKED Property Finance';
        appRec.Protection_Of_Services__c = 'Retirement';
        appRec.Title__c = 'dd';
        appRec.FirstNameSignature__c = 'Litha';
        appRec.SurnameSignature__c = 'Nosekeleza';
        appRec.Signing_Date__c = System.today();
        appRec.Signing_Authority_From_Date__c = system.today();
        appRec.Signature_Type__c = 'new signatories';
        appRec.Special_Instruction__c = 'test';
        appRec.Issue_New_or_Replacement_Cards__c = true;
        appRec.Change_Limits__c = true;
        appRec.In_Terms_Of_Resolution_Dated__c = system.today();
        appRec.Account_Maintenance__c = true;
        appRec.Number_of_Signatories_for_account_Operat__c = '1';
        appRec.Client_Entity_Type__c = 'None';
        appRec.Source_of_Funds_Savings__c = 'ALLOWANCE';

        //insert appRec;

        Application__c app = new Application__c();
        app.Opportunity__c = testOpp.id;
        app.Client_Entity_Type__c = 'None';
        app.Source_of_Funds_Savings__c = 'ALLOWANCE';
        insert app;
        
        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Application__c = app.Id;
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        testAppProdCred.Account_Number__c = 1234;
        insert testAppProdCred;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'someaddress@email.com');
        insert contact;

        EmailTemplate recTemplate = [Select DeveloperName
                                     From EmailTemplate
                                     LIMIT 1];
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        BusinessHours businessHr = [SELECT Id
                                    FROM BusinessHours
                                    LIMIT 1];

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email', Response_Email_Address__c = 'evg@t.com', Queue__c = 'Email', Business_Hours__c = businessHr.Id, Internal_SLA_Time_Measure__c = 'Hour(s)', Internal_SLA_Units__c = '8', Active__c = true);
        insert serviceGr;

        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', External_SLA_Time_Measure__c = 'Hour(s)', External_SLA_Units__c = '8', Default_Service_Level__c = true);
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id, Service_Group__c = serviceGr.Id, Service_Level__c = serviceLevel.Id);
        insert serviceGrType;

        Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', AccountId = account.Id, Risk_Management_Centre__c = 'Digital Fraud', Email__c = 'test@test.com', recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(), Subject = 'test', Description = 'test', Service_Group_Search__c = serviceGr.id, sd_Service_Group_Id__c = serviceGr.Id, Expectation_of_the_Customer__c = 'test', Incident_Date__c = date.today());

        insert caseRec;
        Id whatId = [SELECT Id
                     FROM Case
                     LIMIT 1].Id;
        Id targetObjectId = [Select Id
                             From Contact
                             where Email != null
                             LIMIT 1].Id;
        test.startTest();
        //BusinessEvolveChequeProdVpl2Con.updateApplication(account.Id,'Cellphone','Curency SWAP (Hedging Instruments)','Fixed Deposits','Credit Card','Business /BACKED Property Finance','Retirement','ff','Litha','Nosekeleza',System.today()+2,appRec.Id);
        BusinessEvolveChequeProdVpl2Con.getCurrentUserDetail();
        BusinessEvolveChequeProdVpl2Con.fetchAccountDetails(account.Id);
        BusinessEvolveChequeProdVpl2Con.sendWelcomePackage(testOpp.Id);
        BusinessEvolveChequeProdVpl2Con.updateApplicationDetails('false','Yes','test', 'Self Service',false,'2 Weeks','1', 'O', 'Test','8','Tuesday', '5','Tuesday','','','','','','',testAppProdCred.Id);
        BusinessEvolveChequeProdVpl2Con.getApplicationProductRecord(testOpp.Id);
        String templateName = recTemplate.DeveloperName;
        String emailAddress = 'test@email.com';
        String emailHTMLBody = '<html><body><p>This is a <test mail</p></body></html>';
        List<Messaging.SingleEmailMessage> lstMsgs = BusinessEvolveChequeProdVpl2Con.ComposeEmail(whatId, targetObjectId, 
                                                                                                  templateName, emailAddress, 
                                                                                                  emailHTMLBody,'test');
        if (lstMsgs != null){
            Messaging.SingleEmailMessage email = lstMsgs.get(0);
            String htmlBody = email.getHTMLBody();
        }
        String str = '{"Id":"' + appRec.Id + '"}';
        BusinessEvolveChequeProdVpl2Con.updateSavingsAccountGeneral(testOpp.Id, JSON.serialize(testAppProdCred));
        //BusinessEvolveChequeProdVpl2Con.getOppData(testOpp.Id);
        BusinessEvolveChequeProdVpl2Con.getAccountNumber(testOpp.Id, oppLineItem.Id, '39', '39', '', '', '', 'L');
        BusinessEvolveChequeProdVpl2Con.showopplineitem(testOpp.Id, oppLineItem.Id);
        //BusinessEvolveChequeProdVpl2Con.updateSigningInstructionDetail(appRec.Signing_Authority_From_Date__c, appRec.In_Terms_Of_Resolution_Dated__c, appRec.Signature_Type__c, appRec.Number_of_Signatories_for_account_Operat__c, appRec.Special_Instruction__c, appRec.Change_Limits__c, appRec.Issue_New_or_Replacement_Cards__c, appRec.Account_Maintenance__c, appRec.Id);
        BusinessEvolveChequeProdVpl2Con.updateApplicationROADetails(Date.today(), 'delegatesAtMeeting', null, 'currentSituation', 'currentProductXP', 'needsOrObjectives', 'typicalmacroOrSectorial', 'othermacroOrSectorial', 'generalNotes', 'priorProduct', 'productConsidered', 'productRecommended', 'reasonNotRecommended', 'presentationName', 'presentationGroupName', System.today()+2, 'presentationLocation', 'presentationFolioNo', 'firstName', 'surname', 'designation', System.today()+6, 'N', 'N', 'Y', testAppProdCred.Id);
        //BusinessEvolveChequeProdVpl2Con.getApplicationProductsV2(testOpp.Id,oppLineItem.Id);
        // BusinessEvolveChequeProdVpl2Con.getPricingSchemesByProductV2(testOpp.Id,oppLineItem.Id);
        BusinessEvolveChequeProdVpl2Con.getAccount(testOpp.Id);
        //BusinessEvolveChequeProdVpl2Con.sendWelcomePackageV2(testOpp.Id,oppLineItem.Id);
        //BusinessEvolveChequeProdVpl2Con.getOppDataV2(testOpp.Id,'1234', oppLineItem.Id);
        //BusinessEvolveChequeProdVpl2Con.getOppLineItem(testOpp.Id, 'Family');
        BusinessEvolveChequeProdVpl2Con.changeAccountDomicile(testOpp.AccountId, '1234');
        BusinessEvolveChequeProdVpl2Con.getOpportunityLineItems(testOpp.Id);
        BusinessEvolveChequeProdVpl2Con.getOpportunityLineItemDetails(testOpp.Id);
        test.stopTest();
        System.assertNotEquals(testOpp,null);
    }

      /** 
* @description testGetRelatedParties
*/
    @isTest static void testGetRelatedParties(){
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    LIMIT 1];

        Test.startTest();

        List<Map<String, Object>> relatedParty = BusinessEvolveChequeProdVpl2Con.getRelatedParties(newOppRecord.Id, false);
        //System.debug('Related Party ' + newOppRecord.Name);
        System.assertEquals(relatedParty.size(), 2);
        Test.stopTest();
    }

    /** 
* @description testUpdateApplication
*/
      @isTest static void testUpdateApplication(){
        Application__c newAppRecord = [SELECT Id, Name
                                       FROM Application__c
                                       Where FirstNameSignature__c = 'Litha'];

        Test.startTest();
        String result = BusinessEvolveChequeProdVpl2Con.updateApplication('', 'Cellphone', 'Trade Finance Products', '09010 Call Account', 'Credit Card', 'Commercial Property Finance', 'Buy And Sell', 'Business Cover', 'Bonus Deposit', 'Title', 'First Name', 'Surname', Date.today(), newAppRecord.Id);

         System.assertNotEquals(newAppRecord, null);
        Test.stopTest();
    }

     /** 
* @description testUpdateApplicationInValid
*/
    @isTest static void testUpdateApplicationInValid(){
        Application__c newAppRecord = [SELECT Id, Name
                                       FROM Application__c
                                       Where FirstNameSignature__c = 'Litha'];

        Test.startTest();
        String result = BusinessEvolveChequeProdVpl2Con.updateApplication('55', 'Cellphone', 'Trade Finance Products', '09010 Call Account', 'Credit Card', 'Commercial Property Finance', 'Buy And Sell', 'Business Cover', 'Bonus Deposit', 'Title', 'First Name', 'Surname', Date.today(), newAppRecord.Id);

        System.assertNotEquals(newAppRecord, null);
        Test.stopTest();
    }

       /** 
* @description testUpdateNotifyMe
*/
    @isTest static void testUpdateNotifyMe(){
        Test.startTest();


        Account account = new Account();
        account.Name = 'Test NewAcc';
        account.CIF__c = 'DJ95 SL';
        account.ExecutionLayerRequestID__c = 'Test Case Numbber';
        insert account;

        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;

        Profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Standard User'];

        User userRec = new User();
        userRec.email = 'diksha.wasekar@absa.africa';
        userRec.Phone = '0115442525';
        userRec.ProfileId = p.id;
        userRec.SiteCode__c = siteRec.Site_Code__c;
        userRec.Teller_Operator_Code__c = '042030';
        userRec.Username = 'email1test@absa.com';
        userRec.Alias = 'grang';
        userRec.EmailEncodingKey = 'UTF-8';
        userRec.LastName = 'gaurav.bb@absa2.com';
        userRec.TimeZoneSidKey = 'America/New_York';
        userRec.LocaleSidKey = 'en_US';
        userRec.LanguageLocaleKey = 'en_US';
        insert userRec;


        Opportunity opp = new Opportunity();
        //opp.CIF_Number__c = 'MOOIM 002';
        opp.Name = 'Test OppSales Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'Apply Product';
        opp.AccountId = account.id;
        opp.Site__c = siteRec.id;
        insert opp;

        Product2 prod = new Product2(Name = 'Business Evolve', Family = 'Cheque', ProductCode = '11021');
        insert prod;

        Product2 prod2 = new Product2(Name = 'Savings', Family = 'Savings', ProductCode = '9010');
        insert prod2;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice2;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c = '000004048272164';
        insert oppLineItem;

        OpportunityLineItem oppLineItem2 = new OpportunityLineItem();
        oppLineItem2.OpportunityId = opp.id;
        oppLineItem2.Product2Id = prod2.id;
        oppLineItem2.PricebookEntryId = customPrice2.id;
        oppLineItem2.Quantity = 1;
        oppLineItem2.TotalPrice = 100;
        oppLineItem2.Policy_Number__c = '000004048272164';
        insert oppLineItem2;


        OpportunityLineItem oppLineItem3 = new OpportunityLineItem();
        oppLineItem3.OpportunityId = opp.id;
        oppLineItem3.Product2Id = prod.id;
        oppLineItem3.PricebookEntryId = customPrice.id;
        oppLineItem3.Quantity = 1;
        oppLineItem3.TotalPrice = 100;
        oppLineItem3.Policy_Number__c = '';
        insert oppLineItem3;

        OpportunityLineItem oppLineItem4 = new OpportunityLineItem();
        oppLineItem4.OpportunityId = opp.id;
        oppLineItem4.Product2Id = prod2.id;
        oppLineItem4.PricebookEntryId = customPrice2.id;
        oppLineItem4.Quantity = 1;
        oppLineItem4.TotalPrice = 100;
        oppLineItem4.Policy_Number__c = '';
        insert oppLineItem4;


        Price_Scheme__c prScheme = new Price_Scheme__c();
        prScheme.Name = 'Business Essentials Smart - CQT02S33';
        prScheme.Product_Family__c = 'Cheque';
        prScheme.Product_Name__c = 'Business Essentials';
        prScheme.Start_Date__c = System.today();
        prScheme.No_End_Date__c = TRUE;

        insert prScheme;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Minimum_Amount1__c = 200;
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = '11016 Bussines Essentials';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
        app.Surplus_Cash__c = 'Fixed Deposits';
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-BACKED Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();
        APP.Source_of_Funds_Savings__c = 'TRADING INCOME SALES';
        insert app;

        Application_Product__c ap = new Application_Product__c();
        ap.Opportunity_Product_Id__c = oppLineItem.id;
        ap.Application__c = app.Id;
        ap.Cash_Flow_Manager__c = true;
        insert ap;

        Application_Product__c ap2 = new Application_Product__c();
        ap2.Opportunity_Product_Id__c = oppLineItem2.id;
        ap2.Application__c = app.Id;
        ap2.Cash_Flow_Manager__c = true;
        insert ap2;

        Application_Product__c ap3 = new Application_Product__c();
        ap3.Opportunity_Product_Id__c = oppLineItem3.id;
        ap3.Application__c = app.Id;
        ap3.Cash_Flow_Manager__c = true;
        insert ap3;

        Application_Product__c ap4 = new Application_Product__c();
        ap4.Opportunity_Product_Id__c = oppLineItem4.id;
        ap4.Application__c = app.Id;
        ap4.Cash_Flow_Manager__c = true;
        insert ap4;


        Opportunity newOppRecord = [SELECT Id, Name, AccountId
                                    FROM Opportunity
                                    Where Name = 'Test OppSales Onboarding'];

        Contact contact = new Contact();
        contact.AccountId = newOppRecord.AccountId;
        contact.FirstName = 'john';
        contact.LastName = 'vuligate';
        contact.Email = 'testActiveEmail@absa.africa';
        contact.Phone = '0114007643';
        contact.Communication_Language__c = 'English';
        insert contact;

        EmailTemplate recTemplate = [Select DeveloperName
                                     From EmailTemplate
                                     LIMIT 1];
        String templateName = recTemplate.DeveloperName;

        //String result = BusinessEvolveChequeProdVpl2Con.updateNotifyMe('john', 'vuligate', 'john@gmail.com', '0117615555', 'English', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', Date.today(), 'Yes', '1120', 'N', 'Tuesday', newOppRecord.Id);

        //String output = BusinessEvolveChequeProdVpl2Con.getExecutionLayerRequestID(newOppRecord.Id);
         BusinessEvolveChequeProdVpl2Con.getApplicationId(newOppRecord.Id, 'Cheque');
        //BusinessEvolveChequeProdVpl2Con.sendWelcomePackageV2(newOppRecord.Id, oppLineItem.id);
        BusinessEvolveChequeProdVpl2Con.getOppDataV2(opp.Id, prScheme.Scheme_Code__c, oppLineItem.id);
        BusinessEvolveChequeProdVpl2Con.getOppDataV2(opp.Id, prScheme.Scheme_Code__c, oppLineItem2.id);
        List<OpportunityLineItem> getAppId = BusinessEvolveChequeProdVpl2Con.getApplicationProductsV2(newOppRecord.Id, oppLineItem.id);
        // BusinessEvolveChequeProdVpl2Con.getOppDataV2(opp.Id,prScheme.Scheme_Code__c,oppLineItem3.id);
        BusinessEvolveChequeProdVpl2Con.getOppDataV2(opp.Id, prScheme.Scheme_Code__c, oppLineItem4.id);
        List<Price_Scheme__c> getPricingSchemes = BusinessEvolveChequeProdVpl2Con.getPricingSchemesByProductV2(newOppRecord.Id, oppLineItem.id);
        opportunitylineitem lineItemRec = BusinessEvolveChequeProdVpl2Con.getOppLineItem(newOppRecord.Id, 'Cheque');
        //System.debug('Related Party ' + newOppRecord.Name);
        System.assertNotEquals(opp, null);
        Test.stopTest();
    }

        /** 
* @description testInsertNotifyMe
*/
    @isTest static void testInsertNotifyMe(){
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    Where Name = 'Sales'];

        Test.startTest();
        String result = BusinessEvolveChequeProdVpl2Con.updateNotifyMe('john', 'vuligate', 'john@gmail.com', '0117615555', 'English', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', 'Yes', '', 'Yes', '1120', 'N', 'Tuesday','Yes', newOppRecord.Id);
        //System.debug('Related Party ' + result);
        System.assertNotEquals(result,null);
        Test.stopTest();
    }

     /** 
* @description testUpdateInternetBanking
*/
    @isTest static void testUpdateInternetBanking(){
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    Where Name = 'Test Opp Onboarding 1'];

        Test.startTest();
        String result = BusinessEvolveChequeProdVpl2Con.updateInternetBanking('AccountToBeDebitedMonthlyWithTheCost', 'CombiRecordNumber', 'NumberOfAuthorisations', 'NumberOfMainUsers', 'FeeStructureCode', 'Yes', 'Yes', 'Yes', 'Yes', 'FundsTransfer', 'BillPayments', 'OwnDefinedPayments', 'FutureDatedPayments', 'StopOrderPayments', newOppRecord.Id);
        //System.debug('Result 188 ' + newOppRecord);
        System.assertEquals(result, 'Updated the application record');
        Test.stopTest();
    }

      /** 
* @description testInsertInternetBanking
*/
    @isTest static void testInsertInternetBanking(){
        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    Where Name = 'Onboarding'];

        Test.startTest();
        String result = BusinessEvolveChequeProdVpl2Con.updateInternetBanking('AccountToBeDebitedMonthlyWithTheCost', 'CombiRecordNumber', 'NumberOfAuthorisations', 'NumberOfMainUsers', 'FeeStructureCode', 'Yes', 'Yes', 'Yes', 'Yes', 'FundsTransfer', 'BillPayments', 'OwnDefinedPayments', 'FutureDatedPayments', 'StopOrderPayments', newOppRecord.Id);
        //System.debug('Result 188 ' + newOppRecord);
        System.assertEquals(result, 'Inserted the application record');
        Test.stopTest();
    }

    /** 
* @description testInsertInternetBanking
*/
    @isTest static void testGetSelectedParties(){
        AccountContactRelation acr = [SELECT Id
                                      FROM AccountContactRelation
                                      LIMIT 1];

        Test.startTest();
        //Map<String, Object> accountContactRelation = BusinessEvolveChequeProdVpl2Con.getSelectedParties(acr.Id);
        System.assertNotEquals(acr,null);
        Test.stopTest();
    }

      /** 
* @description getPricingSchemesByProductTest
*/
    @isTest static void getPricingSchemesByProductTest(){
        Account account = new Account();
        account.Name = 'Test Account';
        insert account;
        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding 1';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        // testOpp.Site__c='Test';
        insert testOpp;

        Product2 prod = new Product2(Name = 'Business Essentials', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = testOpp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;

        Price_Scheme__c prScheme = new Price_Scheme__c();
        prScheme.Name = 'Business Essentials Smart - CQT02S33';
        prScheme.Product_Family__c = 'Cheque';
        prScheme.Product_Name__c = 'Business Essentials';
        prScheme.Start_Date__c = System.today();
        BusinessEvolveChequeProdVpl2Con.getPricingSchemesByProduct(testOpp.id);
        System.assertNotEquals(testOpp,null);
    }

    /** 
* @description getSelectedRelatedPartyTest
*/
    @isTest static void getSelectedRelatedPartyTest(){
        Account account = new Account(Name = 'Test Account');
        account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        //W-005355 : Anka Ganta : 2020-07-09
        account.Country_of_Incorporation__c = 'South Africa';
        account.Client_Group__c = 'Non Individual';
        account.CASA_Reference_Number__c = '12233';
        account.CIF__c = '';
        account.Countries_Traded_With__c = 'South Africa';
        account.Source_of_Income__c = 'Donation';
        insert account;

        Account account2 = new Account(Name = 'Test Account2');
        account2.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Business Prospect').getRecordTypeId();
        account2.Country_of_Incorporation__c = 'South Africa';
        account2.Client_Group__c = 'Non Individual';
        account2.Client_Type__c = 'Private Company';
        account2.CASA_Reference_Number__c = '12233';
        account2.CIF__c = '';
        account2.Countries_Traded_With__c = 'South Africa';
        account2.Source_of_Income__c = 'Donation';
        insert account2;

        FinServ__ReciprocalRole__c resRole = new FinServ__ReciprocalRole__c();
        resRole.FinServ__CreateInverseRole__c = true;
        resRole.FinServ__InverseRole__c = 'Director';
        insert resRole;

        FinServ__AccountAccountRelation__c accAccRel = new FinServ__AccountAccountRelation__c(FinServ__Account__c = account.Id, FinServ__RelatedAccount__c = account2.Id, Roles__c = 'Shareholder/Controller', FinServ__Role__c = resRole.id, Primary_Entity_Id__c = account.Id, Shareholding_Percentage__c = 50);
        insert accAccRel;

        //insert related acct;
        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        Account acctSecondary = new Account();
        acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Prospect').getRecordTypeId();
        acctSecondary.ID_Number__pc = '6803037015089';
        acctSecondary.ID_Type__pc = 'SA Identity Document';
        acctSecondary.FirstName = 'First Name';
        acctSecondary.LastName = 'Test Last Name';
        acctSecondary.Initials__pc = 'I';
        acctSecondary.PersonTitle = 'Mr';
        acctSecondary.Client_Type__c = 'Individual Client';
        acctSecondary.CASA_Reference_Number__c = '12454';
        acctSecondary.CASA_Screening_Status__c = 'Matched';
        insert acctSecondary;
        Account acc = [SELECT PersonContactId
                       FROM Account
                       WHERE Id = :acctSecondary.Id];
        Id personContactId = acc.PersonContactId;
        AccountContactRelation accConRel = new AccountContactRelation(AccountId = account.Id, ContactId = personContactId);
        insert accConRel;

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp Onboarding';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'New';
        testOpp.AccountId = account.Id;
        insert testOpp;

        BusinessEvolveChequeProdVpl2Con.getSelectedRelatedParty(accConRel.Id);
        BusinessEvolveChequeProdVpl2Con.getSelectedRelatedParty(accAccRel.Id);
        BusinessEvolveChequeProdVpl2Con.getRelatedParties(testOpp.Id, false);
        System.assertNotEquals(testOpp,null);
    }

   /** 
* @description testUpdateEstatement
*/
    @isTest static void testUpdateEstatement(){


        Test.startTest();

        Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
        insert prod;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Profile p = [SELECT Id
                     FROM Profile
                     WHERE Name = 'Standard User'];

        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;


        User userRec = new User();
        userRec.email = 'diksha.wasekar@absa.africa';
        userRec.ProfileId = p.id;
        userRec.SiteCode__c = siteRec.Site_Code__c;
        userRec.Teller_Operator_Code__c = '042030';
        userRec.Username = 'usertest@absa.africa';
        userRec.Alias = 'grang';
        userRec.EmailEncodingKey = 'UTF-8';
        userRec.LastName = 'gaurav.bb@absa2.com';
        userRec.TimeZoneSidKey = 'America/New_York';
        userRec.LocaleSidKey = 'en_US';
        userRec.LanguageLocaleKey = 'en_US';
        insert userRec;

        List<User> userlist = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

        String site = userlist[0].SiteCode__c;
        String teller = userlist[0].Teller_Operator_Code__c;
        String email = userlist[0].Email;

        Account acc = new Account();
        acc.Name = 'Test NewAcc';
        acc.CIF__c = 'DJ95 SL';
        insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test OppSales Onboarding';
        opp.CloseDate = Date.today();
        opp.StageName = 'New';
        opp.AccountId = acc.id;
        opp.Site__c = siteRec.id;
        insert opp;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Policy_Number__c = '000004048272164';
        insert oppLineItem;

        Price_Scheme__c prScheme = new Price_Scheme__c();
        prScheme.Name = 'Business Essentials Smart - CQT02S33';
        prScheme.Scheme_Code__c = 'CQT02S33';
        prScheme.Product_Family__c = 'Cheque';
        prScheme.Product_Name__c = 'Business Essentials';
        prScheme.Start_Date__c = System.today();
        insert prScheme;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.id;
        app.All_transaction_type__c = '';
        app.Payment__c = '';
        app.Withdrawal__c = '';
        app.Deposit__c = '';
        app.Returned_Transactions__c = '';
        app.Scheduled_transaction__c = '';
        app.Notification_time__c = Date.today();
        app.Minimum_amount__c = '';
        app.Account_to_be_debited_monthly_with_the_c__c = '';
        app.Number_of_authorisations_that_will_be_re__c = '';
        app.Number_of_main_users__c = '';
        app.Fee_Structure_code__c = '';
        app.Absa_online_for_business_BIB__c = '';
        app.Cell_phone_banking__c = '';
        app.Telephone_banking__c = '';
        app.Notifyme__c = '';
        app.Funds_transfer__c = '';
        app.Bill_payments__c = '';
        app.Own_defined_payments__c = '';
        app.Future_dated_payments__c = '';
        app.Stop_order_payments__c = '';
        //app.Transactional_Account__c = '11016 Bussines Essentials';
        //app.Transactional_Account__c = 'Franchise';
        app.Account_Access__c = 'Cellphone';
        app.Foreign_Services__c = 'Currency Swap (Hedging Instruments)';
        app.Surplus_Cash__c = 'Fixed Deposits';
        app.Borrowing_Requiment_General__c = 'Credit Card';
        app.Borrowing_requiment_Assest_Acquisition__c = 'Business-BACKED Property Finance';
        app.Protection_Of_Services__c = 'Retirement';
        app.Title__c = 'dd';
        app.FirstNameSignature__c = 'Litha';
        app.SurnameSignature__c = 'Nosekeleza';
        app.Signing_Date__c = System.today();
        insert app;

        Opportunity newOppRecord = [SELECT Id, Name
                                    FROM Opportunity
                                    Where Name = 'Test OppSales Onboarding'
                                    LIMIT 1];

        String jsonData = '{"oppId":"' + newOppRecord.Id + '", "deliveryMethodVal":"Email","statementFrequencyVal":"Quarterly","statementDayOfMonthVal":"09","accountStreamVal":"Business","duplicateStatementsVal":true,"deliveryInstructionVal":"About.. test"}';
        String result = BusinessEvolveChequeProdVpl2Con.addEstatementDetails(jsonData);
        String resp = BusinessEvolveChequeProdVpl2Con.updateProductPriceScheme(newOppRecord.Id,prScheme.Scheme_Code__c);
        //System.debug('Related Party ' + newOppRecord.Name);
         System.assertNotEquals(newOppRecord, null);
        Test.stopTest();
    }
      /** 
* @description testUpdateEstatement
*/
     @isTest static void validateAddEstatementDetailsMethod(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='demo_12345standarduser@testorg.com',SiteCode__c = '123',Teller_Operator_Code__c='321');

        System.runAs(u) {
            Opportunity newOppRecord = [SELECT Id, Name FROM Opportunity Where Name = 'Test Opp Onboarding 1' LIMIT 1];
            OpportunityLineItem oli = [SELECT Policy_Number__c FROM OpportunityLineItem WHERE OpportunityId =: newOppRecord.Id];
            oli.Policy_Number__c = 'Test';
            update oli;
            Test.startTest();
                String jsonData = '{"oppId":"' + newOppRecord.Id + '", "deliveryMethodVal":"Email","statementFrequencyVal":"Quarterly","statementDayOfMonthVal":"09","accountStreamVal":"Business","duplicateStatementsVal":true,"deliveryInstructionVal":"About.. test"}';
                String result = BusinessEvolveChequeProdVpl2Con.addEstatementDetails(jsonData);
                System.assertNotEquals(u, null);
            Test.stopTest();
        }
    }
}