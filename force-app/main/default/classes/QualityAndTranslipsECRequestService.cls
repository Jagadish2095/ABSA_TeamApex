/**
* @author: Koketso Mpshane
* @dateCreated: 27/09/2019 - Created QualityAndTranslipsECRequestService Class to send Quality EC and Translips EC emails
* @requestUri: /services/apexrest/QualityAndTranslipsECRequestService
* @httpMethods: POST
**/
@RestResource(urlMapping='/QualityAndTranslipsECRequestService/*')
global class QualityAndTranslipsECRequestService {
    
    @HttpPost 
    global static String processRequest(){
        
        String response;
        RestRequest restRqst = RestContext.request;
        system.debug(LoggingLevel.FINE,'**RestRequest**:'+restRqst);
        
        String requestBody = restRqst.requestBody.toString();
        system.debug(LoggingLevel.FINE,'**requestBody**:'+requestBody);
        
        EmailRequestService.RequestStatus statusReq = EmailRequestService.getResponseStatus(requestBody, false);
        
        response = JSON.serialize(statusReq);
        system.debug(LoggingLevel.FINE,'**responseBody**:'+response);
        
        return response;
    }
    
}