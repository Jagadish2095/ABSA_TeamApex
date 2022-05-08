public class CheckDigitVerification_Resp_IB_v1 extends Base_IB {

    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public String rc;
    @AuraEnabled public String branchName;
    @AuraEnabled public String accountHost;
    @AuraEnabled public String bankNameLong;
    @AuraEnabled public String bankNameShort;
    @AuraEnabled public String accountExceptionInd;
    @AuraEnabled public String branchType;
    @AuraEnabled public String acctypeZeroAllowed;
    @AuraEnabled public String bankCode;
    @AuraEnabled public String dt2Allowed;
    @AuraEnabled public String dt5Allowed;
    @AuraEnabled public String aedossIss;
    @AuraEnabled public String aedossAcq;
    @AuraEnabled public String naedossIss;
    @AuraEnabled public String naedossAcq;

    @AuraEnabled public cls_Fault Fault;

    public class cls_Fault{
        @AuraEnabled public String faultcode;
        @AuraEnabled public String faultstring;
        @AuraEnabled public cls_detail detail;
    }

    public class cls_detail{
        @AuraEnabled public cls_ExceptionDetail ExceptionDetail;
    }

    public class cls_ExceptionDetail extends cls_ExceptionBase{
        @AuraEnabled public cls_InnerExceptionCls InnerException;
        @AuraEnabled public cls_HelpLink HelpLink;
    }

    public class cls_HelpLink{}

    public class cls_InnerExceptionCls extends cls_ExceptionBase{
        @AuraEnabled public cls_InnerExceptionCls InnerException;
        @AuraEnabled public cls_HelpLink HelpLink;
    }

    public abstract class cls_ExceptionBase{
        @AuraEnabled public String innerExceptionType; //Type
        @AuraEnabled public String StackTrace;
        @AuraEnabled public String Message;
    }
}