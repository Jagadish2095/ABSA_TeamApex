/**	
* Descripton: Apex/Integration Handler class for SVcreateLinkSavingsNoticeDepAccountV6 service	
* Test Class Name: SVcreateLinkSavingsDepAccount_IH_v1_Test	
* @author  Srikanth : Absa	
* @since   2020-31-01	
*	
**/	
public class SVcreateLinkSavingsDepAccount_IH_v1{	
    /* Makes the callout to SVcreateLinkSavingsDepAccount 	
    * @param: List of Accounts	
    * @return: SVcreateLinkSavingsDepAccount_Resp_IB_v1 bean object	
   */	
    
    //Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
    public static Map<SVcreateLinkSavingsDepAccount_Resp_IB_v1, List<Sys_Log_Integration__c>> callToSVcreateLinkSavingsDepAccount(String oppId, String lineItemId, String srcOfFnds1, 
                                                       																			  String srcOfFnds2, String srcOfFnds3, 
                                                                                                                                  String srcOfFnds4, String srcOfFnds5, String rbaEddRating){	
        	
         Opportunity opp = [SELECT Id,Site__r.Site_Code__c, Account.CIF__c, (select Id,Product2.ProductCode from OpportunitylineItems Where Id=: lineItemId) FROM Opportunity Where Id=: oppId];	
String productcode;	
        if(opp.OpportunitylineItems != null && opp.OpportunitylineItems.size()>0 ) productcode= opp.OpportunitylineItems[0].Product2.ProductCode;	
      	
        Sys_Log_Integration__c log;	
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();	
        SVcreateLinkSavingsDepAccount_Resp_IB_v1 SVcreateLinkSavingsDepAccountRespBean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1();	
        Map<SVcreateLinkSavingsDepAccount_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<SVcreateLinkSavingsDepAccount_Resp_IB_v1, List<Sys_Log_Integration__c>>();	
   	
     	
       	
        try{	
           	
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.SVcreateLinkSavingsDepAccount_STRING);	
              	
                if(integrationSettings!=null || Test.isRunningTest()){	
                   	//Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
                    SVcreateLinkSavingsDepAccount_Req_IB_v1 requestBean = SVcreateLinkSavingsDepAccount_IU_v1.mapRequestdFields(opp.Account.CIF__c, opp.Site__r.Site_Code__c, productCode, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5,rbaEddRating);//accNum,fromDate,toDate,CIFkey,selectedprotype);	
                    System.debug('requestBean in IH'+requestBean) ;	
                    //requestBean.startDate= fromDate; 	
                     //requestBean.endDate= toDate; 	
                    	
                    system.debug(requestBean);	
                     String jsonString = JSON.serialize(requestBean, true);	
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);	
                    	
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_SVcreateLinkSavingsDepAccount_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());	
                   HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);	
                  system.debug('+++'+response.getBody());	
                    if(response.getStatusCode() == 200){	
                        system.debug(JSON.deserialize(response.getBody(), SVcreateLinkSavingsDepAccount_Resp_IB_v1.class));	
                       SVcreateLinkSavingsDepAccountRespBean = (SVcreateLinkSavingsDepAccount_Resp_IB_v1) JSON.deserialize(response.getBody(), SVcreateLinkSavingsDepAccount_Resp_IB_v1.class); 	
                        SVcreateLinkSavingsDepAccountRespBean.statusCode = response.getStatusCode();	
                         SVcreateLinkSavingsDepAccountRespBean.StatusMessage = response.getStatus() ;	
                      	
                    } else{	
                        System.debug('Status Code NOT 200 - FAILURE');    	
                        //Response was not 0	
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());	
                        SVcreateLinkSavingsDepAccountRespBean = SVcreateLinkSavingsDepAccount_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());	
                    	
                        	
                    }	
                    	
                } else{	
                    //No Integration Settings Found	
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();	
                    SVcreateLinkSavingsDepAccountRespBean = SVcreateLinkSavingsDepAccount_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);	
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MLgetAcctBalanceIF42V1_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);	
                    System.debug(message);	
                    	
                }	
                	
            if (log != null) {	
                logList.add(log);	
                insert log;	
              }	
              responseMap.put(SVcreateLinkSavingsDepAccountRespBean, logList);	
            system.debug(responseMap);	
             return responseMap;	
            	
        } catch(Exception e){	
            //Exception	
            System.debug(e.getMessage() + '.' + e.getStackTraceString());	
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();	
            SVcreateLinkSavingsDepAccountRespBean = SVcreateLinkSavingsDepAccount_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);	
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SVcreateLinkSavingsDepAccount_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);	
        }	
        	
        if(log != null){	
            insert log;	
        }	
         responseMap.put(SVcreateLinkSavingsDepAccountRespBean, logList);	
          system.debug(responseMap);	
         return responseMap;	
    }	
}