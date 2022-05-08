/**
* @description Request Bean class for the BAPI_SF_IF22_contractInformation
*
* @author  Kabelo Aphane
* @create   25 June 2021
*/
public class BAPI_SF_IF22_contract_Req_IB_v1 extends Base_IB{
    
	public BAPI_SF_IF22 BAPI_SF_IF22;
/**
* @description BAPI_SF_IF22
*/
	public class BAPI_SF_IF22 {
		public String I_ACCOUNT;
	}
	/**
* @description createDummyRequest
* @return GetPolicyPremiumRequest_Req_IB_v1
*/
public static BAPI_SF_IF22_contract_Req_IB_v1 createDummyRequest()
{
	BAPI_SF_IF22_contract_Req_IB_v1 requestBean = new BAPI_SF_IF22_contract_Req_IB_v1();
	requestBean.BAPI_SF_IF22 = new BAPI_SF_IF22_contract_Req_IB_v1.BAPI_SF_IF22();
	requestBean.BAPI_SF_IF22.I_ACCOUNT = '00074273217';
	
	return requestBean;
}

}