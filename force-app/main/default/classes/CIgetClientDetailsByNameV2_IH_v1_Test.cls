/*
 * Test Integration Handler for CIgetClientDetailsByNameV2 Service
 * @author Rudolf Niehaus
 * @created 2020-04-07
 */

@isTest
public class CIgetClientDetailsByNameV2_IH_v1_Test {
     @isTest static void validateCIgetClientDetailsByNameV2Positive() {

        CIgetClientDetailsByNameV2_Req_IB_v1 dummyBeanParent = CIgetClientDetailsByNameV2_Req_IB_v1.createDummyRequest();
        CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i dummyBean = dummyBeanParent.CIgetClientDetailsByNameV2.cip602i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetClientDetailsByNameV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2
        });

        Test.startTest();
        
        Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetClientDetailsByNameV2_IH_v1.CIgetClientDetailsByNameV2(dummyBean.cifSurname, 
                                                                                                                                                            dummyBean.cifInitials, 
                                                                                                                                                            dummyBean.clntGroup, 
                                                                                                                                                            dummyBean.clntGender, 
                                                                                                                                                            dummyBean.clntBirthDate, 
                                                                                                                                                            dummyBean.maxRecsToRtrv, 
                                                                                                                                                            dummyBean.startAfterSearchPos, 
                                                                                                                                                            dummyBean.siteCode, 
                                                                                                                                                            dummyBean.clntTitle);
		// Get first key from the map
		CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = (new List<CIgetClientDetailsByNameV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateCIgetClientDetailsByNameV2Negative() {

        CIgetClientDetailsByNameV2_Req_IB_v1 dummyBeanParent = CIgetClientDetailsByNameV2_Req_IB_v1.createDummyRequest();
        CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i dummyBean = dummyBeanParent.CIgetClientDetailsByNameV2.cip602i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetClientDetailsByNameV2_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2
        });

        Test.startTest();

        Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetClientDetailsByNameV2_IH_v1.CIgetClientDetailsByNameV2(dummyBean.cifSurname, 
                                                                                                                                                            dummyBean.cifInitials, 
                                                                                                                                                            dummyBean.clntGroup, 
                                                                                                                                                            dummyBean.clntGender, 
                                                                                                                                                            dummyBean.clntBirthDate, 
                                                                                                                                                            dummyBean.maxRecsToRtrv, 
                                                                                                                                                            dummyBean.startAfterSearchPos, 
                                                                                                                                                            dummyBean.siteCode, 
                                                                                                                                                            dummyBean.clntTitle);
		// Get first key from the map
		CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = (new List<CIgetClientDetailsByNameV2_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCIgetClientDetailsByNameV2NoIntegrationSettings() {

        CIgetClientDetailsByNameV2_Req_IB_v1 dummyBeanParent = CIgetClientDetailsByNameV2_Req_IB_v1.createDummyRequest();
        CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i dummyBean = dummyBeanParent.CIgetClientDetailsByNameV2.cip602i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetClientDetailsByNameV2_IH_v1.CIgetClientDetailsByNameV2(dummyBean.cifSurname, 
                                                                                                                                                            dummyBean.cifInitials, 
                                                                                                                                                            dummyBean.clntGroup, 
                                                                                                                                                            dummyBean.clntGender, 
                                                                                                                                                            dummyBean.clntBirthDate, 
                                                                                                                                                            dummyBean.maxRecsToRtrv, 
                                                                                                                                                            dummyBean.startAfterSearchPos, 
                                                                                                                                                            dummyBean.siteCode, 
                                                                                                                                                            dummyBean.clntTitle);
		// Get first key from the map
		CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = (new List<CIgetClientDetailsByNameV2_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateCIgetClientDetailsByNameV2Exception() {

        CIgetClientDetailsByNameV2_Req_IB_v1 dummyBeanParent = CIgetClientDetailsByNameV2_Req_IB_v1.createDummyRequest();
        CIgetClientDetailsByNameV2_Req_IB_v1.Cip602i dummyBean = dummyBeanParent.CIgetClientDetailsByNameV2.cip602i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CIgetClientDetailsByNameV2_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list < String > {
            StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2
        });

        Test.startTest();
        
        Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetClientDetailsByNameV2_IH_v1.CIgetClientDetailsByNameV2(dummyBean.cifSurname, 
                                                                                                                                                            dummyBean.cifInitials, 
                                                                                                                                                            dummyBean.clntGroup, 
                                                                                                                                                            dummyBean.clntGender, 
                                                                                                                                                            dummyBean.clntBirthDate, 
                                                                                                                                                            dummyBean.maxRecsToRtrv, 
                                                                                                                                                            dummyBean.startAfterSearchPos, 
                                                                                                                                                            dummyBean.siteCode, 
                                                                                                                                                            dummyBean.clntTitle);
		// Get first key from the map
		CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean = (new List<CIgetClientDetailsByNameV2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}