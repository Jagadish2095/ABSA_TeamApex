/**
 * @description Integration Utility class for BAPISFContrDetails Service
 * @author Humbelani Denge
 * @created 2021-01-27
 **/
public class BAPISFContrDetails_IU_v1 {
	/**
	 * @description mapRequestFields
	 * @param iAccount
	 * @param iUser
	 * @return BAPISFContrDetails_Req_IB_v1
	 * **/
	public static BAPISFContrDetails_Req_IB_v1 mapRequestFields(String iAccount, String iUser) {
		BAPISFContrDetails_Req_IB_v1 requestBean = new BAPISFContrDetails_Req_IB_v1();
		requestBean.BAPI_SF_CONTR_DETAILS = new BAPISFContrDetails_Req_IB_v1.BAPI_SF_CONTR_DETAILS();

		requestBean.BAPI_SF_CONTR_DETAILS.I_ACCOUNT = iAccount.replaceFirst('^0+', '').leftPad(11, '0');
		requestBean.BAPI_SF_CONTR_DETAILS.I_USER = iUser;

		return requestBean;
	}
}