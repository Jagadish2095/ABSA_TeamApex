/*
 * Response Integration Bean for MPScreateMASSAccountV2 Service
 * @author Prashant Jain
 * @created 2020-05-08
 */

public class MPScreateMASSAccountV2_Resp_IB_v1 extends Base_IB {

    public String status;
    public Integer statusCode;
    public String message;

	public MPScreateMASSAccountV2Response MPScreateMASSAccountV2Response;

	public class Nbsapdpo {
		public String returnCode;
		public String reasonCode;
	}

	public class MPScreateMASSAccountV2Response {
		public Nbsapdpo nbsapdpo;
		public Zbp004o zbp004o;
	}

	public class Zbp004o {
		public String mrchAcctNbr;
		public String refNum;
		public String result;
	}
}