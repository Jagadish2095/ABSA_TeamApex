/**
 * @description  Utility class for dsCheckDigitVerification Service
 * @author Kamil Rega
 * @created 2021-08-18
 */
public with sharing class dsCheckDigitVerificationV1_IU_v1 {
/**
* @description dsCheckDigitVerification
* @param  accountNumber
*@param  branchCode
*@param  accountType
*@param  transactionType
* @return dsCheckDigitVerificationV1_Resp_IB_v1
*/
    public static dsCheckDigitVerificationV1_Req_IB_v1 mapRequestFields(String accountNumber, String branchCode, String accountType, String transactionType) {
        dsCheckDigitVerificationV1_Req_IB_v1 requestBean = new dsCheckDigitVerificationV1_Req_IB_v1();
        requestBean.accountNumber = accountNumber;
        requestBean.branchCode = branchCode;
        requestBean.accountType= accountType;
        requestBean.transactionType= transactionType;
        return requestBean;
    }
}