public class GetBankClearanceCodes_Resp_IB_v1 extends Base_IB {
    
    public String status;
    public Integer statusCode;
    public String message;
    public String moreInd;
    public cls_bankBranch[] bankBranchList;
    
    public class cls_bankBranch{
        
        public String instNameLst;
        public String branchNameLst;
        public String clrCodeLst;
        public String instShrtnamLst;
        public String telNrLst;
        public String ssviLst;
        public String ds1iLst;
        public String ds2iLst;
        public String ds5iLst;
        public String add1Lst;
        public String add2Lst;
        public String poboxLst;
        public String pofficeLst;
        public String pcodeLst;
        public String outCentreLst;
        public String streamLst;
        
    }
    
    
    public cls_Fault Fault;
    
    public class cls_Fault{
        public String faultcode;
        public String faultstring;
        public cls_detail detail;
    }
    
    public class cls_detail{
        public cls_ExceptionDetail ExceptionDetail;
    }
    
    public class cls_ExceptionDetail extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }
    
    public class cls_HelpLink{}
    
    public class cls_InnerExceptionCls extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }
    
    public abstract class cls_ExceptionBase{
        public String innerExceptionType; //Type
        public String StackTrace;
        public String Message;
    }
}