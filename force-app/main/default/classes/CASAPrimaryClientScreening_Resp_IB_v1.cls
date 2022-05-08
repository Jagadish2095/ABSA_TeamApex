public class CASAPrimaryClientScreening_Resp_IB_v1 extends Base_IB{
    
    public Integer statusCode;
    public String httpStatus;
    public String version;
    public String returnCode;
    public String reasonCode;
    public String serviceVersion;
    public String echoKey;
    public String msgNo;
    public String msg;
    public String refNo;
    public String status;
    
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