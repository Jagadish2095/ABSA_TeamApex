/**
* This is a test class for MerchantQuoteBuilderController
*
* @author   Prashant Kumar Jain (Tetrad)
* @since    2020/04/21
* @UpdateDate 2020/04/24
*
*/

@isTest
public with sharing class MerchantQuoteBuilderControllerTest {

    @TestSetup
    static void makeData(){
        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
    }

    @isTest
    private static void testGetQuoteBuilderData() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

        test.startTest();
        String jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(opportunity.Id);

        System.debug('MerchantQuoteBuilderControllerTest.testGetQuoteBuilderData.jsonString: ' + jsonString);

        MerchantQuoteBuilderController.PricingBean pricingBean = (MerchantQuoteBuilderController.PricingBean) JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);

        System.assert(String.isNotBlank(jsonString));
        System.assertNotEquals(null, pricingBean);
        System.assertNotEquals(null, pricingBean.quantityPicklistOptions);
        System.assertNotEquals(null, pricingBean.contractDurationTypePicklistOptions);
        System.assertNotEquals(null, pricingBean.priceSchemeEntryMap);
        System.assertNotEquals(null, pricingBean.vasProductDataList);

        List<Price_Scheme__c> accountProductFamilyPriceSchemes =
                new PriceSchemesSelector().selectByAccountTypeProductFamily(pricingBean.accountId, pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
        delete accountProductFamilyPriceSchemes.get(0);

        Account account = new Account(Id = pricingBean.accountId, Is_Part_Of_Franchise__c = false);
        update account;

        List<OpportunityLineItem> vasOpportunityLineItems = new OpportunityLineItemsSelector().selectRelatedLineItemsByParentId(pricingBean.opportunityLineItemId);
        delete vasOpportunityLineItems;

        jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(opportunity.Id);
        System.assert(String.isNotBlank(jsonString));

        test.stopTest();
    }

    @isTest
    private static void testSaveQuoteBuilderData() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];

        String jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(opportunity.Id);

        MerchantQuoteBuilderController.PricingBean pricingBean = (MerchantQuoteBuilderController.PricingBean) JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);

        Map<String, MerchantQuoteBuilderController.PriceSchemeEntryData> priceSchemeEntryMap = pricingBean.priceSchemeEntryMap;

        pricingBean.negotiatedPriceSchemeId = null;

        for (String key : priceSchemeEntryMap.keySet()) {
            MerchantQuoteBuilderController.PriceSchemeEntryData priceSchemeEntryData = priceSchemeEntryMap.get(key);
            priceSchemeEntryData.updatedValue = 20;
        }

        System.debug('MerchantQuoteBuilderControllerTest.getQuoteBuilderData.UpdatedJsonString: ' + JSON.serialize(pricingBean));

        test.startTest();
        jsonString = MerchantQuoteBuilderController.saveQuoteBuilderData(JSON.serialize(pricingBean));
        System.assert(String.isNotBlank(jsonString));
        System.assertNotEquals(null, pricingBean);
        System.assertNotEquals(null, pricingBean.quantityPicklistOptions);
        System.assertNotEquals(null, pricingBean.contractDurationTypePicklistOptions);
        System.assertNotEquals(null, pricingBean.priceSchemeEntryMap);
        System.assertNotEquals(null, pricingBean.vasProductDataList);

        System.debug('MerchantQuoteBuilderControllerTest.getQuoteBuilderData.UpdatedAgainJsonString: ' + jsonString);

        pricingBean = (MerchantQuoteBuilderController.PricingBean) JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);

        for (MerchantQuoteBuilderController.VASProductData vasProductData : pricingBean.vasProductDataList) {
            if (vasProductData.isSelected && String.isNotBlank(vasProductData.opportunityLineItemId)) {
                vasProductData.isSelected = false;
            } else {
                vasProductData.isSelected = true;
            }
        }

        jsonString = MerchantQuoteBuilderController.saveQuoteBuilderData(JSON.serialize(pricingBean));
        System.assert(String.isNotBlank(jsonString));
        test.stopTest();
    }

    @isTest
    private static void testCreateApplicationRecords() {
        Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        String jsonString = MerchantQuoteBuilderController.getQuoteBuilderData(opportunity.Id);
        MerchantQuoteBuilderController.PricingBean pricingBean = (MerchantQuoteBuilderController.PricingBean) JSON.deserialize(jsonString, MerchantQuoteBuilderController.PricingBean.class);
		Map<String,String> metadataNameToValueMap = new Map<String,String>();
        //deserialize the bean into an Untyped Object. Which allows us to use a get method
        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        //Populate metadataNameToValueMap
        for(Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList){
            if(mtdRecord.Additional_Attributes__c != null){
                MerchantQuoteBuilderController.AdditionalAttributes addAttributes = (MerchantQuoteBuilderController.AdditionalAttributes)JSON.deserialize(mtdRecord.Additional_Attributes__c, MerchantQuoteBuilderController.AdditionalAttributes.class);
                if(addAttributes.priceSchemeEntryMapKey != null){
                    MerchantQuoteBuilderController.PriceSchemeEntryData entryData = pricingBean.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);
                    if(entryData != null && entryData.updatedValue != null){
                        metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(entryData.updatedValue));
                    }else if(entryData != null && entryData.existingValue != null){
                        metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(entryData.existingValue));
                    }
                }else{
                    if(untypedMap.get(addAttributes.valueReadPath) != null){
                        metadataNameToValueMap.put(mtdRecord.DeveloperName, String.valueOf(untypedMap.get(addAttributes.valueReadPath)));
                    }
                }
            }
        }

        test.startTest();
        Map<String, String> idsMap = MerchantQuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

        Id applicationId = idsMap.get('applicationId');
        System.assert(String.isNotBlank(applicationId));

        Id applicationProductMerchantId = idsMap.get('applicationProductMerchantId');
        System.assert(String.isNotBlank(applicationProductMerchantId));

        List<Device_Merchant__c> devices = [SELECT Id FROM Device_Merchant__c LIMIT 1];
        System.assertEquals(devices.size(), 1);

		idsMap = MerchantQuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

        String error = idsMap.get('error');
        System.assert(String.isNotBlank(error));

		Application__c application = new ApplicationsSelector().selectById(applicationId);
		delete application;
		idsMap = MerchantQuoteBuilderController.createApplicationRecords(jsonString, metadataNameToValueMap);

        error = idsMap.get('error');
        System.assert(String.isNotBlank(error));

        test.stopTest();
    }

    // JQUEV: 20200819
    @isTest
    static void testChangeSelectedProduct() {
        Product2 prod = [SELECT Name FROM Product2 LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        Map<String, String> returnMapSuccess = MerchantQuoteBuilderController.changeSelectedProduct(opp.Id, prod.Name);
        System.debug('Change Selected Product Success Response: ' + returnMapSuccess);
        System.assertNotEquals(null, returnMapSuccess.get('opportunityProductId'));
        Map<String, String> returnMapError = MerchantQuoteBuilderController.changeSelectedProduct(opp.Id, 'BadProductName');
        System.debug('Change Selected Product Error Response: ' + returnMapError);
        System.assertNotEquals(null, returnMapError.get('error'));
        Test.stopTest();
    }

    // PJAIN: 20200724
    @isTest
    static void testGenerateMerchantQuoteDocument() {
        Test.startTest();
        String returnMessage = MerchantQuoteBuilderController.generateMerchantQuoteDocument(new Map<String, String>());
        System.assertEquals(null, returnMessage);
        Test.stopTest();
    }

    @isTest
    private static void testDocs() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        Contact testContact = testDataFactory.testContact;
        Document__c appDoc = testDataFactory.testApplicationFormDocument;
        Document__c quoteDoc = testDataFactory.testQuoteDocument;
        test.startTest();
        MerchantQuoteBuilderController.documentRestricted(opp.Id);
        MerchantQuoteBuilderController.getAllClientEmailsSignature(opp.Id);
        MerchantQuoteBuilderController.getMobile(opp.Id);
        MerchantQuoteBuilderController.getDigitalSignatorySelectOptions('Preferred_Method__c');

        Id testProspectAccountContactId = [Select Id, PersonContactId FROM Account WHERE Id = :testDataFactory.testProspectAccount.Id].PersonContactId;
        Signatory_Party_Overide__c spo2 = new Signatory_Party_Overide__c(Opportunity__c=testDataFactory.testOpportunity.id,
                                                                         Preferred_Email__c='test@12.com',Preferred_Method__c='Realtime',
                                                                         Preferred_Mobile__c='0989876543',
                                                                         Signatory_Party__c=testProspectAccountContactId);
        insert spo2;
        String sigs = '[{"Id":"' + testDataFactory.testAccount.id + '","Title":"Mr.","Last_Name":"PAULA VENTER","Mobile_Phone":"+27833826456","Email":"fg@yahoo.com","Method":"Realtime","Role":"Client","Document_Name":"mu.pdf","Document_Type":"Quote"}]';

        MerchantQuoteBuilderController.getUpdatedSignatoriesData(opp.Id, quoteDoc.Id, sigs, 'Realtime', '0988765432', 'test@123.com');
        MerchantQuoteBuilderController.sendForImpressionSignature(opp.Id,  sigs);
        MerchantQuoteBuilderController.fetchImpressionRequest(opp.Id);
        //MerchantQuoteBuilderController.getDocumentContent(opp.Id,  'Download',  ''); 
        System.assertNotEquals(null, MerchantQuoteBuilderController.getQuoteDocumentName(opp.Id));
        test.stopTest();
    }
}