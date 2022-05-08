/*
 * Integration Handler class for addTBMobileBeneficiaries Service
 * @author Mashudu Raidimi
 * @created 2020-07-27
 */
public class addTBMobileBeneficiaries_IH_v1 {
    
    public static final String INTEGRATION_API_NAME = StringConstants.JITTERBIT_API_RB_STRING;
	public static final String INTEGRATION_SERVICE_NAME = 'addTBMobileBeneficiaries';
	public static final String SERVICE_NAME = 'addTBMobileBeneficiaries';
	public static final String METHOD_NAME = SERVICE_NAME + '_IH_v1.' + SERVICE_NAME;

    public static addTBMobileBeneficiaries_Resp_IB_v1 addTBMobileBeneficiaries(String cifKey,String cellNo , String ivrPaymentNo ,
                                                                     String description, String cellProvider){
        
        addTBMobileBeneficiaries_Req_IB_v1 requestBean = addTBMobileBeneficiaries_IU_v1.mapRequestFields(cifKey,cellNo ,ivrPaymentNo ,description, cellProvider);
        addTBMobileBeneficiaries_Resp_IB_v1 responseBean = (addTBMobileBeneficiaries_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, addTBMobileBeneficiaries_Resp_IB_v1.class);
        
        return responseBean;
    }

}