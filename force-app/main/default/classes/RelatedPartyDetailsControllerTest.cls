/**
 * @description       : Controller for thirdparty list
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-09-28
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Happy Baloyi                               Modification
 * 1.0   05-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/

@IsTest
public class RelatedPartyDetailsControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"120004946","status":"P"}';
	public static final String NEGATIVE_RESPONSE_BODY = '{"msgNo":"0","msg":"Success","refNo":"","status":""}';
    public static final String POSITIVE_RESPONSE_BODY_GetStatus = '{"WQgetCASAStatusByRefNoV7Response":{"wqp102o":{"surnameComp":"BOOTH","casaStatus":"I","pepSts":null,"msgNo":0,"msg":"INCOMPLETE-RISKP","idType":1,"idRegNo":8805240649081,"firstName":"MAYA","documentSts":"I","comments":null,"approvedSts":null},"nbsapdpo":{"version":"APLO003","serviceVersion":"BUSO001","returnCode":0,"reasonCode":0,"echoKey":null}}}';
/**
 * @description data creation
 * 
 */
	@testSetup
	public static void dataCreation() {
		String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
		String aemail = 'UserAdmin@testorg.com';
		//Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
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
        
        Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',            
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Account relatedPartyAccount = new Account(
			FirstName = 'Phukubyane',
			LastName = 'Pjane',
            MiddleName = 'snopo',
			Phone = '0835002323',
			CIF__c = '',
			CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',          
			ID_Number__pc = '8604254315089',
			Client_Group__c = 'Individual',            
			ID_Type__c = 'SA Identity Document',
            Countries_Traded_With__c='India',
            Country_of_Birth__pc='South Africa',
			PersonBirthdate = Date.valueOf('1986-04-25'),
            Date_Issued__pc = Date.valueOf('2021-07-05')
		);
		insert relatedPartyAccount;
        Account relatedPartfy = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        
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
             FROM Contact WHERE ID = :relatedPartfy.PersonContactId];
        
        relatedcntParty.ID_Number__c='6905257273088';
        relatedcntParty.FirstName = 'Phukubyane';
        relatedcntParty.LastName = 'Pjane';
		relatedcntParty.CASA_Reference_Number__c= '121238147';
		relatedcntParty.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty.CASA_Screening_Status__c = 'P';
        relatedcntParty.Source_of_Income__c = 'Salary';
        relatedcntParty.OtherPhone='0897897654';
        relatedcntParty.Birthdate = date.valueof('2021-06-11');
        relatedcntParty.Country_of_Birth__c= 'South Africa';
		relatedcntParty.Country_of_Residence__c= 'South Africa';
		relatedcntParty.Nationality__c = 'South Africa';
		relatedcntParty.Gender__c = 'Male';
        update relatedcntParty;
        
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = mainacc.Id;
		acr.ContactId = relatedcntParty.Id;
        acr.Control_of_Passive_Non_Financial_Entity__c = true;
        acr.Controlling_Person_is_Taxed_Outside__c = true;
		acr.Primary_Entity_Id__c = mainacc.Id;
        
		insert acr;
        
      
        Account relatedPartyAccount2 = new Account(FirstName = 'MAar',
                                                   LastName = 'Wawa',
                                                  CIF__C = 'MASKIE11',
                                                  date_issued__pc = date.valueOf('2021-07-09'),
                                                  Employer_Phone__c= '0121231234',
                                                   CASA_Reference_Number__c = '121229159',
			Nationality__pc = 'South Africa',
			Country_of_Residence__pc = 'South Africa',          
			ID_Number__pc = '8904254315089',
			Client_Group__c = 'Individual',            
			ID_Type__c = 'SA Identity Document',
            Countries_Traded_With__c='India',
            Country_of_Birth__pc='South Africa',
			PersonBirthdate = Date.valueOf('1989-04-25')           );
        insert relatedPartyAccount2;
        Account relatedPartyd = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Wawa'];
        
        	Address__c residential1 = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Residential',
			Account__c = relatedPartyd.ID
		);insert residential1 ;	
Address__c postal1= new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Postal',
			Account__c = relatedPartyd.ID
		);
insert postal1;

Address__c employer1= new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyd.ID
		);
insert employer1;
        
        
        Contact relatedcntParty2 = 
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
             FROM Contact WHERE ID = :relatedPartyd.PersonContactId];
        
        relatedcntParty2.ID_Number__c='6906257273088';
        relatedcntParty2.FirstName = 'MAar';
        relatedcntParty2.LastName = 'Wawa';
		relatedcntParty2.CASA_Reference_Number__c= '121212';
		relatedcntParty2.CASA_Screening_Date__c= date.valueof('2021-06-11');
		relatedcntParty2.CASA_Screening_Status__c = 'P';
        relatedcntParty2.Birthdate = date.valueof('2021-06-11');
        relatedcntParty2.Country_of_Birth__c= 'South Africa';
		relatedcntParty2.Country_of_Residence__c= 'South Africa';
		relatedcntParty2.Nationality__c = 'South Africa';
		relatedcntParty2.Gender__c = 'Male';
        update relatedcntParty2;
        
        Account relatedParty5 = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'wawa'];
        AccountContactRelation acr1 = new AccountContactRelation();
        acr1.AccountId = mainacc.Id;
        acr1.ContactId = relatedcntParty2.Id;
        acr1.Primary_Entity_Id__c = mainacc.Id;
        acr1.Control_of_Passive_Non_Financial_Entity__c = false;
        acr1.Controlling_Person_is_Taxed_Outside__c = false;
        insert acr1;
         
		Address__c postalAddress = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Account__c = relatedPartyAccount.ID,
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
			Account__c = relatedPartyAccount.ID
		);
        insert residential;
	Address__c employer = new Address__c(
			Shipping_Street__c = 'matabane',
			Address2__c = 'matabane',
			Shipping_Suburb__c = 'boksburg',
			Shipping_City__c = 'matabane',
			Shipping_Country__c = 'south africa',
			Shipping_Zip_Postal_Code__c = '0101',
			Address_TYpe__c = 'Employers',
			Account__c = relatedPartyAccount.ID
		);
        insert employer;
        
               
        Document__c document = new Document__c(
			Account__c = relatedPartfy.Id,
			Contact__c = relatedcntParty2.Id,
			ECM_Type__c = 'boksburg',
			Reference__c = '{00000000-0000-0000-0000-000000000000}',
			Case_External_Reference__c = 'south africa',
			Document_Sub_Type__c = '0101'
		);
        insert document;
	}
	@IsTest
	public static void getRelatedPartiesDetailsPositive() {
	    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
         Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];

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
			List<RelatedPartyDetailsController.ACRWrapper> acwrappers = RelatedPartyDetailsController.getRelatedPartiesDetails(mainacc.Id);
			Test.stopTest();
			System.assert(acwrappers.size() > 0, 'assert failed');
		}
	}

    
    @IsTest
	public static void insertDocumentInformationPositive() {
       
		//Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];        
       Account mainacc = [SELECT Id, PersonContactId FROM Account WHERE lastName = 'Pjane'];
        contact accr = [SELECT ID FROM contact WHERE lastName = 'Pjane' and firstname='Phukubyane' limit 1];
        
		Document__c document = [SELECT  ID,Account__c,Contact__c,ECM_Type__c,Reference__c 
                                ,Case_External_Reference__c,Document_Sub_Type__c FROM Document__c 
                                WHERE Document_Sub_Type__c = '0101'];
        string documenStr= JSON.serialize(document);
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
			 RelatedPartyDetailsController.insertDocumentInformation(documenStr,mainacc.id,accr.Id);
          //  system.debug('acwrappers ' + acwrappers );
			Test.stopTest();
			System.assertNotEquals('', 'assert failed');
		}
	}   
        
	@IsTest
	public static void getRelatedPartiesDetailsNegative() {
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
			List<RelatedPartyDetailsController.ACRWrapper> acwrappers = RelatedPartyDetailsController.getRelatedPartiesDetails(mainacc.Id);
          //  system.debug('acwrappers ' + acwrappers );
			Test.stopTest();
			System.assert(acwrappers.size()>0, 'assert failed');
		}
	}

	@IsTest
	public static void updateAccountFromDatabasePositiveTest() {
		
        Account mainacc = [SELECT Id FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        contact relatedParty5= [SELECT Id FROM contact WHERE lastName = 'Pjane' limit 1];
        contact relatedParty = [SELECT Id FROM contact WHERE lastName = 'Wawa' limit 1];
        
		List<String> idsToUpdte = new List<String>();
		IdsToUpdte.add(relatedParty5.Id);
		IdsToUpdte.add(relatedParty.Id);
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
			string IdUpdated = RelatedPartyDetailsController.updateAccountFromDatabase(idsToUpdte, relatedParty5.Id, mainacc.Id);
			System.assert(IdUpdated != null, 'assert failed');
			Test.stopTest();
		}

	}
	@IsTest
	public static void updateAccountFromDatabaseNegativeTest() {
         Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        contact relatedParty5 = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
        contact relatedPartyAccount2 = [SELECT ID FROM contact WHERE lastName = 'Wawa' limit 1];
        List<String> idsToUpdte = new List<String>();
        IdsToUpdte.add(relatedParty5.id);
        IdsToUpdte.add(relatedPartyAccount2.id);
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
			string IdUpdated = RelatedPartyDetailsController.updateAccountFromDatabase(idsToUpdte, relatedParty5.id, mainacc.id);
			System.assert(IdUpdated != null, 'assert failed');
			Test.stopTest();
		}

	}

	@IsTest
	public static void screenstokvelRelatedPartiesPositiveTest() {
        Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
        Account relatedPartyAccount1 = [SELECT ID ,PersonContactId FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
         Contact relatedPartycontc = [SELECT ID FROM Contact WHERE id = :relatedPartyAccount1.PersonContactId limit 1];
        AccountContactRelation relatedccount = [SELECT ID, contactid  FROM AccountContactRelation WHERE contactid = :relatedPartycontc.id limit 1];	
         Account relatedPartyAccount2 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
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
		
		
            IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{StringConstants.CASA_SCREEN_RELATED_PARTY_V7 }
		);
          Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			         IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GetStatus));		

		
            Test.startTest();
			string response = RelatedPartyDetailsController.screenstokvelRelatedParties(mainacc.Id, '121238147');
			System.assert(response!= null, 'Assert  failed');
			Test.stopTest();
		}
	}

	@IsTest
	public static void screenstokvelRelatedPartiesNegativeTest() {
		    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID,Country_of_Birth__pc FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
         Account relatedPartyAccount1 = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
         	String translation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_COUNTRY_STRING, relatedParty.Country_of_Birth__pc, StringConstants.OUTBOUND_RECORD_TYPE);
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
			IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CASA_SCREEN_RELATED_PARTY_V6 });
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, NEGATIVE_RESPONSE_BODY));
			Test.startTest();
			string response = RelatedPartyDetailsController.screenstokvelRelatedParties(relatedParty.Id, ' ');
			System.assert(response != ' ', 'Assert  failed');
			Test.stopTest();
		}
	}

	@IsTest
	public static void updateMandatorySignatoryAccountFromDatabasePositiveTest() {
		    Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 contact relatedPartyAccount1 = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
         contact relatedPartyAccount2 = [SELECT ID FROM contact WHERE lastName = 'Wawa' limit 1];
		List<String> idsToUpdate = new List<String>();
		IdsToUpdate.add(relatedPartyAccount1.id);
		IdsToUpdate.add(relatedPartyAccount2.id);
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
			RelatedPartyDetailsController.updateMandatorySignatoryAccountFromDatabase(idsToUpdate, relatedPartyAccount1.id, true,mainacc.id );
			System.assert(RelatedPartyDetailsController.updateMandatorySignatoryAccountFromDatabase(idsToUpdate, relatedPartyAccount1.id, true, mainacc.id) != null, 'assert failed');
			Test.stopTest();
		}

	}
	@IsTest
	public static void updateMandatorySignatoryAccountFromDatabaseNegativeTest() {
			     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 contact relatedPartyAccount1 = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
         contact relatedPartyAccount2 = [SELECT ID FROM contact WHERE lastName = 'Wawa' limit 1];
		List<String> idsToUpdate = new List<String>();
	
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
			integer accountfromdb =	RelatedPartyDetailsController.updateMandatorySignatoryAccountFromDatabase(idsToUpdate, relatedPartyAccount1.id, true,mainacc.id);
			// system.debug('wawa ' + accountfromdb);
			System.assert(accountfromdb != 0, 'assert failed');
			Test.stopTest();
		}

	}


	@IsTest
	public static void removeRelatedpartyPositiveTest() {
		     Account mainacc = [SELECT ID, CASA_REFERENCE_NUMBER__C FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 contact relatedPartyAccount1 = [SELECT ID, CASA_Reference_Number__c FROM contact WHERE lastName = 'Pjane' limit 1];
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
		string removedid =	RelatedPartyDetailsController.RemoveRelatedparty(relatedPartyAccount1.Id,mainacc.Id );

			System.assert(removedid != null,'assert failed');
			Test.stopTest();
		}
	}
	@IsTest
	public static void getEntityCasastatusPositiveTest() {
             Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		String POSITIVE_RESPONSE_BODY = '{"status":"OK"}';

		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME });        
       
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
			List<RelatedPartyDetailsController.EntityWrapper> respo  = RelatedPartyDetailsController.getEntityCasastatus(mainacc.Id);
		
			System.assert(respo[0].casaRefNumber == '121229158', 'SUCCESS');
			Test.stopTest();
		}
	}


	@IsTest
	public static void getEntityCasastatusNegativeTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME });        
      
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
			List<RelatedPartyDetailsController.EntityWrapper> respo  = RelatedPartyDetailsController.getEntityCasastatus(mainacc.Id);
			
			System.assert(respo[0].status == NULL, 'SUCCESS');
			Test.stopTest();
		}
	}

	@IsTest
	public static void getCasaReferenceNumPositiveTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
	
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
			String response = RelatedPartyDetailsController.getCasaReferenceNum(mainacc.Id);
			System.assert(response ==  '121229158', 'assert failed');
			Test.stopTest();
		}
	}

	@IsTest
	public static void getCasaReferenceNumNegativeTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
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
			String response = RelatedPartyDetailsController.getCasaReferenceNum(mainacc.Id);
			System.assert(response ==  '121229158', 'assert failed');
			Test.stopTest();
		}
	}
	/*@IsTest
	public static void getOverallCasaStatusPositiveTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 Account relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME });        
      
		
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
			String response = RelatedPartyDetailsController.getOverallCasastatus('121229158', mainacc.Id);
			
			System.assert( response == 'FAILED', 'ASSERT FAILED');
			Test.stopTest();
		}
	}
	@IsTest
	public static void getOverallCasaStatusNegativeTest() {
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
			String response = RelatedPartyDetailsController.getOverallCasastatus('121229158', mainacc.Id);
			System.assert( response != 'F', 'ASSERT FAILED');
			Test.stopTest();
		}
	}*/

	
    
       @IsTest
	public static void getRelatedpartyCountTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 contact relatedParty = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string contact = RelatedPartyDetailsController.getRelatedpartyCount(mainacc.Id);
			System.assert(contact != null, 'assert faile');
			Test.stopTest();
		}
    }
    
 
          @IsTest
	public static void getMandatorySignatoryCountTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 contact relatedParty = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string snatory = RelatedPartyDetailsController.getMandatorySignatoryCount(mainacc.Id);
         
			System.assert(snatory != null, 'assert faile');
			Test.stopTest();
		}
    }
     

 @IsTest
	public static void updateCIFDetailsTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 ACCOUNT relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			account cif  = RelatedPartyDetailsController.updateCIFDetails(relatedParty.Id,'wasw');
            System.assert(cif != null , 'assert faile');
			Test.stopTest();
		}
    }


	@IsTest
	public static void updateCasaDetailsTest() {
		     Account mainacc = [SELECT ID FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
		 ACCOUNT relatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		 contact relatedcntParty = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			account cicasaf  = RelatedPartyDetailsController.updateAccountCasaDetails(relatedcntParty.ID, 'ref12', 'succees');
			System.assert(cicasaf != null , 'assert faile');
			Test.stopTest();
		}
    }
    
    
    
     @IsTest
	public static void screenRelatedParty() {
           IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ WQgetCASAStatusByRefNoV7_IH_v1.INTEGRATION_SERVICE_NAME }
		);
        	Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GetStatus));
		     Account mainacc = [SELECT ID,CIF__c FROM ACCOUNT WHERE NAME = 'TheStokvel' limit 1 ];
         ACCOUNT accrelatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
		 contact relatedParty = [SELECT ID FROM contact WHERE lastName = 'Pjane' limit 1];
       Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string response  = RelatedPartyDetailsController.screenRelatedParty(accrelatedParty.id,mainacc.Id);
           
           	System.assert(response != null, 'failed');
			Test.stopTest();
		}
    }
    
     @IsTest
	public static void generateORUpdateCIF() {
		  ACCOUNT accrelatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
       Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string cif  = RelatedPartyDetailsController.generateORUpdateCIF(accrelatedParty.Id);
           
           	System.assert(cif != null, 'failed');
			Test.stopTest();
		}
    }

  @IsTest
	public static void generateORUpdateCIFNEg() {
		  ACCOUNT accrelatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Wawa' limit 1];
       Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string cif  = RelatedPartyDetailsController.generateORUpdateCIF(accrelatedParty.Id);
           
           	System.assert(cif != null, 'failed');
			Test.stopTest();
		}
   
}
         @IsTest
	public static void generateORUpdateCItestF() {
		  ACCOUNT accrelatedParty = [SELECT ID FROM ACCOUNT WHERE lastName = 'Pjane' limit 1];
       Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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
			string cif  = RelatedPartyDetailsController.generateORUpdateCIF(accrelatedParty.Id);
           
           	System.assert(cif != null, 'failed');
			Test.stopTest();
		}
    }

}