/**
 * @description Integration Handler for Everyday Banking Charge Control Service
 * @author  Koketso Mpshane
 * @date    19/08/2021
 */
public class EBChargeControl_IH_V1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'EB Charge Control';
    /**
	 * @description ChargeControl method
     * @param chargeControlRecords
	 * @return EBChargeControl_Resp_IB_V1
	 */
    public static EBChargeControl_Resp_IB_V1 ChargeControl(List<Charge_Control__c> chargeControlRecords){
        
		EBChargeControl_Req_IB_V1 requestBean = EBChargeControl_IU_V1.mapRequestFields(chargeControlRecords);
		EBChargeControl_Resp_IB_V1 responseBean = (EBChargeControl_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			EBChargeControl_Resp_IB_V1.class
		);

		return responseBean;
	}

}