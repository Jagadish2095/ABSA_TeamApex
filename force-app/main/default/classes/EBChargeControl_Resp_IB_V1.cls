/**
 * @description Response Integration Bean for Everyday Banking Charge Control Service
 * @author  Koketso Mpshane
 * @date    19/08/2021
 */
public class EBChargeControl_Resp_IB_V1 extends Base_IB {

    public Integer statusCode;
	public String message;
	public String status;
    public String Process;
	public String response_Status;

    /**
	 * @description Method to substitute the service response variable with class variable
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('Status', 'response_Status');
	}

}