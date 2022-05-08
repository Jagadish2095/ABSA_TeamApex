/**
     * @description Consuming the updateLeadDetails service
     * @Author: Mbuyiseni Mbhokane
     * @date: 28/04/2021
     * Updated by Monde Masiza
     * @param  opportunityId
     */

    public class ShortTermInsurancePushLead {
        @AuraEnabled
        /**
         * @description create lead to portal
         * @param opportunityId
         * @return create Lead Response Message
         */
        public static String PushToPortal(String opportunityId) {  
            system.debug('Test' + opportunityId);
            
            String createLeadResponseMessage;
            CreateLead_Req_IB_v1 createLeadRequestBean = CreateLead_IU_v1.mapRequestFields(opportunityId);
            CreateLead_Resp_IB_v1 createLeadResponseBean = CreateLead_IH_v1.createLead(createLeadRequestBean);
    
            System.debug('createLeadResponseBean : '+ createLeadResponseBean);
            System.debug('createLeadResponseBean : '+ createLeadResponseBean.serialize(createLeadResponseBean));
    
            if(createLeadResponseBean != null && createLeadResponseBean.statusCode == 200){
                createLeadResponseMessage = createLeadResponseBean.serialize(createLeadResponseBean);
                //createLeadResponseMessage = Sys_Utilities_Integration.RESPONSE;
                 
                
            }else{
                createLeadResponseMessage = createLeadResponseBean.serialize(createLeadResponseBean);
              
            }
            return createLeadResponseMessage;
        }   
        @AuraEnabled
        /**
         * @description Update lead details in portal
         * @param opportunityId
         * @param accountId
         * @return response Message
         */
        public static String leadDetailsUpdate(String opportunityId, String accountId){
            
            
            String responseMessage;
            
                UpdateLeadDetails_Req_IB_v1 request = UpdateLeadDetails_IU_v1.mapRequestField(opportunityId,accountId);
                UpdateLeadDetails_Resp_IB_v1 response = UpdateLeadDetails_IH_v1.updateLeadDetails(request);
    
                if(response != null && response.statusCode == 200){
                    responseMessage = response.serialize(response);
                }else{
                    responseMessage = response.serialize(response);
                }
    
           
            return responseMessage;
        }
       
    }