/**
 * @description Controller class for the AVAFAuditCertificate component
 * @author Bhanumurty Rayala
 * @created 2021-06-29
 */
public class AVAFAuditCertificateController {
/**
 * @description method to call the AVAFStatementRequest service framework
 * @param avafAccNum
 * @param email
 * @param dateOutput
 * @return AVAFStatementRequest_Resp_IB_v1
 */
    @AuraEnabled
    public static AVAFStatementRequest_Resp_IB_v1 auditCertificateRequest(String avafAccNum, String email, String dateOutput){
        AVAFStatementRequest_Resp_IB_v1 response = AVAFStatementRequest_IH_v1.AVAFStatementRequest(avafAccNum, email, Integer.valueOf(dateOutput), 'T');
        return response;
    }
}