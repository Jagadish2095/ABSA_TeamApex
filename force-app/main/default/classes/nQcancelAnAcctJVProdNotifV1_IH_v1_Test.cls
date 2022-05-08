/*
 * Test Integration Handler for nQcancelAnAcctJVProdNotifV1_IH_v1 Service
 * @author Srikanth N
 * @created 2020-03-22
 */   

@isTest
public class nQcancelAnAcctJVProdNotifV1_IH_v1_Test {
	@isTest static void validatenQcancelAnAcctJVProdNotifV1Positive() {
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1 dummyBeanParent = nQcancelAnAcctJVProdNotifV1_Req_IB_v1.createDummyRequest();
       
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i dummyBean =  dummyBeanParent.NQcancelAnAcctJVProdNotificationV1.Nqp207i;
        
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean = new nQcancelAnAcctJVProdNotifV1_Resp_IB_v1();

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new nqcancelacctnotificationv1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.nqcancelacctnotificationv1_STRING
        });

        Test.startTest();
        
        Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQcancelAnAcctJVProdNotifV1_IH_v1.nQcancelAnAcctJVProdNotificationV1(dummyBean.cif, dummyBean.accountNumber, dummyBean.registeringSite);
		// Get first key from the map
		responseBean = (new List<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validatenQcancelAnAcctJVProdNotifV1NoIntegrationSettings() {
       nQcancelAnAcctJVProdNotifV1_Req_IB_v1 dummyBeanParent = nQcancelAnAcctJVProdNotifV1_Req_IB_v1.createDummyRequest();
       
        nQcancelAnAcctJVProdNotifV1_Req_IB_v1.Nqp207i dummyBean =  dummyBeanParent.NQcancelAnAcctJVProdNotificationV1.Nqp207i;
        
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean = new nQcancelAnAcctJVProdNotifV1_Resp_IB_v1();
        
        Test.startTest();
        
        Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQcancelAnAcctJVProdNotifV1_IH_v1.nQcancelAnAcctJVProdNotificationV1(dummyBean.cif, dummyBean.accountNumber, dummyBean.registeringSite);
		// Get first key from the map
		responseBean = (new List<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1>(responseMap.keySet()))[0];
       
        Test.stopTest();
    }
    
    
}