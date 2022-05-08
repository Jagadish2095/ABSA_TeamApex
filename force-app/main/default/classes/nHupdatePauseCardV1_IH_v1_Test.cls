/*
 * Test Integration Handler for NHupdatePauseCardV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-23
 */

@isTest
public class nHupdatePauseCardV1_IH_v1_Test {
	@isTest static void validateNHupdatePauseCardV1Positive() {

        nHupdatePauseCardV1_Req_IB_v1 dummyBeanParent = nHupdatePauseCardV1_Req_IB_v1.createDummyRequest();
        nHupdatePauseCardV1_Req_IB_v1.Nhs141i dummyBean = dummyBeanParent.NHupdatePauseCardV1.Nhs141i;
        
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nHupdatePauseCardV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NHUPDATEPAUSECARDV1_STRING
        });

        Test.startTest();
        Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHupdatePauseCardV1_IH_v1.nHupdatePauseardv1(dummyBean.accessNumber, dummyBean.tellerCode, dummyBean.supervisor, dummyBean.branchCode, dummyBean.pauseHold, dummyBean.iatmHold, dummyBean.iposHold, dummyBean.latmHold,dummyBean.lposHold ,dummyBean.cnpHold, dummyBean.digwHold, dummyBean.pauseDate, dummyBean.language, dummyBean.action, dummyBean.cardNbr);
		nHupdatePauseCardV1_Resp_IB_v1 responseBean = (new List<nHupdatePauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateNHenquiryPauseCardV1NoIntegrationSettings() {

       	nHupdatePauseCardV1_Req_IB_v1 dummyBeanParent = nHupdatePauseCardV1_Req_IB_v1.createDummyRequest();
        nHupdatePauseCardV1_Req_IB_v1.Nhs141i dummyBean = dummyBeanParent.NHupdatePauseCardV1.Nhs141i;
        
        Test.startTest();
        
        Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nHupdatePauseCardV1_IH_v1.nHupdatePauseardv1(dummyBean.accessNumber, dummyBean.tellerCode, dummyBean.supervisor, dummyBean.branchCode, dummyBean.pauseHold, dummyBean.iatmHold, dummyBean.iposHold, dummyBean.latmHold,dummyBean.lposHold ,dummyBean.cnpHold, dummyBean.digwHold, dummyBean.pauseDate, dummyBean.language, dummyBean.action, dummyBean.cardNbr);
		nHupdatePauseCardV1_Resp_IB_v1 responseBean = (new List<nHupdatePauseCardV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        Test.stopTest();
    }
}