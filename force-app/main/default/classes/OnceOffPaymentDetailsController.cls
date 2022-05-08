/**
* Controller class for OnceOffPaymentDetails Lightning Component
*
* @author  Himani Joshi
* @version v1.0
* @since   2020-11-30

*/
public class OnceOffPaymentDetailsController {
    
    @AuraEnabled
    public static Payment_Plan__c getPayments(Id caseId){
      List<Case>caseList=new CasesSelector().selectByIdWithSLAInfo(caseId,1);
      Id appProductId=caseList[0].Application_Product_Id__c;
      String caseNumber=caseList[0].CaseNumber;
      Payment_Plan__c payPlan=new Payment_Plan__c();
      payPlan.Name=caseNumber;
      payPlan.Method__c='Debit Instruction';
      payPlan.Status__c='Submitted';
      payPlan.Application_Product__c=appProductId;
      insert payPlan;
      List<Payment_Plan__c>payPlanList=new PaymentPlansSelector().selectById(payPlan.id,1);
      Payment_Plan__c returnPaymentPlan=payPlanList[0];
      return returnPaymentPlan;
  
    }
    @AuraEnabled
    public static boolean saveClass( List<Payment_Plan__c> newAccounts){
        Boolean deletion = false;
        for(Payment_Plan__c var:newAccounts){
            system.debug('Id'+var.Id);
        }
        List<Payment_Plan__c>updatedProducts=new List<Payment_Plan__c>();
        for(Payment_Plan__c fin:newAccounts)
        {
          //Payment_Plan__c pp=[select Id,Once_Off_Payment_Required__c,Target_Account__c,Target_Account_Type__c,Target_Clearance_Code__c,Statement_Reference__c,Amount_Fullfillment__c from Payment_Plan__c where Id=:fin.Id ];
          List<Payment_Plan__c>paymentPlanList=new PaymentPlansSelector().selectById(fin.Id,1);
          Payment_Plan__c pp=paymentPlanList[0];
          pp.Once_Off_Payment_Required__c=fin.Once_Off_Payment_Required__c;
          pp.Target_Account__c=fin.Target_Account__c;
          pp.Target_Account_Type__c=fin.Target_Account_Type__c;
          pp.Target_Clearance_Code__c=fin.Target_Clearance_Code__c;
          pp.Statement_Reference__c=fin.Statement_Reference__c;
          pp.Amount_Fullfillment__c=fin.Amount_Fullfillment__c;




          updatedProducts.add(pp);
        }
        system.debug('updatedProducts'+json.serializePretty(updatedProducts));       
        try{
            deletion=true;
           update updatedProducts;
        }    
        catch(Exception exc){
            System.debug('The following exception has occurred: ' + exc.getMessage());
        }
        return deletion;
        
    }

}