/*
Controller Test Class For BranchCustomerAddressHelper class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class BranchCustomerAddressHelperTest {

    @testSetup
    static void dataCreation(){
        Account account = new Account(Name = 'TestAccount');
        insert account;

        Address__c employersAddress = new Address__c(
            Account__c=account.Id,
            Address_Type__c='Employers');

        insert employersAddress;
    }

    @isTest
    public static void getAddressesTest(){
        Account account = [SELECT Id FROM Account where Name = 'TestAccount' LIMIT 1];
        List<String> addressTypes = new List<String>();
        addressTypes.add('Employers');
        addressTypes.add('Postal');

        Test.startTest();
        Map<String,String> errorText = BranchCustomerAddressHelper.getAddresses(account.Id, addressTypes);
        System.assert(errorText != null, 'Test Working');
        Test.stopTest();
    }
}