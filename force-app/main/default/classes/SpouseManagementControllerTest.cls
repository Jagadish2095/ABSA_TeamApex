@isTest
public class SpouseManagementControllerTest {
    
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
        Opportunity opp = new Opportunity();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id,Name FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2' Limit 1 ];
            List<Opportunity_Party__c> oppparty = [SELECT Id, Opportunity__c,Party_Type__c,Benefit_Split__c,First_Name__c,Last_Name__c,
                                                   Date_of_Birth__c,RSA_ID_Number__c,Relationship__c
                                                   from Opportunity_Party__c WHERE Party_Type__c ='Dependant'  LIMIT 1];
            List<Opportunity_Party__c> oppparty1 = [SELECT Id, Opportunity__c,Opportunity__r.recordtype.developername,Party_Type__c,Benefit_Split__c,First_Name__c,Last_Name__c,
                                                   Date_of_Birth__c,RSA_ID_Number__c,Relationship__c
                                                   from Opportunity_Party__c WHERE Party_Type__c ='Dependant' AND Opportunity__r.recordtype.developername != 'Direct_Delivery_Sales_Opportunity'  ];
          
            
            system.debug('---'+oppparty);
            system.debug('---opp'+myOppList);
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
            Insert lstQuote;
            myOppList[0].SyncedQuoteId = lstQuote[0].Id;
      	    Update myOppList[0];
            system.debug('quote test'+lstQuote);
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Spouse';
            quoteLineItem.UnitPrice = 1000;
            Insert quoteLineItem;
            
            Test.startTest();
            SpouseManagementController.getPartyData(myOppList[0].Id);
            SpouseManagementController.getSingleParty(oppparty[0].Id);
            SpouseManagementController.getSpouseDOB(myOppList[0].Id);
            SpouseManagementController.getSpouseDOB(null);
            SpouseManagementController.checkIfSpouseQuoted(myOppList[0].Id);
            SpouseManagementController.createOpportunityParty(oppparty[0],myOppList[0].Id, true);
            SpouseManagementController.updateOpportunityParty(oppparty[0],myOppList[0].Id,oppparty[0].Id, true);
            SpouseManagementController.updateOpportunityParty(oppparty1[0],myOppList[0].Id,oppparty1[0].Id, false); 
            SpouseManagementController.removeOpportunityParty(oppparty[0].Id);
            
            SpouseManagementController.getTotalBenefitSplit(oppparty[0].Id);
            SpouseManagementController.getselectOptions(opp, 'StageName');
            SpouseManagementController.fetchOpportunityRecord(myOppList[0].Id);
            SpouseManagementController.getPricingMatrix(myOppList[0].Id,'100','Flexi Funeral Discount');
            SpouseManagementController.getPricingMatrix(myOppList[0].Id,'100','Flexi Funeral Rate');
            SpouseManagementController.getQuoteLineItemsData(myOppList[0].Id, 'dependent', prod.Name);
            SpouseManagementController.getQuoteLineItemsDataByProduct(myOppList[0].Id, prod.Name);
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": "Test Message","OppParty":"TestParty"}]';
            SpouseManagementController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,quoteLineItem.Relationship_Type__c,
                                                     'Test Description', true, true,true);
            SpouseManagementController.removeDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,'spouse',
                                                     'Test Description', quoteLineItem.OpportunityPartyId__c);
            
            Test.stopTest();
        }
    }
    
    @isTest static void createQuote(){
        User uA = getUser();
        Opportunity opp = new Opportunity();
        System.runAs(uA){
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            
            List<Opportunity_Party__c> oppparty = [SELECT Id, Opportunity__c,Party_Type__c,Benefit_Split__c,First_Name__c,Last_Name__c,Opportunity__r.recordtype.developername,
                                                   Date_of_Birth__c,RSA_ID_Number__c,Relationship__c
                                                   from Opportunity_Party__c WHERE Party_Type__c ='Dependant'   LIMIT 1];
            system.debug('---opp'+myOppList);
            
            List<Quote> lstQuote = new List<Quote>();
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": "Test Message","OppParty":"TestParty"}]';
          
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
            Insert lstQuote;
            system.debug('quote test'+lstQuote);
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'Test Relationship';
            quoteLineItem.UnitPrice = 1000;
            quoteLineItem.OpportunityPartyId__c = oppparty[0].Id;
            Insert quoteLineItem;
            system.debug('--quoteLine'+quoteLineItem);
            myOppList[0].RecordTypeId=devRecordTypeId;
            update myOppList[0];
            Test.startTest();
            
            SpouseManagementController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,quoteLineItem.Relationship_Type__c,
                                                     'Test Description', true, true,true);
            SpouseManagementController.removeDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,'spouse',
                                                     'Test Description', quoteLineItem.OpportunityPartyId__c);
            
            
            //oppparty[0].DD_Cross_Sell_Product_Member_Type__c='Rider family';
            //update oppparty[0];
            SpouseManagementController.removeOpportunityParty(oppparty[0].Id);
            
            Test.stopTest();
        }
    } 
    
     @isTest static void createQuote33(){
        User uA = getUser();
        Opportunity opp = new Opportunity();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            List<Opportunity_Party__c> oppparty = [SELECT Id, Opportunity__c,Party_Type__c,Benefit_Split__c,First_Name__c,Last_Name__c,
                                                   Date_of_Birth__c,RSA_ID_Number__c,Relationship__c
                                                   from Opportunity_Party__c WHERE Party_Type__c ='Dependant' LIMIT 1];
            system.debug('---opp'+myOppList);
            
            List<Quote> lstQuote = new List<Quote>();
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": "200.00","OppParty":"TestParty"}]';
          
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New', product_Name__c='Flexi Funeral Discount'));
            Insert lstQuote;
            
            myOppList[0].SyncedQuoteId = lstQuote[0].Id;
      	    Update myOppList[0];
            system.debug('quote test'+lstQuote);
            
           List<QuoteLineItem> ql = new List<QuoteLineItem>();
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'spouse';
            quoteLineItem.UnitPrice = 1000;
            quoteLineItem.OpportunityPartyId__c = oppparty[0].Id;
            ql.add(quoteLineItem);
            
             QuoteLineItem quoteLineItem2 = new QuoteLineItem();
            
            quoteLineItem2.QuoteId = lstQuote[0].Id;
            quoteLineItem2.Product2Id = prod.Id;
            quoteLineItem2.PricebookEntryId = standardPrice.Id;
            quoteLineItem2.Quantity = 1;
            quoteLineItem2.Relationship_Type__c = 'spouse';
            quoteLineItem2.UnitPrice = 1000;
            quoteLineItem2.OpportunityPartyId__c = oppparty[0].Id;
            ql.add(quoteLineItem2);
            insert ql;
            
            Test.startTest();
            
            SpouseManagementController.createDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,'Spouse',
                                                     'Test Description', true, true,true);
            SpouseManagementController.removeDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,'spouse',
                                                     'Test Description', quoteLineItem.OpportunityPartyId__c);
            
            Test.stopTest();
        }
    } 
    
    
    
    @isTest static void deleteQuote(){
        User uA = getUser();
        Opportunity opp = new Opportunity();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
             List<Opportunity_Party__c> oppparty = [SELECT Id, Opportunity__c,Party_Type__c,Benefit_Split__c,First_Name__c,Last_Name__c,
                                                   Date_of_Birth__c,RSA_ID_Number__c,Relationship__c
                                                   from Opportunity_Party__c WHERE Party_Type__c ='Dependant' LIMIT 1];
            system.debug('---opp'+myOppList);
            
            List<Quote> lstQuote = new List<Quote>();
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": 200.00,"OppParty":"TestParty"}]';
          
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
            lstQuote.add(new Quote(OpportunityId = myOppList[0].Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
            Insert lstQuote;
            myOppList[0].SyncedQuoteId = lstQuote[0].Id;
      	    Update myOppList[0];
            system.debug('quote test'+lstQuote);
            
            List<QuoteLineItem> ql = new List<QuoteLineItem>();
            QuoteLineItem quoteLineItem = new QuoteLineItem();
            
            quoteLineItem.QuoteId = lstQuote[0].Id;
            quoteLineItem.Product2Id = prod.Id;
            quoteLineItem.PricebookEntryId = standardPrice.Id;
            quoteLineItem.Quantity = 1;
            quoteLineItem.Relationship_Type__c = 'spouse';
            quoteLineItem.UnitPrice = 1000;
            quoteLineItem.OpportunityPartyId__c = oppparty[0].Id;
            ql.add(quoteLineItem);
            
             QuoteLineItem quoteLineItem2 = new QuoteLineItem();
            
            quoteLineItem2.QuoteId = lstQuote[0].Id;
            quoteLineItem2.Product2Id = prod.Id;
            quoteLineItem2.PricebookEntryId = standardPrice.Id;
            quoteLineItem2.Quantity = 1;
            quoteLineItem2.Relationship_Type__c = 'spouse';
            quoteLineItem2.UnitPrice = 1000;
            quoteLineItem2.OpportunityPartyId__c = oppparty[0].Id;
            ql.add(quoteLineItem2);
            insert ql;
            system.debug('--quoteLine'+quoteLineItem);
            Test.startTest();
            
            SpouseManagementController.removeDDQuote(myOppList[0].Id, '10.00', prod.Name, psosimplejson,'spouse',
                                                     'Test Description', quoteLineItem.OpportunityPartyId__c);
            Test.stopTest();
        }
    }   
     //Added by pranv
     @isTest static void removepartyTestOpp2(){
           User uA = getUser();
   account acc= [select id from account where OwnerId=: UA.id];
          
         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();
         Opportunity DDRecordtypeopportunity = new Opportunity();
        DDRecordtypeopportunity.AccountId = acc.id;
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
        DDRecordtypeopportunity.Debit_Order_Debit_Day__c='30';
        DDRecordtypeopportunity.Debit_Order_Salary_Day__c='10';
        DDRecordtypeopportunity.DebitOrderThirdParty__c=true;
        DDRecordtypeopportunity.Commencement_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Account_Number__c = '1234567890';
        DDRecordtypeopportunity.Selected_Email__c = 'test@test.com';
        insert DDRecordtypeopportunity;
        
	    List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test212';
        testOpportunityPartySpouse.Last_Name__c = 'Tester234';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = DDRecordtypeopportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse); 
        insert opty;
        
        test.startTest();
        SpouseManagementController.removeOpportunityParty(opty[0].Id);
        test.stopTest();
    }
      @isTest static void removepartyTestOpp1(){
           User uA = getUser();
   account acc= [select id from account where OwnerId=: UA.id];
          
         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();
         Opportunity DDRecordtypeopportunity = new Opportunity();
        DDRecordtypeopportunity.AccountId = acc.id;
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
        DDRecordtypeopportunity.Debit_Order_Debit_Day__c='30';
        DDRecordtypeopportunity.Debit_Order_Salary_Day__c='10';
        DDRecordtypeopportunity.DebitOrderThirdParty__c=true;
        DDRecordtypeopportunity.Commencement_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Account_Number__c = '1234567890';
        DDRecordtypeopportunity.Selected_Email__c = 'test@test.com';
        insert DDRecordtypeopportunity;
        
	    List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test212';
        testOpportunityPartySpouse.Last_Name__c = 'Tester234';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = DDRecordtypeopportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant;Beneficiary';
        testOpportunityPartySpouse.Relationship__c='Spouse';
        opty.add(testOpportunityPartySpouse); 
        insert opty;
        
        test.startTest();
        SpouseManagementController.removeOpportunityParty(opty[0].Id);
        test.stopTest();
    }
   @isTest static void removepartyTestOpp(){
           User uA = getUser();
   account acc= [select id from account where OwnerId=: UA.id];
          
         Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Direct Delivery Sales Opportunity').getRecordTypeId();
         Opportunity DDRecordtypeopportunity = new Opportunity();
        DDRecordtypeopportunity.AccountId = acc.id;
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
        DDRecordtypeopportunity.Debit_Order_Debit_Day__c='30';
        DDRecordtypeopportunity.Debit_Order_Salary_Day__c='10';
        DDRecordtypeopportunity.DebitOrderThirdParty__c=true;
        DDRecordtypeopportunity.Commencement_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Date__c = Date.today();
        DDRecordtypeopportunity.Debit_Order_Account_Number__c = '1234567890';
        DDRecordtypeopportunity.Selected_Email__c = 'test@test.com';
        insert DDRecordtypeopportunity;
        
	    List<Opportunity_Party__c> opty = new List<Opportunity_Party__c>();
        Opportunity_Party__c  testOpportunityPartySpouse = new Opportunity_Party__c();
        testOpportunityPartySpouse.First_Name__c = 'Test212';
        testOpportunityPartySpouse.Last_Name__c = 'Tester234';
        testOpportunityPartySpouse.Date_of_Birth__c = Date.valueOf('1990-07-11');
        testOpportunityPartySpouse.Opportunity__c = DDRecordtypeopportunity.id;
        testOpportunityPartySpouse.Party_Type__c = 'Dependant;Beneficiary';
        testOpportunityPartySpouse.Relationship__c='Spouse';
       testOpportunityPartySpouse.DD_Cross_Sell_Product_Member_Type__c='Rider Family';
        opty.add(testOpportunityPartySpouse); 
        insert opty;
        
        test.startTest();
        SpouseManagementController.removeOpportunityParty(opty[0].Id);
        test.stopTest();
    }
    //------ends-----
}