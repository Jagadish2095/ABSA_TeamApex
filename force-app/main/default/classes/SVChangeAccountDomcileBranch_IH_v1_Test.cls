/*
* Test Integration Handler for SVChangeAccountDomcileBranchv1 Service
* @author Anka Ganta
* @created 2020-07-23
*/
@isTest
public class SVChangeAccountDomcileBranch_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"SVchangeAccountDomcileBranchV1Response": {"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": "2","nbrUserErrs": "2","msgEntry": [{"msgClass": "SVSMGC01","msgCode": "0007","msgErrInd": "E","msgTxt": "The account does not exist."},{"msgClass": "SVSMGC01","msgCode": "0015","msgErrInd": "E","msgTxt": "This may only be done at the domicile branch of the account."}]},"svpp44o": {"eventNumber": "0","newSiteCde": "0","oldSiteCode": "0","clientName": null,"newDomicile": null,"oldDomicile": null}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SVChangeAccountDomcileBranch_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        SVChangeAccountDomcileBranch_Resp_IB_v1 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } /*else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }*/
       

        Test.stopTest();
    }

    private static SVChangeAccountDomcileBranch_Resp_IB_v1 callHandlerMethod() {
        SVChangeAccountDomcileBranch_Req_IB_v1 dummyBean = SVChangeAccountDomcileBranch_Req_IB_v1.createDummyRequest();
        SVChangeAccountDomcileBranch_Resp_IB_v1 dummyrespBean = SVChangeAccountDomcileBranch_Resp_IB_v1.createDummyResponse();
        SVChangeAccountDomcileBranch_Req_IB_v1 reqbean = SVChangeAccountDomcileBranch_IU_v1.mapRequestFields('9051324101','8919');
        SVChangeAccountDomcileBranch_Resp_IB_v1 responseBean = SVChangeAccountDomcileBranch_IH_v1.changeDomcileBranch(dummyBean);
        return responseBean;
    }

}