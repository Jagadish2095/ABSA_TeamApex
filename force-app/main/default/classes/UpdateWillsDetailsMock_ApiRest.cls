/**
* Mock class for Update Wills Details
* @author  Himanshu Nimje
* @created 2019-01-23
*/

@isTest
global class UpdateWillsDetailsMock_ApiRest implements HttpCalloutMock {

    Private String typeTest;
    
    global UpdateWillsDetailsMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{"tran":"WILU","func":"UPDT","rc":"0","rcMessage":"TRANSACTION SUCCESSFUL","willNo":"41000010670","languageCode":"E","bigPrint":"Y","cifkey":"DOEJ   005","usrid":"INTERNET","testator":"JOHN DOE","testatrix":"","deliverMethod":"","advisorCode":"0","brokerCode":"420077","specialistCode":"0","submittedBy":"","submitterTelno":"0112345678","oldWillNo":"0000001747","oldFilingNumber":"0000001747","willFiled":"N","willLegal":"","fillNo":"80409WHITE   099","dateSigned":"10082005","dateFiled":"29082006","dateWithdrawn":"0","timeWithdrawn":"0","reasonWithdrawn":"New will with another Company","withdrawnCode":"","withdrawUserId":"","referalReason":"","whoDied":"","domicileSite":"3232","corpCode":"ABS","transactionSite":"27","tellerNo":"747","effectiveDate":"1012004","currentBalance":"0","productType":"WILL","productStatus":"FILED","branchCode":"8418","deceasedDate":"0","registrationDate":"16012008","willStatus":"?","willError":"?","newAmendRevise":"N","willOrigin":"","acknowledgeLetter":"Y","trackerStatus":"A","pricingFlag":"Y","advisorName":"Henry Cobb","brokerName":"","specialistName":"","caseNo":"0","salaryNo":"0","dispatchDate":"10072003","draftingBranch":"3232","correction":"N","revisionDate":"16012019","executorFeePlan":"Y","firstFileDate":"1122008","safeCustodyFee":"Y","emergencyWill":"N","dateReturned":"0","standAlone":"I","date1stScfLetter":"31012007","eisDate":"10072003","leadCode":"0","leadName":"","csaSent":"N","trustIndicator":"N","specialBequestVal":"0","casaNo":"","casaDate":"0","casaIndicator":"","feePaid":"N","amountDue":"60","payDate":"20120307"}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS){
            response.setBody('{"faultcode": "0x00d30003","faultstring": "Schema Validation Error in service AWupdateWillsDetailsV1: cvc-simple-type 1: element willNo of type {http://www.w3.org/2001/XMLSchema}integer may not be empty" }');
            response.setStatusCode(200);
        }
        return response; 
    }
}