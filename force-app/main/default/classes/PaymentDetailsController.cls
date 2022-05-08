/**
* Controller class for PaymentDetails Lightning Component
*
* @author  Himani Joshi
* @version v1.0
* @since   2020-12-19

*/
public class PaymentDetailsController {
    @AuraEnabled
    public static List<Payment_Plan__c> getPaymentDetails(Id caseId){
        List<Case>caseList=new CasesSelector().selectByIdWithSLAInfo(caseId,1);
        Id appProductId;
        String caseNumber;
        if(caseList != null && caseList.size() > 0){
            appProductId=caseList[0].Application_Product_Id__c;
            caseNumber=caseList[0].CaseNumber;
        
        List<Payment_Plan__c>paymentList=new PaymentPlansSelector().selectByAppProductAndCaseId(appProductId,caseNumber);
        if(paymentList != null && paymentList.size() > 0){
            return paymentList;
        }
        }
        
            return null;
        
    }
}