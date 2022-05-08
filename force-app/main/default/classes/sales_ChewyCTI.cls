/*
* Controller for facilitating user actions on phone device
* @author Mhlangano Khumalo
* @created date 17 Aug 2020
*/
 
public class sales_ChewyCTI {    
 
    @AuraEnabled
    public static List <String> login(String userId, String stationId, String saveStationId) {
 		   List <String> resList = new List <String>();
            System.debug('userId: ' + userId + ' -- stationId: ' + stationId + ' -- saveStationId: ' + saveStationId);
			String bodyStr = '{"requestType":"LOGIN_REQ","originatingSystem":"string","userId":"' + userId + '","channel":"string","stationId":"' + stationId + '"}';            
            resList = sales_ChewyCTI.APICallout( 'login', 'POST', bodyStr);

            if (saveStationId == string.valueOf(saveStationId)) {
                User u = new User(Id = UserInfo.getUserId(), Station_ID__c = stationId);
                update u;
                system.debug('User:  ' + u);
            }   
            return resList;    
    }

    @AuraEnabled
    public static List <String> changeAgentStatus(String userId, String stationId, String agentId, String auxCode, String agentStatus) {
        	List <String> resList = new List <String>();    
            system.debug('userId: ' + userId + '. stationId: ' + stationId + '. agentId: ' + agentId + '. auxCode: ' + auxCode + '. agentStatus: ' + agentStatus);
            String bodyStr = '{"agentId": "' + agentId + '","agentStatus": "' + agentStatus + '","auxCode": "' + auxCode + '","channel": "string","originatingSystem": "string","requestType": "AGENT_STATUS_CHANGE_REQ","userId": "' + userId + '"}';    
            resList = sales_ChewyCTI.APICallout( 'agent-status-change', 'POST', bodyStr);           
            return resList;  
    }
    
    @AuraEnabled
    public static List <String> acceptContact(String userId, String agentId) {
        List <String> resList = new List <String>(); 
        System.debug('userId: ' + userId + ' -- agentId: ' + agentId);
        String bodyStr = '{"requestType": "ACCEPT_CONTACT_REQ","originatingSystem": "string","userId": "' + userId + '","channel": "string","connectionId": "0","agentId": "' + agentId + '"}';
		resList = sales_ChewyCTI.APICallout( 'accept-contact', 'POST', bodyStr);            
        return resList;
    }

    @AuraEnabled
    public static List <String> closeContact(String userId, String agentId) {        
        List <String> resList = new List <String>(); 
        System.debug('userId: ' + userId + ' -- agentId: ' + agentId);
        String bodyStr = '{"requestType": "CLOSE_CONTACT_REQ","originatingSystem": "string","userId": "' + userId + '","channel": "string","connectionId": "0","agentId": "' + agentId + '"}';
		resList = sales_ChewyCTI.APICallout( 'closecontact', 'POST', bodyStr);            
        return resList;
    }

    @AuraEnabled
    public static List <String> logout(String userId, String stationId, String agentPin) {
		List <String> resList = new List <String>(); 
        System.debug('userId: ' + userId + ' -- stationId: ' + stationId + ' -- agentPin: ' + agentPin);
      
		String bodyStr = '{"requestType": "LOGOUT_REQ","originatingSystem": "string","userId": "' + userId + '","agentId": "' + agentPin + '","channel": "string","stationId": "' + stationId + '"}';
		resList = sales_ChewyCTI.APICallout( 'logout', 'POST', bodyStr);            
        return resList;       
    }

    @AuraEnabled
    public static List <String> onHold(String agentId, String connectionId, String stationId, String toggleInd, String userId) {
		List <String> resList = new List <String>(); 
        System.debug('agentId: ' + agentId + ' connectionId: ' + connectionId + ' stationId: ' + stationId + ' toggleInd: ' + toggleInd + ' userId: ' + userId);
       
		String bodyStr = '{"requestType": "TOGGLE_CONTACT_ONHOLD_REQ","originatingSystem": "string","userId": "' + userId + '","channel": "string","agentId": "' + agentId + '","connectionId": "' + connectionId + '","stationId": "' + stationId + '","toggleInd": "' + toggleInd + '"}';
		resList = sales_ChewyCTI.APICallout('on-hold', 'POST', bodyStr);            
        return resList;  
    }

    @AuraEnabled
    public static List <String> agentStatus(String agentId, String userId) {        
		List <String> resList = new List <String>(); 
        System.debug('agentId: ' + agentId + ' userId: ' + userId);
       
		String bodyStr = '{"userId": "' + userId + '","agentId": "' + agentId + '"}';
		resList = sales_ChewyCTI.APICallout('agent-status', 'POST', bodyStr);            
        return resList;  
    }
    
    @AuraEnabled
    public static List <String> clientProfiles(String agentId, String customerIdNumber, String progression, String requesterId, String servicingCif, String sessionId) {
        /*
            {
              "agentId": "string",
              "customerIdNumber": "string",
              "progression": "string",
              "requesterId": "string",
              "servicingCif": "string",
              "sessionId": "string"
            }
		*/
        return null;
    }
    
   /* @AuraEnabled
    public static String auth() {
        Cache.OrgPartition orgCache = Cache.Org.getPartition('local.Chewy');

        String devToken = (String) orgCache.get('devToken');
        String tokenTime = (String) orgCache.get('tokenTime');

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(30000);
        req.setEndpoint('https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/auth/token');
        req.setHeader('grant_type', 'password');
        req.setHeader('client_id', 'salesforce-api');
        req.setHeader('username', 'salesforce');
        req.setHeader('password', 'P@ssword01');
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');

        String thebody = 'grant_type=password&client_id=salesforce-api&username=salesforce&password=P@ssword01';
        req.setBody(thebody);

        HttpResponse res;
        String authToken;
        Long minutesElapsed = 0;

        //Calculate minutes in numbers
        if (tokenTime != null) {
            DateTime timeVal = DateTime.valueOf(tokenTime);
            DateTime timeNow = System.now();
            Long timeNum = (timeNow.getTime() - timeVal.getTime()) / 60000;
            minutesElapsed = timeNum;
        }

        System.debug('Minutes Elapsed::: ' + minutesElapsed);

        if (devToken == null || tokenTime == null || minutesElapsed > 58) { // also add that if time has expired
            res = http.send(req);
            Map <String,
                Object > deserializeObj = (Map <String, Object > ) JSON.deserializeUntyped(res.getBody());
            authToken = (string) deserializeObj.get('access_token');

            orgCache.put('devToken', authToken);
            DateTime currTime = System.now();
            orgCache.put('tokenTime', String.valueOf(currTime));
            system.debug('If part::: ' + authToken);
            system.debug('date::: ' + tokenTime);
        } else {
            authToken = devToken;
            system.debug('Else part::: ' + devToken);
            system.debug('date::: ' + tokenTime);
        }
        return authToken;
    }*/
    
    public static List <String> APICallout(String urlExt, String method, String body) {
        List <String> responseList = new List <String>();
        try {                	
        	//String token = DBS_Dashboard_chewy.auth();
            String token = '';
            if(Test.isRunningTest()){
                 token = 'testToken';
            }            
            if(!Test.isRunningTest()){
             	token = sales_DashboardController.auth();
            }
            
   			Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setTimeout(30000);
            request.setEndpoint(Label.sales_ChewyEndpoint+urlExt); 
            System.debug(' endpoints ----- '+Label.sales_ChewyEndpoint+urlExt);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            request.setMethod(method);
            request.setHeader('User', 'DIVE');
            request.setHeader('Authorization', 'Bearer ' + token);

            request.setBody(body);
            HttpResponse response = http.send(request); 
        
            responseList.add('Success');  // 0                        
       	 	responseList.add(response.getBody()); // 1    
        	responseList.add(JSON.serialize(response.getStatusCode()));   // 2          	
        	responseList.add(response.getStatus()); //3   
        
        	System.debug('\n API Name: '+urlExt+'\n getStatusCode: ' + response.getStatusCode()+ '\n getStatus: '+response.getStatus()+'\n getBody: '+response.getBody());
        	return responseList;
		}catch (Exception e) {
            System.debug('ERROR==> ' + e);
            responseList.add('Failure');
            responseList.add(e.getMessage());
            return responseList;
        }            
    }
    
}