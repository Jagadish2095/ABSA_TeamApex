/**
 * @description       : Integration handler class for Commercial Bureau Enquiry
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
 **/

public class CommercialBureauEnquiry_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CommercialBureauEnquiry';

	/**
	 * @description Service call
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)| 2021-06-09
	 * @param apppcceId
	 * @return CommercialBureauEnquiry_Resp_IB_v1
	 **/
	public static CommercialBureauEnquiry_Resp_IB_v1 commercialBureauEnquiry(String apppcceId) {
		CommercialBureauEnquiry_Req_IB_v1 requestBean = CommercialBureauEnquiry_IU_v1.mapRequestFields(apppcceId);
		CommercialBureauEnquiry_Resp_IB_v1 responseBean = (CommercialBureauEnquiry_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			CommercialBureauEnquiry_Resp_IB_v1.class
		);

		return responseBean;
	}
}