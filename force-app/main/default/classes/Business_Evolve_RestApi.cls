/**
 * @description Api to create Business evolve structure
 * @author Masechaba
 */
@RestResource(urlMapping='/business-evolve/v1/*')
global class Business_Evolve_RestApi {
	/**
	 * @description Create Object data
	 * @param
	 * @return Business_Evolve_Response
	 */
	@HttpPost
	global static Business_Evolve_Response createObjects() {
		String ExecutionLayerRequestID;
		RestRequest req = RestContext.request;
		String body = req.requestBody.toString();
		Map<String, String> apiResponse = new Map<String, String>();
		Map<String, String> translations = new Map<String, String>();
		System.debug('body : ' + body);
		Sys_Log_Integration__c o = SystemLogger.createRequestIntegrationLog(body, '/business-evolve/v1/*', 'Jitterbit', StringConstants.SALESFORCE_STRING);

		body = replaceMappedProperties(body, Business_Evolve_Request.propertyMappings);
		Business_Evolve_Request request = (Business_Evolve_Request) JSON.deserialize(body, Business_Evolve_request.class);
		Business_Evolve_Response res = new Business_Evolve_Response();
		List<Integration_Translation__c> translationList = [
			SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c, Internal_Value__c
			FROM Integration_Translation__c
			WHERE Direction__c = :'Outbound' AND (System_Name__c = :'CIF' OR System_Name__c = :'eCasa' OR System_Name__c = :'Savings')
		];

		for (Integration_Translation__c translatedVars : translationList) {
			String mapKey =
				translatedVars.External_Value__c +
				'' +
				translatedVars.System_Name__c +
				'' +
				translatedVars.Value_Type__c +
				'' +
				translatedVars.Direction__c;
			translations.put(mapKey, translatedVars.Internal_value__c);
		}
		Map<String, Id> addressMap = new Map<String, Id>();
		Map<String, Id> tanMap = new Map<String, Id>();
		GetClientDetails_Resp_IB_v1 respBean = new GetClientDetails_Resp_IB_v1();
		if (!String.isBlank(body)) {
			String cif = request.individual != null ? request.individual.acc.cif__c : request.nonIndividual.acc.cif__c;
			system.debug('cif ' + cif);
			if (cif != null && cif != '') {
				system.debug('in cif if');
				respBean = GetClientDetails_IH_v1.getClientDetails(cif, '0', '5920');
			} else {
				respBean = null;
			}
			String accountId;
			String currentRecordTypeId;
			if (cif != null && cif != '') {
				if ([SELECT Id, cif__c FROM Account WHERE cif__c = :cif].size() > 0) {
					accountId = new AccountsSelector().selectByCIF(cif).Id;
					currentRecordTypeId = new AccountsSelector().selectByCIF(cif).RecordTypeId;
					Set<Id> accountIdSet = new Set<Id>();
					accountIdSet.add(accountId);
					List<Address__c> addressList = new AddressesSelector().addressesRelatedToAcc(accountId);
					List<Trading_as_Name__c> tanList = new TradingAsNamesSelector().selectByAccountId(accountIdSet);
					for (integer i = 0; i < addressList.size(); i++) {
						system.debug('addressList[0].Address_Type__c ' + addressList[i].Address_Type__c);
						addressMap.put(addressList[i].Address_Type__c, addressList[i].Id);
					}

					for (integer i = 0; i < tanList.size(); i++) {
						system.debug('tanList[0].Name ' + tanList[i].Name);
						tanMap.put(tanList[i].Name, tanList[i].Id);
					}
				}
			}
			try {
				apiResponse = createIndividual(body, translations, addressMap, tanMap, accountId, respBean);
				Api_Response__c thisApiResponse = new Api_Response__c();
				thisApiResponse.Account__c = apiResponse.get('accId');
				thisApiResponse.ExecutionLayerRequestID__c = request.Header.ExecutionLayerRequestID;
				thisApiResponse.OpportunityId__c = apiResponse.get('oppId');
				thisApiResponse.Application_Creation_Result__c = apiResponse.get('appId');
				thisApiResponse.Application_Product_Creation_Result__c = apiResponse.get('apId');
				thisApiResponse.Opportunity_Creation_Result__c = apiResponse.get('oppId');
				thisApiResponse.Opportunity_Line_Item_Creation_Result__c = apiResponse.get('oliId');
				thisApiResponse.Primary_Account_AddressCreation_Result__c = apiResponse.get('addId');
				thisApiResponse.Primary_Account_Creation_Result__c = apiResponse.get('accId');
				thisApiResponse.Primary_Account_TAN_Creation_Result__c = apiResponse.get('tanId');
				thisApiResponse.Product_Interest__c = apiResponse.get('productInterest');
				thisApiResponse.Request__c = body;
				insert thisApiResponse;

				Attachment a = new Attachment();
				a.ParentId = thisApiResponse.Id;
				a.Name = 'Request' + ' ' + Date.Today();
				a.ContentType = 'text/plain';
				a.Body = Blob.valueOf(body);
				insert a;

				res = buildResponse(apiResponse.get('accId'), apiResponse.get('oppId'));
				String jsonRes = JSON.serialize(res);
				createLog(200, 'Ok', body, jsonRes);
			} catch (Exception ex) {
				createLog(500, 'Error', body, ex.getLineNumber() + ', ' + ex.getCause());
				throw ex;
			}
		}
		return res;
	}

	/**
	 * @description Create Client in Salesforce
	 * @param individualRequest
	 * @param translations
	 * @param addressMap
	 * @param tanMap
	 * @param accountId
	 * @param respBean
	 * @return Map<String, String>
	 */
	public static Map<String, String> createIndividual(
		String individualRequest,
		Map<String, String> translations,
		Map<String, Id> addressMap,
		Map<String, Id> tanMap,
		String accountId,
		GetClientDetails_Resp_IB_v1 respBean
	) {
		String body = individualRequest;
		Map<String, Object> reqBody = new Map<String, Object>(); //placeholder for the JSON Body of the request
		Map<String, Object> src = new Map<String, Object>();
		Map<String, Object> apiReponseSrc = new Map<String, Object>();
		Map<String, String> apiResponse = new Map<String, String>();
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		Sys_Log_Integration__c o = SystemLogger.createRequestIntegrationLog(body, 'POST', StringConstants.SALESFORCE_STRING, '/business-evolve/v1/*');
		body = replaceMappedProperties(body, Business_Evolve_Request.propertyMappings);
		Business_Evolve_Request request = (Business_Evolve_Request) JSON.deserialize(body, Business_Evolve_request.class);
		system.debug('respBean ' + respBean);
		String respBeanString = JSON.serialize(respBean);
		system.debug('respBeanString ' + respBeanString);
		Account acc;
		if (request.individual != null) {
			acc = request.individual.acc;
			if (acc != null) {
				if (respBean == null) {
					acc.Id = accountId;
					acc.PersonTitle = acc.PersonTitle == '' ? acc.PersonTitle : String.valueOf(Integer.valueOf(acc.PersonTitle));
					acc.Source_of_Income__c = acc.Source_of_Income__c == ''
						? acc.Source_of_Income__c
						: String.valueOf(Integer.valueOf(acc.Source_of_Income__c));
					acc.Source_of_Income__pc = acc.Source_of_Income__pc == ''
						? acc.Source_of_Income__pc
						: String.valueOf(Integer.valueOf(acc.Source_of_Income__pc));
					acc.Occupation_Category__pc = acc.Occupation_Category__pc == ''
						? acc.Occupation_Category__pc
						: String.valueOf(Integer.valueOf(acc.Occupation_Category__pc));
					acc.Occupation_Status__pc = acc.Occupation_Status__pc == ''
						? acc.Occupation_Status__pc
						: String.valueOf(Integer.valueOf(acc.Occupation_Status__pc));
					acc.Occupation__pc = acc.Occupation__pc == '' ? acc.Occupation__pc : String.valueOf(Integer.valueOf(acc.Occupation__pc));
					acc.Client_Type__c = acc.Client_Type__c == '8101'
						? translations.get(acc.Client_Type__c + '' + 'eCasa' + '' + 'Client Type' + '' + 'Outbound')
						: translations.get(acc.Client_Type__c + '' + 'CIF' + '' + 'Client Type' + '' + 'Outbound');
					acc.Communication_Language__pc = translations.get(acc.Communication_Language__pc + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.Preferred_Communication_Method__pc = translations.get(
						acc.Preferred_Communication_Method__pc +
						'' +
						'CIF' +
						'' +
						'Language' +
						'' +
						'Outbound'
					);
					acc.Country_of_Operation__c = createMultiSelect(acc.Country_of_Operation__c, translations);
					acc.Countries_Traded_With__c = createMultiSelect(acc.Countries_Traded_With__c, translations);
					acc.Country_of_Birth__pc = translations.get(acc.Country_of_Birth__pc + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Country_of_Incorporation__c = translations.get(acc.Country_of_Incorporation__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Country_of_Citizenship__c = translations.get(acc.Country_of_Citizenship__c + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Business_Unit__c = 'Virtual Channel';
					acc.Country_of_Foreign_tax__c = translations.get(acc.Country_of_Foreign_tax__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Financial_Year_End__c = translations.get(acc.Financial_Year_End__c + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc.Gender__pc = translations.get(acc.Gender__pc + '' + 'CIF' + '' + 'Gender' + '' + 'Outbound');
					acc.Home_Language__pc = translations.get(acc.Home_Language__pc + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.Language__c = translations.get(acc.Language__c + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.Marital_Status__pc = translations.get(acc.Marital_Status__pc + '' + 'CIF' + '' + 'Marital Status' + '' + 'Outbound');
					acc.Marital_Contract_Type__pc = translations.get(
						acc.Marital_Contract_Type__pc +
						'' +
						'CIF' +
						'' +
						'Marital Contract Type' +
						'' +
						'Outbound'
					);
					acc.Monthly_Income__pc = translations.get(acc.Monthly_Income__pc + '' + 'CIF' + '' + 'Monthly Income' + '' + 'Outbound');
					acc.Nationality__pc = translations.get(acc.Nationality__pc + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Nature_of_Client__c = translations.get(acc.Nature_of_Client__c + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.Occupation_Category__pc = translations.get(acc.Occupation_Category__pc + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.Occupation_Status__pc = translations.get(acc.Occupation_Status__pc + '' + 'CIF' + '' + 'Occupation Status' + '' + 'Outbound');
					acc.Occupation__pc = translations.get(acc.Occupation__pc + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.PersonTitle = translations.get(acc.PersonTitle + '' + 'CIF' + '' + 'Title' + '' + 'Outbound');
					acc.Source_of_Income__c = translations.get(acc.Source_of_Income__c + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
					acc.Source_of_Income__pc = translations.get(acc.Source_of_Income__pc + '' + 'eCasa' + '' + 'Source of Income' + '' + 'Outbound');
					acc.Source_of_Income__pc = acc.Source_of_Income__pc == null
						? acc.Source_of_Income__pc
						: acc.Source_of_Income__pc.toUpperCase().replace('-', '');
					acc.Standard_Industry_SIC_Code__c = translations.get(
						acc.Standard_Industry_SIC_Code__c +
						'' +
						'CIF' +
						'' +
						'Standard Industry SIC Code' +
						'' +
						'Outbound'
					);
					acc.CASA_Screening_Status__pc = translations.get(
						acc.CASA_Screening_Status__pc +
						'' +
						'eCasa' +
						'' +
						'eCasa Status Onboarding' +
						'' +
						'Outbound'
					);
					acc.CASA_Screening_Status__c = acc.CASA_Screening_Status__pc;
					acc.CASA_Risk_Status__pc = translations.get(acc.CASA_Risk_Status__pc + '' + 'eCasa' + '' + 'Risk Rating' + '' + 'Outbound');
					acc.CASA_Risk_Status__c = acc.CASA_Risk_Status__pc;
					acc.CASA_Screening_Date__pc = date.today();
					acc.CASA_Screening_Date__c = date.today();
					acc.CASA_Reference_Number__c = acc.CASA_Reference_Number__pc;
					acc.CASA_Reference_Number__pc = acc.CASA_Reference_Number__pc;
					acc.Industry = translations.get(acc.Industry + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
				} else {
					acc.CIF__c = respBean.clientCode;
					acc.Initials__pc = respBean.initials;
					acc.Communication_Language__pc = translations.get(respBean.language + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					//acc.Communication_Method__c =translations.get(respBean.language+''+'CIF'+''+'Language'+''+'Outbound');
					acc.Language__c = translations.get(respBean.language + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.PersonTitle = translations.get(respBean.titleCode + '' + 'CIF' + '' + 'Title' + '' + 'Outbound');
					system.debug('respBean.surname ' + respBean.surname);
					acc.LastName = acc.LastName;
					system.debug('respBean.idDocType ' + respBean.idDocType);
					//acc.ID_Type__pc= translations.get(respBean.idDocType+''+'CIF'+''+'Identity Type'+''+'Outbound');
					acc.ID_Type__pc = acc.ID_Type__pc;
					String birthDate;
					system.debug('respBean.birthDate' + respBean.birthDate);
					if (respBean.birthDate != null && respBean.birthDate != '' && respBean.birthDate != '0' && respBean.birthDate.length() == 8) {
						acc.PersonBirthdate = date.newinstance(
							integer.valueOf(respBean.birthDate.substring(0, 4)),
							integer.valueOf(respBean.birthDate.substring(5, 6)),
							integer.valueOf(respBean.birthDate.substring(6, 8))
						);
					} else {
						acc.PersonBirthdate = null;
					}

					acc.Marital_Status__pc = translations.get(respBean.maritalStatus + '' + 'CIF' + '' + 'Marital Status' + '' + 'Outbound');
					acc.Marital_Contract_Type__pc = translations.get(respBean.mariageContrctType + '' + 'CIF' + '' + 'Marital Contract Type' + '' + 'Outbound');
					acc.Is_Marketing_Consent_SMS__c = respBean.smsMarkInd == 'Y' ? true : false;
					acc.Gender__pc = translations.get(respBean.gender + '' + 'CIF' + '' + 'Gender' + '' + 'Outbound');
					acc.Occupation_Category__pc = translations.get(respBean.employmentSector + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.Monthly_Income__pc = translations.get(respBean.incomeGroup + '' + 'CIF' + '' + 'Monthly Income' + '' + 'Outbound');
					acc.Home_Language__pc = translations.get(respBean.homeLanguage + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.Client_Type__c = acc.Client_Type__c == '8101'
						? translations.get(acc.Client_Type__c + '' + 'eCasa' + '' + 'Client Type' + '' + 'Outbound')
						: translations.get(acc.Client_Type__c + '' + 'CIF' + '' + 'Client Type' + '' + 'Outbound');
					acc.Income_Tax_Number__c = respBean.taxNumber != null ? respBean.taxNumber : null;
					acc.Standard_Industry_SIC_Code__c = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.FirstName = acc.FirstName;
					acc.Financial_Year_End__c = translations.get(respBean.companyYearEnd + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc.PersonMobilePhone = respBean.cellphone;
					acc.Occupation_Status__pc = translations.get(respBean.occupationStatus + '' + 'CIF' + '' + 'Occupation Status' + '' + 'Outbound');
					acc.Occupation__pc = translations.get(respBean.employmentSector + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.Occupation_Level__pc = translations.get(respBean.occupationLevel + '' + 'CIF' + '' + 'Occupation Level' + '' + 'Outbound');
					acc.Website = respBean.clientWebsite;
					//acc.=respBean.contactPerson;
					//acc.=respBean.designation;
					acc.PersonEmail = respBean.emailAddress;
					acc.Preferred_Communication_Method__c = translations.get(
						respBean.prefrdCommtionMthd +
						'' +
						'CIF' +
						'' +
						'Preferred Communication Method' +
						'' +
						'Outbound'
					);
					acc.Preferred_Communication_Method__pc = translations.get(
						respBean.prefrdCommtionMthd +
						'' +
						'CIF' +
						'' +
						'Preferred Communication Method' +
						'' +
						'Outbound'
					);
					acc.Source_of_Income__c = translations.get(respBean.sourceOfIncome + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
					acc.Source_of_Income__pc = translations.get(respBean.sourceOfIncome + '' + 'eCasa' + '' + 'Source of Income' + '' + 'Outbound');
					acc.Source_of_Income__pc = acc.Source_of_Income__pc == null
						? acc.Source_of_Income__pc
						: acc.Source_of_Income__pc.toUpperCase().replace('-', '');
					String dateIdentified;
					system.debug('respBean.dateIdentified ' + respBean.dateIdentified);
					if (respBean.dateIdentified != null) {
						dateIdentified = respBean.dateIdentified.length() < 8 &&
							respBean.dateIdentified != null
							? '0' + respBean.dateIdentified
							: respBean.dateIdentified;
					}

					acc.Date_Identified__c = respBean.dateIdentified != null &&
						dateIdentified.length() == 8
						? date.newinstance(
								integer.valueOf(dateIdentified.substring(4, 8)),
								integer.valueOf(dateIdentified.substring(3, 4)),
								integer.valueOf(dateIdentified.substring(0, 2))
						  )
						: null;

					String dateVerified;
					system.debug('respBean.dateVerified ' + respBean.dateVerified);
					if (respBean.dateVerified != null) {
						dateVerified = respBean.dateVerified.length() < 8 &&
							respBean.dateVerified != null
							? '0' + respBean.dateVerified
							: respBean.dateVerified;
					}
					acc.Date_Verified__c = respBean.dateIdentified != null &&
						dateVerified.length() == 8
						? date.newinstance(
								integer.valueOf(dateVerified.substring(4, 8)),
								integer.valueOf(dateVerified.substring(3, 4)),
								integer.valueOf(dateVerified.substring(0, 2))
						  )
						: null;
					acc.Identified_by_Employee_Number__c = respBean.employeeIdentified;
					acc.Verified_by_Employee_Number__c = respBean.employeeVerified;
					acc.VAT_Registration_Number__c = respBean.vatRegistrationNo != null &&
						respBean.vatRegistrationNo != ''
						? decimal.valueOf(respBean.vatRegistrationNo)
						: null;
					acc.Nationality__pc = translations.get(respBean.clientNationality + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Country_of_Citizenship__c = translations.get(respBean.clientNationality + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Country_of_Origin__pc = translations.get(respBean.countryOfOrigin + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					//acc.Post_Matric_Qualification__pc= respBean.postMatricQualifd;
					if (respBean.postMatricQualfton != '0') {
						acc.Post_Matric_Qualification__pc = translations.get(
							respBean.postMatricQualfton +
							'' +
							'CIF' +
							'' +
							'Post Matric Qualification' +
							'' +
							'Outbound'
						);
					} else {
						acc.Post_Matric_Qualification__pc = '';
					}
					// acc.Post_Matric_Qualification__pc= decimal.valueOf(respBean.postMatricQualfton)>0? translations.get(respBean.postMatricQualfton+''+'CIF'+''+'Post Matric Qualification'+''+'Outbound'):'';
					acc.Does_the_Client_receive_Social_a_Grant__c = respBean.receiveSocialGrant == 'Y' ? true : false;
					acc.Excon_Exprity_Date__c = respBean.exconExpiryDate;
					String dateIssued;
					if (respBean.dateIssued != null) {
						dateIssued = respBean.dateIssued.length() < 8 && respBean.dateIssued != null ? '0' + respBean.dateIssued : respBean.dateIssued;
					}
					acc.Date_Issued__pc = respBean.dateIssued != null &&
						dateIssued.length() == 8
						? date.newinstance(
								integer.valueOf(dateIssued.substring(4, 8)),
								integer.valueOf(dateIssued.substring(3, 4)),
								integer.valueOf(dateIssued.substring(0, 2))
						  )
						: null;
					acc.Client_Group__c = respBean.clientGroup == 'N' ? 'Non Individual' : 'SOLE TRADER CLIENT';
					acc.Id = accountId;
					acc.Countries_Traded_With__c = createMultiSelect(acc.Countries_Traded_With__c, translations);
					acc.Preferred_Communication_Method__c = translations.get(
						respBean.prefrdCommtionMthd +
						'' +
						'CIF' +
						'' +
						'Preferred Communication Method' +
						'' +
						'Outbound'
					);
					acc.Country_of_Birth__pc = translations.get(respBean.countryOfBirth + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Country_of_Incorporation__c = translations.get(respBean.countryIncorp + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Business_Unit__c = 'Virtual Channel';
					acc.Financial_Year_End__c = translations.get(respBean.companyYearEnd + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc.Nationality__pc = translations.get(respBean.clientNationality + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Occupation_Category__pc = translations.get(respBean.occupationCode + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.Occupation_Status__pc = translations.get(respBean.occupationStatus + '' + 'CIF' + '' + 'Occupation Status' + '' + 'Outbound');
					acc.Occupation__pc = translations.get(respBean.employmentSector + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc.PersonTitle = translations.get(respBean.titleCode + '' + 'CIF' + '' + 'Title' + '' + 'Outbound');
					acc.Standard_Industry_SIC_Code__c = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.CASA_Screening_Status__pc = translations.get(
						acc.CASA_Screening_Status__pc +
						'' +
						'eCasa' +
						'' +
						'eCasa Status Onboarding' +
						'' +
						'Outbound'
					);
					acc.CASA_Screening_Status__c = acc.CASA_Screening_Status__pc;
					acc.CASA_Risk_Status__pc = translations.get(acc.CASA_Risk_Status__pc + '' + 'eCasa' + '' + 'Risk Rating' + '' + 'Outbound');
					acc.CASA_Risk_Status__c = acc.CASA_Risk_Status__pc;
					acc.CASA_Reference_Number__c = acc.CASA_Reference_Number__pc;
					acc.CASA_Reference_Number__pc = acc.CASA_Reference_Number__pc;
					acc.CASA_Screening_Date__pc = date.today();
					acc.CASA_Screening_Date__c = date.today();
					acc.Industry = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.ExecutionLayerRequestID__c = acc.ExecutionLayerRequestID__c;
					//
					if (respBean.clsPercEntry != null) {
						for (integer i = 0; i < respBean.clsPercEntry.size(); i++) {
							if (i == 0) {
								acc.SIC_Classification_1__c = translations.get(
									respBean.clsPercEntry[i].classification +
									'' +
									'CIF' +
									'' +
									'SIC Classification' +
									'' +
									'Outbound'
								);
								acc.SIC_Classification_1_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
							}

							if (i == 1) {
								acc.SIC_Classification_2__c = translations.get(
									respBean.clsPercEntry[i].classification +
									'' +
									'CIF' +
									'' +
									'SIC Classification' +
									'' +
									'Outbound'
								);
								acc.SIC_Classification_2_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
							}

							if (i == 2) {
								acc.SIC_Classification_3__c = translations.get(
									respBean.clsPercEntry[i].classification +
									'' +
									'CIF' +
									'' +
									'SIC Classification' +
									'' +
									'Outbound'
								);
								acc.SIC_Classification_3_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
							}
						}
					}

					//Set default Country of Incorporation to South Africa
					if (respBean.countryIncorp != null && respBean.countryIncorp != '') {
						acc.Country_of_Incorporation__c = translations.get(respBean.countryIncorp + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					} else if (request.individual.acc.Country_of_Incorporation__c != null && request.individual.acc.Country_of_Incorporation__c != '') {
						acc.Country_of_Incorporation__c = translations.get(
							request.individual.acc.Country_of_Incorporation__c +
							'' +
							'CIF' +
							'' +
							'Country' +
							'' +
							'Outbound'
						);
					} else {
						acc.Country_of_Incorporation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					}

					acc.Client_Intent_To_Go_Into_Business_Rescue__c = respBean.inBusinessRescue == 'N' ? false : true;
					acc.Business_Rescue_Affected_Party__c = respBean.placedBy;
					acc.NCA_Threshold__c = respBean.ncaThreshold;
					if (respBean.cpaThreshold == 'Y') {
						acc.Client_NCA_Status__c = 'YES';
					} else if (respBean.cpaThreshold == 'N') {
						acc.Client_NCA_Status__c = 'NO';
					}
					//acc.Client_NCA_Status__c=respBean.cpaThreshold;
					acc.Next_of_Kin_Last_Name__pc = respBean.nkinSurname;
					acc.Next_of_Kin_First_Name_s__pc = respBean.nkinFname;
					acc.Next_of_Kin_Relationship__pc = translations.get(respBean.nkinRela + '' + 'CIF' + '' + 'Relationship' + '' + 'Outbound');
					acc.Next_of_Kin_Telephone_Number__pc = respBean.nkinTelh;
					acc.Next_of_Kin_Cellphone_Number__pc = respBean.nkinCell;
					acc.Next_of_Kin_Email_Address__pc = respBean.nkinEmail;
					acc.Next_of_Kin_Initial__pc = respBean.nkinInitials;
					acc.Country_of_Birth__pc = translations.get(respBean.countryOfBirth + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Preferred_delivery_method_Legal_Notices__c = translations.get(
						respBean.sec129DeliveryAddr +
						'' +
						'CIF' +
						'' +
						'Section 129 Delivery' +
						'' +
						'Outbound'
					);
					// acc.Reason_For_Not_Providing_SA_Tax_Number__c=respBean.rsonSaTaxNotGiven;
					if (respBean.foreignTaxData != null) {
						for (integer i = 0; i < respBean.foreignTaxData.size(); i++) {
							system.debug('respBean.foreignTaxData ' + respBean.foreignTaxData[i].foreignTaxNo);
							if (respBean.foreignTaxData[i].foreignTaxNo != null && respBean.foreignTaxData[i].foreignTaxNo != '') {
								acc.Foreign_Tax_Number__c = respBean.foreignTaxData[i] != null &&
									respBean.foreignTaxData[i].foreignTaxNo != ''
									? decimal.valueOf(respBean.foreignTaxData[i].foreignTaxNo)
									: null;
								acc.Country_of_Foreign_tax__c = translations.get(
									respBean.foreignTaxData[i].foreignTaxCtry +
									'' +
									'CIF' +
									'' +
									'Country' +
									'' +
									'Outbound'
								);
							}
						}
					}

					//Set default Country of Operation to South Africa
					String countryEntOprt;
					if (respBean.countryEntOprtData != null && respBean.countryEntOprtData.size() > 0) {
						for (integer i = 0; i < respBean.countryEntOprtData.size(); i++) {
							if (respBean.countryEntOprtData[i].countryEntOprt != null) {
								countryEntOprt = respBean.countryEntOprtData[i].countryEntOprt + ';';
							}
						}
						acc.Country_of_Operation__c = createMultiSelect(countryEntOprt, translations);
					}

					if (acc.Country_of_Operation__c == null || acc.Country_of_Operation__c == '') {
						if (request.individual.acc.Country_of_Operation__c != null && request.individual.acc.Country_of_Operation__c != '') {
							acc.Country_of_Operation__c = translations.get(
								request.individual.acc.Country_of_Operation__c +
								'' +
								'CIF' +
								'' +
								'Country' +
								'' +
								'Outbound'
							);
						} else {
							acc.Country_of_Operation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
						}
					}
				}
			}
		} else {
			acc = request.nonIndividual.acc;
			if (acc != null) {
				//if (respBean == null) {
				acc.Id = accountId;
				acc.Source_of_Income__c = acc.Source_of_Income__c == '' ? acc.Source_of_Income__c : String.valueOf(Integer.valueOf(acc.Source_of_Income__c));
				acc.Monthly_Income__c = acc.Monthly_Income__c == '' ? acc.Monthly_Income__c : String.valueOf(Integer.valueOf(acc.Monthly_Income__c));
				acc.Client_Type__c = acc.Client_Type__c == '03101'
					? translations.get(acc.Client_Type__c + '' + 'eCasa' + '' + 'Client Type' + '' + 'Outbound')
					: translations.get(acc.Client_Type__c + '' + 'CIF' + '' + 'Client Type' + '' + 'Outbound');
				//TODO fix this
				acc.Country_of_Operation__c = createMultiSelect(acc.Country_of_Operation__c, translations);
				acc.Countries_Traded_With__c = createMultiSelect(acc.Countries_Traded_With__c, translations);
				//if(acc.Country_of_Incorporation__c != null){
				//String countInco = translations.get(acc.Country_of_Incorporation__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				//if(countInco != null){
				//acc.Country_of_Incorporation__c = countInco;
				//}else{
				//    acc.Country_of_Incorporation__c =  acc.Country_of_Incorporation__c;  }}
				acc.Country_of_Citizenship__c = translations.get(acc.Country_of_Citizenship__c + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
				acc.Country_of_Foreign_tax__c = translations.get(acc.Country_of_Foreign_tax__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				acc.Financial_Year_End__c = translations.get(acc.Financial_Year_End__c + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
				acc.Language__c = translations.get(acc.Language__c + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
				acc.Source_of_Income__c = translations.get(acc.Source_of_Income__c + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
				acc.Nature_of_Client__c = translations.get(acc.Nature_of_Client__c + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
				acc.Standard_Industry_SIC_Code__c = translations.get(
					acc.Standard_Industry_SIC_Code__c +
					'' +
					'CIF' +
					'' +
					'Standard Industry SIC Code' +
					'' +
					'Outbound'
				);
				acc.Preferred_Communication_Method__c = translations.get(
					acc.Preferred_Communication_Method__c +
					'' +
					'CIF' +
					'' +
					'Preferred Communication Method' +
					'' +
					'Outbound'
				);
				acc.Industry = translations.get(acc.Industry + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
				acc.Monthly_Income__c = translations.get(acc.Monthly_Income__c + '' + 'CIF' + '' + 'Monthly Income' + '' + 'Outbound');
				acc.CASA_Screening_Status__c = translations.get(acc.CASA_Screening_Status__c + '' + 'eCasa' + '' + 'eCasa Status Onboarding' + '' + 'Outbound');
				acc.CASA_Risk_Status__c = translations.get(acc.CASA_Risk_Status__c + '' + 'eCasa' + '' + 'Risk Rating' + '' + 'Outbound');
				acc.CASA_Reference_Number__c = acc.CASA_Reference_Number__c;
				acc.CASA_Screening_Date__c = date.today();

				//Set default Country of Incorporation to South Africa
				if (respBean != null && respBean.countryIncorp != null && respBean.countryIncorp != '') {
					acc.Country_of_Incorporation__c = translations.get(respBean.countryIncorp + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				} else if (request.nonIndividual.acc.Country_of_Incorporation__c != null && request.nonIndividual.acc.Country_of_Incorporation__c != '') {
					acc.Country_of_Incorporation__c = translations.get(
						request.nonIndividual.acc.Country_of_Incorporation__c +
						'' +
						'CIF' +
						'' +
						'Country' +
						'' +
						'Outbound'
					);
				} else {
					acc.Country_of_Incorporation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				}

				//Set default Country of Operation to South Africa
				String countryEntOprt;
				if (respBean != null && respBean.countryEntOprtData != null && respBean.countryEntOprtData.size() > 0) {
					for (integer i = 0; i < respBean.countryEntOprtData.size(); i++) {
						if (respBean.countryEntOprtData[i].countryEntOprt != null) {
							countryEntOprt = respBean.countryEntOprtData[i].countryEntOprt + ';';
						}
					}
					acc.Country_of_Operation__c = createMultiSelect(countryEntOprt, translations);
				}

				if (acc.Country_of_Operation__c == null || acc.Country_of_Operation__c == '') {
					if (request.nonIndividual.acc.Country_of_Operation__c != null && request.nonIndividual.acc.Country_of_Operation__c != '') {
						acc.Country_of_Operation__c = translations.get(
							request.nonIndividual.acc.Country_of_Operation__c +
							'' +
							'CIF' +
							'' +
							'Country' +
							'' +
							'Outbound'
						);
					} else {
						acc.Country_of_Operation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					}
				}
				/*} else {
					acc.CIF__c = respBean.clientCode;
					// acc.Communication_Method__c=translations.get(respBean.language+''+'CIF'+''+'Language'+''+'Outbound');
					acc.Language__c = translations.get(respBean.language + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc.Name = respBean.surname;
					acc.ID_Type__c = translations.get(respBean.idDocType + '' + 'CIF' + '' + 'Identity Type' + '' + 'Outbound');
					acc.Is_Marketing_Consent_SMS__c = respBean.smsMarkInd == 'Y' ? true : false;
					acc.Monthly_Income__c = translations.get(respBean.incomeGroup + '' + 'CIF' + '' + 'Monthly Income' + '' + 'Outbound');
					acc.Client_Type__c = acc.Client_Type__c == '8101'
						? translations.get(acc.Client_Type__c + '' + 'eCasa' + '' + 'Client Type' + '' + 'Outbound')
						: translations.get(acc.Client_Type__c + '' + 'CIF' + '' + 'Client Type' + '' + 'Outbound');
					acc.Income_Tax_Number__c = respBean.taxNumber != null && respBean.taxNumber != '' ? decimal.valueOf(respBean.taxNumber) : null;
					acc.Standard_Industry_SIC_Code__c = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.Financial_Year_End__c = translations.get(respBean.companyYearEnd + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc.Website = respBean.clientWebsite;
					//acc.=respBean.contactPerson;
					//acc.=respBean.designation;
					acc.Active_Email__c = respBean.emailAddress;
					acc.Preferred_Communication_Method__c = translations.get(
						respBean.prefrdCommtionMthd +
						'' +
						'CIF' +
						'' +
						'Preferred Communication Method' +
						'' +
						'Outbound'
					);
					acc.Source_of_Income__c = translations.get(respBean.sourceOfIncome + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
                    if(respBean.dateIdentified != null){
                        String dateIdentified = respBean.dateIdentified.length() < 8 &&
                            respBean.dateIdentified != null
                            ? '0' + respBean.dateIdentified
                            : respBean.dateIdentified;
                        acc.Date_Identified__c = respBean.dateIdentified != null
                            ? date.newinstance(
                                integer.valueOf(dateIdentified.substring(4, 8)),
                                integer.valueOf(dateIdentified.substring(3, 4)),
                                integer.valueOf(dateIdentified.substring(0, 2))
                            )
                            : null;
                    }
                    
                    if(respBean.dateVerified != null){
                        String dateVerified = respBean.dateVerified.length() < 8 &&
                            respBean.dateVerified != null
                            ? '0' + respBean.dateVerified
                            : respBean.dateVerified;
                        acc.Date_Verified__c = respBean.dateVerified != null
                            ? date.newinstance(
                                integer.valueOf(dateVerified.substring(4, 8)),
                                integer.valueOf(dateVerified.substring(3, 4)),
                                integer.valueOf(dateVerified.substring(0, 2))
                            )
                            : null;
                    }
                    
					acc.Identified_by_Employee_Number__c = respBean.employeeIdentified;
					acc.Verified_by_Employee_Number__c = respBean.employeeVerified;
					// acc.VAT_Registration_Number__c = decimal.valueOf(respBean.vatRegistrationNo);
					acc.Country_of_Citizenship__c = translations.get(respBean.clientNationality + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc.Countries_Traded_With__c = createMultiSelect(acc.Countries_Traded_With__c, translations);
					acc.Excon_Exprity_Date__c = respBean.exconExpiryDate;
                    
                    if(respBean.dateIssued != null) {
					String dateIssued = respBean.dateIssued.length() < 8 && respBean.dateIssued != null ? '0' + respBean.dateIssued : respBean.dateIssued;
					acc.Date_Issued__pc = respBean.dateIssued != null
						? date.newinstance(
								integer.valueOf(dateIssued.substring(4, 8)),
								integer.valueOf(dateIssued.substring(3, 4)),
								integer.valueOf(dateIssued.substring(0, 2))
						  )
						: null;
                    }
					acc.Client_Group__c = respBean.clientGroup == 'N' ? 'Non Individual' : 'SOLE TRADER CLIENT';
					acc.Id = accountId;
					acc.Country_of_Incorporation__c = translations.get(respBean.countryIncorp + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc.Business_Unit__c = 'Virtual Channel';
					acc.Financial_Year_End__c = translations.get(respBean.companyYearEnd + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc.Standard_Industry_SIC_Code__c = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.CASA_Screening_Status__c = translations.get(
						acc.CASA_Screening_Status__c +
						'' +
						'eCasa' +
						'' +
						'eCasa Status Onboarding' +
						'' +
						'Outbound'
					);
					acc.CASA_Risk_Status__c = translations.get(acc.CASA_Risk_Status__c + '' + 'eCasa' + '' + 'Risk Rating' + '' + 'Outbound');
					acc.CASA_Reference_Number__c = acc.CASA_Reference_Number__c;
					acc.CASA_Screening_Date__c = date.today();
					acc.Industry = translations.get(respBean.siccCode5 + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc.ExecutionLayerRequestID__c = acc.ExecutionLayerRequestID__c;
					//
                    if(respBean.clsPercEntry != null) {
					for (integer i = 0; i < respBean.clsPercEntry.size(); i++) {
						if (i == 0) {
							acc.SIC_Classification_1__c = translations.get(
								respBean.clsPercEntry[i].classification +
								'' +
								'CIF' +
								'' +
								'SIC Classification' +
								'' +
								'Outbound'
							);
							acc.SIC_Classification_1_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
						}

						if (i == 1) {
							acc.SIC_Classification_2__c = translations.get(
								respBean.clsPercEntry[i].classification +
								'' +
								'CIF' +
								'' +
								'SIC Classification' +
								'' +
								'Outbound'
							);
							acc.SIC_Classification_2_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
						}

						if (i == 2) {
							acc.SIC_Classification_3__c = translations.get(
								respBean.clsPercEntry[i].classification +
								'' +
								'CIF' +
								'' +
								'SIC Classification' +
								'' +
								'Outbound'
							);
							acc.SIC_Classification_3_Percentage__c = decimal.valueOf(respBean.clsPercEntry[i].percentage);
						}
					}
                    }

					//Set default Country of Incorporation to South Africa
					if (respBean.countryIncorp != null && respBean.countryIncorp != '') {
						acc.Country_of_Incorporation__c = translations.get(respBean.countryIncorp + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					} else if (request.nonIndividual.acc.Country_of_Incorporation__c != null && request.nonIndividual.acc.Country_of_Incorporation__c != '') {
						acc.Country_of_Incorporation__c = translations.get(
							request.nonIndividual.acc.Country_of_Incorporation__c +
							'' +
							'CIF' +
							'' +
							'Country' +
							'' +
							'Outbound'
						);
					} else {
						acc.Country_of_Incorporation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					}
					acc.Client_Intent_To_Go_Into_Business_Rescue__c = respBean.inBusinessRescue == 'N' ? false : true;
					acc.Business_Rescue_Affected_Party__c = respBean.placedBy;
					acc.NCA_Threshold__c = respBean.ncaThreshold;
					acc.Client_NCA_Status__c = respBean.cpaThreshold;

					acc.Preferred_delivery_method_Legal_Notices__c = translations.get(
						respBean.sec129DeliveryAddr +
						'' +
						'CIF' +
						'' +
						'Section 129 Delivery' +
						'' +
						'Outbound'
					);
					// acc.Reason_For_Not_Providing_SA_Tax_Number__c=respBean.rsonSaTaxNotGiven;
					
                    if(respBean.foreignTaxData != null) {
					for (integer i = 0; i < respBean.foreignTaxData.size(); i++) {
						if (respBean.foreignTaxData[i].foreignTaxNo != null && respBean.foreignTaxData[i].foreignTaxNo != '') {
							acc.Foreign_Tax_Number__c = decimal.valueOf(respBean.foreignTaxData[i].foreignTaxNo);

							acc.Country_of_Foreign_tax__c = translations.get(
								respBean.foreignTaxData[i].foreignTaxCtry +
								'' +
								'CIF' +
								'' +
								'Country' +
								'' +
								'Outbound'
							);
						}
					}
                }

					//Set default Country of Operation to South Africa
					String countryEntOprt;

					if (respBean.countryEntOprtData != null && respBean.countryEntOprtData.size() > 0) {
						for (integer i = 0; i < respBean.countryEntOprtData.size(); i++) {
							if (respBean.countryEntOprtData[i].countryEntOprt != null) {
								countryEntOprt = respBean.countryEntOprtData[i].countryEntOprt + ';';
							}
						}

						acc.Country_of_Operation__c = createMultiSelect(countryEntOprt, translations);
					}

					if (acc.Country_of_Operation__c == null || acc.Country_of_Operation__c == '') {
						if (request.nonIndividual.acc.Country_of_Operation__c != null && request.nonIndividual.acc.Country_of_Operation__c != '') {
							acc.Country_of_Operation__c = translations.get(
								request.nonIndividual.acc.Country_of_Operation__c +
								'' +
								'CIF' +
								'' +
								'Country' +
								'' +
								'Outbound'
							);
						} else {
							acc.Country_of_Operation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
						}
					}
				
                }*/
			}
		}
		//Default Countries Traded with to SA if it came in as blank
        if(acc.Countries_Traded_With__c == null || acc.Countries_Traded_With__c == '') {
            acc.Countries_Traded_With__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
        }
		acc.FinServ__Status__c = 'Active';
		try {
			upsert acc;
			apiResponse.put('accId', acc.Id);
		} catch (Exception ex) {
			Sys_Log_Integration__c failureLog = createLog(500, 'Error', body, ex.getLineNumber() + ', ' + ex.getCause());
			logList.add(failureLog);
			throw ex;
		}

		insert logList;
		Id personContactId;
		if (request.individual != null) {
			personContactId = [SELECT PersonContactId FROM Account WHERE id = :acc.Id].PersonContactId;
		}

		List<Address__c> addrList = new List<Address__c>();
		if (request.individual != null) {
			addrList = request.individual.addresses;
			for (integer i = 0; i < request.Individual.relatedParties.size(); i++) {
				for (Address__c addr : request.Individual.relatedParties[i].addresses) {
					addrList.add(addr);
				}
			}
		} else {
			addrList = request.nonIndividual.addresses;
		}

		List<Address__c> addressesUpsert = new List<Address__c>();
		if (addrList != null) {
			for (Address__c addr : addrList) {
				addr.Id = addressMap.get(addr.Address_Type__c);
				addr.Client_Entity_Type__c = acc.Client_Type__c;
				addr.Account__c = acc.Id;
				addr.Contact__c = personContactId;
				addr.Shipping_Country__c = translations.get(addr.Shipping_Country__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				if (!addressesUpsert.contains(addr)) {
					addressesUpsert.add(addr);
				}
				//upsert addr;
				//apiResponse = createAPI('addId', apiResponse, addr.Id);
			}
		}
		if (addressesUpsert != null && addressesUpsert.size() > 0) {
			upsert addressesUpsert;
			for (Address__c eachAddress : addressesUpsert) {
				apiResponse = createAPI('addId', apiResponse, eachAddress.Id);
			}
		}

		List<Trading_as_Name__c> tanList = new List<Trading_as_Name__c>();
		List<Trading_as_Name__c> tanesUpsert = new List<Trading_as_Name__c>();
		if (request.individual != null) {
			tanList = request.individual.tradingAsNames;
		} else {
			tanList = request.nonIndividual.tradingAsNames;
		}
		if (tanList != null) {
			for (Trading_as_Name__c tan : tanList) {
				if (tan.Name != null || tan.Name != '') {
					Trading_as_Name__c tempTan = new Trading_as_Name__c();
					tempTan.Id = tanMap.get(tan.Name.trim());
					tempTan.Name = tan.Name;
					tempTan.Account__c = acc.id;
					tanesUpsert.add(tempTan);
					//upsert tan;
					//apiResponse = createAPI('tanId', apiResponse, tan.Id);
				}
			}
			if (tanesUpsert != null && tanesUpsert.size() > 0) {
				upsert tanesUpsert;
				for (Trading_as_Name__c eachTAN : tanesUpsert) {
					apiResponse = createAPI('tanId', apiResponse, eachTAN.Id);
				}
			}
		}

		//acc.=respBean.contactPerson;
		//acc.=respBean.designation;

		if (respBean != null) {
			if (respBean.contactPerson != null && respBean.contactPerson != '') {
				Account contactPerson = new Account();
				contactPerson.LastName = respBean.contactPerson;
				contactPerson.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();
				insert contactPerson;

				Id contactPersnContactId = [SELECT PersonContactId FROM Account WHERE id = :contactPerson.Id].PersonContactId;

				AccountContactRelation accConRel = new AccountContactRelation();
				accConRel.AccountId = acc.Id;
				accConRel.ContactId = contactPersnContactId;
				accConRel.Roles = 'Contact Person';
				accConRel.Primary_Entity_Id__c = acc.Id;
				//accConRel.Designation__c = respBean.designation != null || respBean.designation != '' ? respBean.designation : null;
				insert accConRel;
			}
		}

		AccountContactRelation calcRecord;
		integer relatedSize;
		List<Account> accRelatedPartyUpsert = new List<Account>();
		Map<String, Account> accRelatedPartyMap = new Map<String, Account>();
		if (request.nonIndividual != null) {
			relatedSize = request.nonIndividual.relatedParties.size();
			if (request.nonIndividual.relatedParties != null) {
				//Add all CIF's to List
                Set<String> accCIF = new Set<String>();
                for (integer i = 0; i < request.nonIndividual.relatedParties.size(); i++) {
                    if(request.nonIndividual.relatedParties[i].acc.CIF__c != null && request.nonIndividual.relatedParties[i].acc.CIF__c != '') {
                        accCIF.add(request.nonIndividual.relatedParties[i].acc.CIF__c);
                    }
                }
                
                Map<String,Id> cifIdMap = new Map<String,Id>();
                if(accCIF != null && accCIF.size() > 0) {
                    for(Account eachAcc : new AccountsSelector().selectByCIF(accCIF, 300)) {
                        cifIdMap.put(eachAcc.CIF__c, eachAcc.Id);
                    }
                }
				for (integer i = 0; i < request.nonIndividual.relatedParties.size(); i++) {
					Account acc2 = request.nonIndividual.relatedParties[i].acc;
					if(cifIdMap.containsKey(request.nonIndividual.relatedParties[i].acc.CIF__c)) {
                        acc2.Id = cifIdMap.get(request.nonIndividual.relatedParties[i].acc.CIF__c);
                    }
					acc2.PersonTitle = acc2.PersonTitle != '' ? String.valueOf(Integer.valueOf(acc2.PersonTitle)) : acc2.PersonTitle;
					acc2.Source_of_Income__c = acc2.Source_of_Income__c != ''
						? String.valueOf(Integer.valueOf(acc2.Source_of_Income__c))
						: acc2.Source_of_Income__c;
					acc2.Occupation_Category__pc = acc2.Occupation_Category__pc != ''
						? String.valueOf(Integer.valueOf(acc2.Occupation_Category__pc))
						: acc2.Occupation_Category__pc;
					acc2.Occupation_Status__pc = acc2.Occupation_Status__pc != ''
						? String.valueOf(Integer.valueOf(acc2.Occupation_Status__pc))
						: acc2.Occupation_Status__pc;
					acc2.Occupation__pc = acc2.Occupation__pc != '' ? String.valueOf(Integer.valueOf(acc2.Occupation__pc)) : acc2.Occupation__pc;
					acc2.Client_Type__c = 'Individual';
					acc2.Client_Group__c = 'Individual';
					acc2.Communication_Language__pc = acc2.Communication_Language__pc == ''
						? 'English'
						: translations.get(acc2.Communication_Language__pc + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					//TODO fix this
					acc2.Country_of_Operation__c = createMultiSelect(acc2.Country_of_Operation__c, translations);
					acc2.Countries_Traded_With__c = createMultiSelect(acc2.Countries_Traded_With__c, translations);
					acc2.Country_of_Birth__pc = translations.get(acc2.Country_of_Birth__pc + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc2.Country_of_Citizenship__c = translations.get(acc2.Country_of_Citizenship__c + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc2.Country_of_Foreign_tax__c = translations.get(acc2.Country_of_Foreign_tax__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					acc2.Financial_Year_End__c = translations.get(acc2.Financial_Year_End__c + '' + 'CIF' + '' + 'Financial Year End' + '' + 'Outbound');
					acc2.Gender__pc = translations.get(acc2.Gender__pc + '' + 'CIF' + '' + 'Gender' + '' + 'Outbound');
					acc2.Home_Language__pc = translations.get(acc2.Home_Language__pc + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc2.Language__c = translations.get(acc2.Language__c + '' + 'CIF' + '' + 'Language' + '' + 'Outbound');
					acc2.Marital_Status__pc = translations.get(acc2.Marital_Status__pc + '' + 'CIF' + '' + 'Marital Status' + '' + 'Outbound');
					acc2.Marital_Contract_Type__pc = translations.get(
						acc2.Marital_Contract_Type__pc +
						'' +
						'CIF' +
						'' +
						'Marital Contract Type' +
						'' +
						'Outbound'
					);
					acc2.Monthly_Income__pc = translations.get(acc2.Monthly_Income__pc + '' + 'CIF' + '' + 'Monthly Income' + '' + 'Outbound');
					acc2.Nationality__pc = translations.get(acc2.Nationality__pc + '' + 'eCasa' + '' + 'Nationality' + '' + 'Outbound');
					acc2.Nature_of_Client__c = translations.get(acc2.Nature_of_Client__c + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc2.Occupation_Category__pc = translations.get(acc2.Occupation_Category__pc + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc2.Occupation_Status__pc = translations.get(acc2.Occupation_Status__pc + '' + 'CIF' + '' + 'Occupation Status' + '' + 'Outbound');
					acc2.Occupation__pc = translations.get(acc2.Occupation__pc + '' + 'CIF' + '' + 'Occupation Category' + '' + 'Outbound');
					acc2.PersonTitle = translations.get(acc2.PersonTitle + '' + 'CIF' + '' + 'Title' + '' + 'Outbound');
					acc2.Source_of_Income__c = translations.get(acc2.Source_of_Income__c + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
					acc2.Source_of_Income__pc = translations.get(acc2.Source_of_Income__pc + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound');
					acc2.Standard_Industry_SIC_Code__c = translations.get(
						acc2.Standard_Industry_SIC_Code__c +
						'' +
						'CIF' +
						'' +
						'Standard Industry SIC Code' +
						'' +
						'Outbound'
					);
					acc2.Industry = translations.get(acc2.Industry + '' + 'CIF' + '' + 'Standard Industry SIC Code' + '' + 'Outbound');
					acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Individual_Prospect').getRecordTypeId();

					//Set default Country of Incorporation to South Africa
					if (acc2.Country_of_Citizenship__c != null && acc2.Country_of_Citizenship__c != '') {
						acc2.Country_of_Incorporation__c = translations.get(acc2.Country_of_Citizenship__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					} else {
						acc2.Country_of_Incorporation__c = translations.get('SO003' + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
					}

					if(!accRelatedPartyUpsert.contains(acc2)) {
                        accRelatedPartyUpsert.add(acc2);
                    }
					//insert acc2;
				}

				if (accRelatedPartyUpsert != null && accRelatedPartyUpsert.size() > 0) {
					insert accRelatedPartyUpsert;

					Set<id> accIds = new Set<Id>();
					for (Account eachAcc : accRelatedPartyUpsert) {
						accIds.add(eachAcc.Id);
						//accRelatedPartyMap.put(eachAcc.ID_Number__pc,eachAcc);
						apiResponse = createAPI('relatedParties', apiResponse, eachAcc.Id);
					}

					for (Account eachAcc : [SELECT Id, PersonContactId, ID_Number__pc FROM Account WHERE Id IN :accIds]) {
						accRelatedPartyMap.put(eachAcc.ID_Number__pc, eachAcc);
					}
				}

				List<Address__c> addressesInsert = new List<Address__c>();
				List<AccountContactRelation> accountContactRelationsInsert = new List<AccountContactRelation>();
				for (integer i = 0; i < request.nonIndividual.relatedParties.size(); i++) {
					Id personContactId2 = accRelatedPartyMap.get(request.nonIndividual.relatedParties[i].acc.ID_Number__pc).PersonContactId;
					//Id personContactId2 = [SELECT  PersonContactId From Account WHERE id = :acc2.Id].PersonContactId;
					for (Address__c addr : request.nonIndividual.relatedParties[i].addresses) {
						Address__c tempAddr = new Address__c();
						tempAddr.Account__c = accRelatedPartyMap.get(request.nonIndividual.relatedParties[i].acc.ID_Number__pc).Id;
						tempAddr.Contact__c = accRelatedPartyMap.get(request.nonIndividual.relatedParties[i].acc.ID_Number__pc).PersonContactId;
						tempAddr.Shipping_Country__c = translations.get(addr.Shipping_Country__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
						addressesInsert.add(tempAddr);
						//insert addr;
					}

					AccountContactRelation accConRel = request.nonIndividual.relatedParties[i].accConRel;
					accConRel.AccountId = acc.Id;
					accConRel.ContactId = personContactId2;
					accConRel.Roles = createRoles(accConRel.Roles, acc.Client_Type__c);
					accConRel.Primary_Entity_Id__c = acc.Id;
					if(accountContactRelationsInsert.contains(accConRel) == false && accConRel.Roles != null && accConRel.Roles != '') {
                        accountContactRelationsInsert.add(accConRel);
                    }
					//insert accConRel;
				}

				if (addressesInsert != null && addressesInsert.size() > 0) {
					insert addressesInsert;
				}

				if (accountContactRelationsInsert != null && accountContactRelationsInsert.size() > 0) {
					insert accountContactRelationsInsert;

					for (AccountContactRelation eachRelationship : accountContactRelationsInsert) {
						if (eachRelationship.Share_Percentage__c > 0) {
							calcRecord = eachRelationship;
						}
					}
					if (calcRecord != null) {
						AccountContactRelationController.calculateControllingPercentageVal2(calcRecord, acc.Id);
					}
				}
			}
		}

		List<Pricebook2> standardPB = [SELECT id FROM Pricebook2 WHERE isStandard = TRUE];

		Opportunity opp = new Opportunity();
		opp.AccountId = acc.Id;
		opp.CloseDate = Date.today() + 30;
		opp.name = 'Product Onboarding';
		opp.pricebook2Id = standardPB[0].Id;
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();
		opp.StageName = 'Apply Product';
		opp.VC_Application_Number__c = acc.Application_Number__c;
		opp.ExecutionLayerRequestID_Text__c = acc.ExecutionLayerRequestID__c;
		opp.CASA_Reference_Number__c = request.individual != null ? acc.CASA_Reference_Number__pc : acc.CASA_Reference_Number__c;
		opp.CASA_Screening_Status_Value__c = acc.CASA_Screening_Status__c;
		system.debug('acc.CASA_Risk_Status__c ' + acc.CASA_Risk_Status__c);
		opp.Risk_Rating__c = 'Medium';
		opp.Risk_Rating_Date__c = date.today();
		opp.CASA_Screening_Date__c = date.today();

		//Set Process Type
		if(acc.CIF__c != null && acc.CIF__c != '') {
			opp.Process_Type__c = 'Remediate Existing Customer';
		} else {
			opp.Process_Type__c = 'New to Bank Onboarding';
		}
		insert opp;
		apiResponse.put('oppId', opp.Id);

		Application__c app;
		if (request.individual != null) {
			app = request.individual.application;
		} else {
			app = request.nonIndividual.application;
		}
		app.Source_of_Funds_Savings__c = respBean != null
			? translations.get(respBean.sourceOfIncome + '' + 'CIF' + '' + 'Source of Income' + '' + 'Outbound')
			: translations.get(app.Source_of_Funds_Savings__c + '' + 'eCasa' + '' + 'Source of Income' + '' + 'Outbound');
		if (app.Source_of_Funds_Savings__c != null) {
			app.Source_of_Funds_Savings__c = app.Source_of_Funds_Savings__c.toUpperCase().replace('-', '');
		} else {
			app.Source_of_Funds_Savings__c = null;
		}
		app.Where_are_the_suppliers_located__c = translations.get(app.Where_are_the_suppliers_located__c + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
		app.Opportunity__c = opp.Id;
		app.Account__c = acc.Id;
		insert app;
		apiResponse.put('appId', app.id);
		apiResponse.put('productInterest', app.Product_Interest__c);

		List<Product2> allActiveProducts = new ProductsSelector().selectActiveProducts(true);
		Map<String, Id> productCodeIdMap = new Map<String, Id>();
		Map<String, String> productCodeFamilyMap = new Map<String, String>();
		Map<String, String> productCodeNameMap = new Map<String, String>();
		Map<String, String> productNameIdMap = new Map<String, String>();
		Map<Id, Product2> IdRecordMap = new Map<Id, Product2>();
		Map<String, String> schemeCodeProductNameMap = new Map<String, String>();
		Map<String, List<Product2>> parentChildrenProductMap = new Map<String, List<Product2>>();

		for (integer i = 0; i < allActiveProducts.size(); i++) {
			productCodeIdMap.put(allActiveProducts[i].ProductCode, allActiveProducts[i].Id);
			productCodeFamilyMap.put(allActiveProducts[i].ProductCode, allActiveProducts[i].Family);
			productCodeNameMap.put(allActiveProducts[i].ProductCode, allActiveProducts[i].Name);
			productNameIdMap.put(allActiveProducts[i].Name, allActiveProducts[i].Id);
			IdRecordMap.put(allActiveProducts[i].Id, allActiveProducts[i]);
		}

		List<Price_Scheme__c> allPriceSchemes = new PriceSchemesSelector().selectByEndDate();
		for (integer i = 0; i < allPriceSchemes.size(); i++) {
			schemeCodeProductNameMap.put(allPriceSchemes[i].Scheme_Code__c + '' + allPriceSchemes[i].Product_Code__c, allPriceSchemes[i].Package_Name__c);
		}

		List<Product_Product_Entry__c> allChildProducts = new ProductProductEntriesSelector().selectAll();

		for (integer i = 0; i < allChildProducts.size(); i++) {
			if (parentChildrenProductMap.get(allChildProducts[i].Parent_Product__c) != null) {
				List<Product2> allchildren = parentChildrenProductMap.get(allChildProducts[i].Parent_Product__c);
				if (IdRecordMap.get(allChildProducts[i].Related_Product__c) != null) {
					allchildren.add(IdRecordMap.get(allChildProducts[i].Related_Product__c));
					parentChildrenProductMap.remove(allChildProducts[i].Parent_Product__c);
					parentChildrenProductMap.put(allChildProducts[i].Parent_Product__c, allchildren);
				}
			} else {
				List<Product2> allchildren = new List<Product2>();
				if (IdRecordMap.get(allChildProducts[i].Related_Product__c) != null) {
					allchildren.add(IdRecordMap.get(allChildProducts[i].Related_Product__c));
					parentChildrenProductMap.put(allChildProducts[i].Parent_Product__c, allchildren);
				}
			}
		}

		List<OpportunityLineItem> oppList = new List<OpportunityLineItem>();
		if (request.individual != null) {
			oppList = request.individual.lineItems;
		} else {
			oppList = request.nonIndividual.lineItems;
		}

		List<OpportunityLineItem> oppLineItemsInsert = new List<OpportunityLineItem>();
		List<Application_Product__c> appProducts = new List<Application_Product__c>();
		List<OpportunityLineItem> oppLineItemsCashFlowInsert = new List<OpportunityLineItem>();
		for (OpportunityLineItem oli : oppList) {
			String evolveType;
			if (productCodeFamilyMap.get(oli.product2Id) == 'Cheque') {
				String packageName = schemeCodeProductNameMap.get(oli.Fee_Structure_Code__c + '' + oli.product2Id);
				String parentId = productNameIdMap.get(packageName);

				if (parentChildrenProductMap.get(parentId) != null) {
					List<Product2> loopChildren = parentChildrenProductMap.get(parentId);
					loopChildren.add(IdRecordMap.get(parentId));

					for (integer i = 0; i < loopChildren.size(); i++) {
						OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
						opportunityLineItem.OpportunityId = opp.Id;
						opportunityLineItem.Product2Id = loopChildren[i].Id;
						opportunityLineItem.TotalPrice = 0;
						opportunityLineItem.Quantity = 1;
						opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(loopChildren[i].Id);
						opportunityLineItem.Policy_Number__c = oli.Policy_Number__c;
						opportunityLineItem.Fee_Structure_Code__c = productCodeFamilyMap.get(oli.product2Id) == 'Cheque' ? oli.Fee_Structure_code__c : '';
						//insert opportunityLineItem;
						if (loopChildren[i].Id != parentId) {
							oppLineItemsCashFlowInsert.add(opportunityLineItem);
							opp.Product_Selected_Business_Evolve__c = true;
							opp.SelectedProduct__c = packageName;
						} else {
							oppLineItemsInsert.add(opportunityLineItem);
						}

						//apiResponse = createAPI('oliId', apiResponse, opportunityLineItem.Id);

						/*if (loopChildren[i].Id != parentId) {
							Application_Product__c ap = new Application_Product__c();
							ap.Opportunity_Product_Id__c = opportunityLineItem.id;
							ap.Application__c = app.Id;
							ap.Cash_Flow_Manager__c = true;
							//insert ap;
							appProducts.add(ap);
							//apiResponse = createAPI('apId', apiResponse, ap.Id);

							opp.Product_Selected_Business_Evolve__c = true;
							opp.SelectedProduct__c = packageName;
							//update opp;
						}*/
					}
				} else {
					OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
					opportunityLineItem.OpportunityId = opp.id;
					opportunityLineItem.TotalPrice = 0;
					opportunityLineItem.Quantity = 1;
					opportunityLineItem.Product2Id = productCodeIdMap.get(oli.Product2Id);
					opportunityLineItem.Policy_Number__c = oli.Policy_Number__c;
					opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(opportunityLineItem.Product2Id);
					opportunityLineItem.Fee_Structure_Code__c = oli.Fee_Structure_code__c;
					oppLineItemsInsert.add(opportunityLineItem);
					//insert oli;
					//apiResponse = createAPI('oliId', apiResponse, oli.Id);

					/*Application_Product__c ap = new Application_Product__c();
					ap.Opportunity_Product_Id__c = oli.id;
					ap.Application__c = app.Id;
					//insert ap;
					appProducts.add(ap);*/
					//apiResponse = createAPI('apId', apiResponse, ap.Id);

					opp.Product_Selected_Business_Evolve__c = true;
					opp.SelectedProduct__c = packageName;
					//update opp;
				}
			} else {
				OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
				opportunityLineItem.OpportunityId = opp.id;
				opportunityLineItem.TotalPrice = 0;
				opportunityLineItem.Quantity = 1;
				opportunityLineItem.Product2Id = productCodeIdMap.get(oli.Product2Id);
				opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(opportunityLineItem.Product2Id);
				opportunityLineItem.Policy_Number__c = oli.Policy_Number__c;
				opportunityLineItem.Fee_Structure_Code__c = oli.Fee_Structure_code__c;
				//insert oli;
				oppLineItemsInsert.add(opportunityLineItem);
				//apiResponse = createAPI('oliId', apiResponse, oli.Id);

				/*Application_Product__c ap = new Application_Product__c();
				ap.Opportunity_Product_Id__c = oli.id;
				ap.Application__c = app.Id;
				//insert ap;
				appProducts.add(ap);*/
				//apiResponse = createAPI('apId', apiResponse, ap.Id);

				opp.SelectedProduct__c = productCodeNameMap.get(oli.Product2.ProductCode);
				//update opp;
			}
		}

		if (oppLineItemsInsert != null && oppLineItemsInsert.size() > 0) {
			insert oppLineItemsInsert;
			for (OpportunityLineItem eachLineItem : oppLineItemsInsert) {
				Application_Product__c ap = new Application_Product__c();
				ap.Opportunity_Product_Id__c = eachLineItem.id;
				ap.Application__c = app.Id;
				appProducts.add(ap);
				//apiResponse = createAPI('oliId', apiResponse, eachLineItem.Id);
			}
		}
		if (oppLineItemsCashFlowInsert != null && oppLineItemsCashFlowInsert.size() > 0) {
			insert oppLineItemsCashFlowInsert;
			for (OpportunityLineItem eachLineItem : oppLineItemsCashFlowInsert) {
				Application_Product__c ap = new Application_Product__c();
				ap.Opportunity_Product_Id__c = eachLineItem.id;
				ap.Application__c = app.Id;
				ap.Cash_Flow_Manager__c = true;
				appProducts.add(ap);
				//apiResponse = createAPI('oliId', apiResponse, eachLineItem.Id);
			}
		}

		if (appProducts != null && appProducts.size() > 0) {
			insert appProducts;
			for (Application_Product__c eachProd : appProducts) {
				apiResponse = createAPI('oliId', apiResponse, eachProd.Opportunity_Product_Id__c);
				apiResponse = createAPI('apId', apiResponse, eachProd.Id);
			}
		}

		update opp;

		try {
			return apiResponse;
		} catch (Exception ex) {
			createLog(500, 'Error', body, ex.getLineNumber() + ', ' + ex.getCause());
			throw ex;
		}
	}

	/**
	 * @description Build the response
	 * @param accountId
	 * @param oppId
	 * @return Business_Evolve_Response
	 */
	global static Business_Evolve_Response buildResponse(Id accountId, Id oppId) {
		Account acc = [SELECT Id, Name, cif__c, ExecutionLayerRequestID__c FROM Account WHERE id = :accountId];
		Business_Evolve_Response response = new Business_Evolve_Response();
		response.ExecutionLayerRequestID = acc.ExecutionLayerRequestID__c;
		response.SourceID = 'SFDC';
		response.Timestamp = '' + Datetime.now();
		response.ResultCode = '0';
		List<Business_Evolve_Response.Products> products = new List<Business_Evolve_Response.Products>();
		List<OpportunityLineItem> lineItems = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
		for (OpportunityLineItem li : lineItems) {
			if (li.policy_Number__c != null) {
				Business_Evolve_Response.Products product = new Business_Evolve_Response.Products();
				product.ProductCode = li.productCode;
				product.AccountNumber = li.policy_Number__c;
				products.add(product);
			}
		}
		response.Products = products;
		List<Business_Evolve_Response.Entities> entities = new List<Business_Evolve_Response.Entities>();
		Business_Evolve_Response.Entities entity = new Business_Evolve_Response.Entities();
		entity.CIFKey = acc.cif__c;
		entity.EntityID = acc.id;
		entities.add(entity);
		response.Entities = entities;
		return response;
	}

	/**
	 * @description Replace mapped Properties
	 * @param body
	 * @param propertyMappings
	 * @return String
	 */
	public static String replaceMappedProperties(String body, Map<String, String> propertyMappings) {
		for (String baseName : propertyMappings.keySet()) {
			if (baseName != null) {
				body = body.replaceAll('"' + baseName + '"\\s*:', '"' + propertyMappings.get(baseName) + '":');
			}
		}
		return body;
	}

	private static String createMultiSelect(String multiSelectValue, Map<String, String> currentMap) {
		List<String> translatedList = new List<String>();
		String traslatedString;
		if (multiSelectValue != null) {
			for (String translateLoop : multiSelectValue.split(';')) {
				String translatedKey = currentMap.get(translateLoop + '' + 'CIF' + '' + 'Country' + '' + 'Outbound');
				if (translatedKey != null) {
					translatedList.add(translatedKey);
				}
			}
		}
		traslatedString = string.join(translatedList, ';');
		return traslatedString;
	}

	private static String createRoles(String roles, String clientType) {
		List<String> translatedList = new List<String>();
		String traslatedString;
		if (roles != null) {
			for (String translateLoop : roles.split(';')) {
				String translatedKey;
				if (translateLoop == 'DIRECTOR') {
					translatedKey = 'Director';
				} else if (translateLoop == 'MEMBER') {
					translatedKey = 'Members/Controllers';
				} else if (translateLoop == 'APPLICANT') {
					translatedKey = 'Contact Person; Individual with Authority to Act';
				} else if (translateLoop == 'SIGNATORY') {
					translatedKey = 'Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
				} else if (translateLoop == 'MANDATE_OFFICIAL') {
					translatedKey = 'Individual with Authority to Act';
				} else if (translateLoop == 'SHAREHOLDER' && clientType != 'Close Corporation') {
					translatedKey = 'Shareholder/Controller';
				} else if (translateLoop == 'SHAREHOLDER' && clientType == 'Close Corporation') {
					translatedKey = 'Members/Controllers';
				} else if (translateLoop == 'MANAGING_DIRECTOR' && clientType != 'Close Corporation') {
					translatedKey = 'Managing Director/Chief Executive Officer';
				} else if (translateLoop == 'MANAGING_DIRECTOR' && clientType == 'Close Corporation') {
					translatedKey = 'Manager';
				}
				if (translatedKey != null) {
					translatedList.add(translatedKey);
				}
			}
		}
		traslatedString = string.join(translatedList, ';');
		return traslatedString;
	}

	private static Map<String, String> createAPI(String mapKey, Map<String, String> currentMap, String newId) {
		String currentIdAps = currentMap.get(mapKey);
		if (currentIdAps != null) {
			currentIdAps = currentIdAps + ';' + newId;
			currentMap.remove(mapKey);
		} else {
			currentIdAps = newId;
		}
		currentMap.put(mapKey, currentIdAps);
		return currentMap;
	}

	private static Sys_Log_Integration__c createLog(Integer statusCode, String status, String request, String response) {
		Sys_Log_Integration__c log = new Sys_Log_Integration__c();
		log.Request_Timestamp__c = System.now();
		log.Request__c = request;
		log.Method_Name__c = '/business-evolve/v1/*';
		log.Source_System__c = 'Jitterbit';
		log.Destination_System__c = StringConstants.SALESFORCE_STRING;
		log.User_Name__c = UserInfo.getName();
		log.Log_Type__c = StringConstants.INBOUND_RECORD_TYPE;
		log.Status_Code__c = statusCode;
		log.Status__c = status;
		log.Response__c = response;
		insert log;
		system.debug('log.Id@@#@#@@ ' + log.Id);

		return log;
	}

	/*private static String translate(String roles, String clientType) {
		List<String> translatedList = new List<String>();
		String traslatedString;
		if (roles != null) {
			for (String translateLoop : roles.split(';')) {
				String translatedKey;
				if (translateLoop == 'DIRECTOR') {
					translatedKey = 'Director';
				} else if (translateLoop == 'MEMBER') {
					translatedKey = 'Members/Controllers';
				} else if (translateLoop == 'APPLICANT') {
					translatedKey = 'Contact Person; Individual with Authority to Act';
				} else if (translateLoop == 'SIGNATORY') {
					translatedKey = 'Operators on primary accounts ( Internet Main Users, Signatories, Card Users)';
				} else if (translateLoop == 'MANDATE_OFFICIAL') {
					translatedKey = 'Individual with Authority to Act';
				} else if (translateLoop == 'SHAREHOLDER' && clientType != 'Close Corporation') {
					translatedKey = 'Shareholder/Controller';
				} else if (translateLoop == 'SHAREHOLDER' && clientType == 'Close Corporation') {
					translatedKey = 'Members/Controllers';
				} else if (translateLoop == 'MANAGING_DIRECTOR' && clientType != 'Close Corporation') {
					translatedKey = 'Managing Director/Chief Executive Officer';
				} else if (translateLoop == 'MANAGING_DIRECTOR' && clientType == 'Close Corporation') {
					translatedKey = 'Manager';
				}
				if (translatedKey != null) {
					translatedList.add(translatedKey);
				}
			}
		}
		traslatedString = string.join(translatedList, ';');
		return traslatedString;
	}*/
}