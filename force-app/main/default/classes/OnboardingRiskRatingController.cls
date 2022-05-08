/**
 * @description Extension Controller for OnboardingRiskRating Component
 *
 * @author  Tracy de Bruin : Cloudsmiths
 * @version v1.0
 * @since   2020-09-16
 *
 */

public class OnboardingRiskRatingController {
	/**
	 * @description Get Opportunity Id
	 * @param recordId
	 * @return List<Opportunity>
	 */
	@AuraEnabled
	public static List<Opportunity> getOppId(Id recordId) {
		List<Opportunity> oppId = [SELECT Id FROM Opportunity WHERE AccountId = :recordId LIMIT 1];
		return oppId;
	}

	/**
	 * @description Save Risk Info on Opportunity
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String saveRikInfo(String oppId) {
		//try{
		String RiskRating;
		GetRiskProfileClient_Resp_IB_v2 respBean;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);
		OpportunityLineItemsSelector oppLineIteminstnce = new OpportunityLineItemsSelector();
		List<OpportunityLineItem> oppLineItem = oppLineIteminstnce.selectByOpportunityId(oppId);

		if (accounts[0] != null && oppLineItem[0] != null) {
			if (accounts[0].Risk_Status__c != 'Valid') {
				//System.debug('UserInfo.getUserId()=====>' + UserInfo.getUserId());

				// Changed method attributes and changed single opportunityline item to list by Masechaba Maseli INC2457268
				respBean = GetRiskProfileClient_IH_v2.getRiskProfileClient(accounts[0], UserInfo.getUserId(), oppLineItem);

				//System.debug('===RATING=====>' + json.serialize(respBean));
				// START W-04045 - Anka Ganta
				Boolean isHighRiskIndustry = false;
				Boolean ishighRiskCaseExist = false;
				Boolean ishighRiskWorkItem = false;
				if (
					accounts[0].The_Client_is_involved_in_High_Risk_Indu__c != null &&
					accounts[0].The_Client_is_involved_in_High_Risk_Indu__c != 'NOT INVOLVED'
				) {
					isHighRiskIndustry = true;
				}

				if (accounts[0].Work_Item_Classification__c != null && accounts[0].Work_Item_Classification__c != 'None') {
					ishighRiskWorkItem = true;
				}
				// check high risk case with Open status and not Resolved
				if (opportunities.get(0).Case__r.RecordType.Name == Label.Onboarding && opportunities.get(0).Case__r.Status != Label.Resolved) {
					ishighRiskCaseExist = true;
				}
				if (accounts[0].Work_Item_Classification__c != null && accounts[0].Work_Item_Classification__c != 'None') {
					isHighRiskWorkItem = true;
				}
				if (respBean != null) {
					RiskRating = respBean.WQriskProfileClientV7Response.riskRating;
					Case riskCaseRecord;
					if (
						(opportunities.get(0).PEP_Status__c == 'Sensitive / Standard' || opportunities.get(0).PEP_Status__c == 'Heightened PEP') &&
						ishighRiskCaseExist == false
					) {
						//Create High Risk / PEP Case / Very High / HighRiskIndustry
						riskCaseRecord = createHighRiskCase(accounts.get(0).Id, Label.Client_Onboarding_High_Risk_Service_Group_Name, Label.Onboarding, 'PEP ');
					} else if (isHighRiskIndustry == true && ishighRiskCaseExist == false) {
						//Create High Risk / PEP Case / Very High / HighRiskIndustry
						riskCaseRecord = createHighRiskCase(
							accounts.get(0).Id,
							Label.Client_Onboarding_High_Risk_Service_Group_Name,
							Label.Onboarding,
							'High Risk Industries'
						);
					} else if ((RiskRating == 'High' || RiskRating == 'Very High') && ishighRiskCaseExist == false) {
						//Create High Risk / PEP Case / Very High / HighRiskIndustry
						riskCaseRecord = createHighRiskCase(
							accounts.get(0).Id,
							Label.Client_Onboarding_High_Risk_Service_Group_Name,
							Label.Onboarding,
							'High Risk'
						);
					} else if (ishighRiskWorkItem == true && ishighRiskCaseExist == false) {
						//Create High Risk / PEP Case / Very High / HighRiskIndustry
						riskCaseRecord = createHighRiskCase(
							accounts.get(0).Id,
							Label.Client_Onboarding_High_Risk_Service_Group_Name,
							Label.Onboarding,
							accounts[0].Work_Item_Classification__c
						);
					}

					//TdB - Update Opportiity with Casa Primary Results
					if (opportunities != null && opportunities.size() > 0) {
						try {
							opportunities[0].Risk_Rating_Date__c = System.now();
							opportunities[0].Risk_Rating__c = RiskRating;

							if (RiskRating != null) {
								opportunities[0].Risk_Status__c = 'Valid';
                                
                                Account updateAcc = new Account();
								updateAcc.id = accounts[0].Id;
								updateAcc.Risk_Status__c = 'Valid';
                                update updateAcc;
							}
                            
							if (riskCaseRecord != null) {
								opportunities[0].case__c = riskCaseRecord.Id;
							}
							update opportunities[0];
							
						} catch (Exception e) {
                            //system.debug('Exception: ' + e.getMessage() + 'Line: ' + e.getLineNumber());
							throw new AuraHandledException(e.getMessage());
						}
					}
				}
			}
		}
		return json.serialize(respBean);

		/*}catch(Exception e){
        return 'FAILURE';
        }*/
	}

	/**
	 * @description Save Risk Info on Opportunity for SPM
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String saveRikInfoforSPM(String oppId) {
		//try{
		String RiskRating;
		GetRiskProfileClient_Resp_IB_v2 respBean;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

		if (accounts[0] != null && opportunities[0] != null) {
			//System.debug('UserInfo.getUserId()=====>' + UserInfo.getUserId());

			respBean = GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(accounts[0], UserInfo.getUserId(), opportunities[0]);

			//System.debug('===RATING=====>' + json.serialize(respBean));

			if (respBean != null) {
				RiskRating = respBean.WQriskProfileClientV7Response.riskRating;
				//Haritha - Update Opportiity with Casa Primary Results for SPM
				if (opportunities != null && opportunities.size() > 0) {
					try {
						opportunities[0].Risk_Rating_Date__c = System.now();
						opportunities[0].Risk_Rating__c = RiskRating;
						opportunities[0].StageName = 'Accept Proposal';
						update opportunities[0];
					} catch (Exception e) {
						throw new AuraHandledException(e.getMessage());
					}
				}
			}
		}
		return json.serialize(respBean);
	}

	/**
	 * @description Method that gets a an account
	 *
	 * @param oppId - opportunity Id
	 * @return Account
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
	 * @description Method that gets the related party accounts from an account
	 *
	 * @param oppId
	 * @return List<Account>
	 */
	@AuraEnabled
	public static List<Account> getPartcicpantAccountData(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

		List<AccountContactRelation> acrList = [
			SELECT
				AccountId,
				Account.Country_of_Citizenship__c,
				Account.Country_of_Residence__c,
				Account.Country_of_Residence__pc,
				Account.ID_Number__pc,
				ContactId,
				account.CASA_Reference_Number__c,
				Account.CASA_Screening_Date__c,
				Account.CASA_Screening_Status__c,
				Account.CASA_Reference_Number__pc,
				Account.CASA_Screening_Date__pc,
				Account.CASA_Screening_Status__pc,
				Account.RecordType.Name,
				Primary_Entity_Id__c,
				UBO__c,
				Account.PEP_Status__pc
			FROM AccountContactRelation
			WHERE (Primary_Entity_Id__c = :opportunities.get(0).AccountId AND UBO__c = 'Yes') OR AccountId = :opportunities.get(0).AccountId
		]; //AccountId
		//System.debug('** acrList: ' + acrList.size());

		Set<Id> relatedPartIdSet = new Set<Id>();
		for (AccountContactRelation acr : acrList) {
			relatedPartIdSet.add(acr.ContactId);
		}

		List<Account> rpAccounts = new AccountsSelector().selectCasaFieldsByPersonContactSetId(relatedPartIdSet);
		//System.debug('** rpAccounts: ' + rpAccounts.size());

		return rpAccounts;
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
		//System.debug('record type' + accounts[0].RecordType.Name);
		return accounts[0].RecordType.Name;
	}

	/**
	 * @description Create High Risk Case
	 * @param accountId
	 * @param serviceGroupName
	 * @param caseRecordTypeDeveloperName
	 * @param subject
	 * @return Case
	 */
	@AuraEnabled
	public static Case createHighRiskCase(String accountId, String serviceGroupName, String caseRecordTypeDeveloperName, String subject) {
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

					riskCase.Subject = subject;
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

		//System.debug('opportunities : ' + opportunities);

		if (opportunities != null && opportunities.size() > 0) {
			return opportunities[0];
		} else {
			return null;
		}
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
	 * @description Get Documents by Opportunity Id
	 * @param opportunityId
	 * @return List<String>
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
	 * @description W-005270 By Himani by Thulani W-005273
	 * Method that gets a list of documents uploaded
	 * @param opportunityId
	 * @return List<string>
	 */
	@AuraEnabled
	public static List<string> getDocs(Id opportunityId) {
		return DocumentManagementControler.getDocs(opportunityId);
	}

	/**
	 * @description Get Mandatory Documents
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
	 * @description WUpdate by Thulani  W-005273
	 * Method verifies mandatory documents for related parties
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
				//System.debug('participant Id++' + participant.Id);
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

		//System.debug('participantStatuses++' + participantStatuses);
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
		//System.debug('relPartyInvalidStatusFlag++' + relPartyInvalidStatusFlag);
		return relPartyInvalidStatusFlag;
	}

	/**
	 * @description Risk info for CAF
	 * @param oppId
	 * @return String
	 */
	@AuraEnabled
	public static String saveCAFRikInfo(String oppId) {
		//try{
		String RiskRating;
		GetRiskProfileClient_Resp_IB_v2 respBean;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		List<Account> accounts = new AccountsSelector().selectCasaFieldsByIds(opportunities.get(0).AccountId, 1);

		if (accounts[0] != null) {
			//System.debug('UserInfo.getUserId()=====>' + UserInfo.getUserId());

			respBean = GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(accounts[0], UserInfo.getUserId());

			//System.debug('===RATING=====>' + json.serialize(respBean));
			// START W-04045 - Anka Ganta
			Boolean isHighRiskIndustry = false;
			if (accounts[0].The_Client_is_involved_in_High_Risk_Indu__c != null && accounts[0].The_Client_is_involved_in_High_Risk_Indu__c != 'NOT INVOLVED') {
				isHighRiskIndustry = true;
			}
			//System.debug('isHighRiskIndustry+' + isHighRiskIndustry);
			Boolean ishighRiskCaseExist = false;
			// check high risk case with Open status and not Resolved
			//if((theCase.RecordType.Name == Label.Onboarding && theCase.Status != 'Close') || opportunities.get(0).Case__r.Status != 'Close'){
			if (opportunities.get(0).Case__r.RecordType.Name == Label.Onboarding && opportunities.get(0).Case__r.Status != Label.Resolved) {
				ishighRiskCaseExist = true;
			}
			//System.debug('ishighRiskCaseExist+' + ishighRiskCaseExist);
			if (respBean != null) {
				RiskRating = respBean.WQriskProfileClientV7Response.riskRating;
				Case riskCaseRecord;
				if (
					(RiskRating == 'High' ||
					RiskRating == 'Very High' ||
					(opportunities.get(0).PEP_Status__c == 'Sensitive / Standard' ||
					opportunities.get(0).PEP_Status__c == 'Heightened PEP') ||
					isHighRiskIndustry == true) && ishighRiskCaseExist == false
				) {
					//Create High Risk / PEP Case / Very High / HighRiskIndustry
					riskCaseRecord = createHighRiskCase(
						accounts.get(0).Id,
						Label.Client_Onboarding_High_Risk_Service_Group_Name,
						Label.Onboarding,
						'High Risk / Pep Client Onboarding'
					);
				}

				//TdB - Update Opportiity with Casa Primary Results
				if (opportunities != null && opportunities.size() > 0) {
					try {
						opportunities[0].Risk_Rating_Date__c = System.now();
						opportunities[0].Risk_Rating__c = RiskRating;
						if (riskCaseRecord != null) {
							opportunities[0].case__c = riskCaseRecord.Id;
						}
						update opportunities[0];
					} catch (Exception e) {
						throw new AuraHandledException(e.getMessage());
					}
				}
			}
		}
		return json.serialize(respBean);

		/*}catch(Exception e){
        return 'FAILURE';
        }*/
	}

	//Method to call the Existing createHighRiskCase Method US: W-013710 by Mohammed
    /**
	 * @description Create a EDD Case
	 * @param oppId
	 * @param Subject
	 */
	@AuraEnabled
    public static void createEDDCaseReason(String oppId, String Subject){
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        Case riskCaseRecord;
        riskCaseRecord = createHighRiskCase(opportunities.get(0).AccountId, Label.Client_Onboarding_High_Risk_Service_Group_Name, Label.Onboarding, Subject);
        if(opportunities != null && opportunities.size() > 0) {
            try {
                if(riskCaseRecord != null){
                    opportunities[0].case__c = riskCaseRecord.Id;
                }   
                update opportunities[0];
                
            }catch(Exception e){
                throw new AuraHandledException( e.getMessage());
            }
        }
    }
    //w-013710 End
}