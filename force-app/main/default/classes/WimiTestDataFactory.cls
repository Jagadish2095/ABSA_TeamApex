/**
* @description Test Factory for WIMI classes
* @author  Kyle Alexander
* @created 2018-07-09
* @updated Derek Hughes
* @updated 2018-09-06
* @updated Changed from using name to using developer name for retrieving record types
*/

public class WimiTestDataFactory {
    public static Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> LookupRecordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> AssetRecordTypeMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    public static Map <String, Schema.RecordTypeInfo> AplicationRecordTypeMap = Application__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

    public Account testAccount;
    public Account testJointAccount;
    public Account testProspectAccount;
    public Contact testContact;
    public Opportunity testOpportunity;
    public Opportunity testOpportunityQuote;
    public Opportunity willOpportunity;
    public Opportunity DDRecordtypeopportunity;
    public Opportunity testMerchantOnboardingOpportunity;
    public Financial_Needs_Analysis__c testFna;
    public Opportunity_Party__c testOpportunityPartyDependant;
    public Opportunity_Party__c testOpportunityPartyDependantSpouse;
    public Opportunity_Party__c testOpportunityPartyBeneficiary;
    public Opportunity_Party__c testOpportunityPartySpouse;
    public Opportunity_Party__c testOpportunityPartySpouse2;
    public List<Opportunity_Party__c> testOpportunityPartyBeneficiaryList = new List<Opportunity_Party__c>();// added by divya
    public List<Opportunity_Party__c> testOpportunityPartyDependantList = new List<Opportunity_Party__c>(); // added by divya
    public Financial_Product__c testFinancialProduct;
    public Clause__c testClause;
    public Lookup__c testBank;
    public Lookup__c testBranch;
    public Quote testQuote;
    public QuoteLineItem testQuoteLineItem;
    public Application__c testApplication;
    public Application__c testApplicationQuote;
    public Payment_Plan__c testPaymentPlan;
    public Asset TestAsset;
    public Lead testLead;
    public Document__c testDocument;
    public Document_Template__c testDocumentTemplate;
    public Document_Template__c test3121DocumentTemplate;
    public Document_Template__c test5122DocumentTemplate;
    public Case testCase;
    public User_Supervisor__c testUserSupervisor;
    public OpportunityLineItem testOppLineItem;
    public OpportunityLineItem testOppLineItemQuote;
    public Application_Product_Merchant__c testAppProdMerch;
    public Application_Product_Merchant__c testAppProdMerchQuote;
    public Digital_Signature_Admin__c testDigitalSignatureAdmin;
    public Digital_Signature_Signatory__c testDigitalSignatureSignatory;
    public Digital_Signature_Admin__c testDigitalSignatureAdminQuote;
    public Digital_Signature_Signatory__c testDigitalSignatureSignatoryQuote;
    public ContentVersion testContentVersion;
    public Account testBizAccount;
    public Document__c testQuoteDocument;
    public Document__c testApplicationFormDocument;
    public Address__c testRegisteredAddress;
    public Address__c testResidentialAddress;
    public Address__c testPhysicalAddress;
    public Address__c testHeadOfficeAddress;
    public Address__c testMasterCourtAddress;
    public Address__c testPostalAddress;
    public Address__c testBusinessAddress;
    public Address__c testEmployersAddress;
    public Site__c testSite;
    public User testuser;
    public AccountContactRelation testAccountContactRelation;
    public Accepted_Card__c testAcceptedCard;
    public ProductContactSignatoryRelationship__c testProductContactSignatoryRelationship;
    public Application_Exposure_Total_Group__c testApplicationExposureTotalGroup;
    public Application_Exposure_Total_Group__c testApplicationExposureTotalGroup2;
    public Application_Scoring__c testApplicationScoring;
    public Application_Scoring__c testApplicationScoring2;
    public Application_Scoring__c testApplicationScoring3;
    public Application_Scoring__c testApplicationScoring4;
    public Application_Scoring__c testApplicationScoring5;
    public Application_Scoring__c testApplicationScoring6;
    public Application_Scoring_Entity__c testScoringEntity;
    public Application_Scoring_Entity__c testScoringEntity1;
    public Application_Principal__c testApplicationPrincipal;
    public Application_Principal__c testApplicationPrincipal2;
    public Application_Principal__c testApplicationPrincipal3;
    public Application_Principal__c testApplicationPrincipal4;
    public Application_Profile__c testApplicationProfile;
    public Application_Profile__c testApplicationProfile2;
    public Application_Financial_Account__c testApplicationFinancialAccount;
    public Application_Exposure__c testApplicationExposure;
    public Application_Exposure__c testApplicationExposure2;
    public Application_Exposure__c testApplicationExposure3;
    public Application_Exposure__c testApplicationExposure4;
    public Application_Exposure__c testApplicationExposure5;
    public Application_Exposure__c testApplicationExposure6;
    public Application_Exposure__c testApplicationExposure7;
    public Application_Exposure__c testApplicationExposure8;
    public Application_Exposure__c testApplicationExposure9;
    public Application_Exposure__c testApplicationExposure10;
    public Application_Exposure__c testApplicationExposure11;
    public Application_Exposure__c testApplicationExposure12;
    public Application_Exposure__c testApplicationExposure13;
    public Application_Exposure__c testApplicationExposure14;
    public Application_Triad__c testApplicationTriad;
    public Application_Exposure_Facility__c testApplicationExposureFacility;
    public Application_Exposure_Facility__c testApplicationExposureFacilityBB;
    public Application_Exposure_Facility__c testApplicationExposureFacilitySLA;
    public Application_Exposure_Facility__c testApplicationExposureFacilityAFBB;
    public Application_Exposure_Facility__c testApplicationExposureFacilityAFR;
    public Application_Exposure_Facility__c testApplicationExposureFacilityMFBB;
    public Application_Exposure_Facility__c testApplicationExposureFacilityMFR;
    public Application_Product__c testApplicationProduct;
    public Application_Product__c testApplicationProductParent;
    public Application_Product__c testApplicationProductNew;

    /**
    * @description WimiTestDataFactory Constructor
    */
    public WimiTestDataFactory(){

        system.debug('AccountRecordTypeMap: '+AccountRecordTypeMap);

        //Site
        testSite = new Site__c(Active__c = true,Branch_Site_Name__c = 'Aberdeen',Site_Code__c = '1010');
        testSite = (Site__c)upsertRecord(testSite);
        //insert testSite;

        //Account
        testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        testAccount.CASA_Reference_Number__c = '1712994';
        testAccount.CASA_Risk_Status__c = 'Low';
        testAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testAccount.CASA_Screening_Status__c = 'Approved';
        testAccount.CASA_Analyst_Comments__c = '30406';
        testAccount.PersonMobilePhone = '0747003747';
       // testAccount.Country_of_Residence__c = 'South Africa';
        testAccount.Country_of_Residence__pc='South Africa';
        testAccount.PersonBirthdate = Date.valueOf('1981-07-11');
        testAccount.FirstName = 'Tony';
        testAccount.External_Siebel_ID__c = '1-1IV9MC';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Nationality__pc = 'South Africa';
        testAccount.Occupation__pc = 'Engineer';
        testAccount.Onboarding_Channel__c = 'Test';
        testAccount.Communication_Language__pc = 'Afrikaans';
        testAccount.PersonTitle = 'Mr.';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.Phone = '0114453322';
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
        testAccount.Alternative_Email__c = 'test@test.com';
        testAccount.Alternative_Email_1__c = 'test@test.com';
        testAccount.Alternative_Email_2__c = 'test@test.com';
        testAccount.Alternative_Email_3__c = 'test@test.com';
        testAccount.Alternative_Email_4__c = 'test@test.com';
        testAccount.Active_Email__c = 'test@test.com';
        testAccount.PersonEmail = 'test@test.com';
        testAccount.PersonAssistantPhone = '0114453322';
        testAccount.PersonAssistantName = 'Test Name';
        testAccount.PersonHomePhone = '0114453322';
        testAccount.PersonOtherPhone = '0114453322';
        testAccount.Phone = '0114453322';
        testAccount.Fax = '0114453322';
        testAccount.FinServ__CurrentEmployer__pc = 'Current Employer';
        testAccount.AccountNumber = '1234567890';//previous value: 0011j00000WkXuGAAV
        testAccount.Identify_the_account_holder_type__c = 'Active Non Financial  Entity (ANFE)';
        testAccount.Date_Established__c = system.today();
        testAccount.registration_number__c = '123456789';
        testAccount = (Account)upsertRecord(testAccount);
        //insert testAccount;


        //Lead
        //Financial Product must be created and associated with the lead - Nelson Chisoko (Dariel)
        Financial_Product__c leadFinancialProduct = new Financial_Product__c(
                Name = 'testLeadFinancialProduct',
                Business_Unit__c = 'WIMI',
                Type__c = 'Insure',
                Product_Type__c = 'Insure'
        );
        leadFinancialProduct = (Financial_Product__c)upsertRecord(leadFinancialProduct);
        //insert leadFinancialProduct;

        //User Supervisor
        List<User> usrs = [SELECT Id FROM USER WHERE IsSupervised__c = true AND isActive=true];
        testUserSupervisor = new User_Supervisor__c();
        testUserSupervisor.Advisor__c = usrs.get(0).id;
        testUserSupervisor.Supervisor__c = usrs.get(1).id;
        testUserSupervisor.Default_Supervisor__c = true;
        testUserSupervisor = (User_Supervisor__c)upsertRecord(testUserSupervisor);
        //insert testUserSupervisor;

        testUser = usrs.get(0);
        testUser.SiteCode__c = '1010';
        testUser = (User)upsertRecord(testUser);
        //update testUser;

        testLead = new Lead();
        testLead.FirstName = 'Test';
        testLead.LastName = 'Lead';
        testLead.MobilePhone = '0747003747';
        testLead.Company = 'Test Lead';
        testLead.Financial_Product__c = leadFinancialProduct.Id;
        testLead.OwnerId = testUserSupervisor.Advisor__c;
        testLead.City='johannesburg';
        testlead.Country='South Africa';
        testlead.Street='test';
        //testlead.Response_Tracking_Code__c = 'TC01';
        testLead = (Lead)upsertRecord(testLead);
        //insert testLead;

        //Joint Account
        testJointAccount = new Account();
        testJointAccount.RecordTypeId = AccountRecordTypeMap.get('Client').getRecordTypeId();
        testJointAccount.Name = 'TEST MR JA & TEST MRS J';
        testJointAccount.Client_Type__c = 'Joint & Several';
        testJointAccount.CASA_Reference_Number__c = '1712994';
        testJointAccount.CASA_Risk_Status__c = 'Low';
        testJointAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testJointAccount.CASA_Screening_Status__c = 'Approved';
        testJointAccount.CASA_Analyst_Comments__c = '30406';
        testJointAccount.Country_of_Registration__c = 'South Africa';
        testJointAccount.CIF__c = 'NAIARA+001';
        testJointAccount.Alternative_Email__c = 'test@test.com';
        testJointAccount.Alternative_Email_1__c = 'test@test.com';
        testJointAccount.Alternative_Email_2__c = 'test@test.com';
        testJointAccount.Alternative_Email_3__c = 'test@test.com';
        testJointAccount.Alternative_Email_4__c = 'test@test.com';
        testJointAccount.Active_Email__c = 'test@test.com';
        testJointAccount = (Account)upsertRecord(testJointAccount);
        //insert testJointAccount;

        //Prospect Account
        testProspectAccount = new Account();
        testProspectAccount.FirstName = 'Test';
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
        testProspectAccount.Alternative_Email__c = 'test@test.com';
        testProspectAccount.Alternative_Email_1__c = 'test@test.com';
        testProspectAccount.Alternative_Email_2__c = 'test@test.com';
        testProspectAccount.Alternative_Email_3__c = 'test@test.com';
        testProspectAccount.Alternative_Email_4__c = 'test@test.com';
        testProspectAccount.Active_Email__c = 'test@test.com';
        testProspectAccount.PersonEmail = 'test@test.com';
        testProspectAccount = (Account)upsertRecord(testProspectAccount);
        //insert testProspectAccount;

        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :testProspectAccount.Id].PersonContactId;

        testAccountContactRelation = new AccountContactRelation();
        testAccountContactRelation.AccountId = testJointAccount.id;
        testAccountContactRelation.ContactId = testProspectAccountContactId;
        testAccountContactRelation.UBO__c = 'Yes';
        testAccountContactRelation.roles='Director;Individual with Authority to Act;Managing Director/Chief Executive Officer;Shareholder/Controller;Contact Person;Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
        testAccountContactRelation = (AccountContactRelation)upsertRecord(testAccountContactRelation);
        //insert testAccountContactRelation;

        //Biz Account
        testBizAccount = new Account();
        testBizAccount.RecordTypeId = AccountRecordTypeMap.get('Prospect').getRecordTypeId();
        testBizAccount.Name = 'TEST MR JA & TEST MRS J';
        testBizAccount.Client_Type__c = 'Joint & Several';
        testBizAccount.CASA_Reference_Number__c = '1712994';
        testBizAccount.CASA_Risk_Status__c = 'Low';
        testBizAccount.CASA_Screening_Date__c = Date.valueOf('2018-06-30');
        testBizAccount.CASA_Screening_Status__c = 'Approved';
        testBizAccount.CASA_Analyst_Comments__c = '30406';
        testBizAccount.Country_of_Registration__c = 'South Africa';
        testBizAccount.CIF__c = 'NAIARA+002';
        testBizAccount.Alternative_Email__c = 'test@test.com';
        testBizAccount.Alternative_Email_1__c = 'test@test.com';
        testBizAccount.Alternative_Email_2__c = 'test@test.com';
        testBizAccount.Alternative_Email_3__c = 'test@test.com';
        testBizAccount.Alternative_Email_4__c = 'test@test.com';
        testBizAccount.Active_Email__c = 'test@test.com';
        testBizAccount = (Account)upsertRecord(testBizAccount);
        //insert testBizAccount;

        //Contact
        testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        testContact.Title = 'Mr.';
        testContact.Salutation = 'Mr.';
        //testContact.AccountId = testJointAccount.Id;
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
        testContact = (Contact)upsertRecord(testContact);
        //insert testContact;

        //Opportunity
        testOpportunity = new Opportunity();
        testOpportunity.AccountId = testAccount.id;
        testOpportunity.Spouse_Account_Id__c = String.valueOf(testAccount.Id);
        testOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('General').getRecordTypeId();
        testOpportunity.Adviser_AB_Number__c = 'TEST001';
        testOpportunity.Name = 'EPP';
        testOpportunity.Product__c = 'Estate Provider Plan';
        testOpportunity.LeadSource = 'Siebel Campaign';
        testOpportunity.Sub_Product__c = 'Estate Provider Plan';
        testOpportunity.Type = 'Cross Sell';
        testOpportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
        testOpportunity.External_Siebel_ID__c = '1-BSGP6F';
        testOpportunity.StageName = 'Not Interested';
        testOpportunity.CloseDate = Date.today() + 10;
        testOpportunity.Will_Number__c = '12345678923';
        testOpportunity.Commission_1st_Year__c = 2000;
        testOpportunity.Commission_2nd_Year__c = 590;
        testOpportunity.Debit_Order_Debit_Day__c = '30';
        testOpportunity.Debit_Order_Salary_Day__c = '10';
        testOpportunity.DebitOrderThirdParty__c = true;
        testOpportunity.Commencement_Date__c = Date.today();
        testOpportunity.Debit_Order_Date__c = Date.today();
        testOpportunity.Debit_Order_Account_Number__c = '1234567890';
        testOpportunity.Selected_Email__c = 'test@test.com';
        testOpportunity.Quote_Status__c = 'Pending'; // Tinashe W-004373
        testOpportunity.OwnerId = testUserSupervisor.Advisor__c;
        testOpportunity = (Opportunity)upsertRecord(testOpportunity);
        //insert testOpportunity;

        // Added by Chenna as part of DD Outbound Sale on 02/11/2020

        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();
        DDRecordtypeopportunity = new Opportunity();
        DDRecordtypeopportunity.AccountId = testAccount.id;
        DDRecordtypeopportunity.RecordTypeId = devRecordTypeId;
        DDRecordtypeopportunity.Adviser_AB_Number__c = 'TEST001';
        DDRecordtypeopportunity.Name = 'EPP';
        DDRecordtypeopportunity.Product__c = 'Estate Provider Plan';
        DDRecordtypeopportunity.LeadSource = 'Siebel Campaign';
        DDRecordtypeopportunity.Sub_Product__c = 'Estate Provider Plan';
        DDRecordtypeopportunity.Type = 'Cross Sell';
        DDRecordtypeopportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
        DDRecordtypeopportunity.External_Siebel_ID__c = '1-BSGP6F';
        DDRecordtypeopportunity.StageName = 'Not Interested';
        DDRecordtypeopportunity.CloseDate = Date.today() + 10;
        DDRecordtypeopportunity.Will_Number__c = '12345678923';
        DDRecordtypeopportunity.Commission_1st_Year__c = 2000;
        DDRecordtypeopportunity.Commission_2nd_Year__c = 590;
        DDRecordtypeopportunity.Debit_Order_Debit_Day__c = '30';
        DDRecordtypeopportunity.Debit_Order_Salary_Day__c = '10';
        DDRecordtypeopportunity.DebitOrderThirdParty__c = true;
        DDRecordtypeopportunity.Commencement_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Account_Number__c = '1234567890';
        DDRecordtypeopportunity.Selected_Email__c = 'test@test.com';
        DDRecordtypeopportunity = (Opportunity)upsertRecord(DDRecordtypeopportunity);
        //insert DDRecordtypeopportunity;

        //Merchant Onboarding Opportunity
        testMerchantOnboardingOpportunity = new Opportunity();
        testMerchantOnboardingOpportunity.AccountId = testAccount.id;
        testMerchantOnboardingOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
        testMerchantOnboardingOpportunity.Adviser_AB_Number__c = 'TEST001';
        testMerchantOnboardingOpportunity.Name = 'EPP';
        testMerchantOnboardingOpportunity.Product__c = 'Estate Provider Plan';
        testMerchantOnboardingOpportunity.LeadSource = 'Siebel Campaign';
        testMerchantOnboardingOpportunity.Sub_Product__c = 'Estate Provider Plan';
        testMerchantOnboardingOpportunity.Type = 'Cross Sell';
        testMerchantOnboardingOpportunity.Originating_Adviser_AB_Number__c = 'EXTC150';
        testMerchantOnboardingOpportunity.External_Siebel_ID__c = '1-BSGP6F';
        testMerchantOnboardingOpportunity.StageName = 'Not Interested';
        testMerchantOnboardingOpportunity.CloseDate = Date.today() + 10;
        testMerchantOnboardingOpportunity.Will_Number__c = '12345678923';
        testMerchantOnboardingOpportunity.Commission_1st_Year__c = 2000;
        testMerchantOnboardingOpportunity.Commission_2nd_Year__c = 590;
        testMerchantOnboardingOpportunity.Debit_Order_Debit_Day__c = '30';
        testMerchantOnboardingOpportunity.Debit_Order_Salary_Day__c = '10';
        testMerchantOnboardingOpportunity.DebitOrderThirdParty__c = true;
        testMerchantOnboardingOpportunity.Commencement_Date__c = Date.today();
        testMerchantOnboardingOpportunity.Debit_Order_Date__c = Date.today();
        testMerchantOnboardingOpportunity.Debit_Order_Account_Number__c = '1234567890';
        testMerchantOnboardingOpportunity.Selected_Email__c = 'test@test.com';
        testMerchantOnboardingOpportunity = (Opportunity)upsertRecord(testMerchantOnboardingOpportunity);
        //insert testMerchantOnboardingOpportunity;

        //WillOpportunity
        willOpportunity = new Opportunity();
        willOpportunity.AccountId = testAccount.id;
        willOpportunity.RecordTypeId = OpportunityRecordTypeMap.get('Wills').getRecordTypeId();
        willOpportunity.Adviser_AB_Number__c = 'TEST001';
        willOpportunity.Name = 'Will';
        willOpportunity.StageName = 'Drafting';
        willOpportunity.CloseDate = Date.today() + 10;
        willOpportunity.Risk_Rating_Date__c = Date.today() - 10;
        willOpportunity.Risk_Rating__c = 'Low';
        willOpportunity = (Opportunity)upsertRecord(willOpportunity);
        //insert willOpportunity;

        //FNA
        testFna = new Financial_Needs_Analysis__c();
        testFna.Account__c = testAccount.id;
        testFna.Cash__c = 50;
        testFna.Investment__c = 100;
        testFna = (Financial_Needs_Analysis__c)upsertRecord(testFna);
        //insert testFna;

        //Opportunity Party - Dependant
        testOpportunityPartyDependant = new Opportunity_Party__c();
        testOpportunityPartyDependant.First_Name__c = 'Test';
        testOpportunityPartyDependant.Last_Name__c = 'Tester';
        testOpportunityPartyDependant.Date_of_Birth__c = Date.valueOf('2002-07-11');
        testOpportunityPartyDependant.Opportunity__c = testOpportunity.id;
        testOpportunityPartyDependant.Party_Type__c = 'Dependant';
        testOpportunityPartyDependant.RSA_ID_Number__c = '0207115025084';
        testOpportunityPartyDependant.Relationship__c = 'Child';
        testOpportunityPartyDependant.Benefit_Split__c = 600;
        testOpportunityPartyDependant = (Opportunity_Party__c)upsertRecord(testOpportunityPartyDependant);
        //insert testOpportunityPartyDependant;

        //Opportunity Party - Spouse
        testOpportunityPartyDependantSpouse = new Opportunity_Party__c();
        testOpportunityPartyDependantSpouse.First_Name__c = 'Test';
        testOpportunityPartyDependantSpouse.Last_Name__c = 'Tester';
        testOpportunityPartyDependantSpouse.Date_of_Birth__c = Date.valueOf('2002-07-12');
        testOpportunityPartyDependantSpouse.Opportunity__c = testOpportunity.id;
        testOpportunityPartyDependantSpouse.Party_Type__c = 'Dependant';
        testOpportunityPartyDependantSpouse.RSA_ID_Number__c = '0207115025082';
        testOpportunityPartyDependantSpouse.Relationship__c = 'Spouse';
        testOpportunityPartyDependantSpouse =  (Opportunity_Party__c)upsertRecord(testOpportunityPartyDependantSpouse);
        //insert testOpportunityPartyDependantSpouse;

        //Opportunity Party - Beneficiary
        testOpportunityPartyBeneficiary = new Opportunity_Party__c();
        testOpportunityPartyBeneficiary.First_Name__c = 'Test2';
        testOpportunityPartyBeneficiary.Last_Name__c = 'Tester2';
        testOpportunityPartyBeneficiary.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartyBeneficiary.Opportunity__c = testOpportunity.id;
        testOpportunityPartyBeneficiary.Party_Type__c = 'Beneficiary';
        testOpportunityPartyBeneficiary.RSA_ID_Number__c = '9007115025085';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 0.5;
        testOpportunityPartyBeneficiary.Relationship__c = 'Child';
        testOpportunityPartyBeneficiary.Beneficiary_Product__c =  'Flexi Funeral';// added by divya
        testOpportunityPartyBeneficiary =  (Opportunity_Party__c)upsertRecord(testOpportunityPartyBeneficiary);
        //insert testOpportunityPartyBeneficiary;
        testOpportunityPartyBeneficiaryList.add(testOpportunityPartyBeneficiary);// added by divya

        //Opportunity Party - Spouse
        testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testOpportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Spouse;Dependant';
        testOpportunityPartyDependant.Relationship__c = 'Spouse';
        testOpportunityPartySpouse =  (Opportunity_Party__c)upsertRecord(testOpportunityPartySpouse);
        //insert testOpportunityPartySpouse;

         //Opportunity Party - Spouse - Added by chenna as part of DD Outbound Success Sale
        testOpportunityPartySpouse2 = new Opportunity_Party__c();
        testOpportunityPartySpouse2.First_Name__c = 'Test2';
        testOpportunityPartySpouse2.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse2.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse2.Opportunity__c = testOpportunity.id;
        testOpportunityPartySpouse2.Party_Type__c = 'Spouse;Dependant';
        testOpportunityPartySpouse2.Relationship__c = 'Spouse';
        testOpportunityPartySpouse2 =  (Opportunity_Party__c)upsertRecord(testOpportunityPartySpouse2);
        //insert testOpportunityPartySpouse2;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'EPP Executor Fees Policy';
        product1.IsActive = true;
        product1 =  (Product2)upsertRecord(product1);
        //insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        pricebookEntry1 = (PricebookEntry)upsertRecord(pricebookEntry1);
        //insert pricebookEntry1;

        Product2 product2 = new Product2();
        product2 = new Product2();
        product2.Name = 'EPP Executor Fees Policy Spouse';
        product2.IsActive = true;
        product2 =  (Product2)upsertRecord(product2);
        //insert product2;
        PricebookEntry pricebookEntry2 = new PricebookEntry();
        pricebookEntry2.UnitPrice = 0;
        pricebookEntry2.Product2Id = product2.id;
        pricebookEntry2.Pricebook2Id = pricebookId;
        pricebookEntry2.IsActive = true;
        pricebookEntry2 = (PricebookEntry)upsertRecord(pricebookEntry2);
        //insert pricebookEntry2;

        Product2 product3 = new Product2();
        product3.Name = 'EPP Estate Bridging Benefit';
        product3.IsActive = true;
        product3 =  (Product2)upsertRecord(product3);
        //insert product3;
        PricebookEntry pricebookEntry3 = new PricebookEntry();
        pricebookEntry3.UnitPrice = 0;
        pricebookEntry3.Product2Id = product3.id;
        pricebookEntry3.Pricebook2Id = pricebookId;
        pricebookEntry3.IsActive = true;
        pricebookEntry3 = (PricebookEntry)upsertRecord(pricebookEntry3);
        //insert pricebookEntry3;

        Product2 product4 = new Product2();
        product4.Name = 'EPP Estate Bridging Benefit Spouse';
        product4.IsActive = true;
        product4 =  (Product2)upsertRecord(product4);
        //insert product4;
        PricebookEntry pricebookEntry4 = new PricebookEntry();
        pricebookEntry4.UnitPrice = 0;
        pricebookEntry4.Product2Id = product4.id;
        pricebookEntry4.Pricebook2Id = pricebookId;
        pricebookEntry4.IsActive = true;
        pricebookEntry4 = (PricebookEntry)upsertRecord(pricebookEntry4);
        //insert pricebookEntry4;

        Product2 product5 = new Product2();
        product5.Name = 'EPP Funeral Benefit';
        product5.IsActive = true;
        product5 =  (Product2)upsertRecord(product5);
        //insert product5;
        PricebookEntry pricebookEntry5 = new PricebookEntry();
        pricebookEntry5.UnitPrice = 0;
        pricebookEntry5.Product2Id = product5.id;
        pricebookEntry5.Pricebook2Id = pricebookId;
        pricebookEntry5.IsActive = true;
        pricebookEntry5 = (PricebookEntry)upsertRecord(pricebookEntry5);
        //insert pricebookEntry5;

        Product2 product6 = new Product2();
        product6.Name = 'EPP Funeral Benefit Spouse';
        product6.IsActive = true;
        product6 =  (Product2)upsertRecord(product6);
        //insert product6;
        PricebookEntry pricebookEntry6 = new PricebookEntry();
        pricebookEntry6.UnitPrice = 0;
        pricebookEntry6.Product2Id = product6.id;
        pricebookEntry6.Pricebook2Id = pricebookId;
        pricebookEntry6.IsActive = true;
        pricebookEntry6 = (PricebookEntry)upsertRecord(pricebookEntry6);
        //insert pricebookEntry6;

        Product2 product7 = new Product2();
        product7.Name = 'Policy Fee';
        product7.IsActive = true;
        product7 =  (Product2)upsertRecord(product7);
        //insert product7;
        PricebookEntry pricebookEntry7 = new PricebookEntry();
        pricebookEntry7.UnitPrice = 0;
        pricebookEntry7.Product2Id = product7.id;
        pricebookEntry7.Pricebook2Id = pricebookId;
        pricebookEntry7.IsActive = true;
        pricebookEntry7 =  (PricebookEntry)upsertRecord(pricebookEntry7);
        //insert pricebookEntry7;

        //Financial Product
        testFinancialProduct = new Financial_Product__c();
        testFinancialProduct.Name = 'Estate Provider Plan';
        //testFinancialProduct.Type__c = 'Insurance';
        testFinancialProduct.Business_Unit__c = 'WIMI';
        testFinancialProduct.Product_Type__c = 'Insure';
        testFinancialProduct.Description__c = 'Test Product';
        testFinancialProduct = (Financial_Product__c)upsertRecord(testFinancialProduct);
        //insert testFinancialProduct;

        //Clauses
        testClause = new Clause__c();
        testClause.Financial_Product__c = testFinancialProduct.id;
        testClause.Name = 'Test Clause';
        testClause.Order__c = 1;
        testClause.Valid_From__c = Date.today();
        testClause.Text_Content__c = '<First Year Commission> <Second Year Commission>';
        testClause = (Clause__c)upsertRecord(testClause);
        //insert testClause;

        //lookup-Bank
        testBank = new Lookup__c();
        testBank.RecordTypeId=LookupRecordTypeMap.get('Bank').getRecordTypeId();
        testBank.Name='ABSA BANK LIMITED';
        testBank = (Lookup__c)upsertRecord(testBank);
        //insert  testBank;

        //lookup-Branch
        testBranch = new Lookup__c();
        testBranch.RecordTypeId=LookupRecordTypeMap.get('Branch').getRecordTypeId();
        testBranch.Name='Sandton';
        testBranch.Bank__c = testBank.Id;
        testBranch.Branch_Code__c = '100345';
        testBranch = (Lookup__c)upsertRecord(testBranch);
        //insert  testBranch;

        //Quote
        testQuote = new Quote();
        testQuote.Name = 'Test Quote';
        testQuote.OpportunityId = testOpportunity.Id;
        testQuote.Pricebook2Id = pricebookId;
        testQuote.Commission_1st_Year__c = 100;
        testQuote.Commission_2nd_Year__c = 20;
        testQuote = (Quote)upsertRecord(testQuote);
        //insert testQuote;

        testOpportunity.SyncedQuoteId=testQuote.id;
        testOpportunity = (Opportunity)upsertRecord(testOpportunity);
        //update testOpportunity;
        //QuoteLineItem
        testQuoteLineItem = new QuoteLineItem();
        testQuoteLineItem.Product2Id = product1.id;
        testQuoteLineItem.QuoteId = testQuote.id;
        testQuoteLineItem.PriceBookEntryID = pricebookEntry1.id;
        testQuoteLineItem.Quantity = 1;
        testQuoteLineItem.UnitPrice = 50;
        testQuoteLineItem.Benefit__c = 'Grocery Benefit';
        testQuoteLineItem = (QuoteLineItem)upsertRecord(testQuoteLineItem);
        //insert testQuoteLineItem;

        //QuoteLineItem product1
        testQuoteLineItem = new QuoteLineItem();
        testQuoteLineItem.Product2Id = product2.id;
        testQuoteLineItem.QuoteId = testQuote.id;
        testQuoteLineItem.PriceBookEntryID = pricebookEntry2.id;
        testQuoteLineItem.Quantity = 1;
        testQuoteLineItem.UnitPrice = 50;
        testQuoteLineItem.Benefit__c = 'U02_U03';
        testQuoteLineItem = (QuoteLineItem)upsertRecord(testQuoteLineItem);
        //insert testQuoteLineItem;

        //QuoteLineItem product2
        testQuoteLineItem = new QuoteLineItem();
        testQuoteLineItem.Product2Id = product3.id;
        testQuoteLineItem.QuoteId = testQuote.id;
        testQuoteLineItem.PriceBookEntryID = pricebookEntry3.id;
        testQuoteLineItem.Quantity = 1;
        testQuoteLineItem.UnitPrice = 50;
        testQuoteLineItem.Benefit__c = 'U01_U03';
        testQuoteLineItem =(QuoteLineItem) upsertRecord(testQuoteLineItem);
        //insert testQuoteLineItem;

        //Application__c
        testApplication = new Application__c();
        testApplication.Opportunity__c = testMerchantOnboardingOpportunity.Id;
        testApplication.Preferred_Communication_Method__c = 'himanshu.nimje@absa.africa';
        testApplication.Preferred_SMS__c = '065892600';
        testApplication.Preferred_Communication_Method__c = 'Email';
        testApplication.Fees_Waived__c = true;
        testApplication.Application_Status__c = 'Pending'; // Tinashe W-004373
        testApplication.Products_And_Services__c = 'NotifyMe';
        testApplication = (Application__c)upsertRecord(testApplication);
        //insert testApplication;

        //ApplicationScoring
		String pcoUpdateResponse = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring = new Application_Scoring__c();
        testApplicationScoring.Stage__c ='1';
        testApplicationScoring.Application_Number__c = testApplication.Id;
        testApplicationScoring.JSON_Request__c = pcoUpdateResponse;
        //testApplicationScoring = (Application_Scoring__c)upsertRecord(testApplicationScoring);
        //insert testApplicationScoring;

          //ApplicationScoring
		String pcoUpdateResponse2 = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring2 = new Application_Scoring__c();
        testApplicationScoring2.Stage__c ='2';
        testApplicationScoring2.Application_Number__c = testApplication.Id;
        testApplicationScoring2.JSON_Request__c = pcoUpdateResponse2;
        testApplicationScoring2 = (Application_Scoring__c)upsertRecord(testApplicationScoring2);
        //insert testApplicationScoring2;

        testScoringEntity = new Application_Scoring_Entity__c();
        testScoringEntity.Application_Scoring__c = testApplicationScoring.Id;
        testScoringEntity.INTENTCLIENTCODE1__c = 'AFIFTAP001';
        testScoringEntity = (Application_Scoring_Entity__c)upsertRecord(testScoringEntity);
        //insert testScoringEntity;

        //ApplicationScoring
		String pcoUpdateResponse3 = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring3 = new Application_Scoring__c();
        testApplicationScoring3.Stage__c ='3';
        testApplicationScoring3.Application_Number__c = testApplication.Id;
        testApplicationScoring3.JSON_Request__c = pcoUpdateResponse3;
        testApplicationScoring3 = (Application_Scoring__c)upsertRecord(testApplicationScoring3);
        //insert testApplicationScoring3;

        //ApplicationScoring
		String pcoUpdateResponse4 = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring4 = new Application_Scoring__c();
        testApplicationScoring4.Stage__c ='4';
        testApplicationScoring4.Application_Number__c = testApplication.Id;
        testApplicationScoring4.JSON_Request__c = pcoUpdateResponse4;
        testApplicationScoring4.ILST_Decision__c ='M';
        testApplicationScoring4.ILST_Decision_Date__c = Date.today();
        testApplicationScoring4.ILST_Decision_Time__c = time.newInstance(1, 60, 60, 200);
        testApplicationScoring4 = (Application_Scoring__c)upsertRecord(testApplicationScoring4);
        //insert testApplicationScoring4;

        //ApplicationScoring
		String pcoUpdateResponse5 = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring5 = new Application_Scoring__c();
        testApplicationScoring5.Stage__c ='5';
        testApplicationScoring5.Application_Number__c = testApplication.Id;
        testApplicationScoring5.JSON_Request__c = pcoUpdateResponse5;
        testApplicationScoring5 = (Application_Scoring__c)upsertRecord(testApplicationScoring5);
        //insert testApplicationScoring5;

        testScoringEntity1 = new Application_Scoring_Entity__c();
        testScoringEntity1.Application_Scoring__c = testApplicationScoring5.Id;
        testScoringEntity1.INTENTCLIENTCODE1__c = 'AFIFTAP001';
        testScoringEntity1.Transunion_PCCE_Id__c = '000000411196';
        testScoringEntity1 = (Application_Scoring_Entity__c)upsertRecord(testScoringEntity1);
        //insert testScoringEntity1;

        //ApplicationScoring
		String pcoUpdateResponse6 = '{"Response":{"ApplicationDV":{"APPAPPAPPLICATIONNUMBER":0,"DERPCOUNIQUENUMBER":"000000007587","DerivedCalcAppData":{"DERAPPEXPO":{"REQTOTADDPOTENTIALOC":100000,"REQPOTENTIALTOTDIRECT":7482303,"REQPOTENTIALTOTGROUP":8105546,"REQPOTENTIALTGBE":100006,"REQPOTENTIALTGAE":1,"REQPOTENTIALTGOE":8105543,"REQPOTENTIALTFL":100006}},"StratRes1":{"RESAPPSCRD":{"CHEQCUTOFF":156,"ODCUTOFF":156,"BCCCUTOFF":156,"FCCUTOFF":156,"GCCUTOFF":156,"TLCUTOFF":133,"BRLCUTOFF":0,"EPSCUTOFF":0,"BGCUTOFF":156,"TRFCUTOFF":156,"AGRICUTOFF":0,"CPFCUTOFF":0,"MOODYCUTOFF":0,"ORDCREDLIMIT":2000000,"ORDCREDSCORINGMANDATE":2500000},"RESAPPGPAM":{"EXPILLUSTDAYSNODECISION":30,"EXPILLUSTDAYSAFTERDECISION":30,"EXPILLUSTDAYSREMOVE":60,"ABSADATARFRESHPERIOD":7,"FRAUDREFERRALPROCESS":30},"RESAPPCMNG":{"REMAXOFFSETREDUC":0.00,"REMINPLUSMINRATE":1.00,"SMMAXOFFSETREDUC":0.50,"SMMINPLUSMINRATE":0.50,"PMMAXOFFSETREDUC":1.00,"PMMINPLUSMINRATE":0.00,"HOCMMAXOFFSETREDUC":8.00,"HOCMMINPLUSMINRATE":0.00}},"Entity01":{"INTENTCLIENTCODE1":"SBSOUTP001","INTENTAPRF":{"RETAILOCE":0,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity01":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"Y","EXISTINGCREDCLIENTINDICATOR":"Y"},"DERENTINST":{"TOTALINSTALLMENTS":2136},"DERENTLMTS":{"TOTALLIMIT":0},"DERENTEXCS":{"TOTALAMNT":6109597},"DERENTARRS":{"TOTALAMNT":298267}},"Entity02":{"INTENTCLIENTCODE1":"FOURIBM001","APPENTIDTYPE":"01","APPENTBUR":{"CONSINPNATID":7010075121089}},"Entity03":{"INTENTAPRF":{"RETAILOCE":8005540,"RETAILOCINST":0,"RETAILMLOANEXP":0,"RETAILMLOANINST":0,"BBOCE":0,"BBOCEINST":0,"BBMLOANEXP":0,"BBMLOANINST":0}},"DerivedCalcEntity03":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity04":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity05":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"DerivedCalcEntity06":{"DERENTCUST":{"EXISTINGCLIENTINDICATOR":"N","EXISTINGCREDCLIENTINDICATOR":"N"}},"ExistingProducts01":{"INTPRDEXST":{"ACCOUNTNUMBER":1000157283}},"APPERRMSG":"DA Error"}}}';
        testApplicationScoring6 = new Application_Scoring__c();
        testApplicationScoring6.Stage__c ='6';
        testApplicationScoring6.Application_Number__c = testApplication.Id;
        testApplicationScoring6.JSON_Request__c = pcoUpdateResponse6;
        testApplicationScoring6 = (Application_Scoring__c)upsertRecord(testApplicationScoring6);
        //insert testApplicationScoring6;

        //Application Exposure Total Group - Total Group Exposure
        testApplicationExposureTotalGroup = new Application_Exposure_Total_Group__c();
        testApplicationExposureTotalGroup.Overall_Control_Branch__c = 'overalll branch';
        testApplicationExposureTotalGroup.Application__c = testApplication.Id;
        testApplicationExposureTotalGroup.Exposure_Policy_Indicator__c = 'policy';
        testApplicationExposureTotalGroup.Requested_Franchise_Code__c = '111';
        testApplicationExposureTotalGroup.Existing_Franchisor_Type_Code__c = 'type111';
        testApplicationExposureTotalGroup.Business_Segment__c = 'bussegment';
        testApplicationExposureTotalGroup.Application_Total_Group__c = 'Total Group Exposure';
        testApplicationExposureTotalGroup.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureTotalGroup = (Application_Exposure_Total_Group__c)upsertRecord(testApplicationExposureTotalGroup);
        //insert testApplicationExposureTotalGroup;

        //Application Exposure Total Group - Client Total Group Exposure
        testApplicationExposureTotalGroup2 = new Application_Exposure_Total_Group__c();
        testApplicationExposureTotalGroup2.Overall_Control_Branch__c = 'overalll branch';
        testApplicationExposureTotalGroup2.Application__c = testApplication.Id;
        testApplicationExposureTotalGroup2.Exposure_Policy_Indicator__c = 'policy';
        testApplicationExposureTotalGroup2.Requested_Franchise_Code__c = '111';
        testApplicationExposureTotalGroup2.Existing_Franchisor_Type_Code__c = 'type111';
        testApplicationExposureTotalGroup2.Business_Segment__c = 'bussegment';
        testApplicationExposureTotalGroup2.Application_Total_Group__c = 'Client Total Group Exposure';
        testApplicationExposureTotalGroup2.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureTotalGroup2 = (Application_Exposure_Total_Group__c)upsertRecord(testApplicationExposureTotalGroup2);
        //insert testApplicationExposureTotalGroup2;

        testApplicationPrincipal = new Application_Principal__c();
        testApplicationPrincipal.Id_Number__c = '123456789111';
        testApplicationPrincipal.CIF__c = 'AFIFTAP011';
        testApplicationPrincipal.Application__c = testApplication.Id;
        testApplicationPrincipal.Principal_Shareholder_Name__c = 'principal shareholder';
        testApplicationPrincipal.Main__c = true;
        testApplicationPrincipal.Is_Part_Of_Application__c = true;
        testApplicationPrincipal.AccConRelId__c = String.ValueOf(testAccountContactRelation.Id);
        testApplicationPrincipal = (Application_Principal__c)upsertRecord(testApplicationPrincipal);
        //insert testApplicationPrincipal;

        testApplicationPrincipal2 = new Application_Principal__c();
        testApplicationPrincipal2.Id_Number__c = '123456789111';
        testApplicationPrincipal2.CIF__c = 'AFIFTAP012';
        testApplicationPrincipal2.Application__c = testApplication.Id;
        testApplicationPrincipal2.Principal_Shareholder_Name__c = 'principal shareholder1';
        testApplicationPrincipal2.Main__c = false;
        testApplicationPrincipal2.Is_Part_Of_Application__c = true;
        testApplicationPrincipal2.AccConRelId__c = String.ValueOf(testAccountContactRelation.Id);
        testApplicationPrincipal2 = (Application_Principal__c)upsertRecord(testApplicationPrincipal2);
        //insert testApplicationPrincipal2;

        testApplicationPrincipal3 = new Application_Principal__c();
        testApplicationPrincipal3.Id_Number__c = '123456789111';
        testApplicationPrincipal3.CIF__c = 'AFIFTAP013';
        testApplicationPrincipal3.Application__c = testApplication.Id;
        testApplicationPrincipal3.Principal_Shareholder_Name__c = 'principal shareholder2';
        testApplicationPrincipal3.Main__c = false;
        testApplicationPrincipal3.Is_Part_Of_Application__c = true;
        testApplicationPrincipal3.AccConRelId__c = String.ValueOf(testAccountContactRelation.Id);
        testApplicationPrincipal3 = (Application_Principal__c)upsertRecord(testApplicationPrincipal3);
        //insert testApplicationPrincipal3;

        testApplicationPrincipal4 = new Application_Principal__c();
        testApplicationPrincipal4.Id_Number__c = '123456789111';
        testApplicationPrincipal4.CIF__c = 'AFIFTAP014';
        testApplicationPrincipal4.Application__c = testApplication.Id;
        testApplicationPrincipal4.Principal_Shareholder_Name__c = 'principal shareholder3';
        testApplicationPrincipal4.Main__c = false;
        testApplicationPrincipal4.Is_Part_Of_Application__c = true;
        testApplicationPrincipal4.AccConRelId__c = String.ValueOf(testAccountContactRelation.Id);
        testApplicationPrincipal4 = (Application_Principal__c)upsertRecord(testApplicationPrincipal4);
        //insert testApplicationPrincipal4;

        testApplicationProfile = new Application_Profile__c();
        testApplicationProfile.Client_CIF_Code__c = 'AFIFTAP001';
        testApplicationProfile.Application__c = testApplication.Id;
        testApplicationProfile.Related_to_Client_ID_or_Reg_Number__c = '123456789';
        testApplicationProfile.Applicant_Type__c = 'Main Applicant';
        testApplicationProfile.PCCE_Id__c = '000000411196';
        testApplicationProfile = (Application_Profile__c)upsertRecord(testApplicationProfile);
        //insert testApplicationProfile;

        testApplicationProfile = new Application_Profile__c();
        testApplicationProfile.Client_CIF_Code__c = 'AFIFTAP002';
        testApplicationProfile.Application__c = testApplication.Id;
        testApplicationProfile.Related_to_Client_ID_or_Reg_Number__c = '123456789';
        testApplicationProfile = (Application_Profile__c)upsertRecord(testApplicationProfile);
        //insert testApplicationProfile;

        testApplicationProfile2 = new Application_Profile__c();
        testApplicationProfile2.Client_CIF_Code__c = 'AFIFTAP020';
        testApplicationProfile2.Application__c = testApplication.Id;
        testApplicationProfile2.Related_to_Client_ID_or_Reg_Number__c = '12345678910';
        testApplicationProfile2.Applicant_Type__c = 'Spouse';
        testApplicationProfile2 = (Application_Profile__c)upsertRecord(testApplicationProfile2);
        //insert testApplicationProfile2;

        testApplicationProfile2 = new Application_Profile__c();
        testApplicationProfile2.Client_CIF_Code__c = 'AFIFTAP021';
        testApplicationProfile2.Application__c = testApplication.Id;
        testApplicationProfile2.Related_to_Client_ID_or_Reg_Number__c = '12345678910';
        testApplicationProfile2 = (Application_Profile__c)upsertRecord(testApplicationProfile2);
        //insert testApplicationProfile2;

        testApplicationFinancialAccount = new Application_Financial_Account__c();
        testApplicationFinancialAccount.Application__c = testApplication.Id;
        testApplicationFinancialAccount.External_Banking_Relationship__c ='External Term Loan';
        testApplicationFinancialAccount = (Application_Financial_Account__c)upsertRecord(testApplicationFinancialAccount);
        //insert testApplicationFinancialAccount;

        testApplicationExposure = new Application_Exposure__c();
        testApplicationExposure.Application__c = testApplication.Id;
        testApplicationExposure.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure.Exposure_Data_Type__c = 'Ordinary Credit';
        testApplicationExposure.Exposure__c = '0.00';
        testApplicationExposure = (Application_Exposure__c)upsertRecord(testApplicationExposure);
        //insert testApplicationExposure;

        testApplicationExposure2 = new Application_Exposure__c();
        testApplicationExposure2.Application__c = testApplication.Id;
        testApplicationExposure2.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure2.Exposure_Data_Type__c = 'Mortgage Residential';
        testApplicationExposure2.Exposure__c = '0.00';
        testApplicationExposure2 = (Application_Exposure__c)upsertRecord(testApplicationExposure2);
        //insert testApplicationExposure2;

        testApplicationExposure3 = new Application_Exposure__c();
        testApplicationExposure3.Application__c = testApplication.Id;
        testApplicationExposure3.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure3.Exposure_Data_Type__c = 'Mortgage CPF';
        testApplicationExposure3.Exposure__c = '0.00';
        testApplicationExposure3 = (Application_Exposure__c)upsertRecord(testApplicationExposure3);
        //insert testApplicationExposure3;

        testApplicationExposure4 = new Application_Exposure__c();
        testApplicationExposure4.Application__c = testApplication.Id;
        testApplicationExposure4.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure4.Exposure_Data_Type__c = 'Mortgage Agriculture';
        testApplicationExposure4.Exposure__c = '0.00';
        testApplicationExposure4 = (Application_Exposure__c)upsertRecord(testApplicationExposure4);
        //insert testApplicationExposure4;

        testApplicationExposure5 = new Application_Exposure__c();
        testApplicationExposure5.Application__c = testApplication.Id;
        testApplicationExposure5.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure5.Exposure_Data_Type__c = 'Mortgage Total';
        testApplicationExposure5.Exposure__c = '0.00';
        testApplicationExposure5 = (Application_Exposure__c)upsertRecord(testApplicationExposure5);
        //insert testApplicationExposure5;

        testApplicationExposure6 = new Application_Exposure__c();
        testApplicationExposure6.Application__c = testApplication.Id;
        testApplicationExposure6.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure6.Exposure_Data_Type__c = 'Total Exposure';
        testApplicationExposure6.Exposure__c = '0.00';
        testApplicationExposure6 = (Application_Exposure__c)upsertRecord(testApplicationExposure6);
        //insert testApplicationExposure6;

        testApplicationExposure7 = new Application_Exposure__c();
        testApplicationExposure7.Application__c = testApplication.Id;
        testApplicationExposure7.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure7.Exposure_Data_Type__c = 'Recovery Exposure';
        testApplicationExposure7.Exposure__c = '0.00';
        testApplicationExposure7 = (Application_Exposure__c)upsertRecord(testApplicationExposure7);
        //insert testApplicationExposure7;

        testApplicationExposure8 = new Application_Exposure__c();
        testApplicationExposure8.Application__c = testApplication.Id;
        testApplicationExposure8.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure8.Exposure_Data_Type__c = 'Ordinary Credit - Total';
        testApplicationExposure8.Exposure__c = '0.00';
        testApplicationExposure8 = (Application_Exposure__c)upsertRecord(testApplicationExposure8);
        //insert testApplicationExposure8;

        testApplicationExposure9 = new Application_Exposure__c();
        testApplicationExposure9.Application__c = testApplication.Id;
        testApplicationExposure9.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure9.Exposure_Data_Type__c = 'Other Ordinary Credit';
        testApplicationExposure9.Exposure__c = '0.00';
        testApplicationExposure9.Client_Name__c =  'Tony Stark';
        testApplicationExposure9 = (Application_Exposure__c)upsertRecord(testApplicationExposure9);
        //insert testApplicationExposure9;

        testApplicationExposure10 = new Application_Exposure__c();
        testApplicationExposure10.Application__c = testApplication.Id;
        testApplicationExposure10.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure10.Exposure_Data_Type__c = 'Loans';
        testApplicationExposure10.Exposure__c = '0.00';
        testApplicationExposure10.Client_Name__c =  'Tony Stark';
        testApplicationExposure10 = (Application_Exposure__c)upsertRecord(testApplicationExposure10);
        //insert testApplicationExposure10;

        testApplicationExposure11 = new Application_Exposure__c();
        testApplicationExposure11.Application__c = testApplication.Id;
        testApplicationExposure11.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure11.Exposure_Data_Type__c = 'Cheques';
        testApplicationExposure11.Exposure__c = '0.00';
        testApplicationExposure11.Client_Name__c =  'Tony Stark';
        testApplicationExposure11 = (Application_Exposure__c)upsertRecord(testApplicationExposure11);
        //insert testApplicationExposure11;

        testApplicationExposure12 = new Application_Exposure__c();
        testApplicationExposure12.Application__c = testApplication.Id;
        testApplicationExposure12.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure12.Exposure_Data_Type__c = 'Credit Card';
        testApplicationExposure12.Exposure__c = '0.00';
        testApplicationExposure12.Client_Name__c =  'Tony Stark';
        testApplicationExposure12 = (Application_Exposure__c)upsertRecord(testApplicationExposure12);
        //insert testApplicationExposure12;

        testApplicationExposure13 = new Application_Exposure__c();
        testApplicationExposure13.Application__c = testApplication.Id;
        testApplicationExposure13.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure13.Exposure_Data_Type__c = 'Asset Finance';
        testApplicationExposure13.Exposure__c = '0.00';
        testApplicationExposure13.Client_Name__c =  'Tony Stark';
        testApplicationExposure13 = (Application_Exposure__c)upsertRecord(testApplicationExposure13);
        //insert testApplicationExposure13;

        testApplicationExposure14 = new Application_Exposure__c();
        testApplicationExposure14.Application__c = testApplication.Id;
        testApplicationExposure14.Client_Code__c = 'AFIFTAP001';
        testApplicationExposure14.Exposure_Data_Type__c = 'Mortgage Loans';
        testApplicationExposure14.Exposure__c = '0.00';
        testApplicationExposure14.Client_Name__c =  'Tony Stark';
        testApplicationExposure14 = (Application_Exposure__c)upsertRecord(testApplicationExposure14);
        //insert testApplicationExposure14;

        testApplicationProductParent = new Application_Product__c();
        testApplicationProductParent.Opportunity__c = testOpportunity.id;
        testApplicationProductParent.Opportunity_Product_Id__c = '001';
        testApplicationProductParent.Alternative_Fund_Code__c = '001';
        testApplicationProductParent.Account_Number__c = 1111;
        testApplicationProductParent.Secured_By_Mortgage_Bond__c = true;
        testApplicationProductParent.Alternative_Fund_Indicator__c = true;
        testApplicationProductParent = (Application_Product__c)upsertRecord(testApplicationProductParent);
        //insert testApplicationProductParent;

        testApplicationProduct = new Application_Product__c();
        testApplicationProduct.Opportunity__c = testOpportunity.id;
        testApplicationProduct.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProduct.Application_Product_Parent__c = testApplicationProductParent.Id;
        testApplicationProduct.Product_State__c = 'Existing';
        testApplicationProduct.Alternative_Fund_Code__c = '001';
        testApplicationProduct.Account_Number__c = 1234;
        testApplicationProduct.Product_Name__c = 'Overdraft';
        testApplicationProduct.Secured_By_Mortgage_Bond__c = true;
        testApplicationProduct.Alternative_Fund_Indicator__c = false;
        testApplicationProduct = (Application_Product__c)upsertRecord(testApplicationProduct);
        //insert testApplicationProduct;

        testApplicationProductNew = new Application_Product__c();
        testApplicationProductNew.Opportunity__c = testOpportunity.id;
        testApplicationProductNew.Opportunity_Product_Id__c = '001';//Dummy Id used to insert for noe becauase Opportunity_Product_Id__c is required and should be linked to an OpportunityLineItem
        testApplicationProductNew.Application_Product_Parent__c = testApplicationProductParent.Id;
        testApplicationProductNew.Product_State__c = 'New';
        testApplicationProductNew.Alternative_Fund_Code__c = '001';
        testApplicationProductNew.Account_Number__c = 1234;
        testApplicationProductNew.Product_Name__c = 'Term Loan';
        testApplicationProduct.Secured_By_Mortgage_Bond__c = true;
        testApplicationProductNew.Alternative_Fund_Indicator__c = false;
        testApplicationProductNew = (Application_Product__c)upsertRecord(testApplicationProductNew);
        //insert testApplicationProductNew;

        testApplicationTriad = new Application_Triad__c();
        testApplicationTriad.client_code__c = 'AFIFTAP001';
        testApplicationTriad.Application__c = testApplication.Id;
        testApplicationTriad.Months_Since_Oldest_Relationship__c = 1000;
        testApplicationTriad = (Application_Triad__c)upsertRecord(testApplicationTriad);
        //insert testApplicationTriad;

        testApplicationExposureFacility = new Application_Exposure_Facility__c();
        testApplicationExposureFacility.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacility.Application__c = testApplication.Id;
        testApplicationExposureFacility.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Retail';
        testApplicationExposureFacility.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacility.Installments_Non_Scored__c = 200;
        testApplicationExposureFacility = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacility);
        //insert testApplicationExposureFacility;

        testApplicationExposureFacilityBB = new Application_Exposure_Facility__c();
        testApplicationExposureFacilityBB.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilityBB.Application__c = testApplication.Id;
        testApplicationExposureFacilityBB.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Business Bank';
        testApplicationExposureFacilityBB.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilityBB.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilityBB = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilityBB);
        //insert testApplicationExposureFacilityBB;

        testApplicationExposureFacilitySLA = new Application_Exposure_Facility__c();
        testApplicationExposureFacilitySLA.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilitySLA.Application__c = testApplication.Id;
        testApplicationExposureFacilitySLA.Approved_Facility__c = 'Settlement Limits Approved';
        testApplicationExposureFacilitySLA.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilitySLA.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilitySLA = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilitySLA);
        //insert testApplicationExposureFacilitySLA;

        testApplicationExposureFacilityAFBB = new Application_Exposure_Facility__c();
        testApplicationExposureFacilityAFBB.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilityAFBB.Application__c = testApplication.Id;
        testApplicationExposureFacilityAFBB.Approved_Facility__c = 'Approved Facilities Asset Finance - Business Bank';
        testApplicationExposureFacilityAFBB.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilityAFBB.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilityAFBB = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilityAFBB);
        //insert testApplicationExposureFacilityAFBB;

        testApplicationExposureFacilityAFR = new Application_Exposure_Facility__c();
        testApplicationExposureFacilityAFR.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilityAFR.Application__c = testApplication.Id;
        testApplicationExposureFacilityAFR.Approved_Facility__c = 'Approved Facilities Asset Finance- Retail';
        testApplicationExposureFacilityAFR.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilityAFR.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilityAFR = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilityAFR);
        //insert testApplicationExposureFacilityAFR;

        testApplicationExposureFacilityMFBB = new Application_Exposure_Facility__c();
        testApplicationExposureFacilityMFBB.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilityMFBB.Application__c = testApplication.Id;
        testApplicationExposureFacilityMFBB.Approved_Facility__c = 'Approved Mortgage Facilities - Business Bank';
        testApplicationExposureFacilityMFBB.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilityMFBB.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilityMFBB = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilityMFBB);
        //insert testApplicationExposureFacilityMFBB;

        testApplicationExposureFacilityMFR = new Application_Exposure_Facility__c();
        testApplicationExposureFacilityMFR.Client_Code__c = 'AFIFTAP001';
        testApplicationExposureFacilityMFR.Application__c = testApplication.Id;
        testApplicationExposureFacilityMFR.Approved_Facility__c = 'Approved Mortgage Facilities - Retail';
        testApplicationExposureFacilityMFR.Exposure_Non_Scored__c = 500;
        testApplicationExposureFacilityMFR.Installments_Non_Scored__c = 200;
        testApplicationExposureFacilityMFR = (Application_Exposure_Facility__c)upsertRecord(testApplicationExposureFacilityMFR);
        //insert testApplicationExposureFacilityMFR;

        //Asset
        TestAsset =new Asset();
        TestAsset.SerialNumber='41000049999';
        TestAsset.Name='41000049999';
        TestAsset.RecordTypeId=AssetRecordTypeMap.get('Will').getRecordTypeId();
        TestAsset.AccountId=testAccount.id;
        TestAsset.Opportunity__c = testOpportunity.id;
        TestAsset.Preferred_Communication_Method__c = testApplication.Preferred_Communication_Method__c;
        TestAsset.Preferred_Email__c = testApplication.Preferred_Email__c;
        TestAsset.Preferred_SMS__c = testApplication.Preferred_SMS__c;
        TestAsset.Adviser_Code__c = 'A12345';

        //Payment_Plan__c
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
        testPaymentPlan = (Payment_Plan__c)upsertRecord(testPaymentPlan);
        //insert testPaymentPlan;

        //Document__c
        testDocument = new Document__c();
        testDocument.Name = 'ROA - April Ludgate 5.pdf';
        testDocument.Type__c = 'Record of Advice';
        testDocument.Opportunity__c = testOpportunity.Id;
        testDocument.Contact__c = testContact.id;
        testDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
        testDocument = (Document__c)upsertRecord(testDocument);
        //insert testDocument;

        testQuoteDocument = new Document__c();
        testQuoteDocument.Name = 'Quote.pdf';
        testQuoteDocument.Type__c = System.Label.Merchant_Quote_Document_Template_Name;
        testQuoteDocument.Opportunity__c = testOpportunity.Id;
        testQuoteDocument.Contact__c = testContact.id;
        testQuoteDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
        testQuoteDocument = (Document__c)upsertRecord(testQuoteDocument);
        //insert testQuoteDocument;

        // Tinashe W-004373
        testApplicationFormDocument = new Document__c();
        testApplicationFormDocument.Name = 'Aplication Form.pdf';
        testApplicationFormDocument.Type__c = 'Application Form';
        testApplicationFormDocument.Opportunity__c = testMerchantOnboardingOpportunity.Id;
        testApplicationFormDocument.Contact__c = testContact.id;
        testApplicationFormDocument.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
        testApplicationFormDocument = (Document__c)upsertRecord(testApplicationFormDocument);
        //insert testApplicationFormDocument;

        //Document_Template__c
        testDocumentTemplate = new Document_Template__c();
        testDocumentTemplate.Name = 'ABSA 3741 - Client Engagement';
        testDocumentTemplate.Client_Type__c = 'Individual Client';
	    testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        testDocumentTemplate.XML__c = '<Schema><ABSA3741><AdviserEmployeeNumber>0939943</AdviserEmployeeNumber><AdviserName>SIFISO</AdviserName><AdviserSignDate>2020-03-10T00:00:00</AdviserSignDate><BusinesssStartDate>2010-03-10T00:00:00</BusinesssStartDate></ABSA3741></Schema>';
        testDocumentTemplate = (Document_Template__c)upsertRecord(testDocumentTemplate);
        //insert testDocumentTemplate;

        testDocumentTemplate = new Document_Template__c();
        testDocumentTemplate.Name = 'ABSA 3141 - Global Application to open/close savings/investment';
        testDocumentTemplate.Client_Type__c = 'PRIVATE COMPANY';
	    testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        testDocumentTemplate.XML__c = '<Schema><ABSA3741><AdviserEmployeeNumber>0939943</AdviserEmployeeNumber><AdviserName>SIFISO</AdviserName><AdviserSignDate>2020-03-10T00:00:00</AdviserSignDate><BusinesssStartDate>2010-03-10T00:00:00</BusinesssStartDate></ABSA3741></Schema>';
        testDocumentTemplate = (Document_Template__c)upsertRecord(testDocumentTemplate);
        //insert testDocumentTemplate;

        testDocumentTemplate = new Document_Template__c();
        testDocumentTemplate.Name = System.Label.Merchant_Quote_Document_Template_Name;
        testDocumentTemplate.XML__c = 'XML';
        testDocumentTemplate.Document_Type__c = System.Label.Merchant_Quote_Document_Template_Name;
        testDocumentTemplate.Signature_Required__c = True;
        testDocumentTemplate.ECM_Account_Number_Metadata__c = true;
        testDocumentTemplate.ECM_Business_Unit_Metadata__c = true;
        testDocumentTemplate.ECM_CIF_Code_Metadata__c = true;
        testDocumentTemplate.ECM_Filing_Date_Metadata__c = true;
        testDocumentTemplate.ECM_ID_Number_Metadata__c = true;
        testDocumentTemplate.ECM_Item_Type__c = 'Ent_Quotation';
        testDocumentTemplate.ECM_Origin_Metadata__c = true;
        testDocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        testDocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        testDocumentTemplate = (Document_Template__c)upsertRecord(testDocumentTemplate);
        //insert testDocumentTemplate;

        test3121DocumentTemplate = new Document_Template__c();
        test3121DocumentTemplate.Name = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
        test3121DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test3121DocumentTemplate.Document_Type__c = 'ABSA 3121 - Physical Site visit conducted for Verification Purposes Confirmation';
        test3121DocumentTemplate.Signature_Required__c = True;
        test3121DocumentTemplate.ECM_Account_Number_Metadata__c = true;
        test3121DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
        test3121DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
        test3121DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
        test3121DocumentTemplate.ECM_ID_Number_Metadata__c = true;
        test3121DocumentTemplate.ECM_Item_Type__c = 'Ent_ProofOfAddress';
        test3121DocumentTemplate.ECM_Origin_Metadata__c = true;
        test3121DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        test3121DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        test3121DocumentTemplate = (Document_Template__c)upsertRecord(test3121DocumentTemplate);
        //insert test3121DocumentTemplate;

        test5122DocumentTemplate = new Document_Template__c();
        test5122DocumentTemplate.Name = 'Absa 5122 EX - Merchant Application Form';
        test5122DocumentTemplate.XML__c = '<Schema>  <ABSA3121_SiteVerificationDetails>    <SiteVerificationDetails></SiteVerificationDetails>    <Id>4074</Id>  </ABSA3121_SiteVerificationDetails>  {{#AccountList}}  <ABSA3121_AccountNumbers>    <AccountNumber>{{AccountNumber}}</AccountNumber>    <ParentId>3039</ParentId>    <Id>781</Id>  </ABSA3121_AccountNumbers> {{/AccountList}}  <AISxMetaData>    <IsCPA>0</IsCPA>    <IsNCA>false</IsNCA>    <Language>E</Language>    <IsDigitalSignature>false</IsDigitalSignature>  </AISxMetaData>  <ABSA3121>    <FormalInformalSettlement>{{Application.Settlement_type__c}}</FormalInformalSettlement>    <SiteVisitDate>{{Application.Site_visit_date__c | format_date}}</SiteVisitDate>    <SiteVisitCPFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</SiteVisitCPFullName>    <CSARefNo>{{Application.Application_Number__c}}</CSARefNo>    <AccountNumber>{{Account.AccountNumber}}</AccountNumber>    <ClientCIF>{{Account.CIF__c}}</ClientCIF>    <InitiatorAbNo>{{User.AB_Number__c}}</InitiatorAbNo>    <SurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SurnameOrEntityName>    <TradingSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</TradingSurnameOrEntityName>    <InitiatorName>{{User.Name}}</InitiatorName>    <InitiatorSurname>{{User.LastName}}</InitiatorSurname>   <IdNo>{{Account.ID_Number__c}}</IdNo>    <IdType>{{Account.ID_Type__c}}</IdType>    <Id>1642</Id>    <PhysicalAddressCity>{{TradingAddress.Shipping_City__c}}</PhysicalAddressCity>    <PhysicalAddressCode>{{TradingAddress.Shipping_Zip_Postal_Code__c}}</PhysicalAddressCode>    <PhysicalAddressSuburb>{{TradingAddress.Shipping_Suburb__c}}</PhysicalAddressSuburb>    <PhysicalAddressLine2>{{TradingAddress.Shipping_State_Province__c}}</PhysicalAddressLine2>    <PhysicalAddressLine1>{{TradingAddress.Shipping_Street__c}}</PhysicalAddressLine1>    <SiteVerificationDetails></SiteVerificationDetails>	<!-- where do we capture than an address was verified-->    <VerifiedAddressInfo></VerifiedAddressInfo>    <PhysicalAddressCountry>{{TradingAddress.Shipping_Country__c}}</PhysicalAddressCountry>    <PhysicalAddressType>{{TradingAddress.Address_Type__c}}</PhysicalAddressType>    <InitiatorTitle>{{User.Title}}</InitiatorTitle>    <Title></Title>    <FullName>{{Account.Name}}</FullName>    <SiteVisitCPTitle>{{Application.Title__c}}</SiteVisitCPTitle>    <SiteVisitCPSurnameOrEntityName>{{Account.Trading_Name__c}}{{Account.LastName}}</SiteVisitCPSurnameOrEntityName>    <TradingFullName>{{Application.First_Name__c}}{{Application.Surname__c}}</TradingFullName>    <TradingTitle></TradingTitle>  </ABSA3121>  <LSOIAddress>  <!-- Not sure what row we talking of here-->    <Row></Row>  </LSOIAddress></Schema>';
        test5122DocumentTemplate.Document_Type__c = 'Absa 5122 EX - Merchant Application Form';
        test5122DocumentTemplate.Signature_Required__c = True;
        test5122DocumentTemplate.ECM_Account_Number_Metadata__c = true;
        test5122DocumentTemplate.ECM_Business_Unit_Metadata__c = true;
        test5122DocumentTemplate.ECM_CIF_Code_Metadata__c = true;
        test5122DocumentTemplate.ECM_Filing_Date_Metadata__c = true;
        test5122DocumentTemplate.ECM_ID_Number_Metadata__c = true;
        test5122DocumentTemplate.ECM_Item_Type__c = 'Ent_ProofOfAddress';
        test5122DocumentTemplate.ECM_Origin_Metadata__c = true;
        test5122DocumentTemplate.Opportunity_Record_Types__c = 'Merchant Onboarding';
        test5122DocumentTemplate.Parent_Document_Type__c = 'Business Client Agreement';
        test5122DocumentTemplate = (Document_Template__c)upsertRecord(test5122DocumentTemplate);
        //insert test5122DocumentTemplate;

        //Case
        testCase = new Case();
        testCase.Subject = 'This is subject';
        testCase.Email_From_Address__c = 'test@test.com';
        testCase.Incident_Date__c = Date.Today();
        testCase = (Case)upsertRecord(testCase);
        //insert testCase;

        testOppLineItem = new OpportunityLineItem();
        testOppLineItem.OpportunityId = testOpportunity.Id;
        testOppLineItem.Product2Id = product1.Id;
        testOppLineItem.PricebookEntryId = pricebookEntry1.Id;
        testOppLineItem.Quantity = 1;
        testOppLineItem.TotalPrice = 100;
        testOppLineItem.Signing_Purpose__c = 'AccountMaintenance';
        testOppLineItem.Signing_Instructions__c = 'Anyone to sign alone';
        testOppLineItem = (OpportunityLineItem)upsertRecord(testOppLineItem);
        //insert testOppLineItem;

        testOppLineItemQuote = new OpportunityLineItem();
        testOppLineItemQuote.OpportunityId = testMerchantOnboardingOpportunity.Id;
        testOppLineItemQuote.Product2Id = product1.Id;
        testOppLineItemQuote.PricebookEntryId = pricebookEntry1.Id;
        testOppLineItemQuote.Quantity = 1;
        testOppLineItemQuote.TotalPrice = 100;
        testOppLineItemQuote.Signing_Purpose__c = 'AccountMaintenance';
        testOppLineItemQuote.Signing_Instructions__c = 'Anyone to sign alone';
        testOppLineItemQuote.Contact_Person__c = testAccountContactRelation.id;
        testOppLineItemQuote = (OpportunityLineItem)upsertRecord(testOppLineItemQuote);
        //insert testOppLineItemQuote;

        testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = testOppLineItem.Id;
        testAppProdMerch = (Application_Product_Merchant__c)upsertRecord(testAppProdMerch);
        //insert testAppProdMerch;

        testAppProdMerchQuote = new Application_Product_Merchant__c();
        testAppProdMerchQuote.Opportunity_Product_Id__c = testOppLineItemQuote.Id;
        testAppProdMerchQuote = (Application_Product_Merchant__c)upsertRecord(testAppProdMerchQuote);
        //insert testAppProdMerchQuote;

        //Start Tnashe added for USSD Story 3951, 4228, 4229
        //Test Digital_Signature_Admin__c
        testDigitalSignatureAdmin = new Digital_Signature_Admin__c();
        testDigitalSignatureAdmin.Document_Type__c = 'Record of Advice';
        testDigitalSignatureAdmin.Number_of_Required_Signatories__c = 1;
        testDigitalSignatureAdmin.Expiry_Unit__c = 'Day';
        testDigitalSignatureAdmin.Expiry_Period__c = 1;
        testDigitalSignatureAdmin = (Digital_Signature_Admin__c)upsertRecord(testDigitalSignatureAdmin);
        //insert testDigitalSignatureAdmin;

        testDigitalSignatureAdminQuote = new Digital_Signature_Admin__c();
        testDigitalSignatureAdminQuote.Document_Type__c = System.Label.Merchant_Quote_Document_Template_Name;
        testDigitalSignatureAdminQuote.Number_of_Required_Signatories__c = 1;
        testDigitalSignatureAdminQuote.Expiry_Unit__c = 'Day';
        testDigitalSignatureAdminQuote.Expiry_Period__c = 1;
        testDigitalSignatureAdminQuote = (Digital_Signature_Admin__c)upsertRecord(testDigitalSignatureAdminQuote);
        //insert testDigitalSignatureAdminQuote;

        //Test Digital_Signature_Signatory__c
        testDigitalSignatureSignatoryQuote = new Digital_Signature_Signatory__c();
        testDigitalSignatureSignatoryQuote.Digital_Signature_Admin__c = testDigitalSignatureAdminQuote.Id;
        testDigitalSignatureSignatoryQuote.Preferred_Method__c = 'Realtime';
        testDigitalSignatureSignatoryQuote.Signatory_Type__c = 'Parent Customer';
        testDigitalSignatureSignatoryQuote.Signatory_Required__c = true;
        testDigitalSignatureSignatoryQuote.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
        testDigitalSignatureSignatoryQuote = (Digital_Signature_Signatory__c)upsertRecord(testDigitalSignatureSignatoryQuote);
        //insert testDigitalSignatureSignatoryQuote;

        testDigitalSignatureSignatory = new Digital_Signature_Signatory__c();
        testDigitalSignatureSignatory.Digital_Signature_Admin__c = testDigitalSignatureAdmin.Id;
        testDigitalSignatureSignatory.Preferred_Method__c = 'Realtime';
        testDigitalSignatureSignatory.Signatory_Type__c = 'Parent Customer';
        testDigitalSignatureSignatory.Signatory_Required__c = true;
        testDigitalSignatureSignatory.Opportunity_Record_Types_Applicable_To__c = 'General;Merchant Onboarding;Product Onboarding';
        testDigitalSignatureSignatory = (Digital_Signature_Signatory__c)upsertRecord(testDigitalSignatureSignatory);
        //insert testDigitalSignatureSignatory;

        ContentVersion testContentVersion = new ContentVersion(Title = 'Penguins',PathOnClient = 'Penguins.pdf',VersionData = Blob.valueOf('Test Content'),IsMajorVersion = true);
        testContentVersion = (ContentVersion)upsertRecord(testContentVersion);
        //insert testContentVersion;
        //End Tinashe Add for USSD Story 3951, 4228, 4229//

        // create addresses for account
        List<Address__c> addressList= new List<Address__c>();
        //testRegisteredAddress = new Address__c(Account__c = testBizAccount.Id, Address_Type__c = 'Registered',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        //addressList.add(testRegisteredAddress);
        //testHeadOfficeAddress = new Address__c(Account__c = testBizAccount.Id, Address_Type__c = 'Head Office',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        //addressList.add(testHeadOfficeAddress);
        //addressList.add(new Address__c(Account__c = testJointAccount.Id, Address_Type__c = 'Registered',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));
        //addressList.add(new Address__c(Account__c = testJointAccount.Id, Address_Type__c = 'Business Address',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));
        addressList.add(new Address__c(Account__c = testJointAccount.Id, Address_Type__c = 'Postal',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));

        addressList.add(new Address__c(Account__c = testBizAccount.Id, Address_Type__c = 'Postal',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));
        addressList.add(new Address__c(Contact__c = testContact.Id, Address_Type__c = 'Postal',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));
        //addressList.add(new Address__c(Contact__c = testContact.Id, Address_Type__c = 'Registered',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City'));

        //testBusinessAddress = new Address__c(Account__c = testBizAccount.Id, Address_Type__c = 'Business Address',Client_Entity_Type__c = 'Joint & Several',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        //addressList.add(testBusinessAddress);

        testResidentialAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Physical Address',Client_Entity_Type__c = 'Individual',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        addressList.add(testResidentialAddress);
        testPhysicalAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Physical Address',Client_Entity_Type__c = 'Individual',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        addressList.add(testPhysicalAddress);
        testPostalAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Postal',Client_Entity_Type__c = 'Individual',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        addressList.add(testPostalAddress);
        testEmployersAddress = new Address__c(Account__c = testAccount.Id, Address_Type__c = 'Employers',Client_Entity_Type__c = 'Individual',Shipping_Country__c = 'South Africa', Shipping_State_Province__c = 'Gauteng',Shipping_Street__c = 'Street 37',Shipping_Suburb__c = 'Maboneng',Shipping_Zip_Postal_Code__c = '1619',Shipping_City__c = 'City');
        addressList.add(testEmployersAddress);
        upsertRecordList(addressList);
        //insert addressList;

        testAcceptedCard = new Accepted_Card__c(Name='Cash Send',Plan_Type__c = 'CS1',Type__c = 'Card;Merchant Fee Category',Pre_Selected_for_Merchant_Class__c = 'FORECOURT;MEDICAL/RETAIL;RESTAURANT;RETAIL;SASOL;WORKSHOP');
        testAcceptedCard = (Accepted_Card__c)upsertRecord(testAcceptedCard);
        //insert testAcceptedCard;

        testProductContactSignatoryRelationship = new ProductContactSignatoryRelationship__c();
        testProductContactSignatoryRelationship.AccountContactRelationshipId__c = testAccountContactRelation.Id;
        testProductContactSignatoryRelationship.In_terms_of_Resolution_date__c = Date.today();
        testProductContactSignatoryRelationship.Number_of_Signatories_for_account__c = '1';
        testProductContactSignatoryRelationship.OpportunityProductId__c = testOppLineItemQuote.Id;
        testProductContactSignatoryRelationship.PrimaryAccountId__c = testAccount.Id;
        testProductContactSignatoryRelationship.Product_Name__c = testOppLineItemQuote.Product2.name;
        testProductContactSignatoryRelationship.Signing_Instructions__c = 'Anyone to sign alone';
        testProductContactSignatoryRelationship.Signing_Purpose__c = 'IssueCards';
        testProductContactSignatoryRelationship.SigningAuthorityFromDate__c = Date.today();
        testProductContactSignatoryRelationship = (ProductContactSignatoryRelationship__c)upsertRecord(testProductContactSignatoryRelationship);
        //insert testProductContactSignatoryRelationship;/*/
    }

    /**
     * @description method to run dml operations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-17
     * @param obj
     * @return SObject
    **/
    private static SObject upsertRecord(sObject obj){
        if(obj != null){
            upsert obj;
            return obj;
        }
        return null;
    }

    /**
     * @description method to run dml operations
     * @author englarmerdge.mongwe@absa.africa | 2021-06-17
     * @param obj
    **/
    private static void upsertRecordList(List<sObject> obj){
        if(obj != null && obj.size() > 0){
            upsert obj;
        }
    }
}