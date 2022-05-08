/**
 * @author Rajesh Nandigam
 * @since 2021-07-20
 * @description Ecp Leads Handler class
 **/


public class EcpLeads_IH_v1 {

 /**
 * @description  method for the ECP Call
 * @since 2021-07-20
 * @param accId
 * @param leadPrdInterest
 * @param accStatus
 * @return responseBean
 **/
    public static final String INTEGRATION_SERVICE_NAME = 'ecpLeads';
    public static EcpLeads_Resp_IB_v1 ECPLeadRequestCall(string accId, string leadPrdInterest, string accStatus) {
        EcpLeads_Req_IB_v1 requestBean = EcpLeads_IU_v1.mapRequestdFields(accId, leadPrdInterest, accStatus);
        EcpLeads_Resp_IB_v1 responseBean = (EcpLeads_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, EcpLeads_Resp_IB_v1.class);
        return responseBean;
    }
    
    /**
 * @description future method for the ECP Call
 * @since 2021-07-20
 * @param accId
 * @param leadPrdInterest
 * @param accStatus
 **/
    @future(callout=true)
    public static void sendEcpLead(string accId, string leadPrdInterest, string accStatus){
        EcpLeads_IH_v1.ECPLeadRequestCall(accId, leadPrdInterest, accStatus);
    }
   
}