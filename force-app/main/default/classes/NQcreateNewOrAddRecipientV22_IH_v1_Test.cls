/**
* NofiyMe service class test (NotifyMe integration flow)
*  @author Satya Boyenepalli
* @since  01/12/2020
**/
@isTest
public class NQcreateNewOrAddRecipientV22_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"NQcreateNewOrAddRecipientV2Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo":{"version":"MSGO003","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"NQSMGC01","msgCode":"9002","msgErrInd":"E","msgTxt":"The details are already recorded."}},"nqp906o":{"rcode":"9002","pnsRecipientIdO":"1"}}}';
    
  
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{NQcreateneworaddrecipientv22_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive_NQcreateNewOrAddRecipientV2() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        NQcreateneworaddrecipientv22_Resp_IB_v1 responseBean = callHandlerMethod();
       /*  System.Debug('response:'+responseBean); */
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static NQcreateneworaddrecipientv22_Resp_IB_v1 callHandlerMethod() {
        NQcreateneworaddrecipientv22_Req_IB_v1 dummyBean = NQcreateneworaddrecipientv22_Req_IB_v1.CreateDummyBean();
        NQcreateneworaddrecipientv22_Resp_IB_v1 responseBean = NQcreateneworaddrecipientv22_IH_v1.Nqcreateneworaddrecipientv2(dummyBean);
        return responseBean;
    }    
    
}