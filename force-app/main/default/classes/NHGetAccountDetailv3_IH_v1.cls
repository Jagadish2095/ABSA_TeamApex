public class NHGetAccountDetailv3_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'nhgetaccountdetailv3';
	public static final String SERVICE_NAME = 'nhgetaccountdetailv3';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static NHGetAccountDetailv3_Resp_IB_v1 nhgetaccountdetailv3(String  combiNumberP,String accountNumberP){
        NHGetAccountDetailv3_Req_IB_v1 requestBean = NHGetAccountDetailv3_IU_v1.mapRequestFields(combiNumberP,accountNumberP);
        NHGetAccountDetailv3_Resp_IB_v1 responseBean = (NHGetAccountDetailv3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, NHGetAccountDetailv3_Resp_IB_v1.class);
        return responseBean;
    }

}