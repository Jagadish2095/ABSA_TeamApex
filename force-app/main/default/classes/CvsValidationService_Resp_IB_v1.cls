public with sharing class CvsValidationService_Resp_IB_v1 extends Base_IB
{
    public String status;
    public Integer statusCode;
    public String message;
    
    public String valStatusCode;
    
    public cls_StatusMessage statusMessage;
    public cls_addressCollection[] addressCollection;
    
    public class cls_StatusMessage
    {
        public cls_Error[] error;
        public cls_Error errorObj;
    }
    
    public class cls_Error
    {
        public String reason;
        public String[] reasonList;
    }
    
    public class cls_addressCollection
    {
        public String contactSFId;
        public String accountSFId;
        public String addressTypeSF;
        public String addressType;
        public String addressLine1;
        public String addressLine2;
        public String town;
        public String suburb;
        public String postalCode;
    }
    
    public override void setFieldNameSubstitutions()
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"statusCode":', '"valStatusCode":');
        fieldNameSubstitutionMap.put('"reason":[', '"reasonList":[');
        fieldNameSubstitutionMap.put('"error":{', '"errorObj":{');
    }
}