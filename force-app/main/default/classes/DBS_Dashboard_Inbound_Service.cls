/**
* Controller for Get an Account Details
* @author Rakesh
* @created date 2019-05-06
*/

@RestResource(urlMapping='/dbsdashboardapi/postdata/*')
global with sharing class DBS_Dashboard_Inbound_Service {
    @AuraEnabled
    public static List<Robot_Data_Retrieval__c> getDataRowAndPopulateFrontend(Boolean dataReceivedFromBot, String queuItemId) {
        system.debug('received from bot: ' + dataReceivedFromBot);
        List<Robot_Data_Retrieval__c> myRow = [SELECT Name, JSON_Data__c FROM Robot_Data_Retrieval__c WHERE Name = :queuItemId Limit 1];
        system.debug('dataRow: ' + myRow[0]);
        return myRow;
    }
    /**
* Method that gets a an user details
*     
* @return userid - logged in user id
*/
    @AuraEnabled
    public static String getUserId() { 
        String userId = UserInfo.getName();
        return userId;
    }
    /**
* Method that gets response from robot and save in the Robot_Data_Retrieval__c object
*     
* @param message - JSON
* @return - Success123
*/    
    @HttpPost
    @AuraEnabled
    global static String postMessage(string data) 
    {  
        String successmsg = 'Insertion failed because queue item id is not available';
        if(!String.IsBlank(data)){
            string JsonResponse=String.valueOf(data).replace('\'','"'); 
            system.debug('JsonResponse'+JsonResponse);
            if(!String.IsBlank(JsonResponse)){
                String Response = (String)JSON.serializePretty( JSON.deserializeUntyped(JsonResponse));
                system.debug('@@@@'+Response);
                Map<String,Object> ResponseMap=new Map<String,Object>();
                Map<String,Object> profileMap=new Map<String,Object>();
                Map<String,Object> debitOrderMap=new Map<String,Object>();
                Map<String,Object> recentTransactionMap=new Map<String,Object>();
                Map<String,Object> callHistoryMap=new Map<String,Object>();
                Map<String,Object> IIPMap=new Map<String,Object>();
                Map<String,Object> simHoldMap=new Map<String,Object>();
                Map<String, Object> dataMap=new Map<String, Object>(); 
                Integer queueId;
                String queue;
                String accountNumber;             
                String idNumber;
                Integer statuscodeId;                
                String robotItemTag;
                String robotItemExceptionReason;
                String JsonBody;
                Integer count=0;
                Integer counter=0;
                ResponseMap = (Map<String,Object>)JSON.deserializeUntyped(JsonResponse);
                if(ResponseMap.containsKey('access_account')){ 
                    accountNumber=(String)ResponseMap.get('access_account');
                }
                if(ResponseMap.containsKey('keyValue')){ 
                    idNumber=(String)ResponseMap.get('keyValue');
                }
                if(ResponseMap.containsKey('tag')){ 
                    robotItemTag=(String)ResponseMap.get('tag');                     
                }
                if(ResponseMap.containsKey('exceptionReasonTag')){ 
                    robotItemExceptionReason=(String)ResponseMap.get('exceptionReasonTag'); 
                    if(robotItemExceptionReason.contains('Business Exception:')){
                        robotItemExceptionReason = robotItemExceptionReason.remove('Business Exception:');
                    }
                }
                if(ResponseMap.containsKey('status_code')){ 
                    statuscodeId=(Integer)ResponseMap.get('status_code'); 
                   
                }
               if(ResponseMap.containsKey('queueIdEnt')){
                    queueId = (Integer)ResponseMap.get('queueIdEnt'); 
                    queue = String.valueOf(queueId);
                   // queue=(String)ResponseMap.get('queueIdEnt'); 
                }
                list<Robot_Data_Retrieval__c> recordAvailableCheck = [select Name from Robot_Data_Retrieval__c where Name = :queue LIMIT 1];
                  
                     if(!recordAvailableCheck.IsEmpty() && (robotItemExceptionReason != null || robotItemExceptionReason !='None') )
                        {
                            Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                            robotDataUpdate.Access_Account_Number__c = accountNumber; 
                            robotDataUpdate.ID_Number__c = idNumber;
                            robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                            robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;                              
                            robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                            update robotDataUpdate; 
                        }   
                
                if(ResponseMap.containsKey('profile_data')){                    
                    dataMap=(Map<String,Object>)ResponseMap.get('profile_data');
                
                    if(ResponseMap.containsKey('queueIdEnt')){                        
                        JsonBody='{';
                        if(ResponseMap.containsKey('profile_data')){
                            profileMap=(Map<String, Object>)ResponseMap.get('profile_data');
                            for(String key : profileMap.keySet()){
                                JsonBody+='"'+key+'" :"'+profileMap.get(key)+'",';          
                            }
                            JsonBody = JsonBody.removeEnd(',');
                        } 
                        JsonBody+='}';
                        if(!recordAvailableCheck.IsEmpty())
                        {
                            successmsg = 'Profile data Inserted';
                            Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];                            
                            robotDataUpdate.Access_Account_Number__c = accountNumber; 
                            robotDataUpdate.ID_Number__c = idNumber;
                            robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                            robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason; 
                            robotDataUpdate.Profile_JSON__c=JsonBody; 
                            robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                            update robotDataUpdate; 
                        }                                         
                    }  
                }
                //end Profile data insertion
                //Debit Order data insertion
                else if(ResponseMap.containsKey('debit_orders')){
          
                    debitOrderMap=(Map<String, Object>)ResponseMap.get('debit_orders');                    
                    JsonBody='{';
                    dataMap=(Map<String,Object>)ResponseMap.get('debit_orders');                    
                    for(String key : debitOrderMap.keySet()){                       
                        dataMap=new Map<String, Object>();
                        dataMap=(Map<String, Object>)debitOrderMap.get(key);                        
                        system.debug('dataMapsize'+debitOrderMap.size());
                        //froming of json                       
                        String Value='{';   
                        count=0;
                        counter=0;
                        for(String Key1 : dataMap.keySet()){
                            Value += '"'+Key1+'":"'+dataMap.get(Key1)+'"';
                            //count
                            if(count < dataMap.Size()-1){
                                Value +=','; 
                                count=count+1;
                            }    
                        }
                        Value+='}';                        
                        JsonBody+='"'+key+'" :'+Value;
                        if(counter < debitOrderMap.Size()-1){
                            JsonBody+=',';
                            counter=counter+1;  
                        }                        
                    }
                    JsonBody = JsonBody.removeEnd(',');
                    JsonBody+='}';                                      
                   
                    if(!recordAvailableCheck.IsEmpty())
                    {                        
                        successmsg = 'Debit Orders data Inserted';
                        Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                        robotDataUpdate.Access_Account_Number__c = accountNumber; 
                        robotDataUpdate.ID_Number__c = idNumber;
                        robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                        robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;
                        robotDataUpdate.Debit_Orders_JSON__c=JsonBody;
                        robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                        update robotDataUpdate; 
                    }              
                }  
                //end Debit Order
                
                //Recent Transactions data insertion
                else if(ResponseMap.containsKey('recent_transactions')){
         
                    recentTransactionMap=(Map<String, Object>)ResponseMap.get('recent_transactions');                    
                    JsonBody='{';
                    dataMap=(Map<String,Object>)ResponseMap.get('recent_transactions');                    
                    for(String key : recentTransactionMap.keySet()){                       
                        dataMap=new Map<String, Object>();
                        dataMap=(Map<String, Object>)recentTransactionMap.get(key);                        
                        system.debug('dataMapsize'+recentTransactionMap.size());
                        //froming of json                       
                        String Value='{';  
                        count=0;
                        counter=0;
                        for(String Key1 : dataMap.keySet()){                            
                            Value += '"'+Key1+'":"'+dataMap.get(Key1)+'"';
                            //count
                            if(count < dataMap.Size()-1){
                                Value +=','; 
                                count=count+1;
                            }    
                        }
                        Value+='}';                        
                        JsonBody+='"'+key+'" :'+Value;
                        if(counter < recentTransactionMap.Size()-1){
                            JsonBody+=',';
                            counter=counter+1;  
                        }                        
                    }
                    JsonBody = JsonBody.removeEnd(',');
                    JsonBody+='}';                   
                    if(!recordAvailableCheck.IsEmpty())
                    { 
                        successmsg = 'Recent Transactions data Inserted';
                        Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                        robotDataUpdate.Access_Account_Number__c = accountNumber; 
                        robotDataUpdate.ID_Number__c = idNumber;
                        robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                        robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;
                        robotDataUpdate.Recent_Transactions_JSON__c=JsonBody;
                        robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                        update robotDataUpdate; 
                    }               
                } 
                //end Recent Transactions
                
                //History data insertion
                else if(ResponseMap.containsKey('call_history')){   
                    system.debug('Call@@@@@@@@@@@@@@@@@@@@@@');
                    callHistoryMap=(Map<String, Object>)ResponseMap.get('call_history');                    
                    JsonBody='{';
                    dataMap=(Map<String,Object>)ResponseMap.get('call_history');                    
                    for(String key : callHistoryMap.keySet()){                       
                        dataMap=new Map<String, Object>();
                        dataMap=(Map<String, Object>)callHistoryMap.get(key);                        
                        system.debug('dataMapsize'+callHistoryMap.size());
                        //froming of json                       
                        String Value='{';  
                        count=0;
                        counter=0;
                        for(String Key1 : dataMap.keySet()){
                            Value += '"'+Key1+'":"'+dataMap.get(Key1)+'"';
                            //count
                            if(count < dataMap.Size()-1){
                                Value +=','; 
                                count=count+1;
                            }    
                        }
                        Value+='}';                        
                        JsonBody+='"'+key+'" :'+Value;
                        if(counter < callHistoryMap.Size()-1){
                            JsonBody+=',';
                            counter=counter+1;  
                        }                        
                    }
                    JsonBody = JsonBody.removeEnd(',');
                    JsonBody+='}';
                    if((!recordAvailableCheck.IsEmpty()) && (ResponseMap.containsKey('call_history')))
                    { 
                        successmsg = 'Call History data Inserted';
                        Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                        robotDataUpdate.Access_Account_Number__c = accountNumber; 
                        robotDataUpdate.ID_Number__c = idNumber;
                        robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                        robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;
                        robotDataUpdate.Call_History_JSON__c=JsonBody;
                        robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                        update robotDataUpdate; 
                    }  
                     if(ResponseMap.containsKey('iip_transactions')){ 
                    system.debug('IIP@@@@@@@@@@@@@@@@@@@@@@');
                    //started for IIP Json
                    IIPMap= (Map<String, Object>)ResponseMap.get('iip_transactions'); 
                    JsonBody = null;
                    JsonBody='{';
                    dataMap=(Map<String,Object>)ResponseMap.get('iip_transactions'); 
                    for(String key : IIPMap.keySet()){                       
                        dataMap=new Map<String, Object>();
                        dataMap=(Map<String, Object>)IIPMap.get(key);                        
                        system.debug('dataMapsize'+IIPMap.size());
                        //froming of json                       
                        String Value='{';  
                        count=0;
                        counter=0;
                        for(String Key1 : dataMap.keySet()){
                            Value += '"'+Key1+'":"'+dataMap.get(Key1)+'"';
                            //count
                            if(count < dataMap.Size()-1){
                                Value +=','; 
                                count=count+1;
                            }    
                        }
                        Value+='}';                        
                        JsonBody+='"'+key+'" :'+Value;
                        if(counter < IIPMap.Size()-1){
                            JsonBody+=',';
                            counter=counter+1;  
                        }                        
                    }
                    JsonBody = JsonBody.removeEnd(',');
                    JsonBody+='}';                   
                    system.debug('QQQQQQQQ'+JsonBody);
                    //ended for IIP
                    }
                    
                    if((!recordAvailableCheck.IsEmpty()))
                    { 
                        successmsg = 'IIP transactions data Inserted';
                        Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                        robotDataUpdate.Access_Account_Number__c = accountNumber; 
                        robotDataUpdate.ID_Number__c = idNumber;
                        robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                        robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;
                        robotDataUpdate.IIP_JSON__c=JsonBody;
                        robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                        update robotDataUpdate; 
                    } 
                } 
                //end History 
                
                //Sim Hold insertion 
                else if(ResponseMap.containsKey('sim_holds')){      
                  
                    simHoldMap=(Map<String, Object>)ResponseMap.get('sim_holds');                    
                    JsonBody='{';
                    dataMap=(Map<String,Object>)ResponseMap.get('sim_holds');                    
                    for(String key : simHoldMap.keySet()){                       
                        dataMap=new Map<String, Object>();
                        dataMap=(Map<String, Object>)simHoldMap.get(key);
                        //froming of json                       
                        String Value='{';  
                        count=0;
                        counter=0;
                        for(String Key1 : dataMap.keySet()){
                            Value += '"'+Key1+'":"'+dataMap.get(Key1)+'"';
                            //count
                            if(count < dataMap.Size()-1){
                                Value +=','; 
                                count=count+1;
                            }    
                        }
                        Value+='}';                        
                        JsonBody+='"'+key+'" :'+Value;
                        if(counter < simHoldMap.Size()-1){
                            JsonBody+=',';
                            counter=counter+1;  
                        }                        
                    }
                    JsonBody = JsonBody.removeEnd(',');
                    JsonBody+='}';                    
                    if(!recordAvailableCheck.IsEmpty())
                    { 
                        successmsg = 'sim Holds data Inserted';
                        Robot_Data_Retrieval__c robotDataUpdate = [Select Name from Robot_Data_Retrieval__c where Name = :queue];
                        robotDataUpdate.Access_Account_Number__c = accountNumber; 
                        robotDataUpdate.ID_Number__c = idNumber;
                        robotDataUpdate.Robot_Item_Tag__c = robotItemTag;
                        robotDataUpdate.Robot_Item_Exception_Reason__c = robotItemExceptionReason;
                        robotDataUpdate.Sim_Holds_JSON__c=JsonBody;
                        robotDataUpdate.Robot_Item_Status__c = statuscodeId;
                        system.debug('StatusCode--------' + statuscodeId);
                        update robotDataUpdate; 
                    }               
                } 
                //end Sim Hold
            }
        }
        
        return 'Success: ' +  successmsg; 
    }
}