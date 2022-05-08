@isTest
public class VoiceCustomerPersonalInfoUpdateCTRLTest {
    	/**
	 * @description test Method for setIdDerivedGenderAndDob method
	 */
    @isTest
    public static void testsetIdDerivedGenderAndDob(){
        Account account = new Account();
		account.ID_Number__pc = '9308305015083';
		account.FirstName = 'Test';
		account.LastName = 'Tester';
		insert account;
		Account accountWithCIF = new Account();
		accountWithCIF.ID_Number__pc = '9309305015082';
		accountWithCIF.FirstName = 'Test';
		accountWithCIF.LastName = 'Tester';
		accountWithCIF.CIF__c = 'NGOBEH 011';
		insert accountWithCIF;
	
        Test.startTest();
        VoiceCustomerPersonalInfoUpdateCTRL.setIdDerivedGenderAndDob(account.Id);
		Account accountAfter = [SELECT PersonBirthDate FROM Account WHERE Id = :account.Id LIMIT 1];
		System.assertEquals('1993-08-30', String.valueOf(accountAfter.PersonBirthDate), 'Assert failed');
        Test.stopTest();
    }
}