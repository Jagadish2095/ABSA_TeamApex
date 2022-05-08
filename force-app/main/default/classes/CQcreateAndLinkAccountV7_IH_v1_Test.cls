/*
 * Test Integration Handler for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

@isTest
public class CQcreateAndLinkAccountV7_IH_v1_Test {
     @isTest static void validateCQcreateAndLinkAccountV7Positive() {
        CQcreateAndLinkAccountV7_Req_IB_v1 dummyBeanParent = CQcreateAndLinkAccountV7_Req_IB_v1.createDummyRequest();
        CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i dummyBean = dummyBeanParent.CQcreateAndLinkAccountV7.cqh411i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CQcreateAndLinkAccountV7_Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7
        });

        Test.startTest();
        
        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7(dummyBean.accountNbr, dummyBean.openSite, dummyBean.controlSite, dummyBean.cifKey, dummyBean.tellerNbr, dummyBean.controllerNbr, dummyBean.workstationNbr, dummyBean.product, dummyBean.applicationNbr, dummyBean.controlSiteType, dummyBean.openSiteType, dummyBean.effectiveDate, dummyBean.marketersCode, dummyBean.provChqBookInd, dummyBean.cbpSchemeCode, dummyBean.cbpPrimaryAccount, dummyBean.srcOfFnds1, dummyBean.srcOfFnds2, dummyBean.srcOfFnds3, dummyBean.srcOfFnds4, dummyBean.srcOfFnds5, dummyBean.digitalChannel, dummyBean.rbaEdd);
		// Get first key from the map
		CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = (new List<CQcreateAndLinkAccountV7_Resp_IB_v1>(responseMap.keySet()))[0];
         CQcreateAndLinkAccountV7_Resp_IB_v1.dummyResponse();
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }

     @isTest static void validateCQcreateAndLinkAccountV7Negative() {
        CQcreateAndLinkAccountV7_Req_IB_v1 dummyBeanParent = CQcreateAndLinkAccountV7_Req_IB_v1.createDummyRequest();
        CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i dummyBean = dummyBeanParent.CQcreateAndLinkAccountV7.cqh411i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CQcreateAndLinkAccountV7_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7
        });

        Test.startTest();

        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7(dummyBean.accountNbr, dummyBean.openSite, dummyBean.controlSite, dummyBean.cifKey, dummyBean.tellerNbr, dummyBean.controllerNbr, dummyBean.workstationNbr, dummyBean.product, dummyBean.applicationNbr, dummyBean.controlSiteType, dummyBean.openSiteType, dummyBean.effectiveDate, dummyBean.marketersCode, dummyBean.provChqBookInd, dummyBean.cbpSchemeCode, dummyBean.cbpPrimaryAccount, dummyBean.srcOfFnds1, dummyBean.srcOfFnds2, dummyBean.srcOfFnds3, dummyBean.srcOfFnds4, dummyBean.srcOfFnds5, dummyBean.digitalChannel, dummyBean.rbaEdd);
		// Get first key from the map
		CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = (new List<CQcreateAndLinkAccountV7_Resp_IB_v1>(responseMap.keySet()))[0];
		CQcreateAndLinkAccountV7_Resp_IB_v1.dummyResponse();
        Test.stopTest();
    }

     @isTest static void validateCQcreateAndLinkAccountV7NoIntegrationSettings() {
        CQcreateAndLinkAccountV7_Req_IB_v1 dummyBeanParent = CQcreateAndLinkAccountV7_Req_IB_v1.createDummyRequest();
        CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i dummyBean = dummyBeanParent.CQcreateAndLinkAccountV7.cqh411i;

        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7(dummyBean.accountNbr, dummyBean.openSite, dummyBean.controlSite, dummyBean.cifKey, dummyBean.tellerNbr, dummyBean.controllerNbr, dummyBean.workstationNbr, dummyBean.product, dummyBean.applicationNbr, dummyBean.controlSiteType, dummyBean.openSiteType, dummyBean.effectiveDate, dummyBean.marketersCode, dummyBean.provChqBookInd, dummyBean.cbpSchemeCode, dummyBean.cbpPrimaryAccount, dummyBean.srcOfFnds1, dummyBean.srcOfFnds2, dummyBean.srcOfFnds3, dummyBean.srcOfFnds4, dummyBean.srcOfFnds5, dummyBean.digitalChannel, dummyBean.rbaEdd);
		// Get first key from the map
		CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = (new List<CQcreateAndLinkAccountV7_Resp_IB_v1>(responseMap.keySet()))[0];
		CQcreateAndLinkAccountV7_Resp_IB_v1.dummyResponse();
        Test.stopTest();
    }

     @isTest static void validateCQcreateAndLinkAccountV7Exception() {
        CQcreateAndLinkAccountV7_Req_IB_v1 dummyBeanParent = CQcreateAndLinkAccountV7_Req_IB_v1.createDummyRequest();
        CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i dummyBean = dummyBeanParent.CQcreateAndLinkAccountV7.cqh411i;

        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CQcreateAndLinkAccountV7_Mock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7
        });

        Test.startTest();
        
        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQcreateAndLinkAccountV7_IH_v1.CQcreateAndLinkAccountV7(dummyBean.accountNbr, dummyBean.openSite, dummyBean.controlSite, dummyBean.cifKey, dummyBean.tellerNbr, dummyBean.controllerNbr, dummyBean.workstationNbr, dummyBean.product, dummyBean.applicationNbr, dummyBean.controlSiteType, dummyBean.openSiteType, dummyBean.effectiveDate, dummyBean.marketersCode, dummyBean.provChqBookInd, dummyBean.cbpSchemeCode, dummyBean.cbpPrimaryAccount, dummyBean.srcOfFnds1, dummyBean.srcOfFnds2, dummyBean.srcOfFnds3, dummyBean.srcOfFnds4, dummyBean.srcOfFnds5, dummyBean.digitalChannel, dummyBean.rbaEdd);
		// Get first key from the map
		CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = (new List<CQcreateAndLinkAccountV7_Resp_IB_v1>(responseMap.keySet()))[0];
        CQcreateAndLinkAccountV7_Resp_IB_v1.dummyResponse();
         System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
}