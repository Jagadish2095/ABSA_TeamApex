/**
 *@description Integration Handler for FraudService_Resp_IB_v1 Service
 * @author Nkaiseng Malete
 * @created 2021-09-17
 */
public without sharing class FraudService_Resp_IB_v1 extends Base_IB {
	public Integer statusCode;
	public String message;

	public String status;
	public Content content;
	public List<Links> links;
	public List<Error> errors;
	/**
	 * @description Content
	 */
	public class Content {
		public String fraudStatus;
		public String applicationNumber;
		public String channelReference;
	}
	/**
	 * @description Links
	 */
	public class Links {
	}
	/**
	 * @description Error
	 */
	public class Error {
		public string fieldName;
		public string sourceSystem;
		public string type;
		public string message;
	}
}