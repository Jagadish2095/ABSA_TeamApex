/*
 * Integration Utilities for SAPGetList Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 */
public class AvafVapsGetList_IU_v1 extends Base_IB {
    public static AvafVapsGetList_Req_IB_v1 mapRequestFields(String accountNumber) {

        AvafVapsGetList_Req_IB_v1 requestBean = new AvafVapsGetList_Req_IB_v1();
        AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS bapiSfVaps = new AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS();
        List<AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS> bapiSfVapsList = new List<AvafVapsGetList_Req_IB_v1.BAPI_SF_VAPS>();
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

        bapiSfVaps.I_Account = accountNumber;
        bapiSfVaps.I_USER = currentUser.AB_Number__c;

        bapiSfVapsList.add(bapiSfVaps);
        requestBean.BAPI_SF_VAPS_LIST = bapiSfVapsList;

        return requestBean;
    }
}