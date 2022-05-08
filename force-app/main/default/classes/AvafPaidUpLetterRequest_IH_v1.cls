/*
 * Integration Handler for paidUpLetterRequest Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-11-03
 */

public class AvafPaidUpLetterRequest_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'AvafPaidUpLetterRequest';

    public static AvafPaidUpLetterRequest_Resp_IB_v1 avafPaidUpLetter(
        String userIdNumber,
        String userEmail,
        String userName,
        String accountNumber,
        String userSurname
    ) {
        AvafPaidUpLetterRequest_Req_IB_v1 requestBean = AvafPaidUpLetterRequest_IU_v1.mapRequestFields(
            userIdNumber,
            userEmail,
            userName,
            accountNumber,
            userSurname
        );
        AvafPaidUpLetterRequest_Resp_IB_v1 responseBean = (AvafPaidUpLetterRequest_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
            requestBean,
            INTEGRATION_SERVICE_NAME,
            AvafPaidUpLetterRequest_Resp_IB_v1.class
        );
        return responseBean;
    }
}