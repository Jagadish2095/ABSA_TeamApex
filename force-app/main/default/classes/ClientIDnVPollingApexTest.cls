/**
 * @description Test class for ClientIDnVPollingApex
 * @author  Danie Booysen
 * @version v1.0
 * @since   2021-03-05
 * @updated 2021-10-22 Koketso Mpshane
 */
@isTest
public class ClientIDnVPollingApexTest {
	@TestSetup
	static void makeData() {
		String jsonString = '{"agentId":"7072","authenticationType":["ID_V","E_PIN"],"cifCode":"TEST_CIF","identified":true,"verified":true,"ucId":"00025173891614972755"}';
		ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) JSON.deserialize(
			jsonString,
			ClientIDnVPollingApex.ClientIDnVSessionObject.class
		);
		Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', sessionObj);

		Service_Group__c sGroup = new Service_Group__c(Name = 'Everyday Banking - Telephone Banking');
		insert sGroup;

		Service_Group_User_Entry__c sgUserEntry = new Service_Group_User_Entry__c();
		sgUserEntry.Service_Group__c = sGroup.Id;
		sgUserEntry.User__c = UserInfo.getUserId();
		insert sgUserEntry;
	}

	@isTest
	public static void getSessionCacheValuesPositive() {
		Test.startTest();
		ClientIDnVPollingApex.ClientIDnVSessionObject clientIDnVSessionObj = ClientIDnVPollingApex.getSessionCacheValues('TEST_CIF');
		Test.stopTest();
		System.assertEquals(true, clientIDnVSessionObj.matched, 'Assert Failed');
	}

	@isTest
	public static void getSessionCacheValuesNegative() {
		Test.startTest();
		ClientIDnVPollingApex.ClientIDnVSessionObject clientIDnVSessionObj = ClientIDnVPollingApex.getSessionCacheValues('NON_MATCHING_CIF');
		Test.stopTest();
		System.assertEquals(false, clientIDnVSessionObj.matched, 'Assert Failed');
	}

	@isTest
	public static void testCheckIDnVPollingUserServiceGroups() {
		Test.startTest();
		Boolean isIDnV = ClientIDnVPollingApex.checkIDnVPollingUserServiceGroups();
		Test.stopTest();
		System.assertEquals(true, isIDnV, 'Assert Failed');
	}
}