/**
 * @description       :
 * @author            : ravi.bodepalli@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Tawanda M.
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-10-25   ravi.bodepalli@absa.africa    Initial Version
 **/

public class EntitySearch_Req_IB_v1 extends Base_IB{
	
	 public payLoad payLoad;
	
	/**
	 * @description Structure Element
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
	public class payLoad {
        public String SystemId;	//Account Id(0011q00000qPTaFAAW) need to pass here as SystemId
	}
    
    /**
    * @description 
    * @author Ravi B. | 2021-11-09 
    * @return EntitySearch_Req_IB_v1 
    **/
    public static EntitySearch_Req_IB_v1 createDummyRequest() {
        EntitySearch_Req_IB_v1 requestBean = new EntitySearch_Req_IB_v1();
        List<String> str = new List<String>{'XYZ'};
		requestBean.payLoad = new EntitySearch_Req_IB_v1.payLoad();	
        requestBean.payLoad.SystemId = str[0];   
    return requestBean;
    }
}