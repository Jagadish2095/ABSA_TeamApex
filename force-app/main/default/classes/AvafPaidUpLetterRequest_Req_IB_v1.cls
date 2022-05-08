/*
 * Request Integration Bean for paidUpLetterRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-02
 */

public class AvafPaidUpLetterRequest_Req_IB_v1 extends Base_IB {
    public String userIdNumber;
    public String userEmail;
    public String userName;
    public String accountNumber;
    public String userSurname;
    public String systemId;

    public static AvafPaidUpLetterRequest_Req_IB_v1 createDummyRequest() {
        AvafPaidUpLetterRequest_Req_IB_v1 requestBean = new AvafPaidUpLetterRequest_Req_IB_v1();
        requestBean.userIdNumber = '8309305930080';
        requestBean.userEmail = 'test@absa.africa';
        requestBean.userName = 'testName';
        requestBean.accountNumber = '00077075815';
        requestBean.userSurname = 'testSurname';
        requestBean.systemId = 'Salesforce';

        return requestBean;
    }
}