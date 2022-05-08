public class HLallocateStockNumber_IU_v1 
{
    public static HLallocateStockNumber_Req_IB_v1 mapRequestFields(String channelP, String applicationP, String traceP, String msgLanguageP, String msgTargetP, String finalMsgClassP, String finalMsgCodeP, String prodCategoryP, String prodTypeP, String prodCodeP, String siteCodeP)
    {               
        HLallocateStockNumber_Req_IB_v1 requestBean = new HLallocateStockNumber_Req_IB_v1();
        
        HLallocateStockNumber_Req_IB_v1.cls_Nbsapdpi sect1 = new HLallocateStockNumber_Req_IB_v1.cls_Nbsapdpi();
        sect1.channel = channelP;
        sect1.application = applicationP;
        sect1.trace = traceP;
            
        HLallocateStockNumber_Req_IB_v1.cls_FinalMsgId sect2sub = new HLallocateStockNumber_Req_IB_v1.cls_FinalMsgId();
        sect2sub.finalMsgClass = finalMsgClassP;
        sect2sub.finalMsgCode = finalMsgCodeP;
            
        HLallocateStockNumber_Req_IB_v1.cls_Nbsmsgi sect2 = new HLallocateStockNumber_Req_IB_v1.cls_Nbsmsgi();
        sect2.msgLanguage = msgLanguageP;
        sect2.msgTarget = msgTargetP;
        sect2.finalMsgId = sect2sub;
                   
        HLallocateStockNumber_Req_IB_v1.cls_Hlp110i sect3 = new HLallocateStockNumber_Req_IB_v1.cls_Hlp110i();
        sect3.prodCategory = prodCategoryP;
        sect3.prodType = prodTypeP;
        sect3.prodCode = prodCodeP;
        sect3.siteCode = siteCodeP;
            
        HLallocateStockNumber_Req_IB_v1 requestStockNumber = new HLallocateStockNumber_Req_IB_v1();
        requestStockNumber.nbsapdpi = sect1;
        requestStockNumber.nbsmsgi = sect2;
        requestStockNumber.hlp110i = sect3;
        
        requestBean = requestStockNumber;
        
        System.debug('HLallocate Stock Number Request Bean: ' + requestBean);
        return requestBean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: HLallocateStockNumber_Resp_IB_v1 bean object
     */
    public static HLallocateStockNumber_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {  
    	HLallocateStockNumber_Resp_IB_v1 bean = new HLallocateStockNumber_Resp_IB_v1();  
        HLallocateStockNumber_Resp_IB_v1 responseBean = (HLallocateStockNumber_Resp_IB_v1)bean.deserialize(responseP.getBody(), HLallocateStockNumber_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: HLallocateStockNumber_Resp_IB_v1 bean object
     * */    
    public static HLallocateStockNumber_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        HLallocateStockNumber_Resp_IB_v1 responseBean = new HLallocateStockNumber_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
}