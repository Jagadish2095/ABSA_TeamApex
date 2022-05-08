/*
 * Integration Handler class for AvafChangeDebitOrder Service
 * @author Humbelani Denge
 * @created 2020-11-19
 */
public class AvafChangeDebitOrder_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AVAF Change Debit Order';

    public static AvafChangeDebitOrder_Resp_IB_v1 AvafChangeDebitOrder(String avafAccNum, String debitOrder, String collectionDay, String collectionStartDate, String collectionEndDate, String collectionAmount, String collectionBankId, String bankAccount) {
        AvafChangeDebitOrder_Req_IB_v1 requestBean = AvafChangeDebitOrder_IU_v1.mapRequestFields(avafAccNum, debitOrder, collectionDay, collectionStartDate, collectionEndDate, collectionAmount, collectionBankId, bankAccount);

        AvafChangeDebitOrder_Resp_IB_v1 responseBean = (AvafChangeDebitOrder_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, INTEGRATION_SERVICE_NAME, AvafChangeDebitOrder_Resp_IB_v1.class);
        return responseBean;
    }
}