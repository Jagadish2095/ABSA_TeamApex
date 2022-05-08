/*
 * Integration Utility class for ExperianGetXML2Report Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class XDSSubmitQuestions_IU_v1 {

    /* Creates a request bean
     * @return: XDSSubmitQuestions_Req_IB_v1 bean object
     */
    public static XDSSubmitQuestions_Req_IB_v1 mapRequestFields(XDSGetQuetions_Resp_IB_v1 getQuestionResponseBean) {
        XDSSubmitQuestions_Req_IB_v1 requestBean = new XDSSubmitQuestions_Req_IB_v1();
        requestBean.xdsSubmit = new XDSSubmitQuestions_Req_IB_v1.XDSSubmit();
        requestBean.xdsSubmit.submitQuestionsReq = getQuestionResponseBean;

        return requestBean;
    }
}