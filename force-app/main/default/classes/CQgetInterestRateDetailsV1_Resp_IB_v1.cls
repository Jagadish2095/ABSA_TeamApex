/**
 * @description       :Integration Response Bean for CQgetInterestRateDetailsV1 Service
 * @author Jason Q
 * @last modified on  : 2021-06-14
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-12   almas.aleem@absa.africa   Initial Version
**/
public class CQgetInterestRateDetailsV1_Resp_IB_v1 extends Base_IB{

	public CQgetInterestRateDetailsV1Response CQgetInterestRateDetailsV1Response;

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class CQgetInterestRateDetailsV1Response {
        public Cqh451o cqh451o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
    }

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Cqh451o {
		public String accountName;
		public String accountNbrOut;
		public String accountType;
		public String capDay;
		public String clientName;
		public String comitIntRate;
		public String comitIntType;
		public String crLinkedRate;
		public String crLinkedRateDescr;
		public String creditBalMethod;
		public CreditIntTiers creditIntTiers;
		public String creditIntType;
		public String creditRateStructure;
		public String debitBalMethod;
		public DebitIntTiers debitIntTiers;
		public String debitIntType;
		public String debitPrimeRate;
		public String debitRateStructure;
		public String enquiryDate;
		public String enquiryTime;
		public String infoMessage;
		public String interestStmnt;
		public String maxRateType;
		public String ncaMsgInd;
		public String nextCapDate;
		public String penaltyIntRate;
		public String penaltyIntType;
	}

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Nbsapdpo {
		public String echoKey;
		public String reasonCode;
		public String returnCode;
		public String serviceVersion;
		public String version;
	}

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class Nbsmsgo {
		public String nbrUserErrs;
		public String nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class CreditIntTiers {
		public Decimal creditBalance ;
        public Decimal creditEffRate;
        public Decimal creditOffset;
	}

	/**
 * @description       : Integration Request Bean for CQgetInterestRateDetailsV1 Service
 */public class DebitIntTiers {
		public Decimal debitBalance ;
        public Decimal debitEffRate;
		public Decimal debitOffset;
	}

}