/**
 * @description       : ROA Question Answer Service
 * @author            : Jabulani Mashia
 * @last modified on  : 2021-11-03
 * @last modified by  : André Pietersen (IQ Business)
**/
public class ROAQuestionAnswerService_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'ROAQuestionAnswerService';

    /**
    * @description ROAQuestionAnswerService
    * @author Jabulani Mashia | 2020-11-11
    * @return ROAQuestionAnswerService_Resp_IB_v1
    **/
    public static ROAQuestionAnswerService_Resp_IB_v1 ROAQuestionAnswerService() {
        ROAQuestionAnswerService_Resp_IB_v1 responseBean = (ROAQuestionAnswerService_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(null, null, INTEGRATION_SERVICE_NAME, ROAQuestionAnswerService_Resp_IB_v1.class);
        return responseBean;
    }

    /**
    * @description getROAQuestionAnswerBody
    * @author André Pietersen (IQ Business) | 2020-11-11
    * @return String
    **/
    public static String getROAQuestionAnswerBody() {
        Sys_Utilities_Integration_StringBody_IB responseBean = (Sys_Utilities_Integration_StringBody_IB) Sys_Utilities_Integration.integrationServiceCall(null, null, INTEGRATION_SERVICE_NAME, Sys_Utilities_Integration_StringBody_IB.class);
        return responseBean.body;
    }
}