/**
 * @description       : Integration request bean class for Commercial Bureau Enquiry
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
 **/

public class CommercialBureauEnquiry_Req_IB_v1 extends Base_IB {
	public cls_Request Request;
	/**
	 * @description       : Integration request bean class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/

	public class cls_Request {
		public cls_ApplicationDV ApplicationDV;
	}
	/**
	 * @description       : Integration request bean class for Commercial Bureau Enquiry
	 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
	 * Ver   Date         Author                       Modification
	 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)  Initial Version
	 **/
	public class cls_ApplicationDV {
		public String APPPCCEID;
	}
}