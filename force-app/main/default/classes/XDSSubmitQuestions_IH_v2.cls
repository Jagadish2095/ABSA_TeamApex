/** 
 * @description Request Integration Bean for SubmitXDSQuestions Service
 * @author Sudhakar Reddy
 * @created 23 SEP 2021 
 */
public class XDSSubmitQuestions_IH_v2 { 

public static final String INTEGRATION_SERVICE_NAME = 'SubmitXDSQuestionsV2';

/**
 * @description xdsSubmitQuestions
 * @param requestBean
 * @return XDSSubmitQuestions_Resp_IB_v2
 */
public static XDSSubmitQuestions_Resp_IB_v2 xdsSubmitQuestions(XDSSubmitQuestions_Req_IB_v2 requestBean) {
    requestBean.processAction = 'Authenticate';
    Base_IB baseBean = (Base_IB) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, XDSSubmitQuestions_Resp_IB_v2.class);
    XDSSubmitQuestions_Resp_IB_v2 responseBean = (XDSSubmitQuestions_Resp_IB_v2)baseBean;

    return responseBean;
}

}