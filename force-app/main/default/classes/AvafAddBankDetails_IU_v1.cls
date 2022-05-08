/*
 * Integration Handler class for AvafAddBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafAddBankDetails_IU_v1 {
    public static AvafAddBankDetails_Req_IB_v1 mapRequestFields(String partnerNumber, String accName, String accHolder, String bankRef, String bankAcc, String ctrlKey, String bankKey, String bankCtry) {
        AvafAddBankDetails_Req_IB_v1 requestBean = new AvafAddBankDetails_Req_IB_v1();
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD = new AvafAddBankDetails_Req_IB_v1.BAPI_BUPA_BANKDETAIL_ADD();

        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BUSINESSPARTNER = partnerNumber;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKACCOUNTNAME = accName;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.ACCOUNTHOLDER = accHolder;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_REF = bankRef;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_ACCT = bankAcc;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.CTRL_KEY = ctrlKey;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_KEY = bankKey;
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_CTRY = bankCtry;
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        requestBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.I_USER = currentUser.AB_Number__c;

        return requestBean;
    }
}