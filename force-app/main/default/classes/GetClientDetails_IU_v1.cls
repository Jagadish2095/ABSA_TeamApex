public class GetClientDetails_IU_v1 {
    
    //Populates the Get Client Details request bean from the parameters passed
    public static GetClientDetails_Req_IB_v1 mapRequestFields(String clientCodeP, String accNumberP, String siteCodeP){
        
        GetClientDetails_Req_IB_v1 requestBean = new GetClientDetails_Req_IB_v1();
        requestBean.inpClientCode = clientCodeP;
        requestBean.clntAcctNbr = accNumberP;
        requestBean.siteCode = siteCodeP;
        
        System.debug('Get Client Details Request Bean: ' + requestBean);
        return requestBean;
    }
    
    //Populates the Get Client Details response bean from an http response
    public static GetClientDetails_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        GetClientDetails_Resp_IB_v1 responseBean = new GetClientDetails_Resp_IB_v1();
        responseBean = (GetClientDetails_Resp_IB_v1)responseBean.deserialize( respP.getBody(), GetClientDetails_Resp_IB_v1.class );
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Get Client Details Response Bean: ' + responseBean);
        return responseBean;
    }
    
    //Populates the Get Client Details response bean as failed with the necessary data
    public static GetClientDetails_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        GetClientDetails_Resp_IB_v1 getClientDetailsResponse = new GetClientDetails_Resp_IB_v1();
        getClientDetailsResponse.message = messageP;
        getClientDetailsResponse.status = statusP;
        getClientDetailsResponse.statusCode = statusCodeP;
        
        System.debug('Get Client Details Failed Response Bean: ' + getClientDetailsResponse);
        return getClientDetailsResponse;
    }
    
}