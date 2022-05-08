/**
 * @description       : 
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/
@isTest
public class SMgetASVCessionOfUnitTrustsV1_IH_v1_Test {
  @isTest static void validatesMgetAsvCessionOfSchemesV1Positive() {
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.createDummyRequest();
       
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i dummyBean = dummyBeanParent.SMgetASVCessionOfUnitTrustsV1.smn236i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {'SM Get ASVCessionOfUnitTrusts V1'});

        Test.startTest();
        
        Map<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfUnitTrustsV1_IH_v1.SMgetASVCessionOfUnitTrustsV1(dummyBean.clcd);
        // Get first key from the map
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1Negative() {
       SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.createDummyRequest();
       
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i dummyBean = dummyBeanParent.SMgetASVCessionOfUnitTrustsV1.smn236i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {'SM Get ASVCessionOfUnitTrusts V1'});

        Test.startTest();

        Map<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfUnitTrustsV1_IH_v1.SMgetASVCessionOfUnitTrustsV1(dummyBean.clcd);
        // Get first key from the map
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1NoIntegrationSettings() {
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.createDummyRequest();
       
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i dummyBean = dummyBeanParent.SMgetASVCessionOfUnitTrustsV1.smn236i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfUnitTrustsV1_IH_v1.SMgetASVCessionOfUnitTrustsV1(dummyBean.clcd);
        // Get first key from the map
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }

     @isTest static void validatesMgetAsvCessionOfSchemesV1Exception() {
       SMgetASVCessionOfUnitTrustsV1_Req_IB_v1 dummyBeanParent = SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.createDummyRequest();
       
        SMgetASVCessionOfUnitTrustsV1_Req_IB_v1.smn236i dummyBean = dummyBeanParent.SMgetASVCessionOfUnitTrustsV1.smn236i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new sMgetAsvCessionOfSchemesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {'SM Get ASVCessionOfUnitTrusts V1'});

        Test.startTest();
        
        Map<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SMgetASVCessionOfUnitTrustsV1_IH_v1.SMgetASVCessionOfUnitTrustsV1(dummyBean.clcd);
        // Get first key from the map
        SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1 responseBean = (new List<SMgetASVCessionOfUnitTrustsV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}