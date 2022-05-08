/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class svupdateaccountconditionsv2_IB_Resp_v1 extends Base_IB{
	/**
	 * @description ZCONN_AUDIT_INFO
	 */
	public class ZCONN_AUDIT_INFO {
		public String applicationID;
		public String userID;
		public String deviceID;
	}
	/**
	 * @description ZCONN_AUDIT_INFO
	 */
	public class UpdateTable {
		public String capturedPercentageIndicator;
		public String authourisationCode;
		public String parameterID;
		public Integer capturedAmount;
		public Integer capturedDate;
		public String conditionValue;
		public String capturedAmountSign;
		public String capturedRiskIndicator;
		public Integer supervisor;
	}
	/**
	 * @description ZCONN_AUDIT_INFO
	 */
	public ZCONN_AUDIT_INFO ZCONN_AUDIT_INFO;
	public SVSP05I SVSP05I;
	public MSGI MSGI;
	public NBSAPDPI NBSAPDPI;

	public class SVSP05I {
		public SVSP05I_INPUT_AREA SVSP05I_INPUT_AREA;
	}
	/**
	 * @description SVSP05I_INPUT_AREA
	 */
	public class SVSP05I_INPUT_AREA {
		public Object workStation;
		public Object branchSiteType;
		public Integer tableCount;
		public List<UpdateTable> updateTable;
		public Object agencyCode;
		public Object tellerCode;
		public String chargeIndicator;
		public String parameterRetrieveType;
		public Object branchCode;
		public Object divisionCode;
		public Object agencySiteType;
		public Object supervisorCode;
		public String savingsDepositType;
	}
	/**
	 * @description NBSMSGI
	 */
	public class NBSMSGI {
		public String messageTarget;
		public String messageLanguage;
	}
	/**
	 * @description MSGI
	 */
	public class MSGI {
		public NBSMSGI NBSMSGI;
	}
	/**
	 * @description NBSAPLI
	 */
	public class NBSAPLI {
		public String trace;
		public String application;
		public String channel;
	}
	/**
	 * @description NBSAPDPI
	 */
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}
}