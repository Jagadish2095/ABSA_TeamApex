@isTest
public class DebitOrderInstruction_IH_v1_Test 
{
	 @isTest static void DebitOrderInstructionPositive() 
    {        
        DebitOrderInstruction_Req_IB_v1 dummyBean = new DebitOrderInstruction_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.DEBIT_ORDER_INSTRUCTION});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DebitOrderInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
              
		DebitOrderInstruction_Resp_IB_v1 responseBean = DebitOrderInstruction_IH_v1.debitOrderInstruction('41860905606', 14, 270.00, '03/02/2019', 'Standard Bank', 567898, 'Cresta', '9876765654', 'Transmission');       
        System.debug('Debit Order Instruction responseBean positive: '+ responseBean);
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void DebitOrderInstructionNegative() 
    {               
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.DEBIT_ORDER_INSTRUCTION});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DebitOrderInstructionMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();  
        
		DebitOrderInstruction_Resp_IB_v1 responseBean = DebitOrderInstruction_IH_v1.debitOrderInstruction('', 14, 0.00, '', '', 0, '', '', '');      
        System.debug('Debit Order Instruction responseBean negative: '+ responseBean);
        Test.stopTest();
    }
    
    @isTest static void DebitOrderInstructionInfoException() 
    {        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.DEBIT_ORDER_INSTRUCTION});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new DebitOrderInstructionMock_ApiRest(StringConstants.UNHANDLED_EXCEPTION_STATUS));
        
        Test.startTest();
        
        DebitOrderInstruction_Resp_IB_v1 responseBean = DebitOrderInstruction_IH_v1.debitOrderInstruction('41860905606', 14, 270.00, '03/02/2019', 'Standard B ank', 567898, 'Cresta', '9876765654', 'Transmission');
        System.assertEquals(500, responseBean.statusCode);
        Test.stopTest();
    }
    
    @isTest static void hlAllocateStockNoIntegrationSettings() 
    {                      
        Test.startTest();  
        
		DebitOrderInstruction_Resp_IB_v1 responseBean = DebitOrderInstruction_IH_v1.debitOrderInstruction('41860905606', 14, 270.00, '03/02/2019', 'Standard Bank', 567898, 'Cresta', '9876765654', 'Transmission');      
        System.debug('Debit Order Instruction responseBean negative: '+ responseBean);
        Test.stopTest();
    }
}