/** @description Request Integration Handler for BAPISFContrDetails Service
 * @author Humbelani Denge
 * @created 2021-01-27
 **/
public class BAPISFContrDetails_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'BAPI SF Contract Details';
	/**
	 * @description BAPISFContrDetails
	 * @author Mradul Maheshwari | 08-19-2021
	 * @param  iAccount
	 * @param  iUser
	 * @return BAPISFContrDetails_Resp_IB_v1
	 **/
	public static BAPISFContrDetails_Resp_IB_v1 BAPISFContrDetails(String iAccount, String iUser) {
		BAPISFContrDetails_Req_IB_v1 requestBean = BAPISFContrDetails_IU_v1.mapRequestFields(iAccount, iUser);
		BAPISFContrDetails_Resp_IB_v1 responseBean = (BAPISFContrDetails_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			BAPISFContrDetails_Resp_IB_v1.class
		);

		return responseBean;
	}
}