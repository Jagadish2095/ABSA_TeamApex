/*
* Request Integration Bean for clientKey Service for package linking
* @author Satya Boyenepalli
* @created 2021-02-25 edited on 07/04/2021
*/


 /**
 * @description  ClientKey  Request class
 */
public class ClientKey_Req_IB_v1 extends Base_IB { 

 /**
 * @description  clientKey
 */
	 @AuraEnabled    public String clientKey;
     /**
 * @description  channel
 */

	 @AuraEnabled    public Channel channel;

	public class Channel {
		public Integer siteCode;
		public String tellerId;
		public String branch;
		public String deviceId;
		public String deviceType;
		public String agentUserId;
        public String employeeNumber;
	}
    /**
 * @description  createDummyRequest
 *  @return ClientKey_Req_IB_v1
 */
    public static ClientKey_Req_IB_v1 createDummyRequest() {
        
        ClientKey_Req_IB_v1 requestBean = new ClientKey_Req_IB_v1();
        requestBean.clientKey='AITCHL 001';
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