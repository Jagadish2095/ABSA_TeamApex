/*
 * Test Integration Handler for nQupdateNotificationsV1_IH_V2 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-04-16
 */   

@isTest
public class nQupdateNotificationsV1_IH_V2_Test {
	@isTest static void validatenQupdateNotificationsV1Positive() {
        nQupdateNotificationsV1_Req_IB_v2 dummyBeanParent = nQupdateNotificationsV1_Req_IB_v2.createDummyBean();
       
        nQupdateNotificationsV1_Req_IB_v2.Nqp204i dummyBean =  dummyBeanParent.NQupdJVProdNotificationAcctSettingsV1.nqp204i;
        
        nQupdateNotificationsV1_Resp_IB_v2 responseBean = new nQupdateNotificationsV1_Resp_IB_v2();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqupdatenotificationsv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqupdatenotificationsv1_STRING
        });      

        Test.startTest();
        
        Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQupdateNotificationsV1_IH_V2.nQupdateNotificationsV1(dummyBean.cif, dummyBean.accountNumber, dummyBean.registeringSite, dummyBean.teller , dummyBean.prodArea, true, true, false, false, false,false,false, dummyBean.transmitWindow, 'daily', '200');
		// Get first key from the map
		responseBean = (new List<nQupdateNotificationsV1_Resp_IB_v2>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validatenQupdateNotificationsV1NoIntegrationSettings() {
        nQupdateNotificationsV1_Req_IB_v2 dummyBeanParent = nQupdateNotificationsV1_Req_IB_v2.createDummyBean();
       
        nQupdateNotificationsV1_Req_IB_v2.Nqp204i dummyBean =  dummyBeanParent.NQupdJVProdNotificationAcctSettingsV1.nqp204i;
        
        nQupdateNotificationsV1_Resp_IB_v2 responseBean = new nQupdateNotificationsV1_Resp_IB_v2();
        
       Test.startTest();
        
        Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQupdateNotificationsV1_IH_V2.nQupdateNotificationsV1(dummyBean.cif, dummyBean.accountNumber, dummyBean.registeringSite, dummyBean.teller , dummyBean.prodArea, true, true, false, false, false,false,false, dummyBean.transmitWindow, 'daily', '200');
		// Get first key from the map
		responseBean = (new List<nQupdateNotificationsV1_Resp_IB_v2>(responseMap.keySet()))[0];
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validatenQupdateNotificationsV1Exception() {
       nQupdateNotificationsV1_Req_IB_v2 dummyBeanParent = nQupdateNotificationsV1_Req_IB_v2.createDummyBean();
       
        nQupdateNotificationsV1_Req_IB_v2.Nqp204i dummyBean =  dummyBeanParent.NQupdJVProdNotificationAcctSettingsV1.nqp204i;
        
        nQupdateNotificationsV1_Resp_IB_v2 responseBean = new nQupdateNotificationsV1_Resp_IB_v2();
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqupdatenotificationsv1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqupdatenotificationsv1_STRING
        });

        Test.startTest();
        
        Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = nQupdateNotificationsV1_IH_V2.nQupdateNotificationsV1(dummyBean.cif, dummyBean.accountNumber, dummyBean.registeringSite, dummyBean.teller , dummyBean.prodArea, true, true, false, false, false,false,false, dummyBean.transmitWindow, 'daily', '200');
		// Get first key from the map
		responseBean = (new List<nQupdateNotificationsV1_Resp_IB_v2>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}