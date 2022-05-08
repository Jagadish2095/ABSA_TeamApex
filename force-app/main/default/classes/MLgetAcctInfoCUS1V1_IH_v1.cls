/** 
 * @description Integration Handler for MLgetAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public class MLgetAcctInfoCUS1V1_IH_v1 extends Base_IB {
    public static final String INTEGRATION_SERVICE_NAME = 'MLgetAcctInfoforCUS1V1Service';
    
    /**
	* @description get the select account Information 
    * @param accountNumber
    * @param requestType
    * @return MLgetAcctInfoCUS1V1_Resp_IB_v1
	*/
    public static MLgetAcctInfoCUS1V1_Resp_IB_v1 getAccountInfo(String accountNumber, String requestType) {
        MLgetAcctInfoCUS1V1_Req_IB_v1 requestBean = MLgetAcctInfoCUS1V1_IU_v1.mapRequestFields(accountNumber, requestType);
        MLgetAcctInfoCUS1V1_Resp_IB_v1 responseBean = (MLgetAcctInfoCUS1V1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, MLgetAcctInfoCUS1V1_Resp_IB_v1.class);
        
        return responseBean;
    }
}