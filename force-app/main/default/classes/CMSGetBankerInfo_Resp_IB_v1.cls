/**
* Apex Integration Response Bean class for CMS Get Banker Info Service
* @author  Diksha Wasekar : Absa
*@Created Date:  2019-09-07
*
*
**/



public class CMSGetBankerInfo_Resp_IB_v1 extends Base_IB{
    
    public String status;
    public Integer statusCode;
    public String message;     
    

	public class ContOffDet {
		public String coEmployeeNum;
		public String exposurePolicy;
		public String groupReviewDate;
		public String franchisorCode;
		public String businessSubSeg;
		public String businessSeg;
		public String overallControl;
		public String divisionCode;
		public String dateApproved;
		public String appByEmployee;
		public String lastAction;
		public String dateCreated;
		public String capByEmployee;
		public String contOffNum;
		public String contOffType;
		public String indvGroup;
		public String branchCode;
	}

	public class Nbsapdpo {
		public String echoKey;
		public String serviceVersion;
		public String reasonCode;
		public String returnCode;
		public String version;
	}

	public class Gsp019o {
		public List<ContOffDet> contOffDet;
		public String noOfOccurences;
	}

	public Body Body;

	public class GBlistCmsContOffPerClntV2Response {
		public Gsp019o gsp019o;
		public Nbsmsgo3 nbsmsgo3;
		public Nbsapdpo nbsapdpo;
	}

	public class Nbsmsgo3 {
		public String nbrUserErrs;
		public String nbrUserMsgs;
		public String sysErrTxt;
		public String version;
	}

	public class Body {
		public GBlistCmsContOffPerClntV2Response GBlistCmsContOffPerClntV2Response;
	}

	


}