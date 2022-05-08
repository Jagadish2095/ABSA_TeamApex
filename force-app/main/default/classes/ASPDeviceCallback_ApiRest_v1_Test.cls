@isTest
public class ASPDeviceCallback_ApiRest_v1_Test {
    
        @testSetup static void Setup(){ 
            string requestMetadata = '{\"ContractReference\":"Test 1111 ",\"ContractAccount\":"4456328903 ",\"ContractDebtorID\":"6026354891235",\"ContractMaximunAmount\":\"250",\"Function\":\"ONUSandNOUS\",\"UserNo\":null,\"ClientType\":null,\"AccessNumber\":null,\"OverrideNo\":null,\"OverrideReason\":null}';        
            ASPDeviceRequest__c newRequest =  new ASPDeviceRequest__c();
            newRequest.CustomerID__c = '6026354891235';
            newRequest.DeviceFunction__c = 'Pin Pad';
            newRequest.RequestMetadata__c = requestMetadata;        
            newRequest.Username__c = UserInfo.getUserName();
            newRequest.RequestDateTime__c = Datetime.now();
            newRequest.Status__c = 'PENDING';            
            Database.SaveResult sr = Database.insert(newRequest);
            //System.debug('setup result :' + sr.isSuccess());
   		 }
    
        @isTest static void ASPDeviceCallback_ApiRest_v1(){ 
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id from ASPDeviceRequest__c where CustomerID__c = :'6026354891235' LIMIT 1];		      
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
       		       
        ASPCallbackInput aspCallbackInput = new ASPCallbackInput();
        aspCallbackInput.Object_ID = deviceRequest.Id;
        aspCallbackInput.Metadata ='{ \"Result\": "MACTestclass"}';
        Test.startTest();
        string result = ASPDeviceCallback_ApiRest_v1.processDeviceCallback(aspCallbackInput);
       // System.debug('result :'+ result);
        System.assert(result.contains('Success'));
        Test.stopTest(); 
    }
}