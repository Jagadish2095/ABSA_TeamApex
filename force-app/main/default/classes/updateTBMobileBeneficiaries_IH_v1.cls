/*
 * Integration Handler class for updateTBMobileBeneficiaries Service
 * @author Mashudu Raidimi
 * @created 2020-07-27
 */
public class updateTBMobileBeneficiaries_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'updateTBMobileBeneficiaries';
	public static final String SERVICE_NAME = 'updateTBMobileBeneficiaries';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static updateTBMobileBeneficiaries_Resp_IB_v1 updateTBMobileBeneficiaries(String cifKey,String cellNo , String ivrPaymentNo ,
                                                                     String description, String cellProvider){
        
        updateTBMobileBeneficiaries_Req_IB_v1 requestBean = updateTBMobileBeneficiaries_IU_v1.mapRequestFields(cifKey,cellNo ,ivrPaymentNo ,description, cellProvider);
        updateTBMobileBeneficiaries_Resp_IB_v1 responseBean = (updateTBMobileBeneficiaries_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null,  INTEGRATION_SERVICE_NAME,  updateTBMobileBeneficiaries_Resp_IB_v1.class);
        
        return responseBean;
    }

}