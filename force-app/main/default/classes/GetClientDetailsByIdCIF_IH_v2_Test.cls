/**
 * @description       : GetClientDetailsByIdCIF_IH_v2 test class
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-31
 * @last modified by  : PaulJohn.duRand@absa.africa
**/
@isTest
public class GetClientDetailsByIdCIF_IH_v2_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"CIgetClientDetailsByIDNOV2Response":{"cip008o":{"lastSearchPos":"019308295015083DRANDPD001","nbrEntsRetrieved":1,"tblEntry":[{"cifKey":"DRANDPD001","cifInitials":"PJ","cifSurname":"DU RANDT","cifTitleCode":1,"cifClntType":101,"cifClntGroup":"I","cifNbrOfAccts":35,"cifBirthDate":19930829,"cifAddrLine1":"2 TEST STREET","cifAddrLine2":null,"cifPostlSuburb":"ALBERTSDAL","cifPostlTown":"ALBERTON","cifPostlCodeRsa":1448,"cifCorpCode":"A"}]},"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001","version":null},"nbsmsgo":{"nbrUserErrs":0,"nbrUserMsgs":0,"sysErrTxt":null,"version":null}}}';

    @TestSetup
    static void setup() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ GetClientDetailsByIdCIF_IH_v2.INTEGRATION_SERVICE_NAME }
        );
    }

    @isTest
    static void testPositive() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        GetClientDetailsByIdCIF_Req_IB_v2 request = new GetClientDetailsByIdCIF_Req_IB_v2();
        request.CIgetClientDetailsByIDNOV2 = request.getNewInstance();
        request.CIgetClientDetailsByIDNOV2.cip008i.idNbr = '93081541515';
        request.CIgetClientDetailsByIDNOV2.cip008i.inpIdDocType = '01';
        request.CIgetClientDetailsByIDNOV2.cip008i.inpCifClntGroup = 'I';
        request.CIgetClientDetailsByIDNOV2.cip008i.inpCifClntType = '101';
        request.CIgetClientDetailsByIDNOV2.cip008i.siteCode = '8136';
        GetClientDetailsByIdCIF_Resp_IB_v2 responseBean = GetClientDetailsByIdCIF_IH_v2.GetCIFCodebyId(request.CIgetClientDetailsByIDNOV2.cip008i);
        System.assert(responseBean.CIgetClientDetailsByIDNOV2Response.cip008o.tblEntry.size() > 0, 'Service failed');
        Test.stopTest();
    }
}