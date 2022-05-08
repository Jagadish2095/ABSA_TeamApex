/**
 * @description       : 
 * @author            : Monde Masiza
 * @last modified on  : 2021-07-10
 * @last modified by  : Monde Masiza
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-06-14   Monde Masiza   Initial Version
**/
@isTest
public class CreateOpportunityLineItemTest {
    @isTest
    public static void createOpportunityLineItemsTest(){
        //Create Product
        Product2 pro = new Product2(Name = 'IDIRECT', Family = 'Short Term Insurance');
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opps';
        opp.StageName = 'New';
        opp.CloseDate = Date.today() + 10;
        insert Opp;
        test.startTest();
        CreateOpportunityLineItem.getOpportunityInputs(Opp.Id,pro.Name,'256486','58974','Service message');
        test.stopTest();
            
        
        
        
    }
    
    
}