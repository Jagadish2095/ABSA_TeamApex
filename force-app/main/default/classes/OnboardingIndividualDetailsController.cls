/**
 *  @description Extension Controller for OnboardingIndividualDetailsController Component
 *
 * @author  Tracy de Bruin : Cloudsmiths 
 * @version v1.0
 * @since   2020-02-20
 *
 */
public class OnboardingIndividualDetailsController{
	/**
	 * @description Get logged in User Details for ID&V
	 * @return User
	 */
	@AuraEnabled
	public static User getLoggedInUserDetails(){

		Set<Id> userIds = new Set<Id>();
		userIds.add(UserInfo.getUserId());
		List<User> loggedInUserInfo = new UsersSelector().selectById(userIds);

		return loggedInUserInfo[0];
	}
    /**
	 * @description getIndividualProspectRecordTypeId
	 * @return User
	 */
	@AuraEnabled
	public static String getIndividualProspectRecordTypeId(){

		Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		return accRecordTypeMap.get('Individual_Prospect').getRecordTypeId();
	}

	/**
	 * @description Makes the callout to Hanis service
	 * @param idNumber
	 * @return String
	 * */
	@AuraEnabled
	public static String callHanisService(String idNumber){
		Map<HanisValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = HanisValidate_IH_v1.HanisValidate(idNumber);
		HanisValidate_Resp_IB_v1 responseBean = (new List<HanisValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		List<Sys_Log_Integration__c> hanisLogs = responseMap.values()[0];
		
		if (hanisLogs != null && !hanisLogs.isEmpty()){
			Insert hanisLogs;
		}
		return responseBean.serialize(responseBean);
	}

	/**
	 * @description Makes the callout to CPB service
	 * @param idNumber
	 * @param lastName
	 * @return String
	 * */
	@AuraEnabled
	public static String callCPBService(String idNumber, String lastName){
		Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CPBValidate_IH_v1.CPBValidate(idNumber, lastName);
		CPBValidate_Resp_IB_v1 responseBean = (new List<CPBValidate_Resp_IB_v1>(responseMap.keySet()))[0];
		List<Sys_Log_Integration__c> cpbLogs = responseMap.values()[0];
		
		if (cpbLogs != null && !cpbLogs.isEmpty()){
			Insert cpbLogs;
		}
		return responseBean.serialize(responseBean);
	}

	/**
	 * @description Creates Individual Prospect Account from Hanis and CPB Data
	 * @param hanisData
	 * @param cpbData
	 * @param accRecordId
	 * @param clientType    // PJAIN: 20200318
	 * @param processType
	 * @param placeOfResidence
	 * @param processName
	 * @param agreedPolicy
	 * @param aggreedVerificationPolicy
	 * @return String
	 */
	@AuraEnabled
	public static String CreateIndividualProspect(String hanisData, String cpbData, Id accRecordId, String clientType, String processType, String placeOfResidence, String processName , Boolean agreedPolicy , Boolean aggreedVerificationPolicy){

		HanisValidate_Resp_IB_v1 hanisDataClass = (HanisValidate_Resp_IB_v1)JSON.deserialize(hanisData, HanisValidate_Resp_IB_v1.class);
		CPBValidate_Resp_IB_v1 cpbDataClass = (CPBValidate_Resp_IB_v1)JSON.deserialize(cpbData, CPBValidate_Resp_IB_v1.class);
		CPBValidate_Resp_IB_v1.PostalAddress cpbPostalDataClass = null;
		CPBValidate_Resp_IB_v1.ResidentialAddress cpbResidentialDataClass = null;

		Account accRec;
		if (String.isNotBlank(accRecordId)){
			// PJAIN: 20200331
			// If accRecordId is populated then query for a record rather than creating a new one
			accRec = new AccountsSelector().selectAllById(accRecordId);
		} else{
			accRec = new Account();
		}

		Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		accRec.RecordTypeId = accRecordTypeMap.get('Individual_Prospect').getRecordTypeId();
		accRec.ID_Type__pc = 'SA Identity Document';
        accRec.Place_of_Residence__c = placeOfResidence;
		accRec.Identified_by_Employee_Number__c = getLoggedInUserDetails().EmployeeNumber;
		accRec.Process_Type__c = processType; //TdB - Set Process Type based on Service Group Type
		accRec.Process_Name__c = processName;
        accRec.share_information_to_third_party__c = agreedPolicy;
        accRec.Permission_to_source_data__c =  aggreedVerificationPolicy;
		// PJAIN: 20200318
		if (clientType.contains('Individual')){
			accRec.Client_Group__c = 'Private Individual';
			accRec.Client_Type__c = clientType;
		} else{
			accRec.Client_Group__c = 'SOLE TRADER CLIENT';
			accRec.Client_Type__c = 'Sole Trader';
		}

		//Hanis prepopulation
		if (hanisDataClass != null && hanisDataClass.surname != null && hanisDataClass.surname != ''){

			String maritalStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('Hanis', 'Marital Status', hanisDataClass.maritalStatus, StringConstants.INBOUND_RECORD_TYPE);

			accRec.FirstName = hanisDataClass.name;
			accRec.LastName = hanisDataClass.surname;
			accRec.ID_Number__pc = hanisDataClass.idNumber;
			accRec.Marital_Status__pc = maritalStatusTranslated;
		} else{
			accRec.LastName = 'Surname';
		}

		if (cpbDataClass != null && cpbDataClass.Person != null){

			if (cpbDataClass.Person.AddressInformation != null){
				cpbPostalDataClass = cpbDataClass.Person.AddressInformation.PostalAddress;
				cpbResidentialDataClass = cpbDataClass.Person.AddressInformation.ResidentialAddress;
			}

			if (cpbDataClass.Person.PersonInformation != null){
				String initialsValue = cpbDataClass.Person.PersonInformation.Initials;
				accRec.Initials__pc = initialsValue.left(5);
				accRec.PersonTitle = cpbDataClass.Person.PersonInformation.Title;
				accRec.Gender__pc = cpbDataClass.Person.PersonInformation.Gender;
				String birthDate = cpbDataClass.Person.PersonInformation.DateOfBirth;

				//Format = DD/MM/YYYY
				String dateValue = cpbDataClass.Person.PersonInformation.DateOfBirth;
				List<String> dateSplit = dateValue.split('/');
				string birthDateStr = dateSplit[2]+'/' + dateSplit[1]+'/' + dateSplit[0];
				accRec.PersonBirthdate = Date.parse(birthDateStr);

				accRec.Passport_Number__pc = cpbDataClass.Person.PersonInformation.PassportNumber;
			}

			if (cpbPostalDataClass != null){
				//Residential Address
				accRec.ShippingStreet = cpbPostalDataClass.Line1;
				accRec.ShippingCity = cpbPostalDataClass.Line2;
				accRec.ShippingState = cpbPostalDataClass.Line3;
				accRec.ShippingCountry = cpbPostalDataClass.Line4;
				accRec.ShippingPostalCode = cpbPostalDataClass.PostalCode;
			}

			if (cpbResidentialDataClass != null){
				//Postal Address
				accRec.BillingStreet = cpbResidentialDataClass.Line1;
				accRec.BillingCity = cpbResidentialDataClass.Line2;
				accRec.BillingState = cpbResidentialDataClass.Line3;
				accRec.BillingCountry = cpbResidentialDataClass.Line4;
				accRec.BillingPostalCode = cpbResidentialDataClass.PostalCode;
			}
		}
		accRec.Valid_Update_Bypass__c = true;

		upsert accRec;
		// W-004836 Insert the Generated Hanis Certificate as Attachment and send it to ECM
		if (accRec.Id != null && hanisDataClass != null && hanisDataClass.Cert != null){
			String jsonStr = hanisDataClass.Cert;
			saveCertificateAsAttachment(accRec.Id, jsonStr,'Hanis Certificate','Hanis Certificate.pdf');
		}
        // W-004836 Insert the Generated CPB Certificate as Attachment and send it to ECM
        if (accRec.Id != null && cpbDataClass != null && cpbDataClass.Person.AddressInformation.ResidentialAddress.AddCert != null){
			String jsonStr = cpbDataClass.Person.AddressInformation.ResidentialAddress.AddCert;
			saveCertificateAsAttachment(accRec.Id, jsonStr,'CPB Certificate','CPB Certificate.pdf');
        }

		if (accRec != null && cpbDataClass != null){
			List<Address__c> addListToBeInsert = new List<Address__c>();
			Address__c postal = new Address__c();
			Address__c street = new Address__c();

			//Get existing Addresses linked to Account
			List<Address__c> allAddressRelatedToAcc = new AddressesSelector().addressesRelatedToAcc(accRec.id);

			if (allAddressRelatedToAcc != null && allAddressRelatedToAcc.size() > 0){

				//Check if there's a Postal address linke dto Account
				//If yes, then update existing, else insert new Address
				for (Address__c eachAddress : allAddressRelatedToAcc){
					if (eachAddress.Address_Type__c == 'Postal'){
						postal = eachAddress;
					} else if (eachAddress.Address_Type__c == 'Physical Address'){
						street = eachAddress;
					}
				}
			}

			// Add Postal address
			if (cpbPostalDataClass != null){
				postal.account__c = accRec.Id;
				postal.Client_Entity_Type__c = accRec.Client_Type__c;
				postal.Address_Type__c = 'Postal';
				postal.Data_Status__c = 'Un Structured';
				postal.Address1__c = cpbPostalDataClass.Line1;
				postal.Address2__c = cpbPostalDataClass.Line2;
				postal.Address3__c = cpbPostalDataClass.Line3;
				postal.Address4__c = cpbPostalDataClass.Line4;
				postal.Address5__c = cpbPostalDataClass.PostalCode;
				postal.Shipping_Street__c = cpbPostalDataClass.Line1;
				postal.Shipping_Suburb__c = cpbPostalDataClass.Line3;
				postal.Shipping_City__c = cpbPostalDataClass.Line3;
				postal.Shipping_State_Province__c = cpbPostalDataClass.Line4;
				postal.Shipping_Zip_Postal_Code__c = cpbPostalDataClass.PostalCode;
				addListToBeInsert.add(postal);
			}

			// Add Residential address
			if (cpbResidentialDataClass != null){
				street.account__c = accRec.Id;
				street.Client_Entity_Type__c = accRec.Client_Type__c;
				street.Address_Type__c = 'Physical Address';
				street.Data_Status__c = 'Un Structured';
				street.Address1__c = cpbResidentialDataClass.Line1;
				street.Address2__c = cpbResidentialDataClass.Line2;
				street.Address3__c = cpbResidentialDataClass.Line3;
				street.Address4__c = cpbResidentialDataClass.Line4;
				street.Address5__c = cpbResidentialDataClass.PostalCode;
				street.Shipping_Street__c = cpbResidentialDataClass.Line1;
				street.Shipping_Suburb__c = cpbResidentialDataClass.Line3;
				street.Shipping_City__c = cpbResidentialDataClass.Line3;
				street.Shipping_State_Province__c = cpbResidentialDataClass.Line4;
				street.Shipping_Zip_Postal_Code__c = cpbResidentialDataClass.PostalCode;
				addListToBeInsert.add(street);
			}

			if (addListToBeInsert != null && addListToBeInsert.size() > 0){
				upsert addListToBeInsert;
			}
		}
		return accRec.Id;
	}

    // W-004836 Insert the Generated Hanis/CPB Certificate as Attachment and send it to ECM
	/**
	 * @description W-004836 Insert the Generated Hanis/CPB Certificate as Attachment and send it to ECM
	 * @param accId
	 * @param jsonString
	 * @param docType
	 * @param filename
	 */
	@future(callout = true)
	public static void saveCertificateAsAttachment(string accId, string jsonString, string docType, string filename){
		DocumentController.sendTOECM(accId, docType, filename, jsonString);
    }

	/**
	 * @description Creates
	 * @param accountId
	 * @param processType
	 * @return String
	 */
	@AuraEnabled
	public static String CreateOnboardingOpportunity(Id accountId, String processType){
		if (accountId != null){
			Date todaysDate = System.today();
			Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			User userRec = new UsersSelector().selectById(UserInfo.getUserId());
			List<Site__c> sitecodes;
			if (userRec.SiteCode__c != null){
				sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
			} else{
				sitecodes = new List<Site__c>();
			}

			//Get Standard Pricebook Id
			PriceBook2 priceBookItem = new PriceBook2();
			priceBookItem = [select id
			                 from priceBook2
			                 where name = 'Standard Price Book'];

			//Create Opportunity
			Opportunity onboardOpportunity = new Opportunity();

              if(processType == 'Surety Onboarding') {
                onboardOpportunity.Name = 'Surety Onboarding';
                onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('Surety_Onboarding').getRecordTypeId();
            } else if(processType == 'Remediate Existing Customer'){ //W-0010160
                    onboardOpportunity.Name = 'Remediate Existing Customer';
                    onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('Customer_Remediation').getRecordTypeId();
            } else if(processType == 'SIC Code Change'){
                    onboardOpportunity.Name = 'SIC Code Change';
                    onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('SIC_Code_Change').getRecordTypeId();
                }
			else {
                onboardOpportunity.Name = 'Sales Onboarding';
                onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('Product_Onboarding').getRecordTypeId();
            }

            onboardOpportunity.Process_Type__c = processType;
			onboardOpportunity.AccountId = accountId;
			onboardOpportunity.StageName = 'Confirm Client Eligibility';
			onboardOpportunity.closeDate = todaysDate.addDays(7);
			onboardOpportunity.priceBook2Id = priceBookItem.id;

			//Capturing Sitecode of loggedin User while creating opportunity if user has site code
			if (!sitecodes.isEmpty()){
				onboardOpportunity.Site__c = sitecodes[0].Id;
			}

			// Added by Masechaba Maseli W-005224 get the ABSA region
			If (userRec.SiteCode__c != Null){
				Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
				onboardOpportunity.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
			}

			insert onboardOpportunity;
            updateCertDocs(accountId,onboardOpportunity.id);
            if(processType == 'Remediate Existing Customer' || processType == 'SIC Code Change'){ //W-0010160
                String ProductName = 'REFRESH';
                ProductsSelector prodSelector = new ProductsSelector();
                Product2 Refreshproduct = prodSelector.selectByName(ProductName, 1);
                //createOpportunityProduct(onboardOpportunity.id,ProductName);
                OnboardingProductInformationController.saveOpportunityLineItem(onboardOpportunity.id,Refreshproduct.Id);
            }

			//TdB - Create Document Placeholders
            DocumentManagementSelectionController.createDocumentPlaceholders(accountId,onboardOpportunity.id);

			return onboardOpportunity.id;
		} else{
			return null;
		}
	}

	/**
	 * @description Prashant Jain and Tinashe Shoko: 20200312: New method for Merchant Onboarding
	 * @param accountId
	 * @return String
	 */
	@AuraEnabled
	public static String createMerchantOnboardingOpportunity(Id accountId){
		if (accountId != null){
			Date todaysDate = System.today();
			Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			User userRec = new UsersSelector().selectById(UserInfo.getUserId());
			List<Site__c> sitecodes;
			if (userRec.SiteCode__c != null){
				sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
			} else{
				sitecodes = new List<Site__c>();
			}

			//Get Standard Pricebook Id
			PriceBook2 priceBookItem = new PriceBook2();
			priceBookItem = [select id
			                 from priceBook2
			                 where name = 'Standard Price Book'];

			//Create Opportunity
			Opportunity onboardOpportunity = new Opportunity();
			onboardOpportunity.Name = 'Merchant Onboarding';
			onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
			onboardOpportunity.AccountId = accountId;
			onboardOpportunity.StageName = 'Confirm Client Eligibility';
			onboardOpportunity.closeDate = todaysDate.addDays(7);
			onboardOpportunity.priceBook2Id = priceBookItem.id;

			//Capturing Sitecode of loggedin User while creating opportunity if user has site code
			if (!sitecodes.isEmpty()){
				onboardOpportunity.Site__c = sitecodes[0].Id;
			}


			// Added by Masechaba Maseli W-005224 get the ABSA region
			If (userRec.SiteCode__c != Null){
				Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
				onboardOpportunity.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
			}


			insert onboardOpportunity;
			 updateCertDocs(accountId,onboardOpportunity.id);

			return onboardOpportunity.id;
		} else{
			return null;
		}
	}

     /**
	 * @description Creates
	 * @param accountId
	 * @return String
	 * */
	@AuraEnabled
	public static String CreateCPFOnboardingOpportunity(Id accountId){
		if (accountId != null){
			Date todaysDate = System.today();
			Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			User userRec = new UsersSelector().selectById(UserInfo.getUserId());
			List<Site__c> sitecodes;
			if (userRec.SiteCode__c != null){
				sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
			} else{
				sitecodes = new List<Site__c>();
			}

			//Get Standard Pricebook Id
			PriceBook2 priceBookItem = new PriceBook2();
			priceBookItem = [select id
			                 from priceBook2
			                 where name = 'Standard Price Book'];

			//Create Opportunity
			Opportunity onboardOpportunity = new Opportunity();
			onboardOpportunity.Name = 'CPF Onboarding';
			onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
			onboardOpportunity.AccountId = accountId;
			onboardOpportunity.StageName = 'Confirm Client Eligibility';
			onboardOpportunity.closeDate = todaysDate.addDays(7);
			onboardOpportunity.priceBook2Id = priceBookItem.id;

			//Capturing Sitecode of loggedin User while creating opportunity if user has site code
			if (!sitecodes.isEmpty()){
				onboardOpportunity.Site__c = sitecodes[0].Id;
			}

			// Added by Masechaba Maseli W-005224 get the ABSA region
			If (userRec.SiteCode__c != Null){
				Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
				onboardOpportunity.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
			}

			insert onboardOpportunity;
            updateCertDocs(accountId,onboardOpportunity.id);

			return onboardOpportunity.id;
		} else{
			return null;
		}
	}

	/**
	 * @description Creates Individual Prospect Account with limited data
	 * @param accRecord
	 * @param agreedPolicy
	 * @param processType
	 * @param aggreedVerificationPolicy
	 * @return Id
	 */
	@AuraEnabled
	public static Id createIndividualProspectLimitedData(Account accRecord, Boolean agreedPolicy, String processType ,Boolean aggreedVerificationPolicy){
		try{

			accRecord.Identified_by_Employee_Number__c = getLoggedInUserDetails().EmployeeNumber;
			accRecord.share_information_to_third_party__c = agreedPolicy;//consent for spm Onboarding by Haritha P
            accRecord.Permission_to_source_data__c = aggreedVerificationPolicy;
			accRecord.Process_Type__c = processType; //TdB - Set Process Type based on Service Group Type
            //accRecord.ByPassValidationInApexPer__pc = true;
			accRecord.Valid_Update_Bypass__c = true;
			insert accRecord;
			return accRecord.Id;

		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
	}

	//Yongama Dayeni Lines 442 to 452 W-006517 and W-006516
	/**
	 * @description Yongama Dayeni Lines 442 to 452 W-006517 and W-006516
	 * @param objName
	 * @param fldName
	 * @return Id
	 */
	@AuraEnabled
	public static List<String> getOccupationLevelAndEmployerSectorPicklist(String objName, String fldName){
		List<String> pkList = new List<String>();
		Map<String, Schema.SObjectType> allObj = Schema.getGlobalDescribe();
		Map<String, Schema.SObjectField> allFlds = allObj.get(objName).getDescribe().fields.getMap();
		List<Schema.PicklistEntry> pickList = allFlds.get(fldName).getDescribe().getPickListValues();
		for (Schema.PicklistEntry pk : pickList){
			pkList.add(pk.getValue());
		}
		return pkList;
	}

	// Added by Diksha for SPM 9/22/2020
	/**
	 * @description Added by Diksha for SPM 9/22/2020
	 * @return List<User>
	 */
	@AuraEnabled
	public static List<User> getPortfolioManagerlist(){

		List<User> pmuserList = [select id, Name, Advisor_Code__c, Profile.Name
		                         from User
		                         WHERE Id = :UserInfo.getUserId() OR Profile.Name = 'Stock Broker Portfolio Manager'];
		return pmuserList;
	}
    // Added by Diksha for SPM 9/22/2020
	/**
	 * @description Added by Diksha for SPM 9/22/2020
	 * @return string
	 */
	@AuraEnabled
	public static string getloggedinUserProfileName(){

		Id profileId = userinfo.getProfileId();
		String profileName = [Select Id, Name
		                      from Profile
		                      where Id = :profileId].Name;
		return profileName;
	}

	/**
	 * @description Method to Create SPM Product Opportunity
	 * @param accountId
	 * @param selectedPm
	 * @return string
	 */
	@AuraEnabled
	public static String createNewSPMOpportunity(Id accountId, string selectedPm){
		String userRecId = null;
		try{
			if (accountId != null){
				Date todaysDate = System.today();
				Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
				User userRec = new UsersSelector().selectById(UserInfo.getUserId());
				List<Site__c> sitecodes;
				if (userRec.SiteCode__c != null){
					sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
				} else{
					sitecodes = new List<Site__c>();
				}
				if (selectedPm != null && selectedPm != ''){
					User userdetail = [select id, name
					                   from user
					                   where name = :selectedPm];
					userRecId = userdetail.id;
				} else{
					userRecId = userRec.id;
				}

				//Get Standard Pricebook Id
				PriceBook2 priceBookItem = new PriceBook2();
				priceBookItem = [select id
				                 from priceBook2
				                 where name = 'Standard Price Book'];

				//Create Opportunity
				Opportunity onboardOpportunity = new Opportunity();
				onboardOpportunity.Name = 'SPM Onboarding';
                onboardOpportunity.Process_Type__c  = 'Lite Onboarding';
				onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('SPM_Onboarding').getRecordTypeId();
				onboardOpportunity.AccountId = accountId;
				onboardOpportunity.StageName = 'Confirm Client Eligibility';
				onboardOpportunity.closeDate = todaysDate.addDays(7);
				onboardOpportunity.priceBook2Id = priceBookItem.id;
				onboardOpportunity.OwnerId = userRecId;

				//Capturing Sitecode of loggedin User while creating opportunity if user has site code
				if (!sitecodes.isEmpty()){
					onboardOpportunity.Site__c = sitecodes[0].Id;
				}

				insert onboardOpportunity;
				Product2 selectedProduct = new ProductsSelector().selectByName('SPM Equity Product');
				Application__c application = new Application__c();
				application.Opportunity__c = onboardOpportunity.Id;
				INSERT application;
				OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
				opportunityLineItem.OpportunityId = onboardOpportunity.Id;
				opportunityLineItem.Quantity = 1;
				opportunityLineItem.TotalPrice = 0;
				opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(selectedProduct.Id);
				opportunityLineItem.Product2Id = selectedProduct.Id;
				INSERT opportunityLineItem;
				Application_Product__c applicationProduct = new Application_Product__c();
				applicationProduct.Opportunity_Product_Id__c = opportunityLineItem.Id;
				applicationProduct.Application__c = application.Id;
				applicationProduct.Opportunity__c = onboardOpportunity.Id;
				INSERT applicationProduct;
				Account accounts = new AccountsSelector().selectByOpportunityId(onboardOpportunity.Id);
            List<Payment_Plan__c> paymentPlansList = [select id, Account__c, Account_Number__c, Account_Type__c,Bank_Name__c,Branch_Code__c,Branch_Name__c,Type__c,Name,BIC_Code__c,Account_Name__c from Payment_Plan__c where Account__c=:accounts.Id AND Type__c='SPM Product' ];

            if(paymentPlansList!=null && !paymentPlansList.isEmpty()){
                Payment_Plan__c paymentRec=new Payment_Plan__c();
                paymentRec.Account__c=accounts.Id;
                paymentRec.Account_Number__c = paymentPlansList[0].Account_Number__c;
                paymentRec.Account_Type__c = paymentPlansList[0].Account_Type__c;
                paymentRec.Bank_Name__c = paymentPlansList[0].Bank_Name__c;
                if (paymentPlansList[0].Branch_Code__c!=null) {
                    paymentRec.Branch_Code__c = paymentPlansList[0].Branch_Code__c;
                }
                paymentRec.Branch_Name__c = paymentPlansList[0].Branch_Name__c;
                paymentRec.Name = paymentPlansList[0].Name;
                paymentRec.Type__c = 'SPM Product';
                paymentRec.Status__c = 'New';
                paymentRec.Method__c = 'Debit Order';
				paymentRec.BIC_Code__c = paymentPlansList[0].BIC_Code__c;
                paymentRec.Account_Name__c = paymentPlansList[0].Account_Name__c;
				paymentRec.Application__c = application.Id;
                paymentRec.Application_Product__c = applicationProduct.Id;
                Insert paymentRec;
            }
				return onboardOpportunity.id;
			} else{
				return null;
			}
		} catch (Exception e){
			return 'Failure';
		}
	}

	/**
	 * @description Create Credit Opportunity
	 * @param accountId
	 * @param processType
	 * @return String
	 * */
		@AuraEnabled
	public static String CreateCreditOnboardingOpportunity(Id accountId, String processType){
		try{
			if (accountId != null){
				Date todaysDate = System.today();
				Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
				User userRec = new UsersSelector().selectById(UserInfo.getUserId());
				List<Site__c> sitecodes;
				if (userRec.SiteCode__c != null){
					sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
				} else{
					sitecodes = new List<Site__c>();
				}

				//Get Standard Pricebook Id
				PriceBook2 priceBookItem = new PriceBook2();
				priceBookItem = [select id
				                 from priceBook2
				                 where name = 'Standard Price Book'];

								 String ruleEngineResults = ClientFinderExt.businessRulesEngineHandler(accountId);
								 //Saurabh : 20210414 adding a salesProcess linking to opp
								 // with next enhancement we would use request name as a param from cmp and then we can create a common method to create all type of opp
								 List<Sales_Process_Type__c> salesProcessList = new SalesProcessTypesSelector().selectByRequestName('New Credit Product (Business Banking)');
								 //Create Opportunity
								 Opportunity onboardOpportunity = new Opportunity();
								 onboardOpportunity.Name = 'Credit Onboarding';
								 onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('Credit_Onboarding').getRecordTypeId();
								 onboardOpportunity.AccountId = accountId;
								 onboardOpportunity.StageName = 'Confirm Client Eligibility';
								 onboardOpportunity.closeDate = todaysDate.addDays(7);
								 onboardOpportunity.priceBook2Id = priceBookItem.id;
								 onboardOpportunity.Process_Type__c = processType;
								 onboardOpportunity.Business_Rules_Decision__c = ruleEngineResults;
								 //not adding a null check so that it will stop the opp creation if Sales Process is not available
								 onboardOpportunity.Sales_Process_Type__c = salesProcessList[0].id; //Saurabh added lookup to Sales Process Type
								 //Capturing Sitecode of loggedin User while creating opportunity if user has site code
								 if (!sitecodes.isEmpty()){
									 onboardOpportunity.Site__c = sitecodes[0].Id;
								 }
								 insert onboardOpportunity;
								 //Creating Application Record
								 Application__c application = new Application__c();
								 application.Opportunity__c = onboardOpportunity.Id;
								 INSERT application;
				                 return onboardOpportunity.id;
			}
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
		return null;
	}

	/**
	 * @description Updating Process Type of Lite Opportunity - 6097 - Trigger Full Client On-boarding Prior Fulfilment
	 * @param recordId
	 * @return boolean
	 */
	@AuraEnabled
	public static boolean updateLiteOpportunity(Id recordId){
		Opportunity oppRecord = new OpportunitiesSelector().selectByOpptId(recordId);
		oppRecord.Process_Type__c = 'New to Bank Onboarding';
		update oppRecord;
		return true;
	}

   /**
	 * @description Updating Process Type of Lite Opportunity - 6097 - Trigger Full Client On-boarding Prior Fulfilment
	 * @param accountId
	 * @param oppId
	 *
	 */
	@AuraEnabled
	public static void updateCertDocs(Id accountId,Id oppId){
        Set<String> docTypeSet = new Set<String>{'Hanis Certificate', 'CPB Certificate'};
        List<Document__c> docList = new DocumentsSelector().selectCerts(accountId,docTypeSet);
        for (Document__c doc : docList) {
            doc.Opportunity__c = oppId;
        }
        update docList;
    }

	 /**
	 * @description Updating Process Type of Lite Opportunity - 6097 - Trigger Full Client On-boarding Prior Fulfilment
	 * @param clientAccountId
	 *
	 * @return ciupdateclientdetailV12_Resp_IB_v1
	 */
     @AuraEnabled
    public static ciupdateclientdetailV12_Resp_IB_v1 clientdetails(String clientAccountId){

   return  OnboardingClientDetailsController.clientdetails(clientAccountId);

    }

    /**
	 *  @description Creates opportunity for CAF
     * @author: Masechaba Maseli
	 * @param accountId
	 * @param processType
	 * @return String
	 * */
	@AuraEnabled
	public static String CreateCAFOnboardingOpportunity(Id accountId, String processType){
		try{
			if (accountId != null){
				Date todaysDate = System.today();
				Map<String, Schema.RecordTypeInfo> accountRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
                Account account = new AccountsSelector().selectAllById(accountId);
				User userRec = new UsersSelector().selectById(UserInfo.getUserId());
				List<Site__c> sitecodes;
				if (userRec.SiteCode__c != null){
					sitecodes = new SitesSelector().selectBySiteCode(userRec.SiteCode__c);
				} else{
					sitecodes = new List<Site__c>();
				}

				//Get Standard Pricebook Id
				PriceBook2 priceBookItem = new PriceBook2();
				priceBookItem = [select id
				                 from priceBook2
				                 where name = 'Standard Price Book'];

				//Create Opportunity
				Opportunity onboardOpportunity = new Opportunity();
				onboardOpportunity.Name = account.Name + '-'+ 'CAF';
				onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('CAF_Application').getRecordTypeId();
				onboardOpportunity.AccountId = accountId;
				onboardOpportunity.StageName = 'Confirm Client Eligibility';
				onboardOpportunity.closeDate = todaysDate.addDays(7);
				onboardOpportunity.priceBook2Id = priceBookItem.id;
                onboardOpportunity.Process_Type__c = processType;

				// Added by Masechaba Maseli W-005224 get the ABSA region
				If (userRec.SiteCode__c != Null){
					Map<String, ABSASiteRegionMap__c> regionMapping = ABSASiteRegionMap__c.getAll();
					onboardOpportunity.ABSA_Region__c = regionMapping.get(userRec.SiteCode__c) != null ? regionMapping.get(userRec.SiteCode__c).ABSA_Region__c : Null;
				}


				//Capturing Sitecode of loggedin User while creating opportunity if user has site code
				if (!sitecodes.isEmpty()){
					onboardOpportunity.Site__c = sitecodes[0].Id;
				}
				insert onboardOpportunity;
                updateCertDocs(accountId,onboardOpportunity.id);

				return onboardOpportunity.id;
			}
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
		return null;
	}

	/**
 	 * @description Tdb - Update Document Placeholders
	 * @param accountId
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String updateDocumentPlaceholders(Id accountId, Id oppId){
        try{
			DocumentManagementSelectionController.createDocumentPlaceholders(accountId,oppId);
		return 'SUCCESS';
        } catch (exception ex) {
			  return 'An unknown error occurred. Line : ' + ex.getLineNumber() + ' Error: ' + ex.getMessage();
        }
	}

}