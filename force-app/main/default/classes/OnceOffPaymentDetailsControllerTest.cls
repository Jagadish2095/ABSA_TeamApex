/**
* Test class for OnceOffPaymentDetailsController
*
* @author  Himani Joshi
* @version v1.0
* @since   2020-11-30

*/
@IsTest
public class OnceOffPaymentDetailsControllerTest {
    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact;
        
        //Products
        Id pricebookId = Test.getStandardPricebookId();
        
        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'EPP Executor Fees Policy';
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
        Insert oppLineItem;
        
        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        insert testAppProdCred;
        
        Case caseRecord=new Case();
        caseRecord.Status='New';
        caseRecord.Application_Product_Id__c=testAppProdCred.Id;
        caseRecord.Opportunity__c=opp.Id;
        caseRecord.ContactId=testContact.Id;
        insert caseRecord;
        
        
        
    }
    static testMethod void testPaymentSection(){
        Case cse=[select Id,casenumber from Case];
        Payment_plan__c pp=new Payment_plan__c();
        pp.Name=cse.caseNumber;
        pp.Method__c='Debit Instruction';
        pp.Status__c='Submitted';
        pp.Once_Off_Payment_Required__c='Yes';
        pp.Target_Account__c='11';
        pp.Target_Account_Type__c='Savings Account';
        pp.Target_Clearance_Code__c='242';
        pp.Statement_Reference__c='trx';
        pp.Amount_Fullfillment__c='113';




        insert pp;
        List<Payment_Plan__c>paymentList=new List<Payment_Plan__c>();
        paymentList.add(pp);
        test.startTest();
        Payment_Plan__c paymentPlan =  OnceOffPaymentDetailsController.getPayments(cse.Id);
        System.assertNotEquals(null,paymentPlan);
        Boolean response =  OnceOffPaymentDetailsController.saveClass(paymentList);
        System.assertNotEquals(null,response);
        test.stopTest();
    }
    
}