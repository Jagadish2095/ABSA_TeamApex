/**
 * Request Integration Bean for CQgetClientConductV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020-08-06
 */

public class CQgetClientConductV3_Req_IB_v1 extends Base_IB {

    public CQgetClientConductV3 CQgetClientConductV3;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class CQgetClientConductV3 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cqh482i cqh482i;
    }

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	public class Cqh482i {
		public String accountNbr;
		public String branchCode;
		public String branchSiteType;
		public String tellerCode;
		public String siteTypeAgency;
		public String supervisorCode;
		public String agencyCode;
		public String corpCode;
    }

    public static CQgetClientConductV3_Req_IB_v1 createDummyRequest() {
        CQgetClientConductV3_Req_IB_v1 requestBean = new CQgetClientConductV3_Req_IB_v1();
		requestBean.CQgetClientConductV3 = new CQgetClientConductV3_Req_IB_v1.CQgetClientConductV3();
		requestBean.CQgetClientConductV3.nbsapdpi = new CQgetClientConductV3_Req_IB_v1.Nbsapdpi();
		requestBean.CQgetClientConductV3.nbsmsgi = new CQgetClientConductV3_Req_IB_v1.Nbsmsgi();
		requestBean.CQgetClientConductV3.cqh482i = new CQgetClientConductV3_Req_IB_v1.Cqh482i();

		requestBean.CQgetClientConductV3.nbsapdpi.channel = 'BDP';
		requestBean.CQgetClientConductV3.nbsapdpi.application = 'BDP';
		requestBean.CQgetClientConductV3.nbsapdpi.trace = 'Y';

		requestBean.CQgetClientConductV3.nbsmsgi.msgLanguage = 'E';
		requestBean.CQgetClientConductV3.nbsmsgi.msgTarget = 'STD';

		requestBean.CQgetClientConductV3.cqh482i.accountNbr = '4050797102';
		requestBean.CQgetClientConductV3.cqh482i.branchCode = '8198';
        requestBean.CQgetClientConductV3.cqh482i.branchSiteType = '034';
        requestBean.CQgetClientConductV3.cqh482i.tellerCode = '12345';
		requestBean.CQgetClientConductV3.cqh482i.siteTypeAgency = '034';
        requestBean.CQgetClientConductV3.cqh482i.supervisorCode = '0';
        requestBean.CQgetClientConductV3.cqh482i.agencyCode = '8198';
        requestBean.CQgetClientConductV3.cqh482i.corpCode = '0';

        return requestBean;
    }
}