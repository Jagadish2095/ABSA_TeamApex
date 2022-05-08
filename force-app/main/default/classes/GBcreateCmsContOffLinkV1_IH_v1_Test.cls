/*
 * Test Integration Handler for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

@isTest
public class GBcreateCmsContOffLinkV1_IH_v1_Test {
   @isTest static void validateGBcreateCmsContOffLinkV1Positive() {
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i ;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });

        Test.startTest();
        
        Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1(dummyBean.clientCode,dummyBean.branchCode,dummyBean.bankingSector,dummyBean.indvGroup,dummyBean.contOffType,dummyBean.contOffNum,dummyBean.capByEmployee,dummyBean.appByEmployee,dummyBean.overallControl,dummyBean.businessSeg,dummyBean.businessSubSeg,dummyBean.franchisorCode) ;

		// Get first key from the map
		GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        
        System.assertEquals(200, responseBean.statusCode);
        responseBean.dummyResponse();
        Test.stopTest();
    }
      
     @isTest static void validateGBcreateCmsContOffLinkV1Negative() {
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.Negative_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });

        Test.startTest();
        
        Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1(dummyBean.clientCode,dummyBean.branchCode,dummyBean.bankingSector,dummyBean.indvGroup,dummyBean.contOffType,dummyBean.contOffNum,dummyBean.capByEmployee,dummyBean.appByEmployee,dummyBean.overallControl,dummyBean.businessSeg,dummyBean.businessSubSeg,dummyBean.franchisorCode) ;
		// Get first key from the map
		GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
      
     @isTest static void validateGBcreateCmsContOffLinkV1NoIntegrationSettings() {
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;

        

        Test.startTest();
        
        Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1(dummyBean.clientCode,dummyBean.branchCode,dummyBean.bankingSector,dummyBean.indvGroup,dummyBean.contOffType,dummyBean.contOffNum,dummyBean.capByEmployee,dummyBean.appByEmployee,dummyBean.overallControl,dummyBean.businessSeg,dummyBean.businessSubSeg,dummyBean.franchisorCode) ;
		// Get first key from the map
		GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
    }
        
     @isTest static void validateGBcreateCmsContOffLinkV1Exception() {
        GBcreateCmsContOffLinkV1_Req_IB_v1 dummyBeanParent = GBcreateCmsContOffLinkV1_Req_IB_v1.createDummyRequest();
        GBcreateCmsContOffLinkV1_Req_IB_v1.Gsp020i dummyBean = dummyBeanParent.GBcreateCmsContOffLinkV1.Gsp020i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new GBcreateCmsContOffLinkV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1
        });

        Test.startTest();
        
        Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1(dummyBean.clientCode,dummyBean.branchCode,dummyBean.bankingSector,dummyBean.indvGroup,dummyBean.contOffType,dummyBean.contOffNum,dummyBean.capByEmployee,dummyBean.appByEmployee,dummyBean.overallControl,dummyBean.businessSeg,dummyBean.businessSubSeg,dummyBean.franchisorCode) ;
		// Get first key from the map
		GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
        
        Test.stopTest();
        
    }

}