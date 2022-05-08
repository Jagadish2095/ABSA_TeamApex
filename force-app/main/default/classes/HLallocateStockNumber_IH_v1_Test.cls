@isTest
public class HLallocateStockNumber_IH_v1_Test {
    
    @isTest static void hlAllocateStockNumberPositive() 
    {        
        HLallocateStockNumber_Req_IB_v1 dummyBean = new HLallocateStockNumber_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HLallocateStockNumberMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
              
		HLallocateStockNumber_Resp_IB_v1 responseBean = HLallocateStockNumber_IH_v1.hlAllocateStockNumber('','WILLS','N','E','STD','','','001','410','410','3232');       
        System.debug('HLallocate StockNumber responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void hlAllocateStockNumberNegative() 
    {               
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HLallocateStockNumberMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();  
        
		HLallocateStockNumber_Resp_IB_v1 responseBean = HLallocateStockNumber_IH_v1.hlAllocateStockNumber('','WILLS','N','E','','','','001','410','410','');      
        System.debug('HLallocate StockNumber responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void hlAllocateStockNumberInfoException() 
    {        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.HLALLOCATE_STOCK_NUMBER});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HLallocateStockNumberMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        
        Test.startTest();
        
        HLallocateStockNumber_Resp_IB_v1 responseBean = HLallocateStockNumber_IH_v1.hlAllocateStockNumber('','','','','','','','','','','');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void hlAllocateStockNoIntegrationSettings() 
    {               
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new HLallocateStockNumberMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();  
        
		HLallocateStockNumber_Resp_IB_v1 responseBean = HLallocateStockNumber_IH_v1.hlAllocateStockNumber('','WILLS','N','E','','','','001','410','410','');      
        System.debug('HLallocate StockNumber responseBean negative: '+ responseBean);
        Test.stopTest();
    }
}