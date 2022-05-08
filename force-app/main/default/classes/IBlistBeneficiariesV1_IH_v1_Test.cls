/*
 * Test Integration Handler for IBlistBeneficiariesV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-19
 */

@isTest
public class IBlistBeneficiariesV1_IH_v1_Test {
     @isTest static void validateIBlistBeneficiariesV1Positive() {

        IBlistBeneficiariesV1_Req_IB_v1 dummyBeanParent = IBlistBeneficiariesV1_Req_IB_v1.createDummyRequest();
        IBlistBeneficiariesV1_Req_IB_v1.Nhp457i dummyBean = dummyBeanParent.IBlistBeneficiariesV1.nhp457i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new IBlistBeneficiariesV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.IB_GET_BENEFICIARY_V1
        });

        Test.startTest();
        
        Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = IBlistBeneficiariesV1_IH_v1.IBlistBeneficiariesV1(dummyBean.accessAccount, 
                                                                                                                                            dummyBean.branch, 
                                                                                                                                            dummyBean.subBranch,
                                                                                                                                            dummyBean.siteType,
                                                                                                                                            dummyBean.teller,
                                                                                                                                            dummyBean.manager,
                                                                                                                                            dummyBean.supervisor);
		// Get first key from the map
		IBlistBeneficiariesV1_Resp_IB_v1 responseBean = (new List<IBlistBeneficiariesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateIBlistBeneficiariesV1Negative() {

        IBlistBeneficiariesV1_Req_IB_v1 dummyBeanParent = IBlistBeneficiariesV1_Req_IB_v1.createDummyRequest();
        IBlistBeneficiariesV1_Req_IB_v1.Nhp457i dummyBean = dummyBeanParent.IBlistBeneficiariesV1.nhp457i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new IBlistBeneficiariesV1_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.IB_GET_BENEFICIARY_V1
        });

        Test.startTest();

        Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = IBlistBeneficiariesV1_IH_v1.IBlistBeneficiariesV1(dummyBean.accessAccount, 
                                                                                                                                            dummyBean.branch, 
                                                                                                                                            dummyBean.subBranch,
                                                                                                                                            dummyBean.siteType,
                                                                                                                                            dummyBean.teller,
                                                                                                                                            dummyBean.manager,
                                                                                                                                            dummyBean.supervisor);
		// Get first key from the map
		IBlistBeneficiariesV1_Resp_IB_v1 responseBean = (new List<IBlistBeneficiariesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateIBlistBeneficiariesV1NoIntegrationSettings() {

        IBlistBeneficiariesV1_Req_IB_v1 dummyBeanParent = IBlistBeneficiariesV1_Req_IB_v1.createDummyRequest();
        IBlistBeneficiariesV1_Req_IB_v1.Nhp457i dummyBean = dummyBeanParent.IBlistBeneficiariesV1.nhp457i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = IBlistBeneficiariesV1_IH_v1.IBlistBeneficiariesV1(dummyBean.accessAccount, 
                                                                                                                                            dummyBean.branch, 
                                                                                                                                            dummyBean.subBranch,
                                                                                                                                            dummyBean.siteType,
                                                                                                                                            dummyBean.teller,
                                                                                                                                            dummyBean.manager,
                                                                                                                                            dummyBean.supervisor);
		// Get first key from the map
		IBlistBeneficiariesV1_Resp_IB_v1 responseBean = (new List<IBlistBeneficiariesV1_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateIBlistBeneficiariesV1Exception() {

        IBlistBeneficiariesV1_Req_IB_v1 dummyBeanParent = IBlistBeneficiariesV1_Req_IB_v1.createDummyRequest();
        IBlistBeneficiariesV1_Req_IB_v1.Nhp457i dummyBean = dummyBeanParent.IBlistBeneficiariesV1.nhp457i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new IBlistBeneficiariesV1_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.IB_GET_BENEFICIARY_V1
        });

        Test.startTest();
        
        Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = IBlistBeneficiariesV1_IH_v1.IBlistBeneficiariesV1(dummyBean.accessAccount, 
                                                                                                                                            dummyBean.branch, 
                                                                                                                                            dummyBean.subBranch,
                                                                                                                                            dummyBean.siteType,
                                                                                                                                            dummyBean.teller,
                                                                                                                                            dummyBean.manager,
                                                                                                                                            dummyBean.supervisor);
		// Get first key from the map
		IBlistBeneficiariesV1_Resp_IB_v1 responseBean = (new List<IBlistBeneficiariesV1_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}