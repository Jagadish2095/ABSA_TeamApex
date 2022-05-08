/*
 * Mock ApiRest Bean for sMgetAsVbondsV1 Service
 * @author Prashant Jain
 * @created 2020-03-03
 */

 @ isTest
global class sMgetAsVbondsV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param typeTest 
    **/
    global sMgetAsVbondsV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method

    /**
    * @description 
    * @author Prashant Jain | 2021-06-10 
    * @param request 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "SMgetASVbondsV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo3": { "version": "MSG3001", "nbrUserMsgs": "0", "nbrUserErrs": "0" }, "smn145o": { "tnomVal": "8060000", "tsecVal": "4782500", "tasvVal": "0", "tmasvVal": "4782500", "bondTable": [ { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "T471419/18", "propDesc": "ERF 3555 VILLIERS", "propType": "UARES", "bondRegnum": "B21254/2018", "seqno": "201", "regDt": "20190420", "bondRank": "2", "realmv": "9000000", "nomVal": "2000000", "secVal": "2000000", "asecVal": "2000000", "masecVal": "2000000", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471431", "propDesc": "ERF 1212 OVER FARM DE RANDBURG, JOHANNESBURG, 2092", "propType": "FPROP", "bondRegnum": "SYSTEMB000471416", "seqno": "210", "regDt": "20190424", "bondRank": "1", "realmv": "4500000", "nomVal": "2000000", "secVal": "2000000", "asecVal": "2000000", "masecVal": "2000000", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471433", "propDesc": "ERF 1213 OVER THE FARM AUCKLAND, JOHANNESBURG 2092", "propType": null, "bondRegnum": "SYSTEMB000471418", "seqno": "212", "regDt": "20190424", "bondRank": "1", "realmv": "3000000", "nomVal": "1000000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471435", "propDesc": "SUE", "propType": "UICOM", "bondRegnum": "SYSTEMB000471420", "seqno": "216", "regDt": "20190506", "bondRank": "1", "realmv": "20000", "nomVal": "20000", "secVal": "10000", "asecVal": "10000", "masecVal": "10000", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471436", "propDesc": "SUE AGAIN", "propType": "UARES", "bondRegnum": "SYSTEMB000471421", "seqno": "217", "regDt": "20190405", "bondRank": "1", "realmv": "30000", "nomVal": "30000", "secVal": "22500", "asecVal": "22500", "masecVal": "22500", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471439", "propDesc": "SUE", "propType": "OTHER", "bondRegnum": "SYSTEMB000471424", "seqno": "219", "regDt": "20190505", "bondRank": "1", "realmv": "10000", "nomVal": "10000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "AFRGRI", "titleDeed": "SYSTEMT000471440", "propDesc": "ERF 2212 - REPUBLIC ROAD - RANDBURG", "propType": "FPROP", "bondRegnum": "SYSTEMB000471425", "seqno": "220", "regDt": "20190512", "bondRank": "1", "realmv": "5000000", "nomVal": "3000000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "AFRGRI", "titleDeed": "SYSTEMT000471441", "propDesc": "ERF 2212, REPUBLIC ROAD , RANDBURG", "propType": "FPROP", "bondRegnum": "SYSTEMB000471426", "seqno": "221", "regDt": "20190512", "bondRank": "1", "realmv": "15000000", "nomVal": "10000000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "SYSTEMT000471442", "propDesc": "TEST ACCOUNT", "propType": "UARES", "bondRegnum": "SYSTEMB000471427", "seqno": "222", "regDt": "20190505", "bondRank": "1", "realmv": "1000000", "nomVal": "1000000", "secVal": "750000", "asecVal": "750000", "masecVal": "750000", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "CAPITEC", "titleDeed": "SYSTEMT000471443", "propDesc": null, "propType": null, "bondRegnum": "SYSTEMB000471428", "seqno": "223", "regDt": "20190404", "bondRank": "1", "realmv": "0", "nomVal": "1000000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": "N", "bondHoldCd": "ABSA", "titleDeed": "T12/", "propDesc": "S98 SA SUB", "propType": "OTHER", "bondRegnum": "B3432/2019", "seqno": "226", "regDt": "20190616", "bondRank": "1", "realmv": "4000000", "nomVal": "2000000", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" }, { "specific": null, "bondHoldCd": null, "titleDeed": null, "propDesc": null, "propType": null, "bondRegnum": null, "seqno": "0", "regDt": "0", "bondRank": "0", "realmv": "0", "nomVal": "0", "secVal": "0", "asecVal": "0", "masecVal": "0", "refNo": "0", "houseSchm": "0", "costClval": "0", "svperc": "0", "asvperc": "0" } ] } } }');
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