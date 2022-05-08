/** 
* @description - Test class for RemediateCustomerController
* @author  Saiteja : Absa
* @version v1.0
* @since   2021-05-03
**/
@istest
public class RemediateCustomerControllerTest {

    @istest
    public static void testRemediateCustomer(){
      Account account = new Account(Name = 'Test Account');
            insert account;

        Date todaysDate = System.today();
        //String ProductName = 'REFRESH';
        Map<String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Id stdpriceBook = Test.getStandardPricebookId();
        //system.debug('stdpriceBook'+stdpriceBook);
        Product2 prod = new Product2(name = 'REFRESH');
        insert prod;
        PricebookEntry pbe = new PricebookEntry(IsActive=true,Pricebook2Id=stdpriceBook,Product2Id=prod.Id,UnitPrice=10.00);  
        insert pbe;
        //system.debug('pbe'+pbe);

        
        PriceBook2 priceBookItem1 = new PriceBook2(name = 'Price Book test', IsActive = true);
        insert  priceBookItem1;
        PricebookEntry pbe1 = new PricebookEntry(IsActive=true,Pricebook2Id=priceBookItem1.id,Product2Id=prod.Id,UnitPrice=100.00);  
        insert pbe1;

           
        Opportunity opp = new Opportunity();
        opp.Name = 'Remediation Opportunity for Manual Refresh';
        opp.AccountId = account.id;
        opp.StageName = 'Open';
        opp.closeDate = todaysDate.addDays(7);
        opp.RecordTypeId =OpportunityRecordTypeMap.get('Customer_Remediation').getRecordTypeId();
        opp.priceBook2Id = priceBookItem1.id;
        opp.Process_Type__c = 'Remediate Existing Customer';
        insert opp;
        opportunity oppt = new opportunity();
        
        test.startTest();
        
        RemediateCustomerController.getOpportunity(account.id);
        oppt = RemediateCustomerController.createOpp(account.id);
        RemediateCustomerController.updateOwner(opp.id);

        system.assertNotEquals(null,oppt);
        test.stopTest();
}

}