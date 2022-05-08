public class AddAccountToPortfolio_Resp_IB_v1 extends Base_IB 
{
    public String status;
    public Integer statusCode;
    public String message;    
    
    public String version;
    public String sysErrTxt;
    public String nbrUserMsgs;
    public String nbrUserErrs;
    public cls_msgEntry[] msgEntry; 
   
    public class cls_msgEntry
      {
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
      }   
}