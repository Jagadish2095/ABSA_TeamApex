/*
 * Integration Handler for LAUpdateBankingDetailsV3 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */
public class LAUpdateBankingDetailsV3_IH_v1 {
    public static final String INTEGRATION_SERVICE_NAME = 'LA Update Banking Details V3';

    public static LAUpdateBankingDetailsV3_Resp_IB_v1 LAUpdateBankingDetailsV3(String clientCode, String policyNumber, String bankName, String sourceOfIncome, String sourceOfFund, String bankAccountNo, String accountHolderName, String collectionDay, String frequency, String accountType, String branchCode, String amount) {
        LAUpdateBankingDetailsV3_Req_IB_v1 requestBean = LAupdateBankingDetailsV3_IU_v1.mapRequestFields(clientCode, policyNumber, bankName, sourceOfIncome, sourceOfFund, bankAccountNo, accountHolderName, collectionDay, frequency, accountType, branchCode, amount);
        LAUpdateBankingDetailsV3_Resp_IB_v1 responseBean = (LAUpdateBankingDetailsV3_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, LAUpdateBankingDetailsV3_Resp_IB_v1.class);
        return responseBean;
    }
}