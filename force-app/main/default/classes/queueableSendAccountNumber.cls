public class queueableSendAccountNumber  implements Queueable, Database.AllowsCallouts{
    
     private String  opportunityId;
    private String  accountId;
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'businessEvolve';
    public static final String SERVICE_NAME = 'businessEvolve';
    public static final String METHOD_NAME = 'Business_Evolve_RestApi.buildResponse' + SERVICE_NAME;
    
    
     public queueableSendAccountNumber (String opportunityId, String accountId) { 

        this.opportunityId = opportunityId;
        this.accountId = accountId;

    } 
    
    
    public void execute(QueueableContext context) { 
        
        Business_Evolve_Response res= new Business_Evolve_Response();
        res = Business_Evolve_RestApi.buildResponse(accountId, opportunityId); 
        Business_Evolve_Response responseBean = (Business_Evolve_Response) Sys_Utilities_Integration.integrationServiceCall(res, null,INTEGRATION_SERVICE_NAME, Business_Evolve_Response.class);
        
    /* String body;
        try{
        Business_Evolve_Response res= new Business_Evolve_Response();
         res = Business_Evolve_RestApi.buildResponse(accountId, opportunityId);    
         Http http = new Http(); 
         HttpRequest request = new HttpRequest(); 
         request.setEndpoint('https://absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/businessEvolve/update'); 
         request.setMethod('POST'); 
         request.setHeader('Content-Type', 'application/json;charset=UTF-8'); // Set the body as a JSON object
         request.setBody(JSON.serialize(res));  
         system.debug(' request.setBody---->'+ Business_Evolve_RestApi.buildResponse(accountId, opportunityId));
         body = request.getBody(); 
         HttpResponse response = new Http().send(request); // Parse the JSON response 
         if (response.getStatusCode() == 200) {
         Sys_Log_Integration__c o = SystemLogger.createRequestIntegrationLog(body, 'POST', StringConstants.SALESFORCE_STRING, '/businessEvolve/update');
          o = SystemLogger.mapResponseFields(o, 200, 'OK', string.valueOf(response));    
          } 
        }
        catch (Exception ex){ 
         Sys_Log_Integration__c o = SystemLogger.createRequestIntegrationLog(body, 'POST', StringConstants.SALESFORCE_STRING, '/businessEvolve/update');   
         o = SystemLogger.mapResponseFields(o, 500, 'ERROR', 'Line number : ' + ex.getLineNumber() + ', ' + ex.getCause());   }
      */
      
  }

}