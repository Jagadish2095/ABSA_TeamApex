/*
* Controller for populating DBS Dashboard front end
* @author Mhlangano Khumalo and Albie Le Grange
* @created date 2019-05-12
*/
public class DBS_Dashboard_Populate_Controller {
    private static final String devTokenValue = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBQk1TQVA1Iiwicm9sZSI6ImFkbWluLCB1c2VyIiwiZXhwIjoxNTc5NTI1MzkzfQ.bGNrrMFzvIrCSHztMXr2JDHr9YhtQlOoazqYwbfDyioic8J65G-D0f_U2MT5pVx1UqA1QLb9rt86P4hNRUeERA';
    
    @AuraEnabled
    public static List<String> postIIPHold(String ippObj) { 
    
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(ippObj);
        String iip_hold_action = (String) meta.get('iip_hold_action'); // 'cancel' / 'release'
        String queueItemTag = 'added_for_iip_'+iip_hold_action;
        
        String created_date = (String) meta.get('created_date');         
        String created_time = (String) meta.get('created_time');
         
        String source_account = (String) meta.get('source_account');
        String target_account = (String) meta.get('target_account');
        
        String amount = (String) meta.get('amount');
        String status_notes = (String) meta.get('status_notes');
        String user_number = (String) meta.get('user_number');
       
        String iip_action = 'R' ;
        if(iip_hold_action == 'cancel'){
              iip_action = 'C'; 
        } 

       
        
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');        
        List<String> responseList = new List<String>();       
        String endPoint,method,tokenVal,userName,contentType,baseURL = ''; 
        Integer statusValue = null;       
        String userAB = DBS_Dashboard_Populate_Controller.getUserId();
        HttpRequest httpRequest = new httpRequest();        
        Integration_API__c integrationInfo = [Select Name,Base_URL__c,Environment__c from Integration_API__c where Name = 'Jitterbit2'];           
        String environment =  integrationInfo.Environment__c;
        String iipObjJSON = null;
        //UAT JSON
        if(environment == '' || environment == null){
        iipObjJSON =  '{"iip_action": "'+iip_action+'","user_number": "'+user_number+'","created_date" : "'+created_date+'",  "created_time":"'+created_time+'", "source_account": "'+source_account+'", "amount" : "'+amount+'", "status_notes" : "'+status_notes+'", "target_account":"'+target_account+'"}';
        iipObjJSON =iipObjJSON.replace('\"','\\"');
        }
        //Prod JSON
        else{
        //iipObjJSONOld =  '{\'iip_action\':  \''+iip_action+'\',\'user_number\': \''+user_number+'\',\'created_date\' : \''+created_date+'\',  \'created_time\':\''+created_time+'\', \'source_account\': \''+source_account+'\', \'amount\' : \''+amount+'\', \'status_notes\' : \''+status_notes+'\', \'target_account\':\''+target_account+'\'}';
        iipObjJSON =  '{"iip_action": "'+iip_action+'","user_number": "'+user_number+'","created_date" : "'+created_date+'",  "created_time":"'+created_time+'", "source_account": "'+source_account+'", "amount" : "'+amount+'", "status_notes" : "'+status_notes+'", "target_account":"'+target_account+'"}';
        iipObjJSON = iipObjJSON.replace('\"','\\"');
        system.debug('-- iiip json: '+iipObjJSON);      
        }
        
        //
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard'); 
        
        //Pointing to Dev - checked
        if(environment == '' || environment == null){
             
            System.debug('System pointing to UAT');
            
            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            statusValue = 201;
            String keyValue = (String) meta.get('keyValue');
            String queueItemId = (String) meta.get('queueItemId');
  
            String accessAccountNumber = (String) meta.get('accessAccountNumber');            
            
            //String devToken =  (String) orgCache.get('devToken');
            String devToken = devTokenValue;
            if(devToken== null || devToken== ''){
                system.debug('error api manager token: '+devToken);
                responseList.add('Failure');
                responseList.add('Api manager token null, populate Platform cache with token using (devToken) as a key');      
                return responseList;                      
            }             
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            String url = auth.Base_URL__c;      
            httpRequest.setEndpoint(url); 
			httpRequest.setTimeout(30000); 	
            httpRequest.setMethod('POST'); 
            httpRequest.setHeader('Authorization', 'Bearer '+devToken);
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);  
            //String jsonStr = '{"keyValue": "' + accessAccountNumber + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+iipObjJSON +'","tag": "'+queueItemTag +'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
            String jsonStr = '{"keyValue": "' + accessAccountNumber + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+iipObjJSON +'","tag": "'+queueItemTag +'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}';  
            system.debug('JSON STRING::: '+jsonStr);
            
            httpRequest.setBody(jsonStr);
            
        }//Pointing to PROD
        else{
            System.debug('System pointing to production');            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');           
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');
                System.debug('Token Null Flow: '+jitterbitTokenVal);
            }             
   
            String keyValue = (String) meta.get('keyValue');
            String queueItemId = (String) meta.get('queueItemId');
    
            String accessAccountNumber = (String) meta.get('accessAccountNumber'); 
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            
            if(integrationServiceCheck.IsEmpty()){
                responseList.add('Failure');
                responseList.add('Authorise Jitterbit Service setting not found'); 
                return responseList;             
            }
            
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Create Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c; 
            
            baseURL = integrationInfo.Base_URL__c;
            endPoint = baseURL+urlExtension;
            
            httpRequest.setEndpoint(endPoint);
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod(method);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal);
            httpRequest.setHeader('User',userName);
            httpRequest.setHeader('Content-type',contentType);            
            
            //String jsonStr='{\\"keyValue\\":\\"' + accessAccountNumber + '\\",\\"abbotResource\\":{\\"resourceId\\":1312},\\"loaded\\":\\"' + dateOfPost  +'\\",\\"processName\\":\\"' + Label.DBS_Dive_ProcessName + '\\",\\"item_data\\":\\"' + accessAccountNumber +  '\\",\\"dat001\\": \\"'+iipObjJSON +'\\",\\"tag\\":\\"' + queueItemTag +  '\\",\\"createdBy\\":\\"'+ userAB +'\\",\\"status\\":{\\"code\\":0},\\"abbotResourceGroup\\":{\\"id\\":' + Label.abbotResourceGroupId + '},\\"abbotWorkQueue\\":{\\"id\\":' + Label.abbotWorkQueueId + '},\\"abbotProcess\\":{\\"processId\\":' + Label.abbotProcessId + '}}'; 
            
            httpRequest.setBody('{"keyValue": '+ keyValue +',"abbotResource": {"resourceId": 1312},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName +'","item_data": "'+accessAccountNumber +'","dat001": "'+iipObjJSON +'","tag": "' + queueItemTag +'","createdBy": "' + userAB +'","status":{"code": 0},"abbotResourceGroup": {"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue": {"id":'+ Label.abbotWorkQueueId +'},"abbotProcess": {"processId":'+ Label.abbotProcessId +'}}');
            //httpRequest.setBody('{"body": "' + jsonStr + '"');
            
        }  
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest); 
            System.debug('Status Code ==>' + httpResponse.getStatusCode() );  
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.add('Success');
                responseList.add(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));                    
                Map<String,Object> objectMap2  = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
                if(environment == '' || environment == null){//checked
                    responseList.add(httpResponse.getHeader('Location'));                    
                }else{
                    responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));
                }                  
                return responseList;  
            } else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.add('Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            }else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Timeout ==>' + httpResponse.getBody() );  
                responseList.add('Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            } else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getStatusCode()+' '+httpResponse.getBody() );  
            }  
            
        } 
        catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        }        
    }    
    
    @AuraEnabled
    public static List<String> saveNotesPost(String noteObj) { 
        String queueItemTag = 'added_for_ims_note';
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');        
        List<String> responseList = new List<String>();       
        String endPoint,method,tokenVal,userName,contentType,baseURL = ''; 
        Integer statusValue = null;       
        String userAB = DBS_Dashboard_Populate_Controller.getUserId();
        HttpRequest httpRequest = new httpRequest();        
        Integration_API__c integrationInfo = [Select Name,Base_URL__c,Environment__c from Integration_API__c where Name = 'Jitterbit2'];           
        String environment =  integrationInfo.Environment__c;
       
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard'); 
        
        //Pointing to Dev - checked
        if(environment == '' || environment == null){
             
            System.debug('System pointing to UAT');
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(noteObj);
            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            statusValue = 201;
            String keyValue = (String) meta.get('keyValue');
            String queueItemId = (String) meta.get('queueItemId');
            String notes = (String) meta.get('notes'); 
            String accessAccountNumber = (String) meta.get('accessAccountNumber');            
            
            //String devToken =  (String) orgCache.get('devToken');
            String devToken = devTokenValue;
            if(devToken== null || devToken== ''){
                system.debug('error api manager token: '+devToken);
                responseList.add('Failure');
                responseList.add('Api manager token null, populate Platform cache with token using (devToken) as a key');      
                return responseList;                      
            }             
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            String url = auth.Base_URL__c;      
            httpRequest.setEndpoint(url); 
			httpRequest.setTimeout(30000); 	
            httpRequest.setMethod('POST'); 
            httpRequest.setHeader('Authorization', 'Bearer '+devToken);
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);  
            //String jsonStr = '{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+notes+'","tag": "added_for_ims_note","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
            String jsonStr = '{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+notes+'","tag": "added_for_ims_note","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}';
            httpRequest.setBody(jsonStr);
            
        }
        //Pointing to PROD
        else{
            System.debug('System pointing to production');            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');           
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');
                System.debug('Token Null Flow: '+jitterbitTokenVal);
            }             
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(noteObj);
            List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
            String keyValue = (String) meta.get('keyValue');
            String queueItemId = (String) meta.get('queueItemId');
            String notes = (String) meta.get('notes'); 
            String accessAccountNumber = (String) meta.get('accessAccountNumber'); 
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            
            if(integrationServiceCheck.IsEmpty()){
                responseList.add('Failure');
                responseList.add('Authorise Jitterbit Service setting not found'); 
                return responseList;             
            }
            
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Create Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c; 
            
            baseURL = integrationInfo.Base_URL__c;
            endPoint = baseURL+urlExtension;
            
            httpRequest.setEndpoint(endPoint); 
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod(method);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal);
            httpRequest.setHeader('User',userName);
            httpRequest.setHeader('Content-type',contentType);            
            
            //String jsonStr='{\\"keyValue\\":\\"' + keyValue + '\\",\\"abbotResource\\":{\\"resourceId\\":1312},\\"loaded\\":\\"' + dateOfPost  +'\\",\\"processName\\":\\"' + Label.DBS_Dive_ProcessName + '\\",\\"item_data\\":\\"' + accessAccountNumber +  '\\",\\"dat001\\": \\"'+notes+'\\",\\"tag\\":\\"' + queueItemTag +  '\\",\\"createdBy\\":\\"'+ userAB +'\\",\\"status\\":{\\"code\\":0},\\"abbotResourceGroup\\":{\\"id\\":' + Label.abbotResourceGroupId + '},\\"abbotWorkQueue\\":{\\"id\\":' + Label.abbotWorkQueueId + '},\\"abbotProcess\\":{\\"processId\\":' + Label.abbotProcessId + '}}'; 
            httpRequest.setBody('{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 1312},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+notes+'","tag": "'+ queueItemTag +'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}');
           
    }  
        
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest); 
            System.debug('Status Code ==>' + httpResponse.getStatusCode() );  
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.add('Success');
                responseList.add(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));                    
                Map<String,Object> objectMap2  = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
                if(environment == '' || environment == null){//checked
                    responseList.add(httpResponse.getHeader('Location'));                    
                }else{
                    responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));
                }                  
                return responseList;  
            } else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.add('Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            }else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Timeout ==>' + httpResponse.getBody() );  
                responseList.add('Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            } else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getStatusCode()+' '+httpResponse.getBody() );  
            }  
            
        } 
        catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        }
    }    
    
    @AuraEnabled
    public static List<String> processRobotDataAction(String itemID, String robotAction, String actionType) {
        List<String> responseList = new List<String>();
        //actionType can be either get / upsert
        try{ 
            Robot_Data_Action__c action = (Robot_Data_Action__c) Json.deserialize(robotAction, Robot_Data_Action__c.class);
            if(itemID !='' && itemID !=NULL){
                if(actionType == 'upsert'){
                    upsert action Queue_Item_ID__c; 
                    responseList.add('Success');
                    responseList.add(String.valueOf(action));
                }
                if(actionType == 'get'){
                    Robot_Data_Action__c rda = [select id, Access_Account_Number__c, Action_Type__c, JSON__c, Queue_Item_ID__c, Robot_Item_Exception_Reason__c, Robot_Item_Status__c from Robot_Data_Action__c where Queue_Item_ID__c=: itemID];
                    responseList.add('Success');
                    responseList.add(String.valueOf(rda));
                }                        
            }
            return responseList;
        }catch(System.Exception e) {  
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList;         
        }
    }    
    
    @AuraEnabled
    public static List<String> postSimHold(String accessAccountNumber, String accountNumber, String userNumber, String keyValue) { 
        String queueItemTag = 'added_for_sim_hold_release';
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');
        List<String> responseList = new List<String>();        
        String endPoint,method,tokenVal,userName,contentType,baseURL = ''; 
        Integer statusValue = null;       
        String userAB = DBS_Dashboard_Populate_Controller.getUserId();
        HttpRequest httpRequest = new httpRequest();
        Integration_API__c integrationInfo = [Select Name,Environment__c,Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];         
        String environment =  integrationInfo.Environment__c;
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
        
        //Pointing to PROD - checked
        if(environment != '' && environment != null){           
            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');
                System.debug('Token Null Flow: '+jitterbitTokenVal);
            } 
            //Point to AbBot PROD
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            if(integrationServiceCheck.IsEmpty()){
                responseList.add('Failure');
                responseList.add('Authorise Jitterbit Service setting not found'); 
                return responseList;             
            }
            System.debug('Token ==>' + jitterbitTokenVal);
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Create Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c; 
            
            Integration_API__c integrationURL = [Select Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];
            baseURL = integrationURL.Base_URL__c; 
            endPoint = baseURL+urlExtension;
            
            httpRequest.setEndpoint(endPoint); 
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod(method);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal);
            httpRequest.setHeader('User',userName);
            httpRequest.setHeader('Content-type',contentType); 
            //String jsonStrOld='{\\"keyValue\\":\\"' + keyValue + '\\",\\"abbotResource\\":{\\"resourceId\\":1312},\\"loaded\\":\\"' + dateOfPost  +'\\",\\"processName\\":\\"' + Label.DBS_Dive_ProcessName + '\\",\\"item_data\\":\\"' + accessAccountNumber +  '\\",\\"dat001\\": \\"'+userNumber+'\\",\\"tag\\":\\"' + queueItemTag +  '\\",\\"createdBy\\":\\"'+ userAB +'\\",\\"status\\":{\\"code\\":0},\\"abbotResourceGroup\\":{\\"id\\":' + Label.abbotResourceGroupId + '},\\"abbotWorkQueue\\":{\\"id\\":' + Label.abbotWorkQueueId + '},\\"abbotProcess\\":{\\"processId\\":' + Label.abbotProcessId + '}}';
            httpRequest.setBody('{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 1312},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+userNumber+'","tag": "'+queueItemTag+'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}');
        }
        //Pointing to UAT
        else{
            statusValue = 201;
            String devToken =  devTokenValue;
            if(devToken == null || devToken == ''){
                system.debug('error api manager token: '+devToken);
                responseList.add('Failure');
                responseList.add('Api manager token null, populate Platform cache with token using (devToken) as a key');      
                return responseList;                      
            } 
            
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            String url = auth.Base_URL__c;              
            httpRequest.setEndpoint(url); 
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod('POST'); 
            httpRequest.setHeader('Authorization', 'Bearer ' + devToken);
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);     
            userAB = DBS_Dashboard_Populate_Controller.getUserId();
            String jsonStr = '{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+userNumber+'","tag": "'+queueItemTag+'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}';
            
            httpRequest.setBody(jsonStr);
        }
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.add('Success');
                responseList.add(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));                    
                Map<String,Object> objectMap2  = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
                if(environment == '' || environment == null)
                {
                    responseList.add(httpResponse.getHeader('Location'));//checked                    
                }
                else{
                    responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));
                } 
                responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));                   
                System.debug(' httpResponse body ==> '+httpResponse.getBody());
                return responseList;                     
            }else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.add('Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));                      
                return responseList;    
            } else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Timeout ==>' + httpResponse.getBody() );  
                responseList.add('Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            } else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getBody() );  
            }              
        } 
        catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        } 
    }     

   /* @AuraEnabled
    public static List<String> getToken(){
        List<String> responseList = new List<String>();
        try{
            String client_id = Label.DIVE_Client_ID;
            Integration_Service__c token = [Select Content_Type__c,Name,Method__c,Password__c,URL_Extension__c,Username__c from Integration_Service__c where name =: 'DIVEAuthToken'];
			System.debug(token);
            Http http = new Http(); 
            HttpRequest req = new HttpRequest(); 
            req.setTimeout(30000);
            req.setEndpoint(token.URL_Extension__c);
            req.setHeader('grant_type', 'password');
            req.setHeader('client_id', client_id);
            req.setHeader('username', token.Username__c);
            req.setHeader('password', token.Password__c);
            req.setHeader('Content-Type',token.Content_Type__c);
            req.setMethod(token.Method__c);
    
            String thebody = 'grant_type=password&client_id='+client_id+'&username='+token.Username__c+'&password='+token.Password__c;
            req.setBody(thebody);
            HttpResponse res = http.send(req);
            System.debug('client_id: '+client_id);
            System.debug('thebody: '+thebody);
       		System.debug('res.getBody(): '+res.getBody());
            
            Map<String, Object> deserializeObj = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String authToken = (string)deserializeObj.get('access_token');
            System.debug('token: '+authToken);
            if(Test.isRunningTest()){
                 authToken = 'testToken';
            }            
              
            system.debug(authToken);
            Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
            orgCache.put('devToken', authToken );
            orgCache.put('prodToken', authToken );
                                                                
            responseList.add('Success');
            responseList.add(authToken);
            return responseList;  
                           
        } catch( System.Exception e) {  
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        } 
    }*/
    
    @AuraEnabled
    public static List<String> getToken(){
        List<String> responseList = new List<String>();
        try{
            JitterbitAuthResponse auth = JitterbitAuth_IH_V1.authenticate2();
            String authToken = '';
            if(Test.isRunningTest()){
                 authToken = 'testToken';
            }            
            if(!Test.isRunningTest()){
             authToken = auth.token;
            }
            system.debug(authToken);
            Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
            orgCache.put('devToken', authToken );
            orgCache.put('prodToken', authToken );
                                                                
            responseList.add('Success');
            responseList.add(authToken);
            return responseList;  
                           
        } catch( System.Exception e) {  
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        } 
    }
    
    public class ResponseObj {
            @AuraEnabled public User userInfo{ get; set; }
       		@AuraEnabled public String supportValue{ get; set; }
            
           public ResponseObj (User userInfo, String supportValue){
            this.userInfo = userInfo;
            this.supportValue = supportValue;   
        }

        public ResponseObj() {}
    }         
    @AuraEnabled
    public static ResponseObj getUserInfo() { 
        User usr =  [select Name, Firstname, Lastname, Email, AB_Number__c ,Username, DBS_Dashboard_Do_Not_Show__c from User where Username =: UserInfo.getUserName()];
     	String getLabelName = Label.DBS_Support;   
        return new ResponseObj(usr, getLabelName); 
    }
    
    @AuraEnabled
    public static void saveUserInfo(Boolean popUpDisplay) { 
        try{
            User usr = new User(Id = userinfo.getuserId(), DBS_Dashboard_Do_Not_Show__c = popUpDisplay);
            update usr;
            
            if(Test.isRunningTest()){
                //Because User is a shared object, any error should be caught.
                if(popUpDisplay == false){
                    throw new CalloutException('An error occurred'); 
                }
            }
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    } 
    
    /*
* Method retrieves Robot Data record using the queue item id
* @author Mhlangano
* @param itemID
* @return Robot_Data_Retrieval__c list with 1 record
*/
    @AuraEnabled
    public static List<Robot_Data_Retrieval__c> getDataFromObject(String itemID) {    
        List<Robot_Data_Retrieval__c> data = [select Id,ID_Number__c, Robot_Item_Exception_Reason__c,IIP_JSON__c,Name, Access_Account_Number__c, Profile_JSON__c,Debit_Orders_JSON__c, Recent_Transactions_JSON__c, Call_History_JSON__c, Sim_Holds_JSON__c, Robot_Item_Status__c from Robot_Data_Retrieval__c where Name=: itemID LIMIT 1];
        if(!data.IsEmpty()){            
            if(data[0].Profile_JSON__c != NULL){
                string profileData = data[0].Profile_JSON__c.replace('\'','"');
                System.debug(profileData);
                Map<String,Object> objectMap = (Map<String,Object>)JSON.deserializeUntyped(profileData);
                String cleanedObject = String.valueOf(objectMap).replace('\'','"');
                System.debug(cleanedObject);  
                data[0].Profile_JSON__c = profileData; 
            }         
        }
        return data;
    } 
    /*
* Method creates Robot Data record
* @author Mhlangano
* @param itemID
* @return void
*/    
    
    @AuraEnabled
    public static void createQueueItemRecord(String itemID) { 
        system.debug('entered into QueueItem');
        if(itemID!=NULL && itemID!=''){       
            List<Robot_Data_Retrieval__c> robotDataRecord = [Select id , Name from Robot_Data_Retrieval__c where name =: itemID];
            if(robotDataRecord.IsEmpty()){
                Robot_Data_Retrieval__c data = new Robot_Data_Retrieval__c(Name=itemID);
                insert data;  
            }          
        }        
    } 
    
    /*
* Method to POST to AbBot and get queue item 
* @author Mhlangano and Albie
* @param Account Number or ID
* @return List<List> containing api response status, api response body and queue item id (Location).
*/ 
    @AuraEnabled
    public static List<String> postQueueItem(String accessAccount, String keyValue) { 
        String queueItemTag = 'added_for_data_retrieval_m';
        String userAB = DBS_Dashboard_Populate_Controller.getUserId();
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');
        String userName,method,contentType,baseURL,endPoint = '';
        Integer statusValue = null;   
        
        HttpRequest httpRequest = new httpRequest();
        List<String> responseList = new List<String>(); 
        
        if(keyValue== null || keyValue ==''){
            responseList.add('Failure');
            responseList.add('Ensure access account/ID Number is populated then try again');      
            return responseList;             
        }
        
        Integration_API__c integrationInfo = [Select Name,Environment__c, Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];      
        String environment =  integrationInfo.Environment__c;
        system.debug('enviro: '+environment);
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
        //Pointing to PROD - checked
        if (environment != '' && environment != null){           
            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');  
            System.debug(' prodToken token:: '+jitterbitTokenVal);
            statusValue = 200;
            if(jitterbitTokenVal == null){
                List<String> tokenObj = DBS_Dashboard_Populate_Controller.getToken();
                if(tokenObj.size()>0){
                    jitterbitTokenVal = tokenObj[1];    
                    System.debug(' prodToken is null flow: '+jitterbitTokenVal);
                }
            }
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            if(integrationServiceCheck.IsEmpty()){
                responseList.add('Failure');
                responseList.add('Authorise Jitterbit Service setting not found'); 
                return responseList;             
            }       
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Create Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c; 
             
            baseURL = integrationInfo.Base_URL__c; 
            endPoint = baseURL+urlExtension;
            httpRequest.setEndpoint(endPoint);
			httpRequest.setTimeout(30000); 	
            httpRequest.setMethod(method);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal);
            httpRequest.setHeader('User',userName);
            httpRequest.setHeader('Content-type',contentType);
            httpRequest.setBody('{"keyValue": '+ keyValue +',"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName +'","tag": "' + queueItemTag +'","createdBy": "' + userAB +'","status":{"code": 0},"abbotResourceGroup": {"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue": {"id":'+ Label.abbotWorkQueueId +'},"abbotProcess": {"processId":'+ Label.abbotProcessId +'}}');           
        }        
        //Pointing to UAT
        else{  
            statusValue = 201;
            
            //String devToken =  (String) sessionToken.get('devToken'); 
            //UAT token
            Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
            orgCache.put('devToken', devTokenValue);
            String devToken =  (String) orgCache.get('devToken');            
            //
            System.debug(' dev token:: '+devToken);
            if(devToken == null || devToken == ''){ 
                orgCache = Cache.Org.getPartition('local.DBSDashboard');                
                orgCache.put('devToken', devTokenValue);
            }
            
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            baseURL = auth.Base_URL__c;
            httpRequest.setEndpoint(baseURL);  
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod('POST');        
            httpRequest.setHeader('Authorization', 'Bearer ' + devToken);
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);
            httpRequest.setBody('{"keyValue":"' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded":"' + dateOfPost  +'","item_data":"'+accessAccount+'","processName":"' + Label.DBS_Dive_ProcessName + '","tag":"' + queueItemTag +  '","createdBy":"'+userAB+'","status":{"code":0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}');    
        }     
        try {  
            Http http = new Http();                
            HttpResponse httpResponse = http.send(httpRequest); 
            system.debug('getStatusCode-----------: '+httpResponse.getStatusCode());
            system.debug('getBody-----------------: '+httpResponse.getBody());
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.add('Success');
                responseList.add(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));                
                Map<String,Object> objectMap2  = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());                   
                if(environment != '' && environment != null){
                    responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));
                }else{
                    responseList.add(httpResponse.getHeader('Location'));
                } 
                System.debug(' httpResponse body ==> '+httpResponse.getBody());
                return responseList; 
            } else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.add('Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));                          
                return responseList;    
            }else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Timeout ==>' + httpResponse.getBody() );  
                responseList.add('Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            } else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getBody() );  
            }   
        } 
        catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            System.debug('ERROR MSG ==> '+ e.getMessage());
            System.debug('StatusCode');
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        } 
    }    
    
    /*
* Method to get user's full name
* @author Mhlangano + Albie
* @return full name
*/       
    
    @AuraEnabled
    public static String getUserId() { 
        User usr = [Select Id, Name, Email, BRID__c, AB_Number__c from User where Username =: UserInfo.getUserName()];        
        if(usr.AB_Number__c == null){
            usr.AB_Number__c = usr.BRID__c;
        }
        return usr.AB_Number__c;
    } 
    
    /*
* Method to get dashboard data from AbBot
* @author Albie
* @param queue item id
* @return List<List> containing api response status, api response body
*/    
    @AuraEnabled
    public static Map<String,String> getRestResponse(String itemID) {
        Map<String,String> responseList = new Map<String,String>();
        Integer itemIDint = Integer.valueOf(itemID);
        HttpRequest httpRequest = new httpRequest();        
        Integration_API__c integrationInfo = [Select Name,Environment__c,Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];          
        String environment =  integrationInfo.Environment__c;
        Integer statusValue = null;
        
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
        
        //Pointing to PROD
        if (environment != '' && environment != null){                
            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken'); 
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');
                System.debug('Token Null flow: '+jitterbitTokenVal);
            }
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            if(integrationServiceCheck.IsEmpty()){
                responseList.put('api_status','Failure');
                responseList.put('sf_message', 'Authorize Jitterbit integration service record not available');
                return responseList;             
            } 
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Get Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            String userName = integrationServiceData.Username__c;
            String method =  integrationServiceData.Method__c;
            String contentType =  integrationServiceData.Content_Type__c;
            
            String baseURL = integrationInfo.Base_URL__c; 
            String endPoint = baseURL+urlExtension + '/' + itemIDint;
            
            httpRequest.setEndpoint(endPoint);  
			httpRequest.setTimeout(30000); 				
            System.debug('endPoint ==>' + endPoint);
            httpRequest.setMethod(method);
            httpRequest.setHeader('Content-type',contentType);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal); 
            httpRequest.setHeader('User', userName);           
        }
        //Pointing to AbBot DEV
        else{ 
            
            //String devToken =  (String) sessionToken.get('devToken'); //rakesh
            //Dev token
            Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
            orgCache.put('devToken', devTokenValue);
            String devToken =  (String) orgCache.get('devToken');  
            //
            if(devToken == null || devToken == ''){
                system.debug('error api manager token: '+devToken);
                responseList.put('api_status','Failure');
                responseList.put('sf_message', 'Api manager token null, populate Platform cache with token using (devToken) as a key');   
                return responseList;                      
            }
            
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            statusValue = 200;
            String url = auth.Base_URL__c;
            String endPoint = url + '/' + itemIDint; 
            system.debug('@@@@@@@@endPoint'+endPoint);
            httpRequest.setEndpoint(endPoint);  
			httpRequest.setTimeout(30000); 				
            httpRequest.setMethod('GET');  
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);
            httpRequest.setHeader('Authorization', 'Bearer ' + devToken);  
        }
        try {  
            Http http = new Http();  
            HttpResponse httpResponse = http.send(httpRequest); 
            system.debug('getStatusCode-----------: '+httpResponse.getStatusCode());
            system.debug('getBody-----------------: '+httpResponse.getBody());
            if (httpResponse.getStatusCode() == statusValue ) {  
                responseList.put('api_status','Success');
                System.debug(' httpResponse body ==> '+httpResponse.getBody());
                responseList.put('full_dictionary', String.valueOf(httpResponse.getBody()));               
                Map<String,Object> objectMap = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
                String cleanedObject = String.valueOf(objectMap).replace('\'','"');                
                String dat001 = (String)objectMap.get('dat001'); 
                if (!String.isBlank(dat001)){
                    responseList.put('profile_data', dat001);
                    System.debug('Profile data found');
                }               
                String dat002 = (String)objectMap.get('dat002'); 
                if (!String.isBlank(dat002)){                    
                    responseList.put('debit_orders',dat002);
                    System.debug('debit orders data found');
                }
                String dat003 = (String)objectMap.get('dat003');                
                if (!String.isBlank(dat003)){                  
                    responseList.put('recent_transactions',dat003);
                    System.debug('recent transactions data found');
                }                
                String dat004 = (String)objectMap.get('dat004');                 
                if (!String.isBlank(dat004)){                    
                    responseList.put('call_history',dat004);
                    System.debug('call history data found');
                }                
                String dat005 = (String)objectMap.get('dat005');
                if (!String.isBlank(dat005)){                    
                    responseList.put('sim_holds',dat005);
                    System.debug('sim holds data found');
                }
                return responseList;                  
            } else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.put('api_status','Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                             
                responseList.put('sf_message', String.valueOf(errorMsg.Message));//change
                return responseList;   
            }  
            else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.put('api_status','Timeout'); 
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                             
                responseList.put('sf_message', String.valueOf(errorMsg.Message));//change
                return responseList;   
            }             
            else {  
                throw new CalloutException( httpResponse.getBody() );  
            } 
        } 
        catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            responseList.put('api_status','Failure');
            responseList.put('sf_message', e.getMessage());
            return responseList;
        } 
    } 
    
    
    /*
* Method to update SF with abBot response
* @author Albie
* @param JSON
* @return api response
*/         
    @AuraEnabled
    public static List<String> postToInboundService(String message) { 
        List<String> responseList = new List<String>();
        try{            
            String response = DBS_Dashboard_Inbound_Service.postMessage(message); 
            
            System.debug('Result of the post method call>>' + response);
            
            responseList.add('Success');
            responseList.add(response);
            return responseList;  
        }catch(Exception e){
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList;
        } 
    }   
    
    
    @AuraEnabled
    public static Map<String, String> getActionRestResponse(String itemID) { 
        Map<String, String> responseList = new Map<String,String>();
        Integer itemIDint = Integer.valueOf(itemID);
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');
        String userName,method,contentType,baseURL,endPoint = '';
        Integer statusValue = null;   
        HttpRequest httpRequest = new httpRequest();
        Integration_API__c integrationInfo = [Select Name,Environment__c,Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];           
        String environment =  integrationInfo.Environment__c;    
        
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
        
        //Point to PROD - checked
        if (environment != '' && environment != null){            
            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');                
            }  
            
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            if(integrationServiceCheck.IsEmpty()){
                responseList.put('api_status','Failure');
                responseList.put('business_exception','Authorize Jitterbit integration service record not available');
                return responseList;             
            }
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Get Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c;            
            
            baseURL = integrationInfo.Base_URL__c; 
            endPoint = baseURL+urlExtension + '/' + itemIDint; 
            httpRequest.setEndpoint(endPoint);
			httpRequest.setTimeout(30000); 	
            httpRequest.setMethod(method);
            httpRequest.setHeader('Content-type',contentType);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal); 
            httpRequest.setHeader('User', userName);
        }        
        else{
            
            String devToken =  devTokenValue;
            if(devToken == null || devToken == ''){
                system.debug('error api manager token: '+devToken);
                responseList.put('api_status','Failure');
                responseList.put('sf_message', 'Api manager token null, populate Platform cache with token using (devToken) as a key');   
                return responseList;                      
            } 
            
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            String url = auth.Base_URL__c;
            statusValue = 200;
            httpRequest.setEndpoint(url + '/' + itemIDint); 
			httpRequest.setTimeout(30000); 			
            System.debug('@@@@@@'+url+'/'+itemIDint);
            httpRequest.setMethod('GET');  
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);
            httpRequest.setHeader('Authorization', 'Bearer ' + devToken); 
        } 
        
        try{
            Http http = new Http();
            System.debug(' endpointurl ==> '+httpRequest.getEndpoint());
            System.debug(' requestBody ==> '+httpRequest.getBody());
            
            //initiate the actual call  
            HttpResponse httpResponse = http.send(httpRequest); 
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.put('api_status','Success');
                System.debug('---('+httpResponse.getBody()+')');
                String body = httpResponse.getBody();
                responseList.put('response_body', body);
                Map<String,Object> ResponseMap = (Map<String,Object>)JSON.deserializeUntyped(body);
                System.debug('map: -('+ResponseMap +')');
                String robotItemExceptionReason='';
                String status = JSON.serialize(ResponseMap.get('status')); 
                System.debug('map status: -('+status+')');
                Map<String, Object> status_map = (Map<String, Object>)JSON.deserializeUntyped(status);
                System.debug('status map: '+String.valueOf(status_map.get('code')));
                responseList.put('status_code', String.valueOf(status_map.get('code')));                
                
                //Exception reason tab
                if(ResponseMap.containsKey('more_data')){ 
                    robotItemExceptionReason=(String)ResponseMap.get('more_data');                                         
                }  
                responseList.put('business_exception',robotItemExceptionReason+'.');
                System.debug('res: '+responseList);              
                return responseList; 
                
            }else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.put('api_status','Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                             
                responseList.put('sf_message', String.valueOf(errorMsg.Message));//change              
                return responseList;    
            } else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.put('api_status','Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                             
                responseList.put('sf_message', String.valueOf(errorMsg.Message));//change
                return responseList;   
            }  else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getBody() );  
            }              
        } catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            responseList.put('api_status','Failure');
            responseList.put('business_exception', String.ValueOf(e.getMessage()));
            return responseList; 
        }                
    }    
    //API Response
    public class errorResponse {
        public String Message;
    }   
    
    @AuraEnabled
    public static List<String> postReverseDebitOrder(String debitObj) {             
        String queueItemTag = 'added_for_debit_order_reverse';
        Datetime currentDateTime = Datetime.now();        
        String dateOfPost = (string)currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss');        
        List<String> responseList = new List<String>();       
        String endPoint,method,tokenVal,userName,contentType,baseURL = ''; 
        Integer statusValue = null;       
        String userAB = DBS_Dashboard_Populate_Controller.getUserId();
        Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(debitObj);       
        String keyValue = (String) meta.get('keyValue');
        String accessAccountNumber = (String) meta.get('accessAccountNumber'); 
        String actionDate = (String) meta.get('debitActionDate');
        String debitType = (String) meta.get('debitType'); 
        String userSeq = (String) meta.get('debitUserSeq');         
        String debitReasonForReversal = (String) meta.get('debitReasonForReversal');  
        String amount = (String) meta.get('debitAmount'); 
        HttpRequest httpRequest = new httpRequest();        
        Integration_API__c integrationInfo = [Select Name,Environment__c,Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];           
        String environment =  integrationInfo.Environment__c;
        
        Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
        
        //Pointing to PROD - checked
        if(environment != '' && environment != null){           
            
            String jitterbitTokenVal =  (String) sessionToken.get('prodToken');
            statusValue = 200;
            if(jitterbitTokenVal == null){
                DBS_Dashboard_Populate_Controller.getToken();            
                jitterbitTokenVal =  (String) sessionToken.get('prodToken');
                System.debug('Token Null Flow: '+jitterbitTokenVal);
            } 
            list<Integration_Service__c> integrationServiceCheck = [Select Name, Password__c, URL_Extension__c, Username__c, Method__c,Content_Type__c from Integration_Service__c where Name = 'DBS DIVE Authorise Jitterbit'];       
            if(integrationServiceCheck.IsEmpty()){
                responseList.add('Failure');
                responseList.add('Authorise Jitterbit Service setting not found'); 
                return responseList;             
            }
            System.debug('Token ==>' + jitterbitTokenVal);
            Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Create Abbot Queue Item'];           
            String urlExtension =  integrationServiceData.URL_Extension__c;
            userName = integrationServiceData.Username__c;
            method =  integrationServiceData.Method__c;
            contentType =  integrationServiceData.Content_Type__c; 
            Integration_API__c integrationURL = [Select Base_URL__c from Integration_API__c where Name = 'Jitterbit2'];
            baseURL = integrationURL.Base_URL__c; 
            endPoint = baseURL+urlExtension;
            httpRequest.setEndpoint(endPoint);
			httpRequest.setTimeout(30000); 			
            httpRequest.setMethod(method);
            httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal);
            httpRequest.setHeader('User',userName);
            httpRequest.setHeader('Content-type',contentType);
            String jsonStr = '{\\"keyValue\\":\\"'+keyValue+'\\",\\"abbotResource\\":{\\"resourceId\\":1312},\\"loaded\\":\\"'+dateOfPost+'\\",\\"processName\\":\\"' + Label.DBS_Dive_ProcessName + '\\",\\"item_data\\":\\"'+accessAccountNumber+'\\",\\"dat001\\": \\"'+actionDate+'\\",\\"dat002\\": \\"'+amount+'\\",\\"dat003\\": \\"'+debitType+'\\",\\"dat004\\": \\"'+userSeq+'\\",\\"dat005\\": \\"'+debitReasonForReversal+'\\",\\"tag\\":\\"'+queueItemTag+'\\",\\"createdBy\\":\\"'+userAB+'\\",\\"status\\":{\\"code\\":0},\\"abbotResourceGroup\\":{\\"id\\":' + Label.abbotResourceGroupId + '},\\"abbotWorkQueue\\":{\\"id\\":' + Label.abbotWorkQueueId + '},\\"abbotProcess\\":{\\"processId\\":' + Label.abbotProcessId + '}}';
            httpRequest.setBody('{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 1312},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+actionDate+'","dat002": "'+amount+'","dat003": "'+debitType+'","dat004": "'+userSeq+'","dat005": "'+debitReasonForReversal+'","tag": "'+queueItemTag+'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}');
            //httpRequest.setBody('{"body": "' + jsonStr + '"');
        }
        //Pointing to UAT
        else{
            statusValue = 201;
            
            //String devToken =  (String) sessionToken.get('devToken');
            String devToken = devTokenValue;
            if(devToken == null || devToken == ''){
                system.debug('error api manager token: '+devToken);
                responseList.add('Failure');
                responseList.add('Api manager token null, populate Platform cache with token using (devToken) as a key');   
                return responseList;                      
            } 
            
            system.debug('api manager token: '+devToken);
            Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
            
            String url = auth.Base_URL__c;              
            httpRequest.setEndpoint(url); 
			httpRequest.setTimeout(30000); 			
            httpRequest.setMethod('POST'); 
            httpRequest.setHeader('Authorization', 'Bearer ' + devToken);
            httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
            httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
            httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);     
            userAB = DBS_Dashboard_Populate_Controller.getUserId();            
            //String jsonStr = '{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+actionDate+'","dat002": "'+amount+'","dat003": "'+debitType+'","dat004": "'+userSeq+'","dat005": "'+debitReasonForReversal+'","tag": "'+queueItemTag+'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup": {"id": 31},"abbotWorkQueue": {"id": 487},"abbotProcess": {"processId": 188}}';
            String jsonStr = '{"keyValue": "' + keyValue + '","abbotResource": {"resourceId": 10126},"loaded": "' + dateOfPost +'","processName": "' + Label.DBS_Dive_ProcessName + '","item_data": "'+accessAccountNumber +'","dat001": "'+actionDate+'","dat002": "'+amount+'","dat003": "'+debitType+'","dat004": "'+userSeq+'","dat005": "'+debitReasonForReversal+'","tag": "'+queueItemTag+'","createdBy": "'+userAB +'","status": {"code": 0},"abbotResourceGroup":{"id":'+ Label.abbotResourceGroupId +'},"abbotWorkQueue":{"id":'+ Label.abbotWorkQueueId +'},"abbotProcess":{"processId":'+ Label.abbotProcessId +'}}';
            httpRequest.setBody(jsonStr);
        } 
        try{
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest); 
            if (httpResponse.getStatusCode() == statusValue) {  
                responseList.add('Success');
                responseList.add(JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));                    
                Map<String,Object> objectMap2  = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
                if(environment != '' && environment != null){
                    responseList.add(String.valueOf(objectMap2.get('queueIdEnt')));
                }else{
                    responseList.add(httpResponse.getHeader('Location'));
                }                  
                return responseList;  
            } else if (httpResponse.getStatusCode() == 401 ) {  
                System.debug(' httpResponse exception Unauthorized ==>' + httpResponse.getBody() );  
                responseList.add('Unauthorized');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            }else if (httpResponse.getStatusCode() == 408 ) {  
                System.debug(' httpResponse exception Timeout ==>' + httpResponse.getBody() );  
                responseList.add('Timeout');
                errorResponse errorMsg = (errorResponse) System.JSON.deserialize(httpResponse.getBody(), errorResponse.class);                
                responseList.add(String.valueOf(errorMsg.Message));      
                return responseList;    
            } else {  
                System.debug(' httpResponse exception ==>' + httpResponse.getBody() );  
                throw new CalloutException( httpResponse.getStatusCode()+' '+httpResponse.getBody() );  
            }  
            
        } 
        catch( System.Exception e) {  
            System.debug('ERROR==> '+ e);
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList; 
        }  
    }
}