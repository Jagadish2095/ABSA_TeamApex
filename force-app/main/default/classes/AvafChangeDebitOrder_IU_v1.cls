/*
 * Integration Handler class for AvafChangeDebitOrder Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafChangeDebitOrder_IU_v1 {
    public static AvafChangeDebitOrder_Req_IB_v1 mapRequestFields(String avafAccNum, String debitOrder, String collectionDay, String collectionStartDate, String collectionEndDate, String collectionAmount, String collectionBankId, String bankAccount) {
        AvafChangeDebitOrder_Req_IB_v1 requestBean = new AvafChangeDebitOrder_Req_IB_v1();
        requestBean.BAPI_SF_DO_CHG = new List<AvafChangeDebitOrder_Req_IB_v1.BAPI_SF_DO_CHG>();
        AvafChangeDebitOrder_Req_IB_v1.BAPI_SF_DO_CHG BSDC = new AvafChangeDebitOrder_Req_IB_v1.BAPI_SF_DO_CHG();
        BSDC.ZDEBIT_ORDER = debitOrder;
        BSDC.ZCOLDAY = collectionDay;
        BSDC.ZCOLSTARTDATE = collectionStartDate;
        BSDC.ZCOLENDDATE = collectionEndDate;
        BSDC.ZCOLAMOUNT = collectionAmount;
        BSDC.ZCOLBANKID = collectionBankId;
        BSDC.ZBANK_ACC = bankAccount;
        BSDC.ZSTATUS = 'ACTIVE';
        requestBean.I_ACTION = 'A';
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        requestBean.I_USER = currentUser.AB_Number__c;
        requestBean.I_ACCOUNT = avafAccNum.replaceFirst('^0+', '').leftPad(11, '0');
        requestBean.BAPI_SF_DO_CHG.add(BSDC);

        return requestBean;
    }
}