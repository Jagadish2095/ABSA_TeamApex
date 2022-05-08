/**
 * @description This is a test class for QuoteBuilderController
 *
 * @author   Prashant Kumar Jain (Tetrad)
 * @since    2020/04/21
 * @UpdateDate 2020/04/24
 *
 */

@isTest
public with sharing class QuoteBuilderControllerTest {
	@TestSetup
	static void makeData() {
		// Instantiating the Pricing Test Data Factory creates pricing related records
		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
	}

	@isTest
	private static void testGetQuoteBuilderData() {
		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

		test.startTest();
		String jsonString = QuoteBuilderController.getQuoteBuilderData(opportunity.Id, 'Merchant Onboarding');
		QuoteBuilderController.PricingBean pricingBean = (QuoteBuilderController.PricingBean) JSON.deserialize(
			jsonString,
			QuoteBuilderController.PricingBean.class
		);

		System.assert(String.isNotBlank(jsonString), 'Assert Failed');
		System.assertNotEquals(null, pricingBean, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.quantityPicklistOptions, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.contractDurationTypePicklistOptions, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.priceSchemeEntryMap, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.componentProductDataList, 'Assert Failed');

		List<Price_Scheme__c> accountProductFamilyPriceSchemes = new PriceSchemesSelector()
			.selectByAccountTypeProductFamily(pricingBean.accountId, pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
		delete accountProductFamilyPriceSchemes.get(0);

		Account account = new Account(Id = pricingBean.accountId, Is_Part_Of_Franchise__c = false);
		update account;

		List<OpportunityLineItem> vasOpportunityLineItems = new OpportunityLineItemsSelector()
			.selectRelatedLineItemsByParentId(pricingBean.opportunityLineItemId);
		delete vasOpportunityLineItems;

		jsonString = QuoteBuilderController.getQuoteBuilderData(opportunity.Id, 'Merchant Onboarding');
		System.assert(String.isNotBlank(jsonString), 'Assert Failed');

		test.stopTest();
	}

	@isTest
	private static void testSaveQuoteBuilderData() {
		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

		String jsonString = QuoteBuilderController.getQuoteBuilderData(opportunity.Id, 'Merchant Onboarding');

		QuoteBuilderController.PricingBean pricingBean = (QuoteBuilderController.PricingBean) JSON.deserialize(
			jsonString,
			QuoteBuilderController.PricingBean.class
		);

		Map<String, QuoteBuilderController.PriceSchemeEntryData> priceSchemeEntryMap = pricingBean.priceSchemeEntryMap;

		pricingBean.negotiatedPriceSchemeId = null;

		for (String key : priceSchemeEntryMap.keySet()) {
			QuoteBuilderController.PriceSchemeEntryData priceSchemeEntryData = priceSchemeEntryMap.get(key);
			priceSchemeEntryData.updatedValue = 20;
		}

		test.startTest();
		jsonString = QuoteBuilderController.saveQuoteBuilderData(JSON.serialize(pricingBean), true);
		System.assert(String.isNotBlank(jsonString), 'Assert Failed');
		System.assertNotEquals(null, pricingBean, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.quantityPicklistOptions, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.contractDurationTypePicklistOptions, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.priceSchemeEntryMap, 'Assert Failed');
		System.assertNotEquals(null, pricingBean.componentProductDataList, 'Assert Failed');

		pricingBean = (QuoteBuilderController.PricingBean) JSON.deserialize(jsonString, QuoteBuilderController.PricingBean.class);

		for (QuoteBuilderController.ComponentProductData vasProductData : pricingBean.componentProductDataList) {
			if (vasProductData.isSelected && String.isNotBlank(vasProductData.opportunityLineItemId)) {
				vasProductData.isSelected = false;
			} else {
				vasProductData.isSelected = true;
			}
		}

		jsonString = QuoteBuilderController.saveQuoteBuilderData(JSON.serialize(pricingBean), true);
		System.assert(String.isNotBlank(jsonString), 'Assert Failed');
		test.stopTest();
	}

	@isTest
	private static void testCreateApplicationRecords() {
		Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
		OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
		String jsonString = QuoteBuilderController.getQuoteBuilderData(opportunity.Id, 'Merchant Onboarding');
		QuoteBuilderController.PricingBean pricingBean = (QuoteBuilderController.PricingBean) JSON.deserialize(
			jsonString,
			QuoteBuilderController.PricingBean.class
		);
		Map<String, String> metadataNameToValueMap = new Map<String, String>();
		//deserialize the bean into an Untyped Object. Which allows us to use a get method
		Map<String, Object> untypedMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
		//Populate  metadataNameToValueMap
		for (Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList) {
			if (mtdRecord.Additional_Attributes__c != null) {
				QuoteBuilderController.AdditionalAttributes addAttributes = (QuoteBuilderController.AdditionalAttributes) JSON.deserialize(
					mtdRecord.Additional_Attributes__c,
					QuoteBuilderController.AdditionalAttributes.class
				);
				if (addAttributes.priceSchemeEntryMapKey != null) {
					QuoteBuilderController.PriceSchemeEntryData entryData = pricingBean.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);
					if (entryData != null && entryData.updatedValue != null) {
						metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(entryData.updatedValue));
					} else if (entryData != null && entryData.existingValue != null) {
						metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(entryData.existingValue));
					}
				} else {
					if (untypedMap.get(addAttributes.valueReadPath) != null) {
						metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(untypedMap.get(addAttributes.valueReadPath)));
					}
				}
			}
		}

		test.startTest();
		Map<String, String> idsMap = QuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

		Id applicationId = idsMap.get('applicationId');
		System.assert(String.isNotBlank(applicationId), 'Assert Failed');

		Id applicationProductMerchantId = idsMap.get('applicationProductMerchantId');
		System.assert(String.isNotBlank(applicationProductMerchantId), 'Assert Failed');

		List<Device_Merchant__c> devices = [SELECT Id FROM Device_Merchant__c LIMIT 1];
		System.assertEquals(devices.size(), 1, 'Assert Failed');

		idsMap = QuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

		String error = idsMap.get('error');
		System.assert(String.isNotBlank(error), 'Assert Failed');

		Application__c application = new ApplicationsSelector().selectById(applicationId);
		delete application;
		idsMap = QuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

		error = idsMap.get('error');
		System.assert(String.isNotBlank(error), 'Assert Failed');

		test.stopTest();
	}

	// JQUEV: 20200819
	@isTest
	static void testChangeSelectedProduct() {
		Product2 prod = [SELECT Name FROM Product2 LIMIT 1];
		Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
		User currentUser = [SELECT Id, sitecode__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
		currentUser.sitecode__c = '8611';
		update currentUser;
		Test.startTest();
		Map<String, String> returnMapSuccess = QuoteBuilderController.changeSelectedProduct(opp.Id, prod.Name);
		System.assertNotEquals(null, returnMapSuccess.get('opportunityProductId'), 'Assert Failed');
		Map<String, String> returnMapError = QuoteBuilderController.changeSelectedProduct(opp.Id, 'BadProductName');
		System.assertNotEquals(null, returnMapError.get('error'), 'Assert Failed');
		Test.stopTest();
	}

	// PJAIN: 20200724
	@isTest
	static void testGenerateMerchantQuoteDocument() {
		Test.startTest();
		String returnMessage = QuoteBuilderController.generateMerchantQuoteDocument(new Map<String, String>());
		System.assertEquals(null, returnMessage, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	private static void testDocs() {
		Map <String, Schema.RecordTypeInfo> AccountRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    	Map <String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Account testAccount = new Account();
        testAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        testAccount.FirstName = 'Tony';
        testAccount.ID_Number__pc = '8107115017084';
        testAccount.ID_Type__pc = 'SA Identity Document';
        testAccount.LastName = 'Stark';
        testAccount.Nationality__pc = 'South Africa';
        testAccount.Client_Type__c = 'Individual Client';
        testAccount.CIF__c = 'AFIFTAP001';
        insert testAccount;

		Contact testContact = new Contact();
        testContact.FirstName = 'Test';
        testContact.LastName = 'Contact';
        insert testContact;

		Opportunity opp = new Opportunity();
        opp.AccountId = testAccount.id;
        opp.RecordTypeId = OpportunityRecordTypeMap.get('General').getRecordTypeId();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Quote_Status__c = 'Pending'; // Tinashe W-004373
        insert opp;

		Document__c appDoc = new Document__c();
        appDoc.Name = 'Aplication Form.pdf';
        appDoc.Type__c = 'Application Form';
        appDoc.Opportunity__c = opp.Id;
        appDoc.Contact__c = testContact.id;
        appDoc.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
        insert appDoc;

		Document__c quoteDoc = new Document__c();
        quoteDoc.Name = 'Quote.pdf';
        quoteDoc.Type__c = System.Label.Merchant_Quote_Document_Template_Name;
        quoteDoc.Opportunity__c = opp.Id;
        quoteDoc.Contact__c = testContact.id;
        quoteDoc.Reference__c = '82 3 ICM7 UGOLSDB4 Will59 26 A1001001A19F14B41357J5034318 A19F14B41357J503431 14 2364';
        insert quoteDoc;

		Account testProspectAccount = new Account();
        testProspectAccount.FirstName = 'Test';
        testProspectAccount.LastName = 'Contact';
        testProspectAccount.ID_Type__pc = 'SA Identity Document';
        testProspectAccount.Nationality__pc = 'South Africa';
        testProspectAccount.RecordTypeId = AccountRecordTypeMap.get('Individual_Client').getRecordTypeId();
        insert testProspectAccount;

		User currentUser = [SELECT Id, sitecode__c FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
		currentUser.sitecode__c = '8611';
		update currentUser;

		test.startTest();
		QuoteBuilderController.documentRestricted(opp.Id);
		QuoteBuilderController.getAllClientEmailsSignature(opp.Id);
		QuoteBuilderController.getMobile(opp.Id);
		QuoteBuilderController.getDigitalSignatorySelectOptions('Preferred_Method__c');

		Id testProspectAccountContactId = [SELECT Id, PersonContactId FROM Account WHERE Id =: testProspectAccount.Id].PersonContactId;
		Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(
			Opportunity__c = opp.id,
			Preferred_Email__c = 'test@12.com',
			Preferred_Method__c = 'Realtime',
			Preferred_Mobile__c = '0989876543',
			Signatory_Party__c = testProspectAccountContactId
		);
		insert spo2;
		String sigs =
			'[{"Id":"' +
			testAccount.id +
			'","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"fg@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';

		QuoteBuilderController.getUpdatedSignatoriesData(opp.Id, quoteDoc.Id, sigs, 'Realtime', '0988765432', 'test@123.com');
		QuoteBuilderController.sendForImpressionSignature(opp.Id, sigs);
		QuoteBuilderController.fetchImpressionRequest(opp.Id);
		List<Map<String, Object>> resp = QuoteBuilderController.getSignatoriesData(opp.Id);
		//QuoteBuilderController.getDocumentContent(opp.Id,  'Download',  '');
		System.assertNotEquals(null, QuoteBuilderController.getQuoteDocumentName(opp.Id), 'Assert Failed');
		test.stopTest();
	}

	@isTest
	static void testGetPriceSchemeEntriesForChargeLogs() {
		Transaction_Group__c transactionGroup = PricingTestDataFactory.createTransactionGroup('Funds Transfer');
		Transaction_Type__c transactionType = PricingTestDataFactory.createTransactionType('Funds Transfer - IVR', transactionGroup.Id);
		transactionType.Transaction_Code__c = '15';
		update transactionType;
		Price_Scheme__c standardPriceScheme = PricingTestDataFactory.createPriceScheme('IVR - Individual', 'Standard', null, null);
		Price_Scheme_Entry__c standardFixedPriceSchemeEntry = PricingTestDataFactory.createFixedPriceSchemeEntry(standardPriceScheme.Id, transactionType.Id);

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
		account.CIF__c = 'MULLEBM001';
		account.Client_Type__c = 'Private Individual';
		account.Telebanking_Charge_Account_Number__c = '0000001234567893';
		insert account;

		Charge_Log__c cl1 = new Charge_Log__c();
		cl1.Account_CIF_Code__c = 'MULLEBM001';
		cl1.Transaction_Code__c = '15';
		cl1.Transaction_Date__c = Date.Today();
		cl1.Source__c = 'IVR';
		insert cl1;

		Map<Id, String> priceSchemeNameToChargeLogIdMap = new Map<Id, String>();
		priceSchemeNameToChargeLogIdMap.put(cl1.Id, 'IVR - Individual');

		Test.startTest();
		Map<Id, Price_Scheme_Entry__c> pceToIdMap = QuoteBuilderController.getPriceSchemeEntriesForChargeLogs(
			priceSchemeNameToChargeLogIdMap,
			new List<Charge_Log__c>{ cl1 }
		);
		System.assertEquals(1, pceToIdMap.values().size(), 'Assert Failed');
		Test.setMock(HttpCalloutMock.class, new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Individual', null));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });
		TriggerHandlerChargeLog.updateAccountFromCIFFuture('MULLEBM001', cl1.Id);
		Test.stopTest();
	}
}