/**
	 * @description Method: UpdateLeadDetails IH
	 * @author: Mbuyiseni Mbhokane(Absa)
	 * @created date: 28/04/2021
     * @lastModifiedBy : Monde Masiza
     * @lastModified : 05/14/2021
* */

public class UpdateLeadDetails_IH_v1 {

    
    public static final String INTEGRATION_SERVICE_NAME = 'updateLeadDetails';

    /**
	    * @description Method: method that return the response
	    * @param requestBean
        * @return response Bean
	 */
    public static UpdateLeadDetails_Resp_IB_v1 updateLeadDetails(UpdateLeadDetails_Req_IB_v1 requestBean){
        UpdateLeadDetails_Resp_IB_v1 responseBean = (UpdateLeadDetails_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, UpdateLeadDetails_Resp_IB_v1.class);
        
        return responseBean;
    }
}