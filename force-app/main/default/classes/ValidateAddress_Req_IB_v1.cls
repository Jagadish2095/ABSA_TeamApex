public class ValidateAddress_Req_IB_v1 extends Base_IB{
    
    public String language;
    public Integer numberOfAddress;
    public cls_addressCollection[] addressCollection;
    
    public class cls_addressCollection{
        public Integer addressType;
        public String addressLine1;
        public String addressLine2;
        public String suburb;
        public String town;
        public String postalCode;
    }
}