/**
 * Response Integration Bean for CQgetClientConductV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020-08-06
 */

public class CQgetClientConductV3_Resp_IB_v1 extends Base_IB {

    public CQgetClientConductV3Response CQgetClientConductV3Response;

	public class CQgetClientConductV3Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Cqh482o cqh482o;
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

    public class Cqh482o {
		public String accountNbrOut;
		public String clientName;
		public String divisionCode;
		public String branch;
		public String accountType;
		public String accountName;
		public String dateOpened;
		public String clientType;
		public String clientOccupation;
		public String segcode;
		public String accountStatusCode;
		public String currentBalance;
		public String availableBalance;
		public String unclearedEffects;
		public String excessAmount;
		public String markedCheque;
		public String authHolds;
		public String authOffline;
		public String negCheqs;
		public String pdatedAmount;
		public String returnedCheque;
		public String guaranteedReserve;
		public String odDeclined;
		public String maxlimit;
		public String overdraftType;
		public String overdraftLimit;
		public String overdraftExpiryDate;
		public String reducibleAmt;
		public String fct;
		public String paymentDate;
		public List<Hldd> hldd;
		public String nca;
		public String unilatIncr;
		public String rdCurrent;
		public String rdPrev;
		public String rdDaysCurrent;
		public String rdDays12;
		public String unauthOd12;
		public String dateLastRd;
		public String lastCreditAmnt;
		public String lastCreditDate;
		public String lastDebitAmnt;
		public String lastDebitDate;
		public String toYrBeforeLast;
		public String lastWithinLmtDate;
		public String toCurrentYr;
		public String toPreviousYr;
		public String highBalCurr;
		public String highBalPrevious;
		public String lowBalCurr;
		public String lowBalPrevious;
		public String debitIntCurr;
		public String debitIntPrevious;
		public String creditIntCurr;
		public String creditIntPrevious;
		public String chargesCurr;
		public String chargesPrev;
		public String incomingUnpdsCurr;
		public String incomingUnpdsVcurr;
		public List<RocqDetail> rocqDetail;
		public String nbrRdCurr;
		public List<RdcqDetail> rdcqDetail;
		public String onedaypaafTot;
		public String defaultedOd;
		public String bomSponsoredAmt;
    }

	public class Hldd {
		public String hlddOut;
	}

	public class RocqDetail {
		public String nbrUnpds;
		public String valueUnpds;
	}

	public class RdcqDetail {
		public String nbrRd;
	}
}