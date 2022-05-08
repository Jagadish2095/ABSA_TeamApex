/** 
 * @description Integration Handler for MLupdAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public  class MLupdAcctInfoCUS1V1_IH_v1 extends Base_IB{
    public static final String INTEGRATION_SERVICE_NAME = 'MLupdAcctInfoforCUS1V1Service';
    
    /**
	* @description get the select account Information 
    * @param accountNumber
    * @param primaryAccountId
    * @param newDueDay
    * @param refNumber
    * @param schemaCode
    * @param requestType
    * @return MLupdAcctInfoCUS1V1_Resp_IB_v1
	*/
    public static MLupdAcctInfoCUS1V1_Resp_IB_v1 doUpdate(String accountNumber, String primaryAccountId, Integer newDueDay, Integer refNumber, Double schemaCode, String requestType) {
        MLupdAcctInfoCUS1V1_Req_IB_v1 requestBean = MLupdAcctInfoCUS1V1_IU_v1.mapRequestFields(accountNumber, primaryAccountId, newDueDay, refNumber, schemaCode, requestType);
        MLupdAcctInfoCUS1V1_Resp_IB_v1 responseBean = (MLupdAcctInfoCUS1V1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, MLupdAcctInfoCUS1V1_Resp_IB_v1.class);
        
        return responseBean;
    }
}