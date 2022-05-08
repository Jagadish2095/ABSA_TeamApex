/*
* Request implemention for Create Service for package linking
* @author Satya Boyenepalli
* @created 2021-03-02
*/
public class Create_Req_IB_v1 extends Base_IB {
    @AuraEnabled   public Channel channel;
    @AuraEnabled  public String clientKey;
    @AuraEnabled  public String chequeAccountNumber;
    @AuraEnabled  public String creditAccountNumber;
    @AuraEnabled  public String pricingCode;
    @AuraEnabled  public String packageName;
     
    public class Channel {
		public Integer siteCode;
		public String tellerId;
		public String branch;
		public String deviceId;
		public String deviceType;
		public String employeeNumber;
	}
    
    public static Create_Req_IB_v1 CreateDummyRequest() {
        
        Create_Req_IB_v1  requestBean = new Create_Req_IB_v1();
        requestBean.clientKey='ADAMSJ 084';
        requestBean.chequeAccountNumber='4048463909';
        requestBean.creditAccountNumber='4550270024983012';
        requestBean.pricingCode='CQT01S03';
        requestBean.packageName='GOLD';
        requestBean.Channel = new Channel();
        requestBean.Channel.siteCode=8198;
        requestBean.Channel.tellerId='000878';
        requestBean.Channel.branch='8198';
        requestBean.Channel.deviceId='deviceid';
        requestBean.Channel.deviceType='laptop';
        requestBean.Channel.employeeNumber='113';
        return requestBean;
        
    }
    
}