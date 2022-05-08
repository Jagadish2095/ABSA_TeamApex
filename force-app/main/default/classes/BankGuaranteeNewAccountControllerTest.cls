/*
* Test Class For BankGuaranteeNewAccountController
* @author  Himani Joshi: Absa
* @version v1.0
* @since   2021-05-25
*
*/
@IsTest
public class BankGuaranteeNewAccountControllerTest {
    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Application_Product__c testAppProdCred = new Application_Product__c();
        testAppProdCred.Product_Name__c='Bank Guarantee';
        testAppProdCred.Product_State__c='Existing';
        testAppProdCred.Opportunity__c=opp.Id;
        testAppProdCred.Opportunity_Product_Id__c=opp.Id;
        //testAppProdCred.RecordId__c='a2p5r0000008Ud5AAE';
        insert testAppProdCred;
    }
     @isTest static void testgetBankGuarantees(){
         Application_Product__c app=[select Id from Application_Product__c];
         system.assertNotEquals(null, app);
         test.startTest();
         Boolean b=BankGuaranteeNewAccountController.deleteAccount(app.Id);
         test.stopTest();
        
     }

}