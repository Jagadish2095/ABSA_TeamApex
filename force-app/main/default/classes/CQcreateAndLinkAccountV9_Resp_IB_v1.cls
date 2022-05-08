/*
 * Integration Response for CQcreateAndLinkAccountV9 Service
 * @author André Pietersen
 * @created 2020-10-30
 */

public class CQcreateAndLinkAccountV9_Resp_IB_v1 extends Base_IB {
    public String errorMessage;
    public String status;
    public Integer statusCode;
    public String message;

    public CQS411O CQS411O;
    public NBSAPDPO NBSAPDPO;
    public MSGO MSGO;

    public class CQS411O {
        public outputErrorMessage outputErrorMessage;
    }

    public class NBSAPDPO {
        public outputErrorHeaders outputErrorHeaders;
    }

    public class MSGO {
        public NBSMSGO3 NBSMSGO3;
    }

    public class outputErrorMessage {
        public String creditBackdateLimit;
        public String crditBackdateLimitA;
        public String studiesCompleted;
        public String surechequeIndA;
        public String studyCourseA;
        public String riskTypeA;
        public String shadowLimitInd;
        public String corpCode;
        public String corpSubProductA;
        public String postGradStudent;
        public Integer trustS781Acct;
        public Integer clientType;
        public String corpSubProduct;
        public String surechequeInd;
        public String mandateNbrA;
        public String trustS781AcctA;
        public String repayingInd;
        public Integer acctOpenDate;
        public String clientNameA;
        public String studyInstitution;
        public String unilateralLimitIndA;
        public String studentLoanInd;
        public String extraFinanceReqrd;
        public Integer nbrYearsRepeated;
        public String studiesCompletedA;
        public Integer businessAcct;
        public String chqBookColectSiteA;
        public Integer acctOpenReason;
        public String debitBackdateLimit;
        public String siteNameA;
        public String shadowLimitIndA;
        public String repaymentStartDateA;
        public String debitBackdateLimitA;
        public String lawSocietyRegionA;
        public String fullTimeStudent;
        public String managerNbrA;
        public String lowRiskHoldAmountA;
        public String fullTimeStudentA;
        public String clientName;
        public String accountName;
        public String siteName;
        public String repayingIndA;
        public Integer repaymentStartDate;
        public String acbUserA;
        public String studentNbrA;
        public String normalDurationA;
        public String AccountNbrOut;
        public String acbUser;
        public String riskType;
        public Integer currentAcademicYear;
        public String acctStoppedInd;
        public String unilateralLimitInd;
        public String postGradStudentA;
        public Integer relatedAcctNbr;
        public String curentAcademicYearA;
        public String trustSweepingInd;
        public String trustSweepingIndA;
        public Integer surechequeRetention;
        public String studyInstitutionA;
        public String lawSocietyRegion;
        public Integer chqBookCollectSite;
        public Integer managerNbr;
        public String extraFinanceReqrdA;
        public String acctOpenReasonA;
        public Integer mandateNbr;
        public Integer lowRiskHoldAmount;
        public String businessAcctA;
        public String nbrYearsRepeatedA;
        public Integer normalDuration;
        public String studentNbr;
        public Integer sicCode;
        public String acctStoppedIndA;
        public String accountNameA;
        public String finalYear;
        public String studyCourse;
        public String finalYearA;
        public String surechequeRetentionA;
        public String acctOpenDateA;
    }

    public class outputErrorHeaders {
        public Integer returnCode;
        public String outputServiceVersion;
        public Integer reasonCode;
    }

    public class NBSMSGO3 {
        public Integer NBNMSGO3_NBR_USER_ERRS;
        public String NBSMSGO3_VERSION;
        public String NBNMSGO3_SYS_ERR_TXT;
        public Integer NBNMSGO3_NBR_USER_MSGS;
        public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
    }

    public class NBNMSGO3_MSG_ENTRY {
        public String NBNMSGO3_MSG_ERR_IND;
        public String NBNMSGO3_MSG_TXT;
        public String NBNMSGO3_MSG_CLASS;
        public String NBNMSGO3_MSG_CODE;
    }
}