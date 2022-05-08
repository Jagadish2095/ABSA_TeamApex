/**
 * Response Integration Bean for CQgetOverdraftDetailsV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-07-28
 */

public class CQgetOverdraftDetailsV4_Resp_IB_v1 extends Base_IB {
    public CQgetOverdraftDetailsV4Response CQgetOverdraftDetailsV4Response;

	public class CQgetOverdraftDetailsV4Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cqh478o cqh478o;
    }

    public class Nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}

	public class Nbsmsgo3 {
		public String version;
		public String sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
    }

	public class Cqh478o {
		public String accountNbrOut;
		public String accountType;
		public String clientName;
		public String accountName;
		public String bankCode;
		public String branchCode;
		public String accountStatus;
		public String overdraftType;
		public String effectiveDate;
		public String reviewDate;
		public String expiryDate;
		public String expiryDateA;
		public String currentOverdraftLimit;
		public String daylightLimit;
		public String daylightLimitA;
		public String daylightExpiryDate;
		public String daylightExpiryDateA;
		public String tellerNumber;
		public String originalOdAmount;
		public String originalOdAmountA;
		public String currentLimitExpDate;
		public String currentLimitExpDteA;
		public String reductionAttribute;
		public String reductionAmount;
		public String reductionAmountFreq;
		public String reductionStartDate;
		public String reduction1timeAmount;
		public String reduction1timeEffDte;
		public String enforcedReducingLimit;
		public String revLoanAttribute;
		public String revLoanPayStruct;
		public String revLoanAmount;
		public String revLoanPayFrequency;
		public String revLoanPaymentMethod;
		public String revLoanPayDay;
		public String revLoanPayDueDate;
		public String revLoanNumExtensions;
		public String revLoanExtEffDte;
		public String revLoanNrTimeInArr;
		public String revLoanArrearsAmount;
		public String defaultedOd;
		public String variableAttribute;
		public String variableTableCounter;
    }
}