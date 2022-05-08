/**
 * @description       :
 * @author  Kyle Alexander
 * @last modified on  : 2021-10-19
 * @last modified by  : robertml@absa.africa
 **/

public class AccountCreateCIFController {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-10-19
	 * @param accId
	 * @return Boolean
	 **/
	@AuraEnabled
	public static Boolean validateIfCIFExists(Id accId) {
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(accId, 1);
		if (accounts.get(0).CIF__c == null) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-10-19
	 * @param accId
	 * @return String
	 **/
	@AuraEnabled
	public static String createOrUpdateAccountInCIF(Id accId) {
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(accId, 1);
		//Pre validation checks
		if (accounts.get(0).Client_Type__c == null) {
			return 'Error: Client Type Cannot be blank - please amend on the account';
		}
		List<String> nonCreditIndicatorList;
		if (accounts.get(0).Non_Credit_Marketing_Indicator__pc != null) {
			nonCreditIndicatorList = accounts.get(0).Non_Credit_Marketing_Indicator__pc.split(';');
		}
		List<String> creditIndicatorList;
		if (accounts.get(0).Credit_Marketing_Indicator__pc != null) {
			creditIndicatorList = accounts.get(0).Credit_Marketing_Indicator__pc.split(';');
		}
		//Joint Account
		if (accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect') {
			List<Account> participantAccounts = new AccountContactRelationSelector().selectListByAccId(accounts.get(0).Id);
			accounts = new AccountsSelector().selectCasaFieldsJointAccountById(accId, 1);
			if (accounts.get(0).CASA_Reference_Number__c == null) {
				return 'Error: CASA Reference Number cannot be blank - please do CASA Screening for this client first through one of their opportunities';
			}
			Id primaryContactId;
			if (accounts.get(0).Primary_Client__c == null) {
				return 'Error: At least 1 contact needs to be marked as a primary client - please amend on the account; ';
			} else {
				primaryContactId = accounts.get(0).Primary_Client__c;
				Set<Id> contactIdSet = new Set<Id>();
				contactIdSet.add(primaryContactId);
				List<Contact> contactList = new List<Contact>();
				contactList = new ContactsSelector().selectAccountIdBySetIds(contactIdSet);
				Id primaryContactAccId;
				if (!contactList.isEmpty() && contactList.size() > 0) {
					primaryContactAccId = contactList.get(0).AccountId;
				}
				//Validate if Primary client is also an account participant(related party)
				if (primaryContactAccId != null) {
					Boolean invalidParticipant = true;
					for (Account acc : participantAccounts) {
						if (acc.Id == primaryContactAccId) {
							invalidParticipant = false;
						}
					}
					if (invalidParticipant) {
						return 'Error: Please ensure your primary client is also listed as a related contact; ';
					}
				}
			}
			//Temp Fix to add period after title
			for (Account account : participantAccounts) {
				if (account.PersonTitle != null) {
					if (!account.PersonTitle.contains('.')) {
						account.PersonTitle = account.PersonTitle + '.';
					}
				}
			}
			//Joint Account Validations
			String validations = jointAccountValidationChecks(accounts, participantAccounts, primaryContactId);
			if (validations == 'Success') {
				String accountName = generateNameForJointAccount(participantAccounts);
				accounts.get(0).Name = accountName;
				Set<Id> conIds = new Set<Id>();
				conIds.add(primaryContactId);
				List<Contact> contactList = new List<Contact>();
				contactList = new ContactsSelector().selectAccountIdBySetIds(conIds);
				Id primaryContactAccountId;
				if (!contactList.isEmpty() && contactList.size() > 0) {
					primaryContactAccountId = contactList.get(0).AccountId;
				}
				CreateClientCIF_Resp_IB_v1 clientResp = CreateClientCIF_IH_v1.createBusinessClient(
					accounts.get(0),
					participantAccounts,
					primaryContactAccountId,
					'Business Client',
					'WILLS',
					accounts.get(0).OwnerId,
					nonCreditIndicatorList,
					creditIndicatorList
				);
				//Joint Party Response Checks
				if (
					clientResp.statusCode == 200 &&
					(clientResp.CIcreateClientV12Response.cib003o.outputCkey != '' ||
					clientResp.CIcreateClientV12Response.cib003o.outputCkey != null)
				) {
					accounts.get(0).CIF__c = clientResp.CIcreateClientV12Response.cib003o.outputCkey;
					accounts.get(0).RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
					update accounts.get(0);
					return 'Success';
				} else {
					return clientResp.message;
				}
			} else {
				return validations;
			}
		} else if (accounts.get(0).RecordType.Name == 'Individual Client' || accounts.get(0).RecordType.Name == 'Individual Prospect') {
			if (accounts.get(0).CASA_Reference_Number__pc == null) {
				return 'Error: CASA Reference Number cannot be blank - please do CASA Screening for this client first through one of their opportunities';
			}
			//Individual Validation checks
			String validations = individualValidationChecks(accounts);
			if (validations == 'Success') {
				CreateClientCIF_Resp_IB_v1 clientResp = CreateClientCIF_IH_v1.createIndividualClient(
					accounts.get(0),
					'WILLS',
					accounts.get(0).OwnerId,
					'Individual Client',
					nonCreditIndicatorList,
					creditIndicatorList
				);
				if (
					clientResp.statusCode == 200 &&
					(clientResp.CIcreateClientV12Response.cib003o.outputCkey != '' ||
					clientResp.CIcreateClientV12Response.cib003o.outputCkey != null)
				) {
					accounts.get(0).CIF__c = clientResp.CIcreateClientV12Response.cib003o.outputCkey;
					accounts.get(0).RecordTypeId = Account.sObjectType.getDescribe()
						.getRecordTypeInfosByDeveloperName()
						.get('Individual_Client')
						.getRecordTypeId();
					update accounts.get(0);
					return 'Success';
				} else {
					return clientResp.message;
				}
			} else {
				return validations;
			}
		}
		return 'Error: Unknown Error has occured';
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-10-19
	 * @param paricipantAccounts
	 * @return String
	 **/
	private static String generateNameForJointAccount(List<Account> paricipantAccounts) {
		Account firstAccount = paricipantAccounts.get(0);
		Account secondAccount = paricipantAccounts.get(1);
		String firstAccountInitials = '';
		if (firstAccount.MiddleName == null) {
			firstAccountInitials = firstAccount.FirstName.substring(0, 1);
		} else {
			firstAccountInitials = firstAccount.FirstName.substring(0, 1) + firstAccount.MiddleName.substring(0, 1);
		}
		String secondAccountInitials = '';
		if (secondAccount.MiddleName == null) {
			secondAccountInitials = secondAccount.FirstName.substring(0, 1);
		} else {
			secondAccountInitials = secondAccount.FirstName.substring(0, 1) + secondAccount.MiddleName.substring(0, 1);
		}
		return (firstAccount.LastName +
			' ' +
			firstAccount.PersonTitle.replace('.', '') +
			' ' +
			firstAccountInitials +
			' & ' +
			secondAccount.LastName +
			' ' +
			secondAccount.PersonTitle.replace('.', '') +
			' ' +
			secondAccountInitials)
			.toUpperCase();
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-10-19
	 * @param accounts
	 * @param paricipantAccounts
	 * @param primaryContactId
	 * @return String
	 **/
	private static String jointAccountValidationChecks(List<Account> accounts, List<Account> paricipantAccounts, Id primaryContactId) {
		String errorMessage = '';
		Boolean isError = false;
		//Todo remove this when proper field is determined
		String validTitles = '';
		Map<String, Integration_Translation__c> titleMap = new Map<String, Integration_Translation__c>();
		for (Integration_Translation__c title : [
			SELECT Id, Internal_Value__c
			FROM Integration_Translation__c
			WHERE Direction__c = 'Outbound' AND Internal_Value__c != 'None' AND System_Name__c = 'CIF' AND Value_Type__c = 'Title'
		]) {
			titleMap.put(title.Internal_Value__c, title);
			validTitles += title.Internal_Value__c + ' ';
		}
		Set<Id> personContactIdSet = new Set<Id>();
		for (Account acc : paricipantAccounts) {
			personContactIdSet.add(acc.PersonContactId);
		}
		List<Account> accNames = new List<Account>();
		accNames = new AccountsSelector().selectCasaFieldsByPersonContactSetId(personContactIdSet);
		Integer numContacts = 0;
		Integer numErrors = 0;
		Boolean isPrimaryAdded = false;
		String participantErrors = '';
		for (Account account : paricipantAccounts) {
			participantErrors = '';
			numContacts++;
			numErrors = 0;
			String accName = 'No Name';
			if (account.FirstName == null || account.LastName == null) {
				participantErrors += 'First Name or Last Name cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.FirstName == null && account.LastName == null) {
				for (Account accN : accNames) {
					if (account.Id == accN.Id) {
						accName = account.FirstName + ' ' + account.LastName;
					}
				}
			}
			if (account.PersonTitle == null) {
				participantErrors += 'Title cannot be blank; ';
				numErrors++;
				isError = true;
			} else {
				if (!Test.isRunningTest()) {
					if (!titleMap.containsKey(account.PersonTitle)) {
						participantErrors += 'Invalid Title - valid titles are: ' + validTitles + '; ';
						numErrors++;
						isError = true;
					}
				}
			}
			if (account.Communication_Language__pc == null) {
				participantErrors += 'Communication Language cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.Occupation_Status__pc == null) {
				participantErrors += 'Occupation Status cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.Occupation_Category__pc == null) {
				participantErrors += 'Occupation Category cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.Preferred_Communication_Method__pc == null) {
				participantErrors += 'Preferred Communication Method cannot be blank; ';
				numErrors++;
				isError = true;
			} else {
				if (account.Preferred_Communication_Method__pc == 'Email' && account.PersonEmail == null) {
					participantErrors += 'Email cannot be blank if the preferred communication method is set to email; ';
					numErrors++;
					isError = true;
				} else if (
					account.Preferred_Communication_Method__pc == 'Phone' &&
					(account.PersonHomePhone == null &&
					account.PersonMobilePhone == null &&
					account.Phone == null)
				) {
					participantErrors += 'At least one phone needs to be added if the preferred communication method is set to phone; ';
					numErrors++;
					isError = true;
				} else if (account.Preferred_Communication_Method__pc == 'SMS' && account.Phone == null) {
					participantErrors += 'Mobile Phone cannot be blank if the preferred communication method is set to SMS; ';
					numErrors++;
					isError = true;
				}
			}
			if (account.PersonHomePhone == null && account.PersonMobilePhone == null && account.Phone == null) {
				participantErrors += 'At least one phone number must be added; ';
				numErrors++;
				isError = true;
			}
			if (account.ShippingStreet == null) {
				participantErrors += 'Shipping Street cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.ShippingCity == null) {
				participantErrors += 'Shipping City cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.ShippingPostalCode == null) {
				participantErrors += 'Shipping Postal Code cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.ShippingCountry == null) {
				participantErrors += 'Shipping Country cannot be blank; ';
				numErrors++;
				isError = true;
			}
			if (account.Id == primaryContactId) {
				if (account.PersonMobilePhone == null) {
					participantErrors += 'Mobile phone number is required; ';
					numErrors++;
					isError = true;
				}
			}
			if (numErrors > 1) {
				participantErrors = 'Please fix the following errors for: ' + accName + ' - ' + participantErrors;
			} else if (numErrors == 1) {
				participantErrors = 'Please fix the following error for: ' + accName + ' - ' + participantErrors;
			}
			errorMessage += participantErrors;
		}
		if (numContacts < 2) {
			errorMessage += 'Error: At least 2 related contacts need to be created; ';
			isError = true;
		}
		if (isError) {
			return errorMessage;
		} else {
			return 'Success';
		}
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-10-19
	 * @param accounts
	 * @return String
	 **/
	private static String individualValidationChecks(List<Account> accounts) {
		if (accounts.get(0).ID_Type__pc == 'Passport') {
			if (accounts.get(0).Country_of_Origin__pc == null) {
				return 'Error: Country Passport cannot be blank if ID Type is Passport - please amend on the account';
			}
			if (accounts.get(0).Passport_Number__pc == null) {
				return 'Error: Passport Number cannot be blank if ID Type is Passport - please amend on the account';
			}
		}
		if (
			accounts.get(0).Occupation_Status__pc == 'Full Time Employed' ||
			accounts.get(0).Occupation_Status__pc == 'Self Employed-Non-Professional' ||
			accounts.get(0).Occupation_Status__pc == 'Self Employed Professional' ||
			accounts.get(0).Occupation_Status__pc == 'Part Time Employed' ||
			accounts.get(0).Occupation_Status__pc == 'Temporary Employed'
		) {
			Set<Id> contactIdSet = new Set<Id>();
			contactIdSet.add(accounts.get(0).PersonContactId);
			List<Contact> contactList = new List<Contact>();
			contactList = new ContactsSelector().selectAccountIdBySetIds(contactIdSet);
			List<Address__c> addresses = new List<Address__c>();
			Boolean invalidEmployeeAddress = true;
			if (!contactList.isEmpty() && contactList.size() > 0) {
				addresses = new AddressesSelector().addressesRelatedToContact(contactList.get(0).Id);
			}
			if (!addresses.isEmpty() && addresses.size() > 0) {
				for (Address__c add : addresses) {
					if (add.Address_Type__c == 'Employers') {
						invalidEmployeeAddress = false;
					}
				}
			}
			if (invalidEmployeeAddress) {
				return 'Error: If the Occupation status is "Full Time Employed", "Self Employed Non Professional", "Self Employed Professional","Part Time Employed", "Temporary Employed" then the employers address must be added onto the Address related list - please amend on the account';
			}
		}
		if (accounts.get(0).Non_Credit_Marketing_Consent__pc == null) {
			return 'Error: Non-Credit Marketing Consent must be completed - please amend on the account';
		} else if (accounts.get(0).Non_Credit_Marketing_Consent__pc == 'Yes') {
			if (accounts.get(0).Non_Credit_Marketing_Indicator__pc == null) {
				return 'Error: If Non-Credit Marketing Consent is "Yes" then atleast one Non-Credit Marketing Indicator must be selected - please amend on the account';
			}
		}
		if (accounts.get(0).Credit_Marketing_Consent__pc == null) {
			return 'Error: Credit Marketing Consent must be completed - please amend on the account';
		} else if (accounts.get(0).Credit_Marketing_Consent__pc == 'Yes') {
			if (accounts.get(0).Credit_Marketing_Indicator__pc == null) {
				return 'Error: If Credit Marketing Consent is "Yes" then atleast one Credit Marketing Indicator must be selected - please amend on the account';
			}
		}
		if (accounts.get(0).Monthly_Income__pc == null) {
			return 'Error: Monthly Income is required when submitting to CIF and must be completed - please amend on the account';
		}
		if (accounts.get(0).Communication_Language__pc == null) {
			return 'Error: Communication Language cannot be blank - please amend on the account';
		}
		if (accounts.get(0).ShippingStreet == null) {
			return 'Error: Shipping Street cannot be blank - please amend on the account';
		}
		if (accounts.get(0).ShippingCity == null) {
			return 'Error: Shipping City cannot be blank - please amend on the account';
		}
		if (accounts.get(0).ShippingPostalCode == null) {
			return 'Error: Shipping Postal Code cannot be blank - please amend on the account';
		}
		if (accounts.get(0).ShippingCountry == null) {
			return 'Error: Shipping Country cannot be blank - please amend on the account';
		}
		if (accounts.get(0).BillingStreet == null) {
			return 'Error: Billing Street cannot be blank - please amend on the account';
		}
		if (accounts.get(0).BillingCity == null) {
			return 'Error: Billing City cannot be blank - please amend on the account';
		}
		if (accounts.get(0).BillingPostalCode == null) {
			return 'Error: Billing Postal Code cannot be blank - please amend on the account';
		}
		if (accounts.get(0).BillingCountry == null) {
			return 'Error: Billing Country cannot be blank - please amend on the account';
		}
		if (accounts.get(0).Preferred_Communication_Method__pc == null) {
			return 'Error: Preferred Communication Method cannot be blank - please amend on the account';
		} else {
			if (accounts.get(0).Preferred_Communication_Method__pc == 'Email' && accounts.get(0).PersonEmail == null) {
				return 'Error: Email cannot be blank if the preferred communication method is set to email - please amend on the account';
			} else if (
				accounts.get(0).Preferred_Communication_Method__pc == 'Phone' &&
				(accounts.get(0).PersonHomePhone == null &&
				accounts.get(0).PersonOtherPhone == null &&
				accounts.get(0).PersonMobilePhone == null)
			) {
				return 'Error: At least one phone needs to be added if the preferred communication method is set to phone - please amend on the account';
			} else if (accounts.get(0).Preferred_Communication_Method__pc == 'SMS' && accounts.get(0).PersonMobilePhone == null) {
				return 'Error: Mobile Phone cannot be blank if the preferred communication method is set to SMS - please amend on the account';
			}
		}
		if (accounts.get(0).Marital_Status__pc == null) {
			return 'Error: Marital Status cannot be blank - please amend on the account';
		}
		return 'Success';
	}
}