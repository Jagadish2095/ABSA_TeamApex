/**
 * @description  Response Integration Bean for Lead Service for Absa Instant Life
 * @author Satya Boyenepalli
 * @created 2021-07-28 
 */
public with sharing class Lead_Res_IB_v1 extends Base_IB {
	/**
	 * @description ConfirmationId
	 */

	public String ConfirmationId;
	/**
	 * @description ValidationErrors
	 */
	public List<ValidationErrors> ValidationErrors;
	public class ValidationErrors {
		public String Id;
		public String Message;
	}
	/**
	 * @description LeadResponse
	 * @return Lead_Res_IB_v1
	 */
	public static Lead_Res_IB_v1 dummyResponse() {
		Lead_Res_IB_v1 responseBean = new Lead_Res_IB_v1();
		responseBean.ConfirmationId = '95a8d8f0486645f1bb0032283313e2fc';
		responseBean.ValidationErrors = new List<Lead_Res_IB_v1.ValidationErrors>();
		return responseBean;
	}
}