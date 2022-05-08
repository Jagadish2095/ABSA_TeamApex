/* 
 * This is the Controller Test Class for the Credit Product Details
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-06-09
*/

@isTest
public class ProductDetailsControllerTest {

    @testSetup
    public static void dataCreation() {
        ClientDetailsSectionCreditTest.dataCreation();
    }

    public static testMethod void testGetProductDetails() {
        
        Opportunity opportnity = [SELECT Id,Name FROM Opportunity LIMIT 1];

        Test.startTest();

        ProductDetailsController.getProductDetails(opportnity.Id);
        ProductDetailsController.viewProductDetails();

        Test.stopTest();
    }
}