/**
 * ECM_LogoutResult_IB_V1
 */
public class ECM_LogoutResult_IB_V1 {
    /**
     * Get status
     * @return status
     */
    public String status { get; set; }

    /**
     * Get detail
     * @return detail
     */
    public String detail { get; set; }

    public static ECM_LogoutResult_IB_V1 getExample() {
        ECM_LogoutResult_IB_V1 logoutResult = new ECM_LogoutResult_IB_V1();
        logoutResult.status = 'aeiou';
        logoutResult.detail = 'aeiou';
        return logoutResult;
    }
}