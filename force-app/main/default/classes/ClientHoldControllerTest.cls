/*
 Controller Test Class For Client Hold Indicator
*
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-09-02
*/

@isTest
public class ClientHoldControllerTest {
     @isTest 
    public static void testNegativeHolds(){
        Account ac1 = new Account();
        ac1.Name='Test2';
        ac1.CIF__c= 'ATRUST1375'; //'ASS1223';
        insert ac1;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientHoldsMock_ApiRest(StringConstants.NEGATIVE_STRING_Hold));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_HOLDS});

         Test.startTest();
         ClientHoldController.getHoldRecordTypes(ac1.Id);
        Test.stopTest();
    }
   
    @isTest 
    public static void testNegativeClientHolds(){
          Account ac1 = new Account();
        ac1.Name='Test2';
        
        insert ac1;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientHoldsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_HOLDS});

         Test.startTest();
         ClientHoldController.getHoldRecordTypes(ac1.Id);
        //dummy response call 
        GetClientHolds_Resp_IB_v1 response = new GetClientHolds_Resp_IB_v1();
        Test.stopTest();
    }
   
    @isTest
    public static void testClientHolds(){
        Account ac = new Account();
        ac.Name='Test';
        ac.CIF__c= 'JESSOM 001'; //NOZENZO001';
        insert ac;
        
         // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetClientHoldsMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_CLIENT_HOLDS});

         Test.startTest();
         List <ClientHoldController.DisplayClientHoldRecordTypes> displayholdList = ClientHoldController.getHoldRecordTypes(ac.Id);
        system.assertNotEquals(null, displayholdList);
      
        Test.stopTest();
        
      
    }
    
   


}