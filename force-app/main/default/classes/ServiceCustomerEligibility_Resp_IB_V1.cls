/**
 * @description Response Integration Bean for ServiceCustomerEligibility Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 30/04/2021
 */
public class ServiceCustomerEligibility_Resp_IB_V1 extends Base_IB {
	public Integer statusCode;
	public String message;
	public String status;

	public String ActionCode;
	public String response_Status;
	public String STAN;
	public String LocalTxnDatTime;
	public Acq Acq;
	public String RetrievalReferenceNumber;
	/**
	 * @description Acquiring Inst ID class
	 */
	public class Acq {
		public String InstIdCde;
	}

	/**
	 * @description Method to substitute the service response variable with class variable
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('Status', 'response_Status');
	}
}