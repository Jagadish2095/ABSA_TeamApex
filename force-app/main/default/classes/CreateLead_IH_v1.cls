/**
* 
* @description Apex/Integration Handler class for createLead service
* @author  Monde Masiza 
* @since   2021-03-29
* @param requestBean
*
**/


public class CreateLead_IH_v1 {
   
    public static final String INTEGRATION_SERVICE_NAME = 'createLead';
    /**
     * @description Method: create lead request bean 
     * @param requestBean
     * @return responseBean
     * 
     */
     public static CreateLead_Resp_IB_v1 createLead(CreateLead_Req_IB_v1 requestBean) {
        CreateLead_Resp_IB_v1 responseBean = (CreateLead_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, CreateLead_Resp_IB_v1.class);
        System.debug('responseBean : '+ responseBean);
        return responseBean;
    }
}