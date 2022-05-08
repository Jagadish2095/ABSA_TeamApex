/*
* Request Integration Bean for idNumber Service for package linking
* @author Satya Boyenepalli
* @created 2021-02-26
*/
public class idNumber_Req_IB_v1 extends Base_IB  {
    public class ClientClassification {
		public String idNumber;
		public String idDocumentType;
		public String cifClientGroup;
		public String cifClientType;
	}

	public ClientClassification clientClassification;
	public Channel channel;

	public class Channel {
		public Integer siteCode;
		public String tellerId;
		public String branch;
		public String deviceId;
		public String deviceType;
		public String agentUserId;
        public String employeeNumber;
	}
     public static idNumber_Req_IB_v1 createDummyRequest() {
        
         idNumber_Req_IB_v1 requestBean = new idNumber_Req_IB_v1();
         requestBean.ClientClassification = new ClientClassification();
         requestBean.ClientClassification.idNumber='6702200100084';
         requestBean.ClientClassification.idDocumentType='ID_NUMBER';
         requestBean.ClientClassification.cifClientGroup='I';
         requestBean.ClientClassification.cifClientType='0';
         requestBean.Channel = new Channel();
         requestBean.Channel.agentUserId='exsb149';
         requestBean.Channel.branch='8474';
         requestBean.Channel.deviceId='deviceid';
         requestBean.Channel.deviceType='laptop';
         requestBean.Channel.siteCode = 8474;  
         requestBean.Channel.tellerId='000878';
         requestBean.Channel.employeeNumber='9117669';
         return requestBean;
    }

}