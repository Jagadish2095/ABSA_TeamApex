/*
 * Test Integration Handler for nQcreateNewOrAddRecipientV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-04-17
 */   

@isTest
public class nQcreateNewOrAddRecipientV2_IH_v2_Test {
	@isTest static void validatenQcreateNewOrAddRecipientV2Positive() {
        nQcreateNewOrAddRecipientV2_Req_IB_v2 dummyBeanParent = nQcreateNewOrAddRecipientV2_Req_IB_v2.createDummyRequest();
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nqp906i dummyBean = dummyBeanParent.NQcreateNewOrAddRecipientV2.Nqp906i;
        
        nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = new nQcreateNewOrAddRecipientV2_Resp_IB_v2();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqcreateneworaddrecipientv2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqcreateneworaddrecipientv2_STRING
        });

        Test.startTest();
        
        Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQcreateNewOrAddRecipientV2_IH_v2.nQcreateNewOrAddRecipientV2(dummyBean.keyFields.cif, dummyBean.keyFields.acn, dummyBean.registeringSite, dummyBean.teller, dummyBean.sbuCd, dummyBean.recipientData.recipNm, dummyBean.recipientData.contactPref, dummyBean.recipientData.lng, dummyBean.recipientData.email, dummyBean.recipientData.cellPhone, dummyBean.recipientAcnData.prodArea, true, true, false, false, false,false,false, dummyBean.recipientAcnData.transmitWindow, 'daily', '200');
		// Get first key from the map
		responseBean = (new List<nQcreateNewOrAddRecipientV2_Resp_IB_v2>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validatenQcreateNewOrAddRecipientV2NoIntegrationSettings() {
        nQcreateNewOrAddRecipientV2_Req_IB_v2 dummyBeanParent = nQcreateNewOrAddRecipientV2_Req_IB_v2.createDummyRequest();
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nqp906i dummyBean = dummyBeanParent.NQcreateNewOrAddRecipientV2.Nqp906i;
       
        Test.startTest();
        
        Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQcreateNewOrAddRecipientV2_IH_v2.nQcreateNewOrAddRecipientV2(dummyBean.keyFields.cif, dummyBean.keyFields.acn, dummyBean.registeringSite, dummyBean.teller, dummyBean.sbuCd, dummyBean.recipientData.recipNm, dummyBean.recipientData.contactPref, dummyBean.recipientData.lng, dummyBean.recipientData.email, dummyBean.recipientData.cellPhone, dummyBean.recipientAcnData.prodArea, true, true, false, false, false,false,false, dummyBean.recipientAcnData.transmitWindow, 'daily', '200');
		// Get first key from the map
		nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = (new List<nQcreateNewOrAddRecipientV2_Resp_IB_v2>(responseMap.keySet()))[0];
        System.assertNotEquals(null, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validatesMgetAsvSuretyshipsV1Exception() {
        nQcreateNewOrAddRecipientV2_Req_IB_v2 dummyBeanParent = nQcreateNewOrAddRecipientV2_Req_IB_v2.createDummyRequest();
        nQcreateNewOrAddRecipientV2_Req_IB_v2.Nqp906i dummyBean = dummyBeanParent.NQcreateNewOrAddRecipientV2.Nqp906i;

         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqcreateneworaddrecipientv2_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqcreateneworaddrecipientv2_STRING
        });

       Test.startTest();
        
        Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQcreateNewOrAddRecipientV2_IH_v2.nQcreateNewOrAddRecipientV2(dummyBean.keyFields.cif, dummyBean.keyFields.acn, dummyBean.registeringSite, dummyBean.teller, dummyBean.sbuCd, dummyBean.recipientData.recipNm, dummyBean.recipientData.contactPref, dummyBean.recipientData.lng, dummyBean.recipientData.email, dummyBean.recipientData.cellPhone, dummyBean.recipientAcnData.prodArea, true, true, false, false, false,false,false, dummyBean.recipientAcnData.transmitWindow, 'daily', '200');
		// Get first key from the map
		nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean = (new List<nQcreateNewOrAddRecipientV2_Resp_IB_v2>(responseMap.keySet()))[0];
        System.assertNotEquals(null, responseBean.statusCode);
        
        Test.stopTest();
    }
}