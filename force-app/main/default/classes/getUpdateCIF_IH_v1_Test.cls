/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-12-01
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@isTest
public class getUpdateCIF_IH_v1_Test {
	@isTest
    public static void testUpdateCIF2(){
        list<Account> testAccount=TestDataFactory.getPersonAccounts('TestLastName','Individual_Prospect', 1);
        testAccount[0].Client_group__c = 'Individual';
        insert testAccount;
        
        Test.setMock(HttpCalloutMock.class, new getUpdateCIFMock_APIRest(StringConstants.POSITIVE_STRING));
        //IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new list<String> {'updateCIF'});

        Test.startTest();
        getUpdateCIF_IH_v1.getCIFResponse(testAccount[0], 'address1', 'address2', 'suburb', 'cityName', 'South Africa', '2001', 'Y', 'Y', 'Allowance','Full Time Employed' , '');
        system.assertEquals(testAccount[0].Client_group__c, 'Individual');
        Test.stopTest();
    } 
}