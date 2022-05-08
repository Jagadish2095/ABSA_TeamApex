/*
 * Mock ApiRest for CAMS Services
 * @author Jason Quevauvilliers
 * @created 2020-05-29
 */

@isTest
global class MerchantManagement_Mock_ApiRest implements HttpCalloutMock {
    private String typeTestMASSAccount;
    private String typeTestMerchantPlan;
    private String typeTestPOSH;
    private Boolean includeSuccessInResultTagMASSAccount;
    private Boolean includeSuccessInResultTagMerchantPlan;
    private Boolean includeSuccessInResultTagPOSH;

    global MerchantManagement_Mock_ApiRest(final String typeTestMASSAccount, final String typeTestMerchantPlan, final String typeTestPOSH, final Boolean includeSuccessInResultTagMASSAccount, final Boolean includeSuccessInResultTagMerchantPlan, final Boolean includeSuccessInResultTagPOSH) {
        this.typeTestMASSAccount = typeTestMASSAccount;
        this.typeTestMerchantPlan = typeTestMerchantPlan;
        this.typeTestPOSH = typeTestPOSH;
        this.includeSuccessInResultTagMASSAccount = includeSuccessInResultTagMASSAccount;
        this.includeSuccessInResultTagMerchantPlan = includeSuccessInResultTagMerchantPlan;
        this.includeSuccessInResultTagPOSH = includeSuccessInResultTagPOSH;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if(request.getEndpoint().contains(MPScreateMASSAccountV2_IH_v1.INTEGRATION_SERVICE_NAME)){

            if (typeTestMASSAccount == StringConstants.POSITIVE_STRING) {
                if(includeSuccessInResultTagMASSAccount){
                    response.setBody('{ "MPScreateMASSAccountV2Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0" }, "zbp004o": { "mrchAcctNbr": "1037886", "refNum": "GN20202010378", "result": "00000 SUCCESS" } } }');
                }else{
                    response.setBody('{ "MPScreateMASSAccountV2Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0" }, "zbp004o": { "mrchAcctNbr": "1037886", "refNum": "GN20202010378", "result": "123" } } }');
                }
                response.setStatusCode(200);
            } else if (typeTestMASSAccount == StringConstants.NEGATIVE_STRING) {
                response.setBody('{"errorCode": 400,"message": "Bad request"}');
                response.setStatusCode(400);
            } else if (typeTestMASSAccount == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
                response.setBody('{}');
                response.setStatusCode(500);
            }

        }else if (request.getEndpoint().contains(MpsCreateMerchantPlanv1_IH_v1.INTEGRATION_SERVICE_NAME)){

            if (typeTestMerchantPlan == StringConstants.POSITIVE_STRING) {
                if(includeSuccessInResultTagMerchantPlan){
                    response.setBody('{ "MPScreateMerchantPlanV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "zbp005o": { "mrchAcctNbr": "00000000000000001037894", "refNum": "GN20202010378", "result": "00000 SUCCESS" } } }');
                }else{
                    response.setBody('{ "MPScreateMerchantPlanV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "zbp005o": { "mrchAcctNbr": "00000000000000001037894", "refNum": "GN20202010378", "result": "123" } } }');
                }
                response.setStatusCode(200);
            } else if (typeTestMerchantPlan == StringConstants.NEGATIVE_STRING) {
                response.setBody('{"errorCode": 400,"message": "Bad request"}');
                response.setStatusCode(400);
            } else if (typeTestMerchantPlan == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
                response.setBody('{}');
                response.setStatusCode(500);
            }

        }else if (request.getEndpoint().contains(MpsCreatePoshMerchantv3_IH_v1.INTEGRATION_SERVICE_NAME)){

            if (typeTestPOSH == StringConstants.POSITIVE_STRING) {
                if(includeSuccessInResultTagPOSH){
                    response.setBody('{ "MPScreatePOSHMerchantV3Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0" }, "zbp006o": { "mrchAcctNbr": "00000000000000000000000", "refNum": "GN20202010378", "result": "00000 SUCCESS" } } }');
                }else{
                    response.setBody('{ "MPScreatePOSHMerchantV3Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0" }, "zbp006o": { "mrchAcctNbr": "00000000000000000000000", "refNum": "GN20202010378", "result": "123" } } }');
                }
                response.setStatusCode(200);
            } else if (typeTestPOSH == StringConstants.NEGATIVE_STRING) {
                response.setBody('{"errorCode": 400,"message": "Bad request"}');
                response.setStatusCode(400);
            } else if (typeTestPOSH == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
                response.setBody('{}');
                response.setStatusCode(500);
            }
        }

        return response;
    }
}