/**
 * @description Request Integration Bean for CIgetAcctLinkedToClientCode Service
 * @author Pitso Sekhu
 * @created 2019-13-01
 */
public class CIgetAcctLinkedToClientCode_Req_IB_v1 extends Base_IB {
	public string channel;
	public string application;
	public string trace;
	public string msgLanguage;
	public string msgTarget;
	public String finalMsgClass;
	public String finalMsgCode;
	public string clientcd;
	public string accntnbr;
	public string maxret;
	public string restart;
	public string siteCode;
	/**
	 * @description creates dummy request record
	 * @return CIgetAcctLinkedToClientCode_Req_IB_v1
	 */
	public CIgetAcctLinkedToClientCode_Req_IB_v1 createDummyRequest() {
		CIgetAcctLinkedToClientCode_Req_IB_v1 reqBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();

		reqBean.channel = 'SALESFORCE';
		reqBean.application = 'WILLS';
		reqBean.trace = 'Y';
		reqBean.msgLanguage = 'E';
		reqBean.msgTarget = 'STD';
		reqBean.finalMsgClass = '';
		reqBean.finalMsgCode = '';
		reqBean.clientcd = 'GREENJ 154';
		reqBean.accntnbr = '0';
		reqBean.maxret = '0';
		reqBean.restart = '';
		reqBean.siteCode = '8196';

		return reqBean;
	}
}