/**
 * @description Integration Handler class for dsCheckDigitVerificationV1_IH_v1
 * @author Kamil Rega
 * @created 2021-08-18
 */
public with sharing class dsCheckDigitVerificationV1_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'Check Digit Verification V1';
/**
* @description dsCheckDigitVerification
* @param  accountNumber
*@param  branchCode
*@param  accountType
*@param  transactionType
* @return dsCheckDigitVerificationV1_Resp_IB_v1
*/
    public static dsCheckDigitVerificationV1_Resp_IB_v1 dsCheckDigitVerification(String accountNumber, String branchCode, String accountType, String transactionType) {
        dsCheckDigitVerificationV1_Req_IB_v1 requestBean = dsCheckDigitVerificationV1_IU_v1.mapRequestFields(accountNumber,branchCode,accountType,transactionType);
        dsCheckDigitVerificationV1_Resp_IB_v1 responseBean = ( dsCheckDigitVerificationV1_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME,  dsCheckDigitVerificationV1_Resp_IB_v1.class);

        return responseBean;
    }
}