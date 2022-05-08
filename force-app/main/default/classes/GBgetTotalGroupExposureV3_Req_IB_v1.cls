/**
 * Request Integration Bean for for GBgetTotalGroupExposureV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020/12/29
 */
public class GBgetTotalGroupExposureV3_Req_IB_v1 extends Base_IB {

	public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public GSB002I_Z GSB002I;

	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
    }

    public class GSB002I_Z {
		public GSB002I GSB002I;
	}

	public class GSB002I {
		public String GSB002I_CLIENT_CODE;
	}

	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
    }

    public static GBgetTotalGroupExposureV3_Req_IB_v1 createDummyRequest() {
        String jsonString = '{"NBSAPDPI":{"NBSAPLI":{"NBNAPLI_CHANNEL":"GATEWAY","NBNAPLI_APPLICATION":"GATEWAY","NBNAPLI_TRACE":"Y"}},"NBSMSGI":{"NBSMSGI":{"NBNMSGI_MSG_LANGUAGE":"E","NBNMSGI_MSG_TARGET":"STD"}},"GSB002I":{"GSB002I":{"GSB002I_CLIENT_CODE":"SBSOUTP001"}}}';
        GBgetTotalGroupExposureV3_Req_IB_v1 requestBean = (GBgetTotalGroupExposureV3_Req_IB_v1)JSON.deserializeStrict(jsonString, GBgetTotalGroupExposureV3_Req_IB_v1.class);

        return requestBean;
    }
}