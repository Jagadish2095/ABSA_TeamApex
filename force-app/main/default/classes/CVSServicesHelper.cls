/**
 * @description       : Helper class for CVS ServiceCalls/This class has methods used by Aura components to call the CVS services(CVSValidate/CVSCreate/CVSValidate)
 * @author            : PaulJohn.duRand@absa.africa
 * @created 2020-10-29
 * @last modified on  : 2021-11-26
 * @last modified by  : PaulJohn.duRand@absa.africa
 * @modified 2021-06-10 - PaulJohn.duRand@absa.africa
 * @modified 2021-06-25 - Aaron Castelyn : ABSA - Added Residential and Postal Street 2
 * @modified 2021-06-25 - PaulJohn.duRand@absa.africa - Update VAS Indicators
 * @modified 2021-09-06 - PaulJohn.duRand@absa.africa - Initials fix for name with special char
 * @modified 2021-10-11   PaulJohn.duRand@absa.africa    Enable Staff
 **/

public without sharing class CVSServicesHelper {
	/**
	 * @description Function used to Validate fields with CVS
	 * @param accountID
	 * @param fieldMappings
	 * @return Map<String,String>
	 */
	@AuraEnabled
	public static Map<String, String> validateFields(String accountID, List<Map<String, String>> fieldMappings) {
		Map<String, String> mapList = new Map<String, String>();
		CVSValidateCIFv22_Req_IB_v1 requestBean = CVSValidateCIFv22_Req_IB_v1.GetEmptyInstance();
		requestBean = CVSValidateCIFv22_Req_IB_v1.GetEmptyBean(requestBean);
		requestBean = CVSServicesHelper.addValuesOfFieldsToValadate(requestBean, fieldMappings);
		if (accountID != null && accountID != '') {
			Account account = new AccountsSelector().selectAllById(accountID);
			if (account.Gender__pc != null) {
				if (account.Gender__pc == 'Male') {
					requestBean.CIB003I.CIcreateClientV22Request.genderCode = 1;
				} else {
					requestBean.CIB003I.CIcreateClientV22Request.genderCode = 2;
				}
			}
		}

		CVSValidateCIFv22_Resp_IB_v1 responsebean = CVSValidateCIFv22_IH_v1.CVSValidateCIFv22(requestBean);
		Boolean hasError = false;
		if (responsebean.statusMessage != null) {
			for (Map<String, String> mapId : fieldMappings) {
				for (CVSValidateCIFv22_Resp_IB_v1.Error error : responsebean.statusMessage.error) {
					if (mapId.get('ServiceField') == error.field) {
						hasError = true;
						String errorReason = error.reason.toString();
						errorReason = errorReason.Substring(1, errorReason.length() - 1);
						mapList.put(mapId.get('CMPField'), errorReason);
					}
					if (
						mapId.get('ServiceField') == 'foreignTaxDataTable' &&
						('reasonFtaxNotGivenCode' == error.field ||
						'foreignTaxCountryCode' == error.field ||
						'foreignTaxNumber' == error.field)
					) {
						hasError = true;
						String errorReason = error.reason.toString();
						errorReason = errorReason.Substring(1, errorReason.length() - 1);
						mapList.put('foreignTaxDataTable', errorReason);
					}
				}
			}
		}

		if (!hasError) {
			mapList.put('Response', 'NoError');
		}
		return mapList;
	}
	/**
	 * @description Function used by validateFields function to replace values on fields that needs to be valadated on the CVSValidateCIFv22_Req_IB_v1 on request Bean
	 * @param requestBean
	 * @param fieldMappings
	 * @return CVSValidateCIFv22_Req_IB_v1
	 */
	public static CVSValidateCIFv22_Req_IB_v1 addValuesOfFieldsToValadate(CVSValidateCIFv22_Req_IB_v1 requestBean, List<Map<String, String>> fieldMappings) {
		if (fieldMappings != null) {
			Object requestBeanAsObject = (Object) requestBean.CIB003I.CIcreateClientV22Request;
			List<CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable> foreignTaxData;
			for (Map<String, String> entry : fieldMappings) {
				String fieldValue = entry.get('Value') != null ? entry.get('Value') : '';
				if (entry.get('ServiceField') != 'foreignTaxDataTable') {
					requestBeanAsObject = Base_IB.putValue(requestBeanAsObject, entry.get('ServiceField'), entry.get('Value'));
				} else {
					foreignTaxData = (List<CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable>) JSON.deserialize(
						entry.get('Value'),
						List<CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable>.class
					);
				}
			}
			String responseBeanAsJson = JSON.serialize(requestBeanAsObject);
			requestBean.CIB003I.CIcreateClientV22Request = (CVSValidateCIFv22_Req_IB_v1.CIcreateClientV22Request) JSON.deserialize(
				responseBeanAsJson,
				CVSValidateCIFv22_Req_IB_v1.CIcreateClientV22Request.class
			);
			if (foreignTaxData != null && foreignTaxData.size() > 0) {
				for (CVSValidateCIFv22_Req_IB_v1.ForeignTaxDataTable item : foreignTaxData) {
					if (item.foreignTaxNumber == null) {
						item.foreignTaxNumber = '';
					}
				}
				requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable = foreignTaxData;
			}
		}
		return requestBean;
	}
	/**
	 * @description Function used to Create or Update customer in CIF based on if the Customer has a CIF
	 * @param objId
	 * @return String
	 */
	public static String createOrUpdate(String objId) {
		String response = '';
		String accountId = BranchFunctions.getAccountId(objId);
		Account account = [SELECT CIF__c, Client_Type__c FROM Account WHERE Account.Id = :accountId];
		if (account.CIF__c == null || account.CIF__c == '') {
			response = CVSServicesHelper.createCIF(accountId);
			if (!response.contains('Error')) {
				account.CIF__c = response;
				account.Valid_Update_Bypass__c = true;
				update account;
				response = 'Success';
			}
		} else {
			response = CVSServicesHelper.updateCIF(accountId, account.CIF__c);
		}
		return response;
	}
	/**
	 * @description Function used to Create customer in CIF
	 * @param accountId
	 * @return String
	 */
	public static String createCIF(id accountId) {
		CVSCreateCIFv22_Req_IB_v1 requestBean = CVSCreateCIFv22_Req_IB_v1.getNewInstance();
		requestBean = CVSServicesHelper.getAccountPopulatedCreateRequest(accountId, requestBean);
		CVSCreateCIFv22_Resp_IB_v1 cVSCreateCIFv22resp = CVSCreateCIFv22_IH_v1.CVSCreateCIFv22(requestBean);
		if (cVSCreateCIFv22resp.body != null) {
			if (
				cVSCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey != null &
				cVSCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey != ''
			) {
				return cVSCreateCIFv22resp.body.CIB003O.CIcreateClientV22Response.outputClientKey;
			} else {
				return 'Error';
			}
		} else {
			if (cVSCreateCIFv22resp != null) {
				return 'Error: ' + JSON.serialize(cVSCreateCIFv22resp);
			}
			return 'CVS Service Error';
		}
	}

	/**
	 * @description Function used to Update CIF client details Overload
	 * @author PaulJohn.duRand@absa.africa | 2021-07-26
	 * @param accountId
	 * @param cifCode
	 * @return String
	 **/
	public static String updateCIF(id accountId, String cifCode) {
		return updateCIF(accountId, cifCode, null);
	}

	/**
	 * @description Function used to Update CIF client details
	 * @param accountId
	 * @param cifCode
	 * @param oppId
	 * @return String
	 */
	public static String updateCIF(id accountId, String cifCode, String oppId) {
		CVSUpdateCIFv22_Req_IB_v1 requestBean = CVSUpdateCIFv22_Req_IB_v1.getNewInstance();
		requestBean = CVSServicesHelper.mapCIFtoupdate(cifCode);
		if (oppId != null) {
			requestBean = updateCIFWithVasFromApplication(oppId, requestBean);
		}
		requestBean = CVSServicesHelper.getAccountPopulatedUpdateRequest(accountId, requestBean);
		CVSUpdateCIFv22_Resp_IB_v1 updateCIFv22resp = CVSUpdateCIFv22_IH_v1.CVSUpdateCIFv22(requestBean);
		if (updateCIFv22resp.body != null) {
			return 'Success';
		} else {
			if (updateCIFv22resp.statusMessage != null) {
				return 'Error: ' + JSON.serialize(updateCIFv22resp);
			} else {
				return 'CVS Service Error';
			}
		}
	}

	/**
	 * @description Function used to Update CIF client details With Group Scheme Code
	 * @param accountId
	 * @param cifCode
	 * @param grouSchemeEmployer
	 * @return String
	 */
	public static String updateCIFWithGroupSchemeCode(String accountId, String cifCode, String grouSchemeEmployer) {
		String cleanName = grouSchemeEmployer.replace('(', '');
		cleanName = cleanName.replace(')', '');
		CVSUpdateCIFv22_Req_IB_v1 requestBean = CVSServicesHelper.mapCIFtoupdate(cifCode);
		requestBean = CVSServicesHelper.getAccountPopulatedUpdateRequest(accountId, requestBean);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeCode = grouSchemeEmployer;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeEmp = cleanName;

		CVSUpdateCIFv22_Resp_IB_v1 updateCIFv22resp = CVSUpdateCIFv22_IH_v1.CVSUpdateCIFv22(requestBean);
		if (updateCIFv22resp.body != null) {
			return 'Success';
		} else {
			if (updateCIFv22resp.statusMessage != null) {
				return 'Error: ' + JSON.serialize(updateCIFv22resp);
			} else {
				return 'CVS Service Error On UpdateCIFWithGroupSchemeCode';
			}
		}
	}

	/**
	 * @description update CIF With Vas From Application
	 * @author PaulJohn.duRand@absa.africa | 2021-07-26
	 * @param oppId
	 * @param requestBean
	 * @return CVSUpdateCIFv22_Req_IB_v1
	 **/
	private static CVSUpdateCIFv22_Req_IB_v1 updateCIFWithVasFromApplication(String oppId, CVSUpdateCIFv22_Req_IB_v1 requestBean) {
		Application__c app = [
			SELECT Id, Internet_Banking__c, Notifyme__c, Absa_Reward__c
			FROM Application__c
			WHERE Opportunity__c = :oppId
			WITH SECURITY_ENFORCED
		];
		requestBean.CIB004I.CIupdateClientDetailsV22Request.absaRewardInd = (app.Internet_Banking__c == true
			? 'Y'
			: requestBean.CIB004I.CIupdateClientDetailsV22Request.absaRewardInd);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.notifyMeInd = (app.Notifyme__c == 'Yes'
			? 'Y'
			: requestBean.CIB004I.CIupdateClientDetailsV22Request.notifyMeInd);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internetBankingInd = (app.Internet_Banking__c == true
			? 'Y'
			: requestBean.CIB004I.CIupdateClientDetailsV22Request.internetBankingInd);
		return requestBean;
	}

	/**
	 * @description Function to Populate request
	 * @param accountId
	 * @param requestBean
	 * @return CVSCreateCIFv22_Req_IB_v1
	 */
	public static CVSCreateCIFv22_Req_IB_v1 getAccountPopulatedCreateRequest(id accountId, CVSCreateCIFv22_Req_IB_v1 requestBean) {
		requestBean.NBSAPDPI.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.NBSAPDPI.NBSAPLI.providerApplication = 'ASP';
		requestBean.NBSAPDPI.NBSAPLI.traceIndicator = 'N';
		requestBean.NBSMSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.NBSMSGI.NBSMSGI.messageTarget = 'STD';
		Account account = new AccountsSelector().selectAllById(accountId);
		Date dateToday = Date.today();
		requestBean.CIB003I.CIcreateClientV22Request.dateIdentified = CVSServicesHelper.getDateForSalesforce(dateToday);
		requestBean.CIB003I.CIcreateClientV22Request.dateVerified = CVSServicesHelper.getDateForSalesforce(dateToday);
		requestBean.CIB003I.CIcreateClientV22Request.idDocTypeCode = 'SA Identity Document';
		requestBean.CIB003I.CIcreateClientV22Request.casaRefNumber = (account.CASA_Reference_Number__pc != null) ? account.CASA_Reference_Number__pc : '0';
		requestBean.CIB003I.CIcreateClientV22Request.dateOfBirth = CVSServicesHelper.getDateForSalesforce(account.PersonBirthdate);
		requestBean.CIB003I.CIcreateClientV22Request.clientTypeCode = CVSServicesHelper.getCIFClientCode(account);
		//Customer Personal information
		requestBean.CIB003I.CIcreateClientV22Request.titleCode = account.Titles__pc;
		requestBean.CIB003I.CIcreateClientV22Request.firstNames = account.FirstName.toUpperCase();
		requestBean.CIB003I.CIcreateClientV22Request.surname = account.LastName.toUpperCase();
		requestBean.CIB003I.CIcreateClientV22Request.idNumber = account.ID_Number__pc;
		requestBean.CIB003I.CIcreateClientV22Request.countryOfBirthCode = account.Country_of_Birth__pc;
		requestBean.CIB003I.CIcreateClientV22Request.homeLanguageCode = account.Home_Language__pc;
		requestBean.CIB003I.CIcreateClientV22Request.clientNationalityCode = account.Nationality_List__pc;
		String dateIdDocIssued = CVSServicesHelper.getDateForSalesforce(account.Date_Issued__pc);
		requestBean.CIB003I.CIcreateClientV22Request.dateIdDocIssued = dateIdDocIssued;
		requestBean.CIB003I.CIcreateClientV22Request.maritalStatusCode = account.Marital_Status__pc;
		requestBean.CIB003I.CIcreateClientV22Request.marriageContractTypeCode = account.Marital_Contract_Type__pc != null
			? account.Marital_Contract_Type__pc
			: '0';
		requestBean.CIB003I.CIcreateClientV22Request.sourceOfIncomeCode = account.Income_Source__pc;
		//Customer Contact details
		requestBean.CIB003I.CIcreateClientV22Request.emailAddress = account.PersonEmail != null ? account.PersonEmail : '';
		requestBean.CIB003I.CIcreateClientV22Request.cellphoneNumber = account.PersonMobilePhone;
		requestBean.CIB003I.CIcreateClientV22Request.commLanguageCode = account.Communication_Language__pc;
		requestBean.CIB003I.CIcreateClientV22Request.preferredCommMethodCode = account.Preferred_Communication_Method__pc;
		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumDialCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumber = '0';
		if (account.PersonOtherPhone != null && account.PersonOtherPhone != '') {
			requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumDialCode = integer.valueof(account.PersonOtherPhone.substring(0, 3));
			requestBean.CIB003I.CIcreateClientV22Request.homeFaxOrAlternativeNumber = account.PersonOtherPhone.substring(3, 10);
		}
		//Next of Kin
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinSurname = account.Next_of_Kin_Last_Name__pc != null
			? account.Next_of_Kin_Last_Name__pc.toUpperCase()
			: ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinFirstname = account.Next_of_Kin_First_Name_s__pc != null
			? account.Next_of_Kin_First_Name_s__pc.toUpperCase()
			: ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinRelationCode = account.Next_of_kin_Relationship__pc != null
			? account.Next_of_kin_Relationship__pc
			: ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeDialCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkDialCode = account.Next_of_Kin_Telephone_Number__pc != null
			? account.Next_of_Kin_Telephone_Number__pc.substring(0, 3)
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfkinHomeTelNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinWorkTelNumber = account.Next_of_Kin_Telephone_Number__pc != null
			? account.Next_of_Kin_Telephone_Number__pc.substring(3, 10)
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinCellNumber = account.Next_of_Kin_Cellphone_Number__pc != null
			? account.Next_of_Kin_Cellphone_Number__pc
			: ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinEmail = account.Next_of_Kin_Email_Address__pc != null
			? account.Next_of_Kin_Email_Address__pc
			: ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantTitleCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantInitials = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.nextOfKinParticipantSurname = ' ';
		//Employer
		Account accountHasPostMatric = [SELECT Has_Post_Matric_Qualification__pc FROM Account WHERE Account.Id = :accountId];

		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationInd = accountHasPostMatric.Has_Post_Matric_Qualification__pc == true ? 'Y' : 'N';
		requestBean.CIB003I.CIcreateClientV22Request.postMatricQualificationCode = accountHasPostMatric.Has_Post_Matric_Qualification__pc == true
			? account.Post_Matric_Qualification__pc
			: '0';
		string occStatus = account.Occupation_Status__pc;
		requestBean.CIB003I.CIcreateClientV22Request.occupationStatusCode = occStatus;

		if (occStatus == 'Housewife' || occStatus == 'Student' || occStatus == 'Unemployed' || occStatus == 'Pensioner' || occStatus == 'Pre-School/Scholar') {
			requestBean.CIB003I.CIcreateClientV22Request.employerName = '';
			requestBean.CIB003I.CIcreateClientV22Request.employmentSectorCode = '0';
			requestBean.CIB003I.CIcreateClientV22Request.occupationLevelCode = '0';
			requestBean.CIB003I.CIcreateClientV22Request.occupationCode = '0';
			requestBean.CIB003I.CIcreateClientV22Request.employerAddrLine1 = '';
			requestBean.CIB003I.CIcreateClientV22Request.employerSuburb = '';
			requestBean.CIB003I.CIcreateClientV22Request.employerTown = '';
			requestBean.CIB003I.CIcreateClientV22Request.employerRsaPostalCode = '0';
			requestBean.CIB003I.CIcreateClientV22Request.workTelephoneDialcode = 0;
			requestBean.CIB003I.CIcreateClientV22Request.workTelephoneNumber = '';
		} else {
			requestBean.CIB003I.CIcreateClientV22Request.employerName = account.Employer_Name__pc;
			requestBean.CIB003I.CIcreateClientV22Request.occupationStatusCode = account.Occupation_Status__pc;
			requestBean.CIB003I.CIcreateClientV22Request.employmentSectorCode = account.Employer_Sector__pc;
			requestBean.CIB003I.CIcreateClientV22Request.occupationLevelCode = account.Occupation_Level__pc;
			requestBean.CIB003I.CIcreateClientV22Request.occupationCode = account.Occupation_Category__pc;
			Address__c employersAddress = [
				SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
				FROM Address__c
				WHERE Account__c = :account.Id AND Address_TYpe__c = 'Employers'
				LIMIT 1
			];
			if (employersAddress != null) {
				requestBean.CIB003I.CIcreateClientV22Request.employerAddrLine1 = (employersAddress.Shipping_Street__c != null)
					? employersAddress.Shipping_Street__c.toUpperCase()
					: '';
				requestBean.CIB003I.CIcreateClientV22Request.employerSuburb = (employersAddress.Shipping_Suburb__c != null)
					? employersAddress.Shipping_Suburb__c.toUpperCase()
					: '';
				requestBean.CIB003I.CIcreateClientV22Request.employerTown = (employersAddress.Shipping_City__c != null)
					? employersAddress.Shipping_City__c.toUpperCase()
					: '';
				requestBean.CIB003I.CIcreateClientV22Request.employerRsaPostalCode = (employersAddress.Shipping_Zip_Postal_Code__c != null)
					? employersAddress.Shipping_Zip_Postal_Code__c.toUpperCase()
					: '';
			}
			if (account.Employer_Phone__c != null && account.Employer_Phone__c != '') {
				requestBean.CIB003I.CIcreateClientV22Request.workTelephoneDialcode = integer.valueof(account.Employer_Phone__c.substring(0, 3));
				requestBean.CIB003I.CIcreateClientV22Request.workTelephoneNumber = account.Employer_Phone__c.substring(3, 10);
			}
		}
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr];

		requestBean.CIB003I.CIcreateClientV22Request.employeeIdentified = userInfo.EmployeeNumber;
		requestBean.CIB003I.CIcreateClientV22Request.employeeVerified = userInfo.EmployeeNumber;
		requestBean.CIB003I.CIcreateClientV22Request.employeeExempted = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.incomeGroupCode = '0';
		Address__c residentialAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :account.Id AND Address_TYpe__c = 'Residential'
			LIMIT 1
		];
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.registeredAddrRsaPostalCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine1 = (residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalAddrLine2 = (residentialAddress.Shipping_Street_2__c != null)
			? residentialAddress.Shipping_Street_2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalSuburb = (residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalTown = (residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.physicalRsaPostalCode = (residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfPhysicalAddrCode = (residentialAddress.Shipping_Country__c != null)
			? residentialAddress.Shipping_Country__c
			: '';
		Address__c postalAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :account.Id AND Address_TYpe__c = 'Postal'
			LIMIT 1
		];
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine1 = (postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrLine2 = (postalAddress.Shipping_Street_2__c != null)
			? postalAddress.Shipping_Street_2__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalSuburb = (postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB003I.CIcreateClientV22Request.postalTown = (postalAddress.Shipping_City__c != null) ? postalAddress.Shipping_City__c.toUpperCase() : '';
		requestBean.CIB003I.CIcreateClientV22Request.postalAddrRsaCode = (postalAddress.Shipping_Zip_Postal_Code__c != null)
			? postalAddress.Shipping_Zip_Postal_Code__c
			: '0';
		requestBean.CIB003I.CIcreateClientV22Request.genderCode = account.Gender__pc;
		requestBean.CIB003I.CIcreateClientV22Request.initials = getInitials(account.FirstName);
		requestBean.CIB003I.CIcreateClientV22Request.saTaxRegisteredInd = account.Is_customer_registered_for_income_tax__c == true ? 'Y' : 'N';
		if (requestBean.CIB003I.CIcreateClientV22Request.saTaxRegisteredInd == 'Y') {
			requestBean.CIB003I.CIcreateClientV22Request.saTaxNumber = account.Income_Tax_Number__pc != null ? account.Income_Tax_Number__pc : '0';
			requestBean.CIB003I.CIcreateClientV22Request.reasonSaTaxNotGivenCode = (account.Income_Tax_Number__pc == null ||
				account.Income_Tax_Number__pc == '0')
				? account.Income_Tax_Number_Reason__pc
				: '';
		} else {
			requestBean.CIB003I.CIcreateClientV22Request.saTaxNumber = '0';
			requestBean.CIB003I.CIcreateClientV22Request.reasonSaTaxNotGivenCode = '';
		}

		requestBean.CIB003I.CIcreateClientV22Request.foreignTaxRegisteredInd = account.Is_customer_registered_for_foreign_tax__c == true ? 'Y' : 'N';
		if (requestBean.CIB003I.CIcreateClientV22Request.foreignTaxRegisteredInd == 'Y') {
			//ForeignTaxDataTableController foreignTaxDataTableControllerClass = new ForeignTaxDataTableController();
			List<IdentityDocument> foreignTaxList = ForeignTaxDataTableController.getTaxDocuments(account.id, 'Foreign Tax');
			if (foreignTaxList.size() > 0) {
				for (IdentityDocument idDocument : foreignTaxList) {
					CVSCreateCIFv22_Req_IB_v1.ForeignTaxDataTable taxItem = new CVSCreateCIFv22_Req_IB_v1.ForeignTaxDataTable();
					string foreignTaxCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						'CIFCodesList',
						'Casa Country',
						idDocument.Issuing_Country__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					if (idDocument.Reason_Not_Provided__c != null) {
						string reasonFtaxNotGivenCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							'CIFCodesList',
							'ReasonSATaxNotGiven',
							idDocument.Reason_Not_Provided__c,
							StringConstants.OUTBOUND_RECORD_TYPE
						);
						taxItem.reasonFtaxNotGivenCode = reasonFtaxNotGivenCode;
					} else {
						taxItem.reasonFtaxNotGivenCode = '';
					}
					taxItem.foreignTaxCountryCode = foreignTaxCountryCode;
					taxItem.foreignTaxNumber = idDocument.Document_Data__c != null ? idDocument.Document_Data__c : '';
					requestBean.CIB003I.CIcreateClientV22Request.foreignTaxDataTable.add(taxItem);
				}
			} else {
				requestBean.CIB003I.CIcreateClientV22Request.foreignTaxRegisteredInd = 'N';
			}
		}

		requestBean.CIB003I.CIcreateClientV22Request.minorChildren = '0';
		requestBean.CIB003I.CIcreateClientV22Request.voluntaryCreditConsolInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.residentialStatusCode = account.Residential_Status__pc != null ? account.Residential_Status__pc : '';
		requestBean.CIB003I.CIcreateClientV22Request.noOfJointParticipants = '0';
		requestBean.CIB003I.CIcreateClientV22Request.companyYearEnd = 0;
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneDialCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.homeTelephoneNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.workFaxDialCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.workFaxNumber = 0;
		requestBean.CIB003I.CIcreateClientV22Request.practiceNumber = '';
		requestBean.CIB003I.CIcreateClientV22Request.clientWebsite = '';
		requestBean.CIB003I.CIcreateClientV22Request.contactPerson = '';
		requestBean.CIB003I.CIcreateClientV22Request.contactPersonDesignationCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.sicCode5 = '';
		requestBean.CIB003I.CIcreateClientV22Request.vatRegistrationNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryPassportIssuedCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.dateExempted = 0;
		requestBean.CIB003I.CIcreateClientV22Request.exemptionStatusInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.exemptionCode = '';
		requestBean.CIB003I.CIcreateClientV22Request.socialGrantInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.groupSchemeEmp = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.excControlAffectedPersonCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.excControlExpiryDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.businessRsaPostalCode = '0';
		requestBean.CIB003I.CIcreateClientV22Request.detailClassificationDataTable = new List<CVSCreateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitNumber = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.tempResPermitExpDate = 0;
		requestBean.CIB003I.CIcreateClientV22Request.subClassificationCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryIncorporatedCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.cpaThresholdInd = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.controllerOverride = 0;
		requestBean.CIB003I.CIcreateClientV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine1 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeAddrLine2 = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeSuburb = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeTown = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.headOfficeRsaPostalCode = 0;
		requestBean.CIB003I.CIcreateClientV22Request.countryOfHeadOfficeAddrCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryOfRegisteredAddrCode = '';
		CVSCreateCIFv22_Req_IB_v1.CountryEntityOprtDataTable countryEntityitem = new CVSCreateCIFv22_Req_IB_v1.CountryEntityOprtDataTable();
		countryEntityitem.countryEntOprtCode = ' ';
		requestBean.CIB003I.CIcreateClientV22Request.countryEntityOprtDataTable.Add(countryEntityitem);
		requestBean.CIB003I.CIcreateClientV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB003I.CIcreateClientV22Request.sec129DeliveryAddrCode = 1;
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.nonCreditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingGroupInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingSmsInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingEmailInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingAutoVoiceInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingTelephoneInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.creditMarketingPostInd = 'N';
		requestBean.CIB003I.CIcreateClientV22Request.forecastOfMembers = 0;
		return requestBean;
	}

	/**
	 * @description Function to map CIFFields to Update Request
	 * @param accountId
	 * @param requestBean
	 * @return String
	 */
	public static CVSUpdateCIFv22_Req_IB_v1 getAccountPopulatedUpdateRequest(id accountId, CVSUpdateCIFv22_Req_IB_v1 requestBean) {
		requestBean.NBSAPDPI.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.NBSAPDPI.NBSAPLI.providerApplication = 'ASP';
		requestBean.NBSAPDPI.NBSAPLI.traceIndicator = 'N';
		requestBean.NBSMSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.NBSMSGI.NBSMSGI.messageTarget = 'STD';
		Account account = new AccountsSelector().selectAllById(accountId);
		Date dateToday = Date.today();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientCode = account.CIF__c;
		//  requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = CVSServicesHelper.getDateForSalesforce(dateToday);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateVerified = CVSServicesHelper.getDateForSalesforce(dateToday);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idDocTypeCode = account.ID_Type__pc; //'SA Identity Document';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.casaRefNumber = (account.CASA_Reference_Number__pc != null)
			? account.CASA_Reference_Number__pc
			: '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateOfBirth = CVSServicesHelper.getDateForSalesforce(account.PersonBirthdate);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientTypeCode = CVSServicesHelper.getCIFClientCode(account);
		//Customer Personal information
		requestBean.CIB004I.CIupdateClientDetailsV22Request.titleCode = account.Titles__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.firstNames = account.FirstName.toUpperCase();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.surname = account.LastName.toUpperCase();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idNumber = account.ID_Number__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfBirthCode = account.Country_of_Birth__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeLanguageCode = account.Communication_Language__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientNationalityCode = account.Nationality_List__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdDocIssued = CVSServicesHelper.getDateForSalesforce(account.Date_Issued__pc);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.maritalStatusCode = account.Marital_Status__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.marriageContractTypeCode = account.Marital_Contract_Type__pc != null
			? account.Marital_Contract_Type__pc
			: '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sourceOfIncomeCode = account.Income_Source__pc;
		//Customer Contact details
		requestBean.CIB004I.CIupdateClientDetailsV22Request.emailAddress = account.PersonEmail != null ? account.PersonEmail : '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneNumber = account.PersonMobilePhone;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.commLanguageCode = account.Communication_Language__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.preferredCommMethodCode = account.Preferred_Communication_Method__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumber = '0';
		if (account.PersonOtherPhone != null && account.PersonOtherPhone != '') {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumDialCode = account.PersonOtherPhone.substring(0, 3);
			requestBean.CIB004I.CIupdateClientDetailsV22Request.homeFaxOrAlternativeNumber = account.PersonOtherPhone.substring(3, 10);
		}

		//Next of Kin
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinSurname = account.Next_of_Kin_Last_Name__pc != null
			? account.Next_of_Kin_Last_Name__pc.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinFirstname = account.Next_of_Kin_First_Name_s__pc != null
			? account.Next_of_Kin_First_Name_s__pc.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinRelationCode = account.Next_of_kin_Relationship__pc != null
			? account.Next_of_kin_Relationship__pc
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeDialCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkDialCode = account.Next_of_Kin_Telephone_Number__pc != null
			? account.Next_of_Kin_Telephone_Number__pc.substring(0, 3)
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeTelNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkTelNumber = account.Next_of_Kin_Telephone_Number__pc != null
			? account.Next_of_Kin_Telephone_Number__pc.substring(3, 10)
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinCellNumber = account.Next_of_Kin_Cellphone_Number__pc != null
			? account.Next_of_Kin_Cellphone_Number__pc
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinEmail = account.Next_of_Kin_Email_Address__pc != null
			? account.Next_of_Kin_Email_Address__pc
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantTitleCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantInitials = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantSurname = '';
		//Employer
		Account accountHasPostMatric = [SELECT Has_Post_Matric_Qualification__pc FROM Account WHERE Account.Id = :accountId];

		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationInd = accountHasPostMatric.Has_Post_Matric_Qualification__pc == true
			? 'Y'
			: 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationCode = accountHasPostMatric.Has_Post_Matric_Qualification__pc == true
			? account.Post_Matric_Qualification__pc
			: '0';

		string occStatus = account.Occupation_Status__pc;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationStatusCode = occStatus;

		if (occStatus == 'Housewife' || occStatus == 'Student' || occStatus == 'Unemployed' || occStatus == 'Pensioner' || occStatus == 'Pre-School/Scholar') {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerName = '';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationCode = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrLine1 = '';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerSuburb = '';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerTown = '';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerRsaPostalCode = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneDialcode = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneNumber = '';
		} else {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerName = account.Employer_Name__pc;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode = account.Employer_Sector__pc;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode = account.Occupation_Level__pc;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationCode = account.Occupation_Category__pc;
			Address__c employersAddress = [
				SELECT Shipping_Street__c, Address2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
				FROM Address__c
				WHERE Account__c = :account.Id AND Address_TYpe__c = 'Employers'
				LIMIT 1
			];
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrLine1 = employersAddress.Shipping_Street__c;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerSuburb = employersAddress.Shipping_Suburb__c;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerTown = employersAddress.Shipping_City__c;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employerRsaPostalCode = employersAddress.Shipping_Zip_Postal_Code__c;
			requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneDialcode = account.Employer_Phone__c.substring(0, 3);
			requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneNumber = account.Employer_Phone__c.substring(3, 10);
		}

		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr];
		if (
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified == null ||
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified == ''
		) {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified = userInfo.EmployeeNumber;
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeVerified = userInfo.EmployeeNumber;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeExempted = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.incomeGroupCode = '0';

		Address__c residentialAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :account.Id AND Address_TYpe__c = 'Residential'
			LIMIT 1
		];
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine1 = (residentialAddress.Shipping_Street__c != null)
			? residentialAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrLine2 = (residentialAddress.Shipping_Street_2__c != null)
			? residentialAddress.Shipping_Street_2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalSuburb = (residentialAddress.Shipping_Suburb__c != null)
			? residentialAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalTown = (residentialAddress.Shipping_City__c != null)
			? residentialAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalRsaPostalCode = (residentialAddress.Shipping_Zip_Postal_Code__c != null)
			? residentialAddress.Shipping_Zip_Postal_Code__c
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfPhysicalAddrCode = (residentialAddress.Shipping_Country__c != null)
			? residentialAddress.Shipping_Country__c
			: '';
		Address__c postalAddress = [
			SELECT Shipping_Street__c, Shipping_Street_2__c, Shipping_Suburb__c, Shipping_City__c, Shipping_Country__c, Shipping_Zip_Postal_Code__c
			FROM Address__c
			WHERE Account__c = :account.Id AND Address_TYpe__c = 'Postal'
			LIMIT 1
		];
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine1 = (postalAddress.Shipping_Street__c != null)
			? postalAddress.Shipping_Street__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrLine2 = (postalAddress.Shipping_Street_2__c != null)
			? postalAddress.Shipping_Street_2__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalSuburb = (postalAddress.Shipping_Suburb__c != null)
			? postalAddress.Shipping_Suburb__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalTown = (postalAddress.Shipping_City__c != null)
			? postalAddress.Shipping_City__c.toUpperCase()
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrRsaCode = (postalAddress.Shipping_Zip_Postal_Code__c != null)
			? postalAddress.Shipping_Zip_Postal_Code__c
			: '0';
		//Customer derived fields
		requestBean.CIB004I.CIupdateClientDetailsV22Request.genderCode = account.Gender__pc;

		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxRegisteredInd = account.Is_customer_registered_for_income_tax__c == true ? 'Y' : 'N';
		if (requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxRegisteredInd == 'Y') {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxNumber = account.Income_Tax_Number__pc != null ? account.Income_Tax_Number__pc : '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.reasonSaTaxNotGivenCode = (account.Income_Tax_Number__pc == null ||
				account.Income_Tax_Number__pc == '0')
				? account.Income_Tax_Number_Reason__pc
				: '';
		} else {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxNumber = '0';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.reasonSaTaxNotGivenCode = '';
		}

		requestBean.CIB004I.CIupdateClientDetailsV22Request.initials = getInitials(account.FirstName);

		if (account.Non_Credit_Marketing_Indicator__pc != null && account.Non_Credit_Marketing_Indicator__pc != '') {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd = account.Non_Credit_Marketing_Indicator__pc.contains('SMS')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd = (account.Non_Credit_Marketing_Indicator__pc.contains('Email') &&
				account.PersonEmail != null &&
				account.PersonEmail != '')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd = account.Non_Credit_Marketing_Indicator__pc.contains(
					'Voice Recording'
				)
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd = (account.Non_Credit_Marketing_Indicator__pc.contains(
					'Telephone'
				) && requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneNumber != '')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd = account.Non_Credit_Marketing_Indicator__pc.contains('Mail')
				? 'Y'
				: 'N';

			if (
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd == 'N'
			) {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = 'N';
			} else {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = 'Y';
			}
		} else {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd = 'N';
		}

		if (account.Credit_Marketing_Indicator__pc != null && account.Credit_Marketing_Indicator__pc != '') {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd = account.Credit_Marketing_Indicator__pc.contains('SMS') ? 'Y' : 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd = (account.Credit_Marketing_Indicator__pc.contains('Email') &&
				account.PersonEmail != null &&
				account.PersonEmail != '')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd = account.Credit_Marketing_Indicator__pc.contains('Voice Recording')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd = (account.Credit_Marketing_Indicator__pc.contains('Telephone') &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneNumber != '')
				? 'Y'
				: 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingPostInd = account.Credit_Marketing_Indicator__pc.contains('Mail') ? 'Y' : 'N';

			if (
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd == 'N' &&
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd == 'N'
			) {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = 'N';
			} else {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = 'Y';
			}
		} else {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd = 'N';
			requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingPostInd = 'N';
		}

		requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd = account.Is_customer_registered_for_foreign_tax__c == true ? 'Y' : 'N';
		if (requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd == 'Y') {
			//ForeignTaxDataTableController foreignTaxDataTableControllerClass = new ForeignTaxDataTableController();
			List<IdentityDocument> foreignTaxList = ForeignTaxDataTableController.getTaxDocuments(account.id, 'Foreign Tax');
			if (foreignTaxList.size() > 0) {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd = 'Y';
				for (IdentityDocument idDocument : foreignTaxList) {
					CVSUpdateCIFv22_Req_IB_v1.ForeignTaxDataTable taxItem = new CVSUpdateCIFv22_Req_IB_v1.ForeignTaxDataTable();
					string foreignTaxCountryCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						'CIFCodesList',
						'Casa Country',
						idDocument.Issuing_Country__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					if (idDocument.Reason_Not_Provided__c != null) {
						string reasonFtaxNotGivenCode = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							'CIFCodesList',
							'ReasonSATaxNotGiven',
							idDocument.Reason_Not_Provided__c,
							StringConstants.OUTBOUND_RECORD_TYPE
						);
						taxItem.reasonFtaxNotGivenCode = reasonFtaxNotGivenCode;
					} else {
						taxItem.reasonFtaxNotGivenCode = '';
					}
					taxItem.foreignTaxCountryCode = foreignTaxCountryCode;
					taxItem.foreignTaxNumber = idDocument.Document_Data__c != null ? idDocument.Document_Data__c : '';
					requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxDataTable.add(taxItem);
				}
			} else {
				requestBean.CIB004I.CIupdateClientDetailsV22Request.foreignTaxRegisteredInd = 'N';
			}
		}

		requestBean.CIB004I.CIupdateClientDetailsV22Request.minorChildren = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.voluntaryCreditConsolInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.residentialStatusCode = account.Residential_Status__pc != null
			? account.Residential_Status__pc
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.noOfJointParticipants = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.companyYearEnd = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxDialCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxNumber = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.practiceNumber = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientWebsite = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPerson = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPersonDesignationCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sicCode5 = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.vatRegistrationNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryPassportIssuedCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateExempted = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionStatusInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.socialGrantInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeEmp = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlAffectedPersonCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlExpiryDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.businessRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.detailClassificationDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitNumber = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitExpDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.subClassificationCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryIncorporatedCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cpaThresholdInd = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.controllerOverride = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.headOfficeRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfHeadOfficeAddrCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfRegisteredAddrCode = '';
		CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable countryEntityitem = new CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable();
		countryEntityitem.countryEntOprtCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable.Add(countryEntityitem);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sec129DeliveryAddrCode = '1';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.forecastOfMembers = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine1 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrLine2 = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredSuburb = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredTown = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.registeredAddrRsaPostalCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedEstateHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.securityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inbusinessRescueAffectedInd = ' ';
		return requestBean;
	}
	/**
	 * @description Function to map CIFFields to Update Request
	 * @param cifCode
	 * @return String
	 */
	public static CVSUpdateCIFv22_Req_IB_v1 mapCIFtoupdate(String cifCode) {
		CIgetClientDetailsV12_Resp_IB_v1 cifClientDetails = BranchCIFSalesforceSyncHelper.GetUpdateAccount(cifCode);
		CVSUpdateCIFv22_Req_IB_v1 requestBean = CVSUpdateCIFv22_Req_IB_v1.getNewInstance();

		requestBean.NBSAPDPI.NBSAPLI.consumerChannel = 'BRANCH';
		requestBean.NBSAPDPI.NBSAPLI.providerApplication = 'ASP';
		requestBean.NBSAPDPI.NBSAPLI.traceIndicator = 'N';
		requestBean.NBSMSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.NBSMSGI.NBSMSGI.messageTarget = 'STD';
		if (cifClientDetails.dateIdentified == null || cifClientDetails.dateIdentified == '0') {
			Date dateToday = Date.today();
			requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = CVSServicesHelper.getDateForSalesforce(dateToday);
		} else {
			Date dateID = BranchCIFSalesforceSyncHelper.getDateForSalesforceDayFirst(cifClientDetails.dateIdentified);
			requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdentified = getDateForSalesforce(dateID);
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateVerified = cifClientDetails.dateVerified;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idDocTypeCode = cifClientDetails.idDocType;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateOfBirth = cifClientDetails.birthDate;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientTypeCode = cifClientDetails.clientType;

		//Customer Personal information
		requestBean.CIB004I.CIupdateClientDetailsV22Request.titleCode = cifClientDetails.titleCode;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.firstNames = cifClientDetails.firstNames;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.surname = cifClientDetails.surname;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idNumber = cifClientDetails.idNumber;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfBirthCode = cifClientDetails.countryOfBirth;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeLanguageCode = cifClientDetails.homeLanguage;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientNationalityCode = cifClientDetails.clientNationality;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateIdDocIssued = cifClientDetails.dateIssued;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.maritalStatusCode = cifClientDetails.maritalStatus;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.marriageContractTypeCode = cifClientDetails.mariageContrctType;
		//Customer Contact detail
		requestBean.CIB004I.CIupdateClientDetailsV22Request.emailAddress = cifClientDetails.emailAddress;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneNumber = cifClientDetails.cellphone;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.commLanguageCode = cifClientDetails.language;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.preferredCommMethodCode = cifClientDetails.prefrdCommtionMthd;
		//Next of Kin
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinSurname = cifClientDetails.nkinSurname;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinFirstname = cifClientDetails.nkinFname;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinRelationCode = cifClientDetails.nkinRela;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeDialCode = cifClientDetails.nkinDcdh;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkDialCode = cifClientDetails.nkinDcdw;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfkinHomeTelNumber = cifClientDetails.nkinTelh;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinWorkTelNumber = cifClientDetails.nkinTelw;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinCellNumber = cifClientDetails.nkinCell;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinEmail = cifClientDetails.nkinEmail;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantTitleCode = cifClientDetails.nkinTitle;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantInitials = cifClientDetails.nkinInitials;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nextOfKinParticipantSurname = cifClientDetails.nkinSurname;
		//Employer
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeIdentified = cifClientDetails.employeeIdentified;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeVerified = cifClientDetails.employeeVerified;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationStatusCode = cifClientDetails.occupationStatus;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employmentSectorCode = cifClientDetails.employmentSector;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationLevelCode = cifClientDetails.occupationLevel;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.occupationCode = cifClientDetails.occupationCode;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.incomeGroupCode = cifClientDetails.incomeGroup;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationInd = cifClientDetails.postMatricQualifd;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postMatricQualificationCode = cifClientDetails.postMatricQualfton;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.genderCode = cifClientDetails.gender;

		if (cifClientDetails.firstNames != null) {
			requestBean.CIB004I.CIupdateClientDetailsV22Request.initials = getInitials(cifClientDetails.firstNames);
		}
		requestBean.CIB004I.CIupdateClientDetailsV22Request.minorChildren = cifClientDetails.minorChildren;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.saTaxNumber = cifClientDetails.taxNumber;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneDialCode = (cifClientDetails.homeTelCode != null) ? cifClientDetails.homeTelCode : '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.homeTelephoneNumber = (cifClientDetails.homeTelephone != null)
			? cifClientDetails.homeTelephone
			: '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneDialcode = cifClientDetails.workTelCode;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workTelephoneNumber = cifClientDetails.workTelephone;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxDialCode = cifClientDetails.faxWorkCode;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.workFaxNumber = cifClientDetails.faxWorkNumber;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.practiceNumber = cifClientDetails.practiceNumber;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientWebsite = cifClientDetails.clientWebsite;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPerson = cifClientDetails.contactPerson;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.contactPersonDesignationCode = cifClientDetails.designation;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sicCode5 = cifClientDetails.siccCode5;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sourceOfIncomeCode = cifClientDetails.sourceOfIncome;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.vatRegistrationNumber = cifClientDetails.vatRegistrationNo;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlAffectedPersonCode = cifClientDetails.affectedPerson;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.excControlExpiryDate = cifClientDetails.exconExpiryDate;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.detailClassificationDataTable = new List<CVSUpdateCIFv22_Req_IB_v1.DetailClassificationDataTable>();
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitNumber = cifClientDetails.tempPermitNbr;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.tempResPermitExpDate = cifClientDetails.permitExpDte;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.subClassificationCode = cifClientDetails.subClassCde;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryIncorporatedCode = cifClientDetails.countryIncorp;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cpaThresholdInd = cifClientDetails.cpaThreshold;
		CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable countryEntityitem = new CVSUpdateCIFv22_Req_IB_v1.CountryEntityOprtDataTable();
		countryEntityitem.countryEntOprtCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryEntityOprtDataTable.Add(countryEntityitem);
		requestBean.CIB004I.CIupdateClientDetailsV22Request.sec129DeliveryAddrCode = cifClientDetails.sec129DeliveryAddr;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingGroupInd = cifClientDetails.nonCreditIndicator;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingSmsInd = cifClientDetails.nonCreditSms;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingEmailInd = cifClientDetails.nonCreditEmail;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingAutoVoiceInd = cifClientDetails.nonCreditAvoice;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingTelephoneInd = cifClientDetails.nonCreditTelephone;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.nonCreditMarketingPostInd = cifClientDetails.nonCreditPost;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingGroupInd = cifClientDetails.creditIndicator;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingSmsInd = cifClientDetails.creditSms;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingEmailInd = cifClientDetails.creditEmail;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingAutoVoiceInd = cifClientDetails.creditAvoice;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingTelephoneInd = cifClientDetails.creditTelephone;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditMarketingPostInd = cifClientDetails.creditPost;
		requestBean.CIB004I.CIupdateClientDetailsV22Request.absaRewardInd = (cifClientDetails.absaRewardIndctor != null)
			? cifClientDetails.absaRewardIndctor
			: 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.notifyMeInd = (cifClientDetails.notifyMeIndicator != null)
			? cifClientDetails.notifyMeIndicator
			: 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internetBankingInd = (cifClientDetails.internetBankinInd != null)
			? cifClientDetails.internetBankinInd
			: 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.cellphoneBankingInd = (cifClientDetails.cellphoneBankInd != null)
			? cifClientDetails.cellphoneBankInd
			: 'N';

		requestBean.CIB004I.CIupdateClientDetailsV22Request.employeeExempted = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerName = 'ABSA';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.forecastOfMembers = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.controllerOverride = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.creditWorthConsentInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfHeadOfficeAddrCode = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryOfRegisteredAddrCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.clientAgreementIssuedInd = 'Y';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.countryPassportIssuedCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.dateExempted = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionStatusInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.exemptionCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.socialGrantInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.groupSchemeEmp = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.secondaryPortfolioInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.companyYearEnd = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.voluntaryCreditConsolInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.residentialStatusCode = cifClientDetails.occupationType;
		//requestBean.CIB004I.CIupdateClientDetailsV22Request.residentialStatusCode = '';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.noOfJointParticipants = '0';
		//update fields
		requestBean.CIB004I.CIupdateClientDetailsV22Request.curatorshipHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselAppliedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.debtCounselOrderIssuedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.deceasedSpouseHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.employerAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.externalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.flexiFuneralPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.idRequiredHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inbusinessRescueAffectedInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueInd = ' ';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescueIssuedDate = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.inBusinessRescuePlacedByCode = '0';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventEstateHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.insolventInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalInvestmentPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalLifePolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.internalShortTermPolicyInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.liabilityInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.savingStatementHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.telephonebankingInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.unclaimedFundsInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.physicalAddrHoldInd = 'N';
		requestBean.CIB004I.CIupdateClientDetailsV22Request.postalAddrHoldInd = 'N';
		return requestBean;
	}

	/**
	 * @description Derive Initials From Names
	 * @author PaulJohn.duRand@absa.africa | 2021-09-06
	 * @param fullName
	 * @return string
	 **/
	private static string getInitials(string fullName) {
		List<String> fullNameList = fullName.split(' ');
		String initials = '';
		for (String x : fullNameList) {
			x = x.replace('-', '');
			x = x.replace('\'', '');
			initials = initials + x.left(1);
		}
		return initials;
	}
	/**
	 * @description Function to convert date
	 * @param sfdate
	 * @return String
	 */
	public static String getDateForSalesforce(Date sfdate) {
		String sMonth = String.valueof(sfdate.month());
		String sDay = String.valueof(sfdate.day());
		if (sMonth.length() == 1) {
			sMonth = '0' + sMonth;
		}
		if (sDay.length() == 1) {
			sDay = '0' + sDay;
		}
		String dateinserviceformat = String.valueof(sfdate.year()) + sMonth + sDay;
		return dateinserviceformat;
	}

	/**
	 * @description
	 * @author PaulJohn.duRand@absa.africa | 2021-10-08
	 * @param account
	 * @return String
	 **/
	public static String getCIFClientCode(Account account) {
		string clientType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'CIFCodesList',
			'Customertype',
			account.Client_Type__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		string idType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			'CIFCodesList',
			'Idtype',
			account.ID_Type__pc,
			StringConstants.OUTBOUND_RECORD_TYPE
		);
		return clientType + idType;
	}
}