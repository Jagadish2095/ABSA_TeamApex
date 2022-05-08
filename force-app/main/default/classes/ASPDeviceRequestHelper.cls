/**
* Helper class to create and update ASPDeviceRequests
* @author  Celliers Inggs
* @created 2020-10-20
*/
public with sharing class ASPDeviceRequestHelper {
    
       @AuraEnabled
       public static string CreateRequest(string customerID, string deviceFunction, string requestMetadata) {
           try{
                ASPDeviceRequest__c newRequest =  new ASPDeviceRequest__c();
                newRequest.CustomerID__c = customerID;
                newRequest.DeviceFunction__c = deviceFunction;
                newRequest.RequestMetadata__c = requestMetadata;        
                newRequest.Username__c = UserInfo.getUserName();
                newRequest.RequestDateTime__c = Datetime.now();
                newRequest.Status__c = 'PENDING';      
                
                Database.SaveResult sr = Database.insert(newRequest);               
                return JSON.serialize(newRequest);
               
            } catch(Exception e) {           
            return 'Failure: ' + e.getMessage();
        }
    }
  
    public static string UpdateRequest(string requestId, string responseMetadata, string status) {
        try 
        {
            List<ASPDeviceRequest__c> deviceRequestList =  [select Id,ResponseMetadata__c,Status__c,ResponseDateTime__c,
            DeviceFunction__c,Username__c,CustomerID__c from ASPDeviceRequest__c where Id = :requestId LIMIT 1];
           
            if (deviceRequestList.size() == 0)
            {
                return 'Failure: Device request not found';
            }
            ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);			 
            List<User> users = [SELECT Id FROM User WHERE Username = :deviceRequest.Username__c LIMIT 1];
            User ownerUser = users.get(0);
            
            switch on deviceRequest.DeviceFunction__c {
                when 'Document Scan' {		
                   /**Id accountId = null;
                    Account customerAccount = GetAccount(deviceRequest.CustomerID__c);
                   	List<Account> accounts = [SELECT Id FROM Account WHERE ID_Number__pc = :deviceRequest.CustomerID__c LIMIT 1];
                    Account account = accounts.get(0);
                    if (account != null){
                        accountId = account.Id;
                    }

                    string docResult = ASPDeviceRequestDocumentHelper.ProcessDocuments(account.Id, ownerUser.Id, responseMetadata);
                    if (docResult != 'Success'){
                        return docResult;
                    }**/
                }	
                when 'Bio' {		
                    
                }	
                when 'Contract' {		
                    
                }	
                when 'Pin Pad' {		
                                     
                }	
            }

            deviceRequest.ResponseMetadata__c = responseMetadata;
            deviceRequest.Status__c = status;
            deviceRequest.ResponseDateTime__c = Datetime.now();
    
            Database.SaveResult sr = Database.update(deviceRequest);
           if (sr.isSuccess()){
                return 'Success';
            }           
            else{
                string errorResponse = 'Failure: ';
                for(Database.Error err : sr.getErrors()) {
                    errorResponse = errorResponse + err.getStatusCode() + ' - ' + err.getMessage() + '; ';
                }
                return errorResponse;
            }
        } catch(Exception e) {
            System.debug('Failure: ' + e.getMessage());
            return 'Failure: ' + e.getMessage();
        }
    } 
    
    @AuraEnabled
    public static string getDeviceRefreshStatusUpdate(string requestId){     
            List<ASPDeviceRequest__c> deviceRequestList =  [select Id, Status__c from ASPDeviceRequest__c where Id = :requestId LIMIT 1];
              if (deviceRequestList.size() == 0)
                {
                    return 'Failure: Device request not found';
                }
            ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
            return deviceRequest.Status__c;   
    }
    
    
   @AuraEnabled
    public static string getDeviceResponseMetadata(string requestId){     
             List<ASPDeviceRequest__c> deviceRequestList =  [select Id, ResponseMetadata__c from ASPDeviceRequest__c where Id = :requestId];      
              if (deviceRequestList.size() == 0)
                {
                    return 'Failure: Device request not found';
                }
            ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
            System.debug('device request:'+ deviceRequest);
            return deviceRequest.ResponseMetadata__c;   
    }
	@AuraEnabled
    public static string CheckDeviceResponse(string requestId){
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id, ResponseMetadata__c from ASPDeviceRequest__c where Id = :requestId];      
        if (deviceRequestList.size() == 0)
        {
        	return '{Error:{message:"Device request not found"}}';
        }
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
        return JSON.serialize(deviceRequest);
    }

    @AuraEnabled
    public static string CheckIfResponseCompeteStatus(string requestId){     
        List<ASPDeviceRequest__c> deviceRequestList =  [select Id, Status__c from ASPDeviceRequest__c where Id = :requestId LIMIT 1];
        if (deviceRequestList.size() == 0)
          {
              return 'Failure: Device request not found';
          }
        ASPDeviceRequest__c deviceRequest = deviceRequestList.get(0);
        
      
        If(deviceRequest.Status__c == 'EXPIRED'){ 
            deviceRequest.Status__c = 'PENDING';
            update deviceRequest;
        }
        
        return deviceRequest.Status__c;  
    }

}