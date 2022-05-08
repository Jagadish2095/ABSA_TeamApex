/*
Controller Test Class For merchantOnboardingAuthSignatoryCtrl class
*
* @author  Tinashe Mutsungi Shoko : Jordiflash
* @version v1.0
* @since   2020-04-02
*/

@isTest
public class ProductOnboardingAuthSignatoryCtrlTest {

    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'Test Accepted Cards');
        insert account;

        Contact contact = new Contact(LastName='Test Accepted Cards', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
        system.debug('The contact us ' + contact.id);

        Pricebook2 pb = new Pricebook2();
        pb.IsActive=true;
        pb.id =test.getStandardPricebookId();
        update pb;

        Product2 prod = new Product2(name='Test - Mobile – Ingenico Move 3500',IsActive=true,
                                     CurrencyIsoCode='ZAR');
        insert prod;

        PricebookEntry pbe = new PricebookEntry(IsActive=true,UnitPrice=100,Pricebook2Id=pb.id,Product2Id=prod.id);
        insert pbe;

        Opportunity opp = new Opportunity(Accountid=account.id,Name='Test Accepted Cards',StageName='Confirm Client Eligibility',
                                          Closedate=Date.today().addDays(30), Pricebook2Id=pb.id);
        insert opp;

        OpportunityLineItem oppLine = new OpportunityLineItem(OpportunityId=opp.id, Quantity=1, UnitPrice=100,Product2Id=prod.id);
        insert oppLine;

        Application_Product_Merchant__c appProdMerch = new Application_Product_Merchant__c(Opportunity_Product_Id__c=oppLine.id);
        insert appProdMerch;

    }

    @isTest
    public static void merchantOnboardingAuthSignatory(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity where Name = 'Test Accepted Cards' LIMIT 1];
        Account acct = [SELECT Id  FROM Account where Name = 'Test Accepted Cards' LIMIT 1];

      /*  Application_Product_Merchant__c rtnMap = ProductOnboardingAuthSignatoryCtrl.getApplicationProductMerchant(opp.Id);
        System.assertNotEquals(null, rtnMap);*/
        List<AccountContactRelation> acrList = ProductOnboardingAuthSignatoryCtrl.getAccountContactRelation(opp.Id);
        System.assertNotEquals(null, acrList);
        Map<string,OpportunityLineItem> oppLineItemMap = ProductOnboardingAuthSignatoryCtrl.getOppProductRecords(opp.Id);
        System.assertNotEquals(null, oppLineItemMap);
        Id accId = Acct.id;
        List<ProductContactSignatoryRelationship__c> ProductCntSignatoryRelationLst = ProductOnboardingAuthSignatoryCtrl.getProductSignatoryRecords(accId);
        Account acc = ProductOnboardingAuthSignatoryCtrl.getAccountRecordforOpp(opp.Id);
        //System.assertNotEquals(null, acc);
        ProductOnboardingAuthSignatoryCtrl.deleteProdConSigRel(testDataFactory.testProductContactSignatoryRelationship.id);
        Test.stopTest();
    }

    @isTest
    public static void merchantOnboardingAuthSignatoryNegative(){
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity where Name = 'Test Accepted Cards' LIMIT 1];
    /*    Application_Product_Merchant__c rtnMap = ProductOnboardingAuthSignatoryCtrl.getApplicationProductMerchant(opp.Id);
        delete rtnMap;
        Application_Product_Merchant__c rtnMapDel = ProductOnboardingAuthSignatoryCtrl.getApplicationProductMerchant(opp.Id);
        System.assertEquals(null, rtnMapDel);*/

        List<AccountContactRelation> acrList = ProductOnboardingAuthSignatoryCtrl.getAccountContactRelation(opp.Id);
        Contact c = [Select id from Contact where Id = : acrList[0].ContactId];
        delete c;
        acrList = ProductOnboardingAuthSignatoryCtrl.getAccountContactRelation(opp.Id);
        System.assertEquals(null, acrList);
        Test.stopTest();
    }
}