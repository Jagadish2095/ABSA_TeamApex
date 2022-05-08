/**
* Apex Integration Request Bean class for DSretrieveDebitsCreditsInqV1 Service
* @author  Prasanna Patwardhan : Absa
* @since   2019-10-30
*
**/
public class DSretrieveDebitsCreditsInqV1_Req_IB_v1 extends Base_IB{
    public String channel;
	public String application;
	public String trace;
	public String msgLanguage;
	public String msgTarget;
    public String channelI;
	public String versionI;
	public String branch;
	public String functionI;
    public String acno;
	public String effFromDate;
	public String nxtTieb;
	
    
     public static DSretrieveDebitsCreditsInqV1_Req_IB_v1 createDummyRequest() {
        DSretrieveDebitsCreditsInqV1_Req_IB_v1 requestBean = new DSretrieveDebitsCreditsInqV1_Req_IB_v1();

        requestBean.channel = 'BDP';
        requestBean.application = 'Salesforce';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.channelI = 'Salesforce';
        requestBean.versionI = '0';
        requestBean.branch = '9713';
        requestBean.functionI = 'SPID';
        requestBean.acno = '09050987409';
        requestBean.effFromDate = '20180101';
        requestBean.nxtTieb = '0';
        return requestBean;
      
    }

}