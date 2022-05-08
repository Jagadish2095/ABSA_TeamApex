/*
* AddBeneficiaryControllerTest for testing AddBeneficiaryController class
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2020-12-11
*/
@isTest
public class AddBeneficiaryControllerTest {
    
    @isTest 
    public static void testCIGetAccount(){
        List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
        accountList[0].LastName = 'SKOSANA';
        accountList[0].ID_Type__pc ='SA Identity Document';
        accountList[0].ID_Number__pc='8505225522085';
        accountList[0].CIF__c='ARENTAL001';
        insert accountList;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE});
        
        Test.startTest();
        String responseBean = AddBeneficiaryController.getAccountDetails(accountList[0].Id);
        system.assertNotEquals(null, responseBean);
        Test.stopTest();
    } 
    
    @isTest
    static void addBeneficiaryTest() {
        // Set mock callout class
        Test.startTest();
        String responseString = AddBeneficiaryController.addBeneficiary('01', 'Test','203099621','51008','00000004048241208','CQ','04483850000235776','TEstst','Testing');
        Test.stopTest();
    }
}