/**
* Controller class for NewOnceOffPayment Lightning Component
*
* @author  Himani Joshi
* @version v1.0
* @since   2020-12-11

*/
public class NewOnceOffPaymentController {
     @AuraEnabled(Cacheable=false)
    public static Boolean deleteAccount(Id appProductId){
        Boolean deletion = false;
        Payment_Plan__c payPlan = new Payment_Plan__c();
        payPlan.Id = appProductId;
        
        try{
            delete payPlan;
            deletion = true;
        } catch(Exception exc){}
        
        return deletion;
    }

}