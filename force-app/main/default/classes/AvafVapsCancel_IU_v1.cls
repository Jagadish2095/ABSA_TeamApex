/**
 * @description Integration Utilities for SAPCancel Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */
public class AvafVapsCancel_IU_v1 extends Base_IB {
	/**
	 * @description Method to create the request bean
	 * @param selectedVAPS
	 * @param authOverride
	 * @return AvafVapsCancel_Req_IB_v1
	 */
	public static AvafVapsCancel_Req_IB_v1 mapRequestFields(String selectedVAPS, Boolean authOverride) {
		//deserialize selectedVaps into bean object
		AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS bapiSfVaps = (AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS) JSON.deserialize(
			selectedVAPS,
			AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS.class
		);
		if (authOverride) {
			bapiSfVaps.AUTH_OVERRIDE = 'X';
		}
		List<AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS> bapiSfVapsList = new List<AvafVapsCancel_Req_IB_v1.BAPI_SF_VAPS>();
		bapiSfVapsList.add(bapiSfVaps);

		AvafVapsCancel_Req_IB_v1 requestBean = new AvafVapsCancel_Req_IB_v1();
		requestBean.BAPI_SF_VAPS_CANCEL = bapiSfVapsList;
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
		requestBean.I_USER = currentUser.AB_Number__c;

		return requestBean;
	}
}