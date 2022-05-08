/*
 * Mock ApiRest Bean for mlviewcomprehensivedetailsv1 service
 * @author Srikanth N
 * @created 2020-05-07
 */

 @ isTest
global class mlviewcomprehensivedetail_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  mlviewcomprehensivedetail_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"MLviewComprehensiveDetailsV1Response": {"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001", "echoKey": null},"mlp047o": {"errmsg": "0000","errsec": null,"accn": "8052424088","accnid": null,"corp": null,"capind": null,"bdcan": "0","clnt1": null, "clnt2": null,"caddr1": null,  "caddr2": null, "caddr3": null,"caddr4": null,"caddr5": null,"btype": null,"dombrc": null,"passbk": null,"cltyp": "0","dbind": "0","riskcd": null,"accntl": null,"dmlast": "0","site": "0","uaf": null,"ncaind": null,"holdCount": "0", "bondCount": "0", "bndtot": "0","covtot": "0","cgross": "0","commn": "0","grantListCount": "0","ntuCount": "0","icdate": "0","insfrq": null,"iddate": "0","iccode": "0", "ocdate": "0", "ncdate": "0","termyy": "0","termmm": "0","remyy": "0","remmm": "0","basins": "0","instat": "0","admin": "0","fixind": null,"hmp": "0","saveBondAmount": "0","hoc": "0", "snypay": "0","expdte": "0","volexe": "0","siramt": "0","endow": "0","tempin": "0", "temped": "0","totins": "0","ardate": "0","volstd": "0","volamt": "0","volper": "0", "volno": "0","volinc": "0", "vonext": "0","affiri": null,"myhome": null,"affind": null,"affcga": null,"affsub": null, "affamt": "0", "lifeac": null, "hschem": "0","empnbr": null, "schdes": null,"cclass": null,"subsind": null,"govscd": "0","notper": "0","mrdate": "0","stcode": "0","efffin": "0","rpxdte": "0", "fryy": "0","frmm": "0","rprcod": null,"cltcon": "0", "minvar": "0","negvar": "0","hlpind": null, "rate": "0","propListCount": "0","propInsurCount": "0","lifeAssurCount": "0"}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}