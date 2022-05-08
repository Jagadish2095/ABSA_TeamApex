/**
 * @description       : Integration Handler Bean for WQgetCASAStatusByRefNoV7 Service
 * @author            : Prudence Shirindzi
 * @last modified on  : 2021-08-13
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

public class WQgetCASAStatusByRefNoV7_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'WQgetCASAStatusByRefNoV7';
	public static final String CasaStatusNullResponse = 'Error : The getCASAStatusByRefNoV7 service returned an invalid response';

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-08-01
	 * @param casaRefNum
	 * @return string
	 **/
	public static string getCASAStatus(string casaRefNum) {
		WQgetCASAStatusByRefNoV7_Resp_IB_v1 response = WQgetCASAStatusByRefNoV7_IH_v1.WQgetCASAStatusByRefNo(casaRefNum);
		return handleGetCASAStatusResponse(response);
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-07-30
	 * @param casaRefNum
	 * @return WQgetCASAStatusByRefNoV7_Resp_IB_v1
	 **/
	public static WQgetCASAStatusByRefNoV7_Resp_IB_v1 WQgetCASAStatusByRefNo(string casaRefNum) {
		WQgetCASAStatusByRefNoV7_Req_IB_v1 request = WQgetCASAStatusByRefNoV7_Req_IB_v1.CreateInstance();
		request.WQgetCASAStatusByRefNoV7.wqp102i.refNo = casaRefNum;
		WQgetCASAStatusByRefNoV7_Resp_IB_v1 response = WQgetCASAStatusByRefNoV7_IH_v1.WQgetCASAStatusByRefNoV7(request);
		return response;
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-07-30
	 * @param requestBean
	 * @return WQgetCASAStatusByRefNoV7_Resp_IB_v1
	 **/
	public static WQgetCASAStatusByRefNoV7_Resp_IB_v1 WQgetCASAStatusByRefNoV7(WQgetCASAStatusByRefNoV7_Req_IB_v1 requestBean) {
		WQgetCASAStatusByRefNoV7_Resp_IB_v1 responseBean = (WQgetCASAStatusByRefNoV7_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			WQgetCASAStatusByRefNoV7_Resp_IB_v1.class
		);
		return responseBean;
	}

	/**
	 * @description handleGetCASAStatusResponse
	 * @param response
	 * @return String
	 */
	@TestVisible
	private static string handleGetCASAStatusResponse(WQgetCASAStatusByRefNoV7_Resp_IB_v1 response) {
		if (
			response == null ||
			response.WQgetCASAStatusByRefNoV7Response == null ||
			response.WQgetCASAStatusByRefNoV7Response.wqp102o == null ||
			response.WQgetCASAStatusByRefNoV7Response.wqp102o.msg == null
		) {
			return CasaStatusNullResponse;
		}
		if (response.WQgetCASAStatusByRefNoV7Response.wqp102o.msgNo == '0') {
			return response.WQgetCASAStatusByRefNoV7Response.wqp102o.msg;
		} else {
			return 'Error :' + response.WQgetCASAStatusByRefNoV7Response.wqp102o.msg;
		}
	}
}