/**
 * @description       : Integration Handler class for Credit Group View
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-24   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class GBgetCmsFullCrGroups_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'GBgetCmsFullCrGroupsDetV1Service';

	/**
	 * @description Handler service call
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 * @param clientCode
	 * @return GBgetCmsFullCrGroups_Resp_IB_v1
	 **/
	public static GBgetCmsFullCrGroups_Resp_IB_v1 GBgetCmsFullCrGroupsV1(String clientCode) {
		GBgetCmsFullCrGroups_Req_IB_v1 requestBean = GBgetCmsCreditGroups_IU_v1.mapRequestFields(clientCode);
		GBgetCmsFullCrGroups_Resp_IB_v1 responseBean = (GBgetCmsFullCrGroups_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			GBgetCmsFullCrGroups_Resp_IB_v1.class
		);
		return responseBean;
	}
}