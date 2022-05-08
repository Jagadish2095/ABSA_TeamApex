/*
* Integration Bean call for NewMemberRegistration Service
* @author Khaliq Abdul
* @created 2020-11-02
*/
public class NewMemberRegistration_IH_v1 {

     public static final String INTEGRATION_SERVICE_NAME = 'NewMemberRegistration';

    public static NewMemberRegistration_Resp_IB_v1 NewMemberRegistration(NewMemberRegistration_Req_IB_v1 requestBean) {
        NewMemberRegistration_Resp_IB_v1 responseBean = (NewMemberRegistration_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, NewMemberRegistration_Resp_IB_v1.class);
        return responseBean;
    }
}