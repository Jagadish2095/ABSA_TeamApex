public class ValidateAddress_Resp_IB_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;
    
    public String nbrUserMsgs;
    public String nbrUserErrs;
	public cls_msgEntry[] msgEntry;
    public String numAddrReturn;
    public cls_addressCollection[] addressCollection;
    
    public class cls_msgEntry{
        public String msgClass;
        public String msgCode;
        public String msgErrInd;
        public String msgTxt;
    }
    public class cls_addressCollection{
        public String addressType;
        public String addressLine1;
        public String addressLine2;
        public String town;
        public String suburb;
        public String postalCode;
    }
}