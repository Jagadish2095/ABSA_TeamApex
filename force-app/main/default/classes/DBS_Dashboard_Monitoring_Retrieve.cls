global class DBS_Dashboard_Monitoring_Retrieve implements Database.Batchable<sObject>, Schedulable,Database.AllowsCallouts{
  
    global Iterable<sObject> start(Database.Batchablecontext BC){
     String query = 'SELECT Id, Name, BotName__c, QueueId__c, Status__c from DBS_Monitoring_Robots__c';
     return Database.getQueryLocator(query); 
  } 
    
  global void execute(Database.BatchableContext BC, List<sObject> scope){ 
      String msg;
	  Datetime currentDateTime = Datetime.now();        
      String dateOfPost = (string)currentDateTime.format('dd-MM-yyyy\' \'HH:mm:ss');
      
      List<DBS_Monitoring_Robots__c> botList = new List<DBS_Monitoring_Robots__c>();
      List<string> failedBots = new List<String>();
      Integration_API__c integrationInfo = [Select Name,Environment__c,Base_URL__c from Integration_API__c where Name = 'Jitterbit'];          
      String environment =  integrationInfo.Environment__c;
		system.debug('Enviro var: '+environment);
      Cache.OrgPartition sessionToken = Cache.Org.getPartition('local.DBSDashboard');
      List<DBS_Monitoring_Robots__c> getQueueIds = [SELECT Id, QueueId__c FROM DBS_Monitoring_Robots__c];
      Integer totalBots =  getQueueIds.size();
      double sum = totalBots;
      Integer workingBots = 0,notWorkingBots = 0,percentageOfBotsRunning = 0;
      Boolean insertedSfObject = false;  
      String contentType,baseURL,endPoint,url = '';
      Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'Api Manager'];
      HttpRequest httpRequest = new httpRequest(); 
    
      //Pointing to Dev 
      if(environment == '' || environment == null){        
         try {             
            for(DBS_Monitoring_Robots__c a : getQueueIds){
                string itemIDint = a.QueueId__c;
                url = auth.Base_URL__c;
                endPoint = url + '/' + itemIDint; 
     
                httpRequest.setEndpoint(endPoint); 
                httpRequest.setMethod('GET'); 
                httpRequest.setHeader('content-type', 'application/json; charset=utf-8');
                httpRequest.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
                httpRequest.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c);
                httpRequest.setHeader('Authorization', 'Bearer ' + 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJBQk1TQVA1Iiwicm9sZSI6ImFkbWluLCB1c2VyIiwiZXhwIjoxNTczOTEwMjE3fQ.10vklHu-sOes-xaHLbrYjZnOJlY65eVJd5kAjeom1G9gWULlWlNiRCvP6rZd98zaeB1UPpkAcQN3D2Uc1rm_0w');
                Http http = new Http();
                HttpResponse httpResponse = http.send(httpRequest);
                if (httpResponse.getStatusCode() == 200 ) {                      
                    insertedSfObject = true;
                    String fullJsonObj = httpResponse.getBody();
                    Map<String, Object> outputJsonBody = (Map<String, Object>) JSON.deserializeUntyped(fullJsonObj);                    
                    string JsonResponse= (JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));
                    string JsonResponsePretty = string.valueOf(JsonResponse);
                    String botName = String.valueOf(outputJsonBody.get('dat005'));
                    Map<String, Object> statusId = (Map<String, Object>) outputJsonBody.get('status');
                    Integer responseStatus_code = Integer.valueOf(statusId.get('code'));
                    if(responseStatus_code != 4){
                        failedBots.add(botName);
                        notWorkingBots = notWorkingBots+1;
                    }
                    else{
                        workingBots = workingBots+1;
                    }
                    list<DBS_Monitoring_Robots__c> recordAvailableCheck = [select QueueId__c from DBS_Monitoring_Robots__c where QueueId__c = :itemIDint LIMIT 1];
                    if(!recordAvailableCheck.IsEmpty())
                    {                       
                        DBS_Monitoring_Robots__c robotDataUpdate = [Select QueueId__c from DBS_Monitoring_Robots__c where QueueId__c = :itemIDint];
                        robotDataUpdate.JSON__c = JsonResponsePretty;
                        robotDataUpdate.Status__c = responseStatus_code;
                        botList.add(robotDataUpdate);           
                    }                    
                }                
            }           
            percentageOfBotsRunning = ((workingBots / sum) * 100).intValue();
            upsert botList;
        }
        catch(Exception e){           
            System.debug('Errors:: ' + e);
        }   
      }
      //Pointing to PROD
      else{                   
          DBS_Dashboard_Populate_Controller.getToken();
          String jitterbitTokenVal =  (String) sessionToken.get('prodToken');  
          Integration_Service__c integrationServiceData = [Select URL_Extension__c, Username__c, Method__c, Content_Type__c from Integration_Service__c where Name = 'Get Abbot Queue Item'];           
          String urlExtension =  integrationServiceData.URL_Extension__c;
          String userName = integrationServiceData.Username__c;
          String method =  integrationServiceData.Method__c;
          contentType =  integrationServiceData.Content_Type__c;          
          baseURL = integrationInfo.Base_URL__c; 
          url = baseURL+urlExtension;
         
         try {              
            for(DBS_Monitoring_Robots__c a : getQueueIds){
                string itemIDint = a.QueueId__c;               
                endPoint = url + '/' + itemIDint;
				                
                httpRequest.setEndpoint(endPoint); 
                httpRequest.setMethod(method); 
                httpRequest.setHeader('content-type', contentType);
                httpRequest.setHeader('Authorization', 'Bearer ' + jitterbitTokenVal); 
                httpRequest.setHeader('User', userName);
                Http http = new Http();
                HttpResponse httpResponse = http.send(httpRequest);
  				System.debug('dfdfdfd ' + httpResponse.getStatusCode());                
                if (httpResponse.getStatusCode() == 200 ) { 
                    insertedSfObject = true;
                    String fullJsonObj = httpResponse.getBody();
                    Map<String, Object> outputJsonBody = (Map<String, Object>) JSON.deserializeUntyped(fullJsonObj);                    
                    string JsonResponse= (JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody())));
                    string JsonResponsePretty = string.valueOf(JsonResponse);
                    String botName = String.valueOf(outputJsonBody.get('dat005'));   
                    Map<String, Object> statusId = (Map<String, Object>) outputJsonBody.get('status');
                    Integer responseStatus_code = Integer.valueOf(statusId.get('code'));
                    if(responseStatus_code != 4){
                        failedBots.add(botName);
                        notWorkingBots = notWorkingBots+1;
                      
                    }
                    else{
                        workingBots = workingBots+1;
                    }
                    list<DBS_Monitoring_Robots__c> recordAvailableCheck = [select QueueId__c from DBS_Monitoring_Robots__c where QueueId__c = :itemIDint LIMIT 1];
                    if(!recordAvailableCheck.IsEmpty())
                    {                       
                        DBS_Monitoring_Robots__c robotDataUpdate = [Select QueueId__c from DBS_Monitoring_Robots__c where QueueId__c = :itemIDint];
                        robotDataUpdate.JSON__c = JsonResponsePretty;
                        robotDataUpdate.Status__c = responseStatus_code;
                        botList.add(robotDataUpdate);           
                    }                    
                }                
            }           
            percentageOfBotsRunning = ((workingBots / sum) * 100).intValue();
            upsert botList;
            //methodName(---)
        }
        catch(Exception e){           
            System.debug('Errors::: '+e);
        } 
      }
    
      if(insertedSfObject == true)
        {
            if(failedBots.size() == 0)
            {
                failedBots.add('0');
            }
            DateTime dt = DateTime.now();
            String timeFormat = dt.format('kk');
            Integer timeSlot = integer.ValueOf(timeFormat);
            String notifyList = System.Label.DBS_Dashboard_Notify_Times;            
            List<String> notifyTimes = notifyList.split(',');
            if((timeSlot >= Integer.valueof(notifyTimes[0]) && timeSlot < Integer.valueof(notifyTimes[1])))
            {   
                msg = workingBots + '/' + totalBots + ' bots running. Bots not running: ' +failedBots +' contact dive team at: dive@absa.africa';     

            }
            else if(percentageOfBotsRunning <= 50)
            {
                     
                msg = workingBots + '/' + totalBots + ' bots running. Bots not running:- ' +failedBots +' contact dive team at: dive@absa.africa';    
            }            
        }
      else
      {     
          msg = 'Something went wrong please check the database or jitterbit: ' + 'contact Cassius Malepe at: cassius.malepe@absa.africa';    
      }
      
      DBS_Monitoring_Result__c resultsObj = New DBS_Monitoring_Result__c();
      
      resultsObj.trigger_date_time__c = dateOfPost;
      resultsObj.result__c = msg;
      upsert resultsObj;
      List<DBS_Monitoring_Result__c> resultsList = [select trigger_date_time__c, result__c from DBS_Monitoring_Result__c ORDER BY CreatedDate DESC LIMIT 5];
  }
    
     global void finish(Database.BatchableContext info){
        
  }
    
  global void execute(SchedulableContext SC) {
      DBS_Dashboard_Monitoring_Retrieve b = new DBS_Dashboard_Monitoring_Retrieve();
      database.executebatch(b);
  }
    
}