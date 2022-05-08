/**
* @author: Koketso Mpshane
* @dateCreated: 26/08/2019 - Created AimsRequestService Class to send AIMS pdf letters
* @requestUri: /services/apexrest/AimsRequestService
* @httpMethods: POST
**/
@RestResource(urlMapping='/AimsRequestService/*')
global class AimsRequestService{
    
    @HttpPost 
    global static String processRequest(){
        
        String response;
        RestRequest restRqst = RestContext.request;
        system.debug(LoggingLevel.FINE,'**RestRequest**:'+restRqst);
        
        String requestBody = restRqst.requestBody.toString();
        system.debug(LoggingLevel.FINE,'**requestBody**:'+requestBody);
        
        EmailRequestService.RequestStatus statusReq = EmailRequestService.getResponseStatus(requestBody, true);
        
        response = JSON.serialize(statusReq);
        system.debug(LoggingLevel.FINE,'**responseBody**:'+response);
        
        return response;
    }
    
}