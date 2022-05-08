/**
 * @description       :  Helper class for CVS ServiceCalls/This class has methods used by Aura components to call the CVS services(CVSValidate/CVSCreate/CVSValidate)
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-10-11
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @modified 2021-06-28 - Aaron Castelyn : ABSA - Added Residential and Postal Street 2
 * 1.0   2021-07-23   PaulJohn.duRand@absa.africa    Add Customer Type for CIF New To Product and New to Salesforce
 * 1.0   2021-08-31   PaulJohn.duRand@absa.africa    New GetClientDetailsByIdCIF Implementation
 * 1.0   2021-09-21   PaulJohn.duRand@absa.africa    Always Update Client Group from CIF
 * 1.0   2021-09-28   PaulJohn.duRand@absa.africa    Set Marketing select to empty when Consent is N
 * 1.0   2021-10-11   PaulJohn.duRand@absa.africa    Enable Staff
 **/

public without sharing class BranchCIFSalesforceSyncHelper {
	/**
	 * @description Function used to populate account object with CIF data
	 * @param accountid
	 * @param cifCode
	 * @param idnumber
	 * @return string
	 */
	public static string UpdateAccountwithCIF(String accountid, String cifCode, String idnumber) {
		if (accountid == '') {
			List<Account> cifAccountList = new List<Account>();
			if (cifCode != '') {
				cifAccountList = new AccountsSelector().selectByCIF(cifCode, 1);
			}
			if (cifAccountList.size() == 1) {
				accountid = cifAccountList[0].id;
			} else {
				List<Account> cifAccountListbyid;
				cifAccountListbyid = new AccountsSelector().selectByIdNumber(IdNumber, 1);
				if (cifAccountList.size() == 1) {
					accountid = cifAccountList[0].id;
				} else {
					String accID = BranchCIFSalesforceSyncHelper.updateCreateAccount(null, cifCode);
					BranchCIFSalesforceSyncHelper.setIdDerived(accID);
					return accID;
				}
			}
		} else {
			if (cifCode == null || cifCode == '') {
				cifCode = BranchCIFSalesforceSyncHelper.accountCIF(accountid);
				if (cifCode == null) {
					cifCode = BranchCIFSalesforceSyncHelper.getCIFCode(accountid);
				}
			}
		}
		if (cifCode != null) {
			return BranchCIFSalesforceSyncHelper.UpdateCreateAccount(accountid, cifCode);
		} else {
			BranchCIFSalesforceSyncHelper.setIdDerived(accountid);
			return accountid;
		}
	}

	/**
	 * @description Function to get CIF code
	 * @param accountid
	 * @return string
	 */
	public static string accountCIF(Id accountid) {
		Account account = [SELECT CIF__c FROM Account WHERE Account.Id = :accountId WITH SECURITY_ENFORCED];
		if (account.CIF__c != null) {
			return account.CIF__c;
		} else {
			return null;
		}
	}

	/**
	 * @description Function to get CIF code
	 * @param accountid
	 * @return string
	 */
	public static String getCIFCode(Id accountid) {
		Account account = [SELECT ID_Number__pc FROM Account WHERE Account.Id = :accountId WITH SECURITY_ENFORCED];
		try {
			GetClientDetailsByIdCIF_Req_IB_v2 request = new GetClientDetailsByIdCIF_Req_IB_v2();
			request.CIgetClientDetailsByIDNOV2 = request.getNewInstance();
			request.CIgetClientDetailsByIDNOV2.cip008i.idNbr = account.ID_Number__pc;
			request.CIgetClientDetailsByIDNOV2.cip008i.inpIdDocType = '01';
			request.CIgetClientDetailsByIDNOV2.cip008i.inpCifClntGroup = 'I';
			request.CIgetClientDetailsByIDNOV2.cip008i.inpCifClntType = '';
			string usr = System.UserInfo.getUserId();
			User userInfo = [SELECT SiteCode__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
			request.CIgetClientDetailsByIDNOV2.cip008i.siteCode = userInfo.SiteCode__c;
			GetClientDetailsByIdCIF_Resp_IB_v2 response = GetClientDetailsByIdCIF_IH_v2.GetCIFCodebyId(request.CIgetClientDetailsByIDNOV2.cip008i);
			if (response.CIgetClientDetailsByIDNOV2Response.Cip008o.nbrEntsRetrieved != '0') {
				return response.CIgetClientDetailsByIDNOV2Response.Cip008o.tblEntry[0].cifKey;
			} else {
				return null;
			}
		} catch (Exception ex) {
			return null;
		}
	}
	/**
	 * @description Function to get CIF code
	 * @param accountid
	 * @param cifCode
	 * @return string
	 */
	public static string updateCreateAccount(Id accountid, string cifCode) {
		Boolean isNewtoSalesforce = false;
		Account account;
		if (accountid != null) {
			account = new AccountsSelector().selectAllById(accountID);
			if (cifCode == null) {
				cifCode = account.CIF__c;
			} else {
				account.CIF__c = cifCode;
			}
		} else {
			account = new Account();
			isNewtoSalesforce = true;
			account.CIF__c = cifCode;
		}
		CIgetClientDetailsV12_Resp_IB_v1 clientResponse = BranchCIFSalesforceSyncHelper.getUpdateAccount(cifCode);
		if (clientResponse.statusCode == 200) {
			return UpdateWithCIF(account, clientResponse, isNewtoSalesforce);
		}
		return account.id;
	}

	/**
	 * @description Function to get CIF code
	 * @param account
	 * @param clientResponse
	 * @param isNewtoSalesforce
	 * @return string
	 */
	public static string updateWithCIF(Account account, CIgetClientDetailsV12_Resp_IB_v1 clientResponse, Boolean isNewtoSalesforce) {
		if (clientResponse.birthDate != '0') {
			account.PersonBirthdate = BranchCIFSalesforceSyncHelper.getDateForSalesforceYearFirst(clientResponse.birthDate);
		}
		if (clientResponse.dateIssued != '0') {
			account.Date_Issued__pc = BranchCIFSalesforceSyncHelper.getDateForSalesforceDayFirst(clientResponse.dateIssued);
		}
		if (clientResponse.dateIdentified != '0') {
			account.Date_Identified__c = BranchCIFSalesforceSyncHelper.getDateForSalesforceDayFirst(clientResponse.dateIdentified);
		}
		account.Identified_by_Employee_Number__c = clientResponse.employeeIdentified;

		//Customer Personal information
		if (clientResponse.titleCode != '0') {
			account.Titles__pc = clientResponse.titleCode;
		}
		account.FirstName = setTextInNameFormat(clientResponse.firstNames);
		account.LastName = setTextInNameFormat(clientResponse.surname);
		account.PersonBirthdate = BranchCIFSalesforceSyncHelper.getBirthdayDateFromId(account.ID_Number__pc);
		account.Gender__pc = BranchCIFSalesforceSyncHelper.getGenderfromId(account.ID_Number__pc);
		account.Country_of_Birth__pc = clientResponse.countryOfBirth;
		account.Home_Language__pc = clientResponse.homeLanguage;
		account.Nationality_List__pc = clientResponse.clientNationality;
		account.Id_Number__pc = clientResponse.idNumber;
		account.PersonMobilePhone = String.valueOf(clientResponse.cellphone.leftPad(10, '0'));
		if (clientResponse.maritalStatus != '0') {
			account.Marital_Status__pc = clientResponse.maritalStatus;
		}
		if (clientResponse.mariageContrctType != '0') {
			account.Marital_Contract_Type__pc = clientResponse.mariageContrctType;
		}
		//Customer Contact detailsP
		account.PersonEmail = clientResponse.emailAddress;

		if (clientResponse.prefrdCommtionMthd != '0') {
			account.Preferred_Communication_Method__pc = clientResponse.prefrdCommtionMthd;
		}
		if (clientResponse.language != '') {
			account.Communication_Language__pc = clientResponse.language;
		}
		if (clientResponse.homeLanguage != '') {
			account.Home_Language__pc = clientResponse.homeLanguage;
		}
		if (clientResponse.sourceOfIncome != '0') {
			account.Income_Source__pc = clientResponse.sourceOfIncome;
		}
		//Next of Kin
		account.Next_of_Kin_First_Name_s__pc = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.nkinFname);
		account.Next_of_Kin_Last_Name__pc = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.nkinSurname);
		if (clientResponse.nkinRela != '0') {
			account.Next_of_kin_Relationship__pc = clientResponse.nkinRela;
		}
		account.Next_of_Kin_Cellphone_Number__pc = clientResponse.nkinCell;
		account.Next_of_Kin_Email_Address__pc = clientResponse.nkinEmail;
		//Employer
		if (clientResponse.occupationStatus != '0') {
			account.Occupation_Status__pc = clientResponse.occupationStatus;
		}
		if (clientResponse.employmentSector != '0') {
			account.Employer_Sector__pc = clientResponse.employmentSector;
		}
		if (clientResponse.occupationLevel != '0') {
			account.Occupation_Level__pc = clientResponse.occupationLevel;
		}
		if (clientResponse.occupationCode != '0') {
			account.Occupation_Category__pc = clientResponse.occupationCode;
		}
		if (clientResponse.postMatricQualifd == 'Y') {
			account.Post_Matric_Qualification__pc = clientResponse.postMatricQualfton;
		}

		if (clientResponse.addressEntry != null) {
			for (CIgetClientDetailsV12_Resp_IB_v1.AddressEntry addressEntry : clientResponse.addressEntry) {
				if (addressEntry.addrType == '70') {
					account.Employer_Name__pc = addressEntry.addrLine1;
				}
			}
		}
		account.Is_customer_registered_for_income_tax__c = clientResponse.saTaxRegis == 'Y' ? true : false;
		account.Income_Tax_Number__pc = clientResponse.taxNumber != null ? clientResponse.taxNumber : '0';
		account.Income_Tax_Number_Reason__pc = clientResponse.rsonSaTaxNotGiven != null ? clientResponse.rsonSaTaxNotGiven : '';

		BranchCIFSalesforceSyncHelper.setMarketingConsent(account, clientResponse);
		account.ID_Type__pc = clientResponse.idDocType;
		if (clientResponse.clientGroup == 'Individual') {
			account.Client_Group__c = clientResponse.clientGroup;
			String clientTypeCodeWithDocCode = clientResponse.clientType;
			String docCode  = clientTypeCodeWithDocCode.right(2);
			String clientTypeCode = clientTypeCodeWithDocCode.removeEnd(docCode).leftPad(3, '0');
			string clientType = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
				'CIFCodesList',
				'IndividualCustomertype',
				clientTypeCode,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			account.Client_Type__c = clientType;
		}
		
		//required for Valid_Update validation rule
		account.Valid_Update_Bypass__c = true;

		if (account.LastName != null) {
			if (isNewtoSalesforce) {
				insert account;
			} else {
				update account;
			}
		}

		if (clientResponse.addressEntry != null) {
			for (CIgetClientDetailsV12_Resp_IB_v1.AddressEntry addressEntry : clientResponse.addressEntry) {
				switch on addressEntry.addrType {
					when '10' {
						BranchCIFSalesforceSyncHelper.updateAddress(account.id, 'Residential', addressEntry);
					}
					when '70' {
						BranchCIFSalesforceSyncHelper.updateAddress(account.id, 'Employers', addressEntry);
					}
				}
			}
			Address__c postalAddress = BranchCIFSalesforceSyncHelper.getAddress(account.id, 'Postal');
			postalAddress.Shipping_Street__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.postlAddrLine1);
			postalAddress.Shipping_Street_2__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.postlAddrLine2);
			postalAddress.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.postlSuburb);
			postalAddress.Shipping_City__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(clientResponse.postlTown);
			clientResponse.postlCodeRsa = clientResponse.postlCodeRsa.leftPad(4, '0');
			postalAddress.Shipping_Zip_Postal_Code__c = clientResponse.postlCodeRsa;
			update postalAddress;
		}
		return account.id;
	}
	/**
	 * @description Function to get CIF code
	 * @param account
	 * @param clientResponse
	 */
	public static void setMarketingConsent(Account account, CIgetClientDetailsV12_Resp_IB_v1 clientResponse) {
		if (clientResponse.creditIndicator != null) {
			account.Credit_Marketing_Consent__pc = clientResponse.creditIndicator == 'Y' ? 'Yes' : 'No';
			if (clientResponse.creditIndicator == 'Y') {
				List<String> creditMarketingList = new List<String>();
				if (clientResponse.creditSms == 'Y') {
					creditMarketingList.add('SMS');
				}
				if (clientResponse.creditEmail == 'Y') {
					creditMarketingList.add('Email');
				}
				if (clientResponse.creditAvoice == 'Y') {
					creditMarketingList.add('Voice Recording');
				}
				if (clientResponse.creditPost == 'Y') {
					creditMarketingList.add('Mail');
				}
				if (clientResponse.creditTelephone == 'Y') {
					creditMarketingList.add('Telephone');
				}
				account.Credit_Marketing_Indicator__pc = BranchCIFSalesforceSyncHelper.getMultiSelectAsString(creditMarketingList);
			}else{
				account.Credit_Marketing_Indicator__pc = '';
			}
		}

		if (clientResponse.nonCreditIndicator != null) {
			account.Non_Credit_Marketing_Consent__pc = clientResponse.nonCreditIndicator == 'Y' ? 'Yes' : 'No';
			if (clientResponse.nonCreditIndicator == 'Y') {
				List<String> noncreditMarketingList = new List<String>();
				if (clientResponse.nonCreditSms == 'Y') {
					noncreditMarketingList.add('SMS');
				}
				if (clientResponse.nonCreditEmail == 'Y') {
					noncreditMarketingList.add('Email');
				}
				if (clientResponse.nonCreditAvoice == 'Y') {
					noncreditMarketingList.add('Voice Recording');
				}
				if (clientResponse.nonCreditPost == 'Y') {
					noncreditMarketingList.add('Mail');
				}
				if (clientResponse.nonCreditTelephone == 'Y') {
					noncreditMarketingList.add('Telephone');
				}
				account.Non_Credit_Marketing_Indicator__pc = BranchCIFSalesforceSyncHelper.getMultiSelectAsString(noncreditMarketingList);
			} else {
				account.Non_Credit_Marketing_Indicator__pc = '';
			}
		}
	}
	/**
	 * @description Function to get CIF code
	 * @param stringList
	 * @return string
	 */
	public static string getMultiSelectAsString(List<String> stringList) {
		Boolean firstAdded = true;
		String consentItems = '';
		for (String item : stringList) {
			if (!firstAdded) {
				consentItems = consentItems + ';' + item;
			} else {
				consentItems = consentItems + item;
				firstAdded = false;
			}
		}
		return consentItems;
	}
	/**
	 * @description Method that updates CIgetClientDetailsV12_Resp_IB_v1 address to Salesforce Address
	 * @param accountId
	 * @param addressType
	 * @param addressEntry
	 */
	public static void updateAddress(String accountId, String addressType, CIgetClientDetailsV12_Resp_IB_v1.AddressEntry addressEntry) {
		Address__c address = BranchCIFSalesforceSyncHelper.getAddress(accountId, addressType);
		if (addressType != 'Employers') {
			address.Shipping_Street__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(addressEntry.addrLine1);
			address.Shipping_Street_2__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(addressEntry.addrLine2);
		} else {
			address.Shipping_Street__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(addressEntry.addrLine2);
		}
		address.Shipping_Suburb__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(addressEntry.addrSuburbRsa);
		address.Shipping_City__c = BranchCIFSalesforceSyncHelper.setTextInNameFormat(addressEntry.addrTown);
		addressEntry.addrPostlCode = addressEntry.addrPostlCode.leftPad(4, '0');
		address.Shipping_Zip_Postal_Code__c = addressEntry.addrPostlCode;
		update Address;
	}
	/**
	 * @description Function that Gets/Creates address;
	 * @param accountId
	 * @param addressType
	 * @return string
	 */
	public static Address__c getAddress(String accountId, String addressType) {
		list<string> addresslist = new List<string>();
		addresslist.add(addressType);
		Map<String, String> addressMap = BranchCustomerAddressHelper.getAddresses(accountId, addresslist);
		String addressId = addressMap.get(addressType);
		Address__c address = [
			SELECT Id, Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Id = :addressId
			WITH SECURITY_ENFORCED
		];
		return address;
	}
	/**
	 * @description Method to set dirived values for SA ID
	 * @param accountid
	 */
	public static void setIdDerived(string accountid) {
		Account account;
		account = [SELECT Account.Id, ID_Number__pc FROM Account WHERE Account.Id = :accountid WITH SECURITY_ENFORCED];
		account.PersonBirthdate = BranchCIFSalesforceSyncHelper.getBirthdayDateFromId(account.ID_Number__pc);
		account.Gender__pc = BranchCIFSalesforceSyncHelper.getGenderfromId(account.ID_Number__pc);

		//required for Valid_Update validation rule
		account.Valid_Update_Bypass__c = true;
		
		update account;
	}
	/**
	 * @description Function that calls the CIgetClientDetailsV12 service and returns Response Bean
	 * @param cifCode
	 * @return CIgetClientDetailsV12_Resp_IB_v1
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 getUpdateAccount(String cifCode) {
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT SiteCode__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
		CIgetClientDetailsV12_Resp_IB_v1 response = CIgetClientDetailsV12_IH_v1.CIgetClientDetailsV12(userInfo.SiteCode__c, cifCode, 0);
		return response;
	}
	/**
	 * @description Function that calls the CIgetClientDetailsV12 service and returns Response Bean
	 * @param incomingDate
	 * @return Date
	 */
	public static Date getDateForSalesforceYearFirst(String incomingDate) {
		return getDateForSalesforce(incomingDate, true);
	}

	/**
	 * @description Function that calls the CIgetClientDetailsV12 service and returns Response Bean
	 * @param incomingDate
	 * @return Date
	 */
	public static Date getDateForSalesforceDayFirst(String incomingDate) {
		incomingDate = incomingDate.leftPad(8, '0');
		return getDateForSalesforce(incomingDate, false);
	}

	/**
	 * @description Function to convert date to from CVS get to Salesforce date
	 * @param incomingDate
	 * @param isYearFirst
	 * @return Date
	 */
	public static Date getDateForSalesforce(String incomingDate, Boolean isYearFirst) {
		try {
			Pattern p = (isYearFirst) ? pattern.compile('(\\d{4})(\\d{2})(\\d{2})') : pattern.compile('(\\d{2})(\\d{2})(\\d{4})');
			Matcher m = p.matcher(incomingDate);
			m.find();
			Integer year = (isYearFirst) ? Integer.valueOf(m.group(1)) : Integer.valueOf(m.group(3));
			Integer month = Integer.valueOf(m.group(2));
			Integer day = (isYearFirst) ? Integer.valueOf(m.group(3)) : Integer.valueOf(m.group(1));
			Date d = Date.newInstance(year, month, day);
			return d;
		} catch (Exception ex) {
			return null;
		}
	}

	/**
	 * @description Function to convert date to from CVS get to Salesforce date
	 * @param name
	 * @return String
	 */
	public static String setTextInNameFormat(String name) {
		if (Name != null) {
			name = name.toLowerCase();
			List<String> names = name.split(' ');
			for (Integer i = 0; i < names.size(); i++) {
				names[i] = names[i].capitalize();
			}
			name = String.join(names, ' ');
			return name;
		} else {
			return '';
		}
	}

	/**
	 * @description Function to derive DOB from SA ID number
	 * @param id
	 * @return String
	 */
	public static Date getBirthdayDateFromId(String id) {
		try {
			String dob = id.LEFT(6);
			Pattern p = pattern.compile('(\\d{2})(\\d{2})(\\d{2})');
			Matcher m = p.matcher(dob);
			m.find();

			Date dateToday = Date.today();
			String currentyear = String.valueof(dateToday.year()).Right(2);
			Integer currentyearint = Integer.valueOf(currentyear);
			Integer idYear = Integer.valueOf(m.group(1));
			Integer birthdayYear;

			if (currentyearint >= idYear) {
				birthdayYear = idYear + 2000;
			} else {
				birthdayYear = idYear + 1900;
			}
			Integer year = birthdayYear, month = Integer.valueOf(m.group(2)), day = Integer.valueOf(m.group(3));
			Date d = Date.newInstance(year, month, day);
			return d;
		} catch (Exception ex) {
			return null;
		}
	}

	/**
	 * @description Function to derive gender from SA ID number
	 * @param idNumber
	 * @return String
	 */
	public static string getGenderfromId(String idNumber) {
		try {
			String genderIdentifier = idNumber.MID(6, 4);
			integer genderIdentifierNumber = Integer.valueOf(genderIdentifier);
			if (genderIdentifierNumber < 5000) {
				return 'Female';
			} else {
				return 'Male';
			}
		} catch (Exception ex) {
			return null;
		}
	}
}