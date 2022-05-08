/*
 * Request Integration Bean for CCupdDailyTransactionLimits Service
 * @author Muvhuso Nekhubvi
 * @created 2019-10-09
 */
public class CCupdDailyTransactionLimitsV2_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    public CCupdDailyTransactionLimitsV2Response ccUpdDailyTransactionLimitsV2Response;
    
    public class CCupdDailyTransactionLimitsV2Response{
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo nbsmsgo;
        public Ccp321o ccp321o;
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
    
    PUBLIC CLASS MsgEntry{
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
    }
    
    public class Ccp321o{
        public string limRec;
    }
}