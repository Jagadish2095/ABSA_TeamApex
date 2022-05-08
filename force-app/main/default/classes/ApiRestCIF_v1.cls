/**
* 
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-08-15
*
**/
public class ApiRestCIF_v1 {

    public static String BASE_ENDPOINT = '';
    public static String OPERATION_GETALLVIEWS = '';
    public static String OPERATION_GETCLIENTS = '';
    public static Integer TIMEOUT = 0;
    public static String X_IBM_Client_Id = ''; 
    public static String X_IBM_Client_Secret = ''; 
    public static String REGID_FIELD = '';
    public static String QUERYTYPE_FIELD = '';
    public static String CIB_VIEW = '';
    
     public void setSessionVariables(){
         
        for(ADAPT360_Integration_Setting__mdt settings : [SELECT DeveloperName, Setting__c FROM ADAPT360_Integration_Setting__mdt WHERE DeveloperName IN('BASE_ENDPOINT','OPERATION_GETALLVIEWS','OPERATION_GETCLIENTS','TIMEOUT','X_IBM_Client_Id','X_IBM_Client_Secret','QUERYTYPE_FIELD','QUERYTYPES','REGID_FIELD','CIB_VIEW')]){
            if (settings.DeveloperName == 'BASE_ENDPOINT') BASE_ENDPOINT = settings.Setting__c;
            if (settings.DeveloperName == 'OPERATION_GETALLVIEWS') OPERATION_GETALLVIEWS = settings.Setting__c;
            if (settings.DeveloperName == 'OPERATION_GETCLIENTS') OPERATION_GETCLIENTS = settings.Setting__c;
            if (settings.DeveloperName == 'TIMEOUT') TIMEOUT = integer.valueof(settings.Setting__c);
            if (settings.DeveloperName == 'X_IBM_Client_Id') X_IBM_Client_Id = settings.Setting__c;
            if (settings.DeveloperName == 'X_IBM_Client_Secret') X_IBM_Client_Secret = settings.Setting__c;
            if (settings.DeveloperName == 'QUERYTYPE_FIELD') QUERYTYPE_FIELD = settings.Setting__c;
            if (settings.DeveloperName == 'REGID_FIELD') REGID_FIELD = settings.Setting__c;
            if (settings.DeveloperName == 'CIB_VIEW') CIB_VIEW = settings.Setting__c;
        }
    }
    
     public ApiRestJson2ApexCIF_v1 RetrieveClientDetails(String queryType, String regId, String view, Boolean hideMeta) {
         
        ApiRestJson2ApexCIF_v1 jsonClass = new ApiRestJson2ApexCIF_v1(); 
        
        // Builds the query strings based on the parameters passed to the method
        String QueryString='';
        if (queryType != '') QueryString = QueryString + '?queryType=' + queryType;
        if (regId != '') QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'regId=' + regId;
        if (view != '') QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'view=' + view;
        QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'hideMeta=' + (hideMeta ? 'true' : 'false');
        
        System.debug('** Query = ' + QueryString);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_ENDPOINT + OPERATION_GETCLIENTS + QueryString.replace(' ','%20'));
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-IBM-Client-Id', X_IBM_Client_Id);
        request.setHeader('X-IBM-Client-Secret', X_IBM_Client_Secret);
        request.setTimeout(TIMEOUT);
        
        HttpResponse response;
       
        try {
            
            response = http.send(request);
            system.debug('response body: '+response.getBody());
            
            if (response.getStatusCode() == 200){
                try {
                    // Deserialize the list of Client Details from the JSON string
                    jsonClass = ApiRestJson2ApexCIF_v1.parse(response.getBody().removeStart('[').removeEnd(']').replace('"number":','"cifnumber":'));
                    //clientDetails = (List<ClientDetail>)JSON.deserialize(response.getBody().replace('"limit":','"limits":').replace('"$ref":','"ref":').replace('"number":','"numbers":').replace('"_links":','"links":').replace('"$id":','"id":'), List<ClientDetail>.class);  
                }catch(Exception e){ 
                    System.debug(e.getMessage());
                }
            }else{
                
                 System.debug(response.getBody());
                 System.debug(response.getStatusCode());
            }
            
        } catch(Exception e){ 
            System.debug(e.getMessage());
        }
        
        return jsonClass;
    }
    
    
     public ApiRestJson2ApexCIF_v1[] RetrieveClientList(String queryType, String regId, String view, Boolean hideMeta) {
         
        ApiRestJson2ApexCIF_v1[] cifList = new list<ApiRestJson2ApexCIF_v1>(); 
        
        // Builds the query strings based on the parameters passed to the method
        String QueryString='';
        if (queryType != '') QueryString = QueryString + '?queryType=' + queryType;
        if (regId != '') QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'regId=' + regId;
        if (view != '') QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'view=' + view;
        QueryString = QueryString + (QueryString=='' ? '?' : '&') + 'hideMeta=' + (hideMeta ? 'true' : 'false');
        
        System.debug('** Query = ' + QueryString);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_ENDPOINT + OPERATION_GETCLIENTS + QueryString.replace(' ','%20'));
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-IBM-Client-Id', X_IBM_Client_Id);
        request.setHeader('X-IBM-Client-Secret', X_IBM_Client_Secret);
        request.setTimeout(TIMEOUT);
        
        HttpResponse response;
       
        try {
            
            response = http.send(request);
            system.debug('response body: '+response.getBody());
            
            if (response.getStatusCode() == 200){
                try {
                    // Deserialize the list of Client Details from the JSON string
                    String body = response.getBody().replace('"number":','"cifnumber":');
                    cifList = (list<ApiRestJson2ApexCIF_v1>)JSON.deserialize(body, list<ApiRestJson2ApexCIF_v1>.class);
                    //clientDetails = (List<ClientDetail>)JSON.deserialize(response.getBody().replace('"limit":','"limits":').replace('"$ref":','"ref":').replace('"number":','"numbers":').replace('"_links":','"links":').replace('"$id":','"id":'), List<ClientDetail>.class);  
                }catch(Exception e){ 
                    System.debug(e.getMessage());
                }
            }else{
                
                 System.debug(response.getBody());
                 System.debug(response.getStatusCode());
            }
            
        } catch(Exception e){ 
            System.debug(e.getMessage());
        }
        
        return cifList;
    }
    
    
}