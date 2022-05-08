/*
* Test Integration Handler for ABFgetBasicDetailsV2 Service 
* @author Gulafsha
* @created 2021-02-15
*/

@isTest
public class CIgetRelationshipsV1_IH_v1Test {

    
      public static final String POSITIVE_RESPONSE_BODY = '{"CIgetRelationshipsV1Response": {"cib128o": {"clientKey": "SBSOUTP001","clientName": "SEDERKRANS BOERDERY SOUTPANSBERG BK","noRecordCnt": 3,"relDetails": [{"dateCreated": 20191107,"relatedAcno": "0000000000000000000","relativeClientIdNo": 199605498423,"relativeClientIdTp": 5,"relativeClientKey": "MBBK   249","relativeClientName": "MAMANGONI BOERDERY BK","relativeRelaCode": 721,"relativeRelaCodeDs": "PRIMARY CLIENT","sourceRelaCode": 390,"sourceRelaCodeDesc": "GROUP MEMBER"},{"dateCreated": 20210127,"relatedAcno": "0000000000000000000","relativeClientIdNo": 191600015706,"relativeClientIdTp": 5,"relativeClientKey": "DBSOUTH001","relativeClientName": "DEVELOPMENT BANK OF SOUTH AFRICA","relativeRelaCode": 900,"relativeRelaCodeDs": "ENTERPRISE DEVEL","sourceRelaCode": 910,"sourceRelaCodeDesc": "S &amp; M ENTERPRISE"},{"dateCreated": 20210127,"relatedAcno": "0000000000000000000","relativeClientIdNo": 295400242507,"relativeClientIdTp": 5,"relativeClientKey": "TSAFRIC048","relativeClientName": "TOTAL SOUTH AFRICA (PTY) LTD","relativeRelaCode": 900,"relativeRelaCodeDs": "ENTERPRISE DEVEL","sourceRelaCode": 910,"sourceRelaCodeDesc": "S &amp; M ENTERPRISE"}], "restartKey": "SBSOUTP001N910900                   TSAFRIC048"},"nbsapdpo": {"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO001"},"nbsmsgo3": {"nbrUserErrs": 0,"nbrUserMsgs": 0}}}';

 @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{'CIgetRelationshipsV1'});
    }
 
     @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        CIgetRelationshipsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static CIgetRelationshipsV1_Resp_IB_v1 callHandlerMethod() {
        CIgetRelationshipsV1_Req_IB_v1 dummyBean = CIgetRelationshipsV1_Req_IB_v1.createDummyRequest();
        CIgetRelationshipsV1_Resp_IB_v1 responseBean = CIgetRelationshipsV1_IH_v1.CIgetRelationshipsV1(dummyBean);
        return responseBean;
    }

    
    
}