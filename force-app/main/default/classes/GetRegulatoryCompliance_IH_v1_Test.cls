@isTest
public class GetRegulatoryCompliance_IH_v1_Test {
    
    @isTest static void getRegulatoryCompliancePositive() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRegulatoryComplianceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('ID number', '9705206631181');
        System.debug('Reg Compliance responseBean getPositive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void getRegulatoryComplianceNegative() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRegulatoryComplianceMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('ID number','');
        System.debug('Reg Compliance responseBean getNegative: '+ responseBean);      
        Test.stopTest();
    }     
    
    @isTest static void getRegulatoryComplianceInfoNoIntegrationSettings() 
    {        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('ID number', '5807175122004');
        Test.stopTest();
    }
    
    @isTest static void getRegulatoryComplianceInfoException() 
    {        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRegulatoryComplianceMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = GetRegulatoryCompliance_IH_v1.getRegulatoryComplianceInfo('ID number', '5807175122004');
        System.assertEquals(500, responseBean.statusCode);  
        Test.stopTest();
    }    
}