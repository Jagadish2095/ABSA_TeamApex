/**
 * @description Apex/Integration Handler class for CASAPrimaryClientScreening service
 * Class Name : CASAPrimaryClientScreening_IH_v3
 * Test Class Name: CASAPrimaryClientScreening_IH_v3_Test
 * @author  Anka Ganta : Absa 
 * @since   2019-11-24
 *
 **/

public class CASAPrimaryClientScreening_IH_v3 {

	/**
	 * @description  Casa Screening for Primary
	 * @param accountP
	 * @param relatedPartyListP
	 * @param relatedTradingAsNames
	 * @param relatedPartyBusinessListP
	 * @return CASAPrimaryClientScreening_Resp_IB_v3
	 */
	public static CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningBusinessAcc(
		Account accountP,
		List<Account> relatedPartyListP,
		List<Trading_as_Name__c> relatedTradingAsNames,
		List<Account> relatedPartyBusinessListP
	) {
		cls_jointScreening jointClientSreening = new cls_jointScreening();
		CASAPrimaryClientScreening_Resp_IB_v3 casaPrimaryClientScreeningResponse;
		Sys_Log_Integration__c log;
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		List<String> errorList = new List<String>();
		List<CASAScreenRelatedParty_Resp_IB_v3> relatedPartyScreeningList;
		List<CASAScreenRelatedParty_Resp_IB_v3> relatedTradingNamesScreeningList;
		String primaryClientRef;
		List<Account> updateAccList = new List<Account>();
		List<Trading_as_Name__c> updateTradingAsNameList = new List<Trading_as_Name__c>();

		try {
			//Query Objects
			Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.API_MANAGER,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2
			);
			Integration_API__c integrationCasaRelatedPartySettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_SCREEN_RELATED_PARTY);  
			if (integrationSettings != null && accountP != null) {
				//W-005355 : Anka Ganta : 2020-07-09
				String countryOfIncorporation = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
					StringConstants.ECASA_STRING,
					StringConstants.FIELD_COUNTRY_STRING,
					accountP.Country_of_Incorporation__c,
					StringConstants.OUTBOUND_RECORD_TYPE
				);
				//W-005355 : Anka Ganta : 2020-07-09
				String idTypeTranslated;
				if (accountP.ID_Type__c != null) {
					idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						StringConstants.FIELD_IDENTITY_TYPE_STRING,
						accountP.ID_Type__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
				} else {
					idTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						StringConstants.FIELD_IDENTITY_TYPE_STRING,
						accountP.ID_Type__pc,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
				}

				String clientTypeGrpTranslated;
				if (accountP.Client_Group__c == 'Non Individual') {
					clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						StringConstants.CLIENT_TYPE_GROUP,
						accountP.Client_Group__c.replace('Non Individual', 'Non-Individual'),
						StringConstants.OUTBOUND_RECORD_TYPE
					);
				} else {
					clientTypeGrpTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
						StringConstants.ECASA_STRING,
						StringConstants.CLIENT_TYPE_GROUP,
						accountP.Client_Group__c,
						StringConstants.OUTBOUND_RECORD_TYPE
					);
				}

				CASAPrimaryClientScreening_Req_IB_v3 casaPrimaryClientScreeningRequest;
				if (countryOfIncorporation != null) {
					casaPrimaryClientScreeningRequest = CASAPrimaryClientScreening_IU_v3.mapRequestFields(
						accountP,
						countryOfIncorporation,
						clientTypeGrpTranslated,
						idTypeTranslated
					);

					String jsonString = JSON.serialize(casaPrimaryClientScreeningRequest, true);

					HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(
						integrationSettings,
						integrationSettings.Integration_Services__r[0],
						jsonString
					);

					log = SystemLogger.createRequestIntegrationLog(
						request.getBody(),
						StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3,
						StringConstants.SALESFORCE_STRING,
						request.getEndpoint()
					);
					//Send Request
					HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

					if (response.getStatusCode() == 200) {
						//populate log;
						log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
						logList.add(log);
					} else {
						//populate log;
						log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
						logList.add(log);
					}

					if (response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT) {
						casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(
							500,
							StringConstants.STATUS_CODE_500,
							StringConstants.ERROR_MSG_READ_TIMED_OUT
						);
					} else {
						///Map Fields
						response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
						casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapResponseFields(response);
						//Translate response values and return the translated bean
						casaPrimaryClientScreeningResponse = translateToInternalValues(casaPrimaryClientScreeningResponse);

						if (casaPrimaryClientScreeningResponse.refNo != null) {
							primaryClientRef = casaPrimaryClientScreeningResponse.refNo;
						}

						AccountsSelector accSelector = new AccountsSelector();
						List<Account> accList = new List<Account>();
						String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
							StringConstants.ECASA_STRING,
							StringConstants.ECASA_STRING_REF,
							casaPrimaryClientScreeningResponse.casaStatus,
							StringConstants.INBOUND_RECORD_TYPE
						);

						//Business Account
						if (accountP.RecordType.DeveloperName == 'Client' || accountP.RecordType.DeveloperName == 'Prospect' || Test.isRunningTest()) {
							accList = accSelector.selectCasaFieldsJointAccountById(accountP.Id, 1);

							if (accList.size() > 0 && accList[0] != null) {
								accList[0].CASA_Reference_Number__c = primaryClientRef; //casaPrimaryClientScreeningResponse.refNo;

								accList[0].CASA_Screening_Date__c = System.today();
								accList[0].CASA_Screening_Status__c = casaStatusTranslated;
								accList[0].Casa_Status__c = 'Valid';
								accList[0].Valid_Update_Bypass__c = true;//W-12037
								updateAccList.add(accList[0]);
							}
						} else {
							//Individual Account
							accList = accSelector.selectCasaIndividualFieldsById(accountP.Id, 1);

							if (accList[0] != null && accList.size() > 0) {
								accList[0].CASA_Reference_Number__pc = primaryClientRef;
								accList[0].CASA_Screening_Date__pc = System.today();
								accList[0].CASA_Screening_Status__pc = casaStatusTranslated;
								accList[0].Casa_Status__c = 'Valid';
								accList[0].Valid_Update_Bypass__c = true;//W-12037
								updateAccList.add(accList[0]);
							}
						}
					}

					Map<Id, Account> relatedAccoountMap = new Map<Id, Account>();
                 if (relatedPartyListP != null && relatedPartyListP.size() > 0) {
					for (Account accountMap : relatedPartyListP) {
						//List<Account> accList = accSelector.selectRelatedPartyCASAByAccountId(account.Id);
						AccountsSelector acs = new AccountsSelector();

						//relatedAccoountMap.put(accountMap.Id, acs.selectRelatedPartyCASAByAccountId(accountMap.Id)[0]);
						relatedAccoountMap.put(accountMap.Id, accountMap);
					}
                  }
					if (relatedPartyListP != null && relatedPartyListP.size() > 0) {
						Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedPartyMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
						Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedPartyMap2 = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();

						relatedPartyScreeningList = new List<CASAScreenRelatedParty_Resp_IB_v3>();
						CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyRespBean = new CASAScreenRelatedParty_Resp_IB_v3();

						for (Account account : relatedPartyListP) {
							// Start of changes for W-004987 by Masechaba Maseli
							//  List<Account> accList1 = AccountsSelector.selectCasaFieldsByIds(account.Id,1);
							List<String> countryCitizenship = new List<String>(account.Country_of_Citizenship__c.split(';'));

							if (account.Casa_Status__c != 'Valid') {
								if (countryCitizenship.size() == 2 && countryCitizenship != null) {
									account.Nationality__pc = countryCitizenship[0];

								   relatedPartyMap = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(account, primaryClientRef, integrationCasaRelatedPartySettings);
									List<CASAScreenRelatedParty_Resp_IB_v3> beanList = new List<CASAScreenRelatedParty_Resp_IB_v3>(relatedPartyMap.keySet());
									relatedPartyScreeningList.add(beanList[0]);
									if (relatedPartyMap.values().size() > 0) {
										logList.add(relatedPartyMap.values()[0]);
									}

									if (beanList[0].msgNo == '0') {
										relatedAccoountMap.get(account.Id).CASA_Reference_Number__pc = beanList[0].refNo;
										relatedAccoountMap.get(account.Id).CASA_Screening_Date__pc = System.today();
										relatedAccoountMap.get(account.Id).Valid_Update_Bypass__c = true;//W-12037
										String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
											StringConstants.ECASA_STRING,
											StringConstants.ECASA_STRING_REF,
											beanList[0].respStatus,
											StringConstants.INBOUND_RECORD_TYPE
										);
										relatedAccoountMap.get(account.Id).CASA_Screening_Status__pc = casaStatusTranslated;
										relatedAccoountMap.get(account.Id).Casa_Status__c = 'Valid';
									}

									account.Nationality__pc = countryCitizenship[1];
								   relatedPartyMap2 = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(account, primaryClientRef, integrationCasaRelatedPartySettings);
									List<CASAScreenRelatedParty_Resp_IB_v3> beanList2 = new List<CASAScreenRelatedParty_Resp_IB_v3>(relatedPartyMap2.keySet());
									relatedPartyScreeningList.add(beanList2[0]);
									if (relatedPartyMap2.values().size() > 0) {
										logList.add(relatedPartyMap2.values()[0]);
									}

									 if (beanList2[0].msgNo == '0' || test.isRunningTest()) {
										relatedAccoountMap.get(account.Id).CASA_Reference_Number2__c = beanList2[0].refNo;
										relatedAccoountMap.get(account.Id).CASA_Screening_Date2__c = System.today();
										relatedAccoountMap.get(account.Id).Valid_Update_Bypass__c = true;//W-12037
										String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
											StringConstants.ECASA_STRING,
											StringConstants.ECASA_STRING_REF,
											beanList2[0].respStatus,
											StringConstants.INBOUND_RECORD_TYPE
										);
										relatedAccoountMap.get(account.Id).CASA_Screening_Status_2__c = casaStatusTranslated;
									}

									updateAccList.add(relatedAccoountMap.get(account.Id));
								}

								// End of changes for W-004987 by Masechaba Maseli

								if (countryCitizenship.size() == 1 && countryCitizenship != null) {
									relatedPartyMap = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(account, primaryClientRef, integrationCasaRelatedPartySettings);
									List<CASAScreenRelatedParty_Resp_IB_v3> beanList = new List<CASAScreenRelatedParty_Resp_IB_v3>(relatedPartyMap.keySet());
									relatedPartyScreeningList.add(beanList[0]);

									if (relatedPartyMap.values().size() > 0) {
										logList.add(relatedPartyMap.values()[0]);
									}

									AccountsSelector accSelector = new AccountsSelector();
									//List<Account> accList = accSelector.selectCasaFieldsJointAccountById(account.Id,1);
									// List<Account> accList = [SELECT ID,ID_Type__c,CASA_Reference_Number__c,CASA_Screening_Date__c,CASA_Screening_Status__c,Registration_Number__c,CASA_Reference_Number__pc,CASA_Screening_Date__pc,CASA_Screening_Status__pc FROM Account Where Id=:account.Id limit 1];
									// if(accList.size()>0 &&  accList[0] != null){
									if (beanList[0].msgNo == '0') {
										//TdB - Individual field mappings for Casa
										relatedAccoountMap.get(account.Id).CASA_Reference_Number__pc = beanList[0].refNo;
										relatedAccoountMap.get(account.Id).CASA_Screening_Date__pc = System.today();
										relatedAccoountMap.get(account.Id).Valid_Update_Bypass__c = true;//W-12037
										String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
											StringConstants.ECASA_STRING,
											StringConstants.ECASA_STRING_REF,
											beanList[0].respStatus,
											StringConstants.INBOUND_RECORD_TYPE
										);
										relatedAccoountMap.get(account.Id).CASA_Screening_Status__pc = casaStatusTranslated;
										relatedAccoountMap.get(account.Id).Casa_Status__c = 'Valid';
										relatedAccoountMap.get(account.Id).Valid_Update_Bypass__c = true;//W-12037
										updateAccList.add(relatedAccoountMap.get(account.Id));

										// }
									}
								}
							}
						} //end of relatedPartyListP for loop//end of relatedPartyListP for loop
					} //end of relatedPartyListP size if

					//TdB - Screen Business Entities on Relationship Section
                    Map<Id, Account> relatedAccAccoountMap = new Map<Id, Account>();
                    for (Account accountMap : relatedPartyBusinessListP) {
						//List<Account> accList = accSelector.selectRelatedPartyCASAByAccountId(account.Id);
						AccountsSelector acs = new AccountsSelector();
						relatedAccAccoountMap.put(accountMap.Id,accountMap);
					}
                    if (relatedPartyBusinessListP != null && relatedPartyBusinessListP.size() > 0) {
						Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedPartyMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
						Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedPartyMap2 = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();

						relatedPartyScreeningList = new List<CASAScreenRelatedParty_Resp_IB_v3>();
						CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyRespBean = new CASAScreenRelatedParty_Resp_IB_v3();

						for (Account account : relatedPartyBusinessListP) {
							if (account.Casa_Status__c != 'Valid') {
								   relatedPartyMap = CASAScreenRelatedParty_IH_v3.screenRelatedPartyMapBusinessAcc(account, primaryClientRef, integrationCasaRelatedPartySettings);
								   List<CASAScreenRelatedParty_Resp_IB_v3> beanList = new List<CASAScreenRelatedParty_Resp_IB_v3>(relatedPartyMap.keySet());
									relatedPartyScreeningList.add(beanList[0]);
									if (relatedPartyMap.values().size() > 0) {
										logList.add(relatedPartyMap.values()[0]);
									}

									if (beanList[0].msgNo == '0') {
										relatedAccAccoountMap.get(account.Id).CASA_Reference_Number__c = beanList[0].refNo;
										relatedAccAccoountMap.get(account.Id).CASA_Screening_Date__c = System.today();
										String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
											StringConstants.ECASA_STRING,
											StringConstants.ECASA_STRING_REF,
											beanList[0].respStatus,
											StringConstants.INBOUND_RECORD_TYPE
										);
										relatedAccAccoountMap.get(account.Id).CASA_Screening_Status__c = casaStatusTranslated;
										relatedAccAccoountMap.get(account.Id).Casa_Status__c = 'Valid';
									}
									updateAccList.add(relatedAccAccoountMap.get(account.Id));
								
							}
						} 
					} 

					//TdB - Screen Trading as Names
					if (relatedTradingAsNames != null && relatedTradingAsNames.size() > 0) {
						Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> relatedTradingNamesMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
						relatedTradingNamesScreeningList = new List<CASAScreenRelatedParty_Resp_IB_v3>();
						CASAScreenRelatedParty_Resp_IB_v3 screenTradingNamesRespBean = new CASAScreenRelatedParty_Resp_IB_v3();

						for (Trading_as_Name__c eachTradingName : relatedTradingAsNames) {
							if (eachTradingName.Casa_Status__c != 'Valid') {
								relatedTradingNamesMap = CASAScreenRelatedParty_IH_v3.screenTradingAsNamesMapBusinessAcc(eachTradingName, primaryClientRef, integrationCasaRelatedPartySettings);
								List<CASAScreenRelatedParty_Resp_IB_v3> beanList = new List<CASAScreenRelatedParty_Resp_IB_v3>(relatedTradingNamesMap.keySet());
								if (!beanList.isEmpty() && beanList[0] != null && beanList.size() > 0) {
									relatedTradingNamesScreeningList.add(beanList[0]);
								}

								if (relatedTradingNamesMap.values().size() > 0) {
									logList.add(relatedTradingNamesMap.values()[0]);
								}

								eachTradingName.CASA_Reference_Number__c = beanList[0].refNo;
								eachTradingName.CASA_Screening_Date__c = System.today();
								String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
									StringConstants.ECASA_STRING,
									StringConstants.ECASA_STRING_REF,
									beanList[0].respStatus,
									StringConstants.INBOUND_RECORD_TYPE
								);
								eachTradingName.CASA_Screening_Status__c = casaStatusTranslated;
								eachTradingName.Casa_Status__c = 'Valid';
								updateTradingAsNameList.add(eachTradingName);
							}
						}
						update updateTradingAsNameList;
					}

					update updateAccList;
				} else {
					String message = '';
					if (countryOfIncorporation == null) {
						//W-005355 : Anka Ganta : 2020-07-09
						message +=
							StringConstants.ERROR_MSG_UNABLE_TO_MAP_COUNTRY_INCORPORATION +
							accountP.Country_of_Incorporation__c +
							' for Account: ' +
							accountP.Name +
							'. ';
						//W-005355 : Anka Ganta : 2020-07-09
					}

					if (clientTypeGrpTranslated == null) {
						message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_CLIENT_GROUP + accountP.Client_Group__c + ' for Account: ' + accountP.Name + '. ';
					}
					log = SystemLogger.createInternalIntegrationLog(
						StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3,
						StringConstants.ECASA_STRING,
						500,
						StringConstants.INTEGRATION_STATUS_FAILED,
						message
					);
					logList.add(log);
					casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(
						500,
						StringConstants.INTEGRATION_STATUS_FAILED,
						message
					);
				} //Translation end
			} else {
				//Map Bad Response and log
				String message = '';
				if (integrationSettings == null) {
					message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND;
				}

				if (accountP == null) {
					message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT;
				}

				log = SystemLogger.createInternalIntegrationLog(
					StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3,
					StringConstants.ECASA_STRING,
					500,
					StringConstants.INTEGRATION_STATUS_FAILED,
					message
				);
				logList.add(log);
				casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
			}
		} catch (Exception e) {
			String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_CASA_PRIMARY_CLIENT_SCREENING_V3,
				StringConstants.ECASA_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				description
			);
			logList.add(log);
			casaPrimaryClientScreeningResponse = CASAPrimaryClientScreening_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
		}

		if (logList.size() > 0) {
			insert logList;
		}

		return casaPrimaryClientScreeningResponse;
	}

	/**
	 * @description  Translations for Casa Screening
	 * @param screeningRepBeanP
	 * @return CASAPrimaryClientScreening_Resp_IB_v3
	 */
	public static CASAPrimaryClientScreening_Resp_IB_v3 translateToInternalValues(CASAPrimaryClientScreening_Resp_IB_v3 screeningRepBeanP) {
		String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
			StringConstants.ECASA_STRING,
			StringConstants.ECASA_STRING_REF,
			screeningRepBeanP.casaStatus,
			StringConstants.INBOUND_RECORD_TYPE
		);

		if (casaStatusTranslated != null) {
			screeningRepBeanP.casaStatus = casaStatusTranslated;
		}

		return screeningRepBeanP;
	}

	/**
	 * @description  Joint Screening class
	 */
	public class cls_jointScreening {
		public CASAPrimaryClientScreening_Resp_IB_v3 primaryScreening;
		public CASAScreenRelatedParty_Resp_IB_v1[] relatedPartyScreening;
	}
}