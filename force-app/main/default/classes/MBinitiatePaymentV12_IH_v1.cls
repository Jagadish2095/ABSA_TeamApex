/**
 * Integration Handler for MBinitiatePaymentV12 Service
 * @author Almas Aleem
 * @created 2020-12-15
 * @updated 2022-03-11 Koketso Mpshane
 */
public class MBinitiatePaymentV12_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Mb Initiate Payment V12';

    public static MBinitiatePaymentV12_Resp_IB_v1 mbInitiatePaymentV12(MBinitiatePaymentV12_Req_IB_v1 requestBean) {
        MBinitiatePaymentV12_Resp_IB_v1 responseBean = (MBinitiatePaymentV12_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MBinitiatePaymentV12_Resp_IB_v1.class);
        return responseBean;
    }
    
    /**
	 * @description initiatePayment method
	 * @param mbInitiatePaymentParamsMap
	 * @return MBinitiatePaymentV12_Resp_IB_v1
	 */
    public static MBinitiatePaymentV12_Resp_IB_v1 initiatePayment(Map<String, String> initiatePaymentParamsMap) {
        
    		MBinitiatePaymentV12_Req_IB_V1 requestBean = MBinitiatePaymentV12_IU_V1.mapRequestFields(initiatePaymentParamsMap);
                                                                                         
			MBinitiatePaymentV12_Resp_IB_V1 responseBean = (MBinitiatePaymentV12_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MBinitiatePaymentV12_Resp_IB_V1.class);

			return responseBean;
    }
    
}