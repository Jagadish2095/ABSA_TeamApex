/**
 * @description       : Integration Handler for IPlistNCARatesV1 Service
 * @author            : Saurabh Pandey
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Saurabh Pandey   Initial Version
 **/

public class IPlistNCARatesV1_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'IP List NCA Rates';

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param requestBean
	 * @return IPlistNCARatesV1_Resp_IB_v1
	 **/
	public static IPlistNCARatesV1_Resp_IB_v1 IPlistNCARatesV1(IPlistNCARatesV1_Req_IB_v1 requestBean) {
		/**
		 * @description
		 * @author Himanshu.Nimje@absa.africa | 2021-06-12
		 * @param Sys_Utilities_Integration.integrationServiceCall
		 * @return IPlistNCARatesV1_Resp_IB_v1
		 **/
		IPlistNCARatesV1_Resp_IB_v1 responseBean = (IPlistNCARatesV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			IPlistNCARatesV1_Resp_IB_v1.class
		);
		return responseBean;
	}
}