/** 
 * @description Integration Utilities for MLgetAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public class MLgetAcctInfoCUS1V1_IU_v1 extends Base_IB{
    /**
	 * @description method to create request and return response
	 * @param accountNumber
     * @param requestType
	 * @return MLgetAcctInfoCUS1V1_Req_IB_v1
	 */
    public static MLgetAcctInfoCUS1V1_Req_IB_v1 mapRequestFields(String accountNumber, String requestType) {

        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        MLgetAcctInfoCUS1V1_Req_IB_v1 requestBean = new MLgetAcctInfoCUS1V1_Req_IB_v1();
        requestBean.NBSAPDPI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSAPLI();
        requestBean.NBSMSGI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSMSGI_Z();
        requestBean.NBSMSGI.NBSMSGI = new MLgetAcctInfoCUS1V1_Req_IB_v1.NBSMSGI();
        requestBean.MLB854I = new MLgetAcctInfoCUS1V1_Req_IB_v1.MLB854I();
        requestBean.MLB854I.MLB854I_INPUT_AREA = new MLgetAcctInfoCUS1V1_Req_IB_v1.MLB854I_INPUT_AREA();
        
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_ACCT_NUMBER= long.valueOf(accountNumber);
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_USER_ID = currentUser.AB_Number__c;//'ABGE081';
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_SITE_CODE = currentUser.SiteCode__c;//'TEST';
        requestBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_REQ_TYPE = requestType;

        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL ='API';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION ='Gateway';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION ='';

        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE= 'E';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET= 'STD';

        return requestBean;
    }
    
}