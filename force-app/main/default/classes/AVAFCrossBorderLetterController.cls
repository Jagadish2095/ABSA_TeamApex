/*
 * AVAFCrossBorderLetterController for AVAF Cross Border Letter
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-17
 * @W-006962
 */

public class AVAFCrossBorderLetterController {
    @AuraEnabled
    public static AVAFCrossBorderLetter_Resp_IB_v1 sendCrossBorderLetter(
        String accountNumber,
        String userEmail,
        String userIdNumber,
        String userName,
        String userSurname,
        String driverName,
        String driverIdNumber,
        String periodStart,
        String periodEnd
    ) {
        AVAFCrossBorderLetter_Resp_IB_v1 responseBean = AVAFCrossBorderLetter_IH_v1.crossBorderLetterRequest(
            accountNumber,
            userEmail,
            userIdNumber,
            userName,
            userSurname,
            driverName,
            driverIdNumber,
            periodStart,
            periodEnd
        );
        return responseBean;
    }
}