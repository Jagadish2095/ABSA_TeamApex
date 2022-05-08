/*
 * Response Integration Bean for MpsCreateMerchantPlanv1 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreateMerchantPlanv1_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
		public String serviceVersion;
	}

	public MPScreateMerchantPlanV1Response MPScreateMerchantPlanV1Response;

	public class MPScreateMerchantPlanV1Response {
		public Nbsapdpo nbsapdpo;
		public Zbp005o zbp005o;
	}

	public class Zbp005o {
		public String mrchAcctNbr;
		public String refNum;
		public String result;
	}
}