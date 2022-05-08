/**
 * @description       : 
 * @author            : Khaliq Abdul
 * @last modified on  : 2021-11-09
 
**/
@isTest
public class RelatedPartiesCofirController_Test {

    @testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		/*Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'AVAF Queries',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Complaint',
			Response_Email_Address__c = 'avafcancellation1@absa.co.za'
		);
		insert serviceGroupRecord;*/

		Case caseRec = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = account.Id,
            Account = account,
			Email__c = 'test@test.com',
			recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',			        
        	Out_Of_SLA_Comments__c = 'Maintanace Related Parties',        
        	//Out_Of_SLA_Reason__c = 'Add or Delete Related Parties', 
			Incident_Date__c = date.today()
		);
		insert caseRec;
        
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
		User au = new User(
			Alias = 'standt',
			Email = aemail,
			EmailEncodingKey = 'UTF-8',
			LastName = 'UserAdmin',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			ProfileId = ap.Id,
			TimeZoneSidKey = 'Africa/Johannesburg',
			UserName = auniqueUserName,
			MobilePhone = '0823389021',
			Advisor_Code__c = '112233',
			SiteCode__c = '1334',
			Supervisor__c = '47028'
		);
		insert au;
	}
    
    @isTest
	public static void testCloseCase() {
		Account acc = new Account(Name = 'Test');
        insert acc;

        Case testCase = new Case(AccountId = acc.Id, Bypass_Validation_Rules__c = true);
        insert testCase;

		
		User au = new User();
		Set<String> userEmails = new Set<String>();
		userEmails.add('UserAdmin@testorg.com');
		List<User> userList = new UsersSelector().selectByEmail(userEmails);
		if (userList.size() > 0) {
			for (User u : userList) {
				if (u.Email == 'UserAdmin@testorg.com') {
					au = u;
				}
			}
		}
		System.runAs(au) {
		Test.startTest();
		RelatedPartiesCofirController.closeCase(testCase.Id);
        System.assert([SELECT Status FROM Case WHERE Id = :testCase.Id][0].Status == 'Closed');
           // System.assertEquals(null, 'Assert Successful');
		Test.stopTest();
        }

		
	}
    
}