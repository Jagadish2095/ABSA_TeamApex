/**
 * @description       : 
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-29
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-11   almas.aleem@absa.africa   Initial Version
**/
@isTest
public class securitiesOfferedCTRLTest {
    @testSetup static void createData(){  

        Account accRecord=new account();
        accRecord.Name='Test Acc1114';
        insert accRecord;

        Account accRecord2=new account();
        accRecord2.Name='Test Acc2';
        insert accRecord2;

        contact conRecord=new contact();
        conRecord.AccountId=accRecord.id;
        conrecord.lastname='TestCon1114';
        insert conRecord;

        AccountContactRelation acr = new AccountContactRelation(); 
        acr.Accountid = accRecord2.id;
        acr.Contactid = conRecord.id;
        insert acr;
        Product2 prod = new Product2(Name = 'Credit Onboarding Overdraft', Family = 'Cheque');
        insert prod;

        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;

        Pricebook2 customPB = new Pricebook2(Name='Standard Pricebook', isActive=true);
        insert customPB;

        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;

        Opportunity opp = new Opportunity();
        opp.AccountId = accRecord2.Id;
        opp.Name = 'Credit Onboarding';
        opp.StageName = 'Fulfill Product';
        opp.CloseDate = date.today();
        insert opp;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.id;
        oppLineItem.Product2Id = prod.id;
        oppLineItem.PricebookEntryId = customPrice.id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        insert oppLineItem;
        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;

        insert app;
    }
    @isTest static void testSecuritiesOffered(){
        Account accRecord2 = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c app = [SELECT Id FROM Application__c LIMIT 1];
        AccountContactRelation acr = [SELECT Id FROM AccountContactRelation LIMIT 1];
        OpportunityLineItem oppLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];

        Test.startTest();
        securitiesOfferedCTRL.getRelatedParties(opp.Id);
        securitiesOfferedCTRL.getSelectedMemberDetails(acr.Id);
        securitiesOfferedCTRL.getPrimaryAccount(opp.Id);
         securitiesOfferedCTRL.getSecuritiesOffered(opp.Id);
        securitiesOfferedCTRL.getSelectedMemberDetails(acr.Id);
        securitiesOfferedCTRL.getProductList(opp.Id, oppLineItem.Id);
        securitiesOfferedCTRL.getSecuritiesOfferedByAccount(opp.Id, acr.Id);
        securitiesOfferedCTRL.getChequeAndOverdraft(opp.Id, false);
        securitiesOfferedCTRL.setValidationFields(opp.Id, 'Securities_Offered', true);
        List<Application_Product__c> appList = securitiesOfferedCTRL.getUniqueIdentifiers(opp.Id);
        List<Application_Product__c> appList2 = securitiesOfferedCTRL.getOpportunityApplicationProducts(opp.Id);
        system.assertNotEquals(null, appList,'securities!');
        Test.stopTest();
    }

    @isTest static void testGetApplicationId(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        securitiesOfferedCTRL.getApplicationId(opp.Id);
        system.assertNotEquals(null, opp,'opportunity found!');
        Test.stopTest();
    }

    @isTest static void testgetOpportunityApplicationProducts(){
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity LIMIT 1];
        Test.startTest();
        securitiesOfferedCTRL.getOpportunityApplicationProducts(opp.Id);
        securitiesOfferedCTRL.getOpportunityLineItems (opp.Id);
        securitiesOfferedCTRL.getSecuritiesOfferedByAccount(opp.Id, opp.AccountId);
        securitiesOfferedCTRL.getSecuritiesOfferedByExternalEntity(opp.Id);
        securitiesOfferedCTRL.getPrimaryAccount(opp.AccountId);
        securitiesOfferedCTRL.getNewExistingProducts(opp.Id);
        Security_Offered__c sc1=new Security_Offered__c();
        sc1.Account__c=opp.AccountId;
        sc1.Physical_Address_line_1__c=null;
        sc1.Security_Type__c = 'General Pledge';
        sc1.Specific_Security__c ='No';
        insert sc1;
        securitiesOfferedCTRL.deleteSecurityOfferedRecord(sc1.Id);
        system.assertNotEquals(null, sc1,'securities!');
        Test.stopTest();
    }
}