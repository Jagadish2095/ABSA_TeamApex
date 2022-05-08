public class RefreshRegulatoryCompliance_IU_v1 
{
	/* Creates a bean from the response 
      * @param: HTTP Response
      * @return: RefreshRegulatoryCompliance_Resp_IB_v1 bean object
     */
    public static RefreshRegulatoryCompliance_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {        
		RefreshRegulatoryCompliance_Resp_IB_v1 bean = new RefreshRegulatoryCompliance_Resp_IB_v1();
        RefreshRegulatoryCompliance_Resp_IB_v1 responseBean = (RefreshRegulatoryCompliance_Resp_IB_v1)bean.deserialize(responseP.getBody(), RefreshRegulatoryCompliance_Resp_IB_v1.class);
  
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';        

        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: GetRegulatoryCompliance_Resp_IB_v1 bean object
     * */    
    public static RefreshRegulatoryCompliance_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        RefreshRegulatoryCompliance_Resp_IB_v1 responseBean = new RefreshRegulatoryCompliance_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;

        return responseBean;
    }
}