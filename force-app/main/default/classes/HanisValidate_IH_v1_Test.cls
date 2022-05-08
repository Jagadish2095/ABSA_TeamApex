/*
 * Test Integration Handler for HanisValidate Service
 * @author Prashant Jain
 * @created 2020-02-12
 */

@isTest
public class HanisValidate_IH_v1_Test {
     @isTest static void validateHanisValidatePositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.HANIS_VALIDATE
        });

        Test.startTest();
        
        Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate('7707077777087');
		// Get first key from the map
		HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateHanisValidateNegative() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.HANIS_VALIDATE
        });

        Test.startTest();

        Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate('7707077777087');
		// Get first key from the map
		HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateHanisValidateNoIntegrationSettings() {
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate('7707077777087');
		// Get first key from the map
		HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		
        Test.stopTest();
    }

     @isTest static void validateHanisValidateException() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.HANIS_VALIDATE
        });

        Test.startTest();
        
        Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate('7707077777087');
		// Get first key from the map
		HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
        System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void validateHanisRequest() {

        Test.startTest();
        HanisValidate_Req_IB_v1.createDummyRequest();        
        
        Test.stopTest();
    }
    
    @isTest static void validateHanisValidate_Resp_IB_v1(){        
        HanisValidate_Resp_IB_v1 testResp = new HanisValidate_Resp_IB_v1();
        testResp.status = 'test';
        testResp.statusCode = 1;
        testResp.message = 'test';
        testResp.transactionID = 'test';
        testResp.idNumber = 'test';
        testResp.name = 'test';
        testResp.surname = 'test';
        testResp.hasSmartCard = false;
        testResp.dateIssued = 'test';
        testResp.idSequenceNo = 1;
        testResp.deadIndicator = false;
        testResp.idBlocked = false;
        testResp.dateOfDeath = 'test';
        testResp.maritalStatus = 'test';
        testResp.dateOfMarriage = 'test';
        testResp.image = 'test';
        testResp.onHanis = false;
        testResp.onHanis = false;
        testResp.birthPlaceCountryCode = 'test';
        testResp.errorCode = 1;
        testResp.Cert = 'test';
        testResp.sessionID = 'test';
       }
}