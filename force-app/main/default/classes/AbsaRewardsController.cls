/**
 * @description Absa Voucher reissuing controller class for W-009112
 * @Author Humbelani Denge
 * @Created Date 2021/05/11
 */
public class AbsaRewardsController {
    /**
     * @description method to get voucher challenges associated to client
     * @param cifKey
     * @return GetChallenges_Resp_IB_v1
     */
    @AuraEnabled
    public static GetChallenges_Resp_IB_v1 getAllChallenges(String cifKey) {
        return GetChallenges_IH_v1.GetChallenges(cifKey);
    }

    /**
     * @description method to get voucher challenge history associated to client
     * @param cifKey
     * @param idNumber
     * @return GetVoucherHistoryOfCustomer_Resp_IB_v1
     */
    @AuraEnabled
    public static GetVoucherHistoryOfCustomer_Resp_IB_v1 getVoucherHistoryOfCustomer(String cifKey, String idNumber) {
        return GetVoucherHistoryOfCustomer_IH_v1.GetVoucherHistoryOfCustomer(cifKey, idNumber);
    }
}