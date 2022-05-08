/**
 * @description       : eCasa Get analyst comments
 * @author            : Thomas Dry : ABSA (IQ Business)
 * @since   2021-03-23
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
**/

public class Wqgetanalystcommentsv7_IH_v2 {
    public static final String INTEGRATION_SERVICE_NAME = StringConstants.Wqgetanalystcommentsv7_STRING;
	public static final String ANALYSTCOMMENTSNULLRESPONSE = 'Error : Analyst response is not valid';


     /**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param casaRefNumber
    * @return String
    **/
    public static String GetAnalystCommentsByRefNumber(String casaRefNumber) {
        Wqgetanalystcommentsv7_Req_IB_v2 requestBean = Wqgetanalystcommentsv7_Req_IB_v2.CreateInstance();
        requestBean.WQgetAnalystCommentsV7Request.refNo = casaRefNumber;
        Wqgetanalystcommentsv7_Resp_IB_v2 responseBean =  Wqgetanalystcommentsv7_IH_v2.GetAnalystComments(requestBean);
        return handleGetAnalystCommentsReponse(responseBean);
    }

    /**
    * @description
    * @author PaulJohn.duRand@absa.africa | 2021-08-02
    * @param requestBean
    * @return Wqgetanalystcommentsv7_Resp_IB_v2
    **/
    public static Wqgetanalystcommentsv7_Resp_IB_v2 GetAnalystComments(Wqgetanalystcommentsv7_Req_IB_v2 requestBean) {
        Wqgetanalystcommentsv7_Resp_IB_v2 responseBean = (Wqgetanalystcommentsv7_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, Wqgetanalystcommentsv7_Resp_IB_v2.class);
        return responseBean;
    }

    /**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-07-29
	 * @param response
	 * @return string
	 **/
	@TestVisible
	private static string handleGetAnalystCommentsReponse(Wqgetanalystcommentsv7_Resp_IB_v2 response) {
		if (response == null || response.WQgetAnalystCommentsV7Response == null || response.WQgetAnalystCommentsV7Response.results == null) {
			return ANALYSTCOMMENTSNULLRESPONSE;
		}
		return response.WQgetAnalystCommentsV7Response.results.commentDesc;
	}
}