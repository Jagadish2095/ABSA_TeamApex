/**
 * @description Integration Response for Marble create account Service
 * @author Haritha Police
 * @created 2021-04-19
 * @param response class
 */
public class SPMMarbleCreateAccount_Resp_IB_V1 extends Base_IB {
	/**
	 * @description Method that maps request parameters based on Opportunity Id
	 * @param
	 * @return  SPMMarbleCreateAccount_Req_IB_V1
	 */
	public class MarbleAccountTypeResponseList {
		public Integer fundId;
		public Integer portfolioId;
		public Integer portfolioProductTypeID;
	}
	public String requestId;
	public Integer partnerID;
	public Integer entityId;
	public Integer crmEntityTypeId;
	public String crmEntityName;
	public String mobileNumber;
	public String email;
	public List<MarbleAccountTypeResponseList> marbleAccountTypeResponseList;
	public MarbleAccountResult marbleAccountResult;
	public Result result;
	/**
	 * @description Method that maps request parameters based on Opportunity Id
	 * @param
	 * @return  SPMMarbleCreateAccount_Req_IB_V1
	 */
	public class MarbleAccountResult {
		public Integer status;
		public Integer statusCode;
		public String statusMessage;
	}
	/**
	 * @description Method that maps request parameters based on Opportunity Id
	 * @param
	 * @return  SPMMarbleCreateAccount_Req_IB_V1
	 */
	public class Result {
		public Integer status;
		public Integer errorCode;
		public String errorMessage;
		public String data;
	}
	/**
	 * @description Method that returns an dummy response
	 * @param
	 * @return  Account     The Account object record
	 */
	public static SPMMarbleCreateAccount_Resp_IB_V1 createDummyResponse() {
		SPMMarbleCreateAccount_Resp_IB_V1 responseBean = new SPMMarbleCreateAccount_Resp_IB_V1();
		responseBean.MarbleAccountTypeResponseList = new List<SPMMarbleCreateAccount_Resp_IB_V1.marbleAccountTypeResponseList>();
		list<SPMMarbleCreateAccount_Resp_IB_V1.MarbleAccountTypeResponseList> listmarbleacctype = new List<SPMMarbleCreateAccount_Resp_IB_V1.MarbleAccountTypeResponseList>();
		return responseBean;
	}
}