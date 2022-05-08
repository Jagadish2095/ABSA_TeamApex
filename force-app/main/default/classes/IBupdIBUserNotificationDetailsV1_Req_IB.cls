/*
 * Request Integration Bean for IBupdIBUserNotificationDetails Service
 * @author Myshkovets Angelina
 * @created 2021-08-25
 */
/**
 * @description IBupdIBUserNotificationDetailsV1_Req_IB
 */
public class IBupdIBUserNotificationDetailsV1_Req_IB extends Base_IB {
	public IBupdIBUserNotificationDetailsV1 IBupdIBUserNotificationDetailsV1;
	/**
	 * @description IBupdIBUserNotificationDetailsV1
	 */
	public class IBupdIBUserNotificationDetailsV1 {
		public nbsapdpi nbsapdpi ;
		public nbsmsgi nbsmsgi;
		public nhp297i nhp297i;
	}
	/**
	 * @description nbsapdpi
	 */
	public class nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
	/**
	 * @description nbsmsgi
	 */
	public class nbsmsgi {
		public String msgTarget;
		public String msgLanguage;
		public finalMsgId finalMsgId;
	}
	/**
	 * @description finalMsgId
	 */
	public class finalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
	/**
	 * @description nhp297i
	 */
	public class nhp297i {
		public String branch;
		public String subBranch;
		public String siteType;
		public String teller;
		public String manager;
		public String agencyCode;
		public String workstation;
		public String supervisor;
		public String accessAccount;
		public String userNumber;
		public String cellphoneNumber;
		public String faxCode;
		public String faxNumber;
		public String email;
		public String rvnNotifyMethod;
		public String alertNotifyMethod;
		public String popNotifyMethod;
		public String generalNotifyMethod;
		public String reminderNotifyMethod;
	}
	/**
	 * @description createDummyRequest
	 * @return IBupdIBUserNotificationDetailsV1_Req_IB
	 */
	public static IBupdIBUserNotificationDetailsV1_Req_IB createDummyRequest() {
		IBupdIBUserNotificationDetailsV1_Req_IB requestBean = new IBupdIBUserNotificationDetailsV1_Req_IB();

		IBupdIBUserNotificationDetailsV1_Req_IB.nbsapdpi nbsapdpiRequest = new IBupdIBUserNotificationDetailsV1_Req_IB.nbsapdpi();
		nbsapdpiRequest.application = 'BDP';
		nbsapdpiRequest.channel = 'BDP';
		nbsapdpiRequest.trace = 'N';

		IBupdIBUserNotificationDetailsV1_Req_IB.nbsmsgi nbsmsgiRequest = new IBupdIBUserNotificationDetailsV1_Req_IB.nbsmsgi();
		nbsmsgiRequest.msgLanguage = 'E';
		nbsmsgiRequest.msgTarget = 'STD';

		IBupdIBUserNotificationDetailsV1_Req_IB.finalMsgId finalMsgIdRequest = new IBupdIBUserNotificationDetailsV1_Req_IB.finalMsgId();
		finalMsgIdRequest.finalMsgClass = '?';
		finalMsgIdRequest.finalMsgCode = '?';

		IBupdIBUserNotificationDetailsV1_Req_IB.nhp297i nhp297iRequest = new IBupdIBUserNotificationDetailsV1_Req_IB.nhp297i();
		nhp297iRequest.accessAccount = '4047920380';
		nhp297iRequest.branch = '8198';
		nhp297iRequest.subBranch = '0';
		nhp297iRequest.siteType = '034';
		nhp297iRequest.teller = '1469';
		nhp297iRequest.manager = '0';
		nhp297iRequest.agencyCode = '0';
		nhp297iRequest.workstation = 'WS';
		nhp297iRequest.supervisor = '0';

		IBupdIBUserNotificationDetailsV1_Req_IB.IBupdIBUserNotificationDetailsV1 IBupdIBUserNotificationDetailsV1bean = new IBupdIBUserNotificationDetailsV1_Req_IB.IBupdIBUserNotificationDetailsV1();
		IBupdIBUserNotificationDetailsV1bean.nbsapdpi = nbsapdpiRequest;
		IBupdIBUserNotificationDetailsV1bean.nbsmsgi = nbsmsgiRequest;
		IBupdIBUserNotificationDetailsV1bean.nhp297i = nhp297iRequest;

		requestBean.IBupdIBUserNotificationDetailsV1 = IBupdIBUserNotificationDetailsV1bean;

		return requestBean;
	}
}