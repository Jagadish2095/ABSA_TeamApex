/**
 * @description Integration Utilities for Create Client in CIF
 * @author Danie Booysen
 * @created 2018-12-07
 */

public class CreateClientCIF_IU_v1 {
	/**
	 * @description Individual Client
	 * @param accountP
	 * @param appliationP
	 * @param userP
	 * @param tanslationValueMapP
	 * @param addressBeanP
	 * @param branchP
	 * @param nonCreditMarketIndP
	 * @param creditMarketIndP
	 * @return CreateClientCIF_Req_IB_v1
	 */
	public static CreateClientCIF_Req_IB_v1 mapIndividualClientRequestFields(
		Account accountP,
		String appliationP,
		User userP,
		Map<String, String> tanslationValueMapP,
		CvsValidationService_Resp_IB_v1 addressBeanP,
		String branchP,
		List<String> nonCreditMarketIndP,
		List<String> creditMarketIndP
	) {
		CreateClientCIF_Req_IB_v1 requestBean = new CreateClientCIF_Req_IB_v1();

		requestBean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
		requestBean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
		requestBean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
		requestBean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
		//requestBean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
		//requestBean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
		//requestBean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

		//Mappings - Nbsapdpi
		requestBean.CIcreateClientV12.Nbsapdpi.application = appliationP;
		requestBean.CIcreateClientV12.Nbsapdpi.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.trace = 'N';

		//Mappings - Nbsmsgi
		requestBean.CIcreateClientV12.Nbsmsgi.msgLanguage = 'E';
		requestBean.CIcreateClientV12.Nbsmsgi.msgTarget = 'STD';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgCode = '';

		//Mappings - Cib003i
		requestBean.CIcreateClientV12.Cib003i.initials = accountP.Initials__pc.toUpperCase();
		if (tanslationValueMapP.get('comLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.language = tanslationValueMapP.get('comLanguageTranslated'); //Translation
		}
		if (tanslationValueMapP.get('personTitleTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.titleCode = tanslationValueMapP.get('personTitleTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.surname = accountP.LastName.toUpperCase();

		if (tanslationValueMapP.get('idTypeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.idType = tanslationValueMapP.get('idTypeTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.idNumber = accountP.ID_Number__pc;

		if (accountP.PersonBirthdate != null) {
			requestBean.CIcreateClientV12.Cib003i.birthDate = String.valueOf(accountP.PersonBirthdate).replace('-', '');
		}
		if (tanslationValueMapP.get('maritalStatusTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.maritalStatus = tanslationValueMapP.get('maritalStatusTranslated'); //Translation
		}
		if (tanslationValueMapP.get('genderTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.gender = tanslationValueMapP.get('genderTranslated'); //Translation
		}
		if (tanslationValueMapP.get('occupaionCodeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.branchClientOpen = branchP;
		if (userP.BRID__c != null) {
			requestBean.CIcreateClientV12.Cib003i.tellerLastChanged = userP.BRID__c.subString(2); //'09999996'
		}
		if (tanslationValueMapP.get('maritalContractTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.mariageContrctType = tanslationValueMapP.get('maritalContractTranslated'); //Translation
		}
		//Non-Credit Marketing
		if (tanslationValueMapP.get('nonCreditMarketConsentTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.ncrInd = tanslationValueMapP.get('nonCreditMarketConsentTranslated'); //Translation

			requestBean.CIcreateClientV12.Cib003i.ncrEmail = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrPost = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrTel = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrSms = 'N';

			if (nonCreditMarketIndP != null) {
				for (String indicator : nonCreditMarketIndP) {
					switch on indicator {
						when 'Email' {
							requestBean.CIcreateClientV12.Cib003i.ncrEmail = 'Y';
						}
						when 'Mail' {
							requestBean.CIcreateClientV12.Cib003i.ncrPost = 'Y';
						}
						when 'Phone' {
							requestBean.CIcreateClientV12.Cib003i.ncrTel = 'Y';
						}
						when 'SMS' {
							requestBean.CIcreateClientV12.Cib003i.ncrSms = 'Y';
						}
					} //End of switch case
				} //End of for loop
			}
		} //End of IF

		//Credit Marketing Consent
		if (tanslationValueMapP.get('creditMarketConsentTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.crInd = tanslationValueMapP.get('creditMarketConsentTranslated'); //Translation

			requestBean.CIcreateClientV12.Cib003i.crPost = 'N';
			requestBean.CIcreateClientV12.Cib003i.crTel = 'N';
			requestBean.CIcreateClientV12.Cib003i.crAvoice = 'N';
			requestBean.CIcreateClientV12.Cib003i.crEmail = 'N';
			requestBean.CIcreateClientV12.Cib003i.crSms = 'N';

			if (creditMarketIndP != null) {
				for (String indicator : creditMarketIndP) {
					switch on indicator {
						when 'Mail' {
							requestBean.CIcreateClientV12.Cib003i.crPost = 'Y';
						}
						when 'Phone' {
							requestBean.CIcreateClientV12.Cib003i.crTel = 'Y';
						}
						when 'Voice Recording' {
							requestBean.CIcreateClientV12.Cib003i.crAvoice = 'Y';
						}
						when 'Email' {
							requestBean.CIcreateClientV12.Cib003i.crEmail = 'Y';
						}
						when 'SMS' {
							requestBean.CIcreateClientV12.Cib003i.crSms = 'Y';
						}
					} //End of switch case
				} //End of for loop
			}
		} //End of IF

		requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated'); //Translation
		requestBean.CIcreateClientV12.Cib003i.miltaryComtmntInd = 'N';
		requestBean.CIcreateClientV12.Cib003i.occupancyType = '0'; //Translation = TBC

		if (accountP.FirstName != null && accountP.MiddleName != null) {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase() + ' ' + accountP.MiddleName.toUpperCase();
		} else {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase();
		}

		if (accountP.PersonHomePhone != null) {
			Integer homeNumberSize = accountP.PersonHomePhone.length();
			requestBean.CIcreateClientV12.Cib003i.homeTelCode = accountP.PersonHomePhone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.homeTelephone = accountP.PersonHomePhone.Substring(3, homeNumberSize);
		}
		if (accountP.Phone != null) {
			Integer workNumberSize = accountP.Phone.length();
			requestBean.CIcreateClientV12.Cib003i.workTelCode = accountP.Phone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.workTelephone = accountP.Phone.Substring(3, workNumberSize);
		}
		System.debug('accountP.PersonMobilePhone ' + accountP.PersonMobilePhone);
		if (accountP.PersonMobilePhone != null) {
			String phoneNumber = accountP.PersonMobilePhone;

			if (phoneNumber.length() > 10) {
				//Take last 10 Digits
				Integer numberLength = phoneNumber.length();
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
			} else if (phoneNumber.length() < 10) {
				//Add 0 infront until number is 10 digits
				while (phoneNumber.length() < 10) {
					phoneNumber = '0' + phoneNumber;
				}
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			} else {
				//Number is the correct length
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			}
		}
		System.debug('requestBean.cellphone ' + requestBean.CIcreateClientV12.Cib003i.cellphone);
		if (tanslationValueMapP.get('occupationStatusTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.emailAddress = accountP.PersonEmail;
		requestBean.CIcreateClientV12.Cib003i.cellphone = accountP.Phone;

		if (tanslationValueMapP.get('comMethodTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = tanslationValueMapP.get('comMethodTranslated'); //Translation
		}
		if (tanslationValueMapP.get('nationalityTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.clientNationality = tanslationValueMapP.get('nationalityTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.countryOfOrigin = tanslationValueMapP.get('countryOfOriginTranslated'); //Translation = TBC
		requestBean.CIcreateClientV12.Cib003i.dateExempted = '0'; //Zero until is business rule is provided
		requestBean.CIcreateClientV12.Cib003i.corporateDivision = 'A';
		requestBean.CIcreateClientV12.Cib003i.haveQualification = '0';
		requestBean.CIcreateClientV12.Cib003i.socialGrant = '0';
		requestBean.CIcreateClientV12.Cib003i.secondaryCard = 'N'; //Zero until is business rule is provided
		if (addressBeanP.addressCollection != null && addressBeanP.addressCollection.size() > 0) {
			for (CvsValidationService_Resp_IB_v1.cls_addressCollection addressP : addressBeanP.addressCollection) {
				if (addressP.addressTypeSF == 'Employers') {
					requestBean.CIcreateClientV12.Cib003i.employerAddrType = '70';
					requestBean.CIcreateClientV12.Cib003i.employerAdd1 = accountP.Employer_Name__pc;
					String addressLine;
					if (addressP.addressLine1 != null) {
						addressLine = addressP.addressLine1;
						if (addressP.addressLine2 != null) {
							addressLine += ' ' + addressP.addressLine2;
						}
					}
					requestBean.CIcreateClientV12.Cib003i.employerAdd2 = Sys_Utilities_General.truncateFieldIfNeeded(addressLine, 30);
					requestBean.CIcreateClientV12.Cib003i.employerTown = addressP.town;
					requestBean.CIcreateClientV12.Cib003i.employerSuburb = addressP.suburb;
					requestBean.CIcreateClientV12.Cib003i.employerPostal = addressP.postalCode;
				}
				if (addressP.addressTypeSF == 'Physical') {
					requestBean.CIcreateClientV12.Cib003i.physicalAddrType = '10';
					requestBean.CIcreateClientV12.Cib003i.physicalAdd1 = addressP.addressLine1;
					requestBean.CIcreateClientV12.Cib003i.physicalAdd2 = addressP.addressLine2;
					requestBean.CIcreateClientV12.Cib003i.physicalTown = addressP.town;
					requestBean.CIcreateClientV12.Cib003i.physicalPostal = addressP.postalCode;
				}
				if (addressP.addressTypeSF == 'Postal') {
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine1 = addressP.addressLine1;
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine2 = addressP.addressLine2;
					requestBean.CIcreateClientV12.Cib003i.postlTown = addressP.town;
					requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = addressP.postalCode;
				}
			}
		}

		requestBean.CIcreateClientV12.Cib003i.thrdPartyInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updAddressInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updTelephoneInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updEmailInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updDateInd = '0'; //Default
		requestBean.CIcreateClientV12.Cib003i.casaRefNum = accountP.CASA_Reference_Number__pc;
		if (tanslationValueMapP.get('countryOfBirthTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.countryOfBirth = tanslationValueMapP.get('countryOfBirthTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'N';
		if (accountP.Income_Tax_Number__pc != null) {
			requestBean.CIcreateClientV12.Cib003i.taxNumber = String.valueOf(accountP.Income_Tax_Number__pc);
		}
		if (tanslationValueMapP.get('incomeSourceTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.sourceOfIncome = tanslationValueMapP.get('incomeSourceTranslated');
		}
		if (tanslationValueMapP.get('incomeGroupTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.incomeGroup = tanslationValueMapP.get('incomeGroupTranslated');
		}
		if (accountP.Date_Issued__pc != null) {
			requestBean.CIcreateClientV12.Cib003i.dateIssued = String.valueOf(accountP.Date_Issued__pc).replace('-', '');
		}
		if (tanslationValueMapP.get('homeLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.homeLanguage = tanslationValueMapP.get('homeLanguageTranslated'); //Translation
		}
		System.debug('CIF Create Client Request' + requestBean);
		return requestBean;
	}

	/**
	 * @description TdB - RBB Individual Mapping as its diffrent than what WILLS are using
	 * @param accountP
	 * @param appliationP
	 * @param userP
	 * @param tanslationValueMapP
	 * @param addressBeanP
	 * @param branchP
	 * @param nonCreditMarketIndP
	 * @param creditMarketIndP
	 * @return CreateClientCIF_Req_IB_v1
	 */
	public static CreateClientCIF_Req_IB_v1 mapRBBIndividualClientRequestFields(
		Account accountP,
		String appliationP,
		User userP,
		Map<String, String> tanslationValueMapP,
		CvsValidationService_Resp_IB_v1 addressBeanP,
		String branchP,
		List<String> nonCreditMarketIndP,
		List<String> creditMarketIndP
	) {
		CreateClientCIF_Req_IB_v1 requestBean = new CreateClientCIF_Req_IB_v1();
		AddressesSelector addrSelector = new AddressesSelector();
		List<Address__c> addressList = addrSelector.addressesRelatedToAcc(accountP.Id);

		//TdB - Use Jitterbit new structure
		requestBean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
		requestBean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
		requestBean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
		requestBean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
		requestBean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
		requestBean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
		requestBean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

		////Mappings - Nbsapdpi
		requestBean.CIcreateClientV12.Nbsapdpi.application = StringConstants.CUSTOMER1_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.trace = 'N';

		//Mappings - Nbsmsgi
		requestBean.CIcreateClientV12.Nbsmsgi.msgLanguage = 'E';
		requestBean.CIcreateClientV12.Nbsmsgi.msgTarget = 'STD';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgCode = '';

		//Mappings - Cib003i

		// Sole Trader specific fields to map (not applicable for individual)
		if (accountP.Client_Type__c.toUpperCase() == 'SOLE TRADER' || accountP.Client_Type__c.toUpperCase() == 'SOLE PROPRIETOR') {
			String sicCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Standard Industry SIC Code',
				(accountP.Standard_Industry_SIC_Code__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (sicCodeTranslated != null) {
				requestBean.CIcreateClientV12.Cib003i.siccCode5 = sicCodeTranslated;
			}

			String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Country',
				accountP.Country_of_Incorporation__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (countryOfIncorporationTranslated != null) {
				requestBean.CIcreateClientV12.Cib003i.countryIncorp = countryOfIncorporationTranslated;
			}

			String cpaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Boolean Value',
				String.valueOf(accountP.Does_the_Client_fall_under_the_CPA__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (cpaThresholdTranslated != null) {
				requestBean.CIcreateClientV12.Cib003i.cpaThreshold = cpaThresholdTranslated;
			}

			String ncaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Boolean Value',
				String.valueOf(accountP.Does_the_Client_fall_under_the_NCA__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (ncaThresholdTranslated != null) {
				requestBean.CIcreateClientV12.Cib003i.ncaThreshold = ncaThresholdTranslated;
			}

			//TdB - W-004831 : Map Regulatory 3(1)f Shareholder% (Is the Cleint affected)
			String affectedPersonTranslated;
			if (accountP.Q1a_Client_affected_by_Regulation_3_1_F__c == true) {
				affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.CIF_STRING,
					'Affected Person',
					String.valueOf(accountP.Q1b_How_is_the_Client_Affected__c),
					StringConstants.OUTBOUND_RECORD_TYPE
				);
				if (String.IsBlank(affectedPersonTranslated) == false) {
					requestBean.CIcreateClientV12.Cib003i.affectedPerson = affectedPersonTranslated;
				}
				if (accountP.Q1c_Exchange_Control_Expiry_date__c != null) {
					requestBean.CIcreateClientV12.Cib003i.exconExpiryDate = String.valueOf(accountP.Q1c_Exchange_Control_Expiry_date__c).replace('-', '');
				}
			}
			if (accountP.Q2a_Client_affected_by_Regulation_3_1_F__c == true) {
				affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.CIF_STRING,
					'Affected Person',
					String.valueOf(accountP.Q2b_How_is_the_Client_Affected__c),
					StringConstants.OUTBOUND_RECORD_TYPE
				);
				if (String.IsBlank(affectedPersonTranslated) == false) {
					requestBean.CIcreateClientV12.Cib003i.affectedPerson = affectedPersonTranslated;
				}
				if (accountP.Q2c_Exchange_Control_Expiry_date__c != null) {
					requestBean.CIcreateClientV12.Cib003i.exconExpiryDate = String.valueOf(accountP.Q2c_Exchange_Control_Expiry_date__c).replace('-', '');
				}
			}

			if (accountP.Place_of_Residence__c == 'South African Resident' || accountP.Is_the_Client_a_Non_resident__c == false) {
				requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated');
			} else {
				requestBean.CIcreateClientV12.Cib003i.clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.CIF_STRING,
					'Client Type',
					'Sole Trader - Foreign National',
					StringConstants.OUTBOUND_RECORD_TYPE
				);
			}

			//Multiple Country Of Operations
			System.debug('accountP.Country_of_Operation__c ' + accountP.Country_of_Operation__c);
			String[] countryEntoprt = new List<String>{};
			if (accountP.Country_of_Operation__c != null && accountP.Country_of_Operation__c != '') {
				countryEntoprt = accountP.Country_of_Operation__c.split(';');
			}
			List<String> countryEntoprtlist = new List<String>();

			for (String countryofopt : countryEntoprt) {
				CreateClientCIF_Req_IB_v1.CountryEntOprtData tempcountryEntoprt = new CreateClientCIF_Req_IB_v1.CountryEntOprtData();
				String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.CIF_STRING,
					'Country',
					accountP.Country_of_Operation__c,
					StringConstants.OUTBOUND_RECORD_TYPE
				);
				if (countryOfOperationTranslated != null) {
					tempcountryEntoprt.countryEntOprt = countryOfOperationTranslated;
					requestBean.CIcreateClientV12.Cib003i.CountryEntOprtData.add(tempcountryEntoprt);
				}
				countryEntoprtlist.add(countryOfOperationTranslated);
			}
		} else {
			//Individual specific (Not for Sole Prop)
			String socialGrantTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Boolean Value',
				String.valueOf(accountP.Does_the_Client_receive_Social_a_Grant__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (socialGrantTranslated != null) {
				requestBean.CIcreateClientV12.Cib003i.socialGrant = socialGrantTranslated;
			}

			//TdB - W-005526
			if (tanslationValueMapP.get('occupationLevelTranslated') != null) {
				requestBean.CIcreateClientV12.Cib003i.occupationLevel = tanslationValueMapP.get('occupationLevelTranslated');
			}

			if (accountP.Place_of_Residence__c == 'South African Resident') {
				requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated');
			} else {
				requestBean.CIcreateClientV12.Cib003i.clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.CIF_STRING,
					'Client Type',
					'Private Individual - Foreign National',
					StringConstants.OUTBOUND_RECORD_TYPE
				);
			}
		}

		//Next of Kin Mappings
		requestBean.CIcreateClientV12.Cib003i.nkinInitials = accountP.Next_of_Kin_Initial__pc;
		requestBean.CIcreateClientV12.Cib003i.nkinFname = accountP.Next_of_Kin_First_Name_s__pc;
		requestBean.CIcreateClientV12.Cib003i.nkinSurname = accountP.Next_of_Kin_Last_Name__pc;
		requestBean.CIcreateClientV12.Cib003i.nkinCell = accountP.Next_of_Kin_Cellphone_Number__pc;
		requestBean.CIcreateClientV12.Cib003i.nkinEmail = accountP.Next_of_Kin_Email_Address__pc;
		requestBean.CIcreateClientV12.Cib003i.nkinTelh = accountP.Next_of_Kin_Telephone_Number__pc;

		//Translations Mappings
		String nextOfKinRelationshipTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Relationship',
			accountP.Next_of_Kin_Relationship__pc,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (nextOfKinRelationshipTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.nkinRela = nextOfKinRelationshipTranslated;
		}

		String creditConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Boolean Value',
			String.valueOf(accountP.Credit_Worthiness_Consent__c),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (creditConsentTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.thrdPartyInd = creditConsentTranslated;
		}

		/* String ficaExemptTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Boolean Value', String.valueOf(accountP.Is_the_Client_exempt_from_FICA__pc), StringConstants.OUTBOUND_RECORD_TYPE);
        if(ficaExemptTranslated != null){
            requestBean.CIcreateClientV12.Cib003i.exemptionStatus = ficaExemptTranslated;					
        }*/

		requestBean.CIcreateClientV12.Cib003i.vatRegistrationNo = String.valueOf(accountP.VAT_Registration_Number__c);

		requestBean.CIcreateClientV12.Cib003i.initials = accountP.Initials__pc.toUpperCase();
		if (tanslationValueMapP.get('comLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.language = tanslationValueMapP.get('comLanguageTranslated');
		}
		if (tanslationValueMapP.get('personTitleTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.titleCode = tanslationValueMapP.get('personTitleTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.surname = accountP.LastName.toUpperCase();

		if (tanslationValueMapP.get('idTypeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.idType = tanslationValueMapP.get('idTypeTranslated');
		}

		if (accountP.ID_Type__c == 'Passport' || accountP.ID_Type__pc == 'Passport') {
			requestBean.CIcreateClientV12.Cib003i.idNumber = accountP.Passport_Number__pc;
		} else {
			requestBean.CIcreateClientV12.Cib003i.idNumber = accountP.ID_Number__pc;
		}

		if (accountP.PersonBirthdate != null) {
			requestBean.CIcreateClientV12.Cib003i.birthDate = String.valueOf(accountP.PersonBirthdate).replace('-', '');
		}
		if (tanslationValueMapP.get('maritalStatusTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.maritalStatus = tanslationValueMapP.get('maritalStatusTranslated');
		}
		if (tanslationValueMapP.get('genderTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.gender = tanslationValueMapP.get('genderTranslated');
		}
		if (tanslationValueMapP.get('occupaionCodeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.branchClientOpen = branchP;
		if (userP.BRID__c != null) {
			requestBean.CIcreateClientV12.Cib003i.tellerLastChanged = userP.BRID__c.subString(2);
		}
		if (tanslationValueMapP.get('maritalContractTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.mariageContrctType = tanslationValueMapP.get('maritalContractTranslated');
		}
		//Non-Credit Marketing
		if (tanslationValueMapP.get('nonCreditMarketConsentTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.ncrInd = tanslationValueMapP.get('nonCreditMarketConsentTranslated');

			requestBean.CIcreateClientV12.Cib003i.ncrEmail = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrPost = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrTel = 'N';
			requestBean.CIcreateClientV12.Cib003i.ncrSms = 'N';

			if (nonCreditMarketIndP != null) {
				for (String indicator : nonCreditMarketIndP) {
					switch on indicator {
						when 'Email' {
							requestBean.CIcreateClientV12.Cib003i.ncrEmail = 'Y';
						}
						when 'Mail' {
							requestBean.CIcreateClientV12.Cib003i.ncrPost = 'Y';
						}
						when 'Phone' {
							requestBean.CIcreateClientV12.Cib003i.ncrTel = 'Y';
						}
						when 'SMS' {
							requestBean.CIcreateClientV12.Cib003i.ncrSms = 'Y';
						}
					}
				}
			}
		}

		//Credit Marketing Consent
		if (tanslationValueMapP.get('creditMarketConsentTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.crInd = tanslationValueMapP.get('creditMarketConsentTranslated');

			requestBean.CIcreateClientV12.Cib003i.crPost = 'N';
			requestBean.CIcreateClientV12.Cib003i.crTel = 'N';
			requestBean.CIcreateClientV12.Cib003i.crAvoice = 'N';
			requestBean.CIcreateClientV12.Cib003i.crEmail = 'N';
			requestBean.CIcreateClientV12.Cib003i.crSms = 'N';

			if (creditMarketIndP != null) {
				for (String indicator : creditMarketIndP) {
					switch on indicator {
						when 'Mail' {
							requestBean.CIcreateClientV12.Cib003i.crPost = 'Y';
						}
						when 'Phone' {
							requestBean.CIcreateClientV12.Cib003i.crTel = 'Y';
						}
						when 'Voice Recording' {
							requestBean.CIcreateClientV12.Cib003i.crAvoice = 'Y';
						}
						when 'Email' {
							requestBean.CIcreateClientV12.Cib003i.crEmail = 'Y';
						}
						when 'SMS' {
							requestBean.CIcreateClientV12.Cib003i.crSms = 'Y';
						}
					}
				}
			}
		}

		requestBean.CIcreateClientV12.Cib003i.miltaryComtmntInd = 'N';

		String occupancyTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Residential Status',
			String.valueOf(accountP.Residential_Status__pc),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (occupancyTypeTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.occupancyType = occupancyTypeTranslated;
		} else {
			requestBean.CIcreateClientV12.Cib003i.occupancyType = '0';
		}

		if (accountP.FirstName != null && accountP.MiddleName != null) {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase() + ' ' + accountP.MiddleName.toUpperCase();
		} else {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase();
		}

		//Contact details
		if (accountP.PersonHomePhone != null) {
			Integer homeNumberSize = accountP.PersonHomePhone.length();
			requestBean.CIcreateClientV12.Cib003i.homeTelCode = accountP.PersonHomePhone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.homeTelephone = accountP.PersonHomePhone.Substring(3, homeNumberSize);
		}
		if (accountP.Phone != null) {
			Integer workNumberSize = accountP.Phone.length();
			requestBean.CIcreateClientV12.Cib003i.workTelCode = accountP.Phone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.workTelephone = accountP.Phone.Substring(3, workNumberSize);
		}

		if (accountP.PersonMobilePhone != null) {
			String phoneNumber = accountP.PersonMobilePhone;

			if (phoneNumber.length() > 10) {
				//Take last 10 Digits
				Integer numberLength = phoneNumber.length();
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
			} else if (phoneNumber.length() < 10) {
				//Add 0 infront until number is 10 digits
				while (phoneNumber.length() < 10) {
					phoneNumber = '0' + phoneNumber;
				}
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			} else {
				//Number is the correct length
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			}
		}
		System.debug('requestBean.cellphone ' + requestBean.CIcreateClientV12.Cib003i.cellphone);
		if (tanslationValueMapP.get('occupationStatusTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated');
		}

		requestBean.CIcreateClientV12.Cib003i.emailAddress = accountP.PersonEmail;

		if (tanslationValueMapP.get('comMethodTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = tanslationValueMapP.get('comMethodTranslated');
		}
		if (tanslationValueMapP.get('nationalityTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.clientNationality = tanslationValueMapP.get('nationalityTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.countryOfOrigin = tanslationValueMapP.get('countryOfOriginTranslated');
		requestBean.CIcreateClientV12.Cib003i.dateExempted = '0';
		requestBean.CIcreateClientV12.Cib003i.corporateDivision = 'A';
		requestBean.CIcreateClientV12.Cib003i.haveQualification = '0';
		requestBean.CIcreateClientV12.Cib003i.secondaryCard = 'N';
		requestBean.CIcreateClientV12.Cib003i.minorChildren = string.valueOf(accountP.Number_Of_Dependents__c);

		//SIC Sub Classification
		String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_1__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_2__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_3__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		if (SICClassification1Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData1 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData1.agriClass = SICClassification1Translated;
			if (accountP.SIC_Classification_1_Percentage__c != null) {
				AgriData1.percentage = String.ValueOf(accountP.SIC_Classification_1_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData1);
		}

		if (SICClassification2Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData2 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData2.agriClass = SICClassification2Translated;
			if (accountP.SIC_Classification_2_Percentage__c != null) {
				AgriData2.percentage = String.ValueOf(accountP.SIC_Classification_2_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData2);
		}

		if (SICClassification3Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData3 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData3.agriClass = SICClassification3Translated;
			if (accountP.SIC_Classification_3_Percentage__c != null) {
				AgriData3.percentage = String.ValueOf(accountP.SIC_Classification_3_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData3);
		}

		//Address Mappings
		for (Address__c add : addressList) {
			if (add.Account__c == accountP.Id) {
				if (add.Address_Type__c == StringConstants.EMPLOYER_ADDR_STRING) {
					requestBean.CIcreateClientV12.Cib003i.employerAddrType = '70';
					requestBean.CIcreateClientV12.Cib003i.employerAdd1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.employerAdd2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.employerSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.employerTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.employerPostal = add.Shipping_Zip_Postal_Code__c;
				}

				// Sole Trader specific fields to map (not applicable for individual)
				if (add.Address_Type__c == StringConstants.PHYSICAL_ADDR_STRING) {
					if (accountP.Client_Type__c.toUpperCase() == 'SOLE TRADER' || accountP.Client_Type__c.toUpperCase() == 'SOLE PROPRIETOR') {
						requestBean.CIcreateClientV12.Cib003i.businessAddrType = '20';
						requestBean.CIcreateClientV12.Cib003i.businessAdd1 = add.Shipping_Street__c;
						requestBean.CIcreateClientV12.Cib003i.businessAdd2 = add.Shipping_Street_2__c;
						requestBean.CIcreateClientV12.Cib003i.businessSuburb = add.Shipping_Suburb__c;
						requestBean.CIcreateClientV12.Cib003i.businessTown = add.Shipping_City__c;
						requestBean.CIcreateClientV12.Cib003i.businessPostal = add.Shipping_Zip_Postal_Code__c;
					} else {
						requestBean.CIcreateClientV12.Cib003i.physicalAddrType = '10';
						requestBean.CIcreateClientV12.Cib003i.physicalAdd1 = add.Shipping_Street__c;
						requestBean.CIcreateClientV12.Cib003i.physicalAdd2 = add.Shipping_Street_2__c;
						requestBean.CIcreateClientV12.Cib003i.physicalSuburb = add.Shipping_Suburb__c;
						requestBean.CIcreateClientV12.Cib003i.physicalTown = add.Shipping_City__c;
						requestBean.CIcreateClientV12.Cib003i.physicalPostal = add.Shipping_Zip_Postal_Code__c;
					}
				}

				if (add.Address_Type__c == StringConstants.POSTAL_STRING) {
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.postlSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.postlTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = add.Shipping_Zip_Postal_Code__c;
				}
			}
		}

		requestBean.CIcreateClientV12.Cib003i.casaRefNum = accountP.CASA_Reference_Number__pc;
		if (tanslationValueMapP.get('countryOfBirthTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.countryOfBirth = tanslationValueMapP.get('countryOfBirthTranslated');
		}

		//TdB - Surety Onboarding: Do not pass BCA/Client Agreement
		if (accountP.Process_Type__c != 'Surety Onboarding') {
			requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'Y';
		} else {
			requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'N';
		}

		if (accountP.Income_Tax_Number__c != null) {
			requestBean.CIcreateClientV12.Cib003i.taxNumber = String.valueOf(accountP.Income_Tax_Number__c);
			requestBean.CIcreateClientV12.Cib003i.saTaxRegis = 'Y';
		} else {
			requestBean.CIcreateClientV12.Cib003i.saTaxRegis = 'N';
		}

		//Start : multiple source of income : 2020-03-16 - Anka Ganta
		String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');

		List<String> sourceOfincomelist = new List<String>();

		for (String srcOfincome : sourceOfincomes) {
			String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				StringConstants.FIELD_SOURCE_OF_INCOME_STRING,
				srcOfincome,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			sourceOfincomelist.add(srcOfincomeTranslated);
		}
		if (sourceOfincomelist[0] != null) {
			requestBean.CIcreateClientV12.Cib003i.sourceOfIncome = sourceOfincomelist[0];
		}

		if (tanslationValueMapP.get('incomeGroupTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.incomeGroup = tanslationValueMapP.get('incomeGroupTranslated');
		}
		if (accountP.Date_Issued__pc != null) {
			requestBean.CIcreateClientV12.Cib003i.dateIssued = String.valueOf(accountP.Date_Issued__pc).replace('-', '');
		}
		if (tanslationValueMapP.get('homeLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.homeLanguage = tanslationValueMapP.get('homeLanguageTranslated');
		}

		if (accountP.Date_Identified__c != null) {
			requestBean.CIcreateClientV12.Cib003i.dateIdentified = string.valueOf(accountP.Date_Identified__c).replace('-', '');
		}
		// if(accountP.Date_Verified__c!=null){
		// requestBean.CIcreateClientV12.Cib003i.dateVerified=string.valueOf(accountP.Date_Verified__c).replace('-','');
		requestBean.CIcreateClientV12.Cib003i.dateVerified = string.valueOf(System.Today().format().replace('/', ''));

		//  }
		//  added by diksha for cif req 20200627
		if (userP.EmployeeNumber != null) {
			requestBean.CIcreateClientV12.Cib003i.employeeIdentified = userP.EmployeeNumber;
			requestBean.CIcreateClientV12.Cib003i.employeeVerified = userP.EmployeeNumber;
		}

		if (accountP.Is_Marketing_Consent_Phone__c != null && accountP.Is_Marketing_Consent_Phone__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRTel = 'Y';
		} else if (accountP.Is_Marketing_Consent_Phone__c != null && accountP.Is_Marketing_Consent_Phone__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRTel = 'N';
		}
		if (accountP.Is_Marketing_Consent_Email__c != null && accountP.Is_Marketing_Consent_Email__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCREmail = 'Y';
		} else if (accountP.Is_Marketing_Consent_Email__c != null && accountP.Is_Marketing_Consent_Email__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCREmail = 'N';
		}
		if (accountP.Is_Marketing_Consent_SMS__c != null && accountP.Is_Marketing_Consent_SMS__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRSMS = 'Y';
		} else if (accountP.Is_Marketing_Consent_SMS__c != null && accountP.Is_Marketing_Consent_SMS__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRSMS = 'N';
		}
		if (accountP.Is_Marketing_Consent_Post__c != null && accountP.Is_Marketing_Consent_Post__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRPost = 'Y';
		} else if (accountP.Is_Marketing_Consent_Post__c != null && accountP.Is_Marketing_Consent_Post__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRPost = 'N';
		}
		if (accountP.Is_Marketing_Consent_voice_rec__c != null && accountP.Is_Marketing_Consent_voice_rec__c == true) {
			requestBean.CIcreateClientV12.Cib003i.ncrAvoice = 'Y';
		} else if (accountP.Is_Marketing_Consent_voice_rec__c != null && accountP.Is_Marketing_Consent_voice_rec__c == false) {
			requestBean.CIcreateClientV12.Cib003i.ncrAvoice = 'N';
		}
		if (
			accountP.Is_Marketing_Consent_Phone__c == true ||
			accountP.Is_Marketing_Consent_Email__c == true ||
			accountP.Is_Marketing_Consent_SMS__c == true ||
			accountP.Is_Marketing_Consent_Post__c == true ||
			accountP.Is_Marketing_Consent_voice_rec__c == true
		) {
			requestBean.CIcreateClientV12.Cib003i.nCRInd = 'Y';
		} else {
			requestBean.CIcreateClientV12.Cib003i.nCRInd = 'N';
		}

		System.debug('CIF Create Client Request' + requestBean);
		return requestBean;
	}

	/**
	 * @description TdB - RBB Mini Individual Mapping
	 * @param accountP
	 * @param appliationP
	 * @param userP
	 * @param tanslationValueMapP
	 * @param addressBeanP
	 * @param branchP
	 * @param nonCreditMarketIndP
	 * @param creditMarketIndP
	 * @return CreateClientCIF_Req_IB_v1
	 */
	public static CreateClientCIF_Req_IB_v1 mapRBBMiniIndividualClientRequestFields(
		Account accountP,
		String appliationP,
		User userP,
		Map<String, String> tanslationValueMapP,
		CvsValidationService_Resp_IB_v1 addressBeanP,
		String branchP,
		List<String> nonCreditMarketIndP,
		List<String> creditMarketIndP
	) {
		CreateClientCIF_Req_IB_v1 requestBean = new CreateClientCIF_Req_IB_v1();
		AddressesSelector addrSelector = new AddressesSelector();
		List<Address__c> addressList = addrSelector.addressesRelatedToAcc(accountP.Id);

		requestBean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
		requestBean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
		requestBean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
		requestBean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
		//requestBean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
		//requestBean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
		//requestBean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

		//Mappings - Nbsapdpi
		requestBean.CIcreateClientV12.Nbsapdpi.application = StringConstants.CUSTOMER1_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.trace = 'N';

		//Mappings - Nbsmsgi
		requestBean.CIcreateClientV12.Nbsmsgi.msgLanguage = 'E';
		requestBean.CIcreateClientV12.Nbsmsgi.msgTarget = 'STD';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgCode = '';

		//Mappings - Cib003i
		requestBean.CIcreateClientV12.Cib003i.secondaryCard = 'Y';

		requestBean.CIcreateClientV12.Cib003i.initials = accountP.Initials__pc.toUpperCase();
		if (tanslationValueMapP.get('comLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.language = tanslationValueMapP.get('comLanguageTranslated');
		}
		if (tanslationValueMapP.get('personTitleTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.titleCode = tanslationValueMapP.get('personTitleTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.surname = accountP.LastName.toUpperCase();

		if (tanslationValueMapP.get('idTypeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.idType = tanslationValueMapP.get('idTypeTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.idNumber = accountP.ID_Number__pc;

		if (accountP.PersonBirthdate != null) {
			requestBean.CIcreateClientV12.Cib003i.birthDate = String.valueOf(accountP.PersonBirthdate).replace('-', '');
		}

		if (tanslationValueMapP.get('genderTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.gender = tanslationValueMapP.get('genderTranslated');
		}
		if (tanslationValueMapP.get('occupaionCodeTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationCode = tanslationValueMapP.get('occupaionCodeTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.branchClientOpen = branchP;
		if (userP.BRID__c != null) {
			requestBean.CIcreateClientV12.Cib003i.tellerLastChanged = userP.BRID__c.subString(2);
		}

		requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated');
		//requestBean.miltaryComtmntInd = 'N';

		String occupancyTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Residential Status',
			String.valueOf(accountP.Residential_Status__pc),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (occupancyTypeTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.occupancyType = occupancyTypeTranslated;
		} else {
			requestBean.CIcreateClientV12.Cib003i.occupancyType = '0';
		}

		if (accountP.FirstName != null && accountP.MiddleName != null) {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase() + ' ' + accountP.MiddleName.toUpperCase();
		} else {
			requestBean.CIcreateClientV12.Cib003i.firstNames = accountP.FirstName.toUpperCase();
		}

		//Contact details
		if (accountP.PersonHomePhone != null) {
			Integer homeNumberSize = accountP.PersonHomePhone.length();
			requestBean.CIcreateClientV12.Cib003i.homeTelCode = accountP.PersonHomePhone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.homeTelephone = accountP.PersonHomePhone.Substring(3, homeNumberSize);
		}
		if (accountP.Phone != null) {
			Integer workNumberSize = accountP.Phone.length();
			requestBean.CIcreateClientV12.Cib003i.workTelCode = accountP.Phone.Substring(0, 3);
			requestBean.CIcreateClientV12.Cib003i.workTelephone = accountP.Phone.Substring(3, workNumberSize);
		}

		if (accountP.PersonMobilePhone != null) {
			String phoneNumber = accountP.PersonMobilePhone;

			if (phoneNumber.length() > 10) {
				//Take last 10 Digits
				Integer numberLength = phoneNumber.length();
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
			} else if (phoneNumber.length() < 10) {
				//Add 0 infront until number is 10 digits
				while (phoneNumber.length() < 10) {
					phoneNumber = '0' + phoneNumber;
				}
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			} else {
				//Number is the correct length
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			}
		}
		System.debug('requestBean.cellphone ' + requestBean.CIcreateClientV12.Cib003i.cellphone);
		if (tanslationValueMapP.get('occupationStatusTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.occupationStatus = tanslationValueMapP.get('occupationStatusTranslated');
		}

		if (accountP.Client_Type__c.toUpperCase() != 'SOLE TRADER' && accountP.Client_Type__c.toUpperCase() != 'SOLE PROPRIETOR') {
			//TdB - W-005526 (Only Individual)
			if (tanslationValueMapP.get('occupationLevelTranslated') != null) {
				requestBean.CIcreateClientV12.Cib003i.occupationLevel = tanslationValueMapP.get('occupationLevelTranslated');
			}
		}

		requestBean.CIcreateClientV12.Cib003i.emailAddress = accountP.PersonEmail;
		requestBean.CIcreateClientV12.Cib003i.cellphone = accountP.Phone;

		if (tanslationValueMapP.get('comMethodTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = tanslationValueMapP.get('comMethodTranslated');
		}
		if (tanslationValueMapP.get('nationalityTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.clientNationality = tanslationValueMapP.get('nationalityTranslated');
		}
		requestBean.CIcreateClientV12.Cib003i.countryOfOrigin = tanslationValueMapP.get('countryOfOriginTranslated');

		//Address Mappings
		for (Address__c add : addressList) {
			if (add.Account__c == accountP.Id) {
				if (add.Address_Type__c == StringConstants.EMPLOYER_ADDR_STRING) {
					requestBean.CIcreateClientV12.Cib003i.employerAddrType = '70';
					requestBean.CIcreateClientV12.Cib003i.employerAdd1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.employerAdd2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.employerSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.employerTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.employerPostal = add.Shipping_Zip_Postal_Code__c;
				}

				// Sole Trader specific fields to map (not applicable for individual)
				if (add.Address_Type__c == StringConstants.PHYSICAL_ADDR_STRING) {
					if (accountP.Client_Type__c.toUpperCase() == 'SOLE TRADER' || accountP.Client_Type__c.toUpperCase() == 'SOLE PROPRIETOR') {
						requestBean.CIcreateClientV12.Cib003i.businessAddrType = '20';
						requestBean.CIcreateClientV12.Cib003i.businessAdd1 = add.Shipping_Street__c;
						requestBean.CIcreateClientV12.Cib003i.businessAdd2 = add.Shipping_Street_2__c;
						requestBean.CIcreateClientV12.Cib003i.businessSuburb = add.Shipping_Suburb__c;
						requestBean.CIcreateClientV12.Cib003i.businessTown = add.Shipping_City__c;
						requestBean.CIcreateClientV12.Cib003i.businessPostal = add.Shipping_Zip_Postal_Code__c;
					} else {
						requestBean.CIcreateClientV12.Cib003i.physicalAddrType = '10';
						requestBean.CIcreateClientV12.Cib003i.physicalAdd1 = add.Shipping_Street__c;
						requestBean.CIcreateClientV12.Cib003i.physicalAdd2 = add.Shipping_Street_2__c;
						requestBean.CIcreateClientV12.Cib003i.physicalSuburb = add.Shipping_Suburb__c;
						requestBean.CIcreateClientV12.Cib003i.physicalTown = add.Shipping_City__c;
						requestBean.CIcreateClientV12.Cib003i.physicalPostal = add.Shipping_Zip_Postal_Code__c;
					}
				}

				if (add.Address_Type__c == StringConstants.POSTAL_STRING) {
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.postlSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.postlTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = add.Shipping_Zip_Postal_Code__c;
				}
			}
		}

		requestBean.CIcreateClientV12.Cib003i.casaRefNum = accountP.CASA_Reference_Number__pc;
		if (tanslationValueMapP.get('countryOfBirthTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.countryOfBirth = tanslationValueMapP.get('countryOfBirthTranslated');
		}

		if (tanslationValueMapP.get('homeLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.homeLanguage = tanslationValueMapP.get('homeLanguageTranslated');
		}

		System.debug('CIF Create Client Request' + requestBean);
		return requestBean;
	}

	/**
	 * @description Business Client
	 * @param accountP
	 * @param relatedAccountListP
	 * @param primaryAccountIdP
	 * @param appliationP
	 * @param userP
	 * @param tanslationValueMapP
	 * @param addressBeanP
	 * @param branchP
	 * @param nonCreditMarketIndP
	 * @param creditMarketIndP
	 * @return CreateClientCIF_Req_IB_v1
	 */
	public static CreateClientCIF_Req_IB_v1 mapBusinessClientRequestFields(
		Account accountP,
		List<Account> relatedAccountListP,
		String primaryAccountIdP,
		String appliationP,
		User userP,
		Map<String, String> tanslationValueMapP,
		CvsValidationService_Resp_IB_v1 addressBeanP,
		String branchP,
		List<String> nonCreditMarketIndP,
		List<String> creditMarketIndP
	) {
		CreateClientCIF_Req_IB_v1 requestBean = new CreateClientCIF_Req_IB_v1();

		requestBean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
		requestBean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
		requestBean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
		requestBean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
		//requestBean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
		//requestBean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
		//requestBean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

		//Mappings - Nbsapdpi
		requestBean.CIcreateClientV12.Nbsapdpi.application = appliationP;

		requestBean.CIcreateClientV12.Nbsapdpi.trace = 'N';

		//Mappings - Nbsmsgi
		requestBean.CIcreateClientV12.Nbsmsgi.msgLanguage = 'E';
		requestBean.CIcreateClientV12.Nbsmsgi.msgTarget = 'STD';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgCode = '';

		//Mappings - Cib003i
		requestBean.CIcreateClientV12.Cib003i.titleCode = '0';

		if (tanslationValueMapP.get('comLanguageTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.language = tanslationValueMapP.get('comLanguageTranslated');
		}

		if (accountP.Name != null) {
			requestBean.CIcreateClientV12.Cib003i.surname = accountP.Name.toUpperCase();
		}

		for (Account jointAcc : relatedAccountListP) {
			if (jointAcc.Id == primaryAccountIdP) {
				String accName = jointAcc.FirstName != null ? jointAcc.FirstName : '' + ' ' + jointAcc.LastName != null ? jointAcc.LastName : '';
				requestBean.CIcreateClientV12.Cib003i.contactPerson = accName.trim().toUpperCase();

				for (CvsValidationService_Resp_IB_v1.cls_addressCollection address : addressBeanP.addressCollection) {
					if (address.accountSFID == primaryAccountIdP) {
						requestBean.CIcreateClientV12.Cib003i.postlAddrLine1 = address.addressLine1;
						requestBean.CIcreateClientV12.Cib003i.postlAddrLine2 = address.addressLine2;
						requestBean.CIcreateClientV12.Cib003i.postlTown = address.town;
						requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = address.postalcode;
					}
				}
			}
		}
		requestBean.CIcreateClientV12.Cib003i.idType = '0';
		requestBean.CIcreateClientV12.Cib003i.idNumber = accountP.ID_Number__pc;
		requestBean.CIcreateClientV12.Cib003i.birthDate = '0';
		requestBean.CIcreateClientV12.Cib003i.maritalStatus = '0';
		requestBean.CIcreateClientV12.Cib003i.gender = '0';
		requestBean.CIcreateClientV12.Cib003i.occupationCode = '0';
		requestBean.CIcreateClientV12.Cib003i.branchClientOpen = branchP;

		if (userP.BRID__c != null) {
			requestBean.CIcreateClientV12.Cib003i.tellerLastChanged = userP.BRID__c.subString(2);
		}

		requestBean.CIcreateClientV12.Cib003i.mariageContrctType = '0';
		requestBean.CIcreateClientV12.Cib003i.ncrInd = tanslationValueMapP.get('marketingConsentTranslated'); //Translation
		requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated'); //Translation
		requestBean.CIcreateClientV12.Cib003i.miltaryComtmntInd = 'N';
		requestBean.CIcreateClientV12.Cib003i.occupancyType = '0'; //Translation = TBC
		requestBean.CIcreateClientV12.Cib003i.homeTelCode = '0';
		requestBean.CIcreateClientV12.Cib003i.homeTelephone = '0';
		requestBean.CIcreateClientV12.Cib003i.workTelCode = '0';
		requestBean.CIcreateClientV12.Cib003i.workTelephone = accountP.Phone;

		if (accountP.PersonMobilePhone != null) {
			String phoneNumber = accountP.PersonMobilePhone;

			if (phoneNumber.length() > 10) {
				//Take last 10 Digits
				Integer numberLength = phoneNumber.length();
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber.Substring(numberLength - 10, numberLength);
			} else if (phoneNumber.length() < 10) {
				//Add 0 infront until number is 10 digits
				while (phoneNumber.length() < 10) {
					phoneNumber = '0' + phoneNumber;
				}
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			} else {
				//Number is the correct length
				requestBean.CIcreateClientV12.Cib003i.cellphone = phoneNumber;
			}
		}

		requestBean.CIcreateClientV12.Cib003i.occupationStatus = '0';
		requestBean.CIcreateClientV12.Cib003i.emailAddress = accountP.PersonEmail;
		//Newly added By Rajesh for Cellphone
		requestBean.CIcreateClientV12.Cib003i.cellphone = accountP.Phone;

		if (tanslationValueMapP.get('comMethodTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = tanslationValueMapP.get('comMethodTranslated'); //Translation
		}
		if (tanslationValueMapP.get('nationalityTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.clientNationality = tanslationValueMapP.get('nationalityTranslated'); //Translation
		}
		if (tanslationValueMapP.get('countryOfRegistrationTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.countryOfOrigin = tanslationValueMapP.get('countryOfRegistrationTranslated'); //Translation = countryOfRegistrationTranslated previously countryOfOriginTranslated
		}
		requestBean.CIcreateClientV12.Cib003i.dateExempted = '0'; //Zero until is business rule is provided
		requestBean.CIcreateClientV12.Cib003i.corporateDivision = 'A';
		requestBean.CIcreateClientV12.Cib003i.haveQualification = '0';
		requestBean.CIcreateClientV12.Cib003i.socialGrant = 'N';
		requestBean.CIcreateClientV12.Cib003i.secondaryCard = 'N';
		requestBean.CIcreateClientV12.Cib003i.dateIssued = '0'; //Zero until is business rule is provided
		requestBean.CIcreateClientV12.Cib003i.employerAddrType = '0';
		requestBean.CIcreateClientV12.Cib003i.physicalAddrType = '0';
		requestBean.CIcreateClientV12.Cib003i.thrdPartyInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updAddressInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updTelephoneInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updEmailInd = 'N'; //Default
		requestBean.CIcreateClientV12.Cib003i.updDateInd = '0'; //Default
		requestBean.CIcreateClientV12.Cib003i.casaRefNum = accountP.CASA_Reference_Number__c;
		if (tanslationValueMapP.get('countryOfBirthTranslated') != null) {
			requestBean.CIcreateClientV12.Cib003i.countryOfBirth = tanslationValueMapP.get('countryOfBirthTranslated'); //Translation
		}
		requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'N';
		requestBean.CIcreateClientV12.Cib003i.taxNumber = '0';
		System.debug('CIF Create Client Request' + requestBean);
		return requestBean;
	}

	/**
	 * @description //Added by Haritha - For Business Prospect Clients
	 * Business Prospects
	 * Simple version of the method for mapping request fields
	 * @param accountP
	 * @param relatedAccountListP
	 * @param primaryAccountIdP
	 * @param appliationP
	 * @param userP
	 * @param tanslationValueMapP
	 * @param addressBeanP
	 * @param branchP
	 * @param nonCreditMarketIndP
	 * @param creditMarketIndP
	 * @return CreateClientCIF_Req_IB_v1
	 */
	public static CreateClientCIF_Req_IB_v1 mapBusinessProspectClientRequestFields(
		Account accountP,
		List<Account> relatedAccountListP,
		String primaryAccountIdP,
		String appliationP,
		User userP,
		Map<String, String> tanslationValueMapP,
		CvsValidationService_Resp_IB_v1 addressBeanP,
		String branchP,
		List<String> nonCreditMarketIndP,
		List<String> creditMarketIndP
	) {
		CreateClientCIF_Req_IB_v1 requestBean = new CreateClientCIF_Req_IB_v1();
		AddressesSelector addrSelector = new AddressesSelector();
		List<Address__c> addressList = addrSelector.addressesRelatedToAcc(accountP.Id);
		List<AccountContactRelation> acrList = [
			SELECT
				id,
				AccountId,
				Designation__c,
				ContactId,
				Contact.Initials__c,
				Contact.Name,
				Contact.FirstName,
				Contact.LastName,
				Roles,
				Contact.MobilePhone,
				Contact.Email,
				Contact.Phone
			FROM AccountContactRelation
			WHERE AccountId = :accountP.Id AND Roles INCLUDES ('Contact Person')
		];

		//TdB - Use Jitterbit new structure
		requestBean.CIcreateClientV12 = new CreateClientCIF_Req_IB_v1.CIcreateClientV12();
		requestBean.CIcreateClientV12.Nbsapdpi = new CreateClientCIF_Req_IB_v1.Nbsapdpi();
		requestBean.CIcreateClientV12.Nbsmsgi = new CreateClientCIF_Req_IB_v1.Nbsmsgi();
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId = new CreateClientCIF_Req_IB_v1.FinalMsgId();
		requestBean.CIcreateClientV12.Cib003i = new CreateClientCIF_Req_IB_v1.Cib003i();
		requestBean.CIcreateClientV12.Cib003i.agriData = new List<CreateClientCIF_Req_IB_v1.AgriData>();
		requestBean.CIcreateClientV12.Cib003i.countryEntOprtData = new List<CreateClientCIF_Req_IB_v1.CountryEntOprtData>();
		requestBean.CIcreateClientV12.Cib003i.foreignTaxData = new List<CreateClientCIF_Req_IB_v1.ForeignTaxData>();

		////Mappings - Nbsapdpi
		requestBean.CIcreateClientV12.Nbsapdpi.application = StringConstants.CUSTOMER1_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.channel = StringConstants.SALESFORCE_STRING.toUpperCase();
		requestBean.CIcreateClientV12.Nbsapdpi.trace = 'N';

		//Mappings - Nbsmsgi
		requestBean.CIcreateClientV12.Nbsmsgi.msgLanguage = 'E';
		requestBean.CIcreateClientV12.Nbsmsgi.msgTarget = 'STD';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIcreateClientV12.Nbsmsgi.finalMsgId.finalMsgCode = '';

		//Mappings - Cib003i

		System.debug('** acrList: ' + acrList);
		if (!acrList.isEmpty()) {
			System.debug('** acrList: ' + acrList);
			for (AccountContactRelation accconRel : acrList) {
				System.debug('accconRel ' + accconRel.Id + ' == ' + accconRel.Contact.Id);
				//if((accconRel.Roles).contains(';')){
				system.debug('accconRel.Roles' + accconRel.Roles);
				for (String roleValue : (accconRel.Roles).split(';')) {
					if (roleValue.toUpperCase() == 'CONTACT PERSON') {
						system.debug('roleValue' + roleValue);
						String contactInitials = accconRel.Contact.Initials__c;
						if (String.isEmpty(contactInitials)) {
							contactInitials = String.ValueOf(accconRel.Contact.FirstName).left(1);
						}

						requestBean.CIcreateClientV12.Cib003i.contactPerson = String.ValueOf(contactInitials + ' ' + accconRel.Contact.LastName).left(30);

						requestBean.CIcreateClientV12.Cib003i.emailAddress = accconRel.Contact.Email;
						if (accconRel.Contact.MobilePhone != null) {
							requestBean.CIcreateClientV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone.right(9);
						}
						if (accconRel.Contact.Phone != null) {
							Integer workNumberSize = accconRel.Contact.Phone.length();
							if (accconRel.Contact.Phone.Substring(0, 3) == '+27') {
								requestBean.CIcreateClientV12.Cib003i.workTelCode = '0' + accconRel.Contact.Phone.Substring(3, 5);
								requestBean.CIcreateClientV12.Cib003i.workTelephone = accconRel.Contact.Phone.Substring(5, workNumberSize);
							} else {
								requestBean.CIcreateClientV12.Cib003i.workTelCode = accconRel.Contact.Phone.Substring(0, 3);
								requestBean.CIcreateClientV12.Cib003i.workTelephone = accconRel.Contact.Phone.Substring(3, workNumberSize);
							}
						}

						system.debug('roleValue2' + roleValue);
						requestBean.CIcreateClientV12.Cib003i.designation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							StringConstants.CIF_STRING,
							'Designation',
							accconRel.Designation__c,
							StringConstants.OUTBOUND_RECORD_TYPE
						);
					}
				}
				//}
				/*else{
                    requestBean.CIcreateClientV12.Cib003i.contactPerson= accconRel.Contact.Name;
                    requestBean.CIcreateClientV12.Cib003i.emailAddress= accconRel.Contact.Email;
                    requestBean.CIcreateClientV12.Cib003i.Cellphone = accconRel.Contact.MobilePhone;
                    }*/
				//requestBean.CIcreateClientV12.Cib003i.designation = acrList[0].Roles;
			}
		}

		//Newly added By Rajesh for Cellphone
		requestBean.CIcreateClientV12.Cib003i.cellphone = accountP.Phone;

		system.debug('requestBean.contactPerson ' + requestBean.CIcreateClientV12.Cib003i.Cellphone);

		//TdB - Surety Onboarding: Do not pass BCA/Client Agreement
		if (accountP.Process_Type__c != 'Surety Onboarding') {
			requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'Y'; //Added by Diksha for W-5480
		} else {
			requestBean.CIcreateClientV12.Cib003i.clntAgrmntIssued = 'N';
		}

		requestBean.CIcreateClientV12.Cib003i.initials = '';
		requestBean.CIcreateClientV12.Cib003i.language = tanslationValueMapP.get('LanguageTranslated'); //accountP.Language__c;
		if (accountP.Name != null) {
			requestBean.CIcreateClientV12.Cib003i.surname = accountP.Name.toUpperCase();
		}

		if (accountP.Client_Type__c == 'PARTNERSHIP') {
			requestBean.CIcreateClientV12.Cib003i.idType = '0';
		} else if (accountP.ID_Type__c != null) {
			requestBean.CIcreateClientV12.Cib003i.idType = accountP.Client_Type__c == 'Trusts' ? '05' : tanslationValueMapP.get('idTypeTranslated');
		} else {
			requestBean.CIcreateClientV12.Cib003i.idType = '0';
		}

		/*if(accountP.Registration_Number__c!=null){
            requestBean.CIcreateClientV12.Cib003i.idNumber = (accountP.Registration_Number__c).replace('/','');
        }*/
		if (accountP.Client_Type__c == 'Trusts') {
			requestBean.CIcreateClientV12.Cib003i.subClassCde = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Sub Classification Code',
				accountP.Sub_Classification_Code__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			requestBean.CIcreateClientV12.Cib003i.practiceNumber = accountP.Trust_Number__c;
		} else if (accountP.Client_Type__c == 'PARTNERSHIP') {
			requestBean.CIcreateClientV12.Cib003i.idNumber = '';
		} else {
			if (accountP.Registration_Number__c != null) {
				requestBean.CIcreateClientV12.Cib003i.idNumber = (accountP.Registration_Number__c).replace('/', '');
			} else {
				requestBean.CIcreateClientV12.Cib003i.idNumber = '0';
			}
		}
		requestBean.CIcreateClientV12.Cib003i.smsMarketInd = 'Y';

		String electronicsite = System.Label.ElectronicSiteForAccount;
        if(accountP.Business_Unit__c == 'Wealth Banking' || accountP.Business_Unit__c == 'WIMI' || accountP.Business_Unit__c == 'Private Banking'){
            requestBean.CIcreateClientV12.Cib003i.branchClientOpen = userP.SiteCode__c;
        }
        else{
            requestBean.CIcreateClientV12.Cib003i.branchClientOpen = electronicsite;
        }

		// if (userP.SiteCode__c != null) {
		// 	requestBean.CIcreateClientV12.Cib003i.branchClientOpen = userP.SiteCode__c;
		// }
		if (userP.Teller_Operator_Code__c != null) {
			requestBean.CIcreateClientV12.Cib003i.tellerLastChanged = userP.Teller_Operator_Code__c;
		}
		if (userP.EmployeeNumber != null) {
			requestBean.CIcreateClientV12.Cib003i.employeeIdentified = userP.EmployeeNumber;
			requestBean.CIcreateClientV12.Cib003i.employeeVerified = userP.EmployeeNumber;
		}
		requestBean.CIcreateClientV12.Cib003i.marketingConcent = 'N';
		System.debug('CLIENT TYPE ' + tanslationValueMapP.get('clientTypeTranslated'));
		if ((accountP.Client_Type__c == 'Non Profit Organizations (NGO)') || (accountP.Client_Type__c == 'Non Profit Companies')) {
			requestBean.CIcreateClientV12.Cib003i.clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'NGO Client Type',
				accountP.Is_the_NPC_NGO_any_of_the_below__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
		} else {
			requestBean.CIcreateClientV12.Cib003i.clientType = tanslationValueMapP.get('clientTypeTranslated'); //Translation//'002301';
		}
		if (accountP.Income_Tax_Number__c != null) {
			requestBean.CIcreateClientV12.Cib003i.taxNumber = String.valueOf(accountP.Income_Tax_Number__c);
		}
		if (accountP.Financial_Year_End__c != null) {
			requestBean.CIcreateClientV12.Cib003i.companyYearEnd = tanslationValueMapP.get('companyYearEnd'); //accountP.Financial_Year_End__c;
		}

		requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = '2001'; //accountP.Postal_Code_Rsa__c;
		requestBean.CIcreateClientV12.Cib003i.prefrdCommtionMthd = tanslationValueMapP.get('comMethodTranslated');
		if (accountP.Standard_Industry_SIC_Code__c != null) {
			requestBean.CIcreateClientV12.Cib003i.siccCode5 = tanslationValueMapP.get('sicCodeTranslated');
			system.debug('requestBean.siccCode5' + requestBean.CIcreateClientV12.Cib003i.siccCode5);
		}
		requestBean.CIcreateClientV12.Cib003i.teleMarkInd = '';

		//SIC Sub Classification
		String SICClassification1Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_1__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String SICClassification2Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_2__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		String SICClassification3Translated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'SIC Classification',
			accountP.SIC_Classification_3__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		if (SICClassification1Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData1 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData1.agriClass = SICClassification1Translated;
			if (accountP.SIC_Classification_1_Percentage__c != null) {
				AgriData1.percentage = String.ValueOf(accountP.SIC_Classification_1_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData1);
		}

		if (SICClassification2Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData2 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData2.agriClass = SICClassification2Translated;
			if (accountP.SIC_Classification_2_Percentage__c != null) {
				AgriData2.percentage = String.ValueOf(accountP.SIC_Classification_2_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData2);
		}

		if (SICClassification3Translated != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData3 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData3.agriClass = SICClassification3Translated;
			if (accountP.SIC_Classification_3_Percentage__c != null) {
				AgriData3.percentage = String.ValueOf(accountP.SIC_Classification_3_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData3);
		}

		if (accountP.AgriClass__c != null) {
			CreateClientCIF_Req_IB_v1.AgriData AgriData4 = new CreateClientCIF_Req_IB_v1.AgriData();
			AgriData4.agriClass = accountP.AgriClass__c;
			if (accountP.AgriClass_Percentage__c != null) {
				AgriData4.percentage = String.ValueOf(accountP.AgriClass_Percentage__c);
			}
			requestBean.CIcreateClientV12.Cib003i.agriData.add(AgriData4);
		}

		String cpaThresholdTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Boolean Value',
			String.valueOf(accountP.Does_the_Client_fall_under_the_CPA__c),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (cpaThresholdTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.cpaThreshold = cpaThresholdTranslated;
		}

		//Start : multiple source of income : 2020-03-16 - Anka Ganta
		String[] sourceOfincomes = accountP.Source_of_Income__c.split(';');

		List<String> sourceOfincomelist = new List<String>();

		for (String srcOfincome : sourceOfincomes) {
			String srcOfincomeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.ECASA_STRING,
				StringConstants.FIELD_SOURCE_OF_INCOME_STRING,
				srcOfincome,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			sourceOfincomelist.add(srcOfincomeTranslated);
		}
		if (sourceOfincomelist[0] != null) {
			requestBean.CIcreateClientV12.Cib003i.sourceOfIncome = sourceOfincomelist[0];
		}
		//End : multiple source of income

		//Start : multiple Country Of Operations : 2020-03-16 - Haritha
		System.debug('accountP.Country_of_Operation__c ' + accountP.Country_of_Operation__c);
		String[] countryEntoprt = new List<String>{};
		if (accountP.Country_of_Operation__c != null && accountP.Country_of_Operation__c != '') {
			countryEntoprt = accountP.Country_of_Operation__c.split(';');
		}
		List<String> countryEntoprtlist = new List<String>();

		for (String countryofopt : countryEntoprt) {
			CreateClientCIF_Req_IB_v1.CountryEntOprtData tempcountryEntoprt = new CreateClientCIF_Req_IB_v1.CountryEntOprtData();
			String countryOfOperationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Country',
				accountP.Country_of_Operation__c,
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			if (countryOfOperationTranslated != null) {
				tempcountryEntoprt.countryEntOprt = countryOfOperationTranslated;
				requestBean.CIcreateClientV12.Cib003i.CountryEntOprtData.add(tempcountryEntoprt);
			}
			countryEntoprtlist.add(countryOfOperationTranslated);
		}

		//End : multiple Country Of Operations
		if (accountP.VAT_Registration_Number__c != null) {
			requestBean.CIcreateClientV12.Cib003i.vatRegistrationNo = String.ValueOf(accountP.VAT_Registration_Number__c);
		}

		requestBean.CIcreateClientV12.Cib003i.corporateDivision = 'A';
		requestBean.CIcreateClientV12.Cib003i.mailInd = 'Y';

		if (accountP.CASA_Reference_Number__c != null) {
			requestBean.CIcreateClientV12.Cib003i.casaRefNum = accountP.CASA_Reference_Number__c;
		}
		if (accountP.Income_Tax_Number__c != null) {
			requestBean.CIcreateClientV12.Cib003i.saTaxRegis = 'Y';
		} else {
			requestBean.CIcreateClientV12.Cib003i.saTaxRegis = 'N';
		}

		if (accountP.Foreign_Tax_Number__c != null) {
			CreateClientCIF_Req_IB_v1.ForeignTaxData tempForeignTaxData = new CreateClientCIF_Req_IB_v1.ForeignTaxData();
			tempForeignTaxData.foreignTaxNo = String.valueOf(accountP.Foreign_Tax_Number__c);
			if (accountP.Country_of_Foreign_tax__c != null) {
				tempForeignTaxData.foreignTaxCtry = tanslationValueMapP.get('countryForeignTax');
			}
			requestBean.CIcreateClientV12.Cib003i.foreignTaxRegis = 'Y';
			requestBean.CIcreateClientV12.Cib003i.foreignTaxData.add(tempForeignTaxData);
		} else {
			requestBean.CIcreateClientV12.Cib003i.foreignTaxRegis = 'N';
		}

		requestBean.CIcreateClientV12.Cib003i.titleCode = '0';
		if (accountP.Date_Identified__c != null) {
			requestBean.CIcreateClientV12.Cib003i.dateIdentified = string.valueOf(accountP.Date_Identified__c).replace('-', '');
		}
		// if(accountP.Date_Verified__c!=null){
		// requestBean.CIcreateClientV12.Cib003i.dateVerified=string.valueOf(accountP.Date_Verified__c).replace('-','');
		requestBean.CIcreateClientV12.Cib003i.dateVerified = string.valueOf(System.Today().format().replace('/', ''));

		//  }
		if (accountP.Is_Marketing_Consent_Phone__c != null && accountP.Is_Marketing_Consent_Phone__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRTel = 'Y';
		} else if (accountP.Is_Marketing_Consent_Phone__c != null && accountP.Is_Marketing_Consent_Phone__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRTel = 'N';
		}
		if (accountP.Is_Marketing_Consent_Email__c != null && accountP.Is_Marketing_Consent_Email__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCREmail = 'Y';
		} else if (accountP.Is_Marketing_Consent_Email__c != null && accountP.Is_Marketing_Consent_Email__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCREmail = 'N';
		}
		if (accountP.Is_Marketing_Consent_SMS__c != null && accountP.Is_Marketing_Consent_SMS__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRSMS = 'Y';
		} else if (accountP.Is_Marketing_Consent_SMS__c != null && accountP.Is_Marketing_Consent_SMS__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRSMS = 'N';
		}
		if (accountP.Is_Marketing_Consent_Post__c != null && accountP.Is_Marketing_Consent_Post__c == true) {
			requestBean.CIcreateClientV12.Cib003i.nCRPost = 'Y';
		} else if (accountP.Is_Marketing_Consent_Post__c != null && accountP.Is_Marketing_Consent_Post__c == false) {
			requestBean.CIcreateClientV12.Cib003i.nCRPost = 'N';
		}
		if (accountP.Is_Marketing_Consent_voice_rec__c != null && accountP.Is_Marketing_Consent_voice_rec__c == true) {
			requestBean.CIcreateClientV12.Cib003i.ncrAvoice = 'Y';
		} else if (accountP.Is_Marketing_Consent_voice_rec__c != null && accountP.Is_Marketing_Consent_voice_rec__c == false) {
			requestBean.CIcreateClientV12.Cib003i.ncrAvoice = 'N';
		}
		if (
			accountP.Is_Marketing_Consent_Phone__c == true ||
			accountP.Is_Marketing_Consent_Email__c == true ||
			accountP.Is_Marketing_Consent_SMS__c == true ||
			accountP.Is_Marketing_Consent_Post__c == true ||
			accountP.Is_Marketing_Consent_voice_rec__c == true
		) {
			requestBean.CIcreateClientV12.Cib003i.nCRInd = 'Y';
		} else {
			requestBean.CIcreateClientV12.Cib003i.nCRInd = 'N';
		}
		//  if(accountP.Preferred_Communication_Info__c!=null){
		//  requestBean.CIcreateClientV12.Cib003i.emailAddress=   accountP.Preferred_Communication_Info__c;}
		for (Address__c add : addressList) {
			if (add.Account__c == accountP.Id) {
				if (add.Address_Type__c == StringConstants.BUSINESS_ADDR_STRING) {
					requestBean.CIcreateClientV12.Cib003i.businessAdd1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.businessAdd2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.businessSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.businessTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.businessPostal = add.Shipping_Zip_Postal_Code__c;
				}

				if (add.Address_Type__c == StringConstants.POSTAL_STRING) {
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.postlAddrLine2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.postlSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.postlTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.postlCodeRsa = add.Shipping_Zip_Postal_Code__c;
				}

				if (add.Address_Type__c == StringConstants.REGISTERED_ADDR_STRING) {
					requestBean.CIcreateClientV12.Cib003i.regAddrLine1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.regAddrLine2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.regSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.regTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.regCodeRsa = add.Shipping_Zip_Postal_Code__c;

					String addCountry = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.CIF_STRING,
						'Country',
						accountP.Country_of_Registration__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);

					if (addCountry != null) {
						requestBean.CIcreateClientV12.Cib003i.countryRegAddress = addCountry;
					} else {
						requestBean.CIcreateClientV12.Cib003i.countryRegAddress = '';
					}
				}

				if (add.Address_Type__c == StringConstants.HEAD_OFFICE_ADDR_STRING) {
					requestBean.CIcreateClientV12.Cib003i.hoAddrLine1 = add.Shipping_Street__c;
					requestBean.CIcreateClientV12.Cib003i.hoAddrLine2 = add.Shipping_Street_2__c;
					requestBean.CIcreateClientV12.Cib003i.hoSuburb = add.Shipping_Suburb__c;
					requestBean.CIcreateClientV12.Cib003i.hoTown = add.Shipping_City__c;
					requestBean.CIcreateClientV12.Cib003i.hoCodeRsa = add.Shipping_Zip_Postal_Code__c;

					String addCountry = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.CIF_STRING,
						'Country',
						accountP.Country_of_Registration__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);

					if (addCountry != null) {
						requestBean.CIcreateClientV12.Cib003i.countryHoAddress = addCountry;
					} else {
						requestBean.CIcreateClientV12.Cib003i.countryHoAddress = '';
					}
				}
			}
		}

		//TdB - W-004831 : Map Regulatory 3(1)f Shareholder% (Is the Cleint affected)
		System.debug('Q4a_Client_affected_by_Regulation_3_1_F__c>>>>' + accountP.Q4a_Client_affected_by_Regulation_3_1_F__c);
		if (accountP.Q4a_Client_affected_by_Regulation_3_1_F__c == true) {
			String affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Affected Person',
				String.valueOf(accountP.Q4b_How_is_the_Client_Affected__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			System.debug('affectedPersonTranslated>>>>' + affectedPersonTranslated);
			if (String.IsBlank(affectedPersonTranslated) == false) {
				requestBean.CIcreateClientV12.Cib003i.affectedPerson = affectedPersonTranslated;
			}
			if (accountP.Q4c_Exchange_Control_Expiry_date__c != null) {
				requestBean.CIcreateClientV12.Cib003i.exconExpiryDate = String.valueOf(accountP.Q4c_Exchange_Control_Expiry_date__c).replace('-', '');
			}
		} else {
			String affectedPersonTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
				StringConstants.CIF_STRING,
				'Affected Person',
				String.valueOf(accountP.Q3b_How_is_the_Client_Affected__c),
				StringConstants.OUTBOUND_RECORD_TYPE
			);
			System.debug('affectedPersonTranslated>>>>' + affectedPersonTranslated);
			if (String.IsBlank(affectedPersonTranslated) == false) {
				requestBean.CIcreateClientV12.Cib003i.affectedPerson = affectedPersonTranslated;
			}
			if (accountP.Q3c_Exchange_Control_Expiry_date__c != null) {
				requestBean.CIcreateClientV12.Cib003i.exconExpiryDate = String.valueOf(accountP.Q3c_Exchange_Control_Expiry_date__c).replace('-', '');
			}
		}

		//TdB - Map Credit Worthiness Consent
		String creditConsentTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Boolean Value',
			String.valueOf(accountP.Credit_Worthiness_Consent__c),
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (creditConsentTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.thrdPartyInd = creditConsentTranslated;
		}

		//TdB - W-005654 : Add Country Incorpration
		String countryOfIncorporationTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			'Country',
			accountP.Country_of_Incorporation__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		if (countryOfIncorporationTranslated != null) {
			requestBean.CIcreateClientV12.Cib003i.countryIncorp = countryOfIncorporationTranslated;
		}

		system.debug('requestBean-------' + requestBean);
		return requestBean;
	}

	/**
	 * @description Map fields for positive response
	 * @param respP
	 * @return CreateClientCIF_Resp_IB_v1
	 */
	public static CreateClientCIF_Resp_IB_v1 mapResponseFields(HttpResponse respP) {
		System.debug('mapResponseFields : ' + respP.getBody());
		CreateClientCIF_Resp_IB_v1 responseBean = (CreateClientCIF_Resp_IB_v1) JSON.deserialize(respP.getBody(), CreateClientCIF_Resp_IB_v1.class);
		responseBean.Status = respP.getStatus();
		responseBean.statusCode = respP.getStatusCode();

		System.debug('CIF Create Client Response' + responseBean);
		return responseBean;
	}

	/**
	 * @description Map fields for Failed Response
	 * @param statusP
	 * @param statusCodeP
	 * @param messageP
	 * @return CreateClientCIF_Resp_IB_v1
	 */
	public static CreateClientCIF_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP) {
		CreateClientCIF_Resp_IB_v1 responseBean = new CreateClientCIF_Resp_IB_v1();
		responseBean.Status = statusP;
		responseBean.statusCode = statusCodeP;
		responseBean.message = messageP;

		System.debug('CIF Create Client Failed Response' + responseBean);
		return responseBean;
	}
}