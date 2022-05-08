/*
 * Test Integration Handler for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh
 * @created 2020-04-07
 */
@isTest
public class CqUpdAcctDomicileChangev2_IH_v1_Test {
    
    @isTest static void validateCqUpdAcctDomicileChangev2Positive() {
        CqUpdAcctDomicileChangev2_Req_IB_v1 dummyBeanParent = CqUpdAcctDomicileChangev2_Req_IB_v1.createDummyRequest();
        CqUpdAcctDomicileChangev2_Req_IB_v1.cqh538i dummyBean = dummyBeanParent.CqUpdAcctDomicileChangev2.cqh538i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CqUpdAcctDomicileChangev2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE
        });

        Test.startTest();
        
        Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(dummyBean.accountNbr,dummyBean.newBranch,dummyBean.branchCode,dummyBean.tellerCode,dummyBean.supervisorCode);
		// Get first key from the map
		CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];
        
        System.assertEquals(200, responseBean.statusCode);
        responseBean.dummyResponse();
        Test.stopTest();
    }
      
     @isTest static void validateCqUpdAcctDomicileChangev2Negative() {
        CqUpdAcctDomicileChangev2_Req_IB_v1 dummyBeanParent = CqUpdAcctDomicileChangev2_Req_IB_v1.createDummyRequest();
        CqUpdAcctDomicileChangev2_Req_IB_v1.cqh538i dummyBean = dummyBeanParent.CqUpdAcctDomicileChangev2.cqh538i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CqUpdAcctDomicileChangev2_Mock_ApiRest(StringConstants.Negative_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE
        });

        Test.startTest();
        
        Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(dummyBean.accountNbr,dummyBean.newBranch,dummyBean.branchCode,dummyBean.tellerCode,dummyBean.supervisorCode);
		// Get first key from the map
		CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
      
     @isTest static void validateCqUpdAcctDomicileChangev2NoIntegrationSettings() {
        CqUpdAcctDomicileChangev2_Req_IB_v1 dummyBeanParent = CqUpdAcctDomicileChangev2_Req_IB_v1.createDummyRequest();
        CqUpdAcctDomicileChangev2_Req_IB_v1.cqh538i dummyBean = dummyBeanParent.CqUpdAcctDomicileChangev2.cqh538i;

        

        Test.startTest();
        
        Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(dummyBean.accountNbr,dummyBean.newBranch,dummyBean.branchCode,dummyBean.tellerCode,dummyBean.supervisorCode);
		// Get first key from the map
		CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
    }
        
     @isTest static void validateCqUpdAcctDomicileChangev2Exception() {
        CqUpdAcctDomicileChangev2_Req_IB_v1 dummyBeanParent = CqUpdAcctDomicileChangev2_Req_IB_v1.createDummyRequest();
        CqUpdAcctDomicileChangev2_Req_IB_v1.cqh538i dummyBean = dummyBeanParent.CqUpdAcctDomicileChangev2.cqh538i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CqUpdAcctDomicileChangev2_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API, new list < String > {
            StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE
        });

        Test.startTest();
        
        Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(dummyBean.accountNbr,dummyBean.newBranch,dummyBean.branchCode,dummyBean.tellerCode,dummyBean.supervisorCode);
		// Get first key from the map
		CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];
        System.AssertNotEquals(200, responseBean.statusCode);
        
        Test.stopTest();
        
    }
     
}