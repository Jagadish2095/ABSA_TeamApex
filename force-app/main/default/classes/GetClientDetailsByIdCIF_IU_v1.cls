public class GetClientDetailsByIdCIF_IU_v1 {

    /* Method to Map Request fields to the bean
     * @Param: String Id Number
     * @Param: String Document Type
     * @Param: String Site Code
     * @Return: GetClientDetailsByIdCIF_Req_IB_v1 Bean
     * */
    public static GetClientDetailsByIdCIF_Req_IB_v1 mapRequestFields(String idNumberP, String idDocTypeP, String siteCodeP){
        
        GetClientDetailsByIdCIF_Req_IB_v1 requestBean = new GetClientDetailsByIdCIF_Req_IB_v1();
        requestBean.idNbr = idNumberP;
        requestBean.inpIdDocType = idDocTypeP;
        requestBean.siteCode = siteCodeP;
        requestBean.maxRecsToRtrv = '10';
        
        return requestBean;
    }
    
    /* Method to Map Response fields to the bean
     * @Param: HttpResponse
     * @Return: GetClientDetailsByIdCIF_Resp_IB_v1 Bean
     * */
    public static GetClientDetailsByIdCIF_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
        
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = new GetClientDetailsByIdCIF_Resp_IB_v1();
        responseBean = (GetClientDetailsByIdCIF_Resp_IB_v1)responseBean.deserialize( responseP.getBody(), GetClientDetailsByIdCIF_Resp_IB_v1.class );
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        return responseBean;
    }
    
    /* Method to Map Failed Response fields to the bean
     * @Param: Integer Status Code
     * @Param: String Status
     * @Param: String message
     * @Return: GetClientDetailsByIdCIF_Resp_IB_v1 Bean
     * */
    public static GetClientDetailsByIdCIF_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){ 
        
        GetClientDetailsByIdCIF_Resp_IB_v1 responseBean = new GetClientDetailsByIdCIF_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}