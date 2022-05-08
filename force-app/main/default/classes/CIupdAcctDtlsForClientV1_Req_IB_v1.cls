/**
 * @description       : CIupdAcctDtlsForClientV1_Req_IB_v1
 * @author            : Rudolf Niehaus
 * @last modified on  : 2021-10-25
 * @last modified by  : André Pietersen (IQ Business)
 * 1.1   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 * 1.2   2021-10-25   André Pietersen (IQ Business)   Changed translation value
 **/

public class CIupdAcctDtlsForClientV1_Req_IB_v1 extends Base_IB {
	public CIupdAcctDtlsForClientV1 CIupdAcctDtlsForClientV1;

	/**
	 * @description Nbsmsgi
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	/**
	 * @description Nbsmsgi
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public class AccEntry {
		public String actionCode;
		public String accountNo;
		public String product;
		public String srcOfFnds1;
		public String srcOfFnds2;
		public String srcOfFnds3;
		public String srcOfFnds4;
		public String srcOfFnds5;
	}

	/**
	 * @description Nbsmsgi
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	/**
	 * @description CIupdAcctDtlsForClientV1
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/

	public class CIupdAcctDtlsForClientV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cip014di cip014di;
	}

	/**
	 * @description Nbsmsgi
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public class Cip014di {
		public String clientCode;
		public String nbrOfRecords;
		public String tellerNo;
		public String site;
		public String corp;
		public AccEntry accEntry;
	}

	/**
	 * @description Nbsmsgi
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	/**
	 * @description setIntegrationTranslations
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 **/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds1', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds2', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds3', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds4', 'CIFCodesList;Sof');
		integrationTranslationsMap.put('CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds5', 'CIFCodesList;Sof');
	}

	/**
	 * @description createDummyRequest
	 * @author André Pietersen (IQ Business) | 2021-08-18
	 * @return CIupdAcctDtlsForClientV1_Req_IB_v1
	 **/
	public static CIupdAcctDtlsForClientV1_Req_IB_v1 createDummyRequest() {
		CIupdAcctDtlsForClientV1_Req_IB_v1 requestBean = new CIupdAcctDtlsForClientV1_Req_IB_v1();

		requestBean.CIupdAcctDtlsForClientV1 = new CIupdAcctDtlsForClientV1_Req_IB_v1.CIupdAcctDtlsForClientV1();

		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi = new CIupdAcctDtlsForClientV1_Req_IB_v1.Nbsapdpi();
		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi = new CIupdAcctDtlsForClientV1_Req_IB_v1.Nbsmsgi();
		requestBean.CIupdAcctDtlsForClientV1.cip014di = new CIupdAcctDtlsForClientV1_Req_IB_v1.Cip014di();
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry = new CIupdAcctDtlsForClientV1_Req_IB_v1.AccEntry();

		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.channel = 'BDP';
		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.application = 'BDP';
		requestBean.CIupdAcctDtlsForClientV1.nbsapdpi.trace = 'N';

		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi.msgLanguage = 'E';
		requestBean.CIupdAcctDtlsForClientV1.nbsmsgi.msgTarget = 'STD';

		requestBean.CIupdAcctDtlsForClientV1.cip014di.clientCode = 'UOISUO 001';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.nbrOfRecords = '1';
		//requestBean.CIupdAcctDtlsForClientV1.cip014di.tellerNo = '000866';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.site = '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.corp = '';

		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.actionCode = 'A';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.accountNo = '4048376500';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.product = '11003';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds1 = '20';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds2 = '22';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds3 = '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds4 = '';
		requestBean.CIupdAcctDtlsForClientV1.cip014di.accEntry.srcOfFnds5 = '';

		return requestBean;
	}
}