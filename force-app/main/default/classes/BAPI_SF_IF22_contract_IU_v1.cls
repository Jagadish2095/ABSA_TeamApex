/**
* @description Integration Utility class for the BAPI_SF_IF22_contractInformation
*
* @author  Kabelo Aphane
* @create   25 June 2021
*/
public class BAPI_SF_IF22_contract_IU_v1 {
/**
* @description mapRequestFields
* @param I_ACCOUNT
* @return BAPI_SF_IF22_contract_Req_IB_v1
*/
public static BAPI_SF_IF22_contract_Req_IB_v1 mapRequestFields(String I_ACCOUNT)
{
    BAPI_SF_IF22_contract_Req_IB_v1 requestBean = new BAPI_SF_IF22_contract_Req_IB_v1();
    requestBean.BAPI_SF_IF22 = new BAPI_SF_IF22_contract_Req_IB_v1.BAPI_SF_IF22();
        requestBean.BAPI_SF_IF22.I_ACCOUNT = I_ACCOUNT;
    
        return requestBean;
}
}