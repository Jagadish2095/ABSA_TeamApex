/**
 * @description Integration Handler for MBlistInstructionsPerSourceAccV1 Service
 * @author Chandra Bhushan
 * @created 2021-03-12
 */

public class MBlistInstPerSourceAccV1_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'MB List Instructions Per Source Acc V1';

	/**
	 * @description MBlistInstructionsPerSourceAccV1 method to get beneficiary data
	 * @param cifKey
     * @param sourceAccount
     * @param instrType
	 * @return MBlistInstPerSourceAccV1_Resp_IB_v1
	 */
	public static MBlistInstPerSourceAccV1_Resp_IB_v1 MBlistInstructionsPerSourceAccV1(String cifKey, String sourceAccount, String instrType) {
		MBlistInstPerSourceAccV1_Req_IB_v1 requestBean = MBlistInstPerSourceAccV1_IU_v1.mapRequestFields(cifKey, sourceAccount, instrType);
		MBlistInstPerSourceAccV1_Resp_IB_v1 responseBean = (MBlistInstPerSourceAccV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			MBlistInstPerSourceAccV1_Resp_IB_v1.class
		);

		return responseBean;
	}
}