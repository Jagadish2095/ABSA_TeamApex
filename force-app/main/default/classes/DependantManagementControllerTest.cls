@isTest
public class DependantManagementControllerTest {
    
    public static testMethod void testLiquidityCalculator(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        /****** Added by chenna as part of DD Outbound Sales on 30/10/2020 -start *********/
        List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Spouse';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse);
        
        Opportunity_Party__c  testOpportunityPartyBeneficiary = new Opportunity_Party__c();
        testOpportunityPartyBeneficiary.First_Name__c = 'Test2';
        testOpportunityPartyBeneficiary.Last_Name__c = 'Tester2';
        testOpportunityPartyBeneficiary.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartyBeneficiary.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartyBeneficiary.Party_Type__c = 'Beneficiary';
        testOpportunityPartyBeneficiary.RSA_ID_Number__c = '9007115025085';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 0.5;
        testOpportunityPartyBeneficiary.Relationship__c='Child';
        opty.add(testOpportunityPartyBeneficiary);
        insert opty;
        
        
         List<Quote> lstQuote = new List<Quote>();
        
        Pricebook2 standardPB = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPB;
        system.debug('--standards'+standardPB);
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        Product2 prod = new Product2(Name = 'Flexi Funeral Discount', Family = 'Best Practices', IsActive = true);
        insert prod;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        lstQuote.add(new Quote(OpportunityId = testDataFactory.testOpportunity.id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
        Insert lstQuote;
        system.debug('quote test'+lstQuote);
        List<QuoteLineItem> ql = new List<QuoteLineItem>();
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        
        quoteLineItem.QuoteId = lstQuote[0].Id;
        quoteLineItem.Product2Id = prod.Id;
        quoteLineItem.PricebookEntryId = standardPrice.Id;
        quoteLineItem.Quantity = 1;
        quoteLineItem.Relationship_Type__c = 'Spouse';
        quoteLineItem.Premium__c =  70.86;
        quoteLineItem.UnitPrice = 1000;
        
        ql.add(quoteLineItem);
        QuoteLineItem quoteLineItem2 = new QuoteLineItem();
        
        quoteLineItem2.QuoteId = lstQuote[0].Id;
        quoteLineItem2.Product2Id = prod.Id;
        quoteLineItem2.PricebookEntryId = standardPrice.Id;
        quoteLineItem2.Quantity = 1;
        quoteLineItem2.Relationship_Type__c = 'Child';
        quoteLineItem2.UnitPrice = 1000;
         quoteLineItem2.Premium__c =  70.86;
          ql.add(quoteLineItem2);
        insert ql;
        
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "200.00","OppParty":"spouse"}]';
        /****** Added by chenna as part of DD Outbound Sales on 30/10/2020 -end *********/
        Test.startTest();
        
        DependantManagementController.getPartyData(testDataFactory.testOpportunity.id);
        DependantManagementController.getSingleParty(testDataFactory.testOpportunityPartyDependant.id);
        DependantManagementController.checkIfFuneralBenefitTaken(testDataFactory.testOpportunity.id);
        DependantManagementController.checkIfFuneralBenefitTaken(null);
        DependantManagementController.updateOpportunityParty(testDataFactory.testOpportunityPartyDependant, testDataFactory.testOpportunity.id, testDataFactory.testOpportunityPartyDependant.id, false);
        DependantManagementController.removeOpportunityParty(testDataFactory.testOpportunityPartySpouse.Id);
        DependantManagementController.removeOpportunityParty(opty[0].id);
        /****** Added by chenna as part of DD Outbound Sales on 30/10/2020  *********/
        DependantManagementController.getTotalBenefitSplit(testDataFactory.testOpportunity.id);
        DependantManagementController.getOpportunitydata(testDataFactory.testOpportunity.id);
        DependantManagementController.getOpportunitydata(null);
        DependantManagementController.createDDQuote(testDataFactory.testOpportunity.id, '10000',prod.Name,psosimplejson, 'spouse','Test description', true, true,true );
        DependantManagementController.getPricingMatrix(testDataFactory.testOpportunity.id, '1000','Flexi Funeral Rate');
        DependantManagementController.getQuoteLineItemsData(testDataFactory.testOpportunity.id, 'Spouse',prod.Name);
        DependantManagementController.getQuoteLineItemsData(null, 'Spouse',prod.Name);
        Test.stopTest();
    }
    
    public static testMethod void testLiquidityCalculatorNegative(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        /******** Modified by Chenna as part of DD outbound Sale on 30/10/2020  *****/
         List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        testOpportunityPartySpouse.Benefit_Split__c = 600;
        opty.add(testOpportunityPartySpouse);
        
        Opportunity_Party__c  testOpportunityPartyBeneficiary = new Opportunity_Party__c();
        testOpportunityPartyBeneficiary.First_Name__c = 'Test2';
        testOpportunityPartyBeneficiary.Last_Name__c = 'Tester2';
        testOpportunityPartyBeneficiary.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartyBeneficiary.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartyBeneficiary.Party_Type__c = 'Beneficiary';
        testOpportunityPartyBeneficiary.RSA_ID_Number__c = '9007115025085';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 0.5;
        testOpportunityPartyBeneficiary.Relationship__c='Child';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 600;
        opty.add(testOpportunityPartyBeneficiary);
        insert opty;
        
        Opportunity opp = new Opportunity();
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "Test Message","OppParty":"spouse"}]';
        
        DependantManagementController.updateOpportunityParty(testDataFactory.testOpportunityPartyDependant, testDataFactory.testOpportunity.id, testDataFactory.testOpportunityPartyDependant.id, true);
        /******** Added by Chenna as part of DD outbound Sale on 30/10/2020  *****/
        DependantManagementController.getOpportunitydata(testDataFactory.testOpportunity.id);
        DependantManagementController.getPartyData(testDataFactory.testOpportunity.id);
        DependantManagementController.createOpportunityParties(opty, testDataFactory.testOpportunity.id);
        DependantManagementController.getPricingMatrix(testDataFactory.testOpportunity.id, '1000','Flexi Funeral Rate');
        DependantManagementController.getselectOptions(opp, 'StageName');
        DependantManagementController.createOpportunityParty(opty[0],testDataFactory.testOpportunity.id, true);
        DependantManagementController.createOpportunityParty(opty[0],testDataFactory.testOpportunity.id, false);
        
        Test.stopTest();
    }
    
    public static testMethod void testOppPartyCreate(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        /******** Modified by Chenna as part of DD outbound Sale on 30/10/2020  *****/
         List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        
        for(integer i=0; i<=6;i++){
            Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
            testOpportunityPartySpouse.First_Name__c = 'Test2'+i;
            testOpportunityPartySpouse.Last_Name__c = 'Tester2'+i;
            testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
            testOpportunityPartySpouse.Opportunity__c = testDataFactory.testOpportunity.id;
            testOpportunityPartySpouse.Party_Type__c = 'Dependant';
            testOpportunityPartySpouse.Relationship__c='Spouse';
            testOpportunityPartySpouse.Benefit_Split__c = 600;
            opty.add(testOpportunityPartySpouse);
        }    
        insert opty;
        
        Opportunity opp = new Opportunity();
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "Test Message","OppParty":"spouse"}]';
        
        DependantManagementController.updateOpportunityParty(opty[0], testDataFactory.testOpportunity.id, opty[0].id, true);
        /******** Added by Chenna as part of DD outbound Sale on 30/10/2020  *****/

        
        Test.stopTest();
    }
    /******** Added by Chenna as part of DD outbound Sale on 30/10/2020  *****/
    @isTest static void quoteDDAdd(){
         WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<Quote> lstQuote = new List<Quote>();
        
        Pricebook2 standardPB = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        update standardPB;
        system.debug('--standards'+standardPB);
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        Product2 prod = new Product2(Name = 'Flexi Funeral Discount', Family = 'Best Practices', IsActive = true);
        insert prod;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        lstQuote.add(new Quote(OpportunityId = testDataFactory.testOpportunity.id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
        Insert lstQuote;
        system.debug('quote test'+lstQuote);
        List<QuoteLineItem> ql = new List<QuoteLineItem>();
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        
        quoteLineItem.QuoteId = lstQuote[0].Id;
        quoteLineItem.Product2Id = prod.Id;
        quoteLineItem.PricebookEntryId = standardPrice.Id;
        quoteLineItem.Quantity = 1;
        quoteLineItem.Relationship_Type__c = 'Spouse';
        quoteLineItem.Premium__c =  70.86;
        quoteLineItem.UnitPrice = 1000;
        
        ql.add(quoteLineItem);
        QuoteLineItem quoteLineItem2 = new QuoteLineItem();
        
        quoteLineItem2.QuoteId = lstQuote[0].Id;
        quoteLineItem2.Product2Id = prod.Id;
        quoteLineItem2.PricebookEntryId = standardPrice.Id;
        quoteLineItem2.Quantity = 1;
        quoteLineItem2.Relationship_Type__c = 'Child';
        quoteLineItem2.UnitPrice = 1000;
        quoteLineItem2.Premium__c =  70.86;
          ql.add(quoteLineItem2);
        insert ql;
        
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "Test Message","OppParty":"spouse"}]';
        
        Test.startTest();
        DependantManagementController.createDDQuote(testDataFactory.testOpportunity.id, '10000',prod.Name,psosimplejson, 'spouse','Test description', true, true,true );
        Test.stopTest();
        
    }
        
    /******** Added by Chenna as part of DD outbound Sale on 30/10/2020  *****/
    @isTest static void quoteRemoveDD(){
         WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        List<Quote> lstQuote = new List<Quote>();
        
        Pricebook2 standardPB = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
       
        List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse);
        
        Opportunity_Party__c  testOpportunityPartyBeneficiary = new Opportunity_Party__c();
        testOpportunityPartyBeneficiary.First_Name__c = 'Test2';
        testOpportunityPartyBeneficiary.Last_Name__c = 'Tester2';
        testOpportunityPartyBeneficiary.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartyBeneficiary.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartyBeneficiary.Party_Type__c = 'Beneficiary';
        testOpportunityPartyBeneficiary.RSA_ID_Number__c = '9007115025085';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 0.5;
        testOpportunityPartyBeneficiary.Relationship__c='Child';
        opty.add(testOpportunityPartyBeneficiary);
        insert opty;
        
        update standardPB;
        system.debug('--standards'+standardPB);
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        Product2 prod = new Product2(Name = 'Flexi Funeral Discount', Family = 'Best Practices', IsActive = true);
        insert prod;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        lstQuote.add(new Quote(OpportunityId = testDataFactory.testOpportunity.id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
        Insert lstQuote;
        system.debug('quote test'+lstQuote);
        List<QuoteLineItem> ql = new List<QuoteLineItem>();
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        
        quoteLineItem.QuoteId = lstQuote[0].Id;
        quoteLineItem.Product2Id = prod.Id;
        quoteLineItem.PricebookEntryId = standardPrice.Id;
        quoteLineItem.Quantity = 1;
        quoteLineItem.Relationship_Type__c = 'Spouse';
        quoteLineItem.OpportunityPartyId__c = opty[0].Id;
        quoteLineItem.UnitPrice = 1000;
        
        ql.add(quoteLineItem);
        QuoteLineItem quoteLineItem2 = new QuoteLineItem();
        
        quoteLineItem2.QuoteId = lstQuote[0].Id;
        quoteLineItem2.Product2Id = prod.Id;
        quoteLineItem2.PricebookEntryId = standardPrice.Id;
        quoteLineItem2.Quantity = 1;
        quoteLineItem2.Relationship_Type__c = 'Child';
        quoteLineItem2.OpportunityPartyId__c = opty[1].Id;
        quoteLineItem2.UnitPrice = 1000;
          ql.add(quoteLineItem2);
        insert ql;
        
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "200.00","OppParty":"spouse"}]';
        string psosimplejson1='[{"Name":"Test","premium":"200.00", "SumInsured": "test","OppParty":"spouse"}]';
        Test.startTest();
        DependantManagementController.removeDDQuote(testDataFactory.testOpportunity.id, '10000',prod.Name,psosimplejson, 'spouse','Test description', opty[1].Id );
         DependantManagementController.removeDDQuote(testDataFactory.testOpportunity.id, '10000',prod.Name,psosimplejson1, 'spouse','Test description', opty[1].Id );
        Test.stopTest();
        
    }
    
    //Added by pranv
      @isTest static void removepartyTestOpp1(){
        
	WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
	    List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.DDRecordtypeopportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant;Beneficiary';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse); 
        insert opty;
        
        test.startTest();
        DependantManagementController.removeOpportunityParty(opty[0].Id);
        test.stopTest();
    }
    @isTest static void removepartyTestOpp(){
        
	WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
	    List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.DDRecordtypeopportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant;Beneficiary';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        testOpportunityPartySpouse.DD_Cross_Sell_Product_Member_Type__c='Rider Family';
        opty.add(testOpportunityPartySpouse); 
        insert opty;
        
        test.startTest();
        DependantManagementController.removeOpportunityParty(opty[0].Id);
        test.stopTest();
    }
    //------ends-----
         /******** Added by Chenna as part of DD outbound Sale on 30/10/2020  *****/
    @isTest static void removepartyTest22(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
          List<Quote> lstQuote = new List<Quote>();
        
        Pricebook2 standardPB = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
       
        List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test2';
        testOpportunityPartySpouse.Last_Name__c = 'Tester2';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse);
        
        Opportunity_Party__c  testOpportunityPartyBeneficiary = new Opportunity_Party__c();
        testOpportunityPartyBeneficiary.First_Name__c = 'Test2';
        testOpportunityPartyBeneficiary.Last_Name__c = 'Tester2';
        testOpportunityPartyBeneficiary.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartyBeneficiary.Opportunity__c = testDataFactory.testOpportunity.id;
        testOpportunityPartyBeneficiary.Party_Type__c = 'Beneficiary';
        testOpportunityPartyBeneficiary.RSA_ID_Number__c = '9007115025085';
        testOpportunityPartyBeneficiary.Benefit_Split__c = 0.5;
        testOpportunityPartyBeneficiary.Relationship__c='Child';
        opty.add(testOpportunityPartyBeneficiary);
        insert opty;
        
        update standardPB;
        system.debug('--standards'+standardPB);
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        Product2 prod = new Product2(Name = 'Flexi Funeral Discount', Family = 'Best Practices', IsActive = true);
        insert prod;
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        lstQuote.add(new Quote(OpportunityId = testDataFactory.testOpportunity.id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
        Insert lstQuote;
        system.debug('quote test'+lstQuote);
        List<QuoteLineItem> ql = new List<QuoteLineItem>();
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        
        quoteLineItem.QuoteId = lstQuote[0].Id;
        quoteLineItem.Product2Id = prod.Id;
        quoteLineItem.PricebookEntryId = standardPrice.Id;
        quoteLineItem.Quantity = 1;
        quoteLineItem.Relationship_Type__c = 'Spouse';
        quoteLineItem.OpportunityPartyId__c = opty[0].Id;
        quoteLineItem.UnitPrice = 1000;
        
        ql.add(quoteLineItem);
        QuoteLineItem quoteLineItem2 = new QuoteLineItem();
        
        quoteLineItem2.QuoteId = lstQuote[0].Id;
        quoteLineItem2.Product2Id = prod.Id;
        quoteLineItem2.PricebookEntryId = standardPrice.Id;
        quoteLineItem2.Quantity = 1;
        quoteLineItem2.Relationship_Type__c = 'Beneficiary';
        quoteLineItem2.OpportunityPartyId__c = opty[1].Id;
        quoteLineItem2.UnitPrice = 1000;
          ql.add(quoteLineItem2);
        insert ql;
        
        string psosimplejson='[{"Name":"Test","premium":"200.00", "SumInsured": "Test Message","OppParty":"spouse"}]';
        
        Test.startTest();
        DependantManagementController.getQuoteLineItemsData(testDataFactory.testOpportunity.id, 'Spouse',prod.Name);
        DependantManagementController.removeOpportunityParty(ql[1].Id);
        Test.stopTest();
        
    }   
}