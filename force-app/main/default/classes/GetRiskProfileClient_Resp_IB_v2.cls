/*
        * Responce wrapper class for GetRiskProfileClient service
        * @author Srikanth N : Absa
        * @version v1.0
        * @since   2019-12-03
        *
   */

global class GetRiskProfileClient_Resp_IB_v2 extends Base_IB {
    
    public cls_WQriskProfileClientV7Response WQriskProfileClientV7Response;
    public String status;
    public Integer statusCode;
    
    public class cls_WQriskProfileClientV7Response{
        
        public Integer msgNo;
        public String msg;
        public String riskRating;
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
     public static GetRiskProfileClient_Resp_IB_v2 dummyResponse(){
        GetRiskProfileClient_Resp_IB_v2 responseBean = new GetRiskProfileClient_Resp_IB_v2();
        GetRiskProfileClient_Resp_IB_v2.cls_WQriskProfileClientV7Response riskprofileresponse =new GetRiskProfileClient_Resp_IB_v2.cls_WQriskProfileClientV7Response();
        responseBean.status='Ok';
        responseBean.statusCode=12;
        riskprofileresponse.msgNo=123;
        riskprofileresponse.msg='Test Message';
        riskprofileresponse.riskRating='Medium';
        return responseBean;
    }

}