/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-09-29
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
public class ciupdateclientdetailV12_IH_v1 {
    
  
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'ciupdateclientdetailv12';
    public static final String SERVICE_NAME = 'ciupdateclientdetailv12';
    public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-09-29 
    * @param acc 
    * @param addressList 
    * @param translations 
    * @param clientType 
    * @param siteCode 
    * @param employeeNumber 
    * @param respBean 
    * @return ciupdateclientdetailV12_Resp_IB_v1 
    **/
    public static ciupdateclientdetailV12_Resp_IB_v1 ciupdateclientdetailv12data(Account acc, List<Address__c> addressList , Map<String,String> translations ,String clientType, String siteCode,String employeeNumber, GetClientDetailsCIF_Resp_IB_v1 respBean){
    Sys_Log_Integration__c log; 
        
    ciupdateclientdetailV12_Req_IB_v1 requestBean = ciupdateclientdetailV12_IU_v1.ciUpdateSoleTrader(acc,addressList,translations,clientType,siteCode,employeeNumber,respBean);
    
         
          editCIFJSONGenerator cj = new editCIFJSONGenerator();
                 
          String jsonString = cj.toString(requestBean);
    
          
           String getString = json.serialize(respBean);
        
        
      
            List<Integration_Service__c> intergrationService = Sys_Utilities_Integration.getIntegrationServices('ciupdateclientdetailv12');

            HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(intergrationService[0], jsonString);

                  //  Send Request
            log = SystemLogger.createRequestIntegrationLog(request.getBody(), INTEGRATION_SERVICE_NAME, StringConstants.SALESFORCE_STRING, SERVICE_NAME);
            HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
            ciupdateclientdetailV12_Resp_IB_v1 responseBean;
        
                   //Map Response
             responseBean = ciupdateclientdetailV12_IU_v1.mapResponseFields(response);
         
        //ciupdateclientdetailV12_Resp_IB_v1 responseBean = (ciupdateclientdetailV12_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null,INTEGRATION_SERVICE_NAME, ciupdateclientdetailV12_Resp_IB_v1.class);
        
            return responseBean;
       
                                                                           
    }
        //TdB - SuretOnboarding for all types on Customer Entities

         /**
         * @description 
         * @author muvhuso.nekhubvi@absa.africa | 2021-09-29 
         * @param acc 
         * @param addressList 
         * @param siteCode 
         * @param respBean 
         * @return ciupdateclientdetailV12_Resp_IB_v1 
         **/
         public static ciupdateclientdetailV12_Resp_IB_v1 ciupdateclientdetailv12Onboarding(Account acc, List<Address__c> addressList , String siteCode, GetClientDetailsCIF_Resp_IB_v1 respBean){
            Sys_Log_Integration__c log; 
    
            ciupdateclientdetailV12_Req_IB_v1 requestBean = ciupdateclientdetailV12_IU_v1.updateClientDetailsSurety(acc,addressList,siteCode,respBean);
            editCIFJSONGenerator cj = new editCIFJSONGenerator();
    
            String jsonString = cj.toString(requestBean);
            String getString = json.serialize(respBean);
            
            List<Integration_Service__c> intergrationService = Sys_Utilities_Integration.getIntegrationServices(INTEGRATION_SERVICE_NAME);
            HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(intergrationService[0], jsonString);
            
            //  Send Request
            log = SystemLogger.createRequestIntegrationLog(request.getBody(), INTEGRATION_SERVICE_NAME, StringConstants.SALESFORCE_STRING, SERVICE_NAME);
            HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
            ciupdateclientdetailV12_Resp_IB_v1 responseBean;
            
            //Map Response
            responseBean = ciupdateclientdetailV12_IU_v1.mapResponseFields(response);
    
            return responseBean;
        }
        //Anka Ganta - 2021-03-04 - W-006976 - Remediate Existing Customer Onboading

        /**
        * @description 
        * @author muvhuso.nekhubvi@absa.africa | 2021-09-29 
        * @param acc 
        * @param addressList 
        * @param translations 
        * @param clientType 
        * @param siteCode 
        * @param employeeNumber 
        * @param respBean 
        * @return map<ciupdateclientdetailV12_Resp_IB_v1, Sys_Log_Integration__c> 
        **/
        public static map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c> ciUpdateRemediateCustomer(Account acc, List<Address__c> addressList , Map<String,String> translations ,String clientType, String siteCode,String employeeNumber, GetClientDetailsCIF_Resp_IB_v1 respBean){
            Sys_Log_Integration__c log; 
            Map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c> respBeanMap = new Map<ciupdateclientdetailV12_Resp_IB_v1,Sys_Log_Integration__c>();
            ciupdateclientdetailV12_Req_IB_v1 requestBean = ciupdateclientdetailV12_IU_v1.ciUpdateRemediateCustomer(acc,addressList,translations,clientType,siteCode,employeeNumber,respBean);
    
            editCIFJSONGenerator cj = new editCIFJSONGenerator();
            String jsonString = cj.toString(requestBean);
            
            String getString = json.serialize(respBean);
          
            List<Integration_Service__c> intergrationService = Sys_Utilities_Integration.getIntegrationServices(INTEGRATION_SERVICE_NAME);

            HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(intergrationService[0], jsonString);
            
            //  Send Request
            log = SystemLogger.createRequestIntegrationLog(request.getBody(), 'ciupdateclientdetailV12_IH_v1.ciUpdateRemediateCustomer', StringConstants.SALESFORCE_STRING, SERVICE_NAME);
            HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
            ciupdateclientdetailV12_Resp_IB_v1 responseBean;
            
            //Map Response
            responseBean = ciupdateclientdetailV12_IU_v1.mapResponseFields(response);
            if(response.getStatusCode() == 200)
            {
                //populate log;
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
            }
            else
            {
                //populate log;
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
            }
          
            respBeanMap.put(responseBean, log);
            return respBeanMap;
            //return responseBean;
            
            
        }
    }