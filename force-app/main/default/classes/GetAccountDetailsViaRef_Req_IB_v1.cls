public class GetAccountDetailsViaRef_Req_IB_v1 extends Base_IB
{
    public String channel;
    public String application;
    public String trace;
	public String avsruser;
    public String reference;
    public Integer reqDate;
    public Integer reqTime;
    public Integer reqCount;	
    
    public GetAccountDetailsViaRef_Req_IB_v1 createDummyRequest()
    {
    	GetAccountDetailsViaRef_Req_IB_v1 reqBean = new GetAccountDetailsViaRef_Req_IB_v1();
        
    	reqBean.channel = 'SALESFORCE';
    	reqBean.application = 'WILLS';
    	reqBean.trace = 'Y';
    	reqBean.avsruser = 'AVSR004000';
	    reqBean.reference = '1749288A5B';
	    reqBean.reqDate = 20170411;
	    reqBean.reqTime = 15150000;
	    reqBean.reqCount = 0;
	    
	    return reqBean;
    }    
}