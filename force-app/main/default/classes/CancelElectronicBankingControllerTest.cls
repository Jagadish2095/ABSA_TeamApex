/* Lightning cmp controller for Cancel Electronic Banking (Telephonic) 
 * Author: Lulu Rankwe
 * Date :  05/05/2020 
 */
@isTest
public class CancelElectronicBankingControllerTest {

    
    
    @isTest 
    public static void testCancelServicePositive(){      
        Test.setMock(HttpCalloutMock.class, new IBCancelServicev1Mock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.IBCANCELSERVICE});

        Test.startTest();  
        IBCancelServicev1_Res_IB_v1 response = new IBCancelServicev1_Res_IB_v1();
        String resp = CancelElectronicBankingController.cancelService('4048276744','4','Testing','N','N','N','N','N','N','Y');
        system.assertNotEquals(null, resp); 
        Test.stopTest();   
    }
    


}