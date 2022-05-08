/**
* @description Integration Handler for  CCissueCombiCard service
* @author Lulu Rankwe
* @created March 202o
*/

public class CCissueCombiCard_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'CCissueCombiCardV1';
    
    /**
	 * @description SMath: 06 June 2021: Callout method to issueCombiCard
	 * @param accountNo
     * @param issueBranch
     * @param persInd
     * @param brandNbr
     * @param autoLink
     * @param persName
     * @param persTitl
     * @param persInit
     * @param persSurn
     * @param delvBranch
     * @param tellerCode
     * @param supervisor
     * @param branchCode
     * @param sbuCode
     * @param clntCode
     * @param nomCheq
     * @param nomSavs
     * @param nomCred
     * @param cardNbr
	 * @return CCissueCombiCardV1_Resp_IB_v1 
	 */  
    public static CCissueCombiCardV1_Resp_IB_v1 issueCombiCard(String accountNo, String issueBranch,String persInd, String brandNbr,
    String autoLink,String persName,String persTitl,String persInit,String persSurn,String delvBranch,
    String tellerCode , String supervisor,String branchCode, String sbuCode,String clntCode, String nomCheq,String nomSavs, String nomCred, String cardNbr) {
        CCissueCombiCardV1_Req_IB_v1 requestBean = CCissueCombiCardV1_IU_v1.mapRequestFields(accountNo, issueBranch, persInd, brandNbr, autoLink, persName, persTitl, persInit, persSurn, delvBranch, tellerCode, supervisor, branchCode, sbuCode, clntCode, nomCheq, nomSavs, nomCred, cardNbr);
        CCissueCombiCardV1_Resp_IB_v1 responseBean = (CCissueCombiCardV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CCissueCombiCardV1_Resp_IB_v1.class);

        return responseBean;
    }
}