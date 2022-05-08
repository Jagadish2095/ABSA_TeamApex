/*
* Integration Handler for HLallocate Stock Number Service
* @author Englarmerdge Mongwe
* @created 2018-11-23
*/

public class HLallocateStockNumber_IH_v1 
{      
    /* Action method which synchronously calls the HLallocate Stock Number operation with specified parameters
    ** HLallocateStockNumber_Req_IB_v1
	*/     
    public static HLallocateStockNumber_Resp_IB_v1 hlAllocateStockNumber(String channelP, String applicationP, String traceP, String msgLanguageP, String msgTargetP, String finalMsgClassP, String finalMsgCodeP, String prodCategoryP, String prodTypeP, String prodCodeP, String siteCodeP)
    {        
        Sys_Log_Integration__c log;
        HLallocateStockNumber_Resp_IB_v1 stockNumberRespBean;
           
        try
        {           
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.HLALLOCATE_STOCK_NUMBER);
            
            //Check if Integration Settings was found
            if(integrationSettings != null)
            {
                //Create request bean
                HLallocateStockNumber_Req_IB_v1 hLAllocateStockNumberRequest = HLallocateStockNumber_IU_v1.mapRequestFields(channelP, applicationP, traceP, msgLanguageP, msgTargetP, finalMsgClassP, finalMsgCodeP, prodCategoryP, prodTypeP, prodCodeP, siteCodeP);
                
                String jsonString = JSON.serialize(hLAllocateStockNumberRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);          
            	              
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_HLALLOCATE_STOCK_NUMBER, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                stockNumberRespBean = HLallocateStockNumber_IU_v1.mapResponseFields(response);
                
                System.debug('HLallocate Stock Number Request Bean: ' + stockNumberRespBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.HLALLOCATE_STOCK_NUMBER + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                stockNumberRespBean = HLallocateStockNumber_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_HLALLOCATE_STOCK_NUMBER, StringConstants.HLALLOCATESTOCKNUMBER_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
            
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            stockNumberRespBean = HLallocateStockNumber_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_HLALLOCATE_STOCK_NUMBER, StringConstants.HLALLOCATESTOCKNUMBER_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return stockNumberRespBean;
    }
}