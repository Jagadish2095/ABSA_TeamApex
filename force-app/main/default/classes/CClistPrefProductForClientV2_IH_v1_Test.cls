/*
* Test Integration Handler for cclistprefproductsforclientv2 Service
* @author Mbuyiseni Mbhokane
* @created 2020-07-30
*/
@isTest 
public class CClistPrefProductForClientV2_IH_v1_Test {
    
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CClistPrefProductsForClientV2Response": {"nbsapdpo": {"version": "APLO003","returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": "DP78004351613468111"},"nbsmsgo": {"version": "MSG3001","nbrUserMsgs": "0","nbrUserErrs": "0"},"ccp317o": {"sbuCode": "F","nbrProdRet": "3","prdProdLst": [{"accntNbr": "4048063812","prodType": "CQ","prodCode": "11032","prodBrand": "N"},{"accntNbr": "9051159122","prodType": "SV","prodCode": "9082","prodBrand": "N"},{"accntNbr": "9051159122","prodType": "GE","prodCode": "99999","prodBrand": "N"}]}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistPrefProductForClientV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testCombiCardPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CClistPrefProductForClientV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static CClistPrefProductForClientV2_Resp_IB_v1 callHandlerMethod() {
        CClistPrefProductForClientV2_Req_IB_v1 dummyReqBean = CClistPrefProductForClientV2_Req_IB_v1.createDummyRequest();
        CClistPrefProductForClientV2_Resp_IB_v1 dummyrespBean = CClistPrefProductForClientV2_Resp_IB_v1.createDummyResponse();
        CClistPrefProductForClientV2_Resp_IB_v1 responseBean = CClistPrefProductForClientV2_IH_v1.cclistprefproductsforclient(dummyReqBean);
        return responseBean;
    }
    
}