/**
 * @description Controller class for Account Contact Controller
 * @author  Happy
 * @created 2020-11-12
 */
public without sharing class AccountContactController {
    
	public static Site__c userSite;
	public static List<User> currentUser;
	/**
	 * @description getAccountWithContacts
	 * @return AccountContactListWrapper
	 * @param accountId
	 * @param internetBankingUserIdNumbers
	 */

	@AuraEnabled
	public static AccountContactListWrapper getAccountWithContacts(String accountId, List<String> internetBankingUserIdNumbers) {
		AccountContactListWrapper accWrapper = new AccountContactListWrapper();
		Site__c userSite = new Site__c();
		try {
			Account mainAccount = [
				SELECT Name, ID_Number__pc, PersonMobilePhone, CASA_Reference_Number__c, CIF__c
				FROM Account
				WHERE Id = :accountId
				WITH SECURITY_ENFORCED
				LIMIT 1
			];
			accWrapper.MainAccount = new AccountContactWrapper();
			accWrapper.MainAccount.FullName = mainAccount.Name;
			accWrapper.MainAccount.IDNumber = mainAccount.ID_Number__pc;
			accWrapper.MainAccount.PhoneNumber = mainAccount.PersonMobilePhone;


			
			List<AccountContactRelation> aclist = getRelatedAccounts(accountId);

           
			if (aclist.size() > 0) {
				accWrapper.MandatorySignatories = new List<AccountContactWrapper>();
				accWrapper.internetBankingUsers = new List<AccountContactWrapper>();
				accWrapper.OfficalsNames = '';
				accWrapper.Beneficiaries = '';
				accWrapper.CasaReferenceNumber = mainAccount.CASA_Reference_Number__c;
				accWrapper.CustomerCode = mainAccount.CIF__c;

				for (AccountContactRelation account : aclist) {
					AccountContactWrapper signatory = new AccountContactWrapper();
					signatory.FullName = account.Contact.FirstName + ' ' + account.Contact.LastName;
					signatory.IDNumber = account.Contact.ID_Number__c;
					signatory.PhoneNumber = account.Contact.MobilePhone;
					signatory.AccountId = account.ContactId;

//					if (account.Control_of_Passive_Non_Financial_Entity__c)
//                    {
						accWrapper.MandatorySignatories.add(signatory);
						accWrapper.OfficalsNames += accWrapper.OfficalsNames == '' ? ' ' : ', ';
						accWrapper.OfficalsNames += account.Contact.FirstName;
						accWrapper.OfficalsNames += ' ' + account.Contact.LastName;
//					}


					if ((internetBankingUserIdNumbers != null) &&
							!internetBankingUserIdNumbers.isEmpty() &&
							internetBankingUserIdNumbers.contains(account.Contact.ID_Number__c)) {
						accWrapper.internetBankingUsers.add(signatory);
					}

					if (account.Controlling_Person_is_Taxed_Outside__c) {
						accWrapper.ControllerAccount = signatory;
					}

					accWrapper.Beneficiaries += accWrapper.Beneficiaries == '' ? ' ' : ', ';
					accWrapper.Beneficiaries += signatory.FullName;
				}

				accWrapper.Address = '';

				AccountContactRelation accountcontroler =    AccountContactController.GetAccountContactController( accountId);
				Account accountcontrolerdetail =    AccountContactController.GetAccountControllerDetails(accountcontroler.ContactId);
				Address__c residentialAddress = [
					SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
					FROM Address__c
					WHERE Account__c = :accountcontrolerdetail.Id AND Address_TYpe__c = 'Residential'
					WITH SECURITY_ENFORCED
					LIMIT 1
				];
				if (residentialAddress != null) {
					accWrapper.Address += residentialAddress.Shipping_Street__c + '\n';
					accWrapper.Address += residentialAddress.Shipping_Suburb__c + '\n';
					accWrapper.Address += residentialAddress.Shipping_City__c + '\n';
					accWrapper.Address += residentialAddress.Shipping_Zip_Postal_Code__c;

					currentUser = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
					
					userSite = new SitesSelector().selectBySiteCode(currentUser[0].SiteCode__c).get(0);
					accWrapper.OpeningSiteName = userSite.Name;
				}
			}
		} catch (Exception e) {
			throw e;
		}
if(accWrapper != null)
{
		return accWrapper;
	}
    else {
        accWrapper = new AccountContactListWrapper();
        return accWrapper;
    }
}

	/**
	 * @description getRelatedAccounts
	 * @return List<Account>
	 * @param accountId
	 */
	public static List<AccountContactRelation> getRelatedAccounts(String accountId) {
			
        List<AccountContactRelation> accountlist = [SELECT Id, 
                                                    AccountId,ContactId,
                                                    Contact.CASA_Reference_Number__c,
                                                    Contact.CASA_Screening_Date__c,
                                                    Contact.CASA_Screening_Status__c,
                                                    account.Client_Group__c,
                                                    account.Countries_Traded_With__c,
                                                    Contact.Source_of_Income__c,
                                                    Contact.FirstName,
                                                    Contact.LastName,
                                                    Contact.ID_Number__c,
                                                    Contact.OtherPhone,
													Contact.MobilePhone,
                                                    Controlling_Person_is_Taxed_Outside__c,// controller
                                                    Control_of_Passive_Non_Financial_Entity__c,//signatory
                                                    Contact.Birthdate,
                                                    Contact.Country_of_Birth__c,
                                                    Contact.Country_of_Residence__c,
                                                    Contact.Nationality__c,
                                                    Contact.Gender__c,
                                                    Contact.CIF__c,
													Contact.Occupation_Category__c
                                                    FROM AccountContactRelation
                                                    WHERE AccountId = :accountId AND Primary_Entity_Id__c =:accountId
                                                    WITH SECURITY_ENFORCED
                                                   ];
		return accountlist;
	}
	/**
	 * @description getIdFrom  objects
	 * @author  Happy
	 * @created 2020-11-12
	 * @param  items
	 *  @param  sname
	 * @return  Set<Id>
	 */
	private static Set<Id> getIdFromList(List<SObject> items, String sname) {
		Set<Id> returnIds = new Set<Id>();
		for (SObject item : items) {
			returnIds.add((String) item.get(sname));
		}

		return returnIds;
	}
	  /**
	 * @description Method gets controller of the stokvel,
	 *  @param accountId - isCheckedVal
	 * @return List<AccountContactRelation>
	 */
	@AuraEnabled
	public static AccountContactRelation GetAccountContactController( ID accountId) {
	
		AccountContactRelation accountController = [
			SELECT ID,Contact.FirstName,
			Contact.LastName, ContactId, 
			Controlling_Person_is_Taxed_Outside__c// controller
			
			FROM AccountContactRelation
			WHERE  AccountId = :accountId AND Primary_Entity_Id__c = :accountId AND Controlling_Person_is_Taxed_Outside__c = TRUE
			WITH SECURITY_ENFORCED
		];		
		return accountController;
	}
    
	 /**
	 * @description Method gets controller details of the stokvel,
	 * @param contactId - set Selected ID from the ThirdParty Grid.
	 * @return Account
	 */
	@AuraEnabled
	public static Account GetAccountControllerDetails(ID contactId) {
	    Contact contactController = [
			SELECT ID, AccountId
			FROM Contact
			WHERE Id = :contactId 
			WITH SECURITY_ENFORCED
		];

		List<Account> accountController = [
			SELECT ID,
				CASA_Reference_Number__c,
                CASA_Screening_Date__c,
                CASA_Screening_Status__c,
				Client_Group__c,
				Countries_Traded_With__c,
				Source_of_Income__c,
				FirstName,
				LastName,
				ID_Number__pc,
				PersonMobilePhone,
            	PersonEmail,
				PersonBirthdate,
				Country_of_Birth__pc,
				Country_of_Residence__pc,
				Nationality__pc
			FROM Account
			WHERE Id = :contactController.AccountId 
			WITH SECURITY_ENFORCED
		];
		
		return accountController[0];
	}

    /**
	 * @description Method gets controller details of the stokvel,
	 *  @param opportunityID - set Selected ID from the ThirdParty Grid.
	 * @param accountContactRelId - set Selected ID from the ThirdParty Grid.
	 * @return Account
	 */
	@AuraEnabled
	public static ProductContactSignatoryRelationship__c GetProductContactSignatoryRelationship(string opportunityID,ID accountContactRelId) 
    {
        OpportunityLineItem opportunityLineItem =
            [SELECT ID, ProductCode, Product2Id, Product_Name__c, Policy_Number__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityID AND Product_Family__c = 'Savings' WITH SECURITY_ENFORCED LIMIT 1];
        
       ProductContactSignatoryRelationship__c productContactSignatory = null;
        try
        {
            productContactSignatory = [
                SELECT ID,
                Name, 
                AccountContactRelationshipId__c, 
                OpportunityProductId__c, 
                PrimaryAccountId__c, 
                Product_Name__c,
                Number_of_Signatories_for_account__c,
                Compulsory_Signature__c,
                Special_Instruction__c
                FROM ProductContactSignatoryRelationship__c
                WHERE AccountContactRelationshipId__c = :accountContactRelId AND OpportunityProductId__c =:opportunityLineItem.Id 
                WITH SECURITY_ENFORCED];
            }
            catch(Exception e) {
                
                productContactSignatory = null;
                
            }
		
		return productContactSignatory;
	}
    
	 /**
	 * @description Method gets controller details of the stokvel,
	 * @param contactId - set Selected ID from the ThirdParty Grid.
	 * @return Account
	 */
	@AuraEnabled
	public static List<Account> GetAccountRelatedpartyDetails(List<ID> contactId) {
	    List<Contact> contacts = [
			SELECT ID, AccountId
			FROM Contact
			WHERE Id in :contactId 
			WITH SECURITY_ENFORCED
		];
		Set<ID> contactids = new Set<ID>();
		for(Contact Acontact : contacts )
		{
		   contactids.add(Acontact.AccountId);  
		}
		List<Account> accountController = [
			SELECT ID,
				CASA_Reference_Number__c,
                CASA_Screening_Date__c,
                CASA_Screening_Status__c,
				Client_Group__c,
				Countries_Traded_With__c,
				Source_of_Income__c,
				FirstName,
				LastName,
				ID_Number__pc,
				PersonMobilePhone,
				PersonBirthdate,
				Country_of_Birth__pc,
				Country_of_Residence__pc,
				Nationality__pc,
            	Account.PersonEmail,
            	Account.Residential_Status__pc,            
            	Account.Highest_Qualification__pc,
            	Account.Number_Of_Dependents__c,            
            	Account.Marital_Status__pc,
            	Account.Language__c,
            	Account.Gender__pc,
            	Account.Employer_Name__pc, 
            	Employer_Sector__pc, 
            	Occupation_Level__pc, 
            	Occupation_Status__pc, 
            	Employer_Phone__c,
				(SELECT  Occupation_Category__c  FROM ACCOUNT.CONTACTS )
			FROM Account
			WHERE Id in :contactids 
			WITH SECURITY_ENFORCED
		];
		
		return accountController;
	}
	/**
	 * @description Controller class for Account Contact Wrapper
	 * @author  Happy
	 * @created 2020-11-12
	 */
	public without sharing class AccountContactWrapper {
		/**
		 * @description accountId
		 */
		@AuraEnabled
		public String accountId ;

		/**
		 * @description fullName
		 */
		@AuraEnabled
		public String fullName { get; set; }

		/**
		 * @description iDNumber
		 */
		@AuraEnabled
		public String idNumber;

		/**
		 * @description phoneNumber
		 */
		@AuraEnabled
		public String phoneNumber;
	}

	/**
	 * @description Controller class for Account ContactList Wrapper
	 * @author  Happy
	 * @created 2020-11-12
	 */

	public without sharing class AccountContactListWrapper {
		/**
		 * @description officalsNames
		 */
		@AuraEnabled
		public String officalsNames ;

		/**
		 * @description beneficiaries
		 */

		@AuraEnabled
		public String beneficiaries ;

		/**
		 * @description address
		 */

		@AuraEnabled
		public String address;

		/**
		 * @description openingSiteName
		 */
		@AuraEnabled
		public String openingSiteName ;

		/**
		 * @description casaReferenceNumber
		 */
		@AuraEnabled
		public String casaReferenceNumber;

		/**
		 * @description customerCode
		 */
		@AuraEnabled
		public String customerCode;

		/**
		 * @description mainAccount
		 */
		@AuraEnabled
		public AccountContactWrapper mainAccount ;

		/**
		 * @description controllerAccount
		 */
		@AuraEnabled
		public AccountContactWrapper controllerAccount ;

		/**
		 * @description mandatorySignatories
		 */
		@AuraEnabled
		public List<AccountContactWrapper> mandatorySignatories;

		/**
		 * @description mandatorySignatories
		 */
		@AuraEnabled
		public List<AccountContactWrapper> internetBankingUsers;
	}
}