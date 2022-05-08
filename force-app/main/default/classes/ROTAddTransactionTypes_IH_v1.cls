public class ROTAddTransactionTypes_IH_v1 {

    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'AddTransactionTypes';
    public static final String SERVICE_NAME = 'AddTransactionTypes';
    public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTAddTransactionTypes_Resp_IB_v1 addTransactionTypes(ROTAddTransactionTypes_Req_IB_v1 requestBean) {
       ROTAddTransactionTypes_Resp_IB_v1 responseBean = (ROTAddTransactionTypes_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTAddTransactionTypes_Resp_IB_v1.class); 
       return responseBean;
    }
    
}