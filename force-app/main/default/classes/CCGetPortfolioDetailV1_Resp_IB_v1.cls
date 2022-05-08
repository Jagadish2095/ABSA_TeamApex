/*
 * Response Integration Bean for CCGetPortfolioDetailV1 Service
 * @author Prashant Jain
 * @created 2020-03-16
 */

public class CCGetPortfolioDetailV1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public class CCgetPortfolioDetailV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo nbsmsgo;
		public Ccp301o ccp301o;
	}

	public CCgetPortfolioDetailV1Response CCgetPortfolioDetailV1Response;

	public class Nbsmsgo {
		public String version;
		//public Object sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
		public MsgEntry msgEntry;
	}

	public class Ccp301o {
		public String combiRetrvdInd;
		public String prevNbr;
		public String nextNbr;
		public String prtPassNbr;
		public String clientCode;
		public String clientName;
		public String idPspNbr;
		public String persName;
		public String langCode;
		public String ncssRefno;
		//public Object ncssStat;
		public String brandNbr;
		public String prodCode;
		public String segmCode;
		public String sbuSiteCode;
		public String issueBranch;
		public String createDate;
		public String activateDate;
		public String holdDate;
		public String closeDate;
		public String inactDate;
		public String ncssDate;
		public String transferDate;
		public String mthLastUse;
		public String exprDate;
		public String nbrHolds;
		public List<Holds> holds;
		//public Object reasCode;
		//public Object sreasCode;
		public String retnDate;
		public String retnBrch;
		public String cardReqd;
		public String autoLink;
		public String bankInter;
		public String bankLink;
		public String bankTel;
		public String pinReqd;
		//public Object blindInd;
		public String scrdInd;
		public String cpresInd;
		public String inactInd;
		//public Object thrdParty;
		public String cardRepl;
		public String cardFeeInd;
		public String cardFeeDate;
		public String lostFeeInd;
		public String lostFeeDate;
		public String mthFeeInd;
		public String nomCheq;
		public String nomSavs;
		public String nomCred;
		public String lvpAppl;
		public String frdAccNbr;
		public String cardCshLim;
		public String cardPosLim;
		public String cardTrfLim;
		public String cardCntLim;
		public String cardCntAvl;
		public String cntLimDate;
		public String cardLimit;
		public String totalLimit;
		public String nbrChipAppl;
		//public Object reisCntrCde;
		//public Object nonReisRsn;
		public String lstReisDate;
		public String brandCode;
		public String dstBrchCode;
		//public Object dstCode;
		public String reisTrgDate;
	}

	public class MsgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Holds {
		public String holdCode;
	}
}