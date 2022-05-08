public class CreateTracker_IU_v1 
{
    public static CreateTracker_Req_IB_v1 mapRequestFields(String channel, String application, String trace, 
    			String willNo, String tstatus, String dateCreated, String timeCreated, String userId, String sstatus, String statCd, 
    			String filLoc, String prevId, String action, String comments, String branchCd)
    {           
        CreateTracker_Req_IB_v1 createTracker = new CreateTracker_Req_IB_v1();
        createTracker.channel = channel;
        createTracker.application = application;
        createTracker.trace = trace;
        createTracker.willNo = willNo;
        createTracker.tstatus = tstatus;
        createTracker.dateCreated = dateCreated;
        createTracker.timeCreated = timeCreated;
        createTracker.userId = userId;
        createTracker.sstatus = sstatus;
        createTracker.statCd = statCd;
        createTracker.filLoc = filLoc;
        createTracker.prevId = prevId;
        createTracker.action = action;
        createTracker.comments = comments;
        createTracker.branchCd = branchCd;
       
        System.debug('Create Tracker Request Bean: ' + createTracker);
        return createTracker;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CreateTracker_Resp_IB_v1 bean object
     */
    public static CreateTracker_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        CreateTracker_Resp_IB_v1 bean = new CreateTracker_Resp_IB_v1();
        CreateTracker_Resp_IB_v1 CreateTrackerResponse =(CreateTracker_Resp_IB_v1)bean.deserialize(responseP.getBody(), CreateTracker_Resp_IB_v1.class);
        
        CreateTrackerResponse.status = responseP.getStatus();
        CreateTrackerResponse.statusCode = responseP.getStatusCode();
        
        System.debug('createTracker Response Bean: ' + CreateTrackerResponse);
        return CreateTrackerResponse;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CreateTracker_Resp_IB_v1 bean object
     * */    
    public static CreateTracker_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CreateTracker_Resp_IB_v1 responseBean = new CreateTracker_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }

}