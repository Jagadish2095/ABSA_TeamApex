/*
 * CCApplicationService get request bean
 * @author Aaron Castelyn: ABSA
 * @created 2021-03-25 
 */

public class CCApplicationService_get_Req_IB_v1 extends Base_IB {
    public class requestCommons {
		public String channelCode;
		public String employeeNumber;
		public String messageLanguage;
		public String siteId;
		public String systemName;
		public String userId;
	}

	public getApplicationInformation getApplicationInformation;

	public class Arg0 {
		public String applicationNumber;
		public requestCommons requestCommons;
	}

	public class getApplicationInformation {
		public Arg0 arg0;
	}

    public static CCApplicationService_get_Req_IB_v1 getNewInstance()
    {
        CCApplicationService_get_Req_IB_v1 requestBean =  new CCApplicationService_get_Req_IB_v1();
        
        requestBean.getApplicationInformation = new CCApplicationService_get_Req_IB_v1.getApplicationInformation();
        
        requestBean.getApplicationInformation.arg0 = new CCApplicationService_get_Req_IB_v1.Arg0();

        requestBean.getApplicationInformation.arg0.requestCommons = new CCApplicationService_get_Req_IB_v1.requestCommons();

		return requestBean;
	}

	public static CCApplicationService_get_Req_IB_v1 createDummyRequest(){
		CCApplicationService_get_Req_IB_v1 requestBean = CCApplicationService_get_Req_IB_v1.getNewInstance();
		
		requestBean.getApplicationInformation.arg0.requestCommons.channelCode = 'B';
		requestBean.getApplicationInformation.arg0.requestCommons.employeeNumber = '9019050';
		requestBean.getApplicationInformation.arg0.requestCommons.messageLanguage ='E';
		requestBean.getApplicationInformation.arg0.requestCommons.siteId = '4592';
		requestBean.getApplicationInformation.arg0.requestCommons.systemName = 'BSF';
		requestBean.getApplicationInformation.arg0.requestCommons.userId ='ABAJ013';
	
		requestBean.getApplicationInformation.arg0.applicationNumber = '102104091328036505';
	
		return requestBean;
	}
}