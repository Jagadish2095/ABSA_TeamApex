/**
 *@description Integration Handler for MBgetPaymentDetailV3 Service
 * @author Chandra Bhushan
 * @created 2021-03-20

 * @updated 2021-04-09
 */

public class MBgetPaymentDetailV3_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'MB Get Payment Detail V3';
  /**
* @description wrapper class MBgetPaymentDetailV3Response
* @param uniqueEft
* @return MBgetPaymentDetailV3_Resp_IB_v1
*/
    public static MBgetPaymentDetailV3_Resp_IB_v1 MBgetPaymentDetailV3(String uniqueEft) {
        MBgetPaymentDetailV3_Req_IB_v1 requestBean = MBgetPaymentDetailV3_IU_v1.mapRequestFields(uniqueEft);

		MBgetPaymentDetailV3_Resp_IB_v1 responseBean = (MBgetPaymentDetailV3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			MBgetPaymentDetailV3_Resp_IB_v1.class
		);


        return responseBean;
    }
}