/*
 * Integration Handler class for AvafGetPartner Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetPartner_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'AVAF Get Partner';

    public static AvafGetPartner_Resp_IB_v1 AvafGetPartner (String avafAccNum){
        AvafGetPartner_Req_IB_v1 requestBean = AvafGetPartner_IU_v1.mapRequestFields(avafAccNum);

        AvafGetPartner_Resp_IB_v1 responseBean = (AvafGetPartner_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafGetPartner_Resp_IB_v1.class);
        return responseBean;
    }
}