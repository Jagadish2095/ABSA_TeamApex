/*
* Request Integration Bean for CQupdAcctHoldsV5 Service
* @author Satya Boyenepalli
* @created 2020-12-08
*/

public class CQupdAcctHoldsV5_Req_IB_v1 extends Base_IB {
    
    public NBSAPDPI NBSAPDPI;
    public NBSMSGI NBSMSGI;
    public CQS525I CQS525I;
    public class NBSMSGI {
        public InputErrorMessage inputErrorMessage;
    }
    
    public class NBSAPDPI {
        public InputHeaders inputHeaders;
    }
    
    public class InputHeaders {
        public String channelName;
        public String applicationName;
        public String traceIndicator;
    }
    
    public class InputErrorMessage {
        public String inputMessageLanguage;
        public String inputMessageTarget;
    }
    
    public class CQS525I {
        public InputCopybook inputCopybook;
    }
    
    public class InputCopybook {
        public String CQN525I_ACCOUNT_NBR;
        public String CQN525I_BRANCH_CODE;
        public String CQN525I_BRANCH_SITE_TYPE;
        public String CQN525I_TELLER_CODE;
        public String CQN525I_SITE_TYPE_AGENCY;
        public String CQN525I_SUPERVISOR_CODE;
        public String CQN525I_AGENCY_CODE;
        public String CQN525I_CORP_CODE;
        public String CQN525I_BLOCKED;
        public String CQN525I_COURT_ORDER;
        public String CQN525I_MANDATE_REQUIRED;
        public String CQN525I_DORMANT;
        public String CQN525I_SEMI_DORMANT;
        public String CQN525I_CONFISCATED;
        public String CQN525I_EXTERNAL_TRANSFER;
        public String CQN525I_STAFF;
        public String CQN525I_CREDIT_ACCOUNT;
        public String CQN525I_EXCLUDE_FROM_ESTATE;
        public String CQN525I_BLOCK_ADHOC_DBT;
        public String CQN525I_BLOCK_ADHOC_CRD;
        public String CQN525I_SPECIAL_RQP_REDIRECT;
        public String CQN525I_COMMERCIAL_PROP_FIN;
        public String CQN525I_MIS_HOLD;
        public String CQN525I_GEN_SEC_MSG;
        public String CQN525I_GEN_SEC_NUM;
        public String CQN525I_WAP_WILD_ACC_PICKUP;
        public String CQN525I_EMPLOYEE_NUMBER;
        public String CQN525I_MANDATE;
        public String CQN525I_EXCL_FROM_INSOLVENT;
        public String CQN525I_DIGITAL_HOLD;
        public String CQN525I_OD_SWITCH_IND;
        public String CQN525I_RBA_EDD;
        public String CQN525I_FRAUD_IND;
    }
    public static CQupdAcctHoldsV5_Req_IB_v1 createDummy(){
        CQupdAcctHoldsV5_Req_IB_v1 requestBean = new CQupdAcctHoldsV5_Req_IB_v1();
        CQupdAcctHoldsV5_Req_IB_v1.NBSAPDPI NBSAPDPIRequest = new CQupdAcctHoldsV5_Req_IB_v1.NBSAPDPI ();
        CQupdAcctHoldsV5_Req_IB_v1.NBSMSGI NBSMSGIRequest = new CQupdAcctHoldsV5_Req_IB_v1.NBSMSGI ();
        CQupdAcctHoldsV5_Req_IB_v1.CQS525I CQS525IRequest = new CQupdAcctHoldsV5_Req_IB_v1.CQS525I ();
        CQupdAcctHoldsV5_Req_IB_v1.InputHeaders inputheaders = new   CQupdAcctHoldsV5_Req_IB_v1.InputHeaders();
        CQupdAcctHoldsV5_Req_IB_v1.inputErrorMessage inputErrMsgs = new   CQupdAcctHoldsV5_Req_IB_v1.inputErrorMessage();
        CQupdAcctHoldsV5_Req_IB_v1.InputCopybook inputCpyBook = new  CQupdAcctHoldsV5_Req_IB_v1.InputCopybook();
        inputheaders.applicationName='SF';
        inputheaders.channelName='SF';
        inputheaders.traceIndicator='N';
        inputErrMsgs.inputMessageLanguage='E';
        inputErrMsgs.inputMessageTarget='STD';
        inputCpyBook.CQN525I_ACCOUNT_NBR='4048017641';
        inputCpyBook.CQN525I_BRANCH_CODE='8474';
        inputCpyBook.CQN525I_BRANCH_SITE_TYPE='034';
        inputCpyBook.CQN525I_TELLER_CODE='1469';
        inputCpyBook.CQN525I_SITE_TYPE_AGENCY='';
        inputCpyBook.CQN525I_SUPERVISOR_CODE='0';
        inputCpyBook.CQN525I_AGENCY_CODE='0';
        inputCpyBook.CQN525I_CORP_CODE='ABS';
        inputCpyBook.CQN525I_BLOCKED='N';
        inputCpyBook.CQN525I_COURT_ORDER='Y';
        inputCpyBook.CQN525I_MANDATE_REQUIRED='N';
        inputCpyBook.CQN525I_DORMANT='N';
        inputCpyBook.CQN525I_SEMI_DORMANT='N';
        inputCpyBook.CQN525I_CONFISCATED='N';
        inputCpyBook.CQN525I_EXTERNAL_TRANSFER='Y';
        inputCpyBook.CQN525I_STAFF='N';
        inputCpyBook.CQN525I_CREDIT_ACCOUNT='N';
        inputCpyBook.CQN525I_EXCLUDE_FROM_ESTATE='N';
        inputCpyBook.CQN525I_BLOCK_ADHOC_DBT='N';
        inputCpyBook.CQN525I_BLOCK_ADHOC_CRD='N';
        inputCpyBook.CQN525I_SPECIAL_RQP_REDIRECT='N';
        inputCpyBook.CQN525I_COMMERCIAL_PROP_FIN='N';
        inputCpyBook.CQN525I_MIS_HOLD='N';
        inputCpyBook.CQN525I_GEN_SEC_MSG='N';
        inputCpyBook.CQN525I_GEN_SEC_NUM='0';
        inputCpyBook.CQN525I_WAP_WILD_ACC_PICKUP='N';
        inputCpyBook.CQN525I_EMPLOYEE_NUMBER='9117669';
        inputCpyBook.CQN525I_MANDATE='0';
        inputCpyBook.CQN525I_EXCL_FROM_INSOLVENT='N';
        inputCpyBook.CQN525I_DIGITAL_HOLD='N';
        inputCpyBook.CQN525I_OD_SWITCH_IND='N';
        inputCpyBook.CQN525I_RBA_EDD='N';
        inputCpyBook.CQN525I_FRAUD_IND='N';
        
        return requestBean;
    }
}