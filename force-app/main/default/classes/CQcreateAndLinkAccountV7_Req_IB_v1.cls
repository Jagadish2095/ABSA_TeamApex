/*
 * Request Integration Bean for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

public class CQcreateAndLinkAccountV7_Req_IB_v1 extends Base_IB {

	public CQcreateAndLinkAccountV7 CQcreateAndLinkAccountV7;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Cqh411i {
		public String accountNbr;
		public String openSite;
		public String controlSite;
		public String cifKey;
		public String tellerNbr;
		public String controllerNbr;
		public String workstationNbr;
		public String product;
		public String applicationNbr;
		public String controlSiteType;
		public String openSiteType;
		public String effectiveDate;
		public String marketersCode;
		public String provChqBookInd;
		public String cbpSchemeCode;
		public String cbpPrimaryAccount;
		public String srcOfFnds1;
		public String srcOfFnds2;
		public String srcOfFnds3;
		public String srcOfFnds4;
		public String srcOfFnds5;
		public String digitalChannel;
		public String rbaEdd;
	}

	public class CQcreateAndLinkAccountV7 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cqh411i cqh411i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

    public static CQcreateAndLinkAccountV7_Req_IB_v1 createDummyRequest() {
        CQcreateAndLinkAccountV7_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV7_Req_IB_v1();
		requestBean.CQcreateAndLinkAccountV7 = new CQcreateAndLinkAccountV7_Req_IB_v1.CQcreateAndLinkAccountV7();
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi = new CQcreateAndLinkAccountV7_Req_IB_v1.Nbsapdpi();
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi = new CQcreateAndLinkAccountV7_Req_IB_v1.Nbsmsgi();
		requestBean.CQcreateAndLinkAccountV7.cqh411i = new CQcreateAndLinkAccountV7_Req_IB_v1.Cqh411i();
		
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.channel = 'BDP';
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.application = 'BDP';
		requestBean.CQcreateAndLinkAccountV7.nbsapdpi.trace = 'N';
		
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi.msgLanguage = 'E';
		requestBean.CQcreateAndLinkAccountV7.nbsmsgi.msgTarget = 'BDP';
		
		requestBean.CQcreateAndLinkAccountV7.cqh411i.accountNbr = '0';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.openSite = '1334';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controlSite = '1334';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cifKey = 'LTD    933';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.tellerNbr = '042030';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controllerNbr = '9999999';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.workstationNbr = '0';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.product = '11021';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.applicationNbr = '0';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.controlSiteType = '034';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.openSiteType = '034';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.effectiveDate = '20200217';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.marketersCode = '0';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.provChqBookInd = 'N';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cbpSchemeCode = '?';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.cbpPrimaryAccount = '0';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds1 = '39';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds2 = '39';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds3 = '39';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds4 = '39';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.srcOfFnds5 = '39';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.digitalChannel = 'B';
		requestBean.CQcreateAndLinkAccountV7.cqh411i.rbaEdd = '?';

        return requestBean;
    }
}