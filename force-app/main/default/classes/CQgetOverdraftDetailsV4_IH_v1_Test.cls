/**
 * Integration Handler for CQgetOverdraftDetailsV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-07-28
 */

@isTest
public class CQgetOverdraftDetailsV4_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"CQgetOverdraftDetailsV4Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO003","echoKey":null},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0"},"cqh478o":{"accountNbrOut":"4050797102","accountType":"26","clientName":"SNIFFELS (PTY) LTD","accountName":null,"bankCode":"ABS","branchCode":"8788","accountStatus":"1","overdraftType":"1","effectiveDate":"20150513","reviewDate":"20160513","expiryDate":"99999999","expiryDateA":null,"currentOverdraftLimit":"5000000","daylightLimit":"0","daylightLimitA":null,"daylightExpiryDate":"0","daylightExpiryDateA":null,"tellerNumber":"999999","originalOdAmount":"10400","originalOdAmountA":"H","currentLimitExpDate":"0","currentLimitExpDteA":"H","reductionAttribute":"H","reductionAmount":"0","reductionAmountFreq":null,"reductionStartDate":"0","reduction1timeAmount":"0","reduction1timeEffDte":"0","enforcedReducingLimit":null,"revLoanAttribute":"H","revLoanPayStruct":null,"revLoanAmount":"0","revLoanPayFrequency":null,"revLoanPaymentMethod":null,"revLoanPayDay":"0","revLoanPayDueDate":"0","revLoanNumExtensions":"0","revLoanExtEffDte":"0","revLoanNrTimeInArr":"0","revLoanArrearsAmount":"0","defaultedOd":null,"variableAttribute":"H","variableTableCounter":"0"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CQgetOverdraftDetailsV4_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        overdraftTestMock();

        Test.startTest();

        CQgetOverdraftDetailsV4_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void overdraftTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static CQgetOverdraftDetailsV4_Resp_IB_v1 callHandlerMethod() {
        CQgetOverdraftDetailsV4_Req_IB_v1 dummyBeanParent = CQgetOverdraftDetailsV4_Req_IB_v1.createDummyRequest();
        CQgetOverdraftDetailsV4_Req_IB_v1.Cqh478i dummyBean = dummyBeanParent.CQgetOverdraftDetailsV4.cqh478i;
        CQgetOverdraftDetailsV4_Resp_IB_v1 responseBean = CQgetOverdraftDetailsV4_IH_v1.CQgetOverdraftDetailsV4(dummyBean.accountNbr, dummyBean.processingSite, dummyBean.processingSiteType, dummyBean.tellerNbr, dummyBean.agencyCode, dummyBean.agencyType, dummyBean.controllerNbr, dummyBean.corpCode);
        return responseBean;
    }
}