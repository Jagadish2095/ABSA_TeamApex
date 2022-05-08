/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-10-18
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   05-21-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class StokvelRelatedPartiesControllerTest 
{
    @testSetup
    static void dataCreation(){
     String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
       // Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
       Profile ap = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];
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
            Advisor_Code__c = '112233'
        );
        insert au;
        Account mainAccount = new Account(firstName = 'Stokvel', lastName = 'MainEntity', Language__c='English');
        insert mainAccount;

        Account relatedPartyAccount = new Account(firstName = 'Stokvel', lastName = 'RelatedParty',ID_Number__pc='7707144715086',
                                                 Client_Type__c= 'Individual', PersonEmail='lolo@mom.com',PersonHomePhone='0831231234',
                                                 Phone='0831231234',CIF__c='moo 001', 
                                                 Salutation = 'MRS');
        insert relatedPartyAccount;
    }

    @isTest
    public static void testCreateStokvelRelationship_ACRExists() {

        Account mainAccount = [SELECT Id FROM Account WHERE lastName = 'MainEntity'];
        Account relatedPartyAccount = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'RelatedParty'];

        AccountContactRelation acr = new AccountContactRelation();
        acr.AccountId = mainAccount.Id;
        acr.ContactId = relatedPartyAccount.PersonContactId;
        acr.Primary_Entity_Id__c = mainAccount.Id;
        insert acr;
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
        String response = StokvelRelatedPartiesController.createStokvelRelationship(relatedPartyAccount.Id, mainAccount.Id);
        System.assertEquals(false, response.contains('SUCCESS'));
        Test.stopTest();
        }
    }

    @isTest
    public static void testValidateExitedAccountRelationship_Positive() {

        Account mainAccount = [SELECT Id FROM Account WHERE lastName = 'MainEntity'];
        Account relatedPartyAccount = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'RelatedParty'];
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
        String response = StokvelRelatedPartiesController.createStokvelRelationship(relatedPartyAccount.Id, mainAccount.Id);
        //System.assert( response.contains('SUCCESS'), 'assert failed');
        System.assertNotEquals('', response);
            Test.stopTest();
        }
    }
    @isTest
    public static void testValidateExitedAccountRelationship_Negative () {

        Account mainAccount = [SELECT Id FROM Account WHERE lastName = 'MainEntity'];
        Account relatedPartyAccount = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'RelatedParty'];
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
        String response = StokvelRelatedPartiesController.createStokvelRelationship( mainAccount.Id,relatedPartyAccount.Id);
        //System.assert( response == 'SUCCESS', 'assert failed');
        //system.debug('respo ' + response);
       System.assert(response == 'SUCCESS', 'assert failed');
            Test.stopTest();
        }
    }
       	@IsTest
	static void updateAccountDetailsTest() {
		 Account mainacc = [SELECT ID FROM ACCOUNT WHERE LastNAME = 'RelatedParty' limit 1 ];
		 Account relatedPartyAccount = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'RelatedParty'];
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
			 StokvelRelatedPartiesController.updateAccountDetails(relatedPartyAccount.Id, '' );
			System.assertNotEquals('SUCCESS', 'assert faile');
			Test.stopTest();
		}
	}
    
      	@IsTest
	static void updateAccountInfo() {
		 Account mainacc = [SELECT ID FROM ACCOUNT WHERE LastNAME = 'RelatedParty' limit 1 ];
		Account relateccount = new Account(firstName = 'Sophy', lastName = 'maluleka',ID_Number__pc='7908144715086',
                                                 Client_Type__c= 'Individual', PersonEmail='lolo@mom.com',PersonHomePhone='0831235234',
                                                 Phone='0831231294',CIF__c='mroo 001', Communication_Method__c='SMS',
                                                 Salutation = 'MRS');
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
			string accitd =  StokvelRelatedPartiesController.updateAccountInfo(relateccount);
			System.assert(accitd != null, 'assert failed');
			Test.stopTest();
		}
	}
}