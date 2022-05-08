/*
* Request Integration Bean for IZcreateUniqueKeyV1 Service
* @author Satya Boyenepalli
* @created 10/11/2020 
*/
public class IZcreateUniqueKeyV1_Req_IB_v1 extends Base_IB   {

    public class InputHeaders {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}

	public class InputErrorMessage {
		public String inputErrorMessageLanguage;
		public String inputErrorMessageTarget;
	}

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public IZBKEYI IZBKEYI;

	public class InputDetail {
		public String requestType;
	}

	public class IZBKEYI {
		public InputDetail inputDetail;
	}

	public class NBSMSGI {
		public InputErrorMessage inputErrorMessage;
	}

	public class NBSAPDPI {
		public InputHeaders inputHeaders;
	}

    public static IZcreateUniqueKeyV1_Req_IB_v1 createDummyRequest() {
        IZcreateUniqueKeyV1_Req_IB_v1 requestBean = new IZcreateUniqueKeyV1_Req_IB_v1();
		requestBean.NBSAPDPI  = new IZcreateUniqueKeyV1_Req_IB_v1.NBSAPDPI ();
        requestBean.NBSAPDPI.InputHeaders  = new IZcreateUniqueKeyV1_Req_IB_v1.InputHeaders ();
        
        requestBean.NBSAPDPI.InputHeaders.channelName = 'BDP';
        requestBean.NBSAPDPI.InputHeaders.applicationName = 'BDP';
        requestBean.NBSAPDPI.InputHeaders.traceIndicator = 'Y';
        
        requestBean.NBSMSGI  = new IZcreateUniqueKeyV1_Req_IB_v1.NBSMSGI ();
        requestBean.NBSMSGI.InputErrorMessage  = new IZcreateUniqueKeyV1_Req_IB_v1.InputErrorMessage ();
        
        requestBean.NBSMSGI.InputErrorMessage.inputErrorMessageLanguage = 'E';
        requestBean.NBSMSGI.InputErrorMessage.inputErrorMessageTarget = 'STD';
        
       requestBean.IZBKEYI  = new IZcreateUniqueKeyV1_Req_IB_v1.IZBKEYI ();
        requestBean.IZBKEYI.InputDetail  = new IZcreateUniqueKeyV1_Req_IB_v1.InputDetail ();
        
        requestBean.IZBKEYI.InputDetail.requestType = 'A'; 

        return requestBean;
    }
}