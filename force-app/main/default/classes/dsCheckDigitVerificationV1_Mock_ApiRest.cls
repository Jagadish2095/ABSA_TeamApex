@isTest
global class  dsCheckDigitVerificationV1_Mock_ApiRest  implements HttpCalloutMock {
    private String typeTest;
    /**
     * @description constructor method
     * @param typeTest
     */
    global dsCheckDigitVerificationV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }
    /**
	 * @description Implement this interface method
	 * @return HTTPResponse
	 * @param request
	 */
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody(
                    '[Base_IB.Fault=null, Base_IB.fieldNameSubstitutionMap={}, Base_IB.integrationTranslationsMap={}, Base_IB.maskedFieldsSet=null, Base_IB.message=null, Base_IB.requiredFieldsSet={}, Base_IB.status=OK, Base_IB.statusCode=200, accountExceptionInd=0, accountHost=F, acctypeZeroAllowed=null, aedossAcq=Y, aedossIss=Y, bankCode=3, bankNameLong=NEDBANK                         NEDSZAJJ, bankNameShort=NEDBANK, branchName=PNP TEMBISA, branchType=C, dt2Allowed=Y, dt5Allowed=Y, naedossAcq=Y, naedossIss=Y, rc=0, ssvAllowed=Y]'
            );
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        } else if (typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response;
    }

}