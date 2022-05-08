/**
* @description Get Absa Instant life Tracker response object integration service class test
* @author Satya Boyenepalli
* @since  28/07/2021
**/
@isTest
public class Tracker_IH_v1_Test {
public static final String POSITIVE_RESPONSE_BODY = '{"ValidationErrors":[],"Leads":[{"FirstName":"GERT COEN","LastName":"ABSA TEST","LeadDate":"2021-07-26T00:00:00","CallbackDateTime":"2021-07-29T10:00:00","LeadStatus":"InProgress"}]}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Tracker_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive_Tracker() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
       Tracker_Res_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static Tracker_Res_IB_v1 callHandlerMethod() {
        Tracker_Req_IB_v1 dummyBean =  Tracker_Req_IB_v1.createDummyRequest();
         Tracker_Res_IB_v1 dummyRespBean = Tracker_Res_IB_v1.dummyResponse();
        Tracker_Res_IB_v1 responseBean = new Tracker_Res_IB_v1();
         responseBean = Tracker_IH_v1.AbsaInstantLifeTracker(dummyBean);
         System.assertEquals(200, responseBean.statusCode);
         return responseBean;
    }
}