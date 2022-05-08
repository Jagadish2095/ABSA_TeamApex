/**
* @description Integration Handler for Update CIF Service
* @author Sharath / Mohammed
* @created 2021-04-26
*/
/**
 *@description getUpdateCIF_IH_v1
*/
public class getUpdateCIF_IH_v1 {
    
   
        /**
        * @description 
        * @author muvhuso.nekhubvi@absa.africa | 2021-11-29 
        * @param accToReq 
        * @param address1 
        * @param address2 
        * @param suburb 
        * @param cityName 
        * @param countryName 
        * @param postalCode 
        * @param indicator 
        * @param indicatorAddressInd 
        * @param sourceIncome 
        * @param occupationStatus 
        * @param jointsParentCode 
        * @return getUpdateCIFParser 
        **/
        public static getUpdateCIFParser getCIFResponse(Account accToReq, string address1, string address2, string suburb, string cityName, string countryName, string postalCode, string indicator,String indicatorAddressInd, string sourceIncome, string occupationStatus,String jointsParentCode){
            Sys_Log_Integration__c log;
            getUpdateCIFParser CIFRespBean;
            string APIName = 'Jitterbit2';
            string serviceName = 'updateCIF';
            try{  
                //To get integration settings of compliance pack service for UAT env
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(APIName, Sys_Utilities_General.getEnvironment(), serviceName);
                //system.debug('the integrationSettings are --> '+integrationSettings);
                user u = new UsersSelector().selectById(userInfo.getUserId());
                if(integrationSettings != null){
                    String jsonString = getUpdateCIF_IU_v1.mapRequestFields(address1, address2, suburb, cityName, countryName, postalCode, indicator,indicatorAddressInd, sourceIncome, occupationStatus,accToReq.Occupation_Category__pc, accToReq.CIF__c , accToReq.Client_Type__c , accToReq.ID_Number__pc,jointsParentCode);	
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0], jsonString);
                    request.setHeader('tellerId', u.AB_Number__c);
                    request.setHeader('applicationId', 'salesforce');
                    request.setHeader('branch', u.SiteCode__c);
                    //request.setHeader('branch', '8198');
                    request.setHeader('deviceId', 'desktop');

                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_UPDATE_CIF_INFO, StringConstants.SALESFORCE_STRING, request.getEndpoint());           
                    //Sending Request to the service
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    //system.debug('the response body is --> '+response.getBody());
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                    CIFRespBean = getUpdateCIF_IU_v1.mapResponseFields(response);
                    //system.debug('the CIFRespBean is --> '+CIFRespBean);
                }
                else{
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.METHOD_UPDATE_CIF_INFO + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    CIFRespBean = getUpdateCIF_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_CIF_INFO, StringConstants.CIFUPDATE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    //System.debug(message);
                }
                
            }catch(Exception e){
                //Exception Handling
                String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
                //System.debug(e.getMessage());
                CIFRespBean = getUpdateCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPDATE_CIF_INFO, StringConstants.CIFUPDATE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                //System.debug(message);
            }
            if(log != null){
                insert log;
            }
            
            return CIFRespBean;  
        }
        
    }