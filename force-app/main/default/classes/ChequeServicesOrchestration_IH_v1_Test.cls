/**
 * @description       : Integration Handler for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
 **/

@isTest
public class ChequeServicesOrchestration_IH_v1_Test {
	public static final String   POSITIVE_RESPONSE_BODY = '{"CQgetBasicAcctDetailsV7Response":[{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO006","echoKey":null},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}]},"cqh455o":{"accountNo":"4047854674","availBal":"16110.6","accountStatus":"1","authHoldAmt":"0","accountType":"16","accountBalance":"16110.6","overdraftExists":"N","overdraftType":"0","overdraftLimit":"0","dateOvrdrftArrngd":"0","ovrdrftExpryDate":"0","branchCode":"8198","division":"ABS","chargesDue":"0","commitmentInterest":"0","clearingCode":"633305","creditInterestDue":"0.88","debitInterestDue":"0","daylightExpryDate":"0","daylightLimit":"0","fullCrTrckngInd":"N","guarnteeAmtReserved":"0","accountHolds":[{"accountHold":"GET-PSTADD"},{"accountHold":"HIGH RISK"},{"accountHold":"POT-BD-DBT"},{"accountHold":"CSQ"},{"accountHold":"PBD"},{"accountHold":"SEC:NONE"},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null}],"markedCheqsAmt":"0","clientFullName":"SNIFFELS (PTY) LTD","ncaAgreemntInd":"N","newStmtFreq":"0","offlnAuthAmt":"0","postDatedTran":"0","penaltyInt":"0","returnedCheques":"0","specialName":null,"nxtStmntDate":"20201022","stmntFreq":"1","unclearedCheqs":"0","wapHold":null,"accntCloseDate":"0","closeReason":"0","accountDomicleBrch":"0","accountDomicleDiv":null,"statementImageInd":"N","negotiatedCheqAmt":"0","newNxtStmntDate":"0","openDate":"20160511","openReason":"1","prefStmntInd":"N","stmntReleaseInd":"P","stmntReqdInd":"Y","unilatrlLimitIncrease":"N","accountInactiveInd":null,"businessUnit":"1","onedaypaafInd":null,"onedaypaafTot":"0","bomSponsoredAmt":"0","digitalChannel":null,"empowermentFund":null,"rconStmntFreq":"1","rconNxtStmntDate":"20190311"}},{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO006","echoKey":null},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}]},"cqh455o":{"accountNo":"4048200886","availBal":"0","accountStatus":"99","authHoldAmt":"0","accountType":"16","accountBalance":"0","overdraftExists":"N","overdraftType":"0","overdraftLimit":"0","dateOvrdrftArrngd":"0","ovrdrftExpryDate":"0","branchCode":"6522","division":"ABS","chargesDue":"0","commitmentInterest":"0","clearingCode":"630018","creditInterestDue":"0","debitInterestDue":"0","daylightExpryDate":"0","daylightLimit":"0","fullCrTrckngInd":"N","guarnteeAmtReserved":"0","accountHolds":[{"accountHold":"GET-PSTADD"},{"accountHold":"HIGH RISK"},{"accountHold":"SEC:NONE"},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null}],"markedCheqsAmt":"0","clientFullName":"SNIFFELS (PTY) LTD","ncaAgreemntInd":"N","newStmtFreq":"0","offlnAuthAmt":"0","postDatedTran":"0","penaltyInt":"0","returnedCheques":"0","specialName":null,"nxtStmntDate":"99999999","stmntFreq":"1","unclearedCheqs":"0","wapHold":null,"accntCloseDate":"20200408","closeReason":"0","accountDomicleBrch":"6522","accountDomicleDiv":"ABS","statementImageInd":"N","negotiatedCheqAmt":"0","newNxtStmntDate":"0","openDate":"20191011","openReason":"99","prefStmntInd":"N","stmntReleaseInd":"P","stmntReqdInd":"Y","unilatrlLimitIncrease":"N","accountInactiveInd":null,"businessUnit":"1","onedaypaafInd":null,"onedaypaafTot":"0","bomSponsoredAmt":"0","digitalChannel":"ESPB","empowermentFund":null,"rconStmntFreq":"1","rconNxtStmntDate":"20191111"}},{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO006","echoKey":null},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null},{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}]},"cqh455o":{"accountNo":"4050797102","availBal":"0","accountStatus":"1","authHoldAmt":"0","accountType":"26","accountBalance":"-5427717.04","overdraftExists":"Y","overdraftType":"1","overdraftLimit":"5000000","dateOvrdrftArrngd":"20150513","ovrdrftExpryDate":"99999999","branchCode":"8788","division":"ABS","chargesDue":"0","commitmentInterest":"0","clearingCode":"631145","creditInterestDue":"0","debitInterestDue":"-5279.01","daylightExpryDate":"0","daylightLimit":"0","fullCrTrckngInd":"N","guarnteeAmtReserved":"0","accountHolds":[{"accountHold":"GET-PSTADD"},{"accountHold":"INSOL/LIQU"},{"accountHold":"SIGN-HELD"},{"accountHold":"BAD-DEBT"},{"accountHold":"HIGH RISK"},{"accountHold":"CASH-FOCUS"},{"accountHold":"LIMITS/GRP"},{"accountHold":"INS"},{"accountHold":"BDH"},{"accountHold":"SEC:NONE"},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null},{"accountHold":null}],"markedCheqsAmt":"0","clientFullName":"SNIFFELS (PTY) LTD","ncaAgreemntInd":"N","newStmtFreq":"0","offlnAuthAmt":"0","postDatedTran":"0","penaltyInt":"-35.15","returnedCheques":"0","specialName":null,"nxtStmntDate":"20201027","stmntFreq":"1","unclearedCheqs":"0","wapHold":null,"accntCloseDate":"0","closeReason":"0","accountDomicleBrch":"0","accountDomicleDiv":null,"statementImageInd":"N","negotiatedCheqAmt":"0","newNxtStmntDate":"0","openDate":"19990827","openReason":"1","prefStmntInd":"N","stmntReleaseInd":"P","stmntReqdInd":"Y","unilatrlLimitIncrease":"N","accountInactiveInd":null,"businessUnit":"1","onedaypaafInd":null,"onedaypaafTot":"0","bomSponsoredAmt":"0","digitalChannel":null,"empowermentFund":null,"rconStmntFreq":"1","rconNxtStmntDate":"20190327"}}]}';

	@isTest
	public static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		system.assertEquals('Cheque Services Orchestration', ChequeServicesOrchestration_IH_v1.INTEGRATION_SERVICE_NAME);
	}

	@isTest
	static void testPositive() {
		// Set mock callout class
		orchestrationTestMock();

		Test.startTest();

		ChequeServicesOrchestration_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(500, responseBean.statusCode);

		Test.stopTest();
	}

	/**
	 * @description testMock
	 * @author Englarmerdge Mongwe| 2021-06-11
	 **/
	public static void orchestrationTestMock() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
	}

	private static ChequeServicesOrchestration_Resp_IB_v1 callHandlerMethod() {
		ChequeServicesOrchestration_Req_IB_v1 dummyBean = ChequeServicesOrchestration_Req_IB_v1.createDummyRequest();
		ChequeServicesOrchestration_Resp_IB_v1 responseBean = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(
			dummyBean.clientcd,
			'Credit Card,Cheque & Overdraft',
			dummyBean.accntnbr,
			dummyBean.siteCode,
			dummyBean.maxret
		);
		return responseBean;
	}
}