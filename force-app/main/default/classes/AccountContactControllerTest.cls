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
@IsTest
public class AccountContactControllerTest
{
	@testSetup
	static void dataCreation() {
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
            SiteCode__c ='8999',
			Advisor_Code__c = '112233'
		);
		insert au;
        
        List<User> currentUser = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		Site__c site = new Site__c();
		site.Name = 'New ATM SIte';
		site.Branch_ATM__c = true;
		site.Branch_Site_Name__c = 'Fourways';
		site.Branch_Site_Code__c = 1007;
		site.Site_Code__c = '8999';
		site.Site_Address__c = 'ABC';
		insert site;

		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			Communication_Method__c = 'Email',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2,
			Country_of_Registration__c = 'South Africa',
			Country_of_Incorporation__c = 'South Africa',
			RepresetentiveName__c = 'anna',
			RepresentativeLastname__c = 'dave'
		);
		insert mainacc;


		Account relatedPartyAccount = new Account(FirstName = 'Phukubyane', LastName = 'Pjane', Phone = '0835002323');
		insert relatedPartyAccount;

		Account relatedParty = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        Contact relatedcntParty = 
        [SELECT Id,
         CASA_Reference_Number__c,
		CASA_Screening_Date__c,
		CASA_Screening_Status__c,
        Birthdate,
       Country_of_Birth__c,
         Source_of_Income__c,
				FirstName,
				LastName,
				ID_Number__c,
		Country_of_Residence__c,
		Nationality__c,
		Gender__c
        FROM Contact WHERE ID = :relatedParty.PersonContactId];
        
        relatedcntParty.ID_Number__c='12121212121212';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121212';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
        acr.Controlling_Person_is_Taxed_Outside__c = true;
        acr.Control_of_Passive_Non_Financial_Entity__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;
		insert acr;
        
        
		Address__c postalAddress = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Account__c = relatedParty.ID,
			Address_TYpe__c = 'Postal'
		);
		insert postalAddress;
		Address__c residential = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedParty.ID
		);
		insert residential;
        Account relatedPartyAccount2 = new Account(FirstName = 'Marna', LastName = 'Gona', Phone = '0835002123');
		insert relatedPartyAccount2;

		Account relatedParty2 = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Gona'];
		AccountContactRelation acr2 = new AccountContactRelation();
		acr2.AccountId = mainacc.Id;
		acr2.ContactId = relatedParty2.PersonContactId;
        acr2.Controlling_Person_is_Taxed_Outside__c = false;
        acr2.Control_of_Passive_Non_Financial_Entity__c = true;
		acr2.Primary_Entity_Id__c = mainacc.Id;
		insert acr2;
	}
	@IsTest
	public static void getAccountWithContactsPositiveTest() {
		//Test data
		//Test data
		Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
        String relatedPartyIdNumber = [SELECT ID, ID_Number__c FROM CONTACT WHERE lastName = 'Pjane' limit 1].ID_Number__c;
             List<User> currentUser = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
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

		List<String> internetUserIds = new List<String>();
		internetUserIds.add(relatedPartyIdNumber);
		System.runAs(au) {
			Test.startTest();
			AccountContactController.AccountContactListWrapper accountwithContacts = AccountContactController.getAccountWithContacts(mainacc.Id, internetUserIds);
		
            System.assert(accountwithContacts != null, 'assert failed');
      
			Test.stopTest();
		}

	}

	@IsTest
	public static void getAccountWithContactsNegativeTest() {
		//Test data
		//Test data
		Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
         Contact relatedParty3 = [SELECT ID FROM CONTACT WHERE lastName = 'Pjane' limit 1];
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
		List<String> internetUserIds = new List<String>();
		System.runAs(au) {
			Test.startTest();
			AccountContactController.AccountContactListWrapper accountwithContacts = AccountContactController.getAccountWithContacts(relatedParty.Id, internetUserIds);
	
            System.assert(accountwithContacts != null, 'assert failed');
      
			Test.stopTest();
		}

	}
	@IsTest
	public static void getRelatedAccountsPositiveTest() {
			Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
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
			List<AccountContactRelation> accountwithContacts = AccountContactController.getRelatedAccounts(mainacc.Id);
            System.assert(accountwithContacts.size() > 0, 'assert failed');
			Test.stopTest();
		}
	}
    @IsTest
	public static void getRelatedAccountsNegativeTest() {
			Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedParty= [SELECT ID,PersonContactId  FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
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
			List<AccountContactRelation> accountwithContacts = AccountContactController.getRelatedAccounts(mainacc.Id);
			System.assert(accountwithContacts.size() != 0, 'assert failed');
			Test.stopTest();
		}
	}
  @IsTest
	public static void GetAccountContactControllerTest() {
			Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
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
			AccountContactRelation accountwithContacts = AccountContactController.GetAccountContactController(mainacc.Id);
			   
            System.assert(accountwithContacts != null, 'assert failed');
			Test.stopTest();
		}
	}  
    @IsTest
	public static void GetAccountControllerDetailsTest() {
			 Account relatedParty= [SELECT ID,PersonContactId  FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
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
			Account accountwithContacts = AccountContactController.GetAccountControllerDetails(relatedParty.PersonContactId);
        
			System.assert(accountwithContacts != null, 'assert failed');
			Test.stopTest();
		}
	} 
     @IsTest
	public static void GetAccountRelatedpartyDetailsTest() {
		Account relatedParty= [SELECT ID,PersonContactId  FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
        Account relatedParty2= [SELECT ID,PersonContactId  FROM ACCOUNT WHERE lastName = 'Gona' limit 1];
        List<ID> ids =new  List<ID>();
        ids.add(relatedParty.PersonContactId);
        ids.add(relatedParty2.PersonContactId);
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
			List<Account> accountwithContacts = AccountContactController.GetAccountRelatedpartyDetails(ids);
            System.assert(accountwithContacts.size() > 0, 'assert failed');
			Test.stopTest();
		}
	} 
    
    
}