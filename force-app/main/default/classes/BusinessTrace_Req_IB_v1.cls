/**
 * Request Integration Bean for BusinessTrace Service
 * @author Englarmerdge Mongwe
 * @created 2021-01-08
 */
public class BusinessTrace_Req_IB_v1 extends Base_IB {
    public BusinessTrace BusinessTrace;

	public class BusinessTrace {
		public String Username;
		public String Password;
		public String BusinessName;
		public String SearchByIndicator;
		public String SearchByValue;
		public String SearchWord1;
		public String SearchWord2;
		public String SearchWord3;
		public String SearchSubsidiaryFile;
		public String TimeoutLimit;
		public String CustomerReference;
    }

    public static BusinessTrace_Req_IB_v1 createDummyRequest() {
        String reqJson = '{"BusinessTrace":{"Username":"ABSACOMMTEST","Password":"no5@8FV","BusinessName":"experian","SearchByIndicator":" ","SearchByValue":" ","SearchWord1":"experian","SearchWord2":"","SearchWord3":"","SearchSubsidiaryFile":"0","TimeoutLimit":"0","CustomerReference":"ABSA TRACE"}}';
        BusinessTrace_Req_IB_v1 requestBean = (BusinessTrace_Req_IB_v1)JSON.deserializeStrict(reqJson, BusinessTrace_Req_IB_v1.class);

        return requestBean;
    }
}