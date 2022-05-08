@isTest
public class ASPDeviceRequestHelperTest {
    @isTest static void CreateDeviceRequestTestPositive(){
        string deviceFunction = 'Pin Pad';
		string metadata = '{\"ContractReference\":"Test 1234 ",\"ContractAccount\":"4456328903 ",\"ContractDebtorID\":"7026354891235",\"ContractMaximunAmount\":\"250",\"Function\":\"ONUSandNOUS\",\"UserNo\":null,\"ClientType\":null,\"AccessNumber\":null,\"OverrideNo\":null,\"OverrideReason\":null}';
            
        Test.startTest();
        string result = ASPDeviceRequestHelper.CreateRequest('7569823695423', deviceFunction, metadata);        
        System.debug('Result: '+ result);
        System.assert(!result.startsWith('Failure'));
        System.assert(result.contains('Test 1234'));
        Test.stopTest(); 
    }
     @isTest static void CreateDeviceRequestTestNegative(){     
        string deviceFunction = '';
		string metadata = '';
        Test.startTest();
        string result = ASPDeviceRequestHelper.CreateRequest('', deviceFunction, metadata);
        System.debug('Result: '+ result);
       // System.assert(result.startsWith('Failure'));
        Test.stopTest();     
    } 
    
    @testSetup static void Setup()
    { 
		string requestMetadata = '{\"ContractReference\":"Test 1111 ",\"ContractAccount\":"4456328903 ",\"ContractDebtorID\":"6026354891235",\"ContractMaximunAmount\":\"250",\"Function\":\"ONUSandNOUS\",\"UserNo\":null,\"ClientType\":null,\"AccessNumber\":null,\"OverrideNo\":null,\"OverrideReason\":null}';        
        ASPDeviceRequest__c newRequest =  new ASPDeviceRequest__c();
        newRequest.CustomerID__c = '6026354891235';
        newRequest.DeviceFunction__c = 'Pin Pad';
        newRequest.RequestMetadata__c = requestMetadata;        
        newRequest.Username__c = UserInfo.getUserName();
        newRequest.RequestDateTime__c = Datetime.now();
        newRequest.Status__c = 'PENDING';            
        Database.SaveResult sr = Database.insert(newRequest);
        System.debug('setup result :' + sr.isSuccess());
    }
    
    @isTest static void UpdateRequestTestPositive()      
    {
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];
		System.debug('deviceRequestList:'+ deviceRequestList.size() );        
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
        System.debug('deviceRequest:'+ deviceRequest.Id );
        string requestId = deviceRequest.Id;
        string metadata ='{ \"Result\": "MACTestclass"}';
        string status = 'COMPLETED';
        Test.startTest();
        string actual = ASPDeviceRequestHelper.UpdateRequest(requestId, metadata, status);
        List<ASPDeviceRequest__c> actualDeviceRequestList =  [select Id,Status__c from ASPDeviceRequest__c where Id = :requestId LIMIT 1];
        System.assertEquals(actualDeviceRequestList.size(), 1);
        ASPDeviceRequest__c actualDeviceRequest = actualDeviceRequestList.get(0);
        System.assertEquals(actualDeviceRequest.Status__c, status);
        Test.stopTest();
    }
    @isTest static void UpdateRequestTestNegative()      
    {
        string requestId = 'G';
        string metadata ='{  \"Result\": "MACTest123"}';
        string status = 'COMPLETED';
        Test.startTest();
        string result = ASPDeviceRequestHelper.UpdateRequest(requestId, metadata, status);
        Test.stopTest();
    }
   
    @isTest static void UpdateDocumentScanRequestTestPositive()      
    {
        string requestId = 'a2C5E000009GWSqUAO';
        string metadata ='{  \"Result\": "MACTest123"}';
        string status = 'COMPLETED';
        Test.startTest();
        string result = ASPDeviceRequestHelper.UpdateRequest(requestId, metadata, status);
        
        Test.stopTest();
    }
   
   
    @isTest static void getDeviceRefreshStatusUpdateNegative(){ 
        string requestId ='';
        Test.startTest();
        string actual = ASPDeviceRequestHelper.getDeviceRefreshStatusUpdate(requestId);
        System.assert(actual.startsWith('Failure'));
        Test.stopTest();      
    }
    
     @isTest static void getDeviceRefreshStatusUpdatePositive(){ 
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];		      
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);   
        Test.startTest();
        string result = ASPDeviceRequestHelper.getDeviceRefreshStatusUpdate(deviceRequest.Id);
        Test.stopTest();      
    }
    
	@isTest static void getDeviceResponseMetadataNegative(){ 
        string requestId = '';
        Test.startTest();
        string actual = ASPDeviceRequestHelper.getDeviceResponseMetadata(requestId);       
        System.assert(actual.startsWith('Failure'));
        Test.stopTest(); 
    }   
	
    @isTest static void getDeviceResponseMetadataPositive(){
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];		      
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);          
        Test.startTest();
        string result = ASPDeviceRequestHelper.getDeviceResponseMetadata(deviceRequest.Id);
        System.debug('result positive :' + result);
        Test.stopTest();     
 
    }
    
     @isTest static void CheckIfResponseCompeteStatus(){
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];		      
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);          
        Test.startTest();
        string result = ASPDeviceRequestHelper.CheckIfResponseCompeteStatus(deviceRequest.Id);
        System.debug('result positive :' + result);
        Test.stopTest();     
 
    }
    
     @isTest static void CheckDeviceResponse(){
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];		      
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);          
        Test.startTest();
        string result = ASPDeviceRequestHelper.CheckDeviceResponse(deviceRequest.Id);
        System.debug('result positive :' + result);
        Test.stopTest();     
    }
    
}