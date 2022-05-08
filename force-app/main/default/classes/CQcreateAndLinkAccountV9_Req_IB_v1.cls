/**
 * @description       : CQcreateAndLinkAccountV9_Req_IB_v1
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-19
 * @last modified by  : André Pietersen (IQ Business)
 * 1.1   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 **/

public class CQcreateAndLinkAccountV9_Req_IB_v1 extends Base_IB {
	public NBSAPDPI NBSAPDPI;
	public MSGI MSGI;
	public CQS411I CQS411I;

	/**
	 * @description NBSAPDPI
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

	/**
	 * @description MSGI
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class MSGI {
		public NBSMSGI NBSMSGI;
	}

	/**
	 * @description CQS411I
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class CQS411I {
		public CQN411I_INPUT_AREA CQN411I_INPUT_AREA;
	}

	/**
	 * @description NBSAPLI
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

	/**
	 * @description NBSMSGI
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	/**
	 * @description CQN411I_INPUT_AREA
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 **/
	public class CQN411I_INPUT_AREA {
		public Integer accountNbr;
		public String openSite;
		public String controlSite;
		public String cifKey;
		public String tellerNbr;
		public Integer controllerNbr;
		public String workstationNbr;
		public Integer product;
		public Integer applicationNbr;
		public String controlSiteType;
		public String openSiteType;
		public Integer effectiveDate;
		public Integer marketersCode;
		public String provChqBookInd;
		public String cbpSchemeCode;
		public Long cbpPrimaryAccount;
		public String SourceOfFunds1;
		public String SourceOfFunds2;
		public String SourceOfFunds3;
		public String SourceOfFunds4;
		public String SourceOfFunds5;
		public String digitalChannel;
		public String rbaEdd;
		public String odRequired;
		public Long packageId;
		public String fraudInd;
	}

	/**
	 * @description createDummyRequest
	 * @author André Pietersen (IQ Business) | 2021-08-19
	 * @return CQcreateAndLinkAccountV9_Req_IB_v1
	 **/
	public static CQcreateAndLinkAccountV9_Req_IB_v1 createDummyRequest() {
		CQcreateAndLinkAccountV9_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV9_Req_IB_v1();
		requestBean.NBSAPDPI = new NBSAPDPI();
		requestBean.MSGI = new MSGI();
		requestBean.CQS411I = new CQS411I();

		requestBean.CQS411I.CQN411I_INPUT_AREA = new CQN411I_INPUT_AREA();
		requestBean.CQS411I.CQN411I_INPUT_AREA.accountNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSite = '8198';
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSite = '8198';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cifKey = 'COLYNVP001';
		requestBean.CQS411I.CQN411I_INPUT_AREA.tellerNbr = '11';
		requestBean.CQS411I.CQN411I_INPUT_AREA.controllerNbr = 111;
		requestBean.CQS411I.CQN411I_INPUT_AREA.workstationNbr = '11';
		requestBean.CQS411I.CQN411I_INPUT_AREA.product = 11032;
		requestBean.CQS411I.CQN411I_INPUT_AREA.applicationNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSiteType = '034';
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSiteType = '034';
		requestBean.CQS411I.CQN411I_INPUT_AREA.effectiveDate = 20200826;
		requestBean.CQS411I.CQN411I_INPUT_AREA.marketersCode = 11;
		requestBean.CQS411I.CQN411I_INPUT_AREA.provChqBookInd = 'N';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpSchemeCode = 'CQT01501';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpPrimaryAccount = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds1 = '20';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds2 = '0';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds3 = '0';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds4 = '0';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds5 = '0';
		requestBean.CQS411I.CQN411I_INPUT_AREA.digitalChannel = 'E2E';
		requestBean.CQS411I.CQN411I_INPUT_AREA.rbaEdd = 'L';
		requestBean.CQS411I.CQN411I_INPUT_AREA.odRequired = 'N';
		requestBean.CQS411I.CQN411I_INPUT_AREA.packageId = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.fraudInd = 'N';

		requestBean.NBSAPDPI.NBSAPLI = new NBSAPLI();
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';

		requestBean.MSGI.NBSMSGI = new NBSMSGI();
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		return requestBean;
	}
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('CQS411I.CQN411I_INPUT_AREA.SourceOfFunds1', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CQS411I.CQN411I_INPUT_AREA.SourceOfFunds2', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CQS411I.CQN411I_INPUT_AREA.SourceOfFunds3', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CQS411I.CQN411I_INPUT_AREA.SourceOfFunds4', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CQS411I.CQN411I_INPUT_AREA.SourceOfFunds5', 'CIFCodesList;Sof');
	}
}