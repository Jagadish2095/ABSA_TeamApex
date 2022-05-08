/**
* 
* @author  Pranav 
* @description CrossSellProductsControllerTest
* @created 2020-11-13
*/
@isTest
public class CrossSellProductsControlllerTest
{
     @TestSetup static void makeData(){
        CrossSellProductsTestDataFactory quotProcessfactory = new CrossSellProductsTestDataFactory();
    }
    /**
     * @description getUser description
     *
     * @return Return User: Return description
     */
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
            Datetime td= System.today();
            Datetime cd = td.addYears(-5);
            Datetime sd = td.addYears(-30);
            Datetime accd = td.addYears(-35);
            String childDOB = cd.format('YYYY-MM-dd');
            String spouseDOB = sd.format('YYYY-MM-dd');
            Date dfSpouseDOB = date.newinstance(sd.year(), sd.month(), sd.day());
            String accDOB = sd.format('YYYY-MM-dd');
            Opportunity_Party__c oppp = new Opportunity_Party__c() ;
            List<Opportunity> myOppList = [SELECT Id,CreditLife_Plans__c,Absa_Staff_Member__c,DD_Premium__c,Card_Life_Plan__c,Secondary_Life__c,Commission__c,Intial_Loan_Amount__c,DD_PhotoFinishSelected__c,Photo_Finish_Premium__c,DD_Additional_Cover_Selected__c,Quote_Outcome_Reason__c,Quote_Outcome__c FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
          string  oppparid =oppPrtylist[0].id;
           
            string psosimplejson='[{"Name":"Road cover","premium":"200.00", "SumInsured": "0","OppParty":"'+oppparid+'"},{"Name":"Road cover","premium":"200.00", "SumInsured": "0","OppParty":"'+oppPrtylist[1].id+'"}]';
List<String> optList = CrossSellProductsController.getselectOptions(oppp, 'Rider_Type__c');
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
                    List<Opportunity> oppPrtylist1= CrossSellProductsController.fetchOpportunityRecord(oppId);
                    List<QuoteLineItem> quotelist= CrossSellProductsController.getQuoteLineItemsData(oppId,'Road Cover','Road Cover');
                    List<QuoteLineItem> quotelist1= CrossSellProductsController.getQuoteLineItemsDataByProduct(oppId,'Road Cover');
                    List<String> prdlist=CrossSellProductsController.getProducts(oppId);
                    list<Account> accdat = CrossSellProductsController.getAccountData('8107115017084');
                    CrossSellProductsController.createDDQuote(oppId, '200.00', 'Road Cover', psosimplejson,'',
                                               'Test Description', false, false,false,myOppList[0],'Client Intersted');
                    Integer age = CrossSellProductsController.calculateOpportunityPartyAge(accDOB);
                    System.assertEquals(10.0,CrossSellProductsController.getPolicyFee());
                }
               
            }
        }
    }
    @isTest static void quoteProcessTestP(){
             User uA = getUser();
        System.runAs(uA){
            Datetime td= System.today();
            Datetime cd = td.addYears(-5);
            Datetime sd = td.addYears(-30);
            Datetime accd = td.addYears(-35);
            String childDOB = cd.format('YYYY-MM-dd');
            String spouseDOB = sd.format('YYYY-MM-dd');
            Date dfSpouseDOB = date.newinstance(sd.year(), sd.month(), sd.day());
            String accDOB = sd.format('YYYY-MM-dd');
            Opportunity_Party__c oppp = new Opportunity_Party__c() ;
            List<Opportunity> myOppList = [SELECT Id,CreditLife_Plans__c,Card_Life_Plan__c,Absa_Staff_Member__c,Secondary_Life__c,Commission__c,Intial_Loan_Amount__c,DD_PhotoFinishSelected__c,Photo_Finish_Premium__c,DD_Additional_Cover_Selected__c,DD_Premium__c,Quote_Outcome_Reason__c,Quote_Outcome__c FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
            system.assertNotEquals(null, oppPrtylist);
          string  oppparid =oppPrtylist[0].id;
           
            string psosimplejson='[{"Name":"Ultimate Protector","premium":"200.00", "SumInsured": "0","OppParty":"rtyu"}]';
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
            CrossSellProductsController.createDDQuote(oppId, '200.00', 'Ultimate Protector', psosimplejson,'',
                                               'Test Description', true, true,true,myOppList[0],'Client Intersted');
                }
            }
            CrossSellProductsController.getQuoteData(myOppList[0].id);
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
                    vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
                }
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void updateOpportunityTest(){
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'DD STI Opportunity'];
			Financial_Product__c newProd = new Financial_Product__c(
                Name = 'STI',
                Description__c = 'STI',  
                Product__c = 'STI', 
                Sub_Product__c = 'STI',
                Business_Unit__c = 'Direct Delivery'
            );
            insert newProd;
				List<Account> accListInsert = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
				//accListInsert[0].PersonBirthdate = date.parse('06/07/1900');
                accListInsert[0].Phone = '0845563377';
                accListInsert[0].PersonHomePhone = '0845563377';
                accListInsert[0].Work_Phone__c = '0845563377';
				insert accListInsert;
				Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
				testOpportunity.RecordTypeId = rt.Id;
				testOpportunity.accountid = accListInsert[0].id;
                testOpportunity.STI_Policy_Number__c = '87452659';
				testOpportunity.Policy_Inception_Date__c = System.today();
				testOpportunity.Product_Provider__c = 'AIC/WEBSURE';
				testOpportunity.Policy_Income_Type__c = 'ST Personal Lines Code 54';
            	testOpportunity.StageName = 'Quote';
                testOpportunity.Product_Interest__c = newProd.Id;
				update testOpportunity;
        		CrossSellProductsController.updateOpportunity(testOpportunity,testOpportunity.Id);
        		CrossSellProductsController.pushToWebsure(testOpportunity.Id);
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
                    vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
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
                    vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
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
                    vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
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
                vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
            }
            System.Equals('Valid', vlaidCheck);
            System.assertEquals('Valid', vlaidCheck);


        }
    }
    @isTest static void quoteProcessTestH(){
        User uA = getUser();
        System.runAs(uA){
            String vlaidCheck;
            List<Account> myAccList = [SELECT Id, Country_of_Residence__pc, Nationality__pc, Country_of_Birth__pc, Income_Source__pc, CIF__c FROM Account WHERE OwnerID = :uA.Id];
            Account myAcc = new Account();
            if (!myAccList.isEmpty() && myAccList != null) {
                myAcc = myAccList.get(0);
                myAcc.PersonBirthdate = null;
                update myAcc;
                List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
                Opportunity myOpp = new Opportunity();
                if (!myOppList.isEmpty() && myOppList != null) {
                    myOpp = myOppList.get(0);
                    Id oppId = myOpp.Id;
                    vlaidCheck = CrossSellProductsController.checkAccountValid(oppId);
                }
            }
            System.assertNotEquals('Valid', vlaidCheck);
        }
    }
    @isTest static void quoteProcessTestG(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.assertNotEquals(null, myOppList);
            system.debug('---Oppty'+myOppList.size());
            Opportunity myOpp = new Opportunity();
            if (!myOppList.isEmpty() && myOppList != null) {
                myOpp = myOppList.get(0);
                Id oppId = myOpp.Id;
                String policy = CrossSellProductsController.getPolicy(myOppList[0].Id);
               /* System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Executors Fees Cover'));
                System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Estate Bridging Benefit'));
                System.assertEquals(null,QuotingProcessController.getMemberPremiumWbif(policy, oppId, '30000', 'Family Funeral'));
                Date d = Date.today();
                System.assertEquals(null,QuotingProcessController.getSpousePremiumWbif(policy, oppId, '30000', 30, d, 'Executors Fees Cover'));
                System.assertEquals(null,QuotingProcessController.getSpousePremiumWbif(policy, oppId, '30000', 30, d, 'Estate Bridging Benefit'));*/
            }
        }
    }
     @isTest static void quoteProcessTestI(){
        User uA = getUser();
        System.runAs(uA){
            //List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity LIMIT 1];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
            set <id> oppparidset =new set<id>{oppPrtylist[0].id};
            id oppparid =oppPrtylist[0].id;
            system.debug('---Oppty'+myOppList.size());
            Opportunity myOpp = new Opportunity();
            if (!myOppList.isEmpty() && myOppList != null) {
                myOpp = myOppList.get(0);
                Id oppId = myOpp.Id;
                List<Opportunity_Party__c> opppar=CrossSellProductsController.getPartyData(oppparid);
                List<Opportunity_Party__c> opppar1=CrossSellProductsController.getSingleParty(oppparidset);
              }
        }
    }
    
     @isTest static void quoteProcessTestL(){
        User uA = getUser();
        System.runAs(uA){
            //List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity LIMIT 1];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id AND DD_Cross_Sell_Product_Member_Type__c='Rider Individual'];
         set <id> oppparidset =new set<id>{oppPrtylist[0].id};
           CrossSellProductsController.deleteOppPartyData(oppPrtylist,oppPrtylist[0].id,true,false);
     }
     }
    @isTest static void quoteProcessTestM(){
        User uA = getUser();
        System.runAs(uA){
            //List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity LIMIT 1];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id AND DD_Cross_Sell_Product_Member_Type__c INCLUDES ('Rider Family')];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            oppPrtylist[0].DD_Cross_Sell_Product_Member_Type__c='Rider Family';
            updatelis.add(oppPrtylist[0]);
            set <id> oppparidset =new set<id>{oppPrtylist[0].id};
           CrossSellProductsController.deleteOppPartyData(updatelis,oppPrtylist[0].id,true,false);
     }
     }
    @isTest static void quoteProcessTestN(){
        User uA = getUser();
        System.runAs(uA){
            //List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity LIMIT 1];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id AND DD_Cross_Sell_Product_Member_Type__c INCLUDES ('Health Assistance')];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            oppPrtylist[0].DD_Cross_Sell_Product_Member_Type__c='Health Assistance';
            updatelis.add(oppPrtylist[0]);
            set <id> oppparidset =new set<id>{oppPrtylist[0].id};
           CrossSellProductsController.deleteOppPartyData(updatelis,oppPrtylist[0].id,false,true);
     }
     }
    @isTest static void quoteProcessTestO(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            for(Opportunity_Party__c oppt : oppPrtylist ){
                if(oppt.DD_Cross_Sell_Product_Member_Type__c!=null && oppt.DD_Cross_Sell_Product_Member_Type__c=='Health Assistance'){
                    updatelis.add(oppt);
                }
            }
            
           // updatelis.add(oppPrtylist[0]);
           // set <id> oppparidset =new set<id>{oppPrtylist[0].id};
         list<Opportunity_Party__c> opl=  CrossSellProductsController.insertOppPartyData(updatelis);
     }
     }
     @isTest static void quoteProcessTestX(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            for(Opportunity_Party__c oppt : oppPrtylist ){
                
                if(oppt.DD_Cross_Sell_Product_Member_Type__c!=null && oppt.DD_Cross_Sell_Product_Member_Type__c.contains('Rider Family')){
                    oppt.DD_Cross_Sell_Product_Member_Type__c='Ultimate Protector';
                    updatelis.add(oppt);
                    break;
                }
            }
            
           // updatelis.add(oppPrtylist);
           // set <id> oppparidset =new set<id>{oppPrtylist[0].id};
            
         list<Opportunity_Party__c> opl=  CrossSellProductsController.insertOppPartyData(updatelis);
     }
     }
    
     @isTest static void quoteProcessTestQ(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            for(Opportunity_Party__c oppt : oppPrtylist ){
                
                if(oppt.DD_Cross_Sell_Product_Member_Type__c==null){
                    oppt.DD_Cross_Sell_Product_Member_Type__c='Rider Family';
                    updatelis.add(oppt);
                }
            }
            
           // updatelis.add(oppPrtylist[0]);
           // set <id> oppparidset =new set<id>{oppPrtylist[0].id};
         list<Opportunity_Party__c> opl=  CrossSellProductsController.insertOppPartyData(updatelis);
     }
     }
     @isTest static void quoteProcessTestW(){
        User uA = getUser();
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id];
            system.assertNotEquals(null, myOppList);
            list<Opportunity_Party__c> oppPrtylist =[SELECT Id,DD_Cross_Sell_Product_Member_Type__c FROM Opportunity_Party__c WHERE Opportunity__c = :myOppList[0].Id];
         	list<Opportunity_Party__c> updatelis =new list<Opportunity_Party__c>();
            Opportunity_Party__c op = new Opportunity_Party__c();
            op.name='test';
            op.DD_Cross_Sell_Product_Member_Type__c='Rider Family';
            updatelis.add(op);
            
           // updatelis.add(oppPrtylist[0]);
           // set <id> oppparidset =new set<id>{oppPrtylist[0].id};
            test.startTest();
         list<Opportunity_Party__c> opl=  CrossSellProductsController.insertOppPartyData(updatelis);
            test.stopTest();
     }
     }
     @isTest static void getMemberPremiumWbif1(){
        User uA = getUser();
        System.runAs(uA){
            
            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            system.assertNotEquals(null, myOppList);
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
            
            CrossSellProductsController.getMemberPremiumWbif(psosimplejson,myOppList[0].Id,'10000','Death and Accidental Disability');
          
            Test.stopTest();
            
        
        }
    }
    
    @isTest static void getMemberPremiumWbif2(){
        User uA = getUser();
        System.runAs(uA){

            List<Quote> lstQuote = new List<Quote>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 2'];
            system.assertNotEquals(null, myOppList);
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
            
            CrossSellProductsController.getMemberPremiumWbif(psosimplejson,myOppList[0].Id,'10000','Accidental Death Benifit and Accidental Disability');
            CrossSellProductsController.getPremiumPlan();
            CrossSellProductsController.casaCheck(myOppList[0].id);
            CrossSellProductsController.getQuoteData1(myOppList[0].id,prod.Name);
            CrossSellProductsController.getPricingMatrix(myOppList[0].id,'Plan A','22','33','Credit Life Cover');
            CrossSellProductsController.getPricingMatrix(myOppList[0].id,'Plan A','22','33','Extended Cover');
            CrossSellProductsController.submitPolicy('Single Policy',myOppList[0].Id,'2234','Estate Bridging');
            try{
                CrossSellProductsController.retrievePriNumber(myOppList[0].Id);

            }catch(exception e){
                system.debug(e);
            }

            Test.stopTest();
        }
    }
}