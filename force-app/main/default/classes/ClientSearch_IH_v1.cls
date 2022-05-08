/**
 * @description Integration Handler for ClientSearch Service
 * @author Koketso Mpshane
 * @created 2021-08-13
 */
public class ClientSearch_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'Client Search';
	/**
	 * @description ClientSearch method 
	 * @param idType
	 * @param idNumber
	 * @return ClientSearch_Resp_IB_v1
	 */
	public static ClientSearch_Resp_IB_v1 ClientSearch(Integer idType, String idNumber) {
		ClientSearch_Req_IB_v1 requestBean = ClientSearch_IU_v1.mapRequestFields(idType, idNumber);
		ClientSearch_Resp_IB_v1 responseBean = (ClientSearch_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ClientSearch_Resp_IB_v1.class
		);

		return responseBean;
	}

}