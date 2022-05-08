/*
 * Request Integration Bean for CQcreateAndLinkAccountV8 Service
 * @author Tracy de Bruin
 * @created 2020-11-03
 */

public class CQcreateAndLinkAccountV8_Req_IB_v1 extends Base_IB{

    public NBSAPDPI NBSAPDPI;
	public MSGI MSGI;
	public CQS411I CQS411I;

	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

	public class MSGI {
		public NBSMSGI NBSMSGI;
	}
    
    public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	public class CQS411I {
		public CQN411I_INPUT_AREA CQN411I_INPUT_AREA;
	}
    
    public class CQN411I_INPUT_AREA {
		public Integer accountNbr;
		public Integer openSite;
		public Integer controlSite;
		public String cifKey;
		public Integer tellerNbr;
		public Integer controllerNbr;
		public Integer workstationNbr;
		public Integer product;
		public Integer applicationNbr;
		public String controlSiteType;
		public String openSiteType;
		public Integer effectiveDate;
		public Integer marketersCode;
		public String provChqBookInd;
		public String cbpSchemeCode;
		public Integer cbpPrimaryAccount;
		public String SourceOfFunds1;
		public String SourceOfFunds2;
		public String SourceOfFunds3;
		public String SourceOfFunds4;
		public String SourceOfFunds5;
		public String digitalChannel;
		public String rbaEdd;
		public String odRequired;
	}
    
    public static CQcreateAndLinkAccountV8_Req_IB_v1 createDummyRequest() {
        CQcreateAndLinkAccountV8_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV8_Req_IB_v1();
		requestBean.NBSAPDPI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSAPDPI();
		requestBean.NBSAPDPI.NBSAPLI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSAPLI();
		requestBean.MSGI = new CQcreateAndLinkAccountV8_Req_IB_v1.MSGI();
        requestBean.MSGI.NBSMSGI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSMSGI();
		requestBean.CQS411I = new CQcreateAndLinkAccountV8_Req_IB_v1.CQS411I();
		requestBean.CQS411I.CQN411I_INPUT_AREA = new CQcreateAndLinkAccountV8_Req_IB_v1.CQN411I_INPUT_AREA();
		
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'N';
		
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';
		
		requestBean.CQS411I.CQN411I_INPUT_AREA.accountNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSite = 6069;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSite = 6069;
		requestBean.CQS411I.CQN411I_INPUT_AREA.cifKey = 'SACOMPE259';
		requestBean.CQS411I.CQN411I_INPUT_AREA.tellerNbr = 9999999;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controllerNbr = 9999999;
		requestBean.CQS411I.CQN411I_INPUT_AREA.workstationNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.product = 11016;
		requestBean.CQS411I.CQN411I_INPUT_AREA.applicationNbr = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.controlSiteType = '034';
		requestBean.CQS411I.CQN411I_INPUT_AREA.openSiteType = '034';
		requestBean.CQS411I.CQN411I_INPUT_AREA.effectiveDate = 20201102;
		requestBean.CQS411I.CQN411I_INPUT_AREA.marketersCode = 76679520;
		requestBean.CQS411I.CQN411I_INPUT_AREA.provChqBookInd = 'N';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpSchemeCode = 'CQT02S02';
		requestBean.CQS411I.CQN411I_INPUT_AREA.cbpPrimaryAccount = 0;
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds1 = '39';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds2 = '39';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds3 = '39';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds4 = '39';
		requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds5 = '39';
		requestBean.CQS411I.CQN411I_INPUT_AREA.digitalChannel = 'B';
		requestBean.CQS411I.CQN411I_INPUT_AREA.rbaEdd = '';
        requestBean.CQS411I.CQN411I_INPUT_AREA.odRequired = 'A';

        return requestBean;
    }
}