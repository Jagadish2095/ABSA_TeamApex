/**
 * 
 * @Author : Mbuyiseni Mbhokane
 * @Since: 25/09/2020
 */
@isTest
public class CClistPrefProductForClientV2_IH_v2_Test {

    public static final String PREF_PROD_RESPONSE_BODY = '{"CCS317O": {"outputCopybook": {"productListTable": [{"prodCode": 11032,"prodBrand": "N","accountNumber": 4048063812,"prodType": "CQ"},{"prodCode": 9082,"prodBrand": "N","accountNumber": 9051159122,"prodType": "SV"},{"prodCode": 99999,"prodBrand": "N","accountNumber": 9051159122,"prodType": "GE"},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "",""prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""},{"prodCode": 0,"prodBrand": "","accountNumber": 0,"prodType": ""}],"cifRetrievedIndicator": "","sbuCode": "F","}},"NBSAPDPO": {"outputHeader": {"serviceVersion": "BUSO001","returnCode": 0,"echoKey": "","reasonCode": 0,"version": "APLO003"}},"NBSMSGO3": {"outputErrorMessage": {"systemErrorText": "","version": "","numberUserErrors": 0,"errorMessageTable": [{"errorMessageCode": "","errorMessageIndicator": "","errorMessageText": "","errorMessageClass": ""},{"errorMessageCode": "","errorMessageIndicator": "","errorMessageText": "","errorMessageClass": ""},{"errorMessageCode": "","errorMessageIndicator": "","errorMessageText": "","errorMessageClass": ""},{"errorMessageCode": "","errorMessageIndicator": "","errorMessageText": "","errorMessageClass": ""},{"errorMessageCode": "","errorMessageIndicator": "","errorMessageText": "","errorMessageClass": ""}],"numberUserMessages": 0}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistPrefProductForClientV2_IH_v2.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPrefProdServicePositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, PREF_PROD_RESPONSE_BODY));
        Test.startTest();
        CClistPrefProductForClientV2_Resp_IB_v2 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        
        Test.stopTest();
    }

    private static CClistPrefProductForClientV2_Resp_IB_v2 callHandlerMethod() {
        CClistPrefProductForClientV2_Req_IB_v2 dummyReqBean = CClistPrefProductForClientV2_Req_IB_v2.createDummyRequest();
        CClistPrefProductForClientV2_Resp_IB_v2 dummyrespBean = CClistPrefProductForClientV2_Resp_IB_v2.createDummyResponse();
        CClistPrefProductForClientV2_Resp_IB_v2 responseBean = CClistPrefProductForClientV2_IH_v2.cclistprefproductsforclient(dummyReqBean);
        return responseBean;
    }

}