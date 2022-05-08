/**
 * Integration handler class for cqupdautooverdraftloadv2
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date January 2021
 */
public class Cqupdautooverdraftloadv2_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'cqupdautooverdraftloadv2';
    
    public static Cqupdautooverdraftloadv2_Resp_IB_v1 executeService(Cqupdautooverdraftloadv2_Req_IB_v1 requestBean){
        Cqupdautooverdraftloadv2_Resp_IB_v1 responseBean = (Cqupdautooverdraftloadv2_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, Cqupdautooverdraftloadv2_Resp_IB_v1.class);
        
        return responseBean;
    }
}