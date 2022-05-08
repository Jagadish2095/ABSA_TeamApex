/**
 * @description       : CASAGeneratedocumentsV7 Service
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @since   2021-02-12
 **/

public class CASAGeneratedocumentsV7_IH_v1 {
	public static final String GENDOCSNULLRESPONSE = 'Error : CASAGeneratedocumentsV7 Null Response';
	public static final String GENDOCSNULLVERSION = 'Error : CASAGeneratedocumentsV7 Version number was not returned ';
	public static final String INTEGRATION_SERVICE_NAME = 'Generatedocumentsv7';

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-03
	 * @param requestBean
	 * @return CASAGeneratedocumentsV7_Resp_IB_v1
	 **/
	public static CASAGeneratedocumentsV7_Resp_IB_v1 CASAGeneratedocumentsV7(CASAGeneratedocumentsV7_Req_IB_v1 requestBean) {
		CASAGeneratedocumentsV7_Resp_IB_v1 responseBean = (CASAGeneratedocumentsV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			CASAGeneratedocumentsV7_Resp_IB_v1.class
		);
		return responseBean;
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-03
	 * @param casaRef
	 * @return String
	 **/
	@TestVisible
	public static String CASAGeneratedocumentsByRefNumber(String casaRef) {
		CASAGeneratedocumentsV7_Req_IB_v1 requestBean = CASAGeneratedocumentsV7_Req_IB_v1.GetInstance();
		requestBean.GetDocsRequest.RefNumber = casaRef;
		CASAGeneratedocumentsV7_Resp_IB_v1 response = CASAGeneratedocumentsV7(requestBean);
		return handleGenerateDocsResponse(response);
	}

	/**
	 * @description handleGenerateDocsResponse
	 * @param response
	 * @return String
	 */
	@TestVisible
	public static String handleGenerateDocsResponse(CASAGeneratedocumentsV7_Resp_IB_v1 response) {
		if ((response == null || response.statusCode != 200 || response.Envelope == null || response.Envelope.Body == null || response.Envelope.Body.GetDocsResponse == null)) {
			return GENDOCSNULLRESPONSE;
		}
		if (response.Envelope.Body.GetDocsResponse.VersionNo == null) {
			return GENDOCSNULLVERSION + response.Envelope.Body.GetDocsResponse.msg;
		}
		return response.Envelope.Body.GetDocsResponse.VersionNo;
	}
}