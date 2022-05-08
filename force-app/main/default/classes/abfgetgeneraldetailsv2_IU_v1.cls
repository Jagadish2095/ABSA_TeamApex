/**
* Apex Integration Utility Bean class for abfgetgeneraldetailsv2 service
* @author  Srikanth N : Absa
* @since   2020-05-05
*
**/
public class abfgetgeneraldetailsv2_IU_v1 {
    /* Creates a Request Bean from the Account 
* @param: List of Case objects
* @return: abfgetgeneraldetailsv2_Req_IB_v1 bean object
* */
    public static abfgetgeneraldetailsv2_Req_IB_v1 mapRequestFields(String accountNbr){
        abfgetgeneraldetailsv2_Req_IB_v1 requestBean = new abfgetgeneraldetailsv2_Req_IB_v1();
        abfgetgeneraldetailsv2_Req_IB_v1.nbsmsgi nbsmsgiBean = new abfgetgeneraldetailsv2_Req_IB_v1.nbsmsgi();
        abfgetgeneraldetailsv2_Req_IB_v1.nbsapdpi nbsapdpiBean = new abfgetgeneraldetailsv2_Req_IB_v1.nbsapdpi();
        abfgetgeneraldetailsv2_Req_IB_v1.finalMsgId finalMsgIdBean = new abfgetgeneraldetailsv2_Req_IB_v1.finalMsgId();
        abfgetgeneraldetailsv2_Req_IB_v1.plpa20i plpa20iBean = new abfgetgeneraldetailsv2_Req_IB_v1.plpa20i();
       
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.trace = 'Y';
        nbsmsgiBean.msgTarget = 'STD';
        nbsmsgiBean.msgLanguage = 'E';
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        nbsmsgiBean.finalMsgId = finalMsgIdbean;
        plpa20iBean.accountNbr = accountNbr ; //'4048276744';
        abfgetgeneraldetailsv2_Req_IB_v1.abfgetgeneraldetailsv2 abfgetgeneraldetailsv2Bean = new abfgetgeneraldetailsv2_Req_IB_v1.abfgetgeneraldetailsv2();
        abfgetgeneraldetailsv2Bean.nbsapdpi = nbsapdpiBean;
        abfgetgeneraldetailsv2Bean.nbsmsgi = nbsmsgiBean;
        abfgetgeneraldetailsv2Bean.plpa20i = plpa20iBean;
        requestBean.abfgetgeneraldetailsv2 = abfgetgeneraldetailsv2Bean;        
        return requestBean;  
    }
    
    
    /* Creates a bean from the response 
* @param: HTTP Response
* @return: abfgetgeneraldetailsv2_Resp_IB_v1 bean object
* */
    
    public static abfgetgeneraldetailsv2_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        System.debug('respP body'+respP.getBody());//To be removed
        abfgetgeneraldetailsv2_Resp_IB_v1 responseBean = (abfgetgeneraldetailsv2_Resp_IB_v1)JSON.deserialize(respP.getBody(),abfgetgeneraldetailsv2_Resp_IB_v1.class);
        abfgetgeneraldetailsv2_Resp_IB_v1.abfgetgeneraldetailsv2Response WQgetAnalystCommentsresp = new abfgetgeneraldetailsv2_Resp_IB_v1.abfgetgeneraldetailsv2Response();
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('abfgetgeneraldetailsv2 Service Success Response Bean after : ' + responseBean);//To be removed
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
* @param: Status Code
* @param: Status
* @param: message
* @return: abfgetgeneraldetailsv2_Resp_IB_v1 bean object
* */
    public static abfgetgeneraldetailsv2_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        abfgetgeneraldetailsv2_Resp_IB_v1 responseBean = new abfgetgeneraldetailsv2_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('abfgetgeneraldetailsv2 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}