/*
* Request Integration Bean for CIgetAcctLinkedToClientCodeV3 Service
* @author Khaliq Abdul
* @created 2021-02-26
*/
public class CIgetAcctLinkedToClientCodeV3_Req_IB_v1 extends Base_IB {
    
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
    
    public static CIgetAcctLinkedToClientCodeV3_Req_IB_v1 createDummyRequest()
    {                       
        CIgetAcctLinkedToClientCodeV3_Req_IB_v1 reqBean = new CIgetAcctLinkedToClientCodeV3_Req_IB_v1();
        
        reqBean.channel = 'SALESFORCE';
        reqBean.application = 'Salesforce';
        reqBean.trace = 'Y';
        reqBean.msgLanguage = 'E';
        reqBean.msgTarget = 'STD';
        reqBean.finalMsgClass = '';
        reqBean.finalMsgCode = '';
        reqBean.clientcd = 'ARENTAL001';//GREENJ 154';
        reqBean.accntnbr = '0';
        reqBean.maxret = '0';
        reqBean.restart = '';
        reqBean.siteCode = '8196'; 
        
        return reqBean;
    }

}