/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-08-10
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/

public class ChewyAgentLookup_IU_v1 {
    
       /**
       * @description 
       * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
       * @param respP 
       * @return ChewyAgentLookup_Resp_IB_v1 
       **/
       public static ChewyAgentLookup_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        System.debug('Chewy Agent lookup Response body: ' + respP.getBody());
        ChewyAgentLookup_Resp_IB_v1 responseBean = (ChewyAgentLookup_Resp_IB_v1)JSON.deserialize( respP.getBody(), ChewyAgentLookup_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('Chewy Agent lookup Response bean: ' + responseBean);
        return responseBean;
    }
    
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-08-10 
    * @param statusP 
    * @param statusCodeP 
    * @param messageP 
    * @return ChewyAgentLookup_Resp_IB_v1 
    **/
    public static ChewyAgentLookup_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        ChewyAgentLookup_Resp_IB_v1 responseBean = new ChewyAgentLookup_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    

}