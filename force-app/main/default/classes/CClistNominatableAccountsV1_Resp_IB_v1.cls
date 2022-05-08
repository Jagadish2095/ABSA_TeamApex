/*
 * Response Integration Bean for CClistNominatableAccountsV Service
 * @author Satya Boyenepalli
 * @created 2020-11-04
 */
public class CClistNominatableAccountsV1_Resp_IB_v1 extends Base_IB  {
	public CClistNominatableAccountsV1Response CClistNominatableAccountsV1Response;

	public class CClistNominatableAccountsV1Response {
	 	@AuraEnabled public Ccp315o ccp315o;
	  	@AuraEnabled public Nbsapdpo nbsapdpo;
	   	@AuraEnabled public Nbsmsgo nbsmsgo;
	}
	
	public class Nbsapdpo {
		public String version;
		public Integer reasonCode;
		public Integer returnCode;
		public String serviceVersion;
		public String echoKey;
	}

	public class Nbsmsgo {
		public String version;
		public String sysErrTxt;
		public Integer nbrUserErrs;
		public Integer nbrUserMsgs;
		public msgEntry msgEntry;
	}

	public class msgEntry {
		public String msgClass;
		public String msgCode;
		public String msgErrInd;
		public String msgTxt;
	}

	public class Ccp315o {
		public String cifRetrvdInd;
		public String nomNbrAccntRet;
		public String nomNxtAccnt;
		public List<NomAccntLst> nomAccntLst;
	}

	public class NomAccntLst {
		public String accntNbr;
		public String prodCode;
		public String prodType;
	}
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');        
	}
}