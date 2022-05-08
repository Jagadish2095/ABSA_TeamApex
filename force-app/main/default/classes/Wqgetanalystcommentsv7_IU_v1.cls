/**
* Apex Integration Utility Bean class for Wqgetanalystcommentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Wqgetanalystcommentsv7_IU_v1 {
  /* Creates a Request Bean from the Account 
    * @param:  Account object
    * @return: Wqgetanalystcommentsv7_Req_IB_v1 bean object
    * */
    public static Wqgetanalystcommentsv7_Req_IB_v1 mapRequestFields(Account accRec){
        Wqgetanalystcommentsv7_Req_IB_v1 requestBean = new Wqgetanalystcommentsv7_Req_IB_v1();
        Wqgetanalystcommentsv7_Req_IB_v1.WQgetAnalystCommentsV7Request WQgetAnalystCommentsbean  = new Wqgetanalystcommentsv7_Req_IB_v1.WQgetAnalystCommentsV7Request();
       
        //WQgetAnalystCommentsbean.refNo = '121132630';
        WQgetAnalystCommentsbean.refNo = accRec.CASA_Reference_Number__pc;
        //WQgetAnalystCommentsbean.refNo = casaRefNum;
        requestBean.WQgetAnalystCommentsV7Request = WQgetAnalystCommentsbean;
        return requestBean;  
    }
  
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: Wqgetanalystcommentsv7_Resp_IB_v1 bean object
    * */
    
    public static Wqgetanalystcommentsv7_Resp_IB_v1 mapResponseFields(HttpResponse respP,Account accRec){
        System.debug('respP body'+respP.getBody());//To be removed
        
        Wqgetanalystcommentsv7_Resp_IB_v1 responseBean = (Wqgetanalystcommentsv7_Resp_IB_v1)JSON.deserialize(respP.getBody(),Wqgetanalystcommentsv7_Resp_IB_v1.class);
        Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response WQgetAnalystCommentsresp = new Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response();
        Wqgetanalystcommentsv7_Resp_IB_v1.Results resultsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
       
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('Wqgetanalystcommentsv7 Service Success Response Bean after : ' + responseBean);//To be removed
        
        return responseBean;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: Wqgetanalystcommentsv7_Resp_IB_v1 bean object
    * */
    public static Wqgetanalystcommentsv7_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        Wqgetanalystcommentsv7_Resp_IB_v1 responseBean = new Wqgetanalystcommentsv7_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('Wqgetanalystcommentsv7 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
    
}