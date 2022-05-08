@isTest
public class DebitOrderManagementControllerTest {

    public static testMethod void testDebitOrderManagemeng(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        DebitOrderManagementController.getAccountInfoData(testDataFactory.testOpportunity.id);
        DebitOrderManagementController.getDebitOrderDetails(testDataFactory.testOpportunity.id);
        DebitOrderManagementController.checkBankAccount('1234567890','123456','01','DR','0','0','Sales','Salesforce','E','STD','N');
        DebitOrderManagementController.createDebitOrder(testDataFactory.testOpportunity, testDataFactory.testOpportunity.id);
        DebitOrderManagementController.getselectOptions(testDataFactory.testOpportunity,'Debit_Order_Account_Type__c');
        
        Test.stopTest();
    }
    //Added by Divya
    @isTest static void createQuote(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
            
            List<Quote> lstQuote = new List<Quote>();
            string psosimplejson='[{"Name":"Test","premium":200.00, "SumInsured": "Test Message","OppParty":"TestParty"}]';
          
            Pricebook2 standardPB = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true
            );
            update standardPB;
            
            Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
            insert pb;
            Product2 prod = new Product2(Name = 'Flexi Funeral Discount', Family = 'Best Practices', IsActive = true);
            insert prod;
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert standardPrice;
            
            PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert pbe;
            lstQuote.add(new Quote(OpportunityId = testDataFactory.testOpportunity.Id, Name = 'Test Quote' , Pricebook2Id = standardPB.Id, Status = 'Review Pending',Material_Disclosure_Status__c ='New',Product_Name__c = prod.Name));
            Insert lstQuote;
            
            Test.startTest();
            
            DebitOrderManagementController.createBankDebitOrder(testDataFactory.testOpportunity,testDataFactory.testOpportunity.Id,'Flexi Funeral Discount');
        	DebitOrderManagementController.getBankData(testDataFactory.testOpportunity.Id);
        	DebitOrderManagementController.getQuotesId(testDataFactory.testOpportunity.Id,'Flexi Funeral Discount');
            Test.stopTest();
        
    } 
    
}