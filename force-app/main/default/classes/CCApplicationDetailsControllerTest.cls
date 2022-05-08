/**
* @description Test Class for CCApplicationDetailsController
* @Author : Manish :Absa
* @since   2021-04-19
**/
@isTest
public class CCApplicationDetailsControllerTest {

    /**
     * @description Test method for CCApplicationDetailsController
    **/
    @isTest
    public static void getApplicationProductTest(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Application_Product__c testAppProduct = testDataFactory.testApplicationProduct;
        String response = CCApplicationDetailsController.getApplicationDetails(testAppProduct.Id);
        CCApplicationDetailsController.saveApplicationDetails('', testAppProduct.Id);
        System.assertNotEquals(response, '','Not Blank');
    }
}