/*
 * Integration Handler for RiskProfileScore Service
 * @author Diksha Wasekar
 * @created 2020-09-08
 */

public class RiskProfileScore_IH_V1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Risk Profile Score';

    public static RiskProfileScore_Resp_IB_V1 RiskProfileScore(String questionOne, String questionTwo, String questionThree, String questionFour, String questionFive,String questionSix,String questionSeven) {
        RiskProfileScore_Req_IB_V1 requestBean = RiskProfileScore_IU_V1.mapRequestFields(questionOne,questionTwo,questionThree, questionFour,questionFive, questionSix, questionSeven);
        RiskProfileScore_Resp_IB_V1 responseBean = (RiskProfileScore_Resp_IB_V1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, RiskProfileScore_Resp_IB_V1.class);
        return responseBean;
    }
}