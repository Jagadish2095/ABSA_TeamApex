/**
* GetCustomerVAPMSummary_IH_v1_Test
*
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-09-13
*
*
*
**/

@isTest
public class GetCustomerVAPMSummary_IH_v1_Test {
	
    @isTest static void GetCustomerVAPMSummaryHappyPath() {
        
        GetCustomerVAPMSummary_Req_IB_v1 dummyRequest = new GetCustomerVAPMSummary_Req_IB_v1();
        dummyRequest.creatDummyRequest();
        
        Test.setMock(HttpCalloutMock.class, new getCustomerVAPMSummaryMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_DEV, new list<String> {StringConstants.GET_CUSTOMER_VAPM_SUMMARY});
        Test.startTest();
        //GetCustomerVAPMSummary_IH_v1.GetCustomerVapmSummary('ARENTAL001');
        Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GetCustomerVAPMSummary_IH_v1.GetCustomerVapmSummary('AMSYSTE020');
		GetCustomerVAPMSummary_Resp_IB_v1 responseBean = (new List<GetCustomerVAPMSummary_Resp_IB_v1>(responseMap.keySet()))[0];
        Test.stopTest();
    }
    
    @isTest static void nullIntegrationSettings() {
        Test.startTest();
       
        Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GetCustomerVAPMSummary_IH_v1.GetCustomerVapmSummary('AMSYSTE020');
		GetCustomerVAPMSummary_Resp_IB_v1 responseBean = (new List<GetCustomerVAPMSummary_Resp_IB_v1>(responseMap.keySet()))[0];
        Test.stopTest();
    }
    
    @isTest static void GetCustomerVAPMSummaryException() {
        Test.setMock(HttpCalloutMock.class, new getCustomerVAPMSummaryMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_DEV, new list<String> {StringConstants.GET_CUSTOMER_VAPM_SUMMARY});
        Test.startTest();
       
        Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GetCustomerVAPMSummary_IH_v1.GetCustomerVapmSummary('AMSYSTE020');
		GetCustomerVAPMSummary_Resp_IB_v1 responseBean = (new List<GetCustomerVAPMSummary_Resp_IB_v1>(responseMap.keySet()))[0];
        Test.stopTest();
    }
    
    @isTest static void validateBankerInfoNegative() 
    {               
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new getCustomerVAPMSummaryMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_DEV, new list<String> {StringConstants.GET_CUSTOMER_VAPM_SUMMARY});

        Test.startTest();
        
        Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GetCustomerVAPMSummary_IH_v1.GetCustomerVapmSummary('');
		GetCustomerVAPMSummary_Resp_IB_v1 responseBean = (new List<GetCustomerVAPMSummary_Resp_IB_v1>(responseMap.keySet()))[0];
       
        Test.stopTest();
    }
   
}