@isTest
public class CreateInstruction_IH_v1_Test {
    
       
    @isTest static void testCreateInstructionPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.createInstruction('01573017159', 'Cheque', '632005', '500', new User(), '','');
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();   
    }
    
    

        
    @isTest static void testCreateInstructionnNegative(){   
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.createInstruction('01573017159', 'Cheque', '632005', '500', new User(), '','');
        CreateInstruction_Resp_IB_v1 responseB = CreateInstruction_IH_v1.MBcreateInstruction('01', 'Test','203099621','51008','4047995828','CQ','4047995828','TEstst','Testing');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    
    @isTest static void testMBCreateInstructionMBcreateInstruction(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.MBcreateInstruction('01', 'Test','203099621','51008','4047995828','CQ','4047995828','TEstst','Testing');
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();  
    } 
    
    @isTest static void testCreateInstructionNoIntegrationSettings(){
        
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.createInstruction('01573017159', 'Cheque', '632005', '500', new User(), '','');
        CreateInstruction_Resp_IB_v1 responseB = CreateInstruction_IH_v1.MBcreateInstruction('01', 'Test','203099621','51008','4047995828','CQ','4047995828','TEstst','Testing');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.createInstruction('01573017159', 'Cheque', '632005', '500', new User(), '','');
        CreateInstruction_Resp_IB_v1 responseB = CreateInstruction_IH_v1.MBcreateInstruction('01', 'Test','203099621','51008','4047995828','CQ','4047995828','TEstst','Testing');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateInstructionNoIntegrationTranslations(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        
        Test.startTest();
        // Call the method to test
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.createInstruction('01573017159', 'Cheque', '632005', '500', new User(), '','');
        CreateInstruction_Resp_IB_v1 responseB = CreateInstruction_IH_v1.MBcreateInstruction('01', 'Test','203099621','51008','4047995828','CQ','4047995828','TEstst','Testing');
        System.debug('responseBean :' + responseBean);
        System.debug('ResponseBean for MBcreate :' + responseB);
        Test.stopTest();
    }
    
     @isTest static void testMBCreateInstructionFuturePositive(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_INSTRUCTION});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        CreateInstruction_Resp_IB_v1 responseBean = CreateInstruction_IH_v1.MBCreateInstructionFuture('01573017159', 'Cheque','3','4047995828','632005','Test','01','20200323','Testing','4047995828');
        system.debug('code'+ responseBean.statusCode);
        system.assertEquals(200, responseBean.statusCode);
        Test.stopTest();  
    } 

    @isTest static void testCreateInstructionCreateDummy(){
        CreateInstruction_Req_IB_v1 requestBean = CreateInstruction_Req_IB_v1.createDummy();
        CreateInstruction_Req_IB_v1 requestB = CreateInstruction_Req_IB_v1.createAddBen();
    }
    
    @isTest static void testCreateInstructionDummyResponse(){
        CreateInstruction_Resp_IB_v1 requestBean = CreateInstruction_Resp_IB_v1.dummyResponse();
       
    }
    
    
    
}