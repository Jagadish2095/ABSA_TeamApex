/*
 * Test Integration Handler for EImaintainESDDetailsV3 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-04-07
 */

@isTest
public class EImaintainESDDetailsV3_IH_v1_Test {
     @isTest static void validatesEImaintainESDDetailsV3Positive() {
        EImaintainESDDetailsV3_Req_IB_v1 dummyBeanParent = EImaintainESDDetailsV3_Req_IB_v1.createDummyRequest();
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i dummyBean = dummyBeanParent.EImaintainESDDetailsV3.Eip103i;
         
        EImaintainESDDetailsV3_Resp_IB_v1  eImaintainESDDetailsV3_Resp_IB_v1 = new EImaintainESDDetailsV3_Resp_IB_v1();
         
        Test.setMock(HttpCalloutMock.class, new EImaintainESDDetailsV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.EI_maintain_ESD_DetailsV3
        });

        Test.startTest();
        
        Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(dummyBean.request, dummyBean.site, dummyBean.teller, dummyBean.acn, dummyBean.product, 'muvhuso.nekhubvi@absa.africa');
		// Get first key from the map
		EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (new List<EImaintainESDDetailsV3_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesEImaintainESDDetailsV3Negative() {
        EImaintainESDDetailsV3_Req_IB_v1 dummyBeanParent = EImaintainESDDetailsV3_Req_IB_v1.createDummyRequest();
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i dummyBean = dummyBeanParent.EImaintainESDDetailsV3.Eip103i;

        // Set mock callout class
       Test.setMock(HttpCalloutMock.class, new EImaintainESDDetailsV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.EI_maintain_ESD_DetailsV3
        });

       Test.startTest();
        
        Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(dummyBean.request, dummyBean.site, dummyBean.teller, dummyBean.acn, dummyBean.product, 'muvhuso.nekhubvi@absa.africa');
		// Get first key from the map
		EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (new List<EImaintainESDDetailsV3_Resp_IB_v1>(responseMap.keySet()))[0];
       
        Test.stopTest();
    }

     @isTest static void validatesEImaintainESDDetailsV3NoIntegrationSettings() {
        EImaintainESDDetailsV3_Req_IB_v1 dummyBeanParent = EImaintainESDDetailsV3_Req_IB_v1.createDummyRequest();
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i dummyBean = dummyBeanParent.EImaintainESDDetailsV3.Eip103i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
       Test.startTest();
        
        Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(dummyBean.request, dummyBean.site, dummyBean.teller, dummyBean.acn, dummyBean.product, 'muvhuso.nekhubvi@absa.africa');
		// Get first key from the map
		EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (new List<EImaintainESDDetailsV3_Resp_IB_v1>(responseMap.keySet()))[0];
       
        Test.stopTest();
    }

     @isTest static void validatesEImaintainESDDetailsV3Exception() {
        EImaintainESDDetailsV3_Req_IB_v1 dummyBeanParent = EImaintainESDDetailsV3_Req_IB_v1.createDummyRequest();
        EImaintainESDDetailsV3_Req_IB_v1.Eip103i dummyBean = dummyBeanParent.EImaintainESDDetailsV3.Eip103i;
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new EImaintainESDDetailsV3_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.EI_maintain_ESD_DetailsV3
        });

       Test.startTest();
        
        Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(dummyBean.request, dummyBean.site, dummyBean.teller, dummyBean.acn, dummyBean.product, 'muvhuso.nekhubvi@absa.africa');
		// Get first key from the map
		EImaintainESDDetailsV3_Resp_IB_v1 responseBean = (new List<EImaintainESDDetailsV3_Resp_IB_v1>(responseMap.keySet()))[0];
        //System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}