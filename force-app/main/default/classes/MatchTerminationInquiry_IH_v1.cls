/*
 * Integration Handler for MatchTerminationInquiry Service
 * @author Prashant Jain
 * @created 2020-05-22
 */

public class MatchTerminationInquiry_IH_v1 {

	public static final String INTEGRATION_SERVICE_NAME = 'Match Termination Inquiry';

    public static MatchTerminationInquiry_Resp_IB_v1 MatchTerminationInquiry(MatchTerminationInquiry_Req_IB_v1 requestBean) {
        MatchTerminationInquiry_Resp_IB_v1 responseBean = (MatchTerminationInquiry_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, MatchTerminationInquiry_Resp_IB_v1.class);
        return responseBean;
    }
}