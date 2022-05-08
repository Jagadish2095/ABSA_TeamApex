public class CreateWillRecord_IU_v1 {
	public static CreateWillRecord_Req_IB_v1 mapRequestFields(String willNo, String cIFKey, Integer domicileSite, String corpCode, Integer transactionSite, Integer tellerNo, Integer effectiveDate)
    {           
        CreateWillRecord_Req_IB_v1 reqBean = new CreateWillRecord_Req_IB_v1();
                
        reqBean.WillNo = willNo;
        reqBean.CIFKey = cIFKey;
        reqBean.DomicileSite = domicileSite;
        reqBean.CorpCode = corpCode;
        reqBean.TransactionSite = transactionSite;
        reqBean.TellerNo = tellerNo;   
        reqBean.EffectiveDate = effectiveDate;      
       
        System.debug('Create Will Record Request Bean: ' + reqBean);
        return reqBean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CreateWillRecord_Req_IB_v1 bean object
     */
    public static CreateWillRecord_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {    
        System.debug('###############: ' + responseP.getBody());
        CreateWillRecord_Resp_IB_v1 bean = new CreateWillRecord_Resp_IB_v1();
        CreateWillRecord_Resp_IB_v1 responseBean = (CreateWillRecord_Resp_IB_v1)bean.deserialize(responseP.getBody(), CreateWillRecord_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Create Will Record Response Bean: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: CreateWillRecord_Resp_IB_v1 bean object
     * */    
    public static CreateWillRecord_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CreateWillRecord_Resp_IB_v1 responseBean = new CreateWillRecord_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}