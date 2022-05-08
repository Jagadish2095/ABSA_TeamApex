/**
 * @description Mock ApiRest Bean for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-20
 */

@isTest
global class MBupdateInstructionV1_Mock_ApiRest implements HttpCalloutMock {
	private String typeTest;

	/**
	 * @description Constructor
     * @param typeTest
	 */
	global MBupdateInstructionV1_Mock_ApiRest(final String typeTest) {
		this.typeTest = typeTest;
	}

	/**
	 * @description Implement this interface method
     * @param request
	 * @return response
	 */
	global HTTPResponse respond(HTTPRequest request) {
		// Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

		if (typeTest == StringConstants.POSITIVE_STRING) {
			response.setBody(
				'{ "MBupdateInstructionV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "nbrUserMsgs": "1", "nbrUserErrs": "1" }, "mbp300o": { "channel": "", "maxRetrieve": "1", "origType": "", "origStatus": "CURRENT", "todaysDate": "20200320", "timeNow": "14293183", "respCode": "0", "respOther": "0", "recsReturn": "0", "respDesc": "NO PARAMETER FOUND - PARM 08", "fwWarnInd": "", "accessAcc": "0", "cifKey": "", "tieb": "0", "instrType": "", "instrNo": "0", "multiNo": "0", "uniqueEft": "", "instrStatus": "CURRENT", "ivrNominate": "0", "intExtBenInd": "", "actDate": "0", "trigDate": "0", "startDate": "0", "endDate": "0", "freq": "", "amount": "0", "instrRefName": "", "srcAcc": "0", "srcAccType": "", "srcClrCode": "0", "srcInstCode": "", "srcStmtRef": "", "trgAcc": "0", "trgAccType": "", "trgClrCode": "0", "trgInstCode": "", "trgStmtRef": "", "trgBusinessCode": "0", "corpCode": "", "sbu": "", "clientType": "", "prelBypass": "", "minPayAmnt": "0", "maxPayAmnt": "9999999999999.99", "payDay": "0", "doType": "", "chqFlag": "", "freeBankInd": "N", "priNo": "0", "mandNo": "0", "pinAuth": "", "retryDate": "0", "retryAmount": "0", "retryCount": "0", "timeRange": "0", "verifTemplate": "", "cardAuth": "", "acbUserCode": "", "acbUcIndex": "0", "creditTrack": "", "notifInd": "", "srcFaxCode": "", "srcFaxNo": "", "srcFaxText": "", "srcCellCode": "", "srcCellNo": "", "srcCellText": "", "srcEmailAddr": "", "srcEmailText": "", "srcNotifMed": "NNN", "trgFaxCode": "", "trgFaxNo": "", "trgFaxText": "", "trgCellCode": "", "trgCellNo": "", "trgCellText": "", "trgEmailAddr": "", "trgEmailText": "", "trgNotifMed": "NNN", "iipAllowInd": "", "lastChangeNo": "0", "lastMaintFunc": "", "lastMaintDate": "20200320", "lastMaintTime": "14293183", "lastMaintBrnch": "", "lastMaintTell": "", "lastMaintOvrId": "", "lastMaintOvr2Id": "", "lastPaymDate": "0", "lastPaymAmnt": "0", "lastPaymErr": "", "userNumber": "", "firstName": "", "surname": "", "streetAddress": "", "city": "", "state": "", "country": "" } } }'
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