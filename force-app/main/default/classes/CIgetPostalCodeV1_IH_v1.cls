/*
 * Integration Handler Bean for CIgetPostalCodeV1 Service
 * @author Prudence Shirindzi & Updated by Satya Boyenepalli
 * @created 2020-10-05 & 2020-10-23
 */
public class CIgetPostalCodeV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'CIgetPostalCodeV1';
    
    public static  CIgetPostalCodeV1_Resp_IB_v1 CIgetPostalCodeV1(CIgetPostalCodeV1_Req_IB_v1 requestBean){
        CIgetPostalCodeV1_Resp_IB_v1 responseBean = ( CIgetPostalCodeV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  CIgetPostalCodeV1_Resp_IB_v1.class);
        return responseBean;
    }
}