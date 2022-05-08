/**
* @description Integration Handler for BAPISFAccntDescr Service
* @author  Koketso Mpshane
* @date    17/05/2021
*/
public class BAPISFAccntDescr_IH_v1 {

    public static final String INTEGRATION_SERVICE_NAME = 'BAPI SF Account Descriptions';
    /**
	 * @description BAPISFAccntDescr method
     * @param accountList
     * @param iUser
     * @return BAPISFAccntDescr_Resp_IB_v1
 	 */
    public static BAPISFAccntDescr_Resp_IB_v1 BAPISFAccntDescr(List<String> accountList, String iUser) {
        BAPISFAccntDescr_Req_IB_v1 requestBean = BAPISFAccntDescr_IU_v1.mapRequestFields(accountList, iUser);
        BAPISFAccntDescr_Resp_IB_v1 responseBean = (BAPISFAccntDescr_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, BAPISFAccntDescr_Resp_IB_v1.class);

        return responseBean;
    }

}