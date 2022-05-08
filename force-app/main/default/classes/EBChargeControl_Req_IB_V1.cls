/**
 * @description Request Integration Bean for Everyday Banking Charge Control Service
 * @author  Koketso Mpshane
 * @date    19/08/2021
 */
public class EBChargeControl_Req_IB_V1 extends Base_IB {

    public String totalSize;
    public String totalFees;
	public Boolean done;
	public List<Records> records;
	
	/**
 	* @description Records wrapper class
 	*/
	public class Records {
		public String Id;
        public String ChargeID;
		public String ChargeMonth;
		public String ChargeAccountNumber;
		public String ChargeAmount;
		public String ChargeProcessCode;
		public String ChargeProcessDate;
	}
}