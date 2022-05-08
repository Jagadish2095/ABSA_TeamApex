@isTest
public class OnboardingProductCQcreateAcctTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.API_MANAGER,
            new List<String>{ StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7, StringConstants.SVcreateLinkSavingsDepAccount_STRING }
        );
        List<Product2> listProd = new List<Product2>();
        Product2 prdCHQ = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
        listProd.add(prdCHQ);
        Product2 prdSAVQ = new Product2(Name = 'Savings Product', Family = 'SAVINGS', ProductCode = '09007');
        listProd.add(prdSAVQ);
        insert listProd;

        Pricebook2 pb = new Pricebook2();
        pb.IsActive = true;
        pb.id = test.getStandardPricebookId();
        update pb;

        List<PricebookEntry> listPrice = new List<PricebookEntry>();
        PricebookEntry priceCHQ = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prdCHQ.Id, UnitPrice = 12000, IsActive = true);
        listPrice.add(priceCHQ);
        PricebookEntry priceSAVQ = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prdSAVQ.Id, UnitPrice = 12000, IsActive = true);
        listPrice.add(priceSAVQ);
        insert listPrice;

        Account acc = new Account();
        acc.Name = 'test acc';
        acc.CIF__c = 'LTD 933';
        insert acc;

        site__c siteRec = new site__c();
        siteRec.Site_Code__c = '1334';
        siteRec.Name = 'Test';
        insert siteRec;

        List<Opportunity> listOpp = new List<Opportunity>();
        Opportunity oppCHQ = new Opportunity();
        oppCHQ.Name = 'Test Opp Onboarding CHQ';
        oppCHQ.CloseDate = Date.today();
        oppCHQ.StageName = 'New';
        oppCHQ.Pricebook2Id = pb.id;
        oppCHQ.AccountId = acc.id;
        oppCHQ.Site__c = siteRec.id;
        listOpp.add(oppCHQ);
        Opportunity oppSAVQ = new Opportunity();
        oppSAVQ.Name = 'Test Opp Onboarding SAVQ';
        oppSAVQ.CloseDate = Date.today();
        oppSAVQ.StageName = 'New';
        oppSAVQ.Pricebook2Id = pb.id;
        oppSAVQ.AccountId = acc.id;
        oppSAVQ.Site__c = siteRec.id;
        listOpp.add(oppSAVQ);
        insert listOpp;

        List<Application__c> listApp = new List<Application__c>();
        Application__c appCHQ = new Application__c();
        appCHQ.Opportunity__c = oppCHQ.id;
        appCHQ.Source_of_Funds_Savings__c = '27	ALLOWANCE';
        listApp.add(appCHQ);
        Application__c appSAVQ = new Application__c();
        appSAVQ.Opportunity__c = oppSAVQ.id;
        appSAVQ.Source_of_Funds_Savings__c = '27	ALLOWANCE';
        listApp.add(appSAVQ);
        insert listApp;

        List<OpportunityLineItem> listOppLineItem = new List<OpportunityLineItem>();
        OpportunityLineItem oppLineItemCHQ = new OpportunityLineItem();
        oppLineItemCHQ.OpportunityId = oppCHQ.id;
        oppLineItemCHQ.Product2Id = prdCHQ.id;
        oppLineItemCHQ.PricebookEntryId = priceCHQ.id;
        oppLineItemCHQ.Quantity = 1;
        oppLineItemCHQ.TotalPrice = 100;
        listOppLineItem.add(oppLineItemCHQ);
        OpportunityLineItem oppLineItemSAVQ = new OpportunityLineItem();
        oppLineItemSAVQ.OpportunityId = oppSAVQ.id;
        oppLineItemSAVQ.Product2Id = prdSAVQ.id;
        oppLineItemSAVQ.PricebookEntryId = priceSAVQ.id;
        oppLineItemSAVQ.Quantity = 1;
        oppLineItemSAVQ.TotalPrice = 100;
        listOppLineItem.add(oppLineItemSAVQ);
        insert listOppLineItem;

        oppLineItemCHQ.Policy_Number__c = null;
        update oppLineItemCHQ;
        oppLineItemSAVQ.Policy_Number__c = null;
        update oppLineItemSAVQ;

        List<user> uList = new List<user>();
        uList.add(createUser('UserAdmin', 'System Administrator (Custom)', null, null));
        uList.add(createUser('UserA', 'Standard User (Business Banker)', siteRec.Site_Code__c, '042030'));
        if (uList != null && uList.size() > 0) {
            insert uList;
        }
    }

    @isTest
    static void chqAccPositveTest() {
        User u = getUser('UserAdmin@absa2.com');
        System.runAs(u) {
            Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding CHQ'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CQcreateAndLinkAccountV7_Mock_ApiRest(StringConstants.POSITIVE_STRING));
            List<OnboardingProductCQcreateAcctSummaryCon.DisplayProducts> dispProd = OnboardingProductCQcreateAcctSummaryCon.getOppData(opp.Id);
            Test.stopTest();
            System.assert(dispProd.get(0).AccountNumber != null);
        }
    }

    @IsTest
    static void chqAccNegativeTest() {
        User u = getUser('UserAdmin@absa2.com');
        System.runAs(u) {
            Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding CHQ'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CQcreateAndLinkAccountV7_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
            List<OnboardingProductCQcreateAcctSummaryCon.DisplayProducts> dispProd = OnboardingProductCQcreateAcctSummaryCon.getOppData(opp.Id);
            Test.stopTest();
            System.assert(dispProd.get(0).AccountNumber == null);
        }
    }

    @isTest
    static void savqAccPositveTest() {
        User u = getUser('UserAdmin@absa2.com');
        System.runAs(u) {
            Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding SAVQ'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SVcreateLinkSavingsDepAcountMock_ApiRest(StringConstants.POSITIVE_STRING));
            List<OnboardingProductCQcreateAcctSummaryCon.DisplayProducts> dispProd = OnboardingProductCQcreateAcctSummaryCon.getOppData(opp.Id);
            Test.stopTest();
            System.assert(dispProd.get(0).AccountNumber != null);
        }
    }

    @isTest
    static void savqAccNegativeTest() {
        User u = getUser('UserAdmin@absa2.com');
        System.runAs(u) {
            Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp Onboarding SAVQ'];
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new SVcreateLinkSavingsDepAcountMock_ApiRest(StringConstants.NEGATIVE_STRING));
            List<OnboardingProductCQcreateAcctSummaryCon.DisplayProducts> dispProd = OnboardingProductCQcreateAcctSummaryCon.getOppData(opp.Id);
            Test.stopTest();
            System.assert(dispProd.get(0).AccountNumber == null);
        }
    }

    public static User createUser(String lastName, String Profile, String siteCode, String tellerCode) {
        User u = new User();
        String uniqueUserName = lastName + DateTime.now().getTime() + '@absa2.com';
        String email = lastName + '@absa2.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = :Profile];
        u = new User(
            Alias = 'standt',
            Email = email,
            EmailEncodingKey = 'UTF-8',
            LastName = lastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = uniqueUserName,
            MobilePhone = '0823389021',
            SiteCode__c = siteCode,
            Teller_Operator_Code__c = tellerCode
        );
        return u;
    }

    public static User getUser(String email) {
        User getUser = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add(email);
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == email) {
                    getUser = u;
                }
            }
        }
        return getUser;
    }
}