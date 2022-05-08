/*
* Test Integration Handler for CClistNominatableAccountsV1 Service
* @author Satya Boyenepalli
* @created 2020-11-04
*/
@isTest
public class CClistNominatableAccountsV1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CClistNominatableAccountsV1Response":{"ccp315o":{"nomAccntLst":[{"accntNbr":4048376500,"prodCode":11003,"prodType":"CQ"},{"accntNbr":9051337380,"prodCode":9050,"prodType":"SA"}],"nomNbrAccntRet":2,"nomNxtAccnt":0},"nbsapdpo":{"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001"},"nbsmsgo":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CClistNominatableAccountsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CClistNominatableAccountsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CClistNominatableAccountsV1_Resp_IB_v1 callHandlerMethod() {
        
        CClistNominatableAccountsV1_Req_IB_v1 dummyBean = CClistNominatableAccountsV1_Req_IB_v1.createDummyRequest();
       /* System.debug('Satya Nominated list request'+ JSON.serializePretty(dummyBean)); */
       
        
       CClistNominatableAccountsV1_Resp_IB_v1 responseBean = CClistNominatableAccountsV1_IH_v1.CClistNominatableAccounts(dummyBean);
   /* System.debug('Satya Nominated list'+ JSON.serializePretty(responseBean)); */
        return responseBean;
    }

}