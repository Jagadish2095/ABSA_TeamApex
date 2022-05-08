/*
* Controller class for Branch VAS components
* @author  André Pietersen : ABSA (IQ Business)
* @created 2021-02-09
*/

public class BranchUpdAcctHoldsController {
    public static Account acc;
    public static Opportunity opp;
    public static OpportunityLineItem oppproduct;
    public static List<User> userRec;

    @AuraEnabled
    public static String updateAccountHolds(String oppId)
    {
        System.debug(oppId);
        String errorMessage = '';
        setOpportunityDetails(oppId);
        CQupdAcctHoldsV5_Req_IB_v1 requestBean = new CQupdAcctHoldsV5_Req_IB_v1();
        CQupdAcctHoldsV5_Req_IB_v1.NBSAPDPI NBSAPDPIRequest = new CQupdAcctHoldsV5_Req_IB_v1.NBSAPDPI ();
        CQupdAcctHoldsV5_Req_IB_v1.NBSMSGI NBSMSGIRequest = new CQupdAcctHoldsV5_Req_IB_v1.NBSMSGI ();
        CQupdAcctHoldsV5_Req_IB_v1.CQS525I CQS525IRequest = new CQupdAcctHoldsV5_Req_IB_v1.CQS525I ();
        CQupdAcctHoldsV5_Req_IB_v1.InputHeaders inputheaders = new CQupdAcctHoldsV5_Req_IB_v1.InputHeaders();
        CQupdAcctHoldsV5_Req_IB_v1.inputErrorMessage inputErrMsgs = new CQupdAcctHoldsV5_Req_IB_v1.inputErrorMessage();
        CQupdAcctHoldsV5_Req_IB_v1.InputCopybook inputCpyBook = new CQupdAcctHoldsV5_Req_IB_v1.InputCopybook();

        inputheaders.applicationName = 'SF';
        inputheaders.channelName = 'SF';
        inputheaders.traceIndicator = 'N';
        NBSAPDPIRequest.inputHeaders = inputheaders;

        inputErrMsgs.inputMessageLanguage = 'E';
        inputErrMsgs.inputMessageTarget = 'STD';
        NBSMSGIRequest.inputErrorMessage = inputErrMsgs;

        inputCpyBook.CQN525I_ACCOUNT_NBR = oppproduct.Policy_Number__c;
        inputCpyBook.CQN525I_BRANCH_CODE = userRec[0].SiteCode__c;
        inputCpyBook.CQN525I_BRANCH_SITE_TYPE = userRec[0].SiteType__c;
        inputCpyBook.CQN525I_TELLER_CODE = userRec[0].Teller_Operator_Code__c;
        inputCpyBook.CQN525I_SITE_TYPE_AGENCY = '';
        inputCpyBook.CQN525I_SUPERVISOR_CODE = '0';
        inputCpyBook.CQN525I_AGENCY_CODE = '0';
        inputCpyBook.CQN525I_CORP_CODE = 'ABS';
        inputCpyBook.CQN525I_BLOCKED = 'N';
        inputCpyBook.CQN525I_COURT_ORDER = 'N';
        inputCpyBook.CQN525I_MANDATE_REQUIRED = 'N';
        inputCpyBook.CQN525I_DORMANT = 'N';
        inputCpyBook.CQN525I_SEMI_DORMANT = 'N';
        inputCpyBook.CQN525I_CONFISCATED = 'N';
        inputCpyBook.CQN525I_EXTERNAL_TRANSFER = 'N';
        inputCpyBook.CQN525I_STAFF = 'N';
        inputCpyBook.CQN525I_CREDIT_ACCOUNT = 'N';
        inputCpyBook.CQN525I_EXCLUDE_FROM_ESTATE = 'N';
        inputCpyBook.CQN525I_BLOCK_ADHOC_DBT = 'N';
        inputCpyBook.CQN525I_BLOCK_ADHOC_CRD = 'N';
        inputCpyBook.CQN525I_SPECIAL_RQP_REDIRECT = 'N';
        inputCpyBook.CQN525I_COMMERCIAL_PROP_FIN = 'N';
        inputCpyBook.CQN525I_MIS_HOLD = 'N';
        inputCpyBook.CQN525I_GEN_SEC_MSG = 'N';
        inputCpyBook.CQN525I_GEN_SEC_NUM = '0';
        inputCpyBook.CQN525I_WAP_WILD_ACC_PICKUP = 'N';
        inputCpyBook.CQN525I_EMPLOYEE_NUMBER = userRec[0].EmployeeNumber;
        inputCpyBook.CQN525I_MANDATE = '113';
        inputCpyBook.CQN525I_EXCL_FROM_INSOLVENT = 'N';
        inputCpyBook.CQN525I_DIGITAL_HOLD = 'N';
        inputCpyBook.CQN525I_OD_SWITCH_IND = 'N';
        inputCpyBook.CQN525I_RBA_EDD = 'N';
        inputCpyBook.CQN525I_FRAUD_IND = oppproduct.FraudIndicator__c;
        CQS525IRequest.inputCopybook = inputCpyBook;
        
        requestBean.NBSAPDPI = NBSAPDPIRequest;
        requestBean.NBSMSGI = NBSMSGIRequest;
        requestBean.CQS525I = CQS525IRequest;

        try {
            CQupdAcctHoldsV5_Resp_IB_v1 responseBean = CQupdAcctHoldsV5_IH_v1.CQupdAcctHoldsV5(requestBean);
            if (responseBean != null) {
                if (responseBean.NBSMSGO3.outputErrorMessage.NBNMSGO3_NBR_USER_ERRS == 0) {
                    return errorMessage = 'Update successful';
                } else {
                    errorMessage = responseBean.NBSMSGO3.outputErrorMessage.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT;
                    throw new AuraHandledException(errorMessage);
                }
            }
            return errorMessage = 'Error: No response from service.';
        } catch (Exception e) {
            system.debug('Error Message :' + e.getMessage() + 'Error Cause :' + e.getCause() + 'Error Where:' + e.getLineNumber());
            return errorMessage = 'Update Account Hold Error: ' + errorMessage;
        }
    }

    @AuraEnabled
    public static void setOpportunityDetails(String oppId) {
        System.debug(oppId);
        opp = new OpportunitiesSelector().selectByOpptId(oppId);
        acc = new AccountsSelector().selectByOpportunityId(oppId);
		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

        List<OpportunityLineItem> oppproducts = new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        
        //find first cheque item linked to opportunity
        for (OpportunityLineItem o : oppproducts) {
            if (o.Product_Family__c == 'Cheque') {
                oppproduct = o;
                break;
            }
        }
	}
}