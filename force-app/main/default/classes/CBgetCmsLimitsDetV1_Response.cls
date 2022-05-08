/**
 * @author Jaco de Lange
 * @since 2021-02-03
 **/
public class CBgetCmsLimitsDetV1_Response {
    
    public class GBgetCmsLimitsDetV1Response {
		public Nbsapdpo nbsapdpo;
		public Nbsmsgo3 nbsmsgo3;
		public Gsb012o gsb012o;
	}
	public class Nbsapdpo {
		public Object version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public Object echoKey;
	}
	public GBgetCmsLimitsDetV1Response GBgetCmsLimitsDetV1Response;

	public class Nbsmsgo3 {
		public Object version;
		public Object sysErrTxt;
		public String nbrUserMsgs;
		public String nbrUserErrs;
	}
	public class Gsb012o {
		public String noOfOccurences;
		public List<LimitDetail> limitDetail;
	}
	public class LimitDetail {
		public String indGrpLim;
		public String typeOfLim;
		public String prodOrComb;
		public String status;
		public String contBranch;
		public String contOffTyp;
		public String contOffNum;
		public String crac;
		public String limArrangement;
		public String oram;
		public String limitAmount;
		public String credBalRange;
		public String limExpDate;
		public String dateApproved;
		public String reviewDate;
		public String reduceCycle;
		public String reduceDate;
		public String reduceAmount;
		public String onceoffRedAmt;
		public String onceoffRedDate;
		public Object forCurrUnit;
		public String forLimAmount;
		public String daylimAmount;
		public String daylimExpDate;
		public String prevAction;
		public String emplPrevAct;
		public String datePrevAct;
		public String empnamePrevAct;
		public String mamt;
		public String appFuncPrevAct;
		public String emplAppPrevAct;
		public String appDatePrevAct;
		public String empnameAppPrev;
		public String vind;
	}
    	public static CBgetCmsLimitsDetV1_Response parse(String json) {
		return (CBgetCmsLimitsDetV1_Response) System.JSON.deserialize(json, CBgetCmsLimitsDetV1_Response.class);
	}
}