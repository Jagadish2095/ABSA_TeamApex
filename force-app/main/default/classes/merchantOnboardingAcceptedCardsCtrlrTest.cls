/*
Controller Test Class For merchantOnboardingAcceptedCardsCtrlr class
*
* @author  Tinashe Mutsungi Shoko : Jordiflash
* @version v1.0
* @since   2020-04-02
*/

@isTest
public class merchantOnboardingAcceptedCardsCtrlrTest {

    @testSetup static void createData(){

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'Test - Mobile – Ingenico Move 3500';
        product1.IsActive = true;
        insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        insert pricebookEntry1;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        oppLineItem.Merchant_Class__c = 'RETAIL';
        Insert oppLineItem;

        Application_Product_Merchant__c testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = oppLineItem.Id;
        //testAppProdMerch.Selected_Cards__c = 'Buy-aid;Cape Consumer';
        Insert testAppProdMerch;

        Transaction_Group__c transactionGroup = new Transaction_Group__c();
        insert transactionGroup;

        Accepted_Card__c acceptedCard = new Accepted_Card__c();
        acceptedCard.Name = 'American Express';
        acceptedCard.Transaction_Group__c = transactionGroup.Id;
        acceptedCard.Plan_Type__c = 'CP1';
        acceptedCard.Pre_Selected_for_Merchant_Class__c = 'RETAIL';
        acceptedCard.Available_for_Merchant_Class__c = 'RESTAURANT';
        acceptedCard.Type__c = StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD;
        acceptedCard.Product_Family__c = 'Merchant';
        insert acceptedCard;
    }

    // PJAIN: 20200525
    @isTest
    public static void testGetAcceptedCardsDataNoIds(){
        Test.startTest();
        Map<String, String> responseMap = merchantOnboardingAcceptedCardsCtrlr.getAcceptedCardsData(null, null, 'Merchant');
        System.assertEquals(StringConstants.MERCHANT_ERROR_APPLICATION_PRODUCT_MERCHANT_NOT_FOUND, responseMap.get('error'));
        Test.stopTest();
    }

    // PJAIN: 20200525
    @isTest
    public static void testGetAcceptedCardsDataNoMerchantClass(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        OpportunityLineItem oppLineItem = [SELECT Id, Merchant_Class__c FROM OpportunityLineItem LIMIT 1];
        oppLineItem.Merchant_Class__c = null;
        update oppLineItem;

        Test.startTest();
        Map<String, String> responseMap = merchantOnboardingAcceptedCardsCtrlr.getAcceptedCardsData(opp.Id, null, 'Merchant');
        System.assertEquals(StringConstants.MERCHANT_ERROR_ACCEPTED_CARDS_MERCHANT_CLASS_BLANK, responseMap.get('error'));
        Test.stopTest();
    }

    // PJAIN: 20200525
    @isTest
    public static void testGetAcceptedCardsDataOnlyOppId(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product_Merchant__c appProdMerch = [SELECT Id FROM Application_Product_Merchant__c LIMIT 1];

        Test.startTest();
        Map<String, String> responseMap = merchantOnboardingAcceptedCardsCtrlr.getAcceptedCardsData(opp.Id, null, 'Merchant');
        System.assertEquals(appProdMerch.Id, responseMap.get('applicationProductMerchantId'));
        Test.stopTest();
    }

    // PJAIN: 20200525
    @isTest
    public static void testGetAcceptedCardsDataBothIds(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product_Merchant__c appProdMerch = [SELECT Id FROM Application_Product_Merchant__c LIMIT 1];

        Test.startTest();
        Map<String, String> responseMap = merchantOnboardingAcceptedCardsCtrlr.getAcceptedCardsData(opp.Id, appProdMerch.Id, 'Merchant');
        System.assertEquals(appProdMerch.Id, responseMap.get('applicationProductMerchantId'));
        System.assertEquals('American Express', responseMap.get('preSelectedCards'));
        System.assertEquals('American Express', responseMap.get('availableCards'));
        Test.stopTest();
    }

    // PJAIN: 20200525
    @isTest
    public static void testGetAcceptedCardsDataWithSelectedCards(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product_Merchant__c appProdMerch = [SELECT Id, Selected_Cards__c FROM Application_Product_Merchant__c LIMIT 1];
        appProdMerch.Selected_Cards__c = 'Buy-aid;Cape Consumer';
        update appProdMerch;

        Test.startTest();
        Map<String, String> responseMap = merchantOnboardingAcceptedCardsCtrlr.getAcceptedCardsData(opp.Id, appProdMerch.Id, 'Merchant');
        System.assertEquals(appProdMerch.Id, responseMap.get('applicationProductMerchantId'));
        System.assertEquals('Buy-aid;Cape Consumer', responseMap.get('preSelectedCards'));
        System.assertEquals('American Express;Buy-aid;Cape Consumer', responseMap.get('availableCards'));
        Test.stopTest();
    }
}