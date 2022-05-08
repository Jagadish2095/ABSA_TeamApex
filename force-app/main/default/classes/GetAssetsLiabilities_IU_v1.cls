public class GetAssetsLiabilities_IU_v1 
{    
    public static GetAssetsLiabilities_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Get Assets Liabilities Response body: ' + respP.getBody());
        GetAssetsLiabilities_Resp_IB_v1 responseBean = (GetAssetsLiabilities_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetAssetsLiabilities_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Get Assets Liabilities Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static GetAssetsLiabilities_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        GetAssetsLiabilities_Resp_IB_v1 responseBean = new GetAssetsLiabilities_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
}