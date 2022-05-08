/*
* Helper class for CreditCardHelper
* @author  Clifford Willers
* @created 2021-02-18
* @last Modified on : 11 September 2021
* @Last Modified by : Jabulani Mashia
*/
@isTest
public class CreditCardHelperTest {
    @testSetup
    static void dataCreation(){
        Account account = new Account();
        account.ID_Number__pc = '9308305015082';
        account.FirstName = 'CreditCardHelperTest';
        account.LastName = 'Tester';
        account.PersonBirthdate = Date.newInstance(2000, 04, 1);
        insert account;
    }

    @isTest
    public static void getActionQuotation()
    {
        Account account = [SELECT Id FROM Account where FirstName = 'CreditCardHelperTest' LIMIT 1];
        String newCreditLimit = '';
        String wkFiid = '';
        String wkAcctProd = '';
        String wkAcctType = '';
        Test.startTest();
        String output = CreditCardHelper.getActionQuotation(account.Id, newCreditLimit, wkFiid, wkAcctProd, wkAcctType);
        System.assert(output != null, 'Test Working');
		Test.stopTest();
    }
}