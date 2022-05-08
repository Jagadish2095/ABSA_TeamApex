/*
 * Response Integration Bean for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

public class CCgetDailyLimits_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

    public CCgetDailyLimitsV2Response CCgetDailyLimitsV2Response;

    public class CCgetDailyLimitsV2Response {
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo nbsmsgo;
        public Ccp312o ccp312o;
    }

    public class Nbsapdpo {
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
    }

    public class Nbsmsgo {
        public String version;
        public String nbrUserMsgs;
        public String nbrUserErrs;
        public MsgEntry msgEntry;
    }

    public class MsgEntry {
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
    }

    public class Ccp312o {
        public String cardCshLim;
        public String cardTrfLim;
        public String cardPosLim;
        public String cardCntLim;
        public String cheqNomAcc;
        public String cheqApplNo;
        public String cheqCshLim;
        public String cheqTrfLim;
        public String cheqPosLim;
        public String savsNomAcc;
        public String savsApplNo;
        public String savsCshLim;
        public String savsTrfLim;
        public String savsPosLim;
        public String cardCshMax;
        public String cardTrfMax;
        public String cardPosMax;
        public String cardCntMax;
    }
}