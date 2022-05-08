/**
* Apex Integration Utilities  class for Banker details from CMS service
* @author  Diksha Wasekar : Absa
* @Created By  Diksha Wasekar: Absa
* @Created Date:  2019-09-07
* 
*
**/

public class CMSGetBankerInfo_IU_v1 
{
     
    public static CMSGetBankerInfo_Req_IB_V1 mapFieldscmsBankerInfoRequest(String application,String clientcd) 
    
    {
        
        CMSGetBankerInfo_Req_IB_V1 cmsBankerInfoRequest = new CMSGetBankerInfo_Req_IB_V1();
         
          cmsBankerInfoRequest.application=application;
          cmsBankerInfoRequest.channel=StringConstants.SALESFORCE_STRING;
          cmsBankerInfoRequest.msgLanguage='E';
          cmsBankerInfoRequest.msgTarget='STD';
          cmsBankerInfoRequest.trace='Y';
          cmsBankerInfoRequest.clientCode=clientcd;
            
        
        return cmsBankerInfoRequest;
    }
    
     /* Creates a bean from the response 
	* @param: HTTP Response
	* @return: CMSGetBankerInfo_Resp_IB_v1 bean object
	* */
	public static CMSGetBankerInfo_Resp_IB_v1 mapResponseFields(HttpResponse responseP) {
        
        CMSGetBankerInfo_Resp_IB_v1 responseBean= new CMSGetBankerInfo_Resp_IB_v1();
		CMSGetBankerInfo_Resp_IB_v1 responseBeanContent = (CMSGetBankerInfo_Resp_IB_v1)responseBean.deserialize(responseP.getBody() , CMSGetBankerInfo_Resp_IB_v1.class);
		
        
        
        responseBeanContent.status = responseP.getStatus();
        responseBeanContent.statusCode = responseP.getStatusCode();
        responseBeanContent.message = '';
        
        return responseBeanContent;

	}

        /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
    * @param: Status Code
    * @param: Status
    * @param: message
    * @return: CMSGetBankerInfo_Resp_IB_v1 bean object
    * */
    
    public static CMSGetBankerInfo_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        CMSGetBankerInfo_Resp_IB_v1 responseBean = new CMSGetBankerInfo_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }
    
    


}