public class RetrieveTrackerStatus_IU_v1 
{
    public static RetrieveTrackerStatus_Req_IB_v1 mapRequestFields(String channel, String application, String trace, 
    			String msgLanguage, String msgTarget, String willNo)
    {           
        RetrieveTrackerStatus_Req_IB_v1 trackerStatus = new RetrieveTrackerStatus_Req_IB_v1();
        trackerStatus.channel = channel;
        trackerStatus.application = application;
        trackerStatus.trace = trace;
        trackerStatus.msgLanguage = msgLanguage;
        trackerStatus.msgTarget = msgTarget;
        trackerStatus.willNo = willNo;
       
        System.debug('Retrieve Tracker Status Request Bean: ' + trackerStatus);
        return trackerStatus;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: RetrieveTrackerStatus_Resp_IB_v1 bean object
     */
    public static RetrieveTrackerStatus_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        RetrieveTrackerStatus_Resp_IB_v1 bean = new RetrieveTrackerStatus_Resp_IB_v1();
        RetrieveTrackerStatus_Resp_IB_v1 responseBean = (RetrieveTrackerStatus_Resp_IB_v1)bean.deserialize(responseP.getBody(), RetrieveTrackerStatus_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: RetrieveTrackerStatus_Resp_IB_v1 bean object
     * */    
    public static RetrieveTrackerStatus_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        RetrieveTrackerStatus_Resp_IB_v1 responseBean = new RetrieveTrackerStatus_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}