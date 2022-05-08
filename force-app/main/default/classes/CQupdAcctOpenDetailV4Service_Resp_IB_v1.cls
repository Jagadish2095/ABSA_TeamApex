/*
 * Request Integration Bean for CQupdAcctOpenDetailV4Service Service
 * @author Willy Zuvana
 * @created 2021-04-06
 */
 
public class CQupdAcctOpenDetailV4Service_Resp_IB_v1 Extends Base_IB{
	
	public NBSAPDPO NBSAPDPO;
	public NBSMSGO3_Z NBSMSGO3;
	public CQT413O CQT413O;

	public class NBSMSGO3_Z {
		public NBSMSGO3 NBSMSGO3;
	}

	public class OutputArea {
		public String oSiteName;
		public String oTypeStudyCourseDesc;
		public String oTransactionTime;
		public String oShadowLimitIndDesc;
		public String oStudiesCompletedDesc;
		public String oFinalYearDesc;
		public String oRiskTypeAmount;
		public String oNormalDurationDesc;
		public String oAcctStoppedDesc;
		public String oACBUserDesc;
		public String oDepositIDTelephone;
		public String oAcctOpenReasonDesc;
		public String oFullTimeStudentDesc;
		public String oAccountTypeDesc;
		public String oCurrentAcadYearDesc;
		public String oNewAccountDesc;
		public String oRepayingIndDesc;
		public String oTrustSweepingIndDesc;
		public String oDepositIDName;
		public String oNextStatementDate;
		public String oSpecialInstructions;
		public String oDuplicateStatement;
		public String oDbtBackdateLimitDesc;
		public String oExtraFinanceReqDesc;
		public String oTransactionDate;
		public String oCrdBackdateLimitDesc;
		public String oStatementFrequency;
		public String oDepositIDMessage;
		public String oNbrYearsFailed;
		public String oSiteDivision;
		public String oCorpSubProductDesc;
		public String oUniltrlLimitIndDesc;
		public String oStudyCourseDesc2;
		public String oPostGradStudentDesc;
		public String oMandateHolderName;
		public String oStudyCourseDesc1;
	}

	public class NBSAPLO {
		public String returnCode;
		public String outputServiceVersion;
		public String reasonCode;
	}

	public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
	}

	public class NBSMSGO3 {
		public String NBNMSGO3_NBR_USER_ERRS;
		public String NBSMSGO3_VERSION;
		public String NBNMSGO3_SYS_ERR_TXT;
		public String NBNMSGO3_NBR_USER_MSGS;
		public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}

	public class CQT413O {
		public OutputArea outputArea;
	}

	public class NBNMSGO3_MSG_ENTRY {
		public String NBNMSGO3_MSG_ERR_IND;
		public String NBNMSGO3_MSG_TXT;
		public String NBNMSGO3_MSG_CLASS;
		public String NBNMSGO3_MSG_CODE;
	}

}