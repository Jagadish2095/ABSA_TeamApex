/*
 * AVAFPreValidAndSendLetterController for Pre Validation and Letter Sending
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-17
 * @W-006962
 */

public class AVAFPreValidAndSendLetterController {
    @AuraEnabled
    public static AVAFPreValidationService_Resp_IB_v1 preValidateAccountInfo(Integer accountNumber) {
        AVAFPreValidationService_Resp_IB_v1 responseBean = AVAFPreValidationService_IH_v1.preValidationService(accountNumber);
        return responseBean;
    }

    @AuraEnabled
    public static String caseStatusUpdate(String caseId){
        Case caseObj = new Case(Id=caseId, Status = 'Closed', Bypass_Validation_Rules__c = true);
        try{
            Update caseObj;
        }catch(exception e){
            return e.getMessage();
        }
        return 'success';
    }
}