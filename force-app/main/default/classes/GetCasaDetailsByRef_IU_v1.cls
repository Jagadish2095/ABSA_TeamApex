public class GetCasaDetailsByRef_IU_v1 {

    public static GetCasaDetailsByRef_Req_IB_v1 mapRequestFields(String refNoP, String startFromP){
        
        GetCasaDetailsByRef_Req_IB_v1 requestBean = new GetCasaDetailsByRef_Req_IB_v1();
        requestBean.refNo = refNoP;
        requestBean.startFrom = startFromP;
        
        return requestBean;
    }
    
    public static GetCasaDetailsByRef_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
        
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = new GetCasaDetailsByRef_Resp_IB_v1();
        responseBean = (GetCasaDetailsByRef_Resp_IB_v1)responseBean.deserialize( responseP.getBody(), GetCasaDetailsByRef_Resp_IB_v1.class );
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = responseBean.msg;
        
        return responseBean;
    }
    
    public static GetCasaDetailsByRef_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){ 
        
        GetCasaDetailsByRef_Resp_IB_v1 responseBean = new GetCasaDetailsByRef_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}