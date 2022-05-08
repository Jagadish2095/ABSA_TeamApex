/*
 * Integration Utility class for paidUpLetterRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-03
 */

public class AvafPaidUpLetterRequest_IU_v1 {
    public static AvafPaidUpLetterRequest_Req_IB_v1 mapRequestFields(
        string userIdNumber,
        String userEmail,
        string userName,
        string accountNumber,
        string userSurname
    ) {
        AvafPaidUpLetterRequest_Req_IB_v1 requestBean = new AvafPaidUpLetterRequest_Req_IB_v1();
        requestBean.userIdNumber = userIdNumber;
        requestBean.userEmail = userEmail;
        requestBean.userName = userName;
        requestBean.accountNumber = accountNumber;
        requestBean.userSurname = userSurname;
        requestBean.systemId = 'Salesforce';

        return requestBean;
    }
}