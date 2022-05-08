/**
 * @description Test class for SalesOnboardingProductsInformation
 * @author  Koketso Mpshane
 * @date    03/09/2021
 */
@isTest
public class SalesOnboardingProductsInformationTest {
    
    @isTest
	static void testGetProductTypesMapping() {

		Test.startTest();
		
        String response = SalesOnboardingProductsInformation.getProductTypesMapping();
        Test.stopTest();
        
        system.assert(response.StartsWith('{'), 'Assert Failed');

    }
    
    @isTest
	static void testGetProductsInformation() {
		
        ROAFeature__c roaProduct = new ROAFeature__c();
        roaProduct.Name = 'Gold Account 1';
        roaProduct.Product_Code__c = '12345';
        roaProduct.Montly_Fee__c = 'R200';
        roaProduct.Recommended_Income__c = 'R240000';
        roaProduct.Pdf_Url__c = 'testurl';
        insert roaProduct;
        
		Test.startTest();

        String response = SalesOnboardingProductsInformation.getProductsInformation(new List<String>{roaProduct.Product_Code__c});
        Test.stopTest();
        
        List<Object> responseObj = (List<Object>) JSON.deserializeUntyped(response);
		system.assertEquals(1, responseObj.size(), 'Assert failed');

    }

}