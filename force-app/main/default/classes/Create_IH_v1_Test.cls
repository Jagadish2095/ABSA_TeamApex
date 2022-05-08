/*
* Integration Test Handler for  Create  Service  for package linking
* @author Satya Boyenepalli
* @created 2021-03-02
*/
@isTest
public class Create_IH_v1_Test {


 public static final String POSITIVE_RESPONSE_BODY = '{"responseReason":"","responses":{"chequeResponse":"","cardResponse":""},"packageId":"210317095548571632","chequeAccountNumber":"4048374003","creditAccountNumber":"04550270024348018","packageType":"GOLD","pricingSchemeCode":"CQT01S03"}';
      
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Create_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest 
    public static void testPositive_CreatePackage() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Create_Resp_IB_v1 responseBean = callHandlerMethod();
        System.Debug('Create response:'+ JSON.serializePretty(responseBean));
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static Create_Resp_IB_v1 callHandlerMethod() {
        Create_Req_IB_v1 dummyBean = Create_Req_IB_v1.CreateDummyRequest();
        Create_Resp_IB_v1 responseBean = Create_Resp_IB_v1.dummyResponse();
        System.debug('Satya package create request:' +  JSON.serializePretty(dummyBean));
         responseBean = Create_IH_v1.CreatePackage(dummyBean);
         System.debug('Satya package create respone:' +  JSON.serializePretty(responseBean));
        return responseBean;
    }    
    
}