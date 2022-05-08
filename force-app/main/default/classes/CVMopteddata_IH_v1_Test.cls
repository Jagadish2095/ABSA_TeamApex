/*
* Test Integration Handler for CVMopteddata Service
* @author Rankwe Lulu
* @created 2020-10-23
*/
@isTest
public class CVMopteddata_IH_v1_Test {

        public static final String POSITIVE_RESPONSE_BODY = '[{ "CIFkey": "CIF_NDHL008","ProviderName": "ABSA_Provider", "Message": "Test003"},{ "CIFkey": "CIF_NDHL008", "ProviderName": "ABSA_Provider","Message": "Test004"},{"CIFkey": "CIF_NDHL008","ProviderName": "ABSA_Provider","Message": "Test005"}]';

        @TestSetup
        static void makeData(){
            IntegrationTestDataFactory.insertIntegrationSettings(CVMopteddata_IH_v1.INTEGRATION_API_NAME, new List<String>{CVMopteddata_IH_v1.INTEGRATION_SERVICE_NAME});
        }
        
        @isTest static void testPositive() {
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            CVMopteddata_Res_IB_v1 dummyBean = CVMopteddata_Res_IB_v1.createDummyResponse();
            
            Test.startTest();
            
            CVMopteddata_Res_IB_v1 responseBean = callHandlerMethod();
            System.assertEquals(200, responseBean.statusCode);
            
            Test.stopTest();
        }
        
    private static CVMopteddata_Res_IB_v1 callHandlerMethod() {
 
        CVMopteddata_Req_IB_v1 dummyBean = CVMopteddata_Req_IB_v1.createDummyRequest();
        CVMopteddata_Req_IB_v1 response = CVMopteddata_IU_v1.mapRequestFields(new List<String> {'Mooim 005','nmhytr009'});
        CVMopteddata_Res_IB_v1 responseBean = CVMopteddata_IH_v1.cvMopteddata(dummyBean);
        return responseBean;
        }



    }