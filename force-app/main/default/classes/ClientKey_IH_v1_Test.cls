/*
* Integration Test Handler for  ClientKey Service  for package linking
* @author Satya Boyenepalli
* @created 2021-02-25
*/
@isTest
public class ClientKey_IH_v1_Test {
 public static final String POSITIVE_RESPONSE_BODY = '{"customerDetails":null,"currentCustomerPackages":null,"qualifyingPackages":[{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025054011","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]},{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025104014","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]}]}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ClientKey_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive_ClientKey() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        ClientKey_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    private static ClientKey_Resp_IB_v1 callHandlerMethod() {
        ClientKey_Req_IB_v1 dummyBean = ClientKey_Req_IB_v1.createDummyRequest();
         ClientKey_Resp_IB_v1 dummyResponseBean =  ClientKey_Resp_IB_v1.dummyResponse();
         ClientKey_Resp_IB_v1 responseBean= new  ClientKey_Resp_IB_v1();
         responseBean = ClientKey_IH_v1.GetLinkProductsByClientKey(dummyBean);

        return responseBean;
    }

}