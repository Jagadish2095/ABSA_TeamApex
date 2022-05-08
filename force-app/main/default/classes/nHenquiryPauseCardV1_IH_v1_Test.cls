/*
 * Test Integration Handler for NHenquiryPauseCardV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-23
 */

@isTest
public class nHenquiryPauseCardV1_IH_v1_Test {
	@isTest static void validateNHenquiryPauseCardV1Positive() {

        nHenquiryPauseCardV1_Req_IB_v1 dummyBeanParent = nHenquiryPauseCardV1_Req_IB_v1.createDummyRequest();
        nHenquiryPauseCardV1_Req_IB_v1.Nhs142i dummyBean = dummyBeanParent.NHenquiryPauseCardV1.Nhs142i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nHenquiryPauseCardV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NHENQUIRYPAUSECARDV1_STRING
        });

        Test.startTest();
        
        Map<nHenquiryPauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHenquiryPauseCardV1_IH_v1.getNHenquiryPauseCardV1(dummyBean.accessNumber,dummyBean.language, dummyBean.action, dummyBean.cardNbr);
		nHenquiryPauseCardV1_Resp_IB_v1 responseBean = (new List<nHenquiryPauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateNHenquiryPauseCardV1NoIntegrationSettings() {

       	nHenquiryPauseCardV1_Req_IB_v1 dummyBeanParent = nHenquiryPauseCardV1_Req_IB_v1.createDummyRequest();
        nHenquiryPauseCardV1_Req_IB_v1.Nhs142i dummyBean = dummyBeanParent.NHenquiryPauseCardV1.Nhs142i;
        
        Test.startTest();
        
        Map<nHenquiryPauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHenquiryPauseCardV1_IH_v1.getNHenquiryPauseCardV1(dummyBean.accessNumber,dummyBean.language, dummyBean.action, dummyBean.cardNbr);
		nHenquiryPauseCardV1_Resp_IB_v1 responseBean = (new List<nHenquiryPauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        Test.stopTest();
    }
}