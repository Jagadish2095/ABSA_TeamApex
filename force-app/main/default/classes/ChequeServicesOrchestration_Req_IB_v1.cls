/**
 * @description       : Request Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
 **/

public class ChequeServicesOrchestration_Req_IB_v1 extends Base_IB {
	public String trace;
	public String siteCode;
	public String restart;
	public String msgTarget;
	public String msgLanguage;
	public String maxret;
	public String finalMsgCode;
	public String finalMsgClass;
	public String clientcd;
	public String channel;
	public String application;
	public String accntnbr;
	public List<String> productFamilies;

	/**
	 * @description dummy request
	 * @author Englarmerdge Mongwe| 2021-06-11
	 * @return ChequeServicesOrchestration_Req_IB_v1
	 **/
	public static ChequeServicesOrchestration_Req_IB_v1 createDummyRequest() {
		ChequeServicesOrchestration_Req_IB_v1 requestBean = new ChequeServicesOrchestration_Req_IB_v1();

		requestBean.channel = StringConstants.SALESFORCE_STRING;
		requestBean.application = StringConstants.SALESFORCE_STRING;
		requestBean.trace = 'Y';

		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';

		requestBean.restart = '';
		requestBean.finalMsgCode = '';
		requestBean.finalMsgClass = '';

		requestBean.clientcd = 'SNIFFEL001'; //for multiplt accounts use REBELLO001, ARENTAL001, GREENJ 154 or SACOMPE061
		requestBean.accntnbr = '0';
		requestBean.siteCode = '8198';
		requestBean.maxret = '0';

		return requestBean;
	}
}