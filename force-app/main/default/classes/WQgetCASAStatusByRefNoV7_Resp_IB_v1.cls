/**
 * @description       : Integration Bean for WQgetCASAStatusByRefNoV7 Service
 * @author            : Prudence Shirindzi
 * @last modified on  : 2021-09-08
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

public class WQgetCASAStatusByRefNoV7_Resp_IB_v1 extends Base_IB {
	/**
	 * @description       : WQgetCASAStatusByRefNoV7Response Prop
	 **/
	public WQgetCASAStatusByRefNoV7Response WQgetCASAStatusByRefNoV7Response { get; set; }
	/**
	 * @description       : WQgetCASAStatusByRefNoV7Response
	 **/
	public class WQgetCASAStatusByRefNoV7Response {
		public nbsapdpo nbsapdpo;
		public wqp102o wqp102o;
	}
	/**
	 * @description       : WQgetCASAStatusByRefNoV7Response
	 **/
	public class nbsapdpo {
		public String version;
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
		public String echoKey;
	}
	/**
	 * @description       : WQgetCASAStatusByRefNoV7Response
	 **/
	public class wqp102o {
		public String firstName;
		public String surnameComp;
		public String idType;
		public String idRegNo;
		public String casaStatus;
		public string approvedSts;
		public string documentSts;
		public String pepSts;
		public String comments;
		public String msgNo;
		public String msg;
	}

	/**
	 * @description       : WQgetCASAStatusByRefNoV7Response
	 **/
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('status', 'casaStatus');
	}
}