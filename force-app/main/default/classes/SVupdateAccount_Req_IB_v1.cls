/** 
 *@description Integration Handler for CIgetClientDetailsByNameV2 Service
 * @author Edited by Prudence Shirindzi 
 * @created 2021-05-12
 */
public without sharing class SVupdateAccount_Req_IB_v1 extends Base_IB {
    public NBSAPDPI NBSAPDPI;
	public MSGI MSGI;
	public SVSP09I SVSP09I;
	/** 
	 * @description NBSMSGI
	 */
    public without sharing class NBSMSGI {
		public String messageLanguage;
		public String messageTarget;
	}

	/** 
	 * @description MSGI
	 */
	public without sharing class MSGI {
		public NBSMSGI NBSMSGI;
	}

	/** 
	 * @description SVSP09I_INPUT_AREA
	 */
	   public without sharing class SVSP09I_INPUT_AREA {
		public String accountNumber;
		public String savingsDepositType;
		public String openReasonCode;
		public String accountName;
		public String groupSchemeCode;
		public String homeEmployPlanCode;
		public String grantType;
		public String specialAccountType;
		public String brokerSource;
		public String brokerNumber;
		public String crpCode;
		public String divisionCode;
		public String workStation;
		public String branchCode;
		public String agencyCode;
		public String agencySiteType;
		public String tellerCode;
		public String supervisorCode;
		public String branchSiteType;
	}

	/** 
	 * @description SVSP09I
	 */
	public without sharing class SVSP09I {
		public SVSP09I_INPUT_AREA SVSP09I_INPUT_AREA;
	}
    /** 
	 * @description NBSAPLI
	 */
    public without sharing class NBSAPLI {
		public String channel;
		public String application;
		public String trace;
	}

	/** 
	 * @description NBSAPDPI
	 */
	public without sharing class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}	
    /** 
	 * @description getNewInstance
	 * @return SVupdateAccount_Req_IB_v1
	 */
  public  SVupdateAccount_Req_IB_v1 getNewInstance()
  {
    SVupdateAccount_Req_IB_v1 request = new SVupdateAccount_Req_IB_v1();
    request.NBSAPDPI = new SVupdateAccount_Req_IB_v1.NBSAPDPI();
    request.NBSAPDPI.NBSAPLI = new SVupdateAccount_Req_IB_v1.NBSAPLI();
    request.SVSP09I = new SVupdateAccount_Req_IB_v1.SVSP09I();
    request.SVSP09I.SVSP09I_INPUT_AREA = new SVupdateAccount_Req_IB_v1.SVSP09I_INPUT_AREA();
    request.MSGI = new SVupdateAccount_Req_IB_v1.MSGI();
    request.MSGI.NBSMSGI = new SVupdateAccount_Req_IB_v1.NBSMSGI();
    return request;
  }

}