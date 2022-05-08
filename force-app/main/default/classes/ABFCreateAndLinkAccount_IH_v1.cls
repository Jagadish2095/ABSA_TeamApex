/*
* Integration Handler for create and link account 
* @author Almas Aleem:Absa  
* @created 2020-12-07
*/
public class ABFCreateAndLinkAccount_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'ABFCreateAndLinkAccount';
     public static ABFCreateAndLinkAccount_Resp_IB_v1 createAndLinkAccount(User user,String clientCode) {
         ABFCreateAndLinkAccount_Req_IB_v1 requestBean = ABFCreateAndLinkAccount_IU_v1.mapRequestFields(user,clientCode); //request mapping
         ABFCreateAndLinkAccount_Resp_IB_v1 responseBean = (ABFCreateAndLinkAccount_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, ABFCreateAndLinkAccount_Resp_IB_v1.class); //service callout
         
         return responseBean;
    }
}