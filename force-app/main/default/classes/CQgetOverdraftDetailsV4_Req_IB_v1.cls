/**
 * Request Integration Bean for CQgetOverdraftDetailsV4 Service
 * @author Englarmerdge Mongwe
 * @created 2020-07-28
 */

public class CQgetOverdraftDetailsV4_Req_IB_v1 extends Base_IB {
    public CQgetOverdraftDetailsV4 CQgetOverdraftDetailsV4;

    public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

    public class CQgetOverdraftDetailsV4 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cqh478i cqh478i;
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

	public class Cqh478i {
		public String accountNbr;
		public String processingSite;
		public String processingSiteType;
		public String tellerNbr;
		public String agencyCode;
		public String agencyType;
		public String controllerNbr;
		public String corpCode;
	}

    public static CQgetOverdraftDetailsV4_Req_IB_v1 createDummyRequest() {
        CQgetOverdraftDetailsV4_Req_IB_v1 requestBean = new CQgetOverdraftDetailsV4_Req_IB_v1();
		requestBean.CQgetOverdraftDetailsV4 = new CQgetOverdraftDetailsV4_Req_IB_v1.CQgetOverdraftDetailsV4();
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi = new CQgetOverdraftDetailsV4_Req_IB_v1.Nbsapdpi();
		requestBean.CQgetOverdraftDetailsV4.nbsmsgi = new CQgetOverdraftDetailsV4_Req_IB_v1.Nbsmsgi();
		requestBean.CQgetOverdraftDetailsV4.cqh478i = new CQgetOverdraftDetailsV4_Req_IB_v1.Cqh478i();

		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.channel = 'BDP';
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.application = 'BDP';
		requestBean.CQgetOverdraftDetailsV4.nbsapdpi.trace = 'Y';

		requestBean.CQgetOverdraftDetailsV4.nbsmsgi.msgLanguage = 'E';
		requestBean.CQgetOverdraftDetailsV4.nbsmsgi.msgTarget = 'STD';

		requestBean.CQgetOverdraftDetailsV4.cqh478i.accountNbr = '4050797102';
		requestBean.CQgetOverdraftDetailsV4.cqh478i.processingSite = '5920';
        requestBean.CQgetOverdraftDetailsV4.cqh478i.processingSiteType = '034';
        requestBean.CQgetOverdraftDetailsV4.cqh478i.tellerNbr = '60';
		requestBean.CQgetOverdraftDetailsV4.cqh478i.agencyCode = '5920';
        requestBean.CQgetOverdraftDetailsV4.cqh478i.agencyType = '';
        requestBean.CQgetOverdraftDetailsV4.cqh478i.controllerNbr = '60';
		requestBean.CQgetOverdraftDetailsV4.cqh478i.corpCode = 'ABS';

        return requestBean;
    }
}