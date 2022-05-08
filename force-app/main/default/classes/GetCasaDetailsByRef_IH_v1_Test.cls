@isTest
public class GetCasaDetailsByRef_IH_v1_Test {

    @isTest static void testGetCasaDetailsByRefPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
        
        Test.startTest();
        // Call the method to test
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef('ABC123', '2019-04-05');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(200, responseBean.statusCode);
        GetCasaDetailsByRef_Req_IB_v1.dummyRequest();
    }
    
    @isTest static void testGetCasaDetailsByRefNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
        
        Test.startTest();
        // Call the method to test
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef('ABC123', '2019-04-05');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }
    
    @isTest static void testGetCasaDetailsByRefNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        // Call the method to test
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef('ABC123', '2019-04-05');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }
    
    @isTest static void testGetCasaDetailsByRefNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
        
        Test.startTest();
        // Call the method to test
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef('ABC123', '2019-04-05');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
        System.assertEquals(500, responseBean.statusCode);
    }
}