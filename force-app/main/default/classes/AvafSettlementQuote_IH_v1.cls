/*
 * Integration Handler for settlementQuoteRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-03
 */

public class AvafSettlementQuote_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AvafSettlementQuote';

    public static AvafSettlementQuote_Resp_IB_v1 settlementQuoteRequest(
        string userIdNumber,
        String userEmail,
        string userName,
        string accountNumber,
        string userSurname
    ) {
        AvafSettlementQuote_Req_IB_v1 requestBean = AvafSettlementQuote_IU_v1.mapRequestFields(
            userIdNumber,
            userEmail,
            userName,
            accountNumber,
            userSurname
        );
        AvafSettlementQuote_Resp_IB_v1 responseBean = (AvafSettlementQuote_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            INTEGRATION_SERVICE_NAME,
            AvafSettlementQuote_Resp_IB_v1.class
        );
        return responseBean;
    }
}