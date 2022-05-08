/**
 * @description This is the Test Class of the CustomerHoldController to show only imposed Data with clicked checkbox,
 * in Retail Leads App on Lead Detail page under Customer Hold tab and,
 * Customer Hub under Person Account details page under releted list Customer Hold.
 *
 * @author  Santosh Kumar
 * @since   2021-06-30
 */

@isTest
public class CustomerHoldControllerTest {
	@isTest
	private static void getClientHoldDetailsTest() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Account tstAccount = testDataFactory.testAccount;
		User user = [SELECT SiteCode__c FROM User WHERE Id = :userInfo.getUserId()];
		Test.startTest();
		String returnResponse = CustomerHoldController.getClientHoldDetails(tstAccount.CIF__c, '0', user.SiteCode__c);
		Test.stopTest();
		system.assert(returnResponse != null);
	}
}