/**
 * @description Controller for loading Security Prep Data
 * @author  Himani Joshi: Absa
 * @version v1.0
 * @since   2020-10-15
 *
 */
public class SecuritiesPrepController{
	/**
	 * @description getSecuritiesOffered description
	 *
	 * @param oppId (Id): oppId
	 * @return Map<string,List<object>>: Return description
	 */
	@AuraEnabled
	public static Map<string, List<object>> getSecuritiesOffered(Id oppId){
		Map<string, List<object>> responseMap = new Map<string, List<object>>();
		List<Security_Offered__c> securitiesOfferedWithAddressList = new List<Security_Offered__c>();
		List<Security_Offered__c> securitiesOfferedList = new List<Security_Offered__c>();
		List<SecurityWrapper> securityWrapperList = new List<SecurityWrapper>();
		List<Application__c> applicationList = new ApplicationsSelector().selectByOpportunityId(oppId);
		if (applicationList.size() > 0 && applicationList != null){
			//Get all Security_Offered__c linked to this Application__c
			securitiesOfferedList = new securitiesOfferedSelector().selectByApplicationId(applicationList[0].Id);
		}
		Set<Id> accIdSet = new Set<Id>();
		if (!securitiesOfferedList.isEmpty() && securitiesOfferedList != null && securitiesOfferedList.size() > 0){
			String mainPartyClientType = new AccountsSelector().selectAllByIdFOrDocs(securitiesOfferedList.get(0).Account__c).Client_Type__c;
            for (Security_Offered__c securityOffered : securitiesOfferedList){
			if (securityOffered.Account__c != null){
				accIdSet.add(securityOffered.Account__c);
			}
			if (securityOffered.Physical_Address_line_1__c == null){
				if (securityOffered.Account__c != null){
					List<Address__c> addList = new AddressesSelector().selectByAccountAndType(securityOffered.Account__c, 'Physical Address');
					if (addList != null && addList.size() > 0){
						securityOffered.Physical_Address_line_1__c = addList[0].Address1__c;
						securityOffered.Physical_Address_line_2__c = addList[0].Address2__c;
						securityOffered.Suburb__c = addList[0].Shipping_Suburb__c;
						securityOffered.Zip_Postal_code__c = addList[0].Shipping_Zip_Postal_Code__c;
						securityOffered.City__c = addList[0].Shipping_City__c;
						securityOffered.Country__c = addList[0].Shipping_Country__c;
					}
				}
			}
			SecurityWrapper secWrapper = new SecurityWrapper();
			secWrapper.Id = securityOffered.Id;

            if (securityOffered.Contact__c != null){
                secWrapper.name = securityOffered.Contact__r.Name;
                secWrapper.secProvEmail = securityOffered.Contact__r.Email;
                secWrapper.secProvClientType = securityOffered.Contact__r.Account.Client_Type__c;
            }
            if (securityOffered.Contact__c == null && securityOffered.External_Entity_Linked__c == true){
                secWrapper.name = securityOffered.Account__r.Name;
                secWrapper.secProvEmail = securityOffered.Account__r.PersonEmail != null ? securityOffered.Account__r.PersonEmail : securityOffered.Account__r.Active_Email__c;
                secWrapper.secProvClientType = mainPartyClientType;
            }
			if (securityOffered.Contact__c == null && securityOffered.External_Entity_Linked__c == false){
				secWrapper.name = securityOffered.Client_Name__c;
			}

			secWrapper.securityDescription = securityOffered.Security_Description__c;
			secWrapper.securityType = securityOffered.Security_Type__c;
			secWrapper.bondType = securityOffered.Bond_Type__c;
			switch on (securityOffered.Security_Type__c){
				when 'Bonds and 99-year Leasehold'{
					secWrapper.securityAmount = securityOffered.Bond_amount_registered_offered__c;
					secWrapper.securityDescription = securityOffered.Property_description__c;
				}
				when 'Cession of Internal Investments', 'Cession of External Investments', 'Cession of Life Policy (Not Link)', 'Cession of Life Policy (Link) (Sanlam)'{
					secWrapper.securityAmount = securityOffered.Amount_ceded__c;
				}
				when 'Suretyship'{
					secWrapper.securityAmount = securityOffered.Security_Amount__c;
				}
				when 'General Pledge'{
					secWrapper.securityAmount = securityOffered.Pledge_amount__c;
				}
				when 'Cession of Debtors'{
					secWrapper.securityAmount = securityOffered.Nominal_Value__c;
				}
				when 'Letter of Undertaking'{
					secWrapper.securityAmount = securityOffered.Nominal_Value__c;
					secWrapper.securityDescription = securityOffered.Description_of_Letter_of_Undertaking__c;
				}
				when 'Cession of Unit Trusts', 'Cession of Dematerialised Shares', 'General Cession'{
					secWrapper.securityAmount = securityOffered.Cession_Amount__c;
				}
				when 'Cession of Fire/Short Term Insurance'{
					secWrapper.securityAmount = securityOffered.Policy_amount__c;
				}
				when 'Excon Ruling'{
					secWrapper.securityAmount = securityOffered.Excon_Approved_Amount__c;
				}
			}
			secWrapper.nominalValue = securityOffered.Nominal_Value__c;
			secWrapper.ASVApprovedByCredit = securityOffered.ASV_approved_by_Credit__c;
			secWrapper.approvedSecurityValue = securityOffered.Approved_security_value__c;

			if (securityOffered.Securities_Offered_for_Facility__c == 'Existing'){
				secWrapper.specificAccount = securityOffered.Reference_Account_Number__c;
			}
			if (securityOffered.Securities_Offered_for_Facility__c == 'New'){
				secWrapper.specificAccount = securityOffered.Unique_Identifier__c;
			}
			if (securityOffered.Specific_Security__c == 'No'){
				secWrapper.specificAccount = 'Not Linked';
			}

			secWrapper.specificAccount = securityOffered.Reference_Account_Number__c != null ? securityOffered.Reference_Account_Number__c : securityOffered.Unique_Identifier__c != null ? securityOffered.Unique_Identifier__c : 'Not Linked';
			secWrapper.IDRegistrationNumber = securityOffered.ID_Registration_Number__c;
			secWrapper.IDType = securityOffered.ID_Type__c;
			secWrapper.accountId = securityOffered.Account__c != null ? securityOffered.Account__c : null;
			secWrapper.contactId = securityOffered.Contact__c;
			secWrapper.externalEntityLinked = securityOffered.External_Entity_Linked__c;
			securityWrapperList.add(secWrapper);
		}

			try{
				update securitiesOfferedList;
			} catch (DmlException e){
				responseMap.put('error ' + e.getMessage(), null);
			}
		}
        List<AccountContactRelation> accConRelationList = new AccountContactRelationSelector().selectRelationByAccountIdSet(accIdSet);
		responseMap.put('securitiesOfferedList', securitiesOfferedList);
		responseMap.put('conlist', accConRelationList);
		responseMap.put('securityWrapperList', securityWrapperList);

		return responseMap;
	}

	/**
	 * @description getSecurityOfferedDocuments description
	 *
	 * @param secId (id): secId
	 * @return List<Document__c>: Return description
	 */
	@AuraEnabled
	public static List<Document__c> getSecurityOfferedDocuments(id secId){
		return new DocumentsSelector().selectDocumentsByOppId(secId);
	}

	
	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-10-19 
	* @param oppId 
	* @param accId 
	* @param secId 
	* @param caseRecType 
	* @return Case 
	**/
	@auraEnabled
	public static Case createCaseForFlightCentre(Id oppId, Id accId, Id secId, string caseRecType){
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecType).getRecordTypeId();

		List<Service_Group__c> serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<string>{caseRecType});

		Case FlightCentrecase = new Case(RecordTypeId=caseRecordTypeId,Status = 'New',AccountId=accId,Opportunity__c = oppId,Subject = caseRecType,Type = caseRecType,Type__c = caseRecType);
        if (caseRecType =='EPrep for LDP') {
            FlightCentrecase.Product__c = 'LDP';
        }

        if (!serviceGroupList.isEmpty() && serviceGroupList.size() > 0 && serviceGroupList != null) {
            Set<Id> idSet = new Set<Id>();
            idSet.add(serviceGroupList.get(0).Id);
            List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);

            if (!serviceGroupTypes.isEmpty()){
                FlightCentrecase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                FlightCentrecase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
                FlightCentrecase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                FlightCentrecase.sd_Service_Group_Id__c = serviceGroupList.get(0).id;
                FlightCentrecase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
                FlightCentrecase.sd_Service_Group__c = serviceGroupList.get(0).Name;
                FlightCentrecase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                FlightCentrecase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
                FlightCentrecase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
                FlightCentrecase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
                FlightCentrecase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
                FlightCentrecase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                if (serviceGroupList.get(0).Queue__c != null){
                    List<Group> caseQueues = new GroupsSelector().selectByNameAndType(serviceGroupList.get(0).Queue__c, 'Queue');
                    if (!caseQueues.isEmpty()){
                        FlightCentrecase.OwnerId = caseQueues[0].id;
                    }
                }
            }
        }
		try{
			insert FlightCentrecase;

			List<Security_Offered__c> securitiesOfferedList = new securitiesOfferedSelector().selectById(secId);

			if (securitiesOfferedList?.size() > 0){
				Security_Offered__c securitiesOffered = securitiesOfferedList[0];
				if(securitiesOffered.Security_Type__c == 'Bonds and 99-year Leasehold') {
					securitiesOffered.Security_Status__c = 'Submitted To Flight Centre';

					update securitiesOffered;
				}
			}
		} catch (Exception exp){
			throw new AuraHandledException(exp.getMessage());
		}
		return FlightCentrecase;
	}

	/**
	 * @description get a List of Addresses for a security proider
	 * Tinashe M Shoko
	 * 2021-01-21
	 * @param accId (Id):
	 * @return List<Address__c>
	 */
	@auraEnabled
	public static List<Address__c> getAddresses(Id accId){
		List<Address__c> addressList = new List<Address__c>();
		if (DocumentController.getParentObjectName(accId) == 'Account'){
			addressList = new AddressesSelector().addressesRelatedToAcc(accId);
		}

		if (DocumentController.getParentObjectName(accId) == 'Contact'){
			addressList = new AddressesSelector().addressesRelatedToContact(accId);
		}

		return addressList;
	}

	/**
	 * @description get possible accounts to link to the id number provided
	 * Jason Quevauvilliers & Danie Booysen
	 * 2021-01-27
	 * @param identificationNumber string
	 * @return List<Account>
	 */
	@auraEnabled
	public static List<Account> getAccountData(String identificationNumber){
		List<Account> accountList = new List<Account>();
		if (identificationNumber != null){
			accountList = new AccountsSelector().selectAccountByIdPassportRegNumber(identificationNumber);
		}
		return accountList;
	}

	/**
	 * @description getAccountContactRelationData description
	 *
	 * @param identificationNumber (String): identificationNumber
	 * @param OpportunityId (Id): OpportunityId
	 * @return List<AccountContactRelation>: Return description
	 */
	@auraEnabled
	public static List<AccountContactRelation> getAccountContactRelationData(String identificationNumber, id OpportunityId){
		Id accId = new OpportunitiesSelector().selectByOpportunityId(OpportunityId) ?.get(0) ?.AccountId;
		List<AccountContactRelation> acrList = new List<AccountContactRelation>();
		if (identificationNumber != null){
			acrList = new AccountContactRelationSelector().selectbyIdNumber(identificationNumber, accId);
		}
		return acrList;
	}

	/**
	 * @description SecurityWrapper Description
	 *
	 */
	public class SecurityWrapper{
		@auraEnabled
		public String Id;
		@auraEnabled
		public String name;
		@auraEnabled
		public String securityDescription;
		@auraEnabled
		public String securityType;
		@auraEnabled
		public String bondType;
		@auraEnabled
		public Decimal securityAmount;
		@auraEnabled
		public Decimal nominalValue;
		@auraEnabled
		public Decimal ASVApprovedByCredit;
		@auraEnabled
		public Decimal approvedSecurityValue;
		@auraEnabled
		public String specificAccount;
		@auraEnabled
		public String IDRegistrationNumber;
		@auraEnabled
		public String IDType;
		@auraEnabled
		public String accountId;
		@auraEnabled
		public String contactId;
		@auraEnabled
		public Boolean externalEntityLinked;
        @auraEnabled
		public String secProvEmail;
		@auraEnabled
		public String secProvClientType;
	}

	/**
	 * @description saveChunk description
	 *
	 * @param parentId (Id): parentId
	 * @param fileName (String): fileName
	 * @param base64Data (String): base64Data
	 * @param contentType (String): contentType
	 * @param fileId (String): fileId
	 * @param done (Boolean): done
	 * @param documentType (String): documentType
	 * @param signedManually (Boolean): signedManually
	 * @param relatedPartyId (String): relatedPartyId
	 * @return Id: Return description
	 */
	@AuraEnabled
	public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, Boolean done, String documentType, Boolean signedManually, String relatedPartyId){
		return DocumentController.saveChunk(parentId, fileName, base64Data, contentType, fileId, done, documentType, signedManually, relatedPartyId);
	}

	/**
	 * @Author - Tinashe M Shoko
	 * @Date 13-Apr-2021
	 * @WorkItem W-011427
	 * @description getSecurityDocumentTypes description
	 *
	 * @param securityType (String): securityType
	 * @param securityProviderType (String): securityProviderType
	 * @param limited (String): limited
	 * @return List<Security_Documents__mdt>: Return description
	 */
	@AuraEnabled
	public static List<Security_Documents__mdt> getSecurityDocumentTypes(String securityType, String securityProviderType, String limited){
		List<Security_Documents__mdt> secDocsList = new List<Security_Documents__mdt>();
		try{
			switch on securityType{
				when 'Suretyship'{
					secDocsList = [Select id, Security_Type__c, Limited__c, Security_Provider_Type__c, Document_Type__c, Source__c
					               FROM Security_Documents__mdt
					               WHERE Security_Type__c = :securityType AND Security_Provider_Type__c = :securityProviderType];
				}
				when 'Cession of Fire/Short Term Insurance', 'Cession of Life Policy (Link) (Sanlam)', 'Cession of Life Policy (Not Link)'{
					secDocsList = [Select id, Security_Type__c, Limited__c, Security_Provider_Type__c, Document_Type__c, Source__c
					               FROM Security_Documents__mdt
					               WHERE Security_Type__c = :securityType];
				}
			}
		} catch (Exception e){
			throw new AuraHandledException(e.getMessage());
		}
		return secDocsList;
	}

	/**
	 * @description getApplicationProducts description
	 *
	 * @param ids (List<Id>): ids
	 * @return List<Application_Product__c>: Return description
	 */
	@AuraEnabled
	public static List<Application_Product__c> getApplicationProducts(List<Id> ids){
		List<Application_Product__c> applicationProducts = new List<Application_Product__c>();
		ApplicationProductSelector appProductselector = new ApplicationProductSelector();
		applicationProducts = appProductselector.selectById(new Set<Id>(ids));
		return applicationProducts;
	}
	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-10-19 
	* @param oppId 
	* @param accId 
	* @param secId 
	* @param caseRecType 
	* @return Case 
	**/
    @auraEnabled
	public static Case createBondRegistrationCase(Id oppId, Id accId,Id secId, string caseRecType){
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecType).getRecordTypeId();
        List<Service_Group__c> serviceGroupList = new ServiceGroupsSelector().selectByName(new Set<string>{caseRecType});
        Case FlightCentrecase = new Case(RecordTypeId=caseRecordTypeId,Status = 'New',AccountId=accId,Opportunity__c = oppId,Subject = caseRecType,Type = caseRecType,Type__c = caseRecType);
        if (!serviceGroupList.isEmpty() && serviceGroupList.size() > 0 && serviceGroupList != null) {
            Set<Id> idSet = new Set<Id>();
            idSet.add(serviceGroupList.get(0).Id);
            List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(idSet);

            if (!serviceGroupTypes.isEmpty()){
                FlightCentrecase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
                FlightCentrecase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
                FlightCentrecase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
                FlightCentrecase.sd_Service_Group_Id__c = serviceGroupList.get(0).id;
                FlightCentrecase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
                FlightCentrecase.sd_Service_Group__c = serviceGroupList.get(0).Name;
                FlightCentrecase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
                FlightCentrecase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
                FlightCentrecase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
                FlightCentrecase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
                FlightCentrecase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
                FlightCentrecase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                /*
                if (serviceGroupList.get(0).Queue__c != null){
                    List<Group> caseQueues = new GroupsSelector().selectByNameAndType(serviceGroupList.get(0).Queue__c, 'Queue');
                    system.debug('caseQueues'+caseQueues);
                    //system.debug('caseQueues[0].id'+caseQueues[0].id);
                    if (!caseQueues.isEmpty()){
                        FlightCentrecase.OwnerId = caseQueues[0].id;
                    }
                }
*/
            }
        }
        FlightCentrecase.Relationship_Banker__c = opp.OwnerId;
        FlightCentrecase.SecurityId__c=secId;
        try{
			insert FlightCentrecase;

			List<Security_Offered__c> securitiesOfferedList = new securitiesOfferedSelector().selectById(secId);

			if (securitiesOfferedList?.size() > 0){
				Security_Offered__c securitiesOffered = securitiesOfferedList[0];
				if(securitiesOffered.Security_Type__c == 'Bonds and 99-year Leasehold') {
					securitiesOffered.Security_Status__c = 'Submitted To Flight Centre';
                    
					update securitiesOffered;
				}
			}
		} catch (Exception exp){
			throw new AuraHandledException(exp.getMessage());
		}
		return FlightCentrecase;
    }
    
	/**
	* @description 
	* @author almas.aleem@absa.africa | 2021-10-19 
	* @param selectedSecurity 
	* @return Security_Offered__c 
	**/
    @auraEnabled
	public static Security_Offered__c updateSecurities(Id selectedSecurity){
       
       List<Case> caseList=[select Id,Status from case where SecurityId__c=:selectedSecurity];
       security_offered__c sfc=[select Id,Security_Status__c,Bond_type__c from security_offered__c where Id=:selectedSecurity];
        if(caseList.size()>0){
            if(caseList[0].Status=='New'){
                sfc.Security_Status__c='Submitted To Flight Centre';
            }
       sfc.Security_Status__c=caseList[0].Status;
        }
       update sfc;
       //return sfc.Security_Status__c;
       return sfc;
       
    }
}