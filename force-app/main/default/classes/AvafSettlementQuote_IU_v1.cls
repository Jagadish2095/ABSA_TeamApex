/*
 * Integration Utility class for settlementQuoteRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-03
 */

public class AvafSettlementQuote_IU_v1 {
    public static AvafSettlementQuote_Req_IB_v1 mapRequestFields(
        string userIdNumber,
        String userEmail,
        string userName,
        string accountNumber,
        string userSurname
    ) {
        AvafSettlementQuote_Req_IB_v1 requestBean = new AvafSettlementQuote_Req_IB_v1();
        requestBean.userIdNumber = userIdNumber;
        requestBean.userEmail = userEmail;
        requestBean.userName = userName;
        requestBean.accountNumber = accountNumber;
        requestBean.userSurname = userSurname;
        requestBean.systemId = 'Salesforce';

        return requestBean;
    }
}