@isTest
public class AICContactDetailsControllerTest {
    @testSetup
	static void dataCreation() {
        AICContactDetails__c aicContactDetails = new AICContactDetails__c();
        aicContactDetails.Name = 'testDepartment';
        aicContactDetails.Department__c = 'testDepartment';
		aicContactDetails.Email__c = 'test@test.com';
		aicContactDetails.Contact_Number__c = '0987654321';
		insert aicContactDetails;        
	}

	@isTest
	static void testGetAICContactDetails() {
		Test.startTest();
        List<AICContactDetails__c> aicContactsLists = AICContactDetailsController.getAICContactDetails();
		Test.stopTest();
        System.assertEquals(1, aicContactsLists.size(), 'Assert Failed');
	}

}