/**
 * @description       : AccountsMetadata_IH_v1_Test
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-05-27
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Initial Version
**/
@isTest
public class AccountsMetadata_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{    "status": "SUCCESSFUL",    "errors": null,    "data": "Meta data successfully updated",    "links": []}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{AccountsMetadata_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        AccountsMetadata_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Service successful');
        Test.stopTest();
    }

    private static AccountsMetadata_Resp_IB_v1 callHandlerMethod() {
        AccountsMetadata_Req_IB_v1 dummyBean = AccountsMetadata_Req_IB_v1.createDummyRequest();
        AccountsMetadata_Resp_IB_v1 responseBean = AccountsMetadata_IH_v1.submitAccountMetadata(dummyBean);
        return responseBean;
    }
}