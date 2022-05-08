/*
 * Integration Handler for ExperianBusinessDetailsGet Service
 * @author Prashant Jain
 * @created 2019-12-05
 * @update 2020-09-10 updated to use new integration framework
 */

public class XDSSubmitQuestions_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'SubmitXDSQuestions';

    public static XDSSubmitQuestions_Resp_IB_v1 xdsSubmitQuestions(XDSGetQuetions_Resp_IB_v1 getQuestionResponseBean) {
        XDSSubmitQuestions_Req_IB_v1 requestBean = XDSSubmitQuestions_IU_v1.mapRequestFields(getQuestionResponseBean);
        XDSSubmitQuestions_Resp_IB_v1 responseBean = (XDSSubmitQuestions_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, XDSSubmitQuestions_Resp_IB_v1.class);
        return responseBean;
    }
}