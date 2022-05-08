/**
* This is a test data factory class for wills specific test data
*
* @author   Nelson Chisoko (Dariel)
* @since    2019/01/23
* @updated   Himanshu Nimje (Mphatek)
* @UpdateDate 2019/03/05
*@Updated   Ignecious Mushanguri (Cloudsmiths) 
*UpdatedDate 2020/12/09
*
*/
@IsTest
public class WillsTestDataFactory {
    
    private static Map <String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    private static Map <String, Schema.RecordTypeInfo> accountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> AssetRecordTypeMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> LookupRecordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> AplicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    
    public Account testAccount;
    public Account testAccountEng;
    public Opportunity testOpportunity;
    public Opportunity testOpportunityAfrSMS;
    public Opportunity testOpportunityEngEmail;
    public Opportunity testOpportunityEngSMS;
    public Application__c testApplication;
    public Application__c testApplicationEngEmail;
    public Application__c testApplicationEngSMS;
    public Application__c testApplicationAfrSMS;
    public Payment_Plan__c testPaymentPlan;
    public Payment_Plan__c testPaymentPlanDraft;
    public Asset testAsset;
    public Lookup__c testBank;
    public Lookup__c testBranch;
    public User testUser;
    public OpportunityLineItem testOpportunityLineItem;
    public Pricebook2 standardPriceBook ;
    public Product2 testProduct;
    public PricebookEntry testPricebookEntry ;
    public Financial_Needs_Analysis__c testFna;
    public Employee__c testAdviser;
    public Site__c testSite;

    
    
    public WillsTestDataFactory(){

        //User
        String orgId = userInfo.getOrganizationId();
        String dateString = Datetime.now().format('yyyMMddHHmmss');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = dateString + randomInt + '@test' + orgId + '.org';
        testUser = new User();
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

        //testAdviser
        testAdviser=new Employee__c();
        testAdviser.Name='testUser';
        testAdviser.AB_Number__c='abit456';
        testAdviser.Advisor_Code__c='A12345';
        testAdviser.BRID__c='BO345633';
        testAdviser.Email__c='TestUser@gmail.com';
        testAdviser.Employee_Number__c='435435435';
        testAdviser.Mobile__c='0658992600';
        insert testAdviser;
        
        //testSite
        testSite=new Site__c();
        testSite.Name='Absa Regional Office Private Bank,(B2509),Umhlanga Ridgeside,33 Richefond Circle';
        testSite.Unique_Site_Code__c='B2509';
       // testSite.RecordTypeId =SiteRecordTypeMap.get('Branch Site').getRecordTypeId();
        testSite.Active__c= true;
        testSite.Site_Code__c='2509';
        insert testSite;
        

        //Account
        testAccount = new Account();
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
        
        //AccountENG
        testAccountEng = new Account();
        testAccountEng.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        system.debug('testAccountEng.RecordTypeId: '+testAccountEng.RecordTypeId);
        testAccountEng.CASA_Reference_Number__c = '1712994';
        testAccountEng.CASA_Risk_Status__c = 'Low';
        testAccountEng.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccountEng.CASA_Screening_Status__c = 'Approved';
        testAccountEng.CASA_Analyst_Comments__c = '30406';
        testAccountEng.PersonMobilePhone = '+270747003747';
        // testAccountEng.Country_of_Residence__c = 'South Africa';
        testAccountEng.Country_of_Residence__pc='South Africa';
        testAccountEng.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccountEng.PersonEmail = 'test@test.co.za';
        testAccountEng.FirstName = 'Green';
        testAccountEng.External_Siebel_ID__c = '1-1IV9MC';
        testAccountEng.ID_Number__pc = '7711055007087';
        testAccountEng.ID_Type__pc = 'SA Identity Document';
        testAccountEng.LastName = 'Lanturn';
        testAccountEng.Nationality__pc = 'South Africa';
        testAccountEng.Occupation__pc = 'Engineer';
        testAccountEng.Onboarding_Channel__c = 'Test';
        testAccountEng.Communication_Language__pc = 'Emglish';
        testAccountEng.PersonTitle = 'Mr';
        testAccountEng.Client_Type__c = 'Individual Client';
        testAccountEng.Phone = '+270114453322';
        testAccountEng.Gender__pc = 'Male';
        testAccountEng.Initials__pc = 'T';
        testAccountEng.Country_of_Birth__pc = 'South Africa';
        testAccountEng.Marital_Status__pc = 'Married';
        testAccountEng.Marital_Contract_Type__pc = 'Community of Property';
        testAccountEng.Income_Source__pc = 'Bonus';
        testAccountEng.Occupation_Status__pc = 'Full Time Employed';
        testAccountEng.Income_Bracket__pc = 'R20;000 - R75;000 pm';
        testAccountEng.Occupation_Category__pc = 'Advertising';
        testAccountEng.ShippingCity = 'CAPE TOWN';
        testAccountEng.ShippingCountry = 'South Africa';
        testAccountEng.ShippingStreet = '01 PUERTA DEL SOL';
        testAccountEng.ShippingPostalCode = '8001';
        testAccountEng.BillingCity = 'GROBLERSDAL';
        testAccountEng.BillingCountry = 'South Africa';
        testAccountEng.BillingStreet = '01 MABOPANE SECTION';
        testAccountEng.BillingPostalCode = '1060';
        testAccountEng.CIF__c = 'AFIFTAP002';
        insert testAccountEng;
        
        //Opportunity
        testOpportunity = new Opportunity();
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
        
        //Opportunity Afr Sms
        testOpportunityAfrSMS = new Opportunity();
        testOpportunityAfrSMS.AccountId = testAccount.id;
        testOpportunityAfrSMS.RecordTypeId = OpportunityRecordTypeMap.get('Wills').getRecordTypeId();
        testOpportunityAfrSMS.Adviser_AB_Number__c = 'TEST001';
        testOpportunityAfrSMS.Name = 'TestClass Wills - AFRSMS';
        // testOpportunityAfrSMS.Product__c = 'ANY AMOUNT - ANY AMOUNT (NOT LISTED)';
        testOpportunityAfrSMS.LeadSource = 'Siebel Campaign';
        // testOpportunityAfrSMS.Sub_Product__c = '';
        testOpportunityAfrSMS.Type = 'Cross Sell';
        testOpportunityAfrSMS.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunityAfrSMS.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunityAfrSMS.StageName = 'Registration';
        testOpportunityAfrSMS.CloseDate = Date.today() + 10;
        testOpportunityAfrSMS.Will_Number__c = '41000049999';
        testOpportunityAfrSMS.Commission_1st_Year__c = 2000;
        testOpportunityAfrSMS.Commission_2nd_Year__c = 590;
        testOpportunityAfrSMS.Debit_Order_Debit_Day__c='30';
        testOpportunityAfrSMS.Debit_Order_Salary_Day__c='10';
        testOpportunityAfrSMS.DebitOrderThirdParty__c=true;
        testOpportunityAfrSMS.Commencement_Date__c = Date.today();
        testOpportunityAfrSMS.Debit_Order_Date__c = Date.today();
        testOpportunityAfrSMS.CASA_Status__c='Valid';
        testOpportunityAfrSMS.Risk_Status__c = 'Valid';
        testOpportunityAfrSMS.Adviser__c=testUser.Id;
        testOpportunityAfrSMS.Adviser_Employee__c=testAdviser.Id;
        testOpportunityAfrSMS.Site__c=testSite.Id;
        insert testOpportunityAfrSMS;
        
        //Opportunity Eng Sms
        testOpportunityEngSMS = new Opportunity();
        testOpportunityEngSMS.AccountId = testAccountEng.id;
        testOpportunityEngSMS.RecordTypeId = OpportunityRecordTypeMap.get('Wills').getRecordTypeId();
        testOpportunityEngSMS.Adviser_AB_Number__c = 'TEST001';
        testOpportunityEngSMS.Name = 'TestClass Wills - ENGSMS';
        // testOpportunityEngSMS.Product__c = 'ANY AMOUNT - ANY AMOUNT (NOT LISTED)';
        testOpportunityEngSMS.LeadSource = 'Siebel Campaign';
        // testOpportunityEngSMS.Sub_Product__c = '';
        testOpportunityEngSMS.Type = 'Cross Sell';
        testOpportunityEngSMS.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunityEngSMS.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunityEngSMS.StageName = 'Registration';
        testOpportunityEngSMS.CloseDate = Date.today() + 10;
        testOpportunityEngSMS.Will_Number__c = '41000049999';
        testOpportunityEngSMS.Commission_1st_Year__c = 2000;
        testOpportunityEngSMS.Commission_2nd_Year__c = 590;
        testOpportunityEngSMS.Debit_Order_Debit_Day__c='30';
        testOpportunityEngSMS.Debit_Order_Salary_Day__c='10';
        testOpportunityEngSMS.DebitOrderThirdParty__c=true;
        testOpportunityEngSMS.Commencement_Date__c = Date.today();
        testOpportunityEngSMS.Debit_Order_Date__c = Date.today();
        testOpportunityEngSMS.CASA_Status__c='Valid';
        testOpportunityEngSMS.Risk_Status__c = 'Valid';
        testOpportunityEngSMS.Adviser__c=testUser.Id;
        testOpportunityEngSMS.Adviser_Employee__c=testAdviser.Id;
        testOpportunityEngSMS.Site__c=testSite.Id;
        insert testOpportunityEngSMS;
        
        //Opportunity Eng Sms
        testOpportunityEngEmail = new Opportunity();
        testOpportunityEngEmail.AccountId = testAccountEng.id;
        testOpportunityEngEmail.RecordTypeId = OpportunityRecordTypeMap.get('Wills').getRecordTypeId();
        testOpportunityEngEmail.Adviser_AB_Number__c = 'TEST001';
        testOpportunityEngEmail.Name = 'TestClass Wills - ENGEMAIL';
        // testOpportunityEngEmail.Product__c = 'ANY AMOUNT - ANY AMOUNT (NOT LISTED)';
        testOpportunityEngEmail.LeadSource = 'Siebel Campaign';
        // testOpportunityEngEmail.Sub_Product__c = '';
        testOpportunityEngEmail.Type = 'Cross Sell';
        testOpportunityEngEmail.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunityEngEmail.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunityEngEmail.StageName = 'Registration';
        testOpportunityEngEmail.CloseDate = Date.today() + 10;
        testOpportunityEngEmail.Will_Number__c = '41000049999';
        testOpportunityEngEmail.Commission_1st_Year__c = 2000;
        testOpportunityEngEmail.Commission_2nd_Year__c = 590;
        testOpportunityEngEmail.Debit_Order_Debit_Day__c='30';
        testOpportunityEngEmail.Debit_Order_Salary_Day__c='10';
        testOpportunityEngEmail.DebitOrderThirdParty__c=true;
        testOpportunityEngEmail.Commencement_Date__c = Date.today();
        testOpportunityEngEmail.Debit_Order_Date__c = Date.today();
        testOpportunityEngEmail.CASA_Status__c='Valid';
        testOpportunityEngEmail.Risk_Status__c = 'Valid';
        testOpportunityEngEmail.Adviser__c=testUser.Id;
        testOpportunityEngEmail.Adviser_Employee__c=testAdviser.Id;
        testOpportunityEngEmail.Site__c=testSite.Id;
        insert testOpportunityEngEmail;
        
        //standardPriceBook 
        standardPriceBook = new Pricebook2();
        standardPriceBook.Id=Test.getStandardPricebookId();
        standardPriceBook.IsActive=true;
        update standardPriceBook;
        
        //Product
        testProduct  =new Product2();
        testProduct.Name='Will';
        testProduct.IsActive=true;
        testProduct.Family='WIMI';
        insert testProduct;
        
        //PriceBookEntry
        testPricebookEntry = new PricebookEntry();
        testPricebookEntry.IsActive=true;
        testPricebookEntry.Pricebook2Id=standardPriceBook.Id;
        testPricebookEntry.Product2Id=testProduct.Id;
        testPricebookEntry.UnitPrice=Math.random();
        insert testPricebookEntry;
        
        
        //Application__c Email
        testApplication = new Application__c();
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
        
        //Application__c Afr SMS
        testApplicationAfrSMS = new Application__c();
        testApplicationAfrSMS.Opportunity__c = testOpportunityAfrSMS.Id;
        testApplicationAfrSMS.Preferred_Email__c='himanshu.nimje@absa.africa';
        testApplicationAfrSMS.Preferred_SMS__c='065892600';
        testApplicationAfrSMS.Preferred_Communication_Method__c='SMS';
        testApplicationAfrSMS.RecordTypeId= AplicationRecordTypeMap.get('Wills').getRecordTypeId();
        testApplicationAfrSMS.Drafting_Fee_Status__c = 'Valid';
        testApplicationAfrSMS.Communication_Preference_Status__c = 'Valid';
        testApplicationAfrSMS.Safe_Custody_Status__c = 'Valid';
        testApplicationAfrSMS.Registration_Status__c = 'New';
        testApplicationAfrSMS.Will_Stock_Confirmation__c=false; 
        insert testApplicationAfrSMS;
        
        //Application__c Eng SMS
        testApplicationEngSMS = new Application__c();
        testApplicationEngSMS.Opportunity__c = testOpportunityEngSMS.Id;
        testApplicationEngSMS.Preferred_Email__c='himanshu.nimje@absa.africa';
        testApplicationEngSMS.Preferred_SMS__c='065892600';
        testApplicationEngSMS.Preferred_Communication_Method__c='SMS';
        testApplicationEngSMS.RecordTypeId= AplicationRecordTypeMap.get('Wills').getRecordTypeId();
        testApplicationEngSMS.Drafting_Fee_Status__c = 'Valid';
        testApplicationEngSMS.Communication_Preference_Status__c = 'Valid';
        testApplicationEngSMS.Safe_Custody_Status__c = 'Valid';
        testApplicationEngSMS.Registration_Status__c = 'New';
        testApplicationEngSMS.Will_Stock_Confirmation__c=false; 
        insert testApplicationEngSMS;
        
        //Application__c Eng Email
        testApplicationEngEmail = new Application__c();
        testApplicationEngEmail.Opportunity__c = testOpportunityEngEmail.Id;
        testApplicationEngEmail.Preferred_Email__c='himanshu.nimje@absa.africa';
        testApplicationEngEmail.Preferred_SMS__c='065892600';
        testApplicationEngEmail.Preferred_Communication_Method__c='Email';
        testApplicationEngEmail.RecordTypeId= AplicationRecordTypeMap.get('Wills').getRecordTypeId();
        testApplicationEngEmail.Drafting_Fee_Status__c = 'Valid';
        testApplicationEngEmail.Communication_Preference_Status__c = 'Valid';
        testApplicationEngEmail.Safe_Custody_Status__c = 'Valid';
        testApplicationEngEmail.Registration_Status__c = 'New';
        testApplicationEngEmail.Will_Stock_Confirmation__c=false; 
        insert testApplicationEngEmail;
        
        //OpportunityLineItem
        TestOpportunityLineItem=new OpportunityLineItem();
        TestOpportunityLineItem.Application__c=testApplication.Id;
        TestOpportunityLineItem.OpportunityId=testOpportunity.Id;
        TestOpportunityLineItem.PricebookEntryId=testPricebookEntry.Id;
        TestOpportunityLineItem.Product2Id=testProduct.Id;
        TestOpportunityLineItem.Quantity=1;
        TestOpportunityLineItem.TotalPrice=TestOpportunityLineItem.Quantity*testPricebookEntry.UnitPrice;
        insert TestOpportunityLineItem;
        
        //Asset
        TestAsset =new Asset();
        TestAsset.SerialNumber='41000049999';
        TestAsset.Name='41000049999';
        TestAsset.RecordTypeId=AssetRecordTypeMap.get('Will').getRecordTypeId();
        TestAsset.AccountId=testAccount.id;
        TestAsset.Opportunity__c=testOpportunity.id;
        TestAsset.Preferred_Communication_Method__c=testApplication.Preferred_Communication_Method__c;
        TestAsset.Preferred_Email__c=testApplication.Preferred_Email__c;
        TestAsset.Preferred_SMS__c=testApplication.Preferred_SMS__c;
        TestAsset.Adviser_Code__c='A12345';
        TestAsset.Product2Id=testProduct.Id;
        insert TestAsset;
        
        //Payment_Plan__c Safe Custody fee
        testPaymentPlan = new Payment_Plan__c();
        testPaymentPlan.Application__c = testApplication.Id;
        testPaymentPlan.Account_Number__c = '1573017159';
        testPaymentPlan.Account_Type__c = 'Cheque';
        testPaymentPlan.Bank_Name__c = 'NEDBANK';
        testPaymentPlan.Branch_Code__c = Integer.valueOf('157342');
        testPaymentPlan.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
        testPaymentPlan.Debit_Order_Commencement_Date__c = Date.valueOf('1970-01-01T00:00:00.000Z');
        testPaymentPlan.Debit_Order_Salary_Day__c = '1';
        testPaymentPlan.Debit_Order_Debit_Day__c = '01';
        testPaymentPlan.Name = 'Cheque - 1573017159';
        testPaymentPlan.Frequency__c = 'Monthly';
        testPaymentPlan.Amount__c = 100.00;
        testPaymentPlan.Reference__c = '12345';
        testPaymentPlan.Method__c = 'Debit Order';
        testPaymentPlan.Status__c = 'New';
        testPaymentPlan.Type__c = 'Will Safe Custody Fee';
        insert testPaymentPlan;
        
        //document
        Document__c  doc = new Document__c();
        doc.Name = 'My document.pdf';
        doc.Reference__c = 'rty564';
        doc.Asset__c = TestAsset.Id;
        insert doc;

        //Payment_Plan__c drafting  fee
        testPaymentPlanDraft = new Payment_Plan__c();
        testPaymentPlanDraft.Application__c = testApplication.Id;
        testPaymentPlanDraft.Account_Number__c = '1573017159';
        testPaymentPlanDraft.Account_Type__c = 'Cheque';
        testPaymentPlanDraft.Bank_Name__c = 'NEDBANK';
        testPaymentPlanDraft.Branch_Code__c = Integer.valueOf('157342');
        testPaymentPlanDraft.Branch_Name__c = 'PHUMULANI MALL TEMBIS (157342)';
        testPaymentPlanDraft.Debit_Order_Commencement_Date__c = Date.valueOf('1970-01-01T00:00:00.000Z');
        testPaymentPlanDraft.Debit_Order_Salary_Day__c = '1';
        testPaymentPlanDraft.Debit_Order_Debit_Day__c = '01';
        testPaymentPlanDraft.Name = 'Cheque - 1573017159';
        testPaymentPlanDraft.Frequency__c = 'Monthly';
        testPaymentPlanDraft.Amount__c = 100.00;
        testPaymentPlanDraft.Reference__c = '12345';
        testPaymentPlanDraft.Method__c = 'Debit Instruction';
        testPaymentPlanDraft.Status__c = 'New';
        testPaymentPlanDraft.Type__c = 'Will Drafting Fee';
        TestPaymentPlanDraft.Fee_Code__c='876786';
        insert testPaymentPlanDraft;
        
        //lookup-Bank 
        testBank = new Lookup__c();
        testBank.RecordTypeId=LookupRecordTypeMap.get('Bank').getRecordTypeId();
        testBank.Name='ABSA BANK LIMITED';
        insert  testBank;
        
        //lookup-Branch
        testBranch = new Lookup__c();
        testBranch.RecordTypeId=LookupRecordTypeMap.get('Branch').getRecordTypeId();
        testBranch.Name='Sandton';
        testBranch.Bank__c=testBank.Id;
        testBranch.Branch_Code__c='100345';
        insert  testBranch;
        
        
        //FNA
        testFna = new Financial_Needs_Analysis__c();
        testFna.Account__c = testAccount.id;
        testFna.Cash__c = 50;
        testFna.Investment__c = 100;
        testFna.Fixed_Properties__c=56;
        testFna.Cash__c=67;
        testFna.Other_Assets__c=87;
        testFna.lump_sum_Assets_Capture__c=345;
        testFna.Mortgages__c=676;
        testFna.Vehicle_Finances__c=565;
        testFna.Credit_Cards__c=567;
        testFna.Personal_Loans__c=4576;
        testFna.Over_Drafts__c=4565;
        testFna.Other_liabilities__c=465;
        insert testFna;
    }
    
    /**
* Creates a base individual client test account record
*
* @return  Account     The created client account test record
*/
    public static Account createAccount() {
        
        Account testAccount = new Account(
            RecordTypeId = accountRecordTypeMap.get('Individual_Client').getRecordTypeId(),
            CIF__c = 'I001',
            Client_Type__c = 'PRIVATE INDIVIDUAL',
            LastName = 'Test Account',
            PersonEmail = 'test@test.com',
            PersonMobilePhone = '0123456789'
        );
        
        try {
            
            insert testAccount;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testAccount;
        
    }
    
    /**
* Creates a base business client test account record
*
* @return  Account     The created client account test record
*/
    public static Account createAccountJointSeveral() {
        
        Account testAccount = new Account(
            RecordTypeId = accountRecordTypeMap.get('Client').getRecordTypeId(),
            CIF__c = 'JS001',
            Client_Type__c = 'JOINT & SEVERAL',
            Name = 'Test Account'
        );
        
        try {
            
            insert testAccount;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testAccount;
        
    }
    
    /**
* Creates a base wills test opportunity with an individual client associated to it
*
* @return  Opportunity     The created opportunity test record
*/
    public static Opportunity createOpportunity() {
        
        Opportunity testOpportunity = new Opportunity(
            RecordTypeId = opportunityRecordTypeMap.get('Wills').getRecordTypeId(),
            Name = 'Test Opportunity',
            AccountId = createAccount().Id,
            CloseDate = Date.today().addDays(5),
            StageName = 'Registration'
        );
        
        try {
            
            insert testOpportunity;
            //Create an associated application__c record
            createApplication(testOpportunity.Id);
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testOpportunity;
    }
    
    /**
* Creates a base wills test Application 
*
* @return  Application     The created Application test record
*/
    public static Application__c createApplication(Id oppId){
        
        Application__c testApplication;
        
        try {
            
            testApplication = new Application__c(
                Opportunity__c = oppId
            );
            insert testApplication;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        
        return testApplication;       
    }
    
    /**
* Creates a base wills test opportunity without a client associated to it
*
* @return  Opportunity     The created opportunity test record
*/
    public static Opportunity createOpportunityWithoutClient() {
        
        Opportunity testOpportunity = new Opportunity(
            RecordTypeId = opportunityRecordTypeMap.get('Wills').getRecordTypeId(),
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(5),
            StageName = 'Registration'
        );
        
        try {
            
            insert testOpportunity;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testOpportunity;
    }
    
    /**
* Returns the standard price book for use in test classes
*
* @return
*/
    public static Pricebook2 getStandardPriceBook() {
        
        Pricebook2 standardPriceBook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        try {
            
            update standardPriceBook;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return standardPriceBook;
        
    }
    
/** Updated Ignecious Mushanguri
 * UpdatedDate 2020/12/09
* Creates a Product2 object record
*
* @param   productName       The name of the Product2 object record
* @param   productFamily     The product family the Product2 object record belongs to
*
* @return  Product2        The Product2 object record
*/
    public static Product2 createProduct(String productName, String productFamily) {
        
        Product2 product = new Product2(
            Name = productName,
            IsActive = true,
            Family = productFamily,
            ProductCode = 'UBRS', // Added productCode 
            Product_Type__c ='PPR' // Added ProductType
        );
        
        try {
            
            insert product;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return product;
        
    }
    /**
    * @description Creates a Sales_Process_Type__c Object
    * @author Ignecious Mushanguri | 09-12-2020 
    * @param salesProcess 
    * @param requestName 
    * @return Sales_Process_Type__c 
    **/
    public static Sales_Process_Type__c createSalesProcessType( String salesProcess, String requestName, String oppRecordType){

        Sales_Process_Type__c salesProcessType = new Sales_Process_Type__c(
            Request_Name__c = requestName,
            Sales_Process__c = salesProcess,
            Opportunity_Record_Type__c = oppRecordType
        );

        try {

            insert salesProcessType;

        } catch(DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());

        } 
        
        return salesProcessType;

        }    
    /**
    * @description Creates Product_Product_Entry__c Object
    * @author Ignecious Mushanguri | 09-12-2020 
    * @param name 
    * @param parentProductId 
    * @param relatedProductId 
    * @return Product_Product_Entry__c 
    **/
    public static Product_Product_Entry__c createProductProductEntry(Id parentProductId,Id relatedProductId){

        Product_Product_Entry__c  productProductEntry = new Product_Product_Entry__c(
            Parent_Product__c = parentProductId,
            Related_Product__c = relatedProductId
        );

        try {

            insert productProductEntry;

        } catch(DmlException e) {

            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

        return productProductEntry;

        }
    
/**
* Creates a Financial_Product__c object record
*
* @param   financialProductName         The name of the Financial_Product__c object record
* @param   financialProductType         The Financial Product Type
*
* @return  Financial_Product__c         The Financial_Product__c object record
*/
    public static Financial_Product__c createFinancialProduct(String financialProductName, String financialProductType) {
        
        Financial_Product__c financialProduct = new Financial_Product__c(
            Name = financialProductName,
            Type__c = financialProductType
        );
        
        try {
            
            insert financialProduct;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return financialProduct;
        
    }
    
    /**
* Creates a PricebookEntry object record
*
* @param   priceBookId     The Id of the PriceBook
* @param   productId       The Id of the Product2 object record
*
* @return  PricebookEntry  The PricebookEntry object record
*/
    public static PricebookEntry createPriceBookEntry(Id priceBookId, Id productId) {
        
        PricebookEntry pricebookEntry = new PricebookEntry(
            IsActive = true,
            Pricebook2Id = priceBookId,
            Product2Id = productId,
            UnitPrice = Math.random()
        );
        
        try {
            
            insert pricebookEntry;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return pricebookEntry;
        
    }
    
    /**
* Creates an OpportunityLineItem object record
*
* @param   oppId               The OpportunityId
* @param   pricebookEntryId    The Id of PricebookEntry object record
*
* @return
*/
    public static OpportunityLineItem createOpportunityLineItem(Id oppId, Id pricebookEntryId) {
        
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem (
            PricebookEntryId = pricebookEntryId,
            OpportunityId = oppId,
            Quantity = 1,
            TotalPrice = (1 * new PriceBookEntriesSelector().selectById(pricebookEntryId).UnitPrice),
            Application__c = new ApplicationsSelector().selectByOpportunityId(oppId).get(0).Id
        );
        
        try {
            
            insert opportunityLineItem;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return opportunityLineItem;
        
    }
    
    /**
* Creates a test User object record
*
* @param roleId        The RoleId of the specified User
* @param profileId     The ProfileId of the specified User
* @param firstName     The User's First Name
* @param lastName      The User's Last Name
*
* @return
*/
    public static User createTestUser(Id roleId, Id profileId, String firstName, String lastName) {
        
        String orgId = userInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User testUser = new User(
            FirstName = firstName,
            LastName = lastName,
            Email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            EmailEncodingKey = 'ISO-8859-1',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'Africa/Johannesburg',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            ProfileId = profileId,
            UserRoleId = roleId
        );
        
        try {
            
            insert testUser;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        return testUser;
    }
    
    /**
* Creates a test Site__c object record
*
* @param siteName  The name of the site
* @param siteCode  The site code of the site
*
* @return
*/
    public static Site__c createSite(String siteName, String siteCode) {
        
        Site__c testSite = new Site__c(
            Name = siteName,
            Site_Code__c = siteCode
        );
        
        try {
            
            insert testSite;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testSite;
        
    }
    
    public static User_Site__c createUserSite(Id userId, Id siteId) {
        
        User_Site__c testUserSite = new User_Site__c(
            User__c = userId,
            Site__c = siteId
        );
        
        try {
            
            insert testUserSite;
            
        } catch (DmlException e) {
            
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            
        }
        
        return testUserSite;
        
    }

    /**
     * Creates an Employee__c object record
     *
     * @param firstName          The employee first name
     * @param middleName        The employee middle name
     * @param lastName          The employee last name
     * @param initials          The employee initials
     * @param idNumber          The employee Id number
     * @param idType            The employee Id type
     * @param email             The employee email
     * @param mobile            The employee mobile
     * @param employeeNumber    The employee employer number
     * @param BRID              The employee BRID
     * @param abNumber          The employee AB number
     * @param adviserCode       The employee adviser code
     *
     * @return  Employee__c     The Employee__c object record
     */
    public static Employee__c createEmployee(
            String firstName, String middleName, String lastName, String initials, String idNumber, String idType,
            String email, String mobile, String employeeNumber, String BRID, String abNumber, String adviserCode
    ) {

        Employee__c testEmployee;

        try {

            testEmployee = new Employee__c(
                Firstname__c = firstName,
                Middle_Name__c = middleName,
                Surname__c = lastName,
                Initials__c = initials,
                ID_Number__c = idNumber,
                ID_Type__c = idType,
                Email__c = email,
                Mobile__c = mobile,
                Employee_Number__c = employeeNumber,
                BRID__c = BRID,
                AB_Number__c = abNumber,
                Advisor_Code__c = adviserCode
            );
            insert testEmployee;

        } catch (DmlException e) {

            System.debug('An unexpected error has occurred: ' + e.getMessage());

        }
        
        return testEmployee;

    }

    /**
     * Creates an Employee_Site__c object record
     *
     * @param employeeId    The employee Id
     * @param siteId        The site Id
     *
     * @return
     */
    public static Employee_Site__c createEmployeeSite(Id employeeId, Id siteId) {

        Employee_Site__c testEmployeeSite;

        try {

            testEmployeeSite = new Employee_Site__c(
                    Active__c = true,
                    Employee__c = employeeId,
                    Site__c = siteId
            );
            insert testEmployeeSite;

        } catch (DmlException e) {

            System.debug('An unexpected error has occurred: ' + e.getMessage());

        }

        return testEmployeeSite;

    }
    
    /**
     * Creates an Service_Type__c object record
     *
     * @param name    		The Service Type Search
     * @param type          The Type
     * @param subtype       The Subtype
     * 
     * Added against W-002766 dated 31/08/2019 by chandra
     * 
     * @return Service_Type__c
     */
    public static Service_Type__c createServiceType(String name, String type, String subtype) {

        Service_Type__c testServiceType;

        try {

            testServiceType = new Service_Type__c(
                    Name = name,
                    Type__c = type,
                    Subtype__c = subtype,
                	Is_Service_Type_Enabled__c = true
            );
            insert testServiceType;

        } catch (DmlException e) {

            System.debug('An unexpected error has occurred: ' + e.getMessage());

        }

        return testServiceType;

    }
}