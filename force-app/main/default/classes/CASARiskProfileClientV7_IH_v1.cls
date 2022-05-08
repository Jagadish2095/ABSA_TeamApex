/**
 * @description       : CASARiskProfileClient Service Implementation
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-12
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @since   2021-02-12
**/


public class CASARiskProfileClientV7_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'CASARiskProfileClientV7_IH_v1';
    public static final String RISKPROFILE200 = 'Error : WQriskProfileClientV7Response Service Status Code : ';
	public static final String RISKPROFILENULLRESPONSE = 'Error : WQriskProfileClientV7Response has no value : ';
	public static final String RISKPROFILENULLRATING = 'Error : WQriskProfileClientV7Response Service msg : ';

	  /**
	 * @description       : CASARiskProfileClientV7
	 * @param requestBean
	 * @return string
	 **/
    public static string CASARiskProfileClientRiskStatus(CASARiskProfileClientV7_Req_IB_v1 requestBean) {
        CASARiskProfileClientV7_Resp_IB_v1 responseBean = CASARiskProfileClientV7(requestBean);
      return handleRiskProfilingResponse(responseBean);
  }

    /**
	 * @description       : CASARiskProfileClientV7
	 * @param requestBean
	 * @return CASARiskProfileClientV7_Resp_IB_v1
	 **/
    public static CASARiskProfileClientV7_Resp_IB_v1 CASARiskProfileClientV7(CASARiskProfileClientV7_Req_IB_v1 requestBean) {
          CASARiskProfileClientV7_Resp_IB_v1 responseBean = (CASARiskProfileClientV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, CASARiskProfileClientV7_Resp_IB_v1.class);
        return responseBean;
    }

    /**
	 * @description handleRiskProfilingResponse
	 * @param response
	 * @return String
	 */
	@TestVisible
	private static string handleRiskProfilingResponse(CASARiskProfileClientV7_Resp_IB_v1 response) {
		if (response.statusCode != 200) {
			return RISKPROFILE200 + response.statusCode;
		}
		if (response.WQriskProfileClientV7Response == null) {
			return RISKPROFILENULLRESPONSE + response.statusCode;
		}
		if (response.WQriskProfileClientV7Response.riskRating == null) {
			return RISKPROFILENULLRATING + response.WQriskProfileClientV7Response.msg;
		}
		return response.WQriskProfileClientV7Response.riskRating;
	}
}