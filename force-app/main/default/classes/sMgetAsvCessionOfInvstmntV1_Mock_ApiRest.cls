/**
 * @description       : Mock ApiRest Bean for sMgetAsvCessionOfInvstmntV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2020-03-03   Prashant Jain   Initial Version
**/

 @ isTest
global class sMgetAsvCessionOfInvstmntV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description Constructor
    * @author Prashant Jain | 2021-06-11  
    * @param typeTest 
    **/
    global sMgetAsvCessionOfInvstmntV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    /**
    * @description Implement this interface method
    * @author Prashant Jain | 2021-06-11 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVCessionOfInternalInvestmentsV1Response": { "nbsapdpo": { "returnCode": null, "reasonCode": null, "serviceVersion": null }, "nbsmsgo3": { "version": null, "nbrUserMsgs": null, "nbrUserErrs": null }, "smn146o": { "clcdOut": null, "totNomvalOut": null, "totSecvalOut": null, "totAppsecvalOut": null, "totMappsecvalOut": null, "successInd": null, "smn146oTable": [ { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" }, { "seqnoOut": "0", "dteSignedOut": "0", "ackdteOut": "0", "matdteOut": "0", "cessamtOut": "0", "nomvalOut": "0", "secvalOut": "0", "appsecvalOut": "0", "mappsecvalOut": "0", "ainvnoOut": "0", "accbalOut": "0", "camt1Out": "0", "camt2Out": "0", "camt3Out": "0", "camt4Out": "0", "camt5Out": "0", "totcesOut": "0", "avlamtOut": "0", "refaccnoOut": "0" } ] } } }');
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