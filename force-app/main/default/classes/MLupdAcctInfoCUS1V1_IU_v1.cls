/** 
 * @description Integration Utilities for MLupdAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public  class MLupdAcctInfoCUS1V1_IU_v1 extends Base_IB {
    /**
	 * @description method to create request and return response
	 * @param accountNumber
     * @param primaryAccountId
     * @param newDueDay
     * @param refNumber
     * @param schemaCode
     * @param requestType
	 * @return MLupdAcctInfoCUS1V1_Req_IB_v1
	 */
    public static MLupdAcctInfoCUS1V1_Req_IB_v1 mapRequestFields(String accountNumber, String primaryAccountId, Integer newDueDay, Integer refNumber, Double schemaCode, String requestType) {
        
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

        MLupdAcctInfoCUS1V1_Req_IB_v1 requestBean = new MLupdAcctInfoCUS1V1_Req_IB_v1();
        requestBean.NBSAPDPI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSAPLI();
        requestBean.NBSMSGI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSMSGI_Z();
        requestBean.NBSMSGI.NBSMSGI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSMSGI();
        requestBean.MLB855I = new MLupdAcctInfoCUS1V1_Req_IB_v1.MLB855I();
        requestBean.MLB855I.MLB855I_INPUT_AREA = new MLupdAcctInfoCUS1V1_Req_IB_v1.MLB855I_INPUT_AREA();

        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL ='API';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION ='Gateway';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE ='';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE= 'E';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET= 'STD';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_ACCT_NUMBER= long.valueOf(accountNumber);
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_USER_ID = currentUser.AB_Number__c;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_SITE_CODE = '';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REF_NUMBER = refNumber;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REQ_TYPE = requestType;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_SCHM_CODE = schemaCode;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_PRIME_ACCT_ID = primaryAccountId;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_PRIME_ACCT_NUMBER = long.valueOf(accountNumber);
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_NEW_PAYMENT_DUE_DAY = newDueDay;
        
        return requestBean;
    }
}