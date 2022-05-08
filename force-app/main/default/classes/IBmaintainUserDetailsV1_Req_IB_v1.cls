/**
 * @description       : IBmaintainUserDetailsV1_Req_IB_v1
 * @author            : Willy zuvana
 * @last modified on  : 2021-07-21
 * @last modified by  : Willy zuvana
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   2021-07-21   Willy zuvana   Initial Version
**/
public class IBmaintainUserDetailsV1_Req_IB_v1 Extends Base_IB {
	public IBmaintainUserDetailsV1 IBmaintainUserDetailsV1;
    
	/**
    * @description IBmaintainUserDetailsV1
    */
	public class IBmaintainUserDetailsV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nhp299i nhp299i;
	}
	
	/**
    * @description UserDetail
    */
	public class UserDetail {
		public String option;
		public String userNumber;
		public String userName;
		public String userId;
		public String language;
	}
    
	/**
    * @description Nhp299i
    */
	public class Nhp299i {
		public String branch;
		public String subBranch;
		public String siteType;
		public String teller;
		public String manager;
		public String agencyCode;
		public String workstation;
		public String supervisor;
		public String accessAccount;
		public String numberOfUserEntries;
		public List<UserDetail> userDetail;
	}
    
	/**
    * @description FinalMsgId
    */
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
    
	/**
    * @description Nbsapdpi
    */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
    
	/**
    * @description Nbsmsgi
    */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}


	/**
	* @description createDummyRequest
	* @author Willy zuvana | 2021-07-21
	* @return IBmaintainUserDetailsV1_Req_IB_v1
	**/
	public static IBmaintainUserDetailsV1_Req_IB_v1 createDummyRequest() {
        
        IBmaintainUserDetailsV1_Req_IB_v1 requestBean = new IBmaintainUserDetailsV1_Req_IB_v1();
		IBmaintainUserDetailsV1_Req_IB_v1.UserDetail userDetailBean = new IBmaintainUserDetailsV1_Req_IB_v1.UserDetail();
        List<IBmaintainUserDetailsV1_Req_IB_v1.UserDetail> userDetailBeanList = new List<IBmaintainUserDetailsV1_Req_IB_v1.UserDetail>();
		
        requestBean.IBmaintainUserDetailsV1 = new IBmaintainUserDetailsV1_Req_IB_v1.IBmaintainUserDetailsV1();
		requestBean.IBmaintainUserDetailsV1.nbsapdpi = new IBmaintainUserDetailsV1_Req_IB_v1.Nbsapdpi();
		requestBean.IBmaintainUserDetailsV1.nbsapdpi.channel = 'BDP';
		requestBean.IBmaintainUserDetailsV1.nbsapdpi.application = 'API';
		requestBean.IBmaintainUserDetailsV1.nbsapdpi.trace = 'Y';
		
		requestBean.IBmaintainUserDetailsV1.nbsmsgi = new IBmaintainUserDetailsV1_Req_IB_v1.Nbsmsgi();
		requestBean.IBmaintainUserDetailsV1.nbsmsgi.msgLanguage = 'E';
		requestBean.IBmaintainUserDetailsV1.nbsmsgi.msgTarget = 'STD';
		requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId = new IBmaintainUserDetailsV1_Req_IB_v1.FinalMsgId();
		requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId.finalMsgCode = '';
		
		requestBean.IBmaintainUserDetailsV1.nhp299i = new IBmaintainUserDetailsV1_Req_IB_v1.Nhp299i();
		requestBean.IBmaintainUserDetailsV1.nhp299i.branch = '008007';
		requestBean.IBmaintainUserDetailsV1.nhp299i.subBranch = '';
		requestBean.IBmaintainUserDetailsV1.nhp299i.siteType = '034';
		requestBean.IBmaintainUserDetailsV1.nhp299i.teller = '878';
		requestBean.IBmaintainUserDetailsV1.nhp299i.manager = '0';
		requestBean.IBmaintainUserDetailsV1.nhp299i.agencyCode = '0';
		requestBean.IBmaintainUserDetailsV1.nhp299i.workstation = 'LA';
		requestBean.IBmaintainUserDetailsV1.nhp299i.supervisor = '0';
		requestBean.IBmaintainUserDetailsV1.nhp299i.accessAccount = '9051357491';
		requestBean.IBmaintainUserDetailsV1.nhp299i.numberOfUserEntries = '2';
		userDetailBean.option = 'A';
		userDetailBean.userNumber = '0';
		userDetailBean.userName = 'SAM SMITH';
		userDetailBean.userId = '1212323';
		userDetailBean.language = 'E';
		userDetailBeanList.add(userDetailBean);
		requestBean.IBmaintainUserDetailsV1.nhp299i.userDetail = userDetailBeanList;

        return requestBean;
    }
}