public class GetRegulatoryCompliance_IU_v1 
{
     /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: GetRegulatoryCompliance_Resp_IB_v1 bean object
     */
    public static GetRegulatoryCompliance_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {            
    	GetRegulatoryCompliance_Resp_IB_v1 bean = new GetRegulatoryCompliance_Resp_IB_v1();
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = (GetRegulatoryCompliance_Resp_IB_v1)bean.deserialize(responseP.getBody(), GetRegulatoryCompliance_Resp_IB_v1.class);
        
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
    public static GetRegulatoryCompliance_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        GetRegulatoryCompliance_Resp_IB_v1 responseBean = new GetRegulatoryCompliance_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}