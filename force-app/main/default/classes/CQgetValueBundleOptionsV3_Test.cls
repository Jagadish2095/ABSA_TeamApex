@IsTest
public class CQgetValueBundleOptionsV3_Test {

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new List<String>{CQgetValueBundleOptionsV3_IH_v1.CQ_GET_VALUE_BUNDLE_OPTIONS_V3});
    }

    @isTest
    static void testCqGetValueBandleOptions(){
        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = new CQgetValueBundleOptionsV3_Resp_IB_v1();

        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O CQS044O = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O();
        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA CQS044O_OUTPUT_AREA = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA();
        CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE SCHEME_CODE_TABLE = new CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE();
        SCHEME_CODE_TABLE.CBP_PRICING_SCHEME_CODE = 'pricingSchemeCode';
        
        CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE = new List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE>{SCHEME_CODE_TABLE};
        CQS044O.CQS044O_OUTPUT_AREA = CQS044O_OUTPUT_AREA;
        responseBean.CQS044O = CQS044O;

        CQgetValueBundleOptionsV3_Req_IB_v1 fakeRequest = new CQgetValueBundleOptionsV3_Req_IB_v1();
    
        String responseBody = JSON.serialize(responseBean);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> testResponseBeean = DelinkingController.cqGetValueBandleOptions('12345');
        Test.stopTest();

        system.assertEquals('pricingSchemeCode', testResponseBeean[0].CBP_PRICING_SCHEME_CODE);
    }

    @IsTest
    static void testCqGetValueBandleOptionsNegative() {
        CQgetValueBundleOptionsV3_Resp_IB_v1 responseBean = new CQgetValueBundleOptionsV3_Resp_IB_v1();

        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O CQS044O = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O();
        CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA CQS044O_OUTPUT_AREA = new CQgetValueBundleOptionsV3_Resp_IB_v1.CQS044O_OUTPUT_AREA();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3 NBSMSGO3 = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3_internal NBSMSGO3_internal = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBSMSGO3_internal();
        CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY NBNMSGO3_MSG_ENTRY = new CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();

        NBNMSGO3_MSG_ENTRY.NBNMSGO3_MSG_TXT = 'test';
        NBSMSGO3_internal.NBNMSGO3_MSG_ENTRY = new List<CQgetValueBundleOptionsV3_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>{NBNMSGO3_MSG_ENTRY};
        NBSMSGO3.NBSMSGO3 = NBSMSGO3_internal;        
        // CQS044O_OUTPUT_AREA.SCHEME_CODE_TABLE = null;
        CQS044O.CQS044O_OUTPUT_AREA = CQS044O_OUTPUT_AREA;
        responseBean.CQS044O = CQS044O;
        responseBean.NBSMSGO3 = NBSMSGO3;

        CQgetValueBundleOptionsV3_Req_IB_v1 fakeRequest = new CQgetValueBundleOptionsV3_Req_IB_v1();
    
        String responseBody = JSON.serialize(responseBean);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, 200));

        Test.startTest();
        try {
            List<CQgetValueBundleOptionsV3_Resp_IB_v1.SCHEME_CODE_TABLE> testResponseBean = DelinkingController.cqGetValueBandleOptions('12345');
        } catch (Exception e) {
            system.assert(String.isNotBlank(e.getMessage()));
        }
        Test.stopTest();
    } 
}