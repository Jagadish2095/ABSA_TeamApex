public class GetWillDetails_IU_v1 {
    
    public static GetWillDetails_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Get Will Details Response body: ' + respP.getBody());
        GetWillDetails_Resp_IB_v1 responseBean = (GetWillDetails_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetWillDetails_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Get Will Details Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static GetWillDetails_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        GetWillDetails_Resp_IB_v1 responseBean = new GetWillDetails_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
}