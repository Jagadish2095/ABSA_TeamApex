/**
 * Request Integration Bean for GBgetCmsCreditGroupsDetV1 Service
 * @author Englarmerdge Mongwe
 * @created 2020-10-13
 */

public class GBgetCmsCreditGroupsDetV1_Req_IB_v1 extends Base_IB {
    public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
    public GSB014I_Z GSB014I;

	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
    }

	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
    }

	public class GSB014I_Z {
		public GSB014I GSB014I;
    }

    public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
    }

    public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	public class GSB014I {
		public String GSB014I_CLIENT_CODE;
	}

    public static GBgetCmsCreditGroupsDetV1_Req_IB_v1 createDummyRequest() {
        GBgetCmsCreditGroupsDetV1_Req_IB_v1 requestBean = new GBgetCmsCreditGroupsDetV1_Req_IB_v1();
		requestBean.NBSAPDPI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSMSGI_Z();
		requestBean.GSB014I = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.GSB014I_Z();
		requestBean.NBSAPDPI.NBSAPLI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSAPLI();
		requestBean.NBSMSGI.NBSMSGI = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.NBSMSGI();
		requestBean.GSB014I.GSB014I = new GBgetCmsCreditGroupsDetV1_Req_IB_v1.GSB014I();

		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';

		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		requestBean.GSB014I.GSB014I.GSB014I_CLIENT_CODE = 'REBELLO001';

        return requestBean;
    }
}