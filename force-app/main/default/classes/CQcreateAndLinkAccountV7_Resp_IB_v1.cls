/*
 * Response Integration Bean for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

public class CQcreateAndLinkAccountV7_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class Cqh411o {
		public String accountNbrOut;
		public String sicCode;
		public String clientType;
		public String relatedAcctNbr;
		public String corpCode;
		public String siteName;
		public String siteNameA;
		public String clientName;
		public String clientNameA;
		public String accountNameA;
		public String acctOpenDate;
		public String acctOpenDateA;
		public String acctOpenReason;
		public String acctOpenReasonA;
		public String managerNbr;
		public String managerNbrA;
		public String riskType;
		public String riskTypeA;
		public String lowRiskHoldAmount;
		public String lowRiskHoldAmountA;
		public String acctStoppedInd;
		public String acctStoppedIndA;
		public String unilateralLimitInd;
		public String unilateralLimitIndA;
		public String acbUser;
		public String acbUserA;
		public String debitBackdateLimit;
		public String debitBackdateLimitA;
		public String creditBackdateLimit;
		public String crditBackdateLimitA;
		public String corpSubProduct;
		public String corpSubProductA;
		public String surechequeInd;
		public String surechequeIndA;
		public String surechequeRetention;
		public String surechequeRetentionA;
		public String businessAcct;
		public String businessAcctA;
		public String trustS781Acct;
		public String trustS781AcctA;
		public String lawSocietyRegionA;
		public String chqBookCollectSite;
		public String chqBookColectSiteA;
		public String studentNbrA;
		public String fullTimeStudentA;
		public String postGradStudentA;
		public String studyCourseA;
		public String normalDuration;
		public String normalDurationA;
		public String currentAcademicYear;
		public String curentAcademicYearA;
		public String finalYearA;
		public String studyInstitution;
		public String studyInstitutionA;
		public String nbrYearsRepeated;
		public String nbrYearsRepeatedA;
		public String extraFinanceReqrdA;
		public String studiesCompletedA;
		public String repayingIndA;
		public String repaymentStartDate;
		public String repaymentStartDateA;
		public String mandateNbr;
		public String mandateNbrA;
		public String studentLoanInd;
		public String trustSweepingInd;
		public String trustSweepingIndA;
		public String shadowLimitInd;
		public String shadowLimitIndA;
	}

	public CQcreateAndLinkAccountV7Response CQcreateAndLinkAccountV7Response;

	public class CQcreateAndLinkAccountV7Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cqh411o cqh411o;
	}

	public class Nbsmsgo3 {
		public String version;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
     public static CQcreateAndLinkAccountV7_Resp_IB_v1 dummyResponse(){
        CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean = new CQcreateAndLinkAccountV7_Resp_IB_v1();
         CQcreateAndLinkAccountV7_Resp_IB_v1.CQcreateAndLinkAccountV7Response cqresponse =new CQcreateAndLinkAccountV7_Resp_IB_v1.CQcreateAndLinkAccountV7Response();
         responseBean.status='Ok';
        responseBean.statusCode=12;
        responseBean.message='Test Message';
        
            return responseBean;
    }
}