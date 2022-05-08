/*
 * Integration Utility class for AvafDebitOrderDetails Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
public class AvafGetDebitOrderDetails_IU_v1 {

    public static AvafGetDebitOrderDetails_Req_IB_v1 mapRequestFields(String avafAccNum){
        AvafGetDebitOrderDetails_Req_IB_v1 requestBean = new AvafGetDebitOrderDetails_Req_IB_v1();
        List<AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS> doDetailsList = new List<AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS>();

        AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS doDetailsObj = new AvafGetDebitOrderDetails_Req_IB_v1.BAPI_SF_DO_DETAILS();
        doDetailsObj.I_ACCOUNT = avafAccNum.replaceFirst('^0+','').leftPad(11, '0');
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        doDetailsObj.I_USER = currentUser.AB_Number__c;
        doDetailsList.add(doDetailsObj);

        requestBean.BAPI_SF_DO_DETAILS = doDetailsList;
        return requestBean;
    }
}