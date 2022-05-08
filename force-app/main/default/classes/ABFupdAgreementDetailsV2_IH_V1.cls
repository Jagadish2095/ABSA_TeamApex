public class ABFupdAgreementDetailsV2_IH_V1 {
/*
* Integration Handler for ABFupdAgreementDetailsV1 Service 
* @author Gulafsha
* @created 2020-11-30
*/
    
    public static final String INTEGRATION_SERVICE_NAME = 'ABF Update Agreement Detail';
    
    public static ABFupdAgreementDetailsV2_Resp_IB_V1 ABFupdAgreementDetailsV2(ABFupdAgreementDetailsV2_Req_IB_V1  requestBeanP){
        //ABFupdAgreementDetailsV2_Req_IB_V1  requestBeanP = ABFupdAgreementDetailsV2_Req_IB_V1.createDummyRequest();
        ABFupdAgreementDetailsV2_Resp_IB_V1 responseBean = (ABFupdAgreementDetailsV2_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBeanP, null, INTEGRATION_SERVICE_NAME, ABFupdAgreementDetailsV2_Resp_IB_V1.class);
        system.debug('@@@responseBean'+responseBean);
        return responseBean;
        
    }

}