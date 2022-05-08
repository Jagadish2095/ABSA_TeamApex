/**
 * @description       :
 * @author            : ravi.bodepalli@absa.africa
 * @last modified on  : 09-11-2021
 * @last modified by  : Tawanda M.
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-25   rav.bodepalli@absa.africa    Initial Version
 **/

public class EntitySearch_IH_v1  {
		/**
	 * @description Custom Exception
	 * @author Tawanda M. | 07-20-2021
	 **/
	public class entitySearchException extends Exception{}

	public static final String INTEGRATION_SERVICE_NAME = 'EntitySearchService';

	/**
	 * @description Handler service call
	 * @author ravi.bodepalli@absa.africa | 2021-10-25 
	 * @param accountId
	 * @return EntitySearch_Resp_IB_v1
	 **/
	public static EntitySearch_Resp_IB_v1 entitySearch(String accountId) {
		try{
			EntitySearch_Req_IB_v1 requestBean = EntitySearch_IU_v1.mapRequestFields(accountId);		
        
			EntitySearch_Resp_IB_v1 responseBean = (EntitySearch_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
				requestBean,
				null,             
				INTEGRATION_SERVICE_NAME,
				EntitySearch_Resp_IB_v1.class
			);
			return responseBean;
		}
		catch(Exception e){
			throw new entitySearchException(e.getMessage());
		}
	}
}