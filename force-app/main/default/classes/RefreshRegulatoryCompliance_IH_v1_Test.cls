@isTest
public class RefreshRegulatoryCompliance_IH_v1_Test 
{
 	@isTest static void refreshRegulatoryCompliancePositive() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RefreshRegulatoryComplianceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REFRESH_REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        RefreshRegulatoryCompliance_Resp_IB_v1 responseBean = RefreshRegulatoryCompliance_IH_v1.refreshRegComplianceInfo('ID number', '8701215081089');
        System.debug('Refresh Reg Compliance responseBean getPositive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void refreshRegulatoryComplianceNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RefreshRegulatoryComplianceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REFRESH_REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        RefreshRegulatoryCompliance_Resp_IB_v1 responseBean = RefreshRegulatoryCompliance_IH_v1.refreshRegComplianceInfo('ID number', '');
        System.debug('Refresh Reg Compliance responseBean getNegative: '+ responseBean);
        
        Test.stopTest();
    }
    
    @isTest static void refreshRegulatoryComplianceInfoException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RefreshRegulatoryComplianceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REFRESH_REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        RefreshRegulatoryCompliance_Resp_IB_v1 responseBean = RefreshRegulatoryCompliance_IH_v1.refreshRegComplianceInfo('ID number', '9705206631181');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
}