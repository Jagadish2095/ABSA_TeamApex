/**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-10-19
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   Englarmerdge Mongwe   Initial Version
 **/

public class ChequeServicesOrchestration_Resp_IB_v1 extends Base_IB {
	public List<CQgetBasicAcctDetailsV7Responses> CQgetBasicAcctDetailsV7Responses;
	public List<ABFgetBasicDetailsV1Responses> ABFgetBasicDetailsV1Responses;
	public List<ABFvalAutosettlementAccountV1Responses> ABFvalAutosettlementAccountV1Responses;
	public List<ABFgetGeneralDetailsV2Responses> ABFgetGeneralDetailsV2Responses;
	public List<CAgetCassACSBEnqV1Responses> CAgetCassACSBEnqV1Responses;
    public List<LDPgetAccountInfoV2Responses> LDPgetAccountInfoV2Responses;
	/**
	 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
	 * @author            : Englarmerdge Mongwe
	 *
	 **/
	public class CAgetCassACSBEnqV1Responses {
		public CAgetCassACSBEnqV1Response CAgetCassACSBEnqV1Response;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Cap918o {
		public String accType;
		public String accountBalance;
		public String acctStatCd;
		public String allocatedLimit;
		public String amtBhvrScore;
		public String budgetInst;
		public String budgetLimit;
		public String cifKey;
		public String creditLimit;
		public String debtIntRate;
		public String expiryDate;
		public String garageInd;
		public String iniFixFee;
		public String iniMaxFee;
		public String iniPctFee;
		public String iniThresholdAmt;
		public String initFeePrev;
		public String instalment;
		public String intRate;
		public String intRateType;
		public String kbAcctNbr;
		public String paymentOption;
		public String raAcctNbr;
		public String returnCd;
		public String returnMsg;
		public String serviceFee;
		public String settlementAmt;
		public String statCdDescr;
		public String subProd;
		public String uniLimitIncr;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class CQgetBasicAcctDetailsV7Responses {
		public CQgetBasicAcctDetailsV7Response CQgetBasicAcctDetailsV7Response;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class CQgetBasicAcctDetailsV7Response {
		public Cqh455o cqh455o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Cqh455o {
		public String accntCloseDate;
		public String accountBalance;
		public String accountDomicleBrch;
		public String accountDomicleDiv;
		public List<AccountHolds> accountHolds;
		public String accountInactiveInd;
		public String accountNo;
		public String accountStatus;
		public String accountType;
		public String authHoldAmt;
		public String availBal;
		public String bomSponsoredAmt;
		public String branchCode;
		public String businessUnit;
		public String chargesDue;
		public String clearingCode;
		public String clientFullName;
		public String closeReason;
		public String commitmentInterest;
		public String creditInterestDue;
		public String dateOvrdrftArrngd;
		public String daylightExpryDate;
		public String daylightLimit;
		public String debitInterestDue;
		public String digitalChannel;
		public String division;
		public String empowermentFund;
		public String fullCrTrckngInd;
		public String guarnteeAmtReserved;
		public String markedCheqsAmt;
		public String ncaAgreemntInd;
		public String negotiatedCheqAmt;
		public String newNxtStmntDate;
		public String newStmtFreq;
		public String nxtStmntDate;
		public String offlnAuthAmt;
		public String onedaypaafInd;
		public String onedaypaafTot;
		public String openDate;
		public String openReason;
		public String overdraftExists;
		public String overdraftLimit;
		public String overdraftType;
		public String ovrdrftExpryDate;
		public String penaltyInt;
		public String postDatedTran;
		public String prefStmntInd;
		public String rconNxtStmntDate;
		public String rconStmntFreq;
		public String returnedCheques;
		public String specialName;
		public String statementImageInd;
		public String stmntFreq;
		public String stmntReleaseInd;
		public String stmntReqdInd;
		public String unclearedCheqs;
		public String unilatrlLimitIncrease;
		public String wapHold;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFgetBasicDetailsV1Responses {
		public ABFgetBasicDetailsV1Response ABFgetBasicDetailsV1Response;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFgetBasicDetailsV1Response {
		public Plpa21o plpa21o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Plpa21o {
		public String account;
		public String dteSettleNotice;
		public String financeType;
		public String mastAgreeNo;
		public String division;
		public String clientCode;
		public String clientFormatName;
		public String clientName1;
		public String clientName2;
		public String domicileBranch;
		public String accountStatus;
		public String siteCode;
		public String statusDate;
		public String paymMethod;
		public String stmtDueDate;
		public String dteMicrofiched;
		public String schemeType;
		public String schemeCode;
		public String crlifeClaimType;
		public String creditLife;
		public String accountName;
		public String addressLine1;
		public String addressLine2;
		public String addressLine3;
		public String addressLine4;
		public String addressLine5;
		public String telephoneNumber;
		public String rate;
		public String linkedFixed;
		public String tableRate;
		public String rateAdjustment;
		public String interestRate;
		public String advance;
		public String arrears;
		public String employeeNbr;
		public String effectiveDate;
		public String totalDrCr;
		public String originalTerm;
		public String balOutstanding;
		public String firstInstDate;
		public String nextInstAmt;
		public String nextDueDay;
		public String arrAdvAmt;
		public String diCode;
		public String accumAdvInt;
		public String remainingInst;
		public String totalAmtDue;
		public String instFrequency;
		public String regularInstAmt;
		public String finalInstDate;
		public String finalInstAmt;
		public String ocsRiskType;
		public String ocsCollCode;
		public String employerName;
		public String occupation;
		public String gender;
		public String birthDate;
		public String maritalStatus;
		public String dependants;
		public String maritalContract;
		public String dialCode;
		public String hold11;
		public String hold12;
		public String hold13;
		public String hold14;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFvalAutosettlementAccountV1Responses {
		public ABFvalAutosettlementAccountV1Response ABFvalAutosettlementAccountV1Response;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFvalAutosettlementAccountV1Response {
		public Plpa74o plpa74o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Plpa74o {
		public List<AccountDetails> accountDetails;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class AccountDetails {
		public String accErrorFlagpic;
		public String account;
		public String initFeeInd;
		public String settlAmount;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFgetGeneralDetailsV2Responses {
		public ABFgetGeneralDetailsV2Response ABFgetGeneralDetailsV2Response;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class ABFgetGeneralDetailsV2Response {
		public Plpa20o plpa20o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Plpa20o {
		public String initCapital;
		public String initInterest;
		public String outCapital;
		public String outInterest;
		public String suppCapital;
		public String suppInterest;
		public String addCapital;
		public String addInterest;
		public String chrgCapital;
		public String chrgInterest;
		public String dteHistArchived;
		public String dteConverted;
		public String portfCover;
		public String stampDuty;
		public String addRepayInd;
		public String docfeeVat;
		public String securities;
		public String commOutstanding;
		public String insurance;
		public String insurancePrem;
		public String assurance;
		public String creditLife;
		public String refundFinst;
		public String advIntPaid;
		public String dateWo;
		public String badDebtAmt;
		public String ncaIndicator;
		public String unclearedChq;
		public String permitWithdrawal;
		public String amountAvailable;
		public String lastAdvDate;
		public String amountAdvanced;
		public String cashbackAmount;
		public String cashbackDate;
		public String empFundCode;
		public String termLoanType;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Nbsapdpo {
		public String echoKey;
		public String reasonCode;
		public String returnCode;
		public String serviceVersion;
		public String version;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class AccountHolds {
		public String accountHold;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class Nbsmsgo3 {
		//public List<MsgEntry> msgEntry;
		public String nbrUserErrs;
		public String nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class CAgetCassACSBEnqV1Response {
		public Cap918o cap918o;
		public Nbsapdpo nbsapdpo;
	}
 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 *
 **/
	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}
    // Added By Himani Joshi
    // Added For LDP
	/**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Himani Joshi
 *
 **/
     public class LDPgetAccountInfoV2Responses {
		public LDPgetAccountInfoV2Response LDPgetAccountInfoV2Response;
        //public LDPgetAccountInfoV2Response_Z LDPgetAccountInfoV2Response1;
     
	}
    
    /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Himani Joshi
 *
 **/
	public class LDPgetAccountInfoV2Response {
		public Ld300a3o ld300a3o;
		public Nbsapdpo nbsapdpo;
	}
    /*
    public class LDPgetAccountInfoV2Response_Z {
		public Ld300a3o_Z ld300a3o;
		public Nbsapdpo nbsapdpo;
	}
*/
   /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Himani Joshi
 *
 **/
    public class Ld300a3o {
        public String accountNumber;
		public String accountTotBalance;
		public String accountTotExpiryDate;
		public String accountTotLimit;
		public Date accountTotReviewDate;
		public String clientCode;
		//public ContractData contractData;
		public List<ContractData>contractData;
		public String errorLine1;
		public String errorLine2;
		public String errorLine3;
		public String errorNumber;
        public String numberOfContracts;
		public String recordId;
		public String recordIde;
		public String recordNumber1;
	}

	 /**
 * @description       : Response Integration Bean for ChequeServicesOrchestration Service
 * @author            : Himani Joshi
 *
 **/
     public class ContractData {
		public Decimal contractAmount;
		public String contractBalance;
		public String contractExpiryDate;
        public String contractNumber;
		public String contractProdCode;
		public String contractProdType;
		public String contractSubProduct;
	}
    /*
    public class Ld300a3o_Z {
		public String accountNumber;
		public String accountTotBalance;
		public String accountTotExpiryDate;
		public String accountTotLimit;
		public Date accountTotReviewDate;
		public String clientCode;
		public List<ContractData> contractData;
		public String errorLine1;
		public String errorLine2;
		public String errorLine3;
		public String errorNumber;
		public String numberOfContracts;
		public String recordId;
		public String recordIde;
		public String recordNumber1;
	}
    */
}