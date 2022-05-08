/**
 * @description       : Integration utilities class for Commercial Bureau Enquiry
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
 **/

public class CommercialBureauEnquiry_IU_v1 {
	/**
	 * @description mapping Requested fields
	 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za) | 2021-06-09
	 * @param apppcceId
	 * @return CommercialBureauEnquiry_Req_IB_v1
	 **/
	public static CommercialBureauEnquiry_Req_IB_v1 mapRequestFields(String apppcceId) {
		CommercialBureauEnquiry_Req_IB_v1 requestBean = new CommercialBureauEnquiry_Req_IB_v1();
		CommercialBureauEnquiry_Req_IB_v1.cls_ApplicationDV applicationDV = new CommercialBureauEnquiry_Req_IB_v1.cls_ApplicationDV();
		CommercialBureauEnquiry_Req_IB_v1.cls_Request request = new CommercialBureauEnquiry_Req_IB_v1.cls_Request();
		applicationDV.APPPCCEID = apppcceId;
		request.ApplicationDV = applicationDV;
		requestBean.Request = request;

		return requestBean;
	}
}