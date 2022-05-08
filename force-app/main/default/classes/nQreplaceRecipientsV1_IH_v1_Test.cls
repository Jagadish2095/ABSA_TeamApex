/*
 * Test Integration Handler for NQreplaceRecipientsAcrossAllAcntsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-19
 */

@isTest
public class nQreplaceRecipientsV1_IH_v1_Test {
	@isTest static void validatesNQreplaceRecipientsAcrossAllAcntsV1Positive() {
        nQreplaceRecipientsV1_Req_v1 dummyBeanParent = nQreplaceRecipientsV1_Req_v1.createDummyRequest();
        nQreplaceRecipientsV1_Req_v1.Nqp096i dummyBean = dummyBeanParent.NQreplaceRecipientsAcrossAllAcntsV1.Nqp096i;
       
        Test.setMock(HttpCalloutMock.class, new nQreplaceRecipientsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING
        });

        Test.startTest();
                                                                                                                 
        Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>> responseMap = nQreplaceRecipientsV1_IH_v1.updateRecipients(dummyBean.cif, dummyBean.registeringSite , dummyBean.recipNm, dummyBean.contactPref, dummyBean.lng, dummyBean.email, dummyBean.cellphone);
		// Get first key from the map
		nQreplaceRecipientsV1_Resp_v1 responseBean = (new List<nQreplaceRecipientsV1_Resp_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
     
     

     @isTest static void validatesNQreplaceRecipientsAcrossAllAcntsV1NoIntegrationSettings() {
        nQreplaceRecipientsV1_Req_v1 dummyBeanParent = nQreplaceRecipientsV1_Req_v1.createDummyRequest();
        nQreplaceRecipientsV1_Req_v1.Nqp096i dummyBean = dummyBeanParent.NQreplaceRecipientsAcrossAllAcntsV1.Nqp096i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
       Test.startTest();
        
        Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>> responseMap = nQreplaceRecipientsV1_IH_v1.updateRecipients(dummyBean.cif, dummyBean.registeringSite , dummyBean.recipNm, dummyBean.contactPref, dummyBean.lng, dummyBean.email, dummyBean.cellphone);
		// Get first key from the map
		nQreplaceRecipientsV1_Resp_v1 responseBean = (new List<nQreplaceRecipientsV1_Resp_v1>(responseMap.keySet()))[0];
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
}