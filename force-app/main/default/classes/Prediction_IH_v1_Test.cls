/*
 * Test Integration Handler for Prediction Service
 * @author Muvhuso Nekhubvi
 * @created 2020/06/26
 */

@isTest
public class Prediction_IH_v1_Test {
    @isTest static void validatesPredictionPositive() {
        Prediction_Req_IB_v1 dummyBeanParent = Prediction_Req_IB_v1.createDummyRequest();
        Prediction_Req_IB_v1 dummyBean = dummyBeanParent;

        Test.setMock(HttpCalloutMock.class, new Prediction_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.PREDICTION_STRING
        });

        Test.startTest();

        Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = Prediction_IH_v1.Prediction(dummyBeanParent.caseId,dummyBeanParent.caseNo, dummyBeanParent.status, dummyBeanParent.serviceTypeId, dummyBeanParent.suppliedEmail, dummyBeanParent.subject, dummyBeanParent.description, dummyBeanParent.serviceGroup);
        // Get first key from the map
        Prediction_Resp_IB_v1 responseBean = (new List<Prediction_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }



     @isTest static void validatesPredictionNoIntegrationSettings() {
        Prediction_Req_IB_v1 dummyBeanParent = Prediction_Req_IB_v1.createDummyRequest();
        Prediction_Req_IB_v1 dummyBean = dummyBeanParent;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
       Test.startTest();

        Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = Prediction_IH_v1.Prediction(dummyBeanParent.caseId,dummyBeanParent.caseNo, dummyBeanParent.status, dummyBeanParent.serviceTypeId, dummyBeanParent.suppliedEmail, dummyBeanParent.subject, dummyBeanParent.description, dummyBeanParent.serviceGroup);
        // Get first key from the map
        Prediction_Resp_IB_v1 responseBean = (new List<Prediction_Resp_IB_v1>(responseMap.keySet()))[0];

        Test.stopTest();
    }




}