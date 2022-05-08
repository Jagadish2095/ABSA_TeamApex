/**
 * @description Response Integration Bean for CIgetAcctLinkedToClientCode Service
 * @author Pitso Sekhu
 * @created 2019-03-01
 */
public class CIgetAcctLinkedToClientCode_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public cls_Nbsapdpo nbsapdpo;
	@AuraEnabled
	public cls_Nbsmsgo3 nbsmsgo3;
	@AuraEnabled
	public cls_Cip047o cip047o;
	/**
	 * @description Innerclass
	 */
	public class cls_Nbsapdpo {
		@AuraEnabled
		public String version;
		@AuraEnabled
		public String returnCode;
		@AuraEnabled
		public String reasonCode;
		@AuraEnabled
		public String serviceVersion;
		@AuraEnabled
		public String echoKey;
	}
	/**
	 * @description Innerclass
	 */
	public class cls_Nbsmsgo3 {
		@AuraEnabled
		public String version;
		@AuraEnabled
		public String sysErrTxt;
		@AuraEnabled
		public String nbrUserMsgs;
		@AuraEnabled
		public String nbrUserErrs;
		@AuraEnabled
		public MsgEntry msgEntry;
	}
	/**
	 * @description Innerclass
	 */
	public class cls_Cip047o {
		@AuraEnabled
		public String counter;
		@AuraEnabled
		public String orestart;
		@AuraEnabled
		public cls_OutputTable[] outputTable;
	}
	/**
	 * @description Innerclass
	 */
	public class cls_OutputTable {
		@AuraEnabled
		public String oaccntnbr;
		@AuraEnabled
		public String product;
		@AuraEnabled
		public String productType;
		@AuraEnabled
		public String productTypeTranslated;
		@AuraEnabled
		public String branch;
		@AuraEnabled
		public String corp;
		@AuraEnabled
		public String status;
		@AuraEnabled
		public String dtclosed;
		@AuraEnabled
		public String balance;
		@AuraEnabled
		public String limit_Z;
		@AuraEnabled
		public String balanceTxt;
		@AuraEnabled
		public String detail;
		@AuraEnabled
		public String availableBalance;
		@AuraEnabled
		public String srcOfFnds1;
		@AuraEnabled
		public String srcOfFnds2;
		@AuraEnabled
		public String srcOfFnds3;
		@AuraEnabled
		public String srcOfFnds4;
		@AuraEnabled
		public String srcOfFnds5;
	}
	/**
	 * @description Innerclass
	 */
	public class MsgEntry {
		@AuraEnabled
		public String msgClass;
		@AuraEnabled
		public String msgCode;
		@AuraEnabled
		public String msgErrInd;
		@AuraEnabled
		public String msgTxt;
	}
	/**
	 * @description replaces reserved salesforce words in the response
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"limit":', '"limit_Z":');
	}
}