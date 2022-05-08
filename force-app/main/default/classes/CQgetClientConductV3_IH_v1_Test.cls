/**
 * Integration Handler for CQgetClientConductV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020-08-06
 */

@isTest
public class CQgetClientConductV3_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"CQgetClientConductV3Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO002","echoKey":null},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0"},"cqh482o":{"accountNbrOut":"4048017641","clientName":"MISS D ZUMA","divisionCode":"ABS","branch":"8198","accountType":"48","accountName":"MAHE","dateOpened":"20180702","clientType":"101","clientOccupation":"6","segcode":"LOS","accountStatusCode":"1","currentBalance":"+000000001068816.34","availableBalance":"+000000001068766.34","unclearedEffects":"+000000000000000.00","excessAmount":"+000000000000000.00","markedCheque":"+000000000000000.00","authHolds":"+000000000000000.00","authOffline":"+000000000000000.00","negCheqs":"+000000000000000.00","pdatedAmount":"+000000000000000.00","returnedCheque":"+000000000000000.00","guaranteedReserve":"0","odDeclined":"N","maxlimit":"+000000000000000.00","overdraftType":null,"overdraftLimit":"+000000000000000.00","overdraftExpiryDate":"0","reducibleAmt":"+000000000000000.00","fct":"N","paymentDate":"0","hldd":[{"hlddOut":"HIGH RISK"},{"hlddOut":null},{"hlddOut":"SEC:NONE"},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null},{"hlddOut":null}],"nca":"N","unilatIncr":"N","rdCurrent":"0","rdPrev":"0","rdDaysCurrent":"0","rdDays12":"0","unauthOd12":"0","dateLastRd":"0","lastCreditAmnt":"500000","lastCreditDate":"20200730","lastDebitAmnt":"-2","lastDebitDate":"20200805","toYrBeforeLast":"1000620","lastWithinLmtDate":"20200805","toCurrentYr":"500001","toPreviousYr":"1655","highBalCurr":"1069667","highBalPrevious":"978026","lowBalCurr":"569670","lowBalPrevious":"976225","debitIntCurr":"0","debitIntPrevious":"0","creditIntCurr":"0","creditIntPrevious":"0","chargesCurr":"5386","chargesPrev":"-231.82","incomingUnpdsCurr":"0","incomingUnpdsVcurr":"0","rocqDetail":[{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"},{"nbrUnpds":"0","valueUnpds":"0"}],"nbrRdCurr":"0","rdcqDetail":[{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"},{"nbrRd":"0"}],"onedaypaafTot":"0","defaultedOd":null,"bomSponsoredAmt":"0"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQgetClientConductV3_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        conductTestMock();

        Test.startTest();

        CQgetClientConductV3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void conductTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static CQgetClientConductV3_Resp_IB_v1 callHandlerMethod() {
        CQgetClientConductV3_Req_IB_v1 dummyBeanParent = CQgetClientConductV3_Req_IB_v1.createDummyRequest();
        CQgetClientConductV3_Req_IB_v1.Cqh482i dummyBean = dummyBeanParent.CQgetClientConductV3.cqh482i;
        CQgetClientConductV3_Resp_IB_v1 responseBean = CQgetClientConductV3_IH_v1.CQgetClientConductV3(dummyBean.accountNbr, dummyBean.branchCode, dummyBean.branchSiteType, dummyBean.tellerCode, dummyBean.siteTypeAgency, dummyBean.supervisorCode, dummyBean.agencyCode, dummyBean.corpCode);
        return responseBean;
    }
}