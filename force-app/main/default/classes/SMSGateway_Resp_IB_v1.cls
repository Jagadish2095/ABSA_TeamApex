public class SMSGateway_Resp_IB_v1 extends Base_IB{

    public String status;
    public Integer statusCode;
    public String message;
    
    public Integer ErrorCode;
    public String ErrorDescription;
    
    //Message Body Fields
    public String MessageReference;
    public String PhoneNumber;
    public String Credits;
    public String smsType;//Type
    public String statusNumber;
    public String StatusDescription;
    public String CreateTime;
    public String ScheduledTime;
    public String SubmitTime;
    public String ConfirmTime;
    public String FinalTime;
    public String UserReference;
    public String MessageText;
    public String SourceNumber;
    public String Flags;
    public String OriginalText;
    public String Success;

    public override void setRequiredFields(){
        
        requiredFieldsSet = new Set<String>();
        requiredFieldsSet.add('MessageReference');
    }
}