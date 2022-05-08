/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-08-31
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class svupdateaccountconditionsv2_IB_Req_v1 extends Base_IB {
	/**
	 * @description UpdateTable
	 */
	public class UpdateTable {
		public String parameterID;
		public String conditionValue;
		public string capturedAmount;
		public String capturedAmountSign;
		public String capturedPercentageIndicator;
		public String capturedRiskIndicator;
		public Integer capturedDate;
		public String authourisationCode;
		public Integer supervisor;
	}

	public NBSAPDPI NBSAPDPI;
	public MSGI MSGI;
	public SVSP05I SVSP05I;
	/**
	 * @description SVSP05I
	 */
	public class SVSP05I {
		public SVSP05I_INPUT_AREA SVSP05I_INPUT_AREA;
	}
	/**
	 * @description NBSMSGI
	 */
	public class NBSMSGI {
		public String messageLanguage;
		public String messageTarget;
	}
	/**
	 * @description MSGI
	 */
	public class MSGI {
		public NBSMSGI NBSMSGI;
	}
	/**
	 * @description SVSP05I_INPUT_AREA
	 */
	public class SVSP05I_INPUT_AREA {
		public string accountNumber;
		public String savingsDepositType;
		public String parameterRetrieveType;
		public String chargeIndicator;
		public Integer tableCount;
		public List<UpdateTable> updateTable;
		public String divisionCode;
		public String workStation;
		public Integer branchCode;
		public Integer agencyCode;
		public String agencySiteType;
		public Integer tellerCode;
		public Integer supervisorCode;
		public String branchSiteType;
	}
	/**
	 * @description NBSAPLI
	 */
	public class NBSAPLI {
		public String channel;
		public String application;
		public String trace;
	}
	/**
	 * @description NBSAPDPI
	 */
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}
}