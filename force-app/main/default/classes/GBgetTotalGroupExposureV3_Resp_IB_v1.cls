/**
 * Response Integration Bean for for GBgetTotalGroupExposureV3 Service
 * @author Englarmerdge Mongwe
 * @created 2020/12/29
 */
public class GBgetTotalGroupExposureV3_Resp_IB_v1 extends Base_IB {
    public GSB002O_Z GSB002O;
	public NBSAPDPO NBSAPDPO;
	public NBSMSGO3_Z NBSMSGO3;

	public class GSB002O_Z {
		public GSB002O GSB002O;
    }

	public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
    }

	public class NBSMSGO3_Z {
		public NBSMSGO3 NBSMSGO3;
	}

	public class GSB002O {
		public String GSB002O_WORST_ARMS_RISK;
		public Integer GSB002O_TOT_AVAF_EXP;
		public String GSB002O_WORST_ARMS_HOLD;
		public Integer GSB002O_TGOE;
		public Integer GSB002O_TGE;
		public Integer GSB002O_TGAE;
		public Integer GSB002O_TGBE;
	}

	public class NBSAPLO {
		public Integer NBNAPLO_REASON_CODE;
		public Integer NBNAPLO_RETURN_CODE;
		public String NBNAPLO_SERVICE_VERSION;
	}

	public class NBSMSGO3 {
		public Integer NBNMSGO3_NBR_USER_ERRS;
		public String NBNMSGO3_SYS_ERR_TXT;
		public Integer NBNMSGO3_NBR_USER_MSGS;
	}
}