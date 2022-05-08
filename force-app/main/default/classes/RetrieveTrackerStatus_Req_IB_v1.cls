public class RetrieveTrackerStatus_Req_IB_v1 extends Base_IB 
{
	public String channel;
	public String application;
	public String trace;
	public String msgLanguage;
	public String msgTarget;
	public String willNo;
    
    public RetrieveTrackerStatus_Req_IB_v1 createDummyRequest()
    {           
        RetrieveTrackerStatus_Req_IB_v1 trackerStatus = new RetrieveTrackerStatus_Req_IB_v1();
        trackerStatus.channel = 'WILLS';
        trackerStatus.application = 'WILLS';
        trackerStatus.trace = 'N';
        trackerStatus.msgLanguage = 'E';
        trackerStatus.msgTarget = 'STD';
        trackerStatus.willNo = '41000014420';
        
        System.debug('RetrieveTrackerStatus_Req: ' + trackerStatus);
        return trackerStatus;
    }
}