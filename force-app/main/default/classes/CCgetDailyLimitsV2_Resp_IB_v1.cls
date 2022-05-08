/*
* Response Integration Bean for CCgetDailyLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-10-15
*/
public class CCgetDailyLimitsV2_Resp_IB_v1 Extends Base_IB {
	public CCgetDailyLimitsV2Response CCgetDailyLimitsV2Response;

	public class CCgetDailyLimitsV2Response {
		public Ccp312o ccp312o;
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
	}

	public class Nbsapdpo {
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
	}

	public class Nbsmsgo {
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public String version;
		public msgEntry msgEntry;
	}

	public class msgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Ccp312o {
		public String cardCntLim;
		public String cardCntMax;
		public String cardCshLim;
		public String cardCshMax;
		public String cardPosLim;
		public String cardPosMax;
		public String cardTrfLim;
		public String cardTrfMax;
		public String cheqApplNo;
		public String cheqCshLim;
		public String cheqNomAcc;
		public String cheqPosLim;
		public String cheqTrfLim;
		public String limInd;
		public String savsApplNo;
		public String savsCshLim;
		public String savsNomAcc;
		public String savsPosLim;
		public String savsTrfLim;
	}
    
}