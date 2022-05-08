/*
 * Mock ApiRest Bean for CIgetClientDetailsByNameV2 Service
 * @author Rudolf Niehaus
 * @created 2020-04-07
 */

 @ isTest
global class CIgetClientDetailsByNameV2_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global CIgetClientDetailsByNameV2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{ "CIgetClientDetailsByNameV2Response": { "nbsapdpo": { "version": "APLO003", "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "sysErrTxt": null, "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": null, "msgCode": null, "msgErrInd": null, "msgTxt": null } }, "cip602o": { "lastSearchPos": "OOSTHUIZEN                                                  AK 01197305241IOOSTHAK001", "nbrEntsRetrieved": "15", "tblEntry": [ { "cifKey": "OOSTHA 001", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "1249512825", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "8", "cifBirthDate": "19530123", "cifAddrLine1": "WATERSONLAAN 47", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "KILNER PARK", "cifPostlCodeRsa": "186", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 004", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-736363368", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "2", "cifBirthDate": "19570727", "cifAddrLine1": "NIMRODSTRAAT 3", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "BETHELSDORP UIT 29", "cifPostlCodeRsa": "6059", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 028", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-2081880741", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "1", "cifBirthDate": "19630722", "cifAddrLine1": "27 ROCK", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "RANDBURG", "cifPostlCodeRsa": "2194", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 018", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-1021904881", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "2", "cifBirthDate": "19690528", "cifAddrLine1": "PO BOX 771", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "POSTMASBURG", "cifPostlCodeRsa": "8420", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 005", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "2", "idDocType": "1", "idNbr": "1958383304", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "2", "cifBirthDate": "19700705", "cifAddrLine1": "172 BRAND STREET", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "DANVILLE", "cifPostlCodeRsa": "183", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 002", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "2", "idDocType": "1", "idNbr": "99009401", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "4", "cifBirthDate": "19720705", "cifAddrLine1": "POSBUS 4096", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "LADYSMITH", "cifPostlCodeRsa": "3370", "cifCorpCode": "A" }, { "cifKey": "OOSTHA 003", "cifInitials": "A", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "7", "idDocType": "1", "idNbr": "74409526", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "12", "cifBirthDate": "19581116", "cifAddrLine1": "13 SHINGARA", "cifAddrLine2": "PETROY STREET", "cifPostlSuburb": null, "cifPostlTown": "FOURWAYS", "cifPostlCodeRsa": "2191", "cifCorpCode": "A" }, { "cifKey": "OOSTHAC002", "cifInitials": "AC", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-1231301671", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "0", "cifBirthDate": "19571107", "cifAddrLine1": "PRINCESS ELIZABETHSTRAAT 15", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "RUYTERWACHT", "cifPostlCodeRsa": "7460", "cifCorpCode": "A" }, { "cifKey": "OOSTHAC001", "cifInitials": "AC", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "2", "idDocType": "1", "idNbr": "-658511419", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "3", "cifBirthDate": "19620127", "cifAddrLine1": "2201 SWEETWATERS", "cifAddrLine2": "16 BEACH RD", "cifPostlSuburb": null, "cifPostlTown": "AMANZIMTOTI", "cifPostlCodeRsa": "4126", "cifCorpCode": "A" }, { "cifKey": "OOSTHAG001", "cifInitials": "AG", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "1665149476", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "3", "cifBirthDate": "19461016", "cifAddrLine1": "POSBUS 80013", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "DOORNPOORT", "cifPostlCodeRsa": "17", "cifCorpCode": "A" }, { "cifKey": "OOSTHAH002", "cifInitials": "AH", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "1153343306", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "3", "cifBirthDate": "19700624", "cifAddrLine1": "PRIVAATSAK X6055", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "PORT ELIZABETH", "cifPostlCodeRsa": "6000", "cifCorpCode": "A" }, { "cifKey": "OOSTHAH001", "cifInitials": "AHJ", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-1700724185", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "3", "cifBirthDate": "19580509", "cifAddrLine1": "POSBUS 50094", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "HERCULES", "cifPostlCodeRsa": "30", "cifCorpCode": "A" }, { "cifKey": "OOSTHAJ266", "cifInitials": "AJ", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "1871750566", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "2", "cifBirthDate": "19481223", "cifAddrLine1": null, "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": null, "cifPostlCodeRsa": "0", "cifCorpCode": "A" }, { "cifKey": "OOSTHAJ257", "cifInitials": "AJ", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "3", "idNbr": "19770327", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "16", "cifBirthDate": "19770325", "cifAddrLine1": "POSBUS 1228", "cifAddrLine2": null, "cifPostlSuburb": null, "cifPostlTown": "SUNDOWNER", "cifPostlCodeRsa": "2161", "cifCorpCode": "A" }, { "cifKey": "OOSTHAK001", "cifInitials": "AK", "cifSurname": "OOSTHUIZEN", "cifTitleCode": "1", "idDocType": "1", "idNbr": "-494287416", "cifClntType": "101", "cifClntGroup": "I", "cifNbrOfAccts": "4", "cifBirthDate": "19730524", "cifAddrLine1": "6 NIKIS", "cifAddrLine2": "DRAKENSBERG RD", "cifPostlSuburb": null, "cifPostlTown": "THE HILL", "cifPostlCodeRsa": "2197", "cifCorpCode": "A" } ] } } }');
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