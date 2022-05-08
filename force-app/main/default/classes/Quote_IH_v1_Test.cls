/**
*  @description Get Absa Instant life quote response object integration service class test
*  @author Satya Boyenepalli
* @since  27/07/2021
**/
@isTest
public class Quote_IH_v1_Test {
    
 public static final String POSITIVE_RESPONSE_BODY = '{"ValidationErrors":[],"InsuredLineResults":[{"InsuredAmount":"6000000","ProductCode":"LIFE_COVER","PremiumAmount":"1273.63","StatusCode":"ACC"}],"WebLink":"https://qawww.instantlife.co.za/LifeInsurance/Restore?orderId=200799759ad643dea18e69a39521ed92&linkId=720d9870142a4af4b3764c90b3cb59f0"}';
    
    /**
 * @description MakeData
 */
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Quote_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    /**
 * @description testPositive Quote
 */
    @isTest static void testPositive_Quote() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        Quote_Res_IB_v1 responseBean = callHandlerMethod();
         System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    /**
 * @description callHandle Method
 * @return Quote_Res_IB_v1
 */
    private static Quote_Res_IB_v1 callHandlerMethod() {
        Quote_Req_IB_v1 dummyBean =  Quote_Req_IB_v1.CreateDummyRequest();
        Quote_Res_IB_v1 dummyRespBean = Quote_Res_IB_v1.dummyResponse();
        Quote_Res_IB_v1 responseBean = new Quote_Res_IB_v1();
         responseBean = Quote_IH_v1.AbsaInstantLifeQuote(dummyBean);
         System.assertEquals(200, responseBean.statusCode);
        return responseBean;
    }    
    
}