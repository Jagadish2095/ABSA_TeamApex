public class GetJointParticipant_IU_v1 
{
    public static GetJointParticipant_Req_IB_v1 mapRequestFields(String clientCodeP)
    {           
        GetJointParticipant_Req_IB_v1 bean = new GetJointParticipant_Req_IB_v1();
        bean.clntCde = clientCodeP;
       
        System.debug('Joint Participant Request Bean: ' + bean);
        return bean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: GetJointParticipant_Resp_IB_v1 bean object
     */
    public static GetJointParticipant_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        GetJointParticipant_Resp_IB_v1 bean = new GetJointParticipant_Resp_IB_v1();
        GetJointParticipant_Resp_IB_v1 responseBean = (GetJointParticipant_Resp_IB_v1)bean.deserialize(responseP.getBody(), GetJointParticipant_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: GetJointParticipant_Resp_IB_v1 bean object
     * */    
    public static GetJointParticipant_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        GetJointParticipant_Resp_IB_v1 responseBean = new GetJointParticipant_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}