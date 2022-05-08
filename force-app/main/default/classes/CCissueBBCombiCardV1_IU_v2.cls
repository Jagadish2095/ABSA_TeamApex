/**
*
* @author  Mbuyiseni Mbhokane
* @since   2020-07-27
*
**/
public class CCissueBBCombiCardV1_IU_v2 {

    public static CCissueBBCombiCardV1_Req_IB_v2 mapRequestFields(String consumerID, String clientCode, String accountNumber, String productCode, String brandNumber,
                                                                 String issueBranch, String sbuCode, String secClientCode, String nameIndicator, String persName, String nomCheq,
                                                                 String nomSavs, String deliveryMethod, String persIndicator){

        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        CCissueBBCombiCardV1_Req_IB_v2 requestBean = new CCissueBBCombiCardV1_Req_IB_v2();
		CCissueBBCombiCardV1_Req_IB_v2.NBSAPDPI nbsapdpiBean = new CCissueBBCombiCardV1_Req_IB_v2.NBSAPDPI();
		CCissueBBCombiCardV1_Req_IB_v2.NBSMSGI nbsmsgiBean = new CCissueBBCombiCardV1_Req_IB_v2.NBSMSGI();
		CCissueBBCombiCardV1_Req_IB_v2.CCS868I ccs868iBean = new CCissueBBCombiCardV1_Req_IB_v2.CCS868I();

		CCissueBBCombiCardV1_Req_IB_v2.InputHeaders inputHeaderBean = new CCissueBBCombiCardV1_Req_IB_v2.InputHeaders();
		CCissueBBCombiCardV1_Req_IB_v2.InputErrorMessage inputErrorMsgBean = new CCissueBBCombiCardV1_Req_IB_v2.InputErrorMessage();
        CCissueBBCombiCardV1_Req_IB_v2.InputCopybook inputCopyBookBean = new CCissueBBCombiCardV1_Req_IB_v2.InputCopybook();
        
        //issue branch check
        String issueBranchCode = String.isEmpty(issueBranch) ? currentUser.SiteCode__c : issueBranch;

		inputHeaderBean.applicationName = 'BDP';
		inputHeaderBean.channelName = 'BDP';
		inputHeaderBean.traceIndicator = 'Y';
		nbsapdpiBean.inputHeaders = inputHeaderBean;
		requestBean.NBSAPDPI = nbsapdpiBean;

		inputErrorMsgBean.errorMessageLanguage = 'E';
		inputErrorMsgBean.errorMessgeTarget = 'STD';
		nbsmsgiBean.inputErrorMessage = inputErrorMsgBean;
		requestBean.NBSMSGI = nbsmsgiBean;

        inputCopyBookBean.tellerCode = currentUser.Teller_Operator_Code__c;
        inputCopyBookBean.workStation = '99';//need to confirm
        inputCopyBookBean.supervisor = currentUser.Supervisor__c;
        inputCopyBookBean.branchCode = currentUser.SiteCode__c;
        inputCopyBookBean.consumerID = consumerID;
        inputCopyBookBean.clientCode = clientCode;
        inputCopyBookBean.accountNumber = accountNumber;
        inputCopyBookBean.productCode = productCode;
        inputCopyBookBean.brandNumber = brandNumber;
        inputCopyBookBean.issueBranch = issueBranchCode;
        inputCopyBookBean.sbuCode = sbuCode;
        inputCopyBookBean.secClientCode = secClientCode;
        inputCopyBookBean.persIndicator = persIndicator;
        inputCopyBookBean.nameIndicator = nameIndicator;
        inputCopyBookBean.persName = persName;
        inputCopyBookBean.nomCheq = nomCheq;
        inputCopyBookBean.nomSavs = nomSavs;
        inputCopyBookBean.deliveryMethod = deliveryMethod;
        inputCopyBookBean.deliveryBranch = currentUser.SiteCode__c;
        inputCopyBookBean.blindIndicator = 'N'; //need to confirm
        ccs868iBean.inputCopybook = inputCopyBookBean;
        requestBean.CCS868I = ccs868iBean;
        
		return requestBean;

    }
}