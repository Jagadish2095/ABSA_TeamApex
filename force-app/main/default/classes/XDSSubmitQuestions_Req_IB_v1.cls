/*
 * Request Integration Bean for SubmitXDSQuestions Service
 * @author Prashant Jain
 * @created 2020-11-13
 */

public class XDSSubmitQuestions_Req_IB_v1 extends Base_IB {
    public XDSSubmit xdsSubmit;

    public class XDSSubmit {
        public XDSGetQuetions_Resp_IB_v1 submitQuestionsReq;
    }
}