/**
* Apex Integration Utility Bean class for Generatedocumentsv7 service
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Generatedocumentsv7_IU_v1 {
     /* Creates a Request Bean from the Account 
    * @param: List of Case objects
    * @return: Wqgetanalystcommentsv7_Req_IB_v1 bean object
    * */
    public static Generatedocumentsv7_Req_IB_v1 mapRequestFields(Account accRecP){
        Generatedocumentsv7_Req_IB_v1 requestBean = new Generatedocumentsv7_Req_IB_v1();
        Generatedocumentsv7_Req_IB_v1.GetDocsRequest GetDocsRequestbean  = new Generatedocumentsv7_Req_IB_v1.GetDocsRequest();
        
        Usersselector us = new Usersselector();
        List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
        if(accRecP.Client_Group__c == 'Non Individual' || accRecP.Client_Group__c == 'JOINT AND SEVERAL CLIENT'){
        GetDocsRequestbean.RefNumber = accRecP.CASA_Reference_Number__c;
        }else{
           GetDocsRequestbean.RefNumber = accRecP.CASA_Reference_Number__pc; 
        }
        GetDocsRequestbean.SBU = '';
        GetDocsRequestbean.OriginatingSystem = 'ESP';
        GetDocsRequestbean.Branch = userP[0].SiteCode__c;
        GetDocsRequestbean.InitialAB = userP[0].AB_Number__c; 
        GetDocsRequestbean.Additional_Docs = ''; 
        requestBean.GetDocsRequest = GetDocsRequestbean;
        return requestBean;  
    }
  
    
    /* Creates a bean from the response 
    * @param: HTTP Response
    * @return: Generatedocumentsv7_Resp_IB_v1 bean object
    * */
    
    public static Generatedocumentsv7_Resp_IB_v1 mapResponseFields(HttpResponse respP,Account accRec){
        System.debug('respP body'+respP.getBody());//To be removed
        
        Generatedocumentsv7_Resp_IB_v1 responseBean = (Generatedocumentsv7_Resp_IB_v1)JSON.deserialize(respP.getBody(),Generatedocumentsv7_Resp_IB_v1.class);
        Generatedocumentsv7_Resp_IB_v1.GetDocsResponse GetDocsResponseresp = new Generatedocumentsv7_Resp_IB_v1.GetDocsResponse();
        //Generatedocumentsv7_Resp_IB_v1.Results resultsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
        
        //String docNum = GetDocsResponseresp.DocNo;
         
        responseBean.StatusMessage = respP.getStatus();
        responseBean.StatusCode = respP.getstatusCode();
        System.debug('Generatedocumentsv7 Service Success Response Bean after : ' + responseBean);//To be removed
      
        return responseBean;
    }

    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: Generatedocumentsv7_Resp_IB_v1 bean object
    * */
    public static Generatedocumentsv7_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        Generatedocumentsv7_Resp_IB_v1 responseBean = new Generatedocumentsv7_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('Generatedocumentsv7 Service Failed Response Bean: ' + responseBean);//To be removed
        return responseBean;
    }
}