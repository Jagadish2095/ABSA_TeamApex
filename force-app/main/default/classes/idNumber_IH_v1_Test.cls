/*
* Integration Handler for  idNumber Service  for package linking
* @author Satya Boyenepalli
* @created 2021-02-26
*/
@isTest
public class idNumber_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"customerDetails":null,"currentCustomerPackages":null,"qualifyingPackages":[{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025054011","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]},{"packageName":"GOLD PACKAGE","qualifyingProducts":{"chequeAccountDetails":{"clientFullName":null,"accountNumber":"4048286349","availableBalance":"1087022.51","accountStatus":"1","accountType":"32","accountBalance":"1087022.51"},"creditAccountDetails":{"creditAccountNumber":"4550270025104014","fiidNumber":"455027","accountType":"GLD","productType":"GOLD","accountStatus":"ACTIVE"}},"availablePricingScheme":[{"pricingSchemeIndicator":"","schemeDescription":"GOLD PACKAGE","schemeCode":"CQT01S48"}]}]}';
  
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{idNumber_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive_ClientKey() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        idNumber_Resp_IB_v1 responseBean = callHandlerMethod();
       /*  System.Debug('response:'+responseBean); */
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static idNumber_Resp_IB_v1 callHandlerMethod() {
        idNumber_Req_IB_v1 dummyBean = idNumber_Req_IB_v1.CreateDummyRequest();
         idNumber_Resp_IB_v1 responseBean = idNumber_Resp_IB_v1.dummyResponse();
        responseBean = idNumber_IH_v1.GetLinkProductsByIdnumber(dummyBean);
         System.debug('Satya package product respone:' +  JSON.serializePretty(responseBean));
        return responseBean;
    }    
    
}