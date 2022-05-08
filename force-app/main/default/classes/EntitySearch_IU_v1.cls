/**
 * @description       :
 * @author            : ravi.bodepalli@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Tawanda M.
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-25   rav.bodepalli@absa.africa    Initial Version
 **/
public class EntitySearch_IU_v1 {
	/**
	 * @description Map Request with Class
	 * @author rav.bodepalli@absa.africa | 2021-10-25
	 * @param accountId
	 * @return EntitySearch_Req_IB_v1
	 **/
	public static EntitySearch_Req_IB_v1 mapRequestFields(String accountId) {
		EntitySearch_Req_IB_v1 requestBean = new EntitySearch_Req_IB_v1();
		requestBean.payLoad = new EntitySearch_Req_IB_v1.payLoad();	
        requestBean.payLoad.SystemId = accountId;   
		return requestBean;
	}
}