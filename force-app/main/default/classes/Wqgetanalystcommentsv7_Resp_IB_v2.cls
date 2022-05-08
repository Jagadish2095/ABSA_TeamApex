/**
 * @description       : eCasa Get analyst comments response bean
 * @author            : Thomas Dry : ABSA (IQ Business)
 * @last modified on  : 2021-08-06
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class Wqgetanalystcommentsv7_Resp_IB_v2 extends Base_IB {
	public String StatusMessage;
	public Integer StatusCode;

	/**
	 * @description       : WQgetAnalystCommentsV7Response
	 **/
	public WQgetAnalystCommentsV7Response WQgetAnalystCommentsV7Response { get; set; }

	/**
	 * @description       : WQgetAnalystCommentsV7Response
	 **/
	public class WQgetAnalystCommentsV7Response {
		public String name;
		public String surname;
		public String idType;
		public String idReg;
		public String dob;
		public String sbu;
		public Results results;
	}
	/**
	 * @description       : Results
	 **/
	public class Results {
		public String seqNo;
		public String commentCode;
		public String commentDesc;
	}
}