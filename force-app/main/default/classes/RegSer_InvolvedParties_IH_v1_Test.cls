@isTest
public class RegSer_InvolvedParties_IH_v1_Test {

     @isTest static void involvedPartiesPositive() {
        
         // Set mock callout class 
         Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
         IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
         Test.startTest();
         
         RegSer_InvolvedParties_Resp_IB_v1 responseBean = RegSer_InvolvedParties_IH_v1.getInvolvedParties('ID Number','8701057648086');
         System.debug('Reg Compliance responseBean get: '+responseBean);
         System.assertEquals(200, responseBean.statusCode);
         
         Test.stopTest();
    }
    
        @isTest static void involvedPartiesNegative() 
    {        
        // Set mock callout class 
       Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        Test.startTest();
        
        RegSer_InvolvedParties_Resp_IB_v1 responseBean = RegSer_InvolvedParties_IH_v1.getInvolvedParties('ID Number','8701057648086');
        System.debug('Reg Compliance responseBean get: '+responseBean);
      
        Test.stopTest();
    }
    
    @isTest static void involvedPartiesInfoException() 
    {        
        // No mock callout class 
       // IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
         RegSer_InvolvedParties_Resp_IB_v1 responseBean = RegSer_InvolvedParties_IH_v1.getInvolvedParties('', '877nm345wr435');
        Test.stopTest();
    } 
    
    
    
}