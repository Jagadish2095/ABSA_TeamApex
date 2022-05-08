/*
 * Request Integration Bean for settlementQuoteRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-02
 */

public class AvafSettlementQuote_Req_IB_v1 extends Base_IB {
    public String userIdNumber;
    public String userEmail;
    public String userName;
    public String accountNumber;
    public String userSurname;
    public String systemId;

    public static AvafSettlementQuote_Req_IB_v1 createDummyRequest() {
        AvafSettlementQuote_Req_IB_v1 requestBean = new AvafSettlementQuote_Req_IB_v1();

        requestBean.userIdNumber = '201010676710';
        requestBean.userEmail = 'test@absa.africa';
        requestBean.userName = 'testName';
        requestBean.accountNumber = '00075666239';
        requestBean.userSurname = 'TestSurname';
        requestBean.systemId = 'Salesforce';

        return requestBean;
    }
}