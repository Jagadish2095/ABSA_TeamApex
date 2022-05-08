/*
 * Response Integration Bean for MpsCreatePoshMerchantv3 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MpsCreatePoshMerchantv3_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
	}

	public MPScreatePOSHMerchantV3Response MPScreatePOSHMerchantV3Response;

	public class MPScreatePOSHMerchantV3Response {
		public Nbsapdpo nbsapdpo;
		public Zbp006o zbp006o;
	}

	public class Zbp006o {
		public String mrchAcctNbr;
		public String refNum;
		public String result;
	}
}