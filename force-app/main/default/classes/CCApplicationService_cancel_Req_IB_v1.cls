/*
 * Request Integration Bean for CCApplicationService cancelApplication
 * @author Prudence Shirindzi
 * @created 2020-10-20
 */
public class CCApplicationService_cancel_Req_IB_v1 extends Base_IB {
    public class CancelApplication {
		public Arg0 arg0;
	}

	public CancelApplication cancelApplication;

	public class RequestCommons {
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String siteId;
		public String systemName;
		public String userId;
	}

	public class Arg0 {
		public String applicationNumber;
		public String cancelReasonId;
		public String corpCode;
		public String lockVersionId;
		public RequestCommons requestCommons;
	}
    
    public static CCApplicationService_cancel_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_cancel_Req_IB_v1 requestBean = new CCApplicationService_cancel_Req_IB_v1();

        requestBean.cancelApplication = new CCApplicationService_cancel_Req_IB_v1.CancelApplication();
        requestBean.cancelApplication.Arg0 = new CCApplicationService_cancel_Req_IB_v1.Arg0();
        requestBean.cancelApplication.Arg0.requestCommons = new CCApplicationService_cancel_Req_IB_v1.RequestCommons();
        
        return requestBean;
    }

    public static CCApplicationService_cancel_Req_IB_v1 createDummyRequest(){
       CCApplicationService_cancel_Req_IB_v1 requestBean = CCApplicationService_cancel_Req_IB_v1.getNewInstance();
        
       requestBean.cancelApplication.Arg0.applicationNumber = '102006121755501757';
       requestBean.cancelApplication.Arg0.cancelReasonId = '0';
       requestBean.cancelApplication.Arg0.corpCode = 'ABSA';
       requestBean.cancelApplication.Arg0.lockVersionId = '0';
       //Arg0bean.RequestCommonsbean.requestCommons = requestCommons;
       
       requestBean.cancelApplication.Arg0.requestCommons.channelCode = 'p';
       requestBean.cancelApplication.Arg0.requestCommons.employeeNumber = '9019050';
       requestBean.cancelApplication.Arg0.requestCommons.messageLanguage = 'E';
       requestBean.cancelApplication.Arg0.requestCommons.siteId = '4592';
       requestBean.cancelApplication.Arg0.requestCommons.systemName = 'ASP';
       requestBean.cancelApplication.Arg0.requestCommons.userId = 'abaj013';
        
       return requestBean;
    }

}