public class SaveXmlWillDraft_IU_v1 
{    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: SaveXmlWillDraft_Resp_IB_v1 bean object
     */
    public static SaveXmlWillDraft_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        SaveXmlWillDraft_Resp_IB_v1 bean = new SaveXmlWillDraft_Resp_IB_v1();
        SaveXmlWillDraft_Resp_IB_v1 responseBean = (SaveXmlWillDraft_Resp_IB_v1)bean.deserialize(responseP.getBody(), SaveXmlWillDraft_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Save Xml Will Draft Response Bean: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: SaveXmlWillDraft_Resp_IB_v1 bean object
     * */    
    public static SaveXmlWillDraft_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        SaveXmlWillDraft_Resp_IB_v1 responseBean = new SaveXmlWillDraft_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }        
}