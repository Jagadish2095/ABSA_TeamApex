/**
 * @description Request Integration Bean for BAPISFAccntDescr Service
 * @author  Koketso Mpshane
 * @date    17/05/2021
 */
public class BAPISFAccntDescr_Req_IB_v1 extends Base_IB {

    public BAPI_SF_ACCNT_DESCR BAPI_SF_ACCNT_DESCR;
    /**
	 * @description ACCOUNT_REQ class
 	 */
	public class ACCOUNT_REQ {
		public String ACCOUNT;
		public String I_USER;
	}
    /**
	 * @description BAPI_SF_ACCNT_DESCR class
 	 */
	public class BAPI_SF_ACCNT_DESCR {
		public List<ACCOUNT_REQ> ACCOUNT_REQ;
	}

}