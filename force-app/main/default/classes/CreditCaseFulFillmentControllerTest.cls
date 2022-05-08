@isTest
public class CreditCaseFulFillmentControllerTest {
    
   public  static testMethod void testAppCredFields(){
         String productname = 'Overdraft';
        List<String> fieldnames = CreditCaseFulfillmentController.getProductFields(productname);
        system.assertNotEquals(null, fieldnames);
        system.assert(fieldnames.size()>0);
    }
}