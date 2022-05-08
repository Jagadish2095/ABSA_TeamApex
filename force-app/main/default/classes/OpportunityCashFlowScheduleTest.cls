/**
* Test class for all new Opportunities
* @author Rankwe Lulu
* @date   28/10/2020
*/
@isTest
public class OpportunityCashFlowScheduleTest {
         public static final String POSITIVE_RESPONSE_BODY = '[{ "CIFkey": "CIF_NDHL008","ProviderName": "ABSA_Provider", "Message": "Test003"},{ "CIFkey": "CIF_NDHL008", "ProviderName": "ABSA_Provider","Message": "Test004"},{"CIFkey": "CIF_NDHL008","ProviderName": "ABSA_Provider","Message": "Test005"}]';

    @testSetup
    static void dataCreation(){
        
        List<Application_Product__c>lstOfUpdateApplication = new List<Application_Product__c>();
        Application_Product__c appRec = new Application_Product__c();
        //appRec.CurrencyIsoCode = 'ZAR - South African Rand';
        appRec.Registered__c = true;
        appRec.Name__c='Testing App';
        appRec.Internet_Banking__c  = true;
        appRec.Cash_Flow_Manager__c = true;
        insert appRec;

    
        
    }
    static testMethod void testOpportunityCashFlowSchedule(){

        Test.startTest();
		dataCreation();        
         List<Application_Product__c> commList = [Select Id,Opportunity_Product_Id__c,Name,Registered__c,Opportunity__r.CIF_Number__c from Application_Product__c ];
        // List<OpportunityLineItem> oppLieItemslist = [Select Id from OpportunityLineItem ];
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));    
        ApplicationProductCashflowBatch bc = new ApplicationProductCashflowBatch();
  		database.executeBatch(bc);
        bc.execute(null, commList);
        
        
        System.Assert(commList[0].id != null,'The SMS was sent');
        
        OpportunityCashFlowSchedule instance = new OpportunityCashFlowSchedule();
        String cronExp = '0 0 23 * * ?'; 
        system.schedule('Test CashFlowSchedule', cronExp, instance); 
        Test.stopTest();
     
    }


}