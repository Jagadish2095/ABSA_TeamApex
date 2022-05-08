/**
 * @description       : Test class for ClientDetailsSectionCredit
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-18
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                  Modification
 * 1.0   2021-06-11   Ephetehe Mokgopanyane   Initial Version
**/

@IsTest
public class ClientDetailsSectionCreditTest {
	/**
	 * @description : Method to create test data
	 * @author Ephetehe Mokgopanyane | 2021-06-11
	**/
	@testSetup
	public static void dataCreation() {
        insertUser();

		Account account = new Account();
		account.Name = 'Test Account';
		account.Client_Type__c = 'Private Individual';
		account.CIF__c = 'SNIFFEL001';
		account.Sic = '35790';
		account.AccountNumber = '0';
		account.Registration_Number__c = '1990/011515/23';
        insert account;

		BusinessHours bh = [SELECT Id, Name FROM BusinessHours WHERE Name = '24 Hours including Public Holidays'];
        User u = [SELECT Id, UserRoleId FROM User LIMIT 1];

		Case caseRec = new Case();
		caseRec.BusinessHoursId = bh.Id;
		caseRec.Subject = 'Test Case';
		caseRec.AccountId = account.Id;
		caseRec.Banker_RE__c = u.UserRoleId;
		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding 1';
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

		Application__c app = new Application__c();
		app.Opportunity__c = testOpp.id;
		app.Account_Access__c = 'Cellphone';
		app.Surplus_Cash__c = 'Fixed Deposits';
		app.Borrowing_Requiment_General__c = 'Credit Card';
		app.Protection_Of_Services__c = 'Retirement';
		app.Title__c = 'dd';
		app.FirstNameSignature__c = 'Litha';
		app.SurnameSignature__c = 'Nosekeleza';
		app.Signing_Date__c = System.today();
		app.Stock_Number__c = '';
        insert app;

		Account testJointAccount = new Account();
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
		acr.Share_Percentage__c = 10;
		acr.StartDate = date.today();
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

		Opportunity opp4 = new Opportunity();
		opp4.Name = 'Credit Onboarding';
		opp4.CloseDate = Date.today();
		opp4.StageName = 'New';
		opp4.AccountId = account.Id;
        insert opp4;

		Opportunity oppCovid = new Opportunity();
		oppCovid.Name = 'Covid Onboarding';
		oppCovid.CloseDate = Date.today();
		oppCovid.StageName = 'New';
		oppCovid.AccountId = account.Id;
		Id recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Credit Maintenance').getRecordTypeId();
		oppCovid.RecordTypeId = recordTypeId;
        insert oppCovid;

        Opportunity opp5 = new Opportunity();
		opp5.Name = 'Cheque Credit Onboarding';
		opp5.CloseDate = Date.today();
		opp5.StageName = 'New';
		opp5.AccountId = account.Id;
		opp5.RecordTypeId = recordTypeId;
		opp5.Illustrative_Decision__c = false;
        insert opp5;

		Application__c appcovid = new Application__c();
		appcovid.Opportunity__c = opp5.id;
		appcovid.Title__c = 'Dr';
		appcovid.FirstNameSignature__c = 'Rob';
		appcovid.SurnameSignature__c = 'Robbello';
		appcovid.Signing_Date__c = System.today();
        insert appcovid;

        //Application_Product__c
        Application_Product__c appProd = new Application_Product__c();
        appProd.Opportunity__c = opp5.id;
        appProd.Opportunity_Product_Id__c = opp5.id;
        appProd.Alternative_Fund_Code__c = '001';
        appProd.Account_Number__c=1111;
        appProd.Product_Type__c = 'CLASSIC BUSINESS ACCOUNT';
        appProd.Secured_By_Mortgage_Bond__c = true;
        appProd.Alternative_Fund_Indicator__c=true;
        appProd.Annual_Turnover__c = 11234;
        appProd.Asset_Value__c=43210;
        insert appProd;

        //Application_Product__c
        Application_Product__c appProdParent = new Application_Product__c();
        appProdParent.Opportunity__c = opp5.id;
        appProdParent.Opportunity_Product_Id__c = opp5.id;
        appProdParent.Application_Product_Parent__c = appProd.Id;
        appProdParent.Product_State__c = 'Existing';
        appProdParent.Alternative_Fund_Code__c = '001';
        appProdParent.Account_Number__c=1234;
        appProdParent.Product_Name__c='Overdraft';
        appProdParent.Secured_By_Mortgage_Bond__c = true;
        appProdParent.Alternative_Fund_Indicator__c=false;
        insert appProdParent;

		IntegrationTestDataFactory.insertIntegrationTranslations();
		Opportunity opp = new Opportunity(Name = 'my opportunity');
		opp.CloseDate = Date.today();
		opp.StageName = 'Drafting';
        insert opp;

		Application__c app2 = new Application__c();
		app2.Opportunity__c = opp2.id;
		app2.Account_Access__c = 'Cellphone';
		app2.Surplus_Cash__c = 'Fixed Deposits';
		app2.Borrowing_Requiment_General__c = 'Credit Card';
		app2.Protection_Of_Services__c = 'Retirement';
		app2.Title__c = 'dd';
		app2.FirstNameSignature__c = 'Litha';
		app2.SurnameSignature__c = 'Nosekeleza';
		app2.Signing_Date__c = System.today();
        insert app2;

		Document__c doc = new Document__c(Name = 'mydoc.pdf', Reference__c = '12345', Opportunity__c = opp.Id);
        insert doc;

		Document__c doc2 = new Document__c(Name = 'mydoc2.pdf', Reference__c = '123456', Opportunity__c = opp.Id);
        insert doc2;

		Document_Template__c dt = new Document_Template__c(Name = 'Absa 3741 Client Engagement', Client_Type__c = 'Private Individual', Document_Type__c = 'Absa 3741 Client Engagement');
        insert dt;

		//E. MONGWE
		account = new Account();
		account.Name = 'REBELLO Test contact';
		account.Client_Type__c = 'Sole Trader';
		account.CIF__c = 'REBELLO001';
        insert account;

		contact = new Contact(LastName = 'REBELLO Test Contact', AccountId = account.Id, Email = 'mxm@support.co.za');
        insert contact;

		app2 = new Application__c();
		app2.Opportunity__c = opp5.id;
		app2.Account_Access__c = 'Cellphone';
		app2.Surplus_Cash__c = 'Fixed Deposits';
		app2.Borrowing_Requiment_General__c = 'Credit Card';
		app2.Protection_Of_Services__c = 'Retirement';
		app2.Title__c = 'Dr';
		app2.FirstNameSignature__c = 'Rob';
		app2.SurnameSignature__c = 'Rob Van Wyk';
		app2.Signing_Date__c = System.today();
        insert app2;

		prod = new Product2(Name = 'Business Essentials Account', Family = 'Cheque', ProductCode = '11016');
        insert prod;

		prod = new Product2(Name = 'Absa Wealth Personal Cheque', Family = 'Cheque', ProductCode = '11015');
        insert prod;

		prod = new Product2(Name = 'Classic Business Account', Family = 'Cheque', ProductCode = '11021');
        insert prod;

		prod = new Product2(Name = 'Absa Wealth Business', Family = 'Cheque', ProductCode = '11026');
        insert prod;

		Id prbId = Test.getStandardPricebookId();
		standardPrice = new PricebookEntry(Pricebook2Id = prbId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

		customPB = new Pricebook2(Name = 'Standard Pricebook', isActive = true);
        insert customPB;

		customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

		oppLineItem = new OpportunityLineItem();
		oppLineItem.OpportunityId = opp5.id;
		oppLineItem.Product2Id = prod.id;
		oppLineItem.PricebookEntryId = customPrice.id;
		oppLineItem.Quantity = 1;
		oppLineItem.TotalPrice = 100;
        insert oppLineItem;

		Product2 prod2 = new Product2(Name = 'Overdraft', Family = 'Cheque');
        insert prod2;

		OpportunityLineItem oppLineItem2 = new OpportunityLineItem();
		oppLineItem2.Parent_Opportunity_Line_Item_Id__c = oppLineItem.id;
		oppLineItem2.OpportunityId = opp5.id;
		oppLineItem2.Product2Id = prod2.id;
		oppLineItem2.PricebookEntryId = customPrice.id;
		oppLineItem2.Quantity = 1;
		oppLineItem2.TotalPrice = 100;
        insert oppLineItem2;

		OpportunityLineItem oppLineItemcovid = new OpportunityLineItem();
		oppLineItemcovid.OpportunityId = oppCovid.Id;
		oppLineItemcovid.Product2Id = prod2.id;
		oppLineItemcovid.PricebookEntryId = customPrice.id;
		oppLineItemcovid.Quantity = 1;
		oppLineItemcovid.TotalPrice = 100;
        insert oppLineItemcovid;

		Application_Principal__c appPrin = new Application_Principal__c();
		appPrin.Application__c = app2.Id;
		appPrin.Casa_Reference__c = account.CASA_Reference_Number__c;
		appPrin.Casa_Result__c = account.CASA_Screening_Status__c;
		appPrin.CIF__c = account.CIF__c;
		appPrin.Controlling_Interest__c = 10;
		appPrin.Id_Number__c = '';
		appPrin.Main__c = true;
		appPrin.Principal_Shareholder_Name__c = account.Name;
        insert appPrin;

		List<Application_Profile__c> appProfileList = new List<Application_Profile__c>();
		Application_Profile__c appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Main Applicant';
		appProfile.Is_Main_Applicant__c = true;
		appProfile.Client_CIF_Code__c = account.CIF__c;
		appProfile.Client_Name__c = account.Name;
		appProfile.Application__c = app2.Id;
        appProfileList.add(appProfile);

		appProfile = new Application_Profile__c();
		appProfile.Applicant_Type__c = 'Principal';
		appProfile.Is_Main_Applicant__c = false;
		appProfile.Client_CIF_Code__c = 'SNIFFEL001';
		appProfile.Client_Name__c = account.Name;
		appProfile.Application__c = app2.Id;
		appProfileList.add(appProfile);
        insert appProfileList;

		Questionnaire_Template__c qTemp = new Questionnaire_Template__c();
		qTemp.Name = 'General Qualitative Information';
        insert qTemp;

		Questionnaire_Question__c qQues = new Questionnaire_Question__c();
		qQues.Question__c = 'Wassup Dawg';
		qQues.Question_Label__c = 'Wassup Dawg';
		qQues.Include_Comment__c = true;
		qQues.Section__c = 'Artist Info';
		qQues.Default_Answer__c = '';
		qQues.Answer_Options__c = '';
		qQues.Answer_Type__c = 'String';
		qQues.Answer_Control_Type__c = 'Textbox';
		qQues.Questionnaire_Template__c = qTemp.Id;
        insert qQues;

		List<Application_Financial_Information__c> appFinInfoList = new List<Application_Financial_Information__c>();
		Application_Financial_Information__c appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Forecast';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year1';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year2';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
        appFinInfoList.add(appFinInfo);

		appFinInfo = new Application_Financial_Information__c();
		appFinInfo.Application__c = app2.Id;
		appFinInfo.Client_Name__c = 'REBELLO';
		appFinInfo.Year_Selection__c = 'Year3';
		appFinInfo.Financial_Statement_Type__c = 'Draft';
		appFinInfo.Statement_Date_Year_end__c = Date.today();
		appFinInfo.Auditor_s_Certificate_Date__c = Date.today();
		appFinInfo.Date_Financials_Signed_Client__c = Date.today();
		appFinInfo.Financial_Statement_Qualified_Issue__c = 'No';
		appFinInfo.Qualification_Comments__c = 'Comments';
		appFinInfo.No_of_Days__c = 365;
		appFinInfoList.add(appFinInfo);
        insert appFinInfoList;

		Application_Financial_Account__c appFinAcc = new Application_Financial_Account__c();
		appFinAcc.External_Banking_Relationship__c = 'Test External Relation';
		appFinAcc.Application__c = app2.Id;
        insert appFinAcc;

		List<Application_Exposure_Facility__c> appExposureFacilities = new List<Application_Exposure_Facility__c>();
		Application_Exposure_Facility__c settlementLimits = new Application_Exposure_Facility__c();
		settlementLimits.Application__c = app2.Id;
		settlementLimits.Approved_Facility__c = 'Settlement Limits Approved';
		settlementLimits.Client_Name__c = 'REBELLO';
		settlementLimits.Client_Code__c = 'REBELLO001';
		settlementLimits.Exposure_Non_Scored__c = 100;
		settlementLimits.Exposure_Scored__c = 100;
		settlementLimits.Installments_Non_Scored__c = 100;
		settlementLimits.Installments_Scored__c = 100;
        appExposureFacilities.add(settlementLimits);

		Application_Exposure_Facility__c ordnryCreditBusBank = new Application_Exposure_Facility__c();
		ordnryCreditBusBank.Application__c = app2.Id;
		ordnryCreditBusBank.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Business Bank';
		ordnryCreditBusBank.Client_Name__c = 'REBELLO';
		ordnryCreditBusBank.Client_Code__c = 'REBELLO001';
		ordnryCreditBusBank.Exposure_Non_Scored__c = 100;
		ordnryCreditBusBank.Exposure_Scored__c = 100;
		ordnryCreditBusBank.Installments_Non_Scored__c = 100;
		ordnryCreditBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditBusBank);

		Application_Exposure_Facility__c ordnryCreditRetail = new Application_Exposure_Facility__c();
		ordnryCreditRetail.Application__c = app2.Id;
		ordnryCreditRetail.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Retail';
		ordnryCreditRetail.Client_Name__c = 'REBELLO';
		ordnryCreditRetail.Client_Code__c = 'REBELLO001';
		ordnryCreditRetail.Exposure_Non_Scored__c = 100;
		ordnryCreditRetail.Exposure_Scored__c = 100;
		ordnryCreditRetail.Installments_Non_Scored__c = 100;
		ordnryCreditRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditRetail);

		Application_Exposure_Facility__c assetFinBusBank = new Application_Exposure_Facility__c();
		assetFinBusBank.Application__c = app2.Id;
		assetFinBusBank.Approved_Facility__c = 'Approved Facilities Asset Finance - Business Bank';
		assetFinBusBank.Client_Name__c = 'REBELLO';
		assetFinBusBank.Client_Code__c = 'REBELLO001';
		assetFinBusBank.Exposure_Non_Scored__c = 100;
		assetFinBusBank.Exposure_Scored__c = 100;
		assetFinBusBank.Installments_Non_Scored__c = 100;
		assetFinBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinBusBank);

		Application_Exposure_Facility__c assetFinRetail = new Application_Exposure_Facility__c();
		assetFinRetail.Application__c = app2.Id;
		assetFinRetail.Approved_Facility__c = 'Approved Facilities Asset Finance- Retail';
		assetFinRetail.Client_Name__c = 'REBELLO';
		assetFinRetail.Client_Code__c = 'REBELLO001';
		assetFinRetail.Exposure_Non_Scored__c = 100;
		assetFinRetail.Exposure_Scored__c = 100;
		assetFinRetail.Installments_Non_Scored__c = 100;
		assetFinRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinRetail);

		Application_Exposure_Facility__c mortgageFacBusBank = new Application_Exposure_Facility__c();
		mortgageFacBusBank.Application__c = app2.Id;
		mortgageFacBusBank.Approved_Facility__c = 'Approved Mortgage Facilities - Business Bank';
		mortgageFacBusBank.Client_Name__c = 'REBELLO';
		mortgageFacBusBank.Client_Code__c = 'REBELLO001';
		mortgageFacBusBank.Exposure_Non_Scored__c = 100;
		mortgageFacBusBank.Exposure_Scored__c = 100;
		mortgageFacBusBank.Installments_Non_Scored__c = 100;
		mortgageFacBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacBusBank);

		Application_Exposure_Facility__c mortgageFacRetail = new Application_Exposure_Facility__c();
		mortgageFacRetail.Application__c = app2.Id;
		mortgageFacRetail.Approved_Facility__c = 'Approved Mortgage Facilities - Retail';
		mortgageFacRetail.Client_Name__c = 'REBELLO';
		mortgageFacRetail.Client_Code__c = 'REBELLO001';
		mortgageFacRetail.Exposure_Non_Scored__c = 100;
		mortgageFacRetail.Exposure_Scored__c = 100;
		mortgageFacRetail.Installments_Non_Scored__c = 100;
		mortgageFacRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacRetail);

		Application_Exposure_Facility__c appFacTotal = new Application_Exposure_Facility__c();
		appFacTotal.Application__c = app2.Id;
		appFacTotal.Approved_Facility__c = 'Approved Facilities Total';
		appFacTotal.Client_Name__c = 'REBELLO';
		appFacTotal.Client_Code__c = 'REBELLO001';
		appFacTotal.Exposure_Non_Scored__c = 100;
		appFacTotal.Exposure_Scored__c = 100;
		appFacTotal.Installments_Non_Scored__c = 100;
		appFacTotal.Installments_Scored__c = 100;
        appExposureFacilities.add(appFacTotal);

		settlementLimits = new Application_Exposure_Facility__c();
		settlementLimits.Application__c = app2.Id;
		settlementLimits.Approved_Facility__c = 'Settlement Limits Approved';
		settlementLimits.Client_Name__c = 'TUMI';
		settlementLimits.Client_Code__c = 'REBELLO002';
		settlementLimits.Exposure_Non_Scored__c = 100;
		settlementLimits.Exposure_Scored__c = 100;
		settlementLimits.Installments_Non_Scored__c = 100;
		settlementLimits.Installments_Scored__c = 100;
        appExposureFacilities.add(settlementLimits);

		ordnryCreditBusBank = new Application_Exposure_Facility__c();
		ordnryCreditBusBank.Application__c = app2.Id;
		ordnryCreditBusBank.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Business Bank';
		ordnryCreditBusBank.Client_Name__c = 'TUMI';
		ordnryCreditBusBank.Client_Code__c = 'REBELLO002';
		ordnryCreditBusBank.Exposure_Non_Scored__c = 100;
		ordnryCreditBusBank.Exposure_Scored__c = 100;
		ordnryCreditBusBank.Installments_Non_Scored__c = 100;
		ordnryCreditBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditBusBank);

		ordnryCreditRetail = new Application_Exposure_Facility__c();
		ordnryCreditRetail.Application__c = app2.Id;
		ordnryCreditRetail.Approved_Facility__c = 'Approved Facilities Ordinary Credit - Retail';
		ordnryCreditRetail.Client_Name__c = 'TUMI';
		ordnryCreditRetail.Client_Code__c = 'REBELLO002';
		ordnryCreditRetail.Exposure_Non_Scored__c = 100;
		ordnryCreditRetail.Exposure_Scored__c = 100;
		ordnryCreditRetail.Installments_Non_Scored__c = 100;
		ordnryCreditRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(ordnryCreditRetail);

		assetFinBusBank = new Application_Exposure_Facility__c();
		assetFinBusBank.Application__c = app2.Id;
		assetFinBusBank.Approved_Facility__c = 'Approved Facilities Asset Finance - Business Bank';
		assetFinBusBank.Client_Name__c = 'TUMI';
		assetFinBusBank.Client_Code__c = 'REBELLO002';
		assetFinBusBank.Exposure_Non_Scored__c = 100;
		assetFinBusBank.Exposure_Scored__c = 100;
		assetFinBusBank.Installments_Non_Scored__c = 100;
		assetFinBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinBusBank);

		assetFinRetail = new Application_Exposure_Facility__c();
		assetFinRetail.Application__c = app2.Id;
		assetFinRetail.Approved_Facility__c = 'Approved Facilities Asset Finance- Retail';
		assetFinRetail.Client_Name__c = 'TUMI';
		assetFinRetail.Client_Code__c = 'REBELLO002';
		assetFinRetail.Exposure_Non_Scored__c = 100;
		assetFinRetail.Exposure_Scored__c = 100;
		assetFinRetail.Installments_Non_Scored__c = 100;
		assetFinRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(assetFinRetail);

		mortgageFacBusBank = new Application_Exposure_Facility__c();
		mortgageFacBusBank.Application__c = app2.Id;
		mortgageFacBusBank.Approved_Facility__c = 'Approved Mortgage Facilities - Business Bank';
		mortgageFacBusBank.Client_Name__c = 'TUMI';
		mortgageFacBusBank.Client_Code__c = 'REBELLO002';
		mortgageFacBusBank.Exposure_Non_Scored__c = 100;
		mortgageFacBusBank.Exposure_Scored__c = 100;
		mortgageFacBusBank.Installments_Non_Scored__c = 100;
		mortgageFacBusBank.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacBusBank);

		mortgageFacRetail = new Application_Exposure_Facility__c();
		mortgageFacRetail.Application__c = app2.Id;
		mortgageFacRetail.Approved_Facility__c = 'Approved Mortgage Facilities - Retail';
		mortgageFacRetail.Client_Name__c = 'TUMI';
		mortgageFacRetail.Client_Code__c = 'REBELLO002';
		mortgageFacRetail.Exposure_Non_Scored__c = 100;
		mortgageFacRetail.Exposure_Scored__c = 100;
		mortgageFacRetail.Installments_Non_Scored__c = 100;
		mortgageFacRetail.Installments_Scored__c = 100;
        appExposureFacilities.add(mortgageFacRetail);

		appFacTotal = new Application_Exposure_Facility__c();
		appFacTotal.Application__c = app2.Id;
		appFacTotal.Approved_Facility__c = 'Approved Facilities Total';
		appFacTotal.Client_Name__c = 'TUMI';
		appFacTotal.Client_Code__c = 'REBELLO002';
		appFacTotal.Exposure_Non_Scored__c = 100;
		appFacTotal.Exposure_Scored__c = 100;
		appFacTotal.Installments_Non_Scored__c = 100;
		appFacTotal.Installments_Scored__c = 100;
		appExposureFacilities.add(appFacTotal);
        insert appExposureFacilities;

		List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();
		Application_Exposure__c appExposure = new Application_Exposure__c();
		appExposure.Application__c = app2.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
		appExposure.Product__c = 'CHEQ';
		appExposure.subIndicator__c = 'O';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        appExposures.add(appExposure);

		appExposure = new Application_Exposure__c();
		appExposure.Application__c = app2.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
		appExposure.Product__c = 'AGRI';
		appExposure.subIndicator__c = 'O';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_PRODUCT;
        appExposures.add(appExposure);

		appExposure = new Application_Exposure__c();
		appExposure.Application__c = app2.Id;
		appExposure.Client_Name__c = appProfile.Client_Name__c;
		appExposure.Client_Code__c = appProfile.Client_CIF_Code__c;
		appExposure.Product__c = '';
		appExposure.subIndicator__c = '';
		appExposure.Exposure__c = '300';
		appExposure.Arrears__c = '300';
		appExposure.Excess__c = '300';
		appExposure.Installment__c = '300';
		appExposure.Liability__c = '300';
		appExposure.Limit__c = '300';
		appExposure.Exposure_Data_Type__c = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_ORDINARY_CREDIT_TOTAL;
		appExposures.add(appExposure);
        insert appExposures;

		Application_Exposure_Cash_and_Investment__c appExpCash = new Application_Exposure_Cash_and_Investment__c();
		appExpCash.Application__c = app2.Id;
		appExpCash.Client_Name__c = appProfile.Client_Name__c;
		appExpCash.Client_Code__c = appProfile.Client_CIF_Code__c;
		appExpCash.Pens_Back_Prepaid__c = 1;
		appExpCash.Participation_Bond__c = 1;
		//appExpCash.Over_Control_SIte__c = 1;
		appExpCash.Other_Available_Cash__c = 1;
		appExpCash.Notice_of_Deposits__c = 1;
		appExpCash.Mortgage_Prepaid__c = 1;
		appExpCash.Fleet_In_Credit__c = 1;
		appExpCash.Fleet_Cash_Advance__c = 1;
		appExpCash.Customer_Investment_Account__c = 1;
		appExpCash.Credit_Card__c = 1;
		appExpCash.CPF_Prepaid__c = 1;
		appExpCash.Term_Deposits__c = 1;
		appExpCash.Savings__c = 1;
		appExpCash.AFC_In_Credit__c = 1;
		appExpCash.Cheque_In_Credit__c = 1.00;
		appExpCash.Client_Total__c = 16;
        insert appExpCash;

		Application_Exposure_Total_Group__c totalGroupRecord = new Application_Exposure_Total_Group__c();
		totalGroupRecord.Application__c = app2.id;
		totalGroupRecord.Control_Branch__c = 'test';
		totalGroupRecord.Branch_code__c = 'test';
		totalGroupRecord.Business_Segment__c = 'test';
		totalGroupRecord.Overall_Control_Branch__c = 'test';
        insert totalGroupRecord;

        Application_Triad__c appTriad = new Application_Triad__c();
        appTriad.Application__c = app2.Id;
		appTriad.Is_Main_Applicant__c = true;
		appTriad.Client_Code__c = account.CIF__c;
        appTriad.Additional_Monthly_Loan_Repayment__c = 20;
        appTriad.Additional_Monthly_Repayment__c = 20;
        appTriad.Additional_Credit_Card_Limit__c = 20;
        appTriad.Additional_Asset_Finance_Repayment__c = 20;
        appTriad.Additional_Monthly_Mortgage_Repayment__c = 20;
        appTriad.Maximum_Ordinary_Credit_Exposure_Capped__c = 20;
        insert appTriad;

        Application_triad_Detail__c appTriadDet = new Application_triad_Detail__c();
        appTriadDet.Application_Triad__c = appTriad.Id;
        appTriadDet.Month__c = Date.valueOf('2012-01-31');
        appTriadDet.Number_of_Cheque_Accounts__c = 0;
        appTriadDet.Days_in_Credit__c = 0;
        appTriadDet.Days_in_Debit__c = 0;
        appTriadDet.Days_In_Excess__c = 0;
        appTriadDet.Number_of_Cheque_RD_Events__c = 0;
        appTriadDet.Number_of_Savings_RD_Events__c = 0;
        appTriadDet.Number_of_Debits_Cheques__c = 0;
        appTriadDet.Number_of_Debits_Deposits__c = 0;
        insert appTriadDet;

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String>{StringConstants.GET_CLIENT_DETAILS});
	}

	/**
	 * @description : Methid to create test client details
	 * @author Ephetehe Mokgopanyane | 2021-06-11
	 **/
	@IsTest
	public static void testGetClientDetails() {
        Test.setMock(HttpCalloutMock.class, new GetClientDetailsMock_ApiRest(StringConstants.POSITIVE_STRING));
		GetClientDetails_Resp_IB_v1 responseBean = GetClientDetails_IH_v1.getClientDetails('REBELLO001', '0', '009970');
		Opportunity opportnity = [SELECT Id, AccountId FROM Opportunity WHERE Name = :'Onboarding'];
		Account account = [SELECT Id, Name FROM Account WHERE Name = :'Test Account'];

		Test.startTest();
		System.assert((clientDetailsSectionCredit.getClientDetails(opportnity.Id) != null), true);
		Test.stopTest();
	}

	/**
	* @description : future method to insert required data
	* @author englarmerdge.mongwe@absa.africa | 2021-06-10
	**/
	@future
	private static void insertUser() {
		Profile p = [SELECT Id FROM Profile WHERE Name LIKE '%Banker%' LIMIT 1];
		UserRole r = [SELECT Id, Name FROM UserRole WHERE DeveloperName = 'Banker'];
		User futureUser = new User(ProfileId = p.Id, LastName = 'last', Email = 'puser000@amamama.com', Username = 'puser000@amamama.com' + System.currentTimeMillis(), CompanyName = 'TEST', Title = 'title', Alias = 'alias', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', SiteCode__c = '8198', SiteType__c = '034', Teller_Operator_Code__c = '12345', Supervisor__c = '0', Division__c = 'RBB', UserRoleId = r.Id);
		insert (futureUser);
	}
}