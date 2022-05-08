/**
 * 
 * Test Class for Asset Details Controller
 *
 * @author  Sandile Mathe
 * 
*/

@IsTest
public class LookUpAssetDetails_Test {
    static testMethod void testfetchData() {
        //application Product
        Application_Product_CAF__c app = new Application_Product_CAF__c();
        app.Serial_Number__c = 'S75759';
        app.VAT_Pay_Back__c = 'MONTH 3';
        insert app;
        
        //opportunity
        Opportunity opp = new Opportunity();
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Name = 'CAF Opp';
        insert opp;
        
        //lineItems
        
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
        oppLineItem.Application_Product_CAF__c = app.Id; 
        Insert oppLineItem;
        
        Vehicle_Make_Model__c vehicle = new Vehicle_Make_Model__c();
        vehicle.MM_Code__c = '1144565';
        vehicle.Make__c = 'BMW';
        vehicle.Model__c='320i';
        vehicle.Name = 'BMW-320i-1144565';
        insert vehicle;

        LookUpAssetDetails.saveVehicleDetails(app.Id, 'BMW-320i-1144565');
        LookUpAssetDetails.ApplicationId(opp.Id);
        LookUpAssetDetails.getSelectedVehicleDetails(app.Id);
        List<SObject> result = LookUpAssetDetails.fetchLookUpValues('maz', 'Vehicle_Make_Model__c');

        System.assert(result != null);
    }
       

}