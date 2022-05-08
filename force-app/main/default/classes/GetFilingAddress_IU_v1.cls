public class GetFilingAddress_IU_v1 
{
	public static GetFilingAddress_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Get Filing Address Response body: ' + respP.getBody());
        GetFilingAddress_Resp_IB_v1 responseBean = (GetFilingAddress_Resp_IB_v1)JSON.deserialize( respP.getBody(), GetFilingAddress_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Get Filing Address Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static GetFilingAddress_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        GetFilingAddress_Resp_IB_v1 responseBean = new GetFilingAddress_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
}