/*
* Test Integration Handler for getTBMobileBeneficiaries service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
@isTest
public class getMobileBeneficiaries_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"mobileNumberList":[{"cellNo":"0831111234","ivrPaymentNo":"1","description":"R TEST1","cellProvider":"M"},{"cellNo":"0609800004","ivrPaymentNo":"8","description":"Test 25-02-13","cellProvider":"M"},{"cellNo":"060980000 ","ivrPaymentNo":"7","description":"Mom s cell","cellProvider":"C"},{"cellNo":"0603500002","ivrPaymentNo":"6","description":"Test 3a","cellProvider":"V"},{"cellNo":"0835551234","ivrPaymentNo":"12","description":"Yoke test phone","cellProvider":"C"},{"cellNo":"0651454303","ivrPaymentNo":"1","description":"Test","cellProvider":"T"},{"cellNo":"0835551111","ivrPaymentNo":"16","description":"Test Fraud","cellProvider":"M"},{"cellNo":"0620001122","ivrPaymentNo":"2","description":"Test 12-06-1","cellProvider":"T"},{"cellNo":"0731110006","ivrPaymentNo":"13","description":"Krish MTN","cellProvider":"M"},{"cellNo":"0829800681","ivrPaymentNo":"14","description":"Krish Vodacom","cellProvider":"V"},{"cellNo":"0614980955","ivrPaymentNo":"5","description":"Test TM","cellProvider":"T"},{"cellNo":"0636555111","ivrPaymentNo":"11","description":"test","cellProvider":"V"},{"cellNo":"0731110005","ivrPaymentNo":"4","description":"Test Client","cellProvider":"M"},{"cellNo":"0832221234","ivrPaymentNo":"1","description":"R TEST2","cellProvider":"M"},{"cellNo":"0832212   ","ivrPaymentNo":"1","description":"R TEST3","cellProvider":"V"},{"cellNo":"0831111235","ivrPaymentNo":"3","description":"R TEST2","cellProvider":"M"},{"cellNo":"0831111237","ivrPaymentNo":"2","description":"This is TEST5","cellProvider":"V"},{"cellNo":"0831111236","ivrPaymentNo":"2","description":"This is: TEST6 xxx","cellProvider":"V"},{"cellNo":"0831111240","ivrPaymentNo":"21","description":"This is: TEST7","cellProvider":"V"},{"cellNo":"0622213278","ivrPaymentNo":"9","description":"Test 16-07","cellProvider":"C"},{"cellNo":"0831111244","ivrPaymentNo":"2","description":"Test 30","cellProvider":"C"},{"cellNo":"0831112220","ivrPaymentNo":"3","description":"test 2-1","cellProvider":"I"},{"cellNo":"0831112221","ivrPaymentNo":"0","description":"test 2-2","cellProvider":"I"},{"cellNo":"0831112222","ivrPaymentNo":"22","description":"test 14-07-20","cellProvider":"I"},{"cellNo":"0719890294","ivrPaymentNo":"0","description":"test","cellProvider":"M"},{"cellNo":"0658133538","ivrPaymentNo":"0","description":"test","cellProvider":"T"},{"cellNo":"0799226364","ivrPaymentNo":"1","description":"test","cellProvider":"V"},{"cellNo":"0799226164","ivrPaymentNo":"0","description":"test","cellProvider":"V"},{"cellNo":"0723935023","ivrPaymentNo":"23","description":"testing -vod","cellProvider":"V"},{"cellNo":"0723935043","ivrPaymentNo":"24","description":"testing dats","cellProvider":"V"},{"cellNo":"0829800601","ivrPaymentNo":"1","description":"test upd 1","cellProvider":"V"},{"cellNo":"0747259417","ivrPaymentNo":"10","description":"Rica message test","cellProvider":"M"},{"cellNo":"0829800602","ivrPaymentNo":"0","description":"xyz","cellProvider":"V"}],"errorDesc":"NA"}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(getMobileBeneficiaries_IH_v1.INTEGRATION_API_NAME, new List<String>{getMobileBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        getMobileBeneficiaries_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
    
    private static getMobileBeneficiaries_Resp_IB_v1 callHandlerMethod() {
        getMobileBeneficiaries_Resp_IB_v1 responseBean = getMobileBeneficiaries_IH_v1.getMobileBeneficiaries('PIERIDO001');
        return responseBean;
    }
}