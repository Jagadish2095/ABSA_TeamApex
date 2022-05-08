/**
* Integration Request for MBinitiatePaymentV12 Service
* @author Almas Aleem
* @created 2020-12-15
*/
public class MBinitiatePaymentV12_Req_IB_v1 extends Base_IB {
    public Nbsapdpi nbsapdpi;
    public Nbsmsgi nbsmsgi;
    public Mbp301i mbp301i;
    
    public class FinalMsgId {
        public String finalMsgClass;
        public String finalMsgCode;
    }
    
    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }
    
    public class Mbp301i {
        public String channelI;
        public String paymTime;
        public String processInd;
        public String paymDest;
        public String overrideCompl;
        public String futureInd;
        public String maxRetrieve;
        public String accessAcc;
        public String cifKey;
        public String tieb;
        public String multiNo;
        public String instrType;
        public String instrRefName;
        public String actDate;
        public String amount;
        public String instrNo;
        public String srcAcc;
        public String srcAccType;
        public String srcClrCode;
        public String srcStmtRef;
        public String trgAcc;
        public String trgClrCode;
        public String trgAccType;
        public String trgStmtRef;
        public String trgBusinessCode;
        public String retryDate;
        public String creditTrack;
        public String retryAmount;
        public String notifInd;
        public String cardAuth;
        public String acbUserCode;
        public String acbUcIndex;
        public String changeBranch;
        public String changeTeller;
        public String changeOverride;
        public String changeOverride2;
        public String uniqueEft;
        public String paymNo;
        public String paymIipInd;
        public String paymConsolTxInd;
        public String paymNotifStat;
        public String paymNotes;
        public String siteType;
        public String siteCorp;
        public String lang;
        public String tranCodeDr;
        public String sfncCodeDr;
        public String sourceIndDr;
        public String tranCodeCr;
        public String sfncCodeCr;
        public String sourceIndCr;
        public String tellerAmtAuth;
        public String productsSpa;
        public String agcy;
        public String subSiteType;
        public String location;
        public String feSwitchFee;
        public String deviceNo;
        public String feRetrRefNo;
        public String tsForceInd;
        public String feRepeatTran;
        public String feStan;
        public String feReversalInd;
        public String exdt;
        public String trackIi;
        public String tranInd;
        public String serverId;
        public String sessionKeyId;
        public String pinBlock;
        public String pinBlockFormat;
        public String budgetInd;
        public String budgetNo;
        public String consolAmnt;
        public String batClr;
        public String initpaymOverride;
        public String wsdlVersion;
        public String tranOpenMedia;
        public String emvrqCryptoInfoData;
        public String emvrqTvr;
        public String emvrqArqc;
        public String emvrqAmtAuth;
        public String emvrqAmtOther;
        public String emvrqAip;
        public String emvrqAtc;
        public String emvrqTermCntryCde;
        public String emvrqTranCrncyCde;
        public String emvrqTranDat;
        public String emvrqTranType;
        public String emvrqUnpredictNum;
        public String emvrqDerivKeyIndex;
        public String emvrqCryptoVerNum;
        public String emvrqCrdVrfyRslts;
        public String emvrqInfo;
        public String emvrqDac;
        public String emvddTermSerlNum;
        public String emvddEmvTermCap;
        public String emvddEmvTermType;
        public String emvddApplVerNum;
        public String emvddCvmRslts;
        public String emvddDfNameLgth;
        public String emvRid;
        public String emvPixExt;
        public String emvstPtSrvEntryMde;
        public String emvstTermEntryCap;
        public String emvstLastEmvStat;
        public String emvstDataSuspect;
        public String emvstApplPanSeqNum;
        public String emvstRsnOnlCde;
        public String emvstArqcVrfy;
        public String emvrpAuthDataLgth;
        public String emvrpArpc;
        public String emvrpIssRespCde;
        public String emvrpInfo;
        public String emvrpSendCrdBlk;
        public String emvrpSendPutData;
        public String echoData;
        public String merchantNumber;
        public String paymMode;
        public String caseId;
        public String mtcNumber;
        public String swiftTranNum;
        public String origCountry;
        public String senderName;
        public String senderSurname;
        public String currency_Z;
        public String foreignAmnt;
        public String endorsedInd;
        public String ibanNo;
        public String benGender;
        public String benNonResStat;
        public String exref;
        public String originChannel;
    }
    
    public class Nbsmsgi {
        public String msgLanguage;
        public String msgTarget;
        public FinalMsgId finalMsgId;
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"currency":', '"currency_Z":');
        
    }
    
    public static MBinitiatePaymentV12_Req_IB_v1 createDummyRequest() {
        MBinitiatePaymentV12_Req_IB_v1 requestBean = new MBinitiatePaymentV12_Req_IB_v1 ();
        String jsonString = '{     "nbsapdpi": {         "channel": "BISON",         "application": "EPS",         "trace": "T"     },     "nbsmsgi": {         "msgLanguage": "E",         "msgTarget": "STD",         "finalMsgId": {             "finalMsgClass": "",             "finalMsgCode": ""         }     },     "mbp301i": {         "channelI": "BDP",         "paymTime": "114878",         "processInd": "",         "paymDest": "",         "overrideCompl": "",         "futureInd": "N",         "maxRetrieve": "1",         "accessAcc": "",         "cifKey": "",         "tieb": "0",         "multiNo": "0",         "instrType": "OOP",         "instrRefName": "",         "actDate": "20201204",         "amount": "100",         "instrNo": "0",         "srcAcc": "4047942396",         "srcAccType": "",         "srcClrCode": "632005",         "srcStmtRef": "TEST XXX",         "trgAcc": "4047373006",         "trgClrCode": "632005",         "trgAccType": "02",         "trgStmtRef": "TEST XXX",         "trgBusinessCode": "",         "retryDate": "0",         "creditTrack": "",         "retryAmount": "0",         "notifInd": "N",         "cardAuth": "0",         "acbUserCode": "0",         "acbUcIndex": "0",         "changeBranch": "8089",         "changeTeller": "00011012",         "changeOverride": "",         "changeOverride2": "",         "uniqueEft": "",         "paymNo": "1",         "paymIipInd": "N",         "paymConsolTxInd": "0",         "paymNotifStat": "0",         "paymNotes": "DE",         "siteType": "",         "siteCorp": "BNK",         "lang": "?",         "tranCodeDr": "0",         "sfncCodeDr": "0",         "sourceIndDr": "0",         "tranCodeCr": "0",         "sfncCodeCr": "0",         "sourceIndCr": "0",         "tellerAmtAuth": "0",         "productsSpa": "0",         "agcy": "0",         "subSiteType": "0",         "location": "0",         "feSwitchFee": "0",         "deviceNo": "",         "feRetrRefNo": "0",         "tsForceInd": "0",         "feRepeatTran": "",         "feStan": "0",         "feReversalInd": "",         "exdt": "0",         "trackIi": "",         "tranInd": "0",         "serverId": "",         "sessionKeyId": "",         "pinBlock": "",         "pinBlockFormat": "",         "budgetInd": "",         "budgetNo": "0",         "consolAmnt": "0",         "batClr": "",         "initpaymOverride": "",         "wsdlVersion": "12",         "tranOpenMedia": "",         "emvrqCryptoInfoData": "",         "emvrqTvr": "",         "emvrqArqc": "",         "emvrqAmtAuth": "0",         "emvrqAmtOther": "0",         "emvrqAip": "",         "emvrqAtc": "",         "emvrqTermCntryCde": "0",         "emvrqTranCrncyCde": "0",         "emvrqTranDat": "0",         "emvrqTranType": "",         "emvrqUnpredictNum": "",         "emvrqDerivKeyIndex": "",         "emvrqCryptoVerNum": "",         "emvrqCrdVrfyRslts": "",         "emvrqInfo": "",         "emvrqDac": "",         "emvddTermSerlNum": "",         "emvddEmvTermCap": "",         "emvddEmvTermType": "",         "emvddApplVerNum": "",         "emvddCvmRslts": "",         "emvddDfNameLgth": "0",         "emvRid": "",         "emvPixExt": "",         "emvstPtSrvEntryMde": "",         "emvstTermEntryCap": "",         "emvstLastEmvStat": "",         "emvstDataSuspect": "",         "emvstApplPanSeqNum": "",         "emvstRsnOnlCde": "",         "emvstArqcVrfy": "",         "emvrpAuthDataLgth": "0",         "emvrpArpc": "",         "emvrpIssRespCde": "",         "emvrpInfo": "",         "emvrpSendCrdBlk": "",         "emvrpSendPutData": "",         "echoData": "",         "merchantNumber": "0",         "paymMode": "",         "caseId": "",         "mtcNumber": "",         "swiftTranNum": "",         "origCountry": "",         "senderName": "",         "senderSurname": "",         "currency": "",         "foreignAmnt": "0",         "endorsedInd": "",         "ibanNo": "",         "benGender": "",         "benNonResStat": "n",         "exref": "",         "originChannel": ""     } }';
        requestBean = (MBinitiatePaymentV12_Req_IB_v1)JSON.deserialize(jsonString, MBinitiatePaymentV12_Req_IB_v1.class);
        
        return requestBean;
    }
    
}