/*
 * Test Integration Handler for NQlistRecipientsRegisteredForCustV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-18
 */

@isTest
public class nQlistRecipientsRegisteredV1_IH_v1_Test {
   
 @isTest static void validatesNQlistRecipientsRegisteredForCustV1Positive() {
        nQlistRecipientsRegisteredV1_Req_IB_v1 dummyBeanParent = nQlistRecipientsRegisteredV1_Req_IB_v1.createDummyRequest();
        nQlistRecipientsRegisteredV1_Req_IB_v1.Nqp904i dummyBean = dummyBeanParent.NQlistRecipientsRegisteredForCustV1.nqp904i;
      
        Test.setMock(HttpCalloutMock.class, new EImaintainESDDetailsV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING
        });

        Test.startTest();
        
        Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQlistRecipientsRegisteredV1_IH_v1.getRecipientsRegisteredDetails(dummyBean.cif, dummyBean.registeringSite);
		// Get first key from the map
		nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean = (new List<nQlistRecipientsRegisteredV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
   
     @isTest static void validatesMgetAsvSuretyshipsV1NoIntegrationSettings() {
         
       nQlistRecipientsRegisteredV1_Req_IB_v1 dummyBeanParent = nQlistRecipientsRegisteredV1_Req_IB_v1.createDummyRequest();
       nQlistRecipientsRegisteredV1_Req_IB_v1.Nqp904i dummyBean = dummyBeanParent.NQlistRecipientsRegisteredForCustV1.nqp904i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = nQlistRecipientsRegisteredV1_IH_v1.getRecipientsRegisteredDetails(dummyBean.cif, dummyBean.registeringSite);
		// Get first key from the map
		nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean = (new List<nQlistRecipientsRegisteredV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        Test.stopTest();
    }
    
}