/**
 * @description Extension Controller for OnboardingClientDetailsController Component
 *
 * @author  Manoj Danthala : Absa
 * @version v1.0
 * @since   2019-11-26
 *
 */
public class OnboardingClientDetailsController{
	public static final String CLIENT_TYPE_GROUP = 'Client Type Group';
	/*
	 * Get logged in User Details for ID&V
	 * User Record
	 */
	/**
    * @description Method to get all the opportunity products
    *
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
	 * @description Makes the callout to Experian service
	 * @param registrationNumber
	 * @return String
	 */

	@AuraEnabled
	public static String callExperianHandler(String registrationNumber){
		try{
			registrationNumber = registrationNumber.replace('/', '');
			ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
			return responseBean.serialize(responseBean);
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
	}

	/**
	 * @description Creates Business Prospect Account from Experian Data
	 * @param experianData2
	 * @param accRecordId
	 * @param processType
	 * @param processName
	 * @param placeOfResidence
	 * @param agreedPolicy
	 * @param aggreedVerificationPolicy
	 * @return Account
	 */
	@AuraEnabled
	public static Account CreateBusinessProspect(String experianData2, Id accRecordId, String processType, String processName, String placeOfResidence, Boolean agreedPolicy , Boolean aggreedVerificationPolicy){
		try{
			ExperianBusinessDetailsGet_Resp_IB_v1 experianData = (ExperianBusinessDetailsGet_Resp_IB_v1)JSON.deserialize(experianData2, ExperianBusinessDetailsGet_Resp_IB_v1.class);
			ExperianBusinessDetailsGet_Resp_IB_v1.CompanyDetails comDet = experianData.companyDownload.results.kreditSearchFile.companyDetails;

			Account accRec;
			if (String.isNotBlank(accRecordId)){
				// PJAIN: 20200331
				// If accRecordId is populated then query for a record rather than creating a new one
				accRec = new AccountsSelector().selectAllById(accRecordId);
			} else{
				accRec = new Account();
			}

			Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
			accRec.RecordTypeId = accRecordTypeMap.get('Prospect').getRecordTypeId();
			accRec.Name = comDet.CompanyName;
			//accRec.Client_Type__c = comDet.Entity;// W-003571
			accRec.Registration_Number__c = comDet.RegistrationNumber;
			//Newly added By Rajesh for Financial Year End
			accRec.Financial_Year_End__c = comDet.financialYear == '1' ? 'January' : comDet.financialYear == '2' ? 'February' : comDet.financialYear == '3' ? 'March' : comDet.financialYear == '4' ? 'April' : comDet.financialYear == '5' ? 'May' : comDet.financialYear == '6' ? 'June' : comDet.financialYear == '7' ? 'July' : comDet.financialYear == '8' ? 'August' : comDet.financialYear == '9' ? 'September' : comDet.financialYear == '10' ? 'October' : comDet.financialYear == '11' ? 'November' : comDet.financialYear == '12' ? 'December' : '';
			// Start W-003571 : 2020-03-17 : Anka Ganta
			String regnumberWithClientType = comDet.RegistrationNumber.right(2);
			String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE, regnumberWithClientType, StringConstants.INBOUND_RECORD_TYPE);
			accRec.Client_Type__c = clientTypeTranslated;
			// End W-003571 : 2020-03-17 : Anka Ganta

			accRec.Sic = comDet.SICCode;
			accRec.Identified_by_Employee_Number__c = getLoggedInUserDetails().EmployeeNumber;
			if (comDet.taxNumber != null && comDet.taxNumber != ''){
				accRec.Income_Tax_Number__c = comDet.taxNumber;
			}
			if (comDet.vatNumbers != null){
				accRec.VAT_Registration_Number__c = Decimal.ValueOf(comDet.vatNumbers.vatNo[0]);
			}

			accRec.Source__c = 'SF';
			accRec.ID_Type__c = 'Registration Number';
			accRec.Client_Group__c = 'Non Individual';
            accRec.process_type__c  = processType;
			accRec.Process_Name__c = processName;//added by Manish-W-010629
            accRec.Place_of_Residence__c = placeOfResidence;
            accRec.share_information_to_third_party__c = agreedPolicy;
            accRec.Permission_to_source_data__c =  aggreedVerificationPolicy;

			//accRec.Date_Established__c = Date.valueOf(comDet.RegistrationDate);
			String regDate = comDet.RegistrationDate;
			String yrStr = regDate.substring(0, 4);
			String mnthStr = regDate.substring(4, 6);
			String dStr = regDate.substring(6, 8);
			string establsheddateStr = yrStr + '/' + mnthStr + '/' + dStr;
			accRec.Date_Established__c = Date.parse(establsheddateStr);
			accRec.Valid_Update_Bypass__c = true;
			
			upsert accRec;
			if (accRec != null){

				if (experianData.CompanyDownload.Results.KreditSearchFile.Directors != null){
					List<ExperianBusinessDetailsGet_Resp_IB_v1.DirectorDetails> directorDetailsList = experianData.CompanyDownload.Results.KreditSearchFile.Directors.DirectorDetails;

					//Creates Related Parties
					RelatedPartiesService rps = new RelatedPartiesService();
					if (accRec.Client_Type__c == 'Close Corporation'){
						rps.createRelatedParties(accRec.id, directorDetailsList, 'Member');
					} else{
						rps.createRelatedParties(accRec.id, directorDetailsList, 'Director');
					}

				}

				// Insert Address and associate with Account
				ExperianBusinessDetailsGet_Resp_IB_v1.ContactDetails conDet = experianData.CompanyDownload.Results.KreditSearchFile.contactDetails;
				ExperianBusinessDetailsGet_Resp_IB_v1.PhysicalAddress phyAdd = experianData.CompanyDownload.Results.KreditSearchFile.ContactDetails.physicalAddress;
				ExperianBusinessDetailsGet_Resp_IB_v1.StreetAddress strAdd = experianData.CompanyDownload.Results.KreditSearchFile.contactDetails.streetAddress;
				ExperianBusinessDetailsGet_Resp_IB_v1.PostalAddress postAdd = experianData.CompanyDownload.Results.KreditSearchFile.ContactDetails.postalAddress;

				List<Address__c> addListToBeInsert = new List<Address__c>();
				Address__c postalAddress = new Address__c();
				Address__c registeredAddress = new Address__c();
				Address__c businessAddress = new Address__c();

				//Get existing Addresses linked to Account
				List<Address__c> allAddressRelatedToAcc = new AddressesSelector().addressesRelatedToAcc(accRec.id);

				if (allAddressRelatedToAcc != null && allAddressRelatedToAcc.size() > 0){

					//Check if there's a Postal address linke dto Account
					//If yes, then update existing, else insert new Address
					for (Address__c eachAddress : allAddressRelatedToAcc){
						if (eachAddress.Address_Type__c == 'Postal'){
							postalAddress = eachAddress;
						} else if (eachAddress.Address_Type__c == 'Business Address'){
							businessAddress = eachAddress;
						} else if (eachAddress.Address_Type__c == 'Registered'){
							registeredAddress = eachAddress;
						}
					}
				}

				// Mapp Physical addressfrom Experian to Business Physical Address and Head Office
				if (phyAdd != null){
					businessAddress.account__c = accRec.Id;
					businessAddress.Client_Entity_Type__c = accRec.Client_Type__c;
					businessAddress.Address_Type__c = 'Business Address';
					businessAddress.Data_Status__c = 'Un Structured';
					businessAddress.Address1__c = phyAdd.Address1;
					businessAddress.Address2__c = phyAdd.Address2;
					businessAddress.Address3__c = phyAdd.Address3;
					businessAddress.Address4__c = phyAdd.Address4;
					businessAddress.Address5__c = phyAdd.Address5;
					businessAddress.Shipping_Street__c = phyAdd.Address1;
					businessAddress.Shipping_Suburb__c = phyAdd.Address2;
					businessAddress.Shipping_City__c = phyAdd.Address3;
					businessAddress.Shipping_State_Province__c = phyAdd.Address4;
					businessAddress.Shipping_Zip_Postal_Code__c = phyAdd.Address5;
					addListToBeInsert.add(businessAddress);

				}

				// Map Postal address from Experian to Postal
				if (postAdd != null){
					postalAddress.account__c = accRec.Id;
					postalAddress.Client_Entity_Type__c = accRec.Client_Type__c;
					postalAddress.Address_Type__c = 'Postal';
					postalAddress.Data_Status__c = 'Un Structured';
					postalAddress.Address1__c = postAdd.Address1;
					postalAddress.Address2__c = postAdd.Address2;
					postalAddress.Address3__c = postAdd.Address3;
					postalAddress.Address4__c = postAdd.Address4;
					postalAddress.Address5__c = postAdd.Address5;
					//W-006881-Anka Ganta-2020-10-20
					if (postAdd.Address1.containsIgnoreCase('P.O. BOX')){
						postalAddress.Shipping_Street__c = postAdd.Address1.replace('P.O. BOX', 'PO BOX');
					} else if (postAdd.Address1.containsIgnoreCase('P O BOX')){
						postalAddress.Shipping_Street__c = postAdd.Address1.replace('P O BOX', 'PO BOX');
					} else{
						postalAddress.Shipping_Street__c = postAdd.Address1;
					}
					postalAddress.Shipping_Suburb__c = postAdd.Address2;
					postalAddress.Shipping_City__c = postAdd.Address3;
					postalAddress.Shipping_State_Province__c = postAdd.Address4;
					postalAddress.Shipping_Zip_Postal_Code__c = postAdd.Address5;
					addListToBeInsert.add(postalAddress);
				}

				// Map Street address from Experian to Registered
				if (strAdd != null){
					registeredAddress.account__c = accRec.Id;
					registeredAddress.Client_Entity_Type__c = accRec.Client_Type__c;
					registeredAddress.Address_Type__c = 'Registered';
					registeredAddress.Data_Status__c = 'Un Structured';
					registeredAddress.Address1__c = strAdd.Address1;
					registeredAddress.Address2__c = strAdd.Address2;
					registeredAddress.Address3__c = strAdd.Address3;
					registeredAddress.Address4__c = strAdd.Address4;
					registeredAddress.Address5__c = strAdd.Address5;
					registeredAddress.Shipping_Street__c = strAdd.Address1;
					registeredAddress.Shipping_Suburb__c = strAdd.Address2;
					registeredAddress.Shipping_City__c = strAdd.Address3;
					registeredAddress.Shipping_State_Province__c = strAdd.Address4;
					registeredAddress.Shipping_Zip_Postal_Code__c = strAdd.Address5;
					addListToBeInsert.add(registeredAddress);
				}

				if (!addListToBeInsert.isEmpty()){
					upsert addListToBeInsert;
                }
				//Insert Experian Certificate into ECM and relate Document with Account for W-004836
				if (!String.isBlank(experianData.pdf)){
					saveFile(accRec.Id, experianData.pdf);
				}
			}

			return accRec;
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
	}

    /**
	 * W-004836 
	 * @description accId Account Id
	 * @param accId
	 * @param link
	 * */
	@SuppressWarnings('PMD.ApexOpenRedirect')
	@future(callout = true)
	public static void saveFile(String accId, String link){
		Blob body = !test.isRunningTest() ? new PageReference(link).getContentAsPDF() : Blob.valueOf('test');
		DocumentController.sendToECM(accId, 'Experian Certificate', 'Experian Certificate.pdf', EncodingUtil.base64Encode(body));
    }

	/**
	 * @description Creates
	 * @param accountId
	 * @param processType
	 * @return String
	 */
	@AuraEnabled
	public static String CreateOnboardingOpportunity(Id accountId, String processType){
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

				//Create Opportunity
				Opportunity onboardOpportunity = new Opportunity();

				if(processType == 'Surety Onboarding') {
                    onboardOpportunity.Name = 'Surety Onboarding';
                    onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('Surety_Onboarding').getRecordTypeId();
                } else if(processType == 'Remediate Existing Customer'){
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
                 if(processType == 'Remediate Existing Customer' ||  processType == 'SIC Code Change'){ //W-0010152
                    String ProductName = 'REFRESH';
                    ProductsSelector prodSelector = new ProductsSelector();
                    Product2 Refreshproduct = prodSelector.selectByName(ProductName, 1);
                    //createOpportunityProduct(onboardOpportunity.id,ProductName);
                    OnboardingProductInformationController.saveOpportunityLineItem(onboardOpportunity.id,Refreshproduct.Id);
                }

				//TdB - Create Document Placeholders
                DocumentManagementSelectionController.createDocumentPlaceholders(accountId,onboardOpportunity.id);

				return onboardOpportunity.id;
			}
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
		return null;
	}

	/**
	 * @description Prashant Jain and Tinashe Shoko: 20200312: New method for Merchant Onboarding
	 * @param accountId
	 * @return String
	 * */
	@AuraEnabled
	public static String createMerchantOnboardingOpportunity(Id accountId){
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

				//Get Standard Pricebook Id
				PriceBook2 priceBookItem = [SELECT Id
				                            FROM PriceBook2
				                            WHERE Name = 'Standard Price Book'
				                            LIMIT 1];

				//Create Opportunity
				Opportunity onboardOpportunity = new Opportunity();
				onboardOpportunity.Name = 'Merchant Onboarding';
				onboardOpportunity.RecordTypeId = opportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId();
				onboardOpportunity.AccountId = accountId;
				onboardOpportunity.StageName = 'Confirm Client Eligibility';
				onboardOpportunity.closeDate = todaysDate.addDays(7);
				onboardOpportunity.priceBook2Id = priceBookItem.Id;

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
	 * @description Method that gets all picklist data
	 *
	 * @param objObject - Id of the specific opportunity party being removed
	 * @param fld - field name i.e. Clause_Name__c
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getselectOptions(sObject objObject, string fld){
		List<String> allOpts = new list<String>();
		Schema.sObjectType objType = objObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();

		for (Schema.PicklistEntry a : values){
			allOpts.add(a.getValue());
		}
		//allOpts.sort();
		return allOpts;
	}

	/**
	 * @description validate related parties for an account
	 * @param accountId
	 * @param processType
	 * @param clientTypeP
	 * @return string
	 */
	@AuraEnabled
	public static string validateRelatedParties(Id accountId, String processType, String clientTypeP){
		//List<AccountContactRelation> accnList = [SELECT Id, AccountId, ContactId, Roles,Tax_Number__c,Tax_Residency__c,UBO__c FROM AccountContactRelation WHERE AccountId =: accountId];
		string errorText = '';
		boolean director = false;
		boolean shareholder = false;
		boolean ceo = false;
		boolean authoritytoact = false;
		boolean contactPreson = false;

		Set<Id> relPartyPrimaryEntityIdSet = new Set<Id>();
		Map<Id, Controlling_Interest__c> mapToControllingInterest = new Map<Id, Controlling_Interest__c>();
		List<Controlling_Interest__c> contrIntrList = [select id, Contact__c, Parent_Account__c, Primary_Entity__c, UBO__c, Other_Primary_Entity_Id__c
		                                               from Controlling_Interest__c
		                                               where Primary_Entity__c = :accountId AND UBO__c = 'Yes'];
		for (Controlling_Interest__c accCon : contrIntrList){
			mapToControllingInterest.put(accCon.Contact__c, accCon);
			relPartyPrimaryEntityIdSet.add(accCon.Other_Primary_Entity_Id__c); //Added by Rajesh for defect W-007527
		}
		List<AccountContactRelation> accnList = [SELECT Id, AccountId, ContactId, Roles, Tax_Number__c, Tax_Residency__c, UBO__c, Primary_Entity_Id__c
		                                         FROM AccountContactRelation
		                                         WHERE AccountId = :accountId OR Primary_Entity_Id__c IN :relPartyPrimaryEntityIdSet];
		//Added by Manoj - W-006995 Manoj Tax Number & Tax Residency -->
		Account accountRecord = new AccountsSelector().selectAllById(accountId);

		for (AccountContactRelation accn : accnList){
			if (accn.Roles != '' && accn.Roles != null){
				if (accn.Roles.contains('Director')){
					director = true;
				}
				if (accn.Roles.contains('Shareholder/Controller')){
					shareholder = true;
				}
				if (accn.Roles.contains('Managing Director/Chief Executive Officer') || accn.Roles.contains('Manager')){
					ceo = true;
				}
				if (accn.Roles.contains('Individual with Authority to Act')){
					authoritytoact = true;
				}
				if (accn.Roles.contains('Contact Person')){
					contactPreson = true;
				}

				if (mapToControllingInterest.containsKey(accn.ContactId) && ((accn.Tax_Number__c == null || accn.Tax_Number__c == '') || (accn.Tax_Residency__c == null || accn.Tax_Residency__c == '')) && ((accountRecord.Identify_the_account_holder_type__c == 'Passive Non Financial Entity (PNFE)-With Foreign Shareholding') || (accountRecord.Identify_the_account_holder_type__c == 'Passive Non Financial Entity (PNFE)-Without Foreign Shareholding'))){
					errorText = 'Please Enter Tax Number & Tax Residency in Individual Related Party \n';
				}

			}
		}

        if(processType != 'Surety Onboarding') {
            if (clientTypeP == 'Trusts' || clientTypeP == 'Close Corporation' || clientTypeP == 'Funds' ||
                clientTypeP == 'Co-operative' || clientTypeP == 'Foreign Company' ||
                clientTypeP == 'Foreign Listed Company' || clientTypeP == 'Public Listed Company' ||
                clientTypeP == 'Foreign Trust' || clientTypeP == 'Clubs/Societies/Associations/Other Informal Bodies' ||
                clientTypeP == 'Incorporated Company' || clientTypeP == 'Non Profit Companies' ||
                clientTypeP == 'Non Profit Organizations (NGO)' || clientTypeP == 'Central Bank or Regulator' || clientTypeP == 'Organs of State and Institutions of Higher Learning' ||
                clientTypeP == 'PARTNERSHIP'){
                    errorText = errorText;
                } else{
                    if (!director || !shareholder || !ceo || !authoritytoact || !contactPreson){
                        errorText = errorText + 'Related party/parties with the folowing role(s) are missing: \n';
                    }

                    if (!director){
                        errorText = errorText + ' - Director\n';
                    }
                    if (!shareholder){
                        errorText = errorText + ' - Shareholder/Controller\n';
                    }
                    if (!ceo){
                        errorText = errorText + ' - Manager\n';
                    }
                    if (!authoritytoact){
                        errorText = errorText + ' - Individual with Authority to Act\n';
                    }
                    if (!contactPreson){
                        errorText = errorText + ' - Contact Person\n';
                    }
                }

        } else {
            if (!contactPreson){
                errorText = errorText + ' - Contact Person\n';
            }
        }
		return errorText;
	}

	/**
	 * @description PJAIN: 20200327
	 * Method to get Account Record Type Id for the specified Record Type
	 * @param recordTypeName
	 * @return Id
	 */
	@AuraEnabled
	public static Id getAccountRecordTypeId(String recordTypeName){

		Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		return accRecordTypeMap.get(recordTypeName).getRecordTypeId();
	}

	/**
	 * @description Creates Business Prospect Account with limited data
	 * @param accRecord
	 * @param agreedPolicy
	 * @param processType
	 * @param aggreedVerificationPolicy
	 * @return Id
	 */

	@AuraEnabled
	public static Id createBusinessProspectLimitedData(Account accRecord, Boolean agreedPolicy, String processType , Boolean aggreedVerificationPolicy){
		try{
			accRecord.share_information_to_third_party__c = agreedPolicy;//consent for spm Onboarding by Haritha P
            accRecord.Permission_to_source_data__c = aggreedVerificationPolicy;
            accRecord.Process_Type__c = processType;
			insert accRecord;
			return accRecord.Id;
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
	}

	/**
	 * @description Gets Entities and Golden Sourec Mappings from EntitiesGoldenSource__mdt
	 *
	 * @return List<EntitiesGoldenSource__mdt>
	 */
	@AuraEnabled
	public static List<EntitiesGoldenSource__mdt> getEntitiesMapping(){
		try{

			List<EntitiesGoldenSource__mdt> entitiesList = [SELECT Id, developername, Label, Call_Golden_Source__c, GoldenSource__c, Entity_Name__c
			                                                FROM EntitiesGoldenSource__mdt];
			return entitiesList;
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
	}

	// Added by Diksha for SPM 9/22/2020
	/**
	 * @description Gets Entities and Golden Sourec Mappings from EntitiesGoldenSource__mdt
	 *
	 * @return List<User>
	 */
	@AuraEnabled
	public static List<User> getPortfolioManagerlist(){

		List<User> pmuserList = [select id, Name, Advisor_Code__c, Profile.Name
		                         from User
		                         WHERE Id = :UserInfo.getUserId() OR Profile.Name = 'Stock Broker Portfolio Manager'];
		return pmuserList;
	}

	/**
	 * @description Gets Entities and Golden Sourec Mappings from EntitiesGoldenSource__mdt
	 *
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
	 * @description Gets Entities and Golden Sourec Mappings from EntitiesGoldenSource__mdt
	 * @param accountId
	 * @param processType
	 * @return string
	 */

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
	 * @description Creates
	 * @param accountId
	 * @return String
	 * */
	@AuraEnabled
	public static String CreateCPFOnboardingOpportunity(Id accountId){
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

				//Create Opportunity
				Opportunity onboardOpportunity = new Opportunity();
				onboardOpportunity.Name = 'CPF Onboarding';
				onboardOpportunity.RecordTypeId = accountRecordTypeMap.get('CPF_Onboarding').getRecordTypeId();
				onboardOpportunity.AccountId = accountId;
				onboardOpportunity.StageName = 'Confirm Client Eligibility';
				onboardOpportunity.closeDate = todaysDate.addDays(7);
				onboardOpportunity.priceBook2Id = priceBookItem.id;

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
				updateCertDocs(accountId, onboardOpportunity.id);
				return onboardOpportunity.id;
			}
		} catch (Exception exc){
			throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
		}
		return null;
	}



	/**
	 * @description Haritha Police and Diksha Wasekar:  New method for SPM Onboarding
	 * @param accountId
	 * @param selectedPm
	 * @return String
	 */

	@AuraEnabled
	public static String createSPMOnboardingOpportunity(Id accountId, string selectedPm){
		String userRecId = null;

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
	}

	/**
	 * @description Getting Account Id from Opportunity Id - 6097 - Trigger Full Client On-boarding Prior Fulfilment
	 * @param recordId
	 * @return Account
	 * */
	@AuraEnabled
	public static Account getAccountId(Id recordId){
		//Opportunity oppRecord = new OpportunitiesSelector().selectByOpptId(recordId);
		Account accounts = new AccountsSelector().selectByOpportunityId(recordId);
		return accounts;
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
     * @description Method to link the newly created Opportunity to any certificates
	 * @param accountId
	 * @param oppId
     */
    @AuraEnabled
    public static void updateCertDocs(Id accountId,Id oppId){
        Set<String> docTypeSet = new Set<String>{'Experian Certificate','HANIS Certificate', 'CPB Certificate'};
        List<FinServ__AccountAccountRelation__c> accAccList = new AccountAccountRelationSelector().selectByPrimaryForRelationshipSection(accountId);      
        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectRelationByAccountId(accountId);
        
        Set<Id> accContactId = new Set<Id>();
        for(FinServ__AccountAccountRelation__c eachAcc : accAccList) {
            accContactId.add(eachAcc.FinServ__RelatedAccount__c);
        }
        
        for(AccountContactRelation eachAccRelatedList : accnRelList) {
            accContactId.add(eachAccRelatedList.Contact.AccountId);
        }
        accContactId.add(accountId);
        
        List<Document__c> docList = new DocumentsSelector().selectCertRelatedParty(accContactId,docTypeSet);
        
        for (DOcument__c doc : docList) {
            doc.Opportunity__c = oppId;
        }
    
        update docList;
    }
	/* W-005849-ibiz
	 * @Author: Sandile Mathe
	 * @param: recordId Id
	 * @return: List
	 * */
	/**
	//getting ContactInformation from  AccountContactRelation
	 @AuraEnabled
	 public static list<AccountContactRelation> getContactinfomation(Id recordId)
	 {

	 List <AccountContactRelation> conlist = new  List <AccountContactRelation>();
           LIST<Account> newAcc = [SELECT Id,Name,IsPersonAccount FROM Account where Id =:recordid];
	// return  [ SELECT Id,Contact.Name,Contact.LastName,Contact.ID_Number__c,Account.AuthMessage__c,Contact.AccountId FROM AccountContactRelation where AccountId =: recordId];
          return  [ SELECT Id,Contact.Name,Contact.LastName,Contact.ID_Number__c,Account.AuthMessage__c,Contact.AccountId FROM AccountContactRelation where  Contact.AccountId =: newAcc[0].Id LIMIT 1];
	 }
	 **/
   /**
     * @description Method to link the newly created Opportunity to any certificates
	 * @param oppId
	 * @return List < Map < String,Object >>
     */
  @AuraEnabled
  public static List < Map < String,Object >> getRelatedParties(Id oppId) {
  AccountsSelector aSelector = new AccountsSelector();
    List < Map < String,Object >> listParties = new List < Map < String,Object >> ();
    Account acccount = aSelector.selectByOpportunityId(oppId);
    List < AccountContactRelation > accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);
    Map<String,String> partiesInList = new Map<String, String>();
      If(acccount.Client_Group__c == 'SOLE TRADER CLIENT' || acccount.Client_Group__c == 'Individual' ){
      Map < String,Object > mapObj = new Map < String,Object > ();
      mapObj.put('Id', acccount.Id);
      mapObj.put('AccountId', acccount.Id);
      mapObj.put('ContactId', acccount.PersonContactId);
      mapObj.put('FirstName', acccount.FirstName);
      mapObj.put('LastName', acccount.LastName);
      mapObj.put('IDNumber', acccount.ID_Number__pc);
      mapObj.put('CIF', acccount.CIF__c);
      mapObj.put('Nationality', acccount.Nationality__pc);
      mapObj.put('Birthdate', String.valueOf(acccount.PersonBirthdate));
      mapObj.put('Phone', acccount.Phone);
      mapObj.put('AuthMessage', acccount.AuthMessage__c);
      partiesInList.put( String.valueOf(acccount.PersonContactId),  String.valueOf(acccount.PersonContactId));
      listParties.add(mapObj);
    }
      if (accnRelList != null && accnRelList.size() > 0) {
      for (AccountContactRelation accnRel: accnRelList) {
        If(!partiesInList.containsKey(accnRel.ContactId)) {
          Map < String,Object > mapObj = new Map < String,Object > ();
          mapObj.put('Id', accnRel.Contact.AccountId);
          mapObj.put('AccountId', accnRel.AccountId);
          mapObj.put('ContactId', accnRel.ContactId);
          mapObj.put('FirstName', accnRel.Contact.FirstName);
          mapObj.put('LastName', accnRel.Contact.LastName);
          mapObj.put('IDNumber', accnRel.Contact.ID_Number__c);
          mapObj.put('CIF', accnRel.Account.CIF__c);
          mapObj.put('Nationality', accnRel.Contact.Nationality__c);
          mapObj.put('Birthdate', String.valueOf(accnRel.Contact.Birthdate));
          mapObj.put('SharePercentage', string.valueOf(accnRel.Share_Percentage__c));
          mapObj.put('CIF', accnRel.Account.CIF__c);
          mapObj.put('Roles', accnRel.Roles);
          mapObj.put('Phone', accnRel.Account.Phone);
          mapObj.put('AuthMessage', accnRel.Contact.Account.AuthMessage__c);
          partiesInList.put(accnRel.ContactId, accnRel.ContactId);
          listParties.add(mapObj);
        }
      }
    }

      return listParties;

  }
  /**
     * @description Method to link the newly created Opportunity to any certificates
	 * @param recordId
	 * @return String
     */
  @AuraEnabled
    public static String getEntityType(Id recordId){

        Account AccDetails = new AccountsSelector().selectAllById(recordId);

        return AccDetails.Client_Type__c;

    }

    /**
	 * @description W-005849-ibiz
	 * @Author: Sandile Mathe
	 * @param clientAccountId
	 * @return ciupdateclientdetailV12_Resp_IB_v1
	 */
     @AuraEnabled
    public static ciupdateclientdetailV12_Resp_IB_v1 clientdetails(String clientAccountId){
       List<User> currentUser = [SELECT Id, SiteCode__c, SiteType__c, Supervisor__C, ManagerId, Teller_Operator_Code__c,employeeNumber FROM USER WHERE Id =: Userinfo.getUserId() limit 1];
       //added code!!!
         AddressesSelector addrSelector = new AddressesSelector();
        List<Address__c> addressList = addrSelector.addressesRelatedToAcc(clientAccountId);

        // sitecode
      //  User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
        String siteCode = currentUser[0].SiteCode__c;
        String employeeNumber = currentUser[0].employeeNumber;
      // String siteCode = '009970';
        // cif
         Account accountList = new AccountsSelector().selectAccountFieldsCIFById(clientAccountId);
        // String cifKey = 'AEXCELL001';
        String clntAcctNbr = '0';
        GetClientDetailsCIF_Resp_IB_v1 respBean = new GetClientDetailsCIF_Resp_IB_v1();
        respBean = GetClientDetailsCIF_IH_v1.getClientDetails(accountList.CIF__c,clntAcctNbr,siteCode);

        String Res = JSON.serialize(respBean);

       // return respBean;
       //  String var2 = Res;
        List<Integration_Translation__c> translation = [SELECT Direction__c, External_Value__c, System_Name__c, Value_Type__c ,Internal_Value__c
                                                        FROM Integration_Translation__c
                                                        WHERE Direction__c = :'Outbound'
                                                        AND (System_Name__c =:'CIF'
                                                             OR System_Name__c =:'eCasa')];
        Map<String,String> translations = new Map<String,String>();
        for(Integration_Translation__c translatedVars: translation ){
            String mapKey = translatedVars.Internal_value__c+''+translatedVars.System_Name__c+''+translatedVars.Value_Type__c+''+translatedVars.Direction__c;
            translations.put(mapKey, translatedVars.External_Value__c); }


         ciupdateclientdetailV12_Resp_IB_v1 respBean1 = new ciupdateclientdetailV12_Resp_IB_v1();

         respBean1 =  ciupdateclientdetailV12_IH_v1.ciupdateclientdetailv12data(accountList,addressList,translations,accountList.Client_Type__c,siteCode,employeeNumber,respBean);
        return respBean1;

    }

     /**
	 * @description Creates opportunity for CAF
     * @author: Masechaba Maseli
	 * @param accountId
	 * @param processType
	 * @return String
	 */
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