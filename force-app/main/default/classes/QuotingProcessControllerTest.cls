@isTest
public class QuotingProcessControllerTest {

    @TestSetup static void makeData(){
        QuotingProcessTestDataFactory QuotProcessfactory = new QuotingProcessTestDataFactory();
    }
    public static User getUser(){
        User uA = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('User@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (!userList.isEmpty() && userList != null) {
            for (User u : userList) {
                if (u.Email=='User@testorg.com') {
                    uA=u;
                }
            }
        }
        return uA;
    }
    @isTest static void quoteProcessTestA(){
        User uA = getUser();
        System.runAs(uA){
            Datetime td	= System.today();
            Datetime cd = td.addYears(-5);
            Datetime sd = td.addYears(-30);
            Datetime accd = td.addYears(-35);
            String childDOB = cd.format('YYYY-MM-dd');
            String SpouseDOB = sd.format('YYYY-MM-dd');
            Date dfSpouseDOB = date.newinstance(sd.year(), sd.month(), sd.day());
            String accDOB = sd.format('YYYY-MM-dd');
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
                    System.assertEquals(true, QuotingProcessController.checkIfSpouseAdded(oppId));
                    System.assertEquals(dfSpouseDOB,QuotingProcessController.getSpouseDOB(oppId));
                    System.assertEquals('150',QuotingProcessController.getTotalQuoteData(oppId));
                    List<QuoteLineItem> qteLinItemList = QuotingProcessController.getQuoteLineItemsData(oppId);
                    System.assertEquals(3, qteLinItemList.size());
                    System.assertEquals(150.0,QuotingProcessController.checkIfQuoteExists(oppId));
                    System.assertEquals(18,QuotingProcessController.getSpouseMinAge(oppId));
                    System.assertEquals(70,QuotingProcessController.getSpouseMaxAge(oppId));
                    System.assertEquals(10.0,QuotingProcessController.getPolicyFee());
                    QuotingProcessController.createQuote(oppId, '300', '10', '50', '50', '30000', '50', '30000', '50', '50', true, '1990-05-05', false, 'Description');

                }
                List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
                Account myAcc = new Account();
                if (!myAccList.isEmpty() && myAccList != null) {
                    myAcc = myAccList.get(0);
                    List<Financial_Needs_Analysis__c> fnaList = new List<Financial_Needs_Analysis__c>();
                    fnaList = [SELECT Id, Name , Account__c FROM Financial_Needs_Analysis__c WHERE Account__c = : myAcc.Id ];
                    if (!fnaList.isEmpty() && fnaList != null) {
                        Financial_Needs_Analysis__c fna = fnaList.get(0);
                        List<String> optList = QuotingProcessController.getselectOptions(fna, 'Life_Policies_Action__c');
                        System.assertEquals(2, optList.size());
                    }
                }
            }
        }
    }
    @isTest static void quoteProcessTestB(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Country_of_Residence__pc = null;
                myAcc.CIF__c = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    vlaidCheck = QuotingProcessController.checkAccountValid(oppId);
                }
                QuotingProcessController.sendEmail(myOppList[0].id,'test@test.com');
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestC(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Nationality__pc = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    vlaidCheck = QuotingProcessController.checkAccountValid(oppId);
                }
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestD(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Country_of_Birth__pc = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    vlaidCheck = QuotingProcessController.checkAccountValid(oppId);
                }
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestE(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Income_Source__pc = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    vlaidCheck = QuotingProcessController.checkAccountValid(oppId);
                }
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestF(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            Opportunity myOpp = new Opportunity();
            if (!myOppList.isEmpty() && myOppList != null) {
                myOpp = myOppList.get(0);
                Id oppId = myOpp.Id;
                vlaidCheck = QuotingProcessController.checkAccountValid(oppId);
            }
            System.Equals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestG(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.debug('---Oppty'+myOppList.size());
            Opportunity myOpp = new Opportunity();
            if (!myOppList.isEmpty() && myOppList != null) {
                myOpp = myOppList.get(0);
                Id oppId = myOpp.Id;
                String policy = QuotingProcessController.getPolicy(myOppList[0].Id);
               /* System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Executors Fees Cover'));
                System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Estate Bridging Benefit'));
                System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Family Funeral'));
                Date d = Date.today();
                System.assertEquals(null,QuotingProcessController.getSpousePremiumWbif(policy, oppId, '30000', 30, d, 'Executors Fees Cover'));
                System.assertEquals(null,QuotingProcessController.getSpousePremiumWbif(policy, oppId, '30000', 30, d, 'Estate Bridging Benefit'));*/
            }
        }
    }
    @isTest static void quoteProcessTestH(){
        User uA = getUser();
        System.runAs(uA){
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    //System.assertEquals(true,QuotingProcessController.sendEmail(oppId, 'test@test.com'));
                }
            }
        }
    }
    @isTest static void quoteProcessTestI(){
        User uA = getUser();
        System.runAs(uA){
            List<Account> myAccList = [SELECT Id, Alternative_Email__c, Alternative_Email_1__c, Alternative_Email_2__c, Alternative_Email_3__c,
            Alternative_Email_4__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Alternative_Email__c = null;
                myAcc.Alternative_Email_1__c = null;
                myAcc.Alternative_Email_2__c = null;
                myAcc.Alternative_Email_3__c = null;
                myAcc.Alternative_Email_4__c = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    for (Integer i = 0; i < 5; i++) {
                        System.assertEquals(true,QuotingProcessController.setOppEmail(oppId, 'test@test.com','testa@test.com',true));
                    }
                }
            }
        }
    }
    @isTest static void quoteProcessTestJ(){
        User uA = getUser();
        System.runAs(uA){
            List<Account> myAccList = [SELECT Id, Alternative_Email__c, Alternative_Email_1__c, Alternative_Email_2__c, Alternative_Email_3__c,
            Alternative_Email_4__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            List<Opportunity> myOppList = [SELECT Id, Selected_Email__c FROM Opportunity WHERE OwnerID = :uA.Id];
            Opportunity myOpp = new Opportunity();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.Alternative_Email__c = 'acc@email.com';
                myAcc.Alternative_Email_1__c = 'acc@email.com';
                myAcc.Alternative_Email_2__c = 'acc@email.com';
                myAcc.Alternative_Email_3__c = 'acc@email.com';
                myAcc.Alternative_Email_4__c = 'acc@email.com';
                update myAcc;
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    myOpp.Selected_Email__c = 'opp@email.com';
                    update myOpp;
                    Id oppId = myOpp.Id;
                    List<String> emaiList = QuotingProcessController.getEmails(oppId);
                    if (!emaiList.isEmpty() && emaiList != null) {
                        System.assertEquals(7, emaiList.size());
                    }
                }
            }
        }
    }
    @isTest static void quoteProcessTestK(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
                    System.assertEquals(false, QuotingProcessController.checkIfSpouseAdded(oppId));
                    System.assertEquals(null,QuotingProcessController.getSpouseDOB(oppId));
                    System.assertEquals(null,QuotingProcessController.getTotalQuoteData(oppId));
                    System.assertEquals(null,QuotingProcessController.getQuoteLineItemsData(oppId));
                    System.assertEquals(null,QuotingProcessController.checkIfQuoteExists(oppId));
                }
            }
        }
    }
    @isTest static void quoteProcessTestL(){
        User uA = getUser();
        System.runAs(uA){
            Datetime td	= System.today();
            Datetime cd = td.addYears(-5);
            Datetime sd = td.addYears(-30);
            Datetime accd = td.addYears(-35);
            String childDOB = cd.format('YYYY-MM-dd');
            String SpouseDOB = sd.format('YYYY-MM-dd');
            Date dfSpouseDOB = date.newinstance(sd.year(), sd.month(), sd.day());
            String accDOB = sd.format('YYYY-MM-dd');
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
                    System.assertEquals(50.0,QuotingProcessController.getMemberPremium(oppId, '30000', 'Executors Fees Cover'));
                    System.assertEquals(40.0,QuotingProcessController.getMemberPremium(oppId, null, 'Family Funeral'));
                    System.assertEquals(null,QuotingProcessController.getMemberPremium(null, null, 'Family Funeral'));
                    System.assertEquals(50.0,QuotingProcessController.getSpousePremium(oppId, '30000', 30, 'Executors Fees Cover'));
                    System.assertEquals(null,QuotingProcessController.getSpousePremium(oppId, '30000', null, 'Executors Fees Cover'));
                    System.assertEquals(100.0,QuotingProcessController.getFirstYearCommission(oppId));
                    System.assertEquals(20.0,QuotingProcessController.getSecondYearCommission(oppId));
                    QuotingProcessController.createQuote(oppId, '300', '10', '50', '50', '30000', '50', '30000', '50', '50', true, '1990-05-05', true, 'Description');
                }
            }
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void getQuoteLineItemsDataByProduct(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
            Pricebook2 standardPB = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
            );
            update standardPB;
            system.debug('--standards'+standardPB);
            Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
            insert pb;
            Product2 prod = new Product2(Name = 'Flexi Funeral Rate', Family = 'Best Practices', IsActive = true);
            insert prod;
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert standardPrice;
            
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert pbe;
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
            system.debug('test--quoteLineItem'+quoteLineItem);
            Test.startTest();
             QuotingProcessController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
            QuotingProcessController.getPricingMatrix(myOppList[0].Id, '10.00', prod.Name);
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
     @isTest static void getQuoteLineItemsDataByProduct1(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
            system.debug('test--quoteLineItem'+quoteLineItem);
            Test.startTest();
             //QuotingProcessController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
            QuotingProcessController.getPricingMatrix(myOppList[0].Id, '10.00', prod.Name);
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void getMemberPremiumWbif1(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Test Relationship';
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
           
            
            string psosimplejson='{"status":"Teest","statusCode":200, "message": "Test Message"}';
            
            Test.startTest();
            
          
             //QuotingProcessController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
          // QuotingProcessController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, '"test":"test"',quoteLineItem.Relationship_Type__c,
                                                //   'Test Description', true, true,true);
            QuotingProcessController.getMemberPremiumWbif(psosimplejson,myOppList[0].Id,'10000','Family Funeral');
          
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void getMemberPremiumWbif2(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Test Relationship';
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
           
            
            string psosimplejson='{"status":"Teest","statusCode":200, "message": "Test Message"}';
            
            Test.startTest();
            
          
             //QuotingProcessController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
          // QuotingProcessController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, '"test":"test"',quoteLineItem.Relationship_Type__c,
                                                //   'Test Description', true, true,true);
            QuotingProcessController.getMemberPremiumWbif(psosimplejson,myOppList[0].Id,'10000','Executors Fees Cover');
          
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void getMemberPremiumWbif3(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Test Relationship';
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
           
            
            string psosimplejson='{"status":"Teest","statusCode":200, "message": "Test Message"}';
            
            Test.startTest();
            
          
             //QuotingProcessController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
          // QuotingProcessController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, '"test":"test"',quoteLineItem.Relationship_Type__c,
                                                //   'Test Description', true, true,true);
            QuotingProcessController.getMemberPremiumWbif(psosimplejson,myOppList[0].Id,'10000','Estate Bridging Benefit');
          
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void createQuote(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id,Quote_Outcome_Reason__c,Quote_Outcome__c FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending'));
            Insert lstQuote;
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Test Relationship';
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
           	system.debug('----line items'+quoteLineItem);
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": "Test Message","OppParty":"TestParty"}]';
            
            Test.startTest();
          	QuotingProcessController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,quoteLineItem.Relationship_Type__c,
                                               'Test Description', true, true,true,myOppList[0],'Client Interested');
            
          
            Test.stopTest();
            
        
        }
    }
    
    
   
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
    @isTest static void getSpousePremiumWbif11(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
           string psosimplejson= '{"status":"Teest","statusCode":200, "message": "Test Message"}';
            
            Test.startTest();
          	//QuotingProcessController.getSpousePremiumWbif(psosimplejson,myOppList[0].Id,'TestSum',25.00,system.today(),'Executors Fees Cover');
            QuotingProcessController.getSpousePremiumWbif(psosimplejson, myOppList[0].Id,'1000',19.99d, system.today(),'Executors Fees Cover');
          
            Test.stopTest();
            
        
        }
    }
    
    /** Added by Chenna for DD Outbount Sale on 30/10/2020 ***/
     
    @isTest static void getSpousePremiumWbif12(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
           string psosimplejson= '{"status":"Teest","statusCode":200, "message": "Test Message"}';
            
            Test.startTest();
          	//QuotingProcessController.getSpousePremiumWbif(psosimplejson,myOppList[0].Id,'TestSum',25.00,system.today(),'Executors Fees Cover');
            QuotingProcessController.getSpousePremiumWbif(psosimplejson, myOppList[0].Id,'1000',19.99d, system.today(),'Estate Bridging Benefit');
          
            Test.stopTest();
            
        
        }
    }
      
}