public class getMobileBeneficiaries_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'getMobileBeneficiariesByCifKey';
	public static final String SERVICE_NAME = 'getMobileBeneficiaries';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static getMobileBeneficiaries_Resp_IB_v1 getMobileBeneficiaries(String CifKey){
        
        getMobileBeneficiaries_Req_IB_v1 requestBean = getMobileBeneficiaries_IU_v1.mapRequestFields();                                                                
        getMobileBeneficiaries_Resp_IB_v1 responseBean = (getMobileBeneficiaries_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, CifKey, INTEGRATION_SERVICE_NAME, getMobileBeneficiaries_Resp_IB_v1.class);
        
        return responseBean;
    }
}