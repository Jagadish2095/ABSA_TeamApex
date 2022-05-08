/**
 * @description Extension Controller for OnboardingCASAScreening Component
 *
 * @author  Anka Ganta : Absa
 * @version v1.0
 * @since   2020-02-20
 *
 */
public class OnboardingCASAScreeningController {
	/**
	 * @description Call to Casa screen Primary and Related Party
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String callToCASAScreening(String oppId) {
        try {
            String returnMessage = 'SUCCESS';
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
            List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
            String accountHierarchy = '';
            accountHierarchy = accounts[0].UBO_ParentAccountWrapper__c;
            List<Account> relatedParties;
            string OppOwner = '';
            Opportunity Opp = new OpportunitiesSelector().selectByActivityId(opportunities.get(0).Id,1);
            relatedParties = getParticipantsAccCons(oppId,accountHierarchy);
            /*OppOwner = Opp.CreatedBy.Name;
                if(OppOwner.contains('Virtual')){
                    relatedParties = getPartcicpantAccount(opportunities.get(0).Id); 
                }
            else{
                //00001 -casa issue
                //relatedParties = getParticipants(opportunities.get(0).AccountId,'AccountContact',accountHierarchy);
                relatedParties = getParticipantsAccCons(oppId,accountHierarchy);
                
           }*/
            List<Account> relatedPartiesBusiness = getPartcicpantBusinessAccountData(opportunities.get(0).Id); 
            List<Trading_as_Name__c> tradingAsNameParties = getTradingAsNameData(opportunities.get(0).Id, relatedPartiesBusiness);
            CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IH_v3.casaPrimaryClientScreeningBusinessAcc(
                accounts[0],
                relatedParties,
                tradingAsNameParties,
                relatedPartiesBusiness
            );
            
            if (casaPrimaryClientScreeningResponse.statusCode == 200) {
                if (
                    casaPrimaryClientScreeningResponse.msgNo == '1' ||
                    (casaPrimaryClientScreeningResponse.refNo != null &&
                     casaPrimaryClientScreeningResponse.refNo != '0')
                ) {
                    returnMessage = returnMessage + '' + casaPrimaryClientScreeningResponse.message;
                } else {
                    returnMessage = '' + casaPrimaryClientScreeningResponse.msg;
                }
                
                //TdB - Update Opportiity with Casa Primary Results
                if (opportunities != null && opportunities.size() > 0) {
                    try {
                        opportunities[0].CASA_Reference_Number__c = casaPrimaryClientScreeningResponse.refNo;
                        opportunities[0].CASA_Screening_Date__c = System.today();
                        opportunities[0].Casa_Status__c = 'Valid';
                        String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
                            StringConstants.ECASA_STRING,
                            StringConstants.ECASA_STRING_REF,
                            casaPrimaryClientScreeningResponse.casaStatus,
                            StringConstants.INBOUND_RECORD_TYPE
                        );
                        opportunities[0].CASA_Screening_Status_Value__c = casaStatusTranslated;
                        
                        update opportunities[0];
                    } catch (Exception e) {
                        throw new AuraHandledException(e.getMessage());
                    }
                }
            } else {
                returnMessage = '' + casaPrimaryClientScreeningResponse.message;
            }
            return returnMessage;
        } catch (Exception e) {
            throw new AuraHandledException('Something went wrong: ' + e.getMessage());
        }
	}
    
    /**
	 * @description Get list of accounts for casa screening : //00001 -casa issue
	 * @param oppId
	 * @param accountHierarchy
	 * @return List<Account>
	 */
    @AuraEnabled
    public static List<Account> getParticipantsAccCons(Id oppId,String accountHierarchy){
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        List<Account> rpAccounts;
        Set<Id> participantIdsSet;
        List<AccountContactRelation> acrList;
        //get list of recordIds acr ids from ubo structure
        participantIdsSet = OnboardingMainUtil.getParticipantsData(accountHierarchy);
        //get list of acr records from ubo structure
        acrList = AccountContactRelationUtil.getAccountContactRelation(participantIdsSet);
        //get list of acr records from AccountContactRelation
        List<AccountContactRelation> acrListRelatedParty = new AccountContactRelationSelector().selectByRelatedPartySection(opportunities.get(0).AccountId);
        acrList.addAll(acrListRelatedParty);
        Set<Id> relatedPartyIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            if(acr.Roles != 'Contact Person') {
                relatedPartyIdSet.add(acr.ContactId);
            }
            
        }
        
        return rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetIds(relatedPartyIdSet);
    }

	/**
	 * @description GetThe Opportunity Id
	 * @param recordId
	 * @return List<Opportunity>
	 */
	@AuraEnabled
	public static List<Opportunity> getOppId(Id recordId) {
		List<Opportunity> oppId = [SELECT Id FROM Opportunity WHERE AccountId = :recordId LIMIT 1];
		return oppId;
	}

	/**
	 * @description Method that gets a an account
	 * @param oppId - opportunity Id
	 * @return Account - specific account related to account
	 */
	@AuraEnabled
	public static Account getAccountData(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities[0].AccountId, 1);
		if (accounts.size() > 0 && accounts[0] != null) {
			if (accounts[0].RecordType.Name == 'Business Client' || accounts[0].RecordType.Name == 'Business Prospect') {
				accounts = new AccountsSelector().selectCasaFieldsJointAccountById(accounts[0].Id, 1);
			} else if (accounts[0].RecordType.Name == 'Individual Client' || accounts[0].RecordType.Name == 'Individual Prospect') {
				accounts = new AccountsSelector().selectCasaFieldsByIds(accounts[0].Id, 1);
			}
		}
		return accounts[0];
	}

    /**
    * @description getParentAccountWrapper
    * @param oppId 
    * @return String 
    **/
	 @AuraEnabled
    public static String getParentAccountWrapper(Id oppId) { 
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
                
        String accountHierarchy = OnboardingUBOListViewController.parentAccountWrapper(opportunities.get(0).AccountId, false);
        return accountHierarchy;
    }

	
	/**
	* @description Method that gets the related party accounts from an account
	* @param oppId 
	* @param parentAccWrapper 
	* @return List<Account> 
	**/
	@AuraEnabled
	public static List<Account> getPartcicpantAccountData(Id oppId, String parentAccWrapper) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

		List<Account> relatedParties= getParticipants(opportunities.get(0).AccountId,'AccountContact',parentAccWrapper);
        return relatedParties;
		
	}

	/**
	 * @description Method that gets the related party accounts from an account
	 *
	 * @param oppId - opportunity Id
	 * @return List<Account> - specific accounts related to the primary account
	 */
	@AuraEnabled
	public static List<Account> getPartcicpantBusinessAccountData(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

        //Tdb - Include Business Entities on Relationship Section
        List<FinServ__AccountAccountRelation__c> accAccList = new AccountAccountRelationSelector().selectByPrimaryForRelationshipSection(opportunities.get(0).AccountId);
        Set<Id> relatedPartAccIdSet = new Set<Id>();
        for(FinServ__AccountAccountRelation__c eachAccAcc : accAccList) {
            relatedPartAccIdSet.add(eachAccAcc.FinServ__RelatedAccount__c);
        }
        
        List<Account> rpAccAccounts = new AccountsSelector().selectCasaBusinessFieldsBySetId(relatedPartAccIdSet);
        
        return rpAccAccounts;
	}

	/**
	 * @description TdB - Get Trading as Name details
	 *
	 * @param oppId - opportunity Id
	 * @param businessRelatedParties
	 * @return List<Trading_as_Name__c>
	 */
	@AuraEnabled
	public static List<Trading_as_Name__c> getTradingAsNameData(Id oppId, List<Account> businessRelatedParties) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

		Set<Id> accIdSets = new Set<Id>();


        if(businessRelatedParties != null && businessRelatedParties.size() > 0) {
            for(Account eachAcc : businessRelatedParties) {
                accIdSets.add(eachAcc.Id);           
            }
        }
		List<Trading_as_Name__c> tradingAsNameRecords = new List<Trading_as_Name__c>();
		if (accounts != null && accounts.size() > 0) {
			accIdSets.add(accounts[0].id);
			if(accIdSets != null && accIdSets.size() > 0) {
                tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSets);
            }
		}
		return tradingAsNameRecords;
	}

	/**
	 * @description Method that calls the refresh casa status service if the previous status was pending approval
	 *
	 * @param oppId - opportunity Id
	 * @return String - the risk status i.e. valid, invalid etc.
	 */
	@AuraEnabled
	public static String refreshCasaStatus(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
		Set<Id> accIdSets = new Set<Id>();
		Boolean mainRecordCasaFailed = false;
		Boolean relatedRecordCasaFailed = false;
		GetCasaDetailsByRef_Resp_IB_v1 mainPartyCasaResp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(accounts.get(0).CASA_Reference_Number__c, '', false);
		if (mainPartyCasaResp.casaStatus != 'Approved') {
			mainRecordCasaFailed = true;
		}
		accIdSets.add(accounts[0].id);
		//W-007512 : Anka Ganta - get related parties Primary_Entity_Id__c in UBO structure
		Set<Id> relPartyPrimaryEntityIdSet = new Set<Id>();
		for (Controlling_Interest__c contrInt : [
			SELECT
				Id,
				Name,
				Contact__c,
				Contact__r.Name,
				Controlling_Interest__c,
				Other_Primary_Entity_Id__c,
				Parent_Account__c,
				Primary_Entity__c,
				Related_Account__c,
				UBO__c
			FROM Controlling_Interest__c
			WHERE Primary_Entity__c = :opportunities.get(0).AccountId AND UBO__c = 'Yes'
		]) {
			relPartyPrimaryEntityIdSet.add(contrInt.Other_Primary_Entity_Id__c);
		}

		// if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
		//List<Account> participants = new AccountContactRelationSelector().selectListByAccId(opportunities.get(0).AccountId);
		List<Account> participants = new AccountContactRelationSelector()
			.selectListByAccIdAndPrimaryEntityId(opportunities.get(0).AccountId, relPartyPrimaryEntityIdSet);
		List<Trading_as_Name__c> tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSets);
		List<String> participantStatuses = new List<String>();
		List<String> participantPEPStatuses = new List<String>();

		if (participants != null && participants.size() > 0) {
			for (Account participant : participants) {
				//participant.CASA_Reference_Number__pc//'197101150307'

				GetCasaDetailsByRef_Resp_IB_v1 resp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(participant.CASA_Reference_Number__pc, '', false);
				if (resp.statusCode == 200 && resp.msgNo == '0') {
					String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						'Screening Status',
						resp.casaStatus,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					participant.CASA_Screening_Status__pc = resp.casaStatus;
					participant.PEP_Status__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						'Screening Status',
						resp.pepSts,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					participant.status_pepsts__c = resp.status;
					participantStatuses.add(resp.casaStatus);
					if (participant.PEP_Status__pc != null) {
						participantPEPStatuses.add(participant.PEP_Status__pc);
					}
				} else {
					if (resp.message != null || resp.message != '') {
						return 'Error: ' + resp.message;
					} else {
						return 'Error: An unknown error has occured please contact a system administrator';
					}
				}
			}

			update participants;
			String relPartyStatus = 'Approved';
			for (String status : participantStatuses) {
				if (status != 'Approved') {
					relPartyStatus = status;
					relatedRecordCasaFailed = true;
					break;
				}
			}
			String relPartyPEPStatus = 'Approved';
			for (String status : participantPEPStatuses) {
				if (status != 'Approved') {
					relPartyPEPStatus = status;
					break;
				}
			}
			accounts.get(0).CASA_Screening_Status__c = relPartyStatus;
			accounts.get(0).PEP_Status__c = relPartyPEPStatus;
			update accounts;

			//TdB - Update Opportiity with Casa Primary Results
			if (opportunities != null && opportunities.size() > 0) {
				try {
					if (!mainRecordCasaFailed & relatedRecordCasaFailed) {
						opportunities[0].CASA_Screening_Date__c = System.today();
						opportunities[0].CASA_Screening_Status_Value__c = relPartyStatus;
						opportunities[0].PEP_Status__c = relPartyPEPStatus;
					} else {
						opportunities[0].CASA_Screening_Date__c = System.today();
						opportunities[0].CASA_Screening_Status_Value__c = mainPartyCasaResp.casaStatus;
						opportunities[0].PEP_Status__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							StringConstants.ECASA_STRING,
							'Screening Status',
							mainPartyCasaResp.pepSts,
							StringConstants.OUTBOUND_RECORD_TYPE
						);
					}
					update opportunities[0];
				} catch (Exception e) {
					throw new AuraHandledException(e.getMessage());
				}
			}
		} else {
			GetCasaDetailsByRef_Resp_IB_v1 resp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(accounts.get(0).CASA_Reference_Number__pc, '');
			if (resp.statusCode == 200 && resp.msgNo == '0') {
				accounts.get(0).CASA_Screening_Status__pc = resp.casaStatus;
				accounts.get(0).PEP_Status__pc = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.ECASA_STRING,
					'Screening Status',
					resp.pepSts,
					StringConstants.OUTBOUND_RECORD_TYPE
				);

				update accounts.get(0);

				//TdB - Update Opportiity with Casa Primary Results
				if (opportunities != null && opportunities.size() > 0) {
					try {
						opportunities[0].CASA_Screening_Date__c = System.today();
						opportunities[0].PEP_Status__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							StringConstants.ECASA_STRING,
							'Screening Status',
							resp.pepSts,
							StringConstants.OUTBOUND_RECORD_TYPE
						);
						opportunities[0].CASA_Screening_Status_Value__c = resp.casaStatus;

						update opportunities[0];
					} catch (Exception e) {
						throw new AuraHandledException(e.getMessage());
					}
				}
			} else {
				if (resp.message != null || resp.message != '') {
					return 'Error: ' + resp.message;
				} else {
					return 'Error: An unknown error has occured please contact a system administrator';
				}
			}
		}

		//TdB - Refresh Casa Status for Trading as Name
		if (tradingAsNameRecords != null && tradingAsNameRecords.size() > 0) {
			for (Trading_as_Name__c eachTradingName : tradingAsNameRecords) {
				GetCasaDetailsByRef_Resp_IB_v1 resp = GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef(eachTradingName.CASA_Reference_Number__c, '', false);
				if (resp.statusCode == 200 && resp.msgNo == '0') {
					String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						'Screening Status',
						resp.casaStatus,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					eachTradingName.CASA_Screening_Status__c = resp.casaStatus;
					eachTradingName.PEP_Status__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						'Screening Status',
						resp.pepSts,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
					participantStatuses.add(resp.casaStatus);
				} else {
					if (resp.message != null || resp.message != '') {
						return 'Error: ' + resp.message;
					} else {
						return 'Error: An unknown error has occured please contact a system administrator';
					}
				}
			}

			update tradingAsNameRecords;
		}

		return 'Success';
	}

	/**
	 * @description Method that checks what the Account record type is
	 *
	 * @param oppId - opportunity Id
	 * @return String - account record type i.e. Individual/Business client
	 */
	@AuraEnabled
	public static String getAccountRecordType(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
		if (accounts.size() > 0 && accounts[0] != null) {
			if (accounts[0].RecordType.Name != null) {
				return accounts.get(0).RecordType.Name;
			}
		}
		return accounts[0].RecordType.Name;
	}

	/**
	 * @description Create high risk case for Opportunity
	 * @param accountId
	 * @param serviceGroupName
	 * @param caseRecordTypeDeveloperName
	 * @return Case
	 */
	@AuraEnabled
	public static Case createHighRiskCase(String accountId, String serviceGroupName, String caseRecordTypeDeveloperName) {
		Case riskCase = new Case();
		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		if (serviceGroupName != null && caseRecordTypeDeveloperName != null) {
			//Get Service Group details based on Name
			Set<String> serviceGroupNames = new Set<String>();
			serviceGroupNames.add(serviceGroupName);
			List<Service_Group__c> serviceGroups = new ServiceGroupsSelector().selectByName(serviceGroupNames);

			//Get Service Group Type based on Service Group
			if (serviceGroups != null && serviceGroups.size() > 0) {
				Set<Id> serviceGroupIds = new Set<Id>();
				serviceGroupIds.add(serviceGroups[0].Id);
				List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(serviceGroupIds);

				if (serviceGroupTypes != null && serviceGroups.size() > 0) {
					riskCase.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
					riskCase.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
					riskCase.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
					riskCase.sd_Service_Group_Id__c = serviceGroups[0].Id;
					riskCase.sd_Communication_Plan_Id__c = serviceGroupTypes[0].sd_Communication_Plan__c;
					riskCase.sd_Service_Group__c = serviceGroups[0].Name;
					riskCase.sd_Service_Group__c = serviceGroups[0].Name;
					riskCase.sd_Service_Group__c = serviceGroups[0].Name;
					riskCase.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].id;
					riskCase.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
					riskCase.sd_Response_Email_Address__c = serviceGroupTypes[0].Service_Group__r.Response_Email_Address__c;
					riskCase.sd_Email_Template_Case_Creation__c = serviceGroupTypes[0].Service_Group__r.Email_Template_Case_Creation__c;
					riskCase.Internal_SLA_Notification_User__c = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;
					riskCase.External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
					riskCase.Originated_By__c = 'Non-Absa Customer';

					//Get Queue
					List<Group> caseQueues = new GroupsSelector().selectByNameAndType(serviceGroups[0].Queue__c, 'Queue');
					if (!caseQueues.isEmpty()) {
						riskCase.OwnerId = caseQueues[0].id;
					}

					riskCase.Subject = 'High Risk / Pep Client Onboarding';
					riskCase.Description = 'Perform Enhanced Due Diligence';
					riskCase.AccountId = accountId;
					riskCase.RecordTypeId = caseRecordTypeMap.get(caseRecordTypeDeveloperName).getRecordTypeId();
					riskCase.Bypass_Validation_Rules__c = true;
					riskCase.Skip_Auto_Response__c = true;

					insert riskCase;
				} else {
					throw new AuraHandledException('No Service Group Type found. Please contact your System Administrator');
				}
			} else {
				throw new AuraHandledException('No Service Group is found. Please contact your System Administrator');
			}
		} else {
			throw new AuraHandledException('No Service Group is Setup. Please contact your System Administrator');
		}

		return riskCase;
	}

	/**
	 * @description TdB - Method that gets Opportunity Details
	 *
	 * @param oppId - opportunity Id
	 * @return Opportunity - specific opportunity details
	 */
	@AuraEnabled
	public static Opportunity getOpportunityData(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

		if (opportunities != null && opportunities.size() > 0) {
			return opportunities[0];
		} else {
			return null;
		}
	}

	/**
	 *  @description Anka Ganta: W-**** : docPack Orchestration
	 *  SF make a call to 1. getDocuments service on Jitterbit
	 *  Jitterbit make a call to service 2 and 3 internally and give consolidate response.
	 * 2. WQconfirmDocumentReceiptV2(CASA Tier 1,2)
	 * 3. WQacknowledgeDocumentsV1 (CASA Tier 3)
	 * @param oppId - opportunity Id
	 * @return String
	 */
	@AuraEnabled
	public static String getDocumentsCasaTiers(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accRecP = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
		GetDocumentsv1_Req_IB_v1 requestBean = new GetDocumentsv1_Req_IB_v1();
		GetDocumentsv1_Req_IB_v1.GetDocsRequest GetDocsRequestbean = new GetDocumentsv1_Req_IB_v1.GetDocsRequest();
		GetDocumentsv1_Req_IB_v1.RequestMessage RequestMessagebean = new GetDocumentsv1_Req_IB_v1.RequestMessage();
		GetDocumentsv1_Req_IB_v1.Header Headerbean = new GetDocumentsv1_Req_IB_v1.Header();
		GetDocumentsv1_Req_IB_v1.GenerateDocument GenerateDocumentbean = new GetDocumentsv1_Req_IB_v1.GenerateDocument();

		Usersselector us = new Usersselector();
		List<User> userP = us.userwithSiteCode(UserInfo.getUserId());
		if (accRecP[0].Client_Group__c == 'Individual' || accRecP[0].Client_Group__c == 'SOLE TRADER CLIENT') {
			GetDocsRequestbean.RefNumber = accRecP[0].CASA_Reference_Number__pc;
		} else {
			GetDocsRequestbean.RefNumber = accRecP[0].CASA_Reference_Number__c;
		}
		GetDocsRequestbean.SBU = '0';
		GetDocsRequestbean.OriginatingSystem = 'ESP';
		if (userP[0].SiteCode__c != null && userP[0].AB_Number__c != null) {
			GetDocsRequestbean.Branch = userP[0].SiteCode__c;
			GetDocsRequestbean.InitialAB = userP[0].AB_Number__c;
		}
		GetDocsRequestbean.Additional_Docs = '';
		RequestMessagebean.GetDocsRequest = GetDocsRequestbean;
		Headerbean.transID = '12344';
		Headerbean.sourceApp = 'Salesforce';
		GenerateDocumentbean.Header = Headerbean;
		GenerateDocumentbean.RequestMessage = RequestMessagebean;
		requestBean.GenerateDocument = GenerateDocumentbean;
		GetDocumentsv1_IH_v1.getDocuments(requestbean);

		return 'SUCCESS';
	}
	/**
	 * @description Anka Ganta: W-005025 :
	 * 1. Generatedocumentsv7 2. WQconfirmDocumentReceiptV2(CASA Tier 1,2)
	 * 3. WQacknowledgeDocumentsV1 (CASA Tier 3)
	 * @ create confirmDocumentReceiptLog(System log of above services) -
	 * @param oppId - opportunity Id
	 * @return String
	 */

	@AuraEnabled
	public static String confirmDocumentReceipt(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accountP = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
		//Generic variables
		List<Sys_Log_Integration__c> confirmDocumentReceiptLog = new List<Sys_Log_Integration__c>();
		//Generatedocumentsv7 related variables
		Map<Generatedocumentsv7_Resp_IB_v1, Sys_Log_Integration__c> Generatedocumentsv7beanToLogMap;

		Generatedocumentsv7_Resp_IB_v1.Envelope Envelopebean = new Generatedocumentsv7_Resp_IB_v1.Envelope();
		Generatedocumentsv7_Resp_IB_v1.Body Bodybean = new Generatedocumentsv7_Resp_IB_v1.Body();
		Generatedocumentsv7_Resp_IB_v1.GetDocsResponse GetDocsResponsebean = new Generatedocumentsv7_Resp_IB_v1.GetDocsResponse();
		List<Generatedocumentsv7_Resp_IB_v1.Documentation> DocumentationListbean = new List<Generatedocumentsv7_Resp_IB_v1.Documentation>();

		//WQconfirmDocumentReceiptV2 related variables
		Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> WQconfirmDocumentReceiptV2beanToLogMap;
		WQconfirmDocumentReceiptV2_Resp_IB_v1 WQconfirmDocumentReceiptV2RespBean;

		//WQacknowledgeDocumentsV1 related variables
		Map<WQacknowledgeDocumentsV1_Resp_IB_v1, Sys_Log_Integration__c> WQacknowledgeDocumentsV1beanToLogMap;
		WQacknowledgeDocumentsV1_Resp_IB_v1 WQacknowledgeDocumentsV1RespBean;

		List<String> docCodeList = new List<String>();
		String docNoP;
		String VersionNoP;

		// Calling document hub services starts here
		Generatedocumentsv7beanToLogMap = Generatedocumentsv7_IH_v1.generateDocuments(accountP[0], false);

		//Add Generatedocumentsv7 log to  main DocPackServiceLogList Sys log
		if (Generatedocumentsv7beanToLogMap.values().size() > 0) {
			confirmDocumentReceiptLog.add(Generatedocumentsv7beanToLogMap.values()[0]);
		}

		// If Generatedocumentsv7 service has valid response
		if (Generatedocumentsv7beanToLogMap.keySet().size() > 0) {
			List<Generatedocumentsv7_Resp_IB_v1> Generatedocumentsv7RespBean = new List<Generatedocumentsv7_Resp_IB_v1>(
				Generatedocumentsv7beanToLogMap.keySet()
			);
			if (
				Generatedocumentsv7RespBean[0].StatusCode == 200 &&
				Generatedocumentsv7RespBean[0] != null &&
				!Generatedocumentsv7RespBean.isEmpty() &&
				Generatedocumentsv7RespBean.size() > 0
			) {
				Envelopebean = Generatedocumentsv7RespBean[0].Envelope;
				Bodybean = Envelopebean.Body;
				GetDocsResponsebean = Bodybean.GetDocsResponse;
				if (GetDocsResponsebean.msgNo == '0' && GetDocsResponsebean.DocNo != '0') {
					DocumentationListbean = GetDocsResponsebean.documentation;
					docNoP = GetDocsResponsebean.docNo;
					VersionNoP = GetDocsResponsebean.VersionNo;
					if (!DocumentationListbean.isEmpty() && DocumentationListbean.size() > 0 && DocumentationListbean != null) {
						for (Generatedocumentsv7_Resp_IB_v1.Documentation docBean : DocumentationListbean) {
							docCodeList.add(docBean.docCode);
						}
					}

					if (!docCodeList.isEmpty() && docCodeList.size() > 0) {
						try {
							WQconfirmDocumentReceiptV2beanToLogMap = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(
								accountP[0],
								docCodeList,
								docNoP,
								VersionNoP,
								false
							);
							if (WQconfirmDocumentReceiptV2beanToLogMap.values().size() > 0) {
								confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
							}
							WQacknowledgeDocumentsV1beanToLogMap = WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(
								accountP[0],
								docCodeList,
								docNoP,
								VersionNoP,
								false
							);
							if (WQacknowledgeDocumentsV1beanToLogMap.values().size() > 0) {
								confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
							}
						} catch (Exception e) {
							throw new AuraHandledException(e.getMessage());
						}
					}
				} else if (GetDocsResponsebean.msgNo == '0' && GetDocsResponsebean.DocNo == '0') {
					docNoP = GetDocsResponsebean.docNo;
					VersionNoP = GetDocsResponsebean.VersionNo;

					WQconfirmDocumentReceiptV2beanToLogMap = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(
						accountP[0],
						docCodeList,
						docNoP,
						VersionNoP,
						false
					);
					if (WQconfirmDocumentReceiptV2beanToLogMap.values().size() > 0) {
						confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
					}
					WQacknowledgeDocumentsV1beanToLogMap = WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(
						accountP[0],
						docCodeList,
						docNoP,
						VersionNoP,
						false
					);
					if (WQacknowledgeDocumentsV1beanToLogMap.values().size() > 0) {
						confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
					}
				} else if (GetDocsResponsebean.msgNo != '0' && GetDocsResponsebean.DocNo == '0') {
					docNoP = GetDocsResponsebean.docNo;
					VersionNoP = GetDocsResponsebean.VersionNo;

					WQconfirmDocumentReceiptV2beanToLogMap = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(
						accountP[0],
						docCodeList,
						docNoP,
						VersionNoP,
						false
					);
					if (WQconfirmDocumentReceiptV2beanToLogMap.values().size() > 0) {
						confirmDocumentReceiptLog.add(WQconfirmDocumentReceiptV2beanToLogMap.values()[0]);
					}
					WQacknowledgeDocumentsV1beanToLogMap = WQacknowledgeDocumentsV1_IH_v1.acknowledgeDocuments(
						accountP[0],
						docCodeList,
						docNoP,
						VersionNoP,
						false
					);
					if (WQacknowledgeDocumentsV1beanToLogMap.values().size() > 0) {
						confirmDocumentReceiptLog.add(WQacknowledgeDocumentsV1beanToLogMap.values()[0]);
					}
				}
			}
		}
		if (confirmDocumentReceiptLog.size() > 0 && !confirmDocumentReceiptLog.isEmpty()) {
			insert confirmDocumentReceiptLog;
		}

		return 'success';
	}

	/**
	 * @description Anka Ganta W-004015 : used to get CASA Analyst Comments
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String getAnalystComments(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);

		// if(accounts.get(0).RecordType.Name == 'Business Client' || accounts.get(0).RecordType.Name == 'Business Prospect'){
		List<Account> participants = new AccountContactRelationSelector().selectListByAccId(opportunities.get(0).AccountId);
		List<String> participantStatuses = new List<String>();
		//Define sys log
		List<Sys_Log_Integration__c> AnalystCommentsLogList = new List<Sys_Log_Integration__c>();
		if (participants.size() == 0 && accounts.size() > 0)
			participants.add(accounts[0]);
		if (participants != null && participants.size() > 0) {
			for (Account participant : participants) {
				Map<Wqgetanalystcommentsv7_Resp_IB_v1, Sys_Log_Integration__c> Wqgetanalystcommentsv7beanToLogMap;

				// Call to Wqgetanalystcommentsv7 service
				Wqgetanalystcommentsv7beanToLogMap = Wqgetanalystcommentsv7_IH_v1.getCasaAnalystComments(participant, false);

				//Add Wqgetanalystcommentsv7 log to AnalystCommentsLogList Sys log
				if (Wqgetanalystcommentsv7beanToLogMap.values().size() > 0) {
					AnalystCommentsLogList.add(Wqgetanalystcommentsv7beanToLogMap.values()[0]);
				}

				List<Wqgetanalystcommentsv7_Resp_IB_v1> Wqgetanalystcommentsv7RespBean = new List<Wqgetanalystcommentsv7_Resp_IB_v1>(
					Wqgetanalystcommentsv7beanToLogMap.keySet()
				);
				if (Wqgetanalystcommentsv7RespBean.size() > 0 && !Wqgetanalystcommentsv7RespBean.isEmpty()) {
					if (Wqgetanalystcommentsv7RespBean[0].statusCode == 200) {
						Wqgetanalystcommentsv7_Resp_IB_v1 responseBean = new Wqgetanalystcommentsv7_Resp_IB_v1();
						Wqgetanalystcommentsv7_Resp_IB_v1.Results resulstsBean = new Wqgetanalystcommentsv7_Resp_IB_v1.Results();
						Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response commentsbean = new Wqgetanalystcommentsv7_Resp_IB_v1.WQgetAnalystCommentsV7Response();
						responseBean = Wqgetanalystcommentsv7RespBean[0];
						commentsbean = Wqgetanalystcommentsv7RespBean[0].WQgetAnalystCommentsV7Response;
						resulstsBean = commentsbean.results;
						participant.CASA_Analyst_Comments__pc = resulstsBean.commentDesc;
					}
				}
			}
			update participants;
		}
		if (AnalystCommentsLogList != null && AnalystCommentsLogList.size() > 0) {
			try {
				insert AnalystCommentsLogList;
			} catch (DmlException e) {
				return e.getMessage();
			}
		}

		return 'success';
	}

	/**
	 * @description Get Opportunity Product
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String getOpportunityProduct(String oppId) {
		OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
		List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(oppId);

		if (oppLineItem.size() > 0 && oppLineItem[0].product2 != null) {
			return oppLineItem[0].product2.Name;
		} else
			return 'undefined';
	}

	/**
	 * @description Anka Ganta W-005017 : used to get EDD Procees required documents
	 * @param opportunityId
	 * @return : List<String>
	 */
	@AuraEnabled
	public static List<String> getDocsByOppId(Id opportunityId) {
		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
		Set<String> requiredDocs = new Set<String>();
		for (Document__c doc : docList) {
			if (doc.Type__c == StringConstants.EDD_level_ll_report_STRING) {
				requiredDocs.add(doc.Type__c);
			}
			if (doc.Type__c == StringConstants.Management_sign_off_STRING) {
				requiredDocs.add(doc.Type__c);
			}
			if (doc.Type__c == StringConstants.POS_of_Income_funds_STRING) {
				requiredDocs.add(doc.Type__c);
			}
		}
		return new List<String>(requiredDocs);
	}

	/**
	 * @description Start changes for W-004683 By Himani
	 * @param opportunityId
	 * @return List<Opportunity>
	 */
	@AuraEnabled
	public static List<Opportunity> getentitytype(Id opportunityId) {
		list<opportunity> entitytype = [SELECT Entity_Type__c FROM opportunity WHERE id = :opportunityId LIMIT 1];
		return entitytype;
	}

	/**
	 * @description :: W-005270 By Himani
	 * @Updated by Thulani W-005273
	 *  Method that gets a list of documents uploaded
	 * @param opportunityId
	 * @return List<Opportunity>
	 */
	@AuraEnabled
	public static List<string> getDocs(Id opportunityId) {
		return DocumentManagementControler.getDocs(opportunityId);
	}

	/**
	 * @description Get all Mandatory documents
	 * @param Entitytype
	 * @return List<Mandatory_Doc__mdt>
	 */
	@AuraEnabled
	public static List<Mandatory_Doc__mdt> getAllMandatoryDocuments(string Entitytype) {
		return DocumentManagementControler.getAllMandatoryDocuments(Entitytype);
	}

	/**
	 * @description W-005222 By Masechaba Maseli
	 * Method verifies mandatory documents for related parties
	 * @param Entitytype
	 * @param OppId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getAllRelatedMandatoryDocuments(string Entitytype, String OppId) {
		List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(OppId);

		return DocumentManagementControler.getAllRelMandatoryDocuments(Entitytype, OppId, docList);
	}

	/**
	 * @description Update by Thulani  W-005273
	 * @param recordId
	 * @param docFlag
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> updateOpportunity(String recordId, String docFlag) {
		return DocumentManagementControler.updateOpportunity(recordId, docFlag);
	}

	/**
	 * @description W-005715 : Anka Ganta : 2020-08-18
	 *if any Related party/ TradingAsName / Primary Client CASA status is not 'Approved' or 'Proceed' Stop user to do Risk Profiling
	 * @param oppId
	 * @return Boolean
	 */
	@AuraEnabled
	public static Boolean CheckRelatedPartyCasaStatus(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunities.get(0).AccountId, 1);
		Set<Id> accIdSets = new Set<Id>();
		accIdSets.add(accounts[0].id);

		List<Account> participants = new AccountContactRelationSelector().selectListByAccId(opportunities.get(0).AccountId);
		List<Trading_as_Name__c> tradingAsNameRecords = new TradingAsNamesSelector().selectByAccountId(accIdSets);
		List<String> participantStatuses = new List<String>();
		if (participants != null && participants.size() > 0) {
			for (Account participant : participants) {
				participantStatuses.add(participant.CASA_Screening_Status__pc);
			}
		}
		if (tradingAsNameRecords != null && tradingAsNameRecords.size() > 0) {
			for (Trading_as_Name__c eachTradingName : tradingAsNameRecords) {
				participantStatuses.add(eachTradingName.CASA_Screening_Status__c);
			}
		}
		if (accounts.get(0).CASA_Screening_Status__c != null) {
			participantStatuses.add(accounts.get(0).CASA_Screening_Status__c);
		} else {
			participantStatuses.add(accounts.get(0).CASA_Screening_Status__pc);
		}

		// if Related party status is not 'Approved' or 'Proceed'  Stop user to do Risk Profiling
		Boolean relPartyInvalidStatusFlag = false;
		for (String status : participantStatuses) {
			if (status == 'Matched') {
				relPartyInvalidStatusFlag = true;
				break;
			} else if (status == 'Pending') {
				relPartyInvalidStatusFlag = true;
				break;
			} else if (status == 'Declined') {
				relPartyInvalidStatusFlag = true;
				break;
			} else if (status == 'Cancelled') {
				relPartyInvalidStatusFlag = true;
				break;
			}
		}
		return relPartyInvalidStatusFlag;
	}

	/**
	 * @description W-005661 - Anka Ganta - 2020-09-18
	 * @param Entitytype
	 * @param OppId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getPrimaryClientMandatoryDocuments(String Entitytype, String OppId) {
		return DocumentManagementControler.getPrimaryClientMandatoryDocuments(Entitytype, OppId);
	}

	/**
	* @description participantIds
	* @param primaryAccId 
	* @param relationshipType 
	* @param accountHierarchy 
	* @return List<Id> 
	**/
	private List<Id> participantIds;     
        public static List<Account> getParticipants(Id primaryAccId,String relationshipType,String accountHierarchy){
            List<OnboardingUBOListViewController.ParentAccountWrapper> accountHierarchyWrapper = new List<OnboardingUBOListViewController.ParentAccountWrapper>();
            //String accountHierarchy = OnboardingUBOListViewController.parentAccountWrapper(primaryAccId, false);
            if(!String.isBlank(accountHierarchy)){
				accountHierarchyWrapper = (List<OnboardingUBOListViewController.ParentAccountWrapper>)JSON.deserialize(accountHierarchy, List<OnboardingUBOListViewController.ParentAccountWrapper>.class);
			}
			 List<Id> participantIds = new List<Id>(); 
            List<Account> rpAccounts = new List<Account>();
            for(OnboardingUBOListViewController.ParentAccountWrapper accWrapper : accountHierarchyWrapper){
                 participantIds.add(accWrapper.recordId);
                if(accWrapper.Accwrplist != null && accWrapper.Accwrplist.size() > 0){
                    participantIds = getParticipantsData(accWrapper.Accwrplist,participantIds,relationshipType);
                }
            }
            Set<Id> participantIdsSet = new Set<Id>();
            participantIdsSet.addAll(participantIds);
            if(relationshipType == 'AccountContact'){
                
                List<AccountContactRelation> acrList = new AccountContactRelationSelector().selectbyIdSet(participantIdsSet);
                List<AccountContactRelation> acrListRelatedParty = new AccountContactRelationSelector().selectByRelatedPartySection(primaryAccId);
                acrList.addAll(acrListRelatedParty);
                Set<Id> relatedPartyIdSet = new Set<Id>();
                for(AccountContactRelation acr : acrList){
                    if(acr.Roles != 'Contact Person') {
                        relatedPartyIdSet.add(acr.ContactId);
                    }
                }
                rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetIds(relatedPartyIdSet);
            }else if(relationshipType == 'AccountAccount'){
                List<FinServ__AccountAccountRelation__c> accAccList = new AccountAccountRelationSelector().selectbyIdSet(participantIdsSet);
                Set<Id> relatedPartAccIdSet = new Set<Id>();
                for(FinServ__AccountAccountRelation__c eachAccAcc : accAccList) {
                    relatedPartAccIdSet.add(eachAccAcc.FinServ__RelatedAccount__c);
                }
                rpAccounts = new AccountsSelector().selectCasaBusinessFieldsBySetId(relatedPartAccIdSet);
            }
            return rpAccounts;
        }        
        
        /**
        * @description getParticipantsData
        * @param entityWrapperList 
        * @param participantIds 
        * @param relationshipType 
        * @return List<Id> 
        **/
        public static List<Id> getParticipantsData(List<OnboardingUBOListViewController.AccountWrapper> entityWrapperList, List<Id> participantIds,String relationshipType){
            
            for(OnboardingUBOListViewController.AccountWrapper eachWrapper : entityWrapperList) {
                
                String relationshipTypeEntity = eachWrapper.accType;               
                if(relationshipTypeEntity == 'AccountContact') {
                    
                    if(eachWrapper.UBO == 'Yes') {
                          participantIds.add(eachWrapper.recordId);
                    }
                    
                } else if (relationshipTypeEntity == 'AccountAccount') {
                    participantIds.add(eachWrapper.recordId);
                }
                if(eachWrapper.childwrplist != null && eachWrapper.childwrplist.size() > 0) {
                    participantIds = getParticipantsData(eachWrapper.childwrplist,participantIds,relationshipType);
                }
                
            }
            
            return participantIds;
        }  
		/**
     * @description Method that gets the related party accounts from an account
     *
     * @param oppId - opportunity Id  
     * @return List of Accounts - specific accounts related to the primary account
     */
    @AuraEnabled
    public static List<Account> getPartcicpantAccount(Id oppId) { 
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
        
        Set<Id> relPartyPrimaryEntityIdSet = new Set<Id>();
        for(Controlling_Interest__c contrInt:[SELECT Id, Name, Contact__c,Contact__r.Name, Controlling_Interest__c, Other_Primary_Entity_Id__c, Parent_Account__c, Primary_Entity__c, Related_Account__c, UBO__c FROM Controlling_Interest__c where Primary_Entity__c =:opportunities.get(0).AccountId AND UBO__c = 'Yes']){
            relPartyPrimaryEntityIdSet.add(contrInt.Other_Primary_Entity_Id__c);
        }
        List<AccountContactRelation> acrList = [SELECT AccountId,Roles, Account.Country_of_Citizenship__c,Account.Country_of_Residence__c,Account.Country_of_Residence__pc,Account.ID_Number__pc,ContactId, account.CASA_Reference_Number__c, Account.CASA_Screening_Date__c, Account.CASA_Screening_Status__c,Account.CASA_Reference_Number__pc, Account.CASA_Screening_Date__pc, Account.CASA_Screening_Status__pc,Account.RecordType.Name,Primary_Entity_Id__c,UBO__c,Account.PEP_Status__pc FROM AccountContactRelation WHERE (Primary_Entity_Id__c IN:relPartyPrimaryEntityIdSet) OR (AccountId =: opportunities.get(0).AccountId) ];//AccountId
        
        Set<Id> relatedPartIdSet = new Set<Id>();
        for(AccountContactRelation acr : acrList){
            if(acr.Roles != 'Contact Person') {
                relatedPartIdSet.add(acr.ContactId);
            }
           
        }
        
        List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetIds(relatedPartIdSet);
    
        return rpAccounts;
  
    
}
}