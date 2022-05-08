public class GetAccountDetailsViaRef_IU_v1 
{
    public static GetAccountDetailsViaRef_Req_IB_v1 mapRequestFields(String channel, String application, String trace, String avsruser, String reference, Integer reqDate, Integer reqTime, Integer reqCount)
    {           
        GetAccountDetailsViaRef_Req_IB_v1 reqBean = new GetAccountDetailsViaRef_Req_IB_v1();

        reqBean.channel = channel;
    	reqBean.application = application;
    	reqBean.trace = trace;
    	reqBean.avsruser = avsruser;
	    reqBean.reference = reference;
	    reqBean.reqDate = reqDate;
	    reqBean.reqTime = reqTime;
	    reqBean.reqCount = reqCount;
       
        System.debug('Get Account Details Via Reference Request Bean: ' + reqBean);
        return reqBean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: GetAccountDetailsViaRef_Resp_IB_v1 bean object
     */
    public static GetAccountDetailsViaRef_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        GetAccountDetailsViaRef_Resp_IB_v1 bean = new GetAccountDetailsViaRef_Resp_IB_v1();
        GetAccountDetailsViaRef_Resp_IB_v1 responseBean = (GetAccountDetailsViaRef_Resp_IB_v1)bean.deserialize(responseP.getBody(), GetAccountDetailsViaRef_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: GetAccountDetailsViaRef_Resp_IB_v1 bean object
     * */    
    public static GetAccountDetailsViaRef_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        GetAccountDetailsViaRef_Resp_IB_v1 responseBean = new GetAccountDetailsViaRef_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}