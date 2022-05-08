/**
* @description Integration Handler class for the BAPI_SF_IF22_contract_IH_v1
* @author  Kabelo Aphane
* @create   25 June 2021
*/
public class BAPI_SF_IF22_contract_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'BAPISFIF22 Contract Information v1';
/**
* @description getBAPISFIF22ContactInfov1
* @param I_ACCOUNT
* @return BAPI_SF_IF22_contract_Resp_IB_v1
*/
  public static BAPI_SF_IF22_contract_Resp_IB_v1 getBAPISFIF22ContactInfov1(String I_ACCOUNT) {
        
    BAPI_SF_IF22_contract_Req_IB_v1 requestBean = BAPI_SF_IF22_contract_IU_v1.mapRequestFields(I_ACCOUNT);
    BAPI_SF_IF22_contract_Resp_IB_v1 responseBean = (BAPI_SF_IF22_contract_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, BAPI_SF_IF22_contract_Resp_IB_v1.class);
    return responseBean;
    }
}