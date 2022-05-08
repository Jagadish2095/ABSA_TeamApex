/*
* Integration Handler for AddAccountToPortfolio Service
* @author Pitso Sekhu
* @created 2018-11-30
* @updated Danie Booysen
* @updated 2019-02-07
*/

public class AddAccountToPortfolio_IH_v1 {

    
    public static AddAccountToPortfolio_Resp_IB_v1 AddAccountToPortfolio(String clientCode, String accountNo, string dateAccOpen, string siteAccOpen, string tellerNo, string product, string casaRefNum, string srcOfFnds1, string srcOfFnds2,string srcOfFnds3, string srcOfFnds4, string srcOfFnds5, string sec129DeliveryAddr)
    {        
        Sys_Log_Integration__c log;
        AddAccountToPortfolio_Resp_IB_v1 portfolioAccounteRespBean;
           
        try
        {           
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.ADD_ACCOUNT_TO_PORTFOLIO);
            
            //Check if Metadata was found
            if(integrationSettings != null)
            {
                //Create request bean
                AddAccountToPortfolio_Req_IB_v1 portfolioAccountRequest = AddAccountToPortfolio_UI_v1.mapRequestFields(clientCode, accountNo, dateAccOpen, siteAccOpen, tellerNo, product, casaRefNum, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, sec129DeliveryAddr);
                
                String jsonString = JSON.serialize(portfolioAccountRequest, true);
               	HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                              
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                portfolioAccounteRespBean = AddAccountToPortfolio_UI_v1.mapResponseFields(response);

            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ADD_ACCOUNT_TO_PORTFOLIO + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                portfolioAccounteRespBean = AddAccountToPortfolio_UI_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.ADDACCOUNTTOPORTFOLIO_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
            
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            portfolioAccounteRespBean = AddAccountToPortfolio_UI_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ADD_ACCOUNT_TO_PORTFOLIO, StringConstants.ADDACCOUNTTOPORTFOLIO_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return portfolioAccounteRespBean;
    }
}