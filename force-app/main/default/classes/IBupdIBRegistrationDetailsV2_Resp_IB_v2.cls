/*
 * Response Integration Bean for IBupdIBRegistrationDetailsV2 Service
 * @author Angelina
 * @created 2020-10-15
 */
/**
 * @description IBupdIBRegistrationDetailsV2_Resp_IB_v2
 */
public class IBupdIBRegistrationDetailsV2_Resp_IB_v2 extends Base_IB {
/**
 * @description Nbsapdpo
 */
	public class Nbsapdpo {
		public string version;
		public string serviceVersion;
		public Integer returnCode;
		public Integer reasonCode;
		public string echoKey;
	}

	/**
	 * @description IBupdIBRegistrationDetailsV2Response
	 */
	public class IBupdIBRegistrationDetailsV2Response {
		public Nbsmsgo3 nbsmsgo3;
		public Nbsapdpo nbsapdpo;
	}

	public IBupdIBRegistrationDetailsV2Response IBupdIBRegistrationDetailsV2Response;

	/**
	 * @description Nbsmsgo3
	 */
	public class Nbsmsgo3 {
		public String version;
		public string sysErrTxt;
		public Integer nbrUserMsgs;
		public Integer nbrUserErrs;
		public List<MsgEntry> msgEntry;
	}
	/**
	 * @description MsgEntry
	 */
	public class MsgEntry {
		public String msgTxt;
		public String msgErrInd;
		public String msgCode;
		public String msgClass;
	}
	/**
	 * @description setFieldNameSubstitutions
	 */
    
     public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String, String>();

        integrationTranslationsMap.put('Assessment.AssessmentID', 'TestSystem;TestType');
        integrationTranslationsMap.put('Assessment.Locales.Locale.TestName', 'TestSystem;TestType');

    }
    
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('"number":', '"z_number":');
	}
}