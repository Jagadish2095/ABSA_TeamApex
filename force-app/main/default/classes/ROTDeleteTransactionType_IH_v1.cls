/**
* Class Name: ROTDeleteTransactionType_IH_v1
* @author   : Manish
**/
public class ROTDeleteTransactionType_IH_v1 {
      //update as per new Integration pattern in new Env where comman changes are available
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
    public static final String INTEGRATION_SERVICE_NAME = 'DeleteTransactionType';
    public static final String SERVICE_NAME = 'DeleteTransactionType';
    public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;
    
    public static ROTDeleteTransactionType_Resp_IB_v1 deleteTransactionType(ROTDeleteTransactionType_Req_IB_v1 requestBean) {
       ROTDeleteTransactionType_Resp_IB_v1 responseBean = (ROTDeleteTransactionType_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ROTDeleteTransactionType_Resp_IB_v1.class); 
       return responseBean;
    }
}