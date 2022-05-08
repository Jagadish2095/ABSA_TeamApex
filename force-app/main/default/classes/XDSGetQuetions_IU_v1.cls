/**
* Apex Integration Utility Bean class for XDSGetQuetions service
* @author  Madhava Palla : Absa
* @since   2019-08-21
*
**/
public class XDSGetQuetions_IU_v1 {
    
     /* Creates a Request Bean from the Accounts 
    * @param: List of Account objects
    * @return: XDSGetQuetions_Req_IB_v1 bean object
    * */
    
    public static XDSGetQuetions_Req_IB_v1 mapRequestFields(Account accRec){
        XDSGetQuetions_Req_IB_v1 requestBean = new XDSGetQuetions_Req_IB_v1();
        requestBean.idNumber = accRec.ID_Number__pc;
        requestBean.surname = accRec.lastname;
        return requestBean;
    }
    
    
     /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: XDSGetQuestions_Resp_IB_v1 bean object
    * */
    
    public static XDSGetQuetions_Resp_IB_v1 mapResponseFields(HttpResponse respP,Account accRec){
        XDSGetQuetions_Resp_IB_v1 responseBean = (XDSGetQuetions_Resp_IB_v1)JSON.deserialize(respP.getBody(),XDSGetQuetions_Resp_IB_v1.class);
       
        
        responseBean.StatusMessage = respP.getStatus();
		responseBean.StatusCode = respP.getstatusCode();
        return responseBean;
    }
    
    //added by srikanth as part of Power of attornery verification
      public static XDSGetQuetions_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        XDSGetQuetions_Resp_IB_v1 responseBean = (XDSGetQuetions_Resp_IB_v1)JSON.deserialize(respP.getBody(),XDSGetQuetions_Resp_IB_v1.class);
         system.debug(responseBean.questions);
          responseBean.StatusMessage = respP.getStatus();
		responseBean.StatusCode = respP.getstatusCode();
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: XDSGetQuetions_Resp_IB_v1 bean object
    * */
    public static XDSGetQuetions_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        XDSGetQuetions_Resp_IB_v1 responseBean = new XDSGetQuetions_Resp_IB_v1();
        responseBean.Message=messageP;
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        return responseBean;
    }

}