public class GetXmlWillDraft_IU_v1
 {
    public static GetXmlWillDraft_Resp_IB_v1 mapResponseFields(HttpResponse respP)
    {
        
        System.debug('Get Xml Will Draft Response body: ' + respP.getBody());
        GetXmlWillDraft_Resp_IB_v1 responseBean = (GetXmlWillDraft_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetXmlWillDraft_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Get Xml Will Draft Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static GetXmlWillDraft_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        GetXmlWillDraft_Resp_IB_v1 responseBean = new GetXmlWillDraft_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}