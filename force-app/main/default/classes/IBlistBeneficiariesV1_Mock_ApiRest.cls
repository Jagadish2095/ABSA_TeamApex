/*
 * Mock ApiRest Bean for IBlistBeneficiariesV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-19
 */

 @ isTest
global class IBlistBeneficiariesV1_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global IBlistBeneficiariesV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{ "IBlistBeneficiariesV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": null, "msgCode": null, "msgErrInd": null, "msgTxt": null } }, "nhp457o": { "combiCardNumber": "-1367581969", "clientName": "MR    D   ZUMA", "division": "ABSA", "numberOfBeneficiaries": "10", "linkedBeneficiaries": [ { "instructionNumber": "43", "beneficiaryName": "Jan1", "bankName": "ABSA BANK", "targetAccountNumber": "461020874", "sourceStatementRef": "Jan1", "targetStatementRef": "Jan1" }, { "instructionNumber": "44", "beneficiaryName": "CACADU DIS", "bankName": "CACADU DIS", "targetAccountNumber": "1234567", "sourceStatementRef": "rent", "targetStatementRef": "sizwe" }, { "instructionNumber": "45", "beneficiaryName": "ADULLAM TR", "bankName": "ADULLAM TR", "targetAccountNumber": "234567", "sourceStatementRef": "sizwe", "targetStatementRef": "trust" }, { "instructionNumber": "46", "beneficiaryName": "AMER-SWISS", "bankName": "AMER-SWISS", "targetAccountNumber": "1", "sourceStatementRef": "TEST", "targetStatementRef": "zuma" }, { "instructionNumber": "47", "beneficiaryName": "AMER-SWISS", "bankName": "AMER-SWISS", "targetAccountNumber": "456", "sourceStatementRef": "Test", "targetStatementRef": "Sizwe" }, { "instructionNumber": "48", "beneficiaryName": "Parklands", "bankName": "ABSA BANK", "targetAccountNumber": "-246949655", "sourceStatementRef": "Parklands", "targetStatementRef": "Parklands" }, { "instructionNumber": "49", "beneficiaryName": "Parklands", "bankName": "ABSA BANK", "targetAccountNumber": "-1293641773", "sourceStatementRef": "Parklands", "targetStatementRef": "Parklands" }, { "instructionNumber": "51", "beneficiaryName": "April", "bankName": "ABSA BANK", "targetAccountNumber": "-1293641773", "sourceStatementRef": "April", "targetStatementRef": "April" }, { "instructionNumber": "52", "beneficiaryName": "2020", "bankName": "FIRSTRAND", "targetAccountNumber": "1872305093", "sourceStatementRef": "2020", "targetStatementRef": "2020" }, { "instructionNumber": "54", "beneficiaryName": "Nyandane", "bankName": "FIRSTRAND", "targetAccountNumber": "1872305093", "sourceStatementRef": "Nyandane", "targetStatementRef": "Nyandane" } ] } } }');
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