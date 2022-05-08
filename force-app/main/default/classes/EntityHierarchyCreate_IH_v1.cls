/**
 * @description       : Integration Handler class for EntityHierarchyCreate
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 09-11-2021
 * @last modified by  : Tawanda M.
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-28   Himanshu.Nimje@absa.africa   Initial Version
 **/
public class EntityHierarchyCreate_IH_v1 {
	/**
	 * @description Custom Exception
	 * @author Tawanda M. | 07-20-2021
	 **/
	public class entityHierarchyCreateException extends Exception{}

    public static final String INTEGRATION_SERVICE_NAME = 'EntityHierarchyCreate';
    
    /**
	 * @description Handler service call
	 * @author Himanshu.Nimje@absa.africa | 2021-10-28
	 * @return EntityHierarchyCreate_Resp_IB_v1
	 **/
	public static EntityHierarchyCreate_Resp_IB_v1 EntityHierarchyCreate(EntityHierarchyCreate_Req_IB_v1 requestBean, string ultimateEntityClientCode) {
        
		try{
			Map<String, String> customHeader = new Map<String, String>{'ENTITY_ID'=>ultimateEntityClientCode};
			EntityHierarchyCreate_Resp_IB_v1 responseBean = (EntityHierarchyCreate_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
				requestBean,
				null,
				customHeader,
				INTEGRATION_SERVICE_NAME,
				EntityHierarchyCreate_Resp_IB_v1.class
			);
	
			return responseBean;  
		}
		catch(Exception e){
			throw new entityHierarchyCreateException(e.getMessage());
		}      
	}
}