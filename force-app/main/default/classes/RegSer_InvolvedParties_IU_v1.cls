public class RegSer_InvolvedParties_IU_v1 {
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: RegSer_InvolvedParties_Resp_IB_v1 bean object
* */
    
    public static RegSer_InvolvedParties_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
        RegSer_InvolvedParties_Resp_IB_v1 bean = new RegSer_InvolvedParties_Resp_IB_v1();
        RegSer_InvolvedParties_Resp_IB_v1 responseBean = (RegSer_InvolvedParties_Resp_IB_v1)bean.deserialize(responseP.getBody(), RegSer_InvolvedParties_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        System.debug('Reg Services Involved Parties Response bean: ' + responseBean);
        
        return responseBean; 
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: RegSer_InvolvedParties_Resp_IB_v1 bean object
* */
    public static RegSer_InvolvedParties_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        RegSer_InvolvedParties_Resp_IB_v1 responseBean = new RegSer_InvolvedParties_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean; 
    }
    
}