@IsTest
public class CQgetChargesDetailsMaintV9_Test {
    
    public static void testCQgetChargesDetails(Boolean insertIntegrationSettings, Integer statusCode, Boolean isErrorResponse) {
        
        if (insertIntegrationSettings) {
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {CQgetChargesDetailsMaintV9_IH_v1.CQ_GET_CHARGES_DETAILS_MAINT_V9});
        }

        String errorMessage = 'Test Error Message';

        String responseBody = '{"errorMessage" : "' + errorMessage + '"}';

        if (!isErrorResponse) {
            responseBody = JSON.serialize(CQgetChargesDetailsMaintV9_Resp_IB_v1.dummyResponse());
        }
        System.debug('isErrorResponse ' + isErrorResponse);
        Test.setMock(HttpCalloutMock.class, new CQcalloutMock(responseBody, statusCode));

        Test.startTest();
        try {
            Map<CQgetChargesDetailsMaintV9_Resp_IB_v1, List<Sys_Log_Integration__c>> response = CQgetChargesDetailsMaintV9_IH_v1.callToCQgetChargesDetailsMaintV9('12345');

            if (insertIntegrationSettings) {
                System.assertEquals(statusCode, new List<CQgetChargesDetailsMaintV9_Resp_IB_v1> (response.keySet())[0].statusCode);
            } else {
                System.assertEquals(500, new List<CQgetChargesDetailsMaintV9_Resp_IB_v1> (response.keySet())[0].statusCode);    
            }

        } catch (Exception e) {
            System.assertEquals(errorMessage, e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void testCQgetChargesDetailsPositive() {
        testCQgetChargesDetails(true, 200, false);
    }

    @IsTest
    public static void testCQgetChargesDetailsNegative() {
        testCQgetChargesDetails(false, 200, false);
    }

    @IsTest 
    public static void testCQgetChargesDetailsStatusFailed() {
        testCQgetChargesDetails(true, 500, false);
    }

    @isTest 
    public static void testCQgetChargesDetailsBadResponse() {
        testCQgetChargesDetails(true, 200, true);
    }

    @IsTest 
    public static void testCQgetChargesDetails_Req() {
        CQgetChargesDetailsMaintV9_Req_IB_v1.createDummyRequest();
    }
}