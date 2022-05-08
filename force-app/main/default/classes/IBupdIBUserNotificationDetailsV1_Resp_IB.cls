/*
 * Response Integration Bean for IBupdIBUserNotificationDetailsV1 Service
 * @author Angelina Myshkovets
 * @description IBupdIBUserNotificationDetailsV1_Resp_IB
 * @created 2021-08-26
 */
/**
 * @description IBupdIBUserNotificationDetailsV1_Resp_IB
 */
public with sharing class IBupdIBUserNotificationDetailsV1_Resp_IB Extends Base_IB {
/**
 * @description Nbsmsgo
 */
    
    public class Nbsapdpo {
        public Object version;
        public String returnCode;
        public String reasonCode;
        public String serviceVersion;
        public Object echoKey;
    }
/**
 * @description Nbsmsgo
 */
    
    public class Nbsmsgo {
        public String version;
        public String sysErrTxt;
        public String nbrUserMsgs;
        public String nbrUserErrs;
        public List<MsgEntry> msgEntry;
    }
/**
 * @description IBupdIBUserNotificationDetailsV1Response
 */
    public class IBupdIBUserNotificationDetailsV1Response {
        public Nbsapdpo nbsapdpo;
        public Nbsmsgo nbsmsgo;
    }

    public IBupdIBUserNotificationDetailsV1Response IBupdIBUserNotificationDetailsV1Response;
/**
 * @description 
 */
    public class MsgEntry {
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
    }
}