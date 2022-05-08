/*
 * Response Integration Bean for MBlistInstructionsPerSourceAccV1 Service
 * @author Mashudu Raidmi
 * @created 2020-08-11
 */
public class MBlistInstructionsPerSrcAccV1_Resp_IB_v1 extends Base_IB{

    @AuraEnabled public MBlistInstructionsPerSourceAccV1Response MBlistInstructionsPerSourceAccV1Response;

    public class nbsmsgo3{
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String sysErrTxt;
        @AuraEnabled public String nbrUserErrs;
        @AuraEnabled public String version;
        @AuraEnabled public List<MsgEntry> msgEntry;
    }

    public class MsgEntry{
        @AuraEnabled public String msgClass;
        @AuraEnabled public String msgCode;
        @AuraEnabled public String msgErrInd;
        @AuraEnabled public String msgTxt;
    }

    public class nbsapdpo{
        @AuraEnabled public String echoKey;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String returnCode;
        @AuraEnabled public String serviceVersion;
        @AuraEnabled public String version;
    }

    public class mbs326o{
        @AuraEnabled public String origStatus;
        @AuraEnabled public String recsReturn;
        @AuraEnabled public String respOther;
        @AuraEnabled public String respDesc;
        @AuraEnabled public String respCode;
        @AuraEnabled public String altTieb;
        @AuraEnabled public String timeNow;
        @AuraEnabled public String fwWarnInd;
        @AuraEnabled public String todaysDate;
        @AuraEnabled public String accessAcc;
        @AuraEnabled public String origType;
        @AuraEnabled public list<instruction> instruction;
        @AuraEnabled public String maxRetrieve;
        @AuraEnabled public String tacAccCount;
        @AuraEnabled public String channel;
    }

    public class MBlistInstructionsPerSourceAccV1Response{
        @AuraEnabled public mbs326o mbs326o;
        @AuraEnabled public nbsmsgo3 nbsmsgo3;
        @AuraEnabled public nbsapdpo nbsapdpo;
    }

    public class instruction{
        @AuraEnabled public String intExtBenInd;
        @AuraEnabled public String srcStmtRef;
        @AuraEnabled public String srcInstCode;
        @AuraEnabled public String trgAcc;
        @AuraEnabled public String srcClrCode;
        @AuraEnabled public String trgAccType;
        @AuraEnabled public String srcAccType;
        @AuraEnabled public String trgClrCode;
        @AuraEnabled public String srcAcc;
        @AuraEnabled public String trgInstCode;
        @AuraEnabled public String instrRefName;
        @AuraEnabled public String trgStmtRef;
        @AuraEnabled public String amount;
        @AuraEnabled public String trgBusinessCode;
        @AuraEnabled public String freq;
        @AuraEnabled public String clientType;
        @AuraEnabled public String endDate;
        @AuraEnabled public String payDay;
        @AuraEnabled public String startDate;
        @AuraEnabled public String doType;
        @AuraEnabled public String actDate;
        @AuraEnabled public String freeBankInd;
        @AuraEnabled public String ivrNominate;
        @AuraEnabled public String priNo;
        @AuraEnabled public String instrStatus;
        @AuraEnabled public String mandNo;
        @AuraEnabled public String uniqueEft;
        @AuraEnabled public String timeRange;
        @AuraEnabled public String multiNo;
        @AuraEnabled public String creditTrack;
        @AuraEnabled public String instrNo;
        @AuraEnabled public String iipAllowInd;
        @AuraEnabled public String instrType;
        @AuraEnabled public String lastMaintDate;
        @AuraEnabled public String tieb;
        @AuraEnabled public String lastMaintTell;
        @AuraEnabled public String cifKey;
    }

    //2021/01/11 - Humbelani Denge
    public override void setIntegrationTranslations(){
        integrationTranslationsMap = new Map<String,String>();
        integrationTranslationsMap.put('MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction.trgAccType', 'CIF;Account Type');
    }
}