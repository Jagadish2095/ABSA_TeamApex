/**
 * @description Apex class for PowerCurve submission, it may get invoked FROM multiple cmp
 * @author  Saurabh : Absa
 * @version v1.0
 * @since   2020-09-29
 * @UserStory W-005792
 */
public class PowerCurveController {
	public static Map<String,String> translationMap;

	/**
	 * @description method to check if client is a sole trader
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @return Boolean
	**/
    @AuraEnabled
	public static Boolean isSoleTraderAccount(Id oppId) {
		Boolean forceSoleTrader = false;
		Opportunity opp = [SELECT Id,Is_Spouse_Captured__c,Spouse_Account_Id__c, AccountId FROM Opportunity WHERE Id = :oppId];//new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0).AccountId;
        Account acc = [SELECT Id, RecordType.Name, Client_Type__c,Marital_Contract_Type__pc FROM Account WHERE Id = :opp.AccountId];

		if (acc.Client_Type__c.equalsIgnoreCase('Sole Trader') && (acc.RecordType.Name.equalsIgnoreCase('Individual Client') || acc.RecordType.Name.equalsIgnoreCase('Individual Prospect') )) {
            String contractType = acc.Marital_Contract_Type__pc;
            if(contractType != null){
                if((opp.Spouse_Account_Id__c == null) && (contractType == 'Community of Property' || contractType == 'In Community of Property' || contractType == 'In Community Of Property') ){

                    forceSoleTrader = true;
                }
            }
        }
		return forceSoleTrader;
	}

	/**
	 * @description  method to get financial response app scoring from PCO
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @return List<Map<String, String>>
	**/
	@AuraEnabled
	public static List<Map<String,String>> getFinResponseAppScoringEntities(Id oppId) {
        List<Map<String,String>> appScrEntMaps = PowerCurveFinancialsResponseCtrl.getApplicationScoringEntities(oppId);

        return appScrEntMaps;
    }

	/**
	 * @description returning a Map of Field/Section Name and Validation Map for validation Screen
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @return Map<string, Boolean>
	**/
	@AuraEnabled
	public static Map<string, Boolean> getValidationMap(String oppId) {
		List<Validations__c> fieldValidationList = [SELECT Id, Related_to_Object_Record_Id__c, Validation_Value__c, Related_to_Object_Api_Name__c, Name
		                                            FROM Validations__c
		                                            WHERE Related_to_Object_Record_Id__c = :oppId];
		Map<string, Boolean> fieldMap = new Map<string, Boolean>();
		for (Validations__c val : fieldValidationList) {
			fieldMap.put(val.Name, val.Validation_Value__c);
		}
		return fieldMap;
	}

	/**
	 * @description Call this method FROM different Sections to set the values.
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @param sectionName
	 * @param validationValue
	 * @return Validations__c
	**/
	@AuraEnabled
	public static Validations__c setValidationFields(String oppId, String sectionName, Boolean validationValue) {
		Map<string, Boolean> existingValMap = getValidationMap(oppId);
		Boolean isExisting = existingValMap.containsKey(sectionName);
		Validations__c valRecord = new Validations__c();
		valRecord.Name = sectionName;
		valRecord.Related_to_Object_Record_Id__c = oppId;
		valRecord.Validation_Value__c = validationValue;
		valRecord.Related_to_Object_Api_Name__c = 'Opportunity';
		try {
			if (!isExisting)
				//we may put some logic to update the values later
				Insert valRecord;
		}
		Catch (Exception e) {
			throw new AuraHandledException('Validation could not be completed for' + sectionName);
		}
		return valRecord;
	}

	/**
	 * @description methods to gather diff data needed FROM various objects like Triad, exposure
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @return String
	**/
	public static String getStockNumber(String oppId) {
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
		return application?.Stock_Number__c;
	}

	/**
	 * @description method to format DateTime values
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-15
	 * @param dt
	 * @return String
	**/
	public static String getFormattedTime(Datetime dt) {
		String formattedTime = '';
		if (dt.hour() < 10) {
			formattedTime += '0' + dt.hour();
		}
		else {
			formattedTime += '' + dt.hour();
		}

		if (dt.minute() < 10) {
			formattedTime += '0' + dt.minute();
		}
		else {
			formattedTime += '' + dt.minute();
		}

		if (dt.second() < 10) {
			formattedTime += '0' + dt.second();
		}
		else {
			formattedTime += '' + dt.second();
		}

		return formattedTime;
	}

	/**
	 * @description method to submit calls to PCO based on stages
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @param stageId
	 * @param Illustrative_Decision
	 * @return String
	**/
	@AuraEnabled
	public static String pcoStageHandler(String oppId, String stageId, Boolean Illustrative_Decision) {
		String result = '';
		PowerCurveNewApplication_Resp_IB_v1 pcoNewResponseBean = new PowerCurveNewApplication_Resp_IB_v1();
		PowerCurveNewApplication_Req_IB_v1 pcoNewRequestBean = new PowerCurveNewApplication_Req_IB_v1();
		PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean = new PowerCurveUpdateApplication_Req_IB_v1();
		PowerCurveUpdateApplication_Resp_IB_v1 pcoUpdateResponseBean = new PowerCurveUpdateApplication_Resp_IB_v1();
		List<Application_Scoring__c> appScoringList;
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);

		if (stageId == '01') {
			try {
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'1' );
				//for thr first time submission it should be null, while reprocessing we need to add a check to only call PCO2
				if (appScoringList.isEmpty() || appScoringList == null) {
					if (opp.Reprocessing__c == true) {
						PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean2 = new PowerCurveUpdateApplication_Req_IB_v1();
						PowerCurveUpdateApplication_Resp_IB_v1 pcoUpdateResponseBean2 = new PowerCurveUpdateApplication_Resp_IB_v1();

						pcoNewRequestBean = submitToPowerCurve(oppId);
						pcoUpdateRequestBean = PowerCurveUpdateController2.mapPowerCureveUpdateRequest(oppId, pcoNewRequestBean, app.DERPCOUNIQUENUMBER__c, '01');
						pcoUpdateResponseBean = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(pcoUpdateRequestBean);

						pcoUpdateRequestBean2 = PowerCurveUpdateController2.mapPowerCureveUpdateRequest(oppId, pcoNewRequestBean, app.DERPCOUNIQUENUMBER__c, '02');
						pcoUpdateResponseBean2 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(pcoUpdateRequestBean2);

						//PowerCurveUpdateController.mapResponseAppScoringFields(pcoUpdateRequestBean, pcoUpdateResponseBean, app, 1);
						PowerCurveUpdateController.mapResponseAppScoringFields(pcoUpdateRequestBean2, pcoUpdateResponseBean2, app, 2);
						PowerCurveUpdateController.InsertUpdatePCO(pcoUpdateRequestBean, pcoUpdateResponseBean, oppId, app);
                        setValidationFields(oppId, 'Validation01', true);

                        result = 'Success';
					}
					else {
						pcoNewRequestBean = submitToPowerCurve(oppId);
						pcoNewResponseBean = PowerCurveNewApplication_IH_v1.PowerCurveNewApplication(pcoNewRequestBean);

						if (pcoNewResponseBean?.statusCode == 200 && pcoNewResponseBean?.Fault?.faultcode == null) {
							pcoUpdateRequestBean = PowerCurveUpdateController2.mapPowerCureveUpdateRequest(oppId, pcoNewRequestBean, pcoNewResponseBean.Response.ApplicationDV.DERPCOUNIQUENUMBER, '02');
							pcoUpdateResponseBean = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(pcoUpdateRequestBean);

							if (pcoUpdateResponseBean?.statusCode == 200 && pcoUpdateResponseBean?.Fault?.faultcode == null) {
								PowerCurveUpdateController.mapResponseAppScoringFields(pcoUpdateRequestBean, pcoUpdateResponseBean, app, 2);

								//PCO New insertion method
								PowerCurveUpdateController.InsertNewPCO(pcoNewRequestBean, pcoNewResponseBean, oppId, app.Id);
								result = 'Success';
                                setValidationFields(oppId, 'Validation01', true);
							}
							else {
								result = 'Failed Update ' + pcoUpdateResponseBean?.Fault?.faultstring;
							}
						}
						else {
							result = 'Failed New ' + pcoNewResponseBean?.Fault?.faultstring;
						}
					}
				}
				//if block end
                else {
                    result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
                }
            } catch (Exception e) {
				//System.debug('PowerCurve New Request could not be completed: ' + e.getMessage()+' ' + e.getStackTraceString());
				throw new AuraHandledException('PowerCurve New Request could not be completed: ' + e.getMessage()+' ' + e.getStackTraceString());
			}
		}
		else {
			//will handle some amendment logic here later
		
			String prevStage = String.valueOf(Integer.valueOf(stageId)-1);
           
			Application_Scoring__c appScoring = [SELECT Id, Name, Application_Number__c, JSON_Request__c
			                                     FROM Application_Scoring__c
			                                     WHERE Stage__c = :prevStage and Application_Number__c = :app.id
			                                     ORDER BY CreatedDate Desc
			                                     LIMIT 1];
            
			pcoUpdateRequestBean = (PowerCurveUpdateApplication_Req_IB_v1)JSON.deserialize(appScoring.JSON_Request__c, PowerCurveUpdateApplication_Req_IB_v1.class);
			if (!Test.isRunningTest()) {
				pcoUpdateRequestBean.Request.ApplicationDV.APPAPPSTAGEID = stageId;
			}
			if (stageId == '03') {
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'3' );
				//for the first time submission it should be null, while reprocessing we need to add a check to only call PCO3
				if (appScoringList.isEmpty() || appScoringList == null) {
					PowerCurveUpdateApplication_Req_IB_v1 requestbean3 = PowerCurveUpdateController3And5.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, opp, app, 3);
					PowerCurveUpdateApplication_Resp_IB_v1 responseBean3 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean3);

					if (responseBean3?.statusCode == 200 && responseBean3?.Fault?.faultcode == null) {
						PowerCurveUpdateController.mapResponseAppScoringFields(requestbean3, responseBean3, app, 3);
						result = 'Success';
						setValidationFields(oppId, 'Validation03', true);
					}
					else {
						result = 'Failed Update PCO3';
					}
				}
				else{
					result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
				}
			}
			else if (stageId == '04') {
				PowerCurveUpdateApplication_Req_IB_v1 requestbean4;
				PowerCurveUpdateApplication_Resp_IB_v1 responseBean4;
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'4' );
				//for the first time submission it should be null, while reprocessing we need to add a check to only call PCO4
				if (appScoringList.isEmpty() || appScoringList == null) {
					requestbean4 = PowerCurveUpdateController4.mapStage4Fields(pcoUpdateRequestBean, opp);
					responseBean4 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean4);

					if (responseBean4?.statusCode == 200 && responseBean4?.Fault?.faultcode == null) {
						result = 'Success';
						//setValidationFields(oppId, 'Validation04', true);
					}
					else {
						result = 'Failed Update PCO4';
					}

					if (!opp.Illustrative_Decision__c && !LocateCallController.isLocateCallRequired(opp?.Id) && result == 'Success') {
						pcoUpdateRequestBean.Request.ApplicationDV.APPAPPSTAGEID = '05';
						PowerCurveUpdateApplication_Req_IB_v1 requestbean5 = PowerCurveUpdateController3And5.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, opp, app, 5);
						PowerCurveUpdateApplication_Resp_IB_v1 responseBean5 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean5);

						if(responseBean5?.Response?.ApplicationDV != null) {
							if (responseBean5?.statusCode == 200 && responseBean5?.Fault?.faultcode == null) {
								PowerCurveUpdateController.mapResponseAppScoringFields(requestbean5, responseBean5, app, 5);
								result = 'Success';
								NCAResultUpdateCon.getNCAResultsFromService(opp.Id); // Added by diksha for NCA service.
							}
							else {
								result = 'Failed Update PCO5';
							}
						} else {
							result = 'Failed Update PCO5. Please resubmit validation 3 to PowerCurve';
						}

					} else {
						result = 'PCO 4 Successful. PCO 5 not run';
					}
					// saving the call 4 response after PCO 5 logic to avoid Uncommited work Error
					PowerCurveUpdateController.mapResponseAppScoringFields(requestbean4, responseBean4, app, 4);
					//update validations to make call 5 successful w-12734
					setValidationFields(oppId, 'Validation04', true);
				}
				else{
					result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
				}
			}
			else if (stageId == '05') {
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'5' );
				//for the first time submission it should be null, while reprocessing we need to add a check to only call PCO5
				if (appScoringList.isEmpty() || appScoringList == null) {
					PowerCurveUpdateApplication_Req_IB_v1 requestbean5 = PowerCurveUpdateController3And5.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, opp, app, 5);
					PowerCurveUpdateApplication_Resp_IB_v1 responseBean5 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean5);

					if (responseBean5?.statusCode == 200 && responseBean5?.Fault?.faultcode == null) {
						PowerCurveUpdateController.mapResponseAppScoringFields(requestbean5, responseBean5, app, 5);
						result = 'Success';
						NCAResultUpdateCon.getNCAResultsFromService(opp.Id); // Added by diksha for NCA service.
					}
					else {
						result = 'Failed Update PCO5';
					}
				}
				else{
					result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
				}
			}
			else if (stageId == '06') {
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'6' );
				//for the first time submission it should be null, while reprocessing we need to add a check to only call PCO6
				if (appScoringList.isEmpty() || appScoringList == null) {
					PowerCurveUpdateApplication_Req_IB_v1 requestbean6 = PowerCurveUpdateCtrl6.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, oppId, 6);
					PowerCurveUpdateApplication_Resp_IB_v1 responseBean6 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean6);

					if (responseBean6?.statusCode == 200 && responseBean6?.Fault?.faultcode == null) {
						PowerCurveUpdateController.mapResponseAppScoringFields(requestbean6, responseBean6, app, 6);
						result = 'Success';
						setValidationFields(oppId, 'Validation06', true);
					}
					else {
						result = 'Failed Update PCO6';
					}
				}
				else{
					result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
				}
			}
			else if (stageId == '07') {
				appScoringList = new ApplicationScoringSelector().selectByOpportunityId(oppId,'7' );
				//for the first time submission it should be null, while reprocessing we need to add a check to only call PCO7
				if (appScoringList.isEmpty() || appScoringList == null) {
					PowerCurveUpdateApplication_Req_IB_v1 requestbean7 = PowerCurveUpdateController7.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, oppId, 7);
					PowerCurveUpdateApplication_Resp_IB_v1 responseBean7 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean7);

					if (responseBean7?.statusCode == 200 && responseBean7?.Fault?.faultcode == null) {
						PowerCurveUpdateController.mapResponseAppScoringFields(requestbean7, responseBean7, app, 7);
						result = 'Success';
						setValidationFields(oppId, 'Validation07', true);
					}
					else {
						result = 'Failed Update PCO7';
					}
				}
				else{
					result = 'Failed !! Kindly amend the Application for reprocessing or start with new one';
				}
			}
			else if (stageId == '08') {
				PowerCurveUpdateApplication_Req_IB_v1 requestbean8 = PowerCurveUpdateController8.mapPowerCureveUpdateRequest(pcoUpdateRequestBean, oppId, 8);
				PowerCurveUpdateApplication_Resp_IB_v1 responseBean8 = PowerCurveUpdateApplication_IH_v1.PowerCurveUpdateApplication(requestbean8);

				if (responseBean8?.statusCode == 200 && responseBean8?.Fault?.faultcode == null) {
					PowerCurveUpdateController.mapResponseAppScoringFields(requestbean8, responseBean8, app, 8);
					result = 'Success';
				}
				else {
					result = 'Failed Update PCO8';
				}
			}
		}

		return result;
	}

	/**
	 * @description method to get and map Group Exposure details to PCO
	 * @author Gulafsha.Mohammed@absa.africa | 2020-09-29
	 * @param CIFNo
	 * @param appId
	 * @return map<String, String>
	**/
	@AuraEnabled
	public static map<String, String> getExposureDetails(String CIFNo, String appId) {
		Map<String, String> ExposureMap = new Map<String, String>();
		// can we create a map for this instead of calling for each client
		//List<Application_Exposure_Total_Group__c> aetg = new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeClientCode(appId,CIFNo,'Client Total Group Exposure');
		//List<Application_Exposure_Total_Group__c> aetgTotal = new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpType(appId,'Total Group Exposure');
		List<Application_Exposure_Total_Group__c> aetgList = new ApplicationsTotalGroupSelector().getApplicationTotalGroupbyGrpTypeList(appId, new List<String>{'Client Total Group Exposure', 'Total Group Exposure'});

		if (aetgList != null && aetgList.size() > 0) {
			for (Application_Exposure_Total_Group__c aetgrec : aetgList) {
				if (aetgrec.Application_Total_Group__c == 'Client Total Group Exposure' && aetgrec.Client_Code__c == CIFNo) {
					ExposureMap.put('INTAPPOVERALLCONTROLBRANCH', aetgrec.Overall_Control_Branch_Code__c != null ? aetgrec.Overall_Control_Branch_Code__c : '');
					ExposureMap.put('POLICYIND', aetgrec.Exposure_Policy_Indicator__c != null ? aetgrec.Exposure_Policy_Indicator__c : '');
					//ExposureMap.put('APPAPPREQUESTEDFRANCHISORTYPE', aetgrec.Requested_Franchise_Code__c != null ? aetgrec.Requested_Franchise_Code__c : '');
					//ExposureMap.put('APPAPPREQUESTEDFRANCHISEFINANCING', aetgrec.Requested_Franchise_Code__c != null ? 'Y' : 'N');
					//ExposureMap.put('INTAPPEXISTINGFRANCHISORTYPE', aetgrec.Existing_Franchisor_Type_Code__c != null ? aetgrec.Existing_Franchisor_Type_Code__c : '');
					//ExposureMap.put('INTAPPEXISTINGFRANCHISEFINANCING', aetgrec.Existing_Franchisor_Type_Code__c != null ? 'Y' : 'N');
					//ExposureMap.put('INTAPPBUSINESSSUBSEGMENT', aetgrec.Business_Segment__c != null ? aetgrec.Business_Segment__c : '');
					//ExposureMap.put('INTAPPBUSINESSSEGMENT', aetgrec.Business_Sub_Segment__c != null ? aetgrec.Business_Sub_Segment__c : '');

                    ExposureMap.put('INTAPPBUSINESSSEGMENT', aetgrec.Business_Segment__c != null ? aetgrec.Business_Segment__c : '');
					ExposureMap.put('INTAPPBUSINESSSUBSEGMENT', aetgrec.Business_Sub_Segment__c != null ? aetgrec.Business_Sub_Segment__c : '');
				}
				else if (aetgrec.Application_Total_Group__c == 'Total Group Exposure') {
					ExposureMap.put('TOTALGROUPEXPOSURE', aetgrec.TGE__c != null ? String.valueof(aetgrec.TGE__c) : '');
					ExposureMap.put('TGOE', aetgrec.TGOE__c != null ? String.valueof(aetgrec.TGOE__c) : '');
					ExposureMap.put('TGBE', aetgrec.TGBE__c != null ? String.valueof(aetgrec.TGBE__c) : '');
					ExposureMap.put('TGAE', aetgrec.TGAE__c != null ? String.valueof(aetgrec.TGAE__c) : '');
				}
			}
		}
		return ExposureMap;
	}

	/**
	 * @description method to Term Loan Amount Details
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-09-29
	 * @param appId
	 * @return String
	**/
	@AuraEnabled
	public static String getTermloanAmtDetails(String appId) {
		List<Application_Financial_Account__c> appFinList = new ApplicationFinancialAccountSelector().selectByApplicationIdEBR(appId, 'External Term Loan');
		Decimal balance = 0;
		for (Application_Financial_Account__c output : appFinList) {
			balance += output.Outstanding_Balance__c != null ? output.Outstanding_Balance__c : 0;
		}
		return String.valueof(balance).substringBefore('.');
	}

	/**
	 * @description method to submit calls to PCO based on stages
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param oppId
	 * @return PowerCurveNewApplication_Req_IB_v1
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1 submitToPowerCurve(String oppId) {
		//will start mapping again post existing Product Verification
		//Mapping By Gulafsha
		User u = new UsersSelector().selectById(userinfo.getUserId());
		Integer keyprincipal = 0;
		Integer coreprincipal = 0;
		Integer nonresparticipants = 0;
		Set<id> accConRelIds = new Set<Id>();
		List<opportunity> opplist = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		List<opportunity> opplistnew = [SELECT id, External_Call_Outcome__c, Illustrative_Decision__c, Declaration_Status__c, Opportunity_Number__c, OwnerId, AccountId, CIF_Number__c,
                                        Selected_Email__c, SyncedQuoteId, Email_Status__c, WBIF_Policy_Number__c, Site__c, Adviser_Employee__c,
                                        Annual_turnover__c, Financial_Needs_Analysis__c, Spouse_Account_Id__c, account.name, account.Id,
                                        account.Date_Established__c, account.Standard_Industry_SIC_Code__c, account.Business_Start_Date__c,
                                        account.sic, account.Trading_indicator__c, account.EDF_Code__c,
                                        account.Client_is_a_stokvel__c, account.Affected_Person_Reg_3_1_f__c, account.CIF__c,
                                        account.ID_Type__pc, Account.Is_the_Client_a_Non_resident__c, account.Age_years__c, account.ID_Number__pc,
                                        account.Registration_Number__c, account.Client_ever_been_declared_Insolvent__c, account.Passport_Number__pc,
                                        (SELECT id, AIPS__c,Requested_Franchise_Code__c,EDF_ReqCode__c from applications__r),
		                                account.Franchise_Code__c,account.Franchise_Name__c,account.Client_Type__c,
                                          account.Marital_Status__pc, account.Marital_Contract_Type__pc, account.Client_intends_to_declare_insolvency__c
		                                FROM opportunity
		                                WHERE id = :oppId
		                                LIMIT 1];
		//we can query Account fields in Opp Selector
		Account acc = new AccountsSelector().selectIndvByOpportunityId(oppId);

		Acc.Id = opplistnew[0].Account.Id;//
		Acc.Business_Start_Date__c = opplistnew[0].Account.Business_Start_Date__c;
		Acc.sic = opplistnew[0].Account.sic;//
		Acc.Trading_indicator__c = opplistnew[0].Account.Trading_indicator__c;
		Acc.EDF_Code__c = opplistnew[0].Account.EDF_Code__c;
		//Acc.EDF_ReqCode__c = opplistnew[0].Account.EDF_ReqCode__c;
		Acc.Client_is_a_stokvel__c = opplistnew[0].Account.Client_is_a_stokvel__c;
		Acc.Affected_Person_Reg_3_1_f__c = opplistnew[0].Account.Affected_Person_Reg_3_1_f__c;
		Acc.CIF__c = opplistnew[0].Account.CIF__c;//
		Acc.ID_Type__pc = opplistnew[0].Account.ID_Type__pc;//
		Acc.Is_the_Client_a_Non_resident__c = opplistnew[0].Account.Is_the_Client_a_Non_resident__c;//;
		// Acc.Age_years__c = opplistnew[0].Account.Age_years__c;//
		Acc.ID_Number__pc = opplistnew[0].Account.ID_Number__pc;//
		Acc.Registration_Number__c = opplistnew[0].Account.Registration_Number__c;//
		Acc.Client_ever_been_declared_Insolvent__c = opplistnew[0].Account.Client_ever_been_declared_Insolvent__c;//d;
		Acc.Passport_Number__pc = opplistnew[0].Account.Passport_Number__pc;//
		Acc.name = opplistnew[0].Account.name;//
		Acc.Marital_Status__pc = opplistnew[0].Account.Marital_Status__pc;//;
		Acc.Marital_Contract_Type__pc = opplistnew[0].Account.Marital_Contract_Type__pc;//
		Acc.Client_intends_to_declare_insolvency__c = opplistnew[0].Account.Client_intends_to_declare_insolvency__c;//
		Acc.Franchise_Code__c = opplistnew[0].Account.Franchise_Code__c;
        Acc.Client_Type__c = opplistnew[0].Account.Client_Type__c;
        //Acc.Requested_Franchise_Code__c = opplistnew[0].Account.Requested_Franchise_Code__c;

		//we can do a inner query on Opportunity to get app data also
		// Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		Application__c applicationRec = opplistnew[0].applications__r[0];
		Map<String, String> mapPrinNonRes = new Map<String, String>();
		Map<String, String> ExposureMap = new Map<String, String>();
		List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().getApplicationPrincipals(applicationRec.Id);
		// Map<String,Object> SelectedPartiesMap = new Map<String,Object>();
		// SelectedPartiesMap = principalShareholderDetails.getSelectedParties();

        if (appPrinList != null) {
            for (Application_Principal__c aprincipal : appPrinList) {
                keyprincipal += 1;
                coreprincipal += aprincipal.Is_Part_Of_Application__c ? 1:0;
                if (aprincipal.AccConRelId__c != null) {
                    accConRelIds.add(aprincipal.AccConRelId__c);
                }
            }

            if (accConRelIds.size() > 0) {
                Set<id> persacc = new Set<Id>();
                List<AccountContactRelation> accConRelList = new AccountContactRelationSelector().selectbyIdSet(accConRelIds);
                for(AccountContactRelation accConRel :accConRelList) {
                    persacc.add(accConRel.Contact.Id);
                }

                List<Account> persacclist = new AccountsSelector().selectAccountByPersonContactSetId(persacc);
                for (Account personacc : persacclist) {
                    nonresparticipants += personacc.Is_the_Client_a_Non_resident__c ? 1:0;
                    nonresparticipants += personacc.Is_the_Client_a_Temporary_Resident__c ? 1:0;
                }
            }
        }

		if (opplist != null && opplist.size() > 0) {
			//  List<Account> accounts = new AccountsSelector().selectById(new Set<Id>{opplist[0].AccountId}, 1);
			String FranchiseCodeName = '';
			if (applicationRec != null && String.isNotBlank(opplist[0].CIF_Number__c)) {
				ExposureMap = getExposureDetails(opplist[0].CIF_Number__c, applicationRec.id);
			}
		}

		//if(acc.Business_Start_Date__c != null){} //will have to put some checks here
		decimal daysBetween = (opplistnew[0].account.Date_Established__c.daysBetween(date.today()));
        decimal businessdays = (daysBetween / 365 * 12) < 1 ? 1 : (daysBetween / 365 * 12); // changed to 30 by Tinashe defect W-009399
        long inmonthsval = businessdays.round(System.RoundingMode.HALF_DOWN);
        //not sure what is being done here, we should have request as well
		IPlistNCARatesV1_Resp_IB_v1 responseBeanIP = new IPlistNCARatesV1_Resp_IB_v1();

		if (!Test.isRunningTest()) {
			responseBeanIP = (IPlistNCARatesV1_Resp_IB_v1)Json.deserialize(applicationRec.AIPS__c, IPlistNCARatesV1_Resp_IB_v1.class);
		}

		PowerCurveNewApplication_Req_IB_v1 requestBean = new PowerCurveNewApplication_Req_IB_v1();
		requestBean.Request = new PowerCurveNewApplication_Req_IB_v1.Request();
		requestBean.Request.ApplicationDV = new PowerCurveNewApplication_Req_IB_v1.ApplicationDV();
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONDATE = String.valueOf(Date.today()).removeEnd(' 00:00:00'); //today's date
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONNUMBER = getStockNumber(oppId) != null ? getStockNumber(oppId) : ''; //stock Number here
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTIME = getFormattedTime(DateTime.now());
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONTYPE = 'O';//Default to O
		requestBean.Request.ApplicationDV.INTAPPBRANCHCODE = u.SiteCode__c != null ? u.SiteCode__c : '8193';
		requestBean.Request.ApplicationDV.INTAPPOVERALLCONTROLBRANCH = (ExposureMap != null && ExposureMap.containskey('INTAPPOVERALLCONTROLBRANCH')) ? ExposureMap.get('INTAPPOVERALLCONTROLBRANCH') : '3840';//d
		requestBean.Request.ApplicationDV.INTAPPBUSINESSSEGMENT = (ExposureMap != null && ExposureMap.containskey('INTAPPBUSINESSSEGMENT')) ? ExposureMap.get('INTAPPBUSINESSSEGMENT') : '';//d
		requestBean.Request.ApplicationDV.INTAPPBUSINESSSUBSEGMENT = (ExposureMap != null && ExposureMap.containskey('INTAPPBUSINESSSUBSEGMENT')) ? ExposureMap.get('INTAPPBUSINESSSUBSEGMENT') : '';//d // Saurabh : 20210216 W: 9419 Removing the default values as per SA comments

        String standardIndustrySICCodeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Standard Industry SIC Code', opplistnew[0].Account.Standard_Industry_SIC_Code__c, StringConstants.OUTBOUND_RECORD_TYPE);

		requestBean.Request.ApplicationDV.INTAPPSICCODE = standardIndustrySICCodeTranslated != null ? standardIndustrySICCodeTranslated : ''; //Map it from SIC Code
		requestBean.Request.ApplicationDV.APPAPPTRADINGINDICATOR = opplistnew[0].account.Trading_indicator__c == True ? 'Y' : 'N';
		requestBean.Request.ApplicationDV.APPAPPFOREIGNCONTROLLEDPERC = '0';//waiting for input pass blank for now
		requestBean.Request.ApplicationDV.INTAPPENTERPRDEVFUNDEXISTING = opplistnew[0].account.EDF_Code__c != null ? opplistnew[0].account.EDF_Code__c : '';//d
		requestBean.Request.ApplicationDV.APPAPPENTERPRDEVFUNDREQ = applicationRec.EDF_ReqCode__c != null ? applicationRec.EDF_ReqCode__c : '';//d
		requestBean.Request.ApplicationDV.APPAPPSTOKVELAPPLICATION = opplistnew[0].account.Client_is_a_stokvel__c == True ? 'Y' : 'N';
		/*requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISEFINANCING = (ExposureMap != null && ExposureMap.containskey('INTAPPEXISTINGFRANCHISEFINANCING')) ? ExposureMap.get('INTAPPEXISTINGFRANCHISEFINANCING') : 'N';//d
		requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISEFINANCING = (ExposureMap != null && ExposureMap.containskey('APPAPPREQUESTEDFRANCHISEFINANCING')) ? ExposureMap.get('APPAPPREQUESTEDFRANCHISEFINANCING') : 'N';//d
		requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISORTYPE = (ExposureMap != null && ExposureMap.containskey('INTAPPEXISTINGFRANCHISORTYPE')) ? ExposureMap.get('INTAPPEXISTINGFRANCHISORTYPE') : '';//d
		requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISORTYPE = (ExposureMap != null && ExposureMap.containskey('APPAPPREQUESTEDFRANCHISORTYPE')) ? ExposureMap.get('APPAPPREQUESTEDFRANCHISORTYPE') : '';//d*/
		requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISEFINANCING = opplistnew[0].account.Franchise_Code__c != null?'Y': 'N';//d
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISEFINANCING = applicationRec.Requested_Franchise_Code__c != null?'Y':'N';//d
        requestBean.Request.ApplicationDV.INTAPPEXISTINGFRANCHISORTYPE = opplistnew[0].account.Franchise_Code__c != null?opplistnew[0].account.Franchise_Code__c:'';//d
        requestBean.Request.ApplicationDV.APPAPPREQUESTEDFRANCHISORTYPE =  applicationRec.Requested_Franchise_Code__c != null?applicationRec.Requested_Franchise_Code__c: '';//d
		requestBean.Request.ApplicationDV.APPAPPFORMALAPPINDICATOR = opplistnew[0].Illustrative_Decision__c == True ? 'N' : 'Y';
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSTATUS = 'P';//default to P
		requestBean.Request.ApplicationDV.APPAPPAPPLICATIONSUBSTATUS = '';//ignore?
		requestBean.Request.ApplicationDV.APPAPPESPINSTRUCTION = String.valueof(opplistnew[0].Opportunity_Number__c).substringAfter('-');//String.valueof(opplistnew[0].Opportunity_Number__c).replaceAll('[\\O-]','');
		requestBean.Request.ApplicationDV.APPAPPEXTRTLAMNT = applicationRec != null ? getTermloanAmtDetails(applicationRec.id).substringBefore('.') : '0';//d
		requestBean.Request.ApplicationDV.APPBANKERNUMBER = u.EmployeeNumber != null ? u.EmployeeNumber : '9145944';

		requestBean.Request.ApplicationDV.AppData = new PowerCurveNewApplication_Req_IB_v1.AppData();
		requestBean.Request.ApplicationDV.AppData.APPAPPNUMKEYPRINCIPALS = String.valueof(keyprincipal);
		requestBean.Request.ApplicationDV.AppData.APPAPPNUMCOREPRINCIPALS = String.valueof(coreprincipal);
		requestBean.Request.ApplicationDV.AppData.APPAPPNONRESPRINCIPALS = String.valueof(nonresparticipants);
		requestBean.Request.ApplicationDV.AppData.APPAPPNUMPARTICIPANTS = '';//ignore
		requestBean.Request.ApplicationDV.AppData.APPAPPMNTHSSINCEBUSESTABLISHED = inmonthsval != null ? String.valueof(inmonthsval) : '0';
		requestBean.Request.ApplicationDV.AppData.INTAPPAFFECTEDPERSREG31F = opplistnew[0].account.Affected_Person_Reg_3_1_f__c != null ? opplistnew[0].account.Affected_Person_Reg_3_1_f__c : '';//pending

		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO = new PowerCurveNewApplication_Req_IB_v1.INTAPPEXPO();
		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.POLICYIND = (ExposureMap != null && ExposureMap.containskey('POLICYIND')) ? ExposureMap.get('POLICYIND') : '';//d
		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGAE = (ExposureMap != null && ExposureMap.containskey('TGAE')) ? ExposureMap.get('TGAE').substringBefore('.') : '0';//d
		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGBE = (ExposureMap != null && ExposureMap.containskey('TGBE')) ? ExposureMap.get('TGBE').substringBefore('.') : '0';//d
		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TGOE = (ExposureMap != null && ExposureMap.containskey('TGOE')) ? ExposureMap.get('TGOE').substringBefore('.') : '0';//d
		requestBean.Request.ApplicationDV.AppData.INTAPPEXPO.TOTALGROUPEXPOSURE = (ExposureMap != null && ExposureMap.containskey('TOTALGROUPEXPOSURE')) ? ExposureMap.get('TOTALGROUPEXPOSURE').substringBefore('.') : '0';//d

		// as of now term loan values are not needed
		/*  requestBean.Request.ApplicationDV.AppData.INTAPPTOT = new PowerCurveNewApplication_Req_IB_v1.INTAPPTOT();
		 requestBean.Request.ApplicationDV.AppData.INTAPPTOT.INSTSETTLEMENTS ='';//d
		 requestBean.Request.ApplicationDV.AppData.INTAPPTOT.LOANREQ ='';//d
		 requestBean.Request.ApplicationDV.AppData.INTAPPTOT.SETTLEMENTSAMNT ='';//d*/

		if (!Test.isRunningTest()) {
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP = new PowerCurveNewApplication_Req_IB_v1.INTAPPNCAP();
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESFIRST = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaFirst) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESNEXTPERC = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaNext) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESMAX = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaMax != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaMax) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINITFEESTHRESHOLD = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaPerc != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeMaPerc) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAMAXSERVICEFEES = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeMaMaxsf != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeMaMaxsf) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.MAINTERESTRATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateMaMaxdr != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateMaMaxdr) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESFIRST = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfFirst) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESNEXTPERC = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfNext != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfNext) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESMAX = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfMax != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfMax) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINITFEESTHRESHOLD = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfPerc != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeCfPerc) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAMAXSERVICEFEES = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeCfMaxsf != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeCfMaxsf) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.CAINTERESTRATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateCfMaxdr != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateCfMaxdr) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESFIRST = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctFirst) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESNEXTPERC = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctNext != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctNext) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESMAX = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctMax != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctMax) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINITFEESTHRESHOLD = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctPerc != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeUctPerc) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTMAXSERVICEFEES = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeUctMaxsf != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeUctMaxsf) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.UCTINTERESTRATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateUctMaxdr != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateUctMaxdr) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESFIRST = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaFirst) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESNEXTPERC = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaNext != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaNext) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESMAX = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaMax != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaMax) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINITFEESTHRESHOLD = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaPerc != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeOcaPerc) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAMAXSERVICEFEES = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeOcaMaxsf != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeOcaMaxsf) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.OCAINTERESTRATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateOcaMaxdr != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateOcaMaxdr) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESFIRST = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctFirst != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctFirst) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESNEXTPERC = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctNext != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctNext) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESMAX = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctMax != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctMax) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINITFEESTHRESHOLD = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctPerc != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxifeeStctPerc) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTMAXSERVICEFEES = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeStctMaxsf != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxfeeStctMaxsf) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.STCTINTERESTRATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateStctMaxdr != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.ncaMaxrateStctMaxdr) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.PRIMERATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.primeRate != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.primeRate) : '';
			requestBean.Request.ApplicationDV.AppData.INTAPPNCAP.REPORATE = responseBeanIP.IPlistNCARatesV1Response.Ipb100o.repurchaseRate != null ? String.valueof(responseBeanIP.IPlistNCARatesV1Response.Ipb100o.repurchaseRate) : '';
		}

		//Not needed to map as of now
		requestBean.Request.ApplicationDV.AppData.INTAPPCCLP = new PowerCurveNewApplication_Req_IB_v1.INTAPPCCLP();
		requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMINAMNT = '0';
		requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.TLCREDITLIFEMAXAMNT = '0';
		requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMINAMNT = '0';
		requestBean.Request.ApplicationDV.AppData.INTAPPCCLP.ODCREDITLIFEMAXAMNT = '0';

		requestBean = getEntityData(requestBean, opplist[0], acc, applicationRec, appPrinList, opplistnew[0].Account.Age_years__c);

		// mapping from Product Method
		requestBean = mapExistingRequestedProducts(requestBean, oppID);

		return requestBean; //need to check if response is null or not and call insertnewpco method
	}

	/**
	 * @description method to get and map client Entity/Account details PCO
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param requestBean
	 * @param opp
	 * @param acc
	 * @param application
	 * @param appPrincipalList
	 * @param AgeInYears
	 * @return PowerCurveNewApplication_Req_IB_v1
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1 getEntityData(PowerCurveNewApplication_Req_IB_v1 requestBean, Opportunity opp, Account acc, Application__c application, List<application_principal__c> appPrincipalList, String AgeInYears) {
		/*
		 PowerCurveNewApplication_Req_IB_v1 requestBean = new PowerCurveNewApplication_Req_IB_v1();
		 requestBean.Request = new PowerCurveNewApplication_Req_IB_v1.Request();
		 requestBean.Request.ApplicationDV = new PowerCurveNewApplication_Req_IB_v1.ApplicationDV();
		 Account acc=new Account();
		 acc=new AccountsSelector().selectIndvByOpportunityId(oppId);
		 Application__c application=new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		 Opportunity opp=new OpportunitiesSelector().selectByOppId(oppID);
		 List<Application_Principal__c> appPrincipalList = new ApplicationPrincipalsSelector().getApplicationPrincipals(application.Id);
		 */
		List<Integration_Translation__c> translationList = [SELECT Id, Direction__c, External_Value__c, Internal_Value__c, System_Name__c, Value_Type__c, Name FROM Integration_Translation__c WHERE Value_Type__c IN ('Identity Type','Client Type') AND System_Name__c = 'CIF' AND Direction__c = 'Outbound'];

        translationMap = new Map<String, String>();
        for(Integration_Translation__c trnsRecord : translationList) {
            translationMap.put(trnsRecord.Internal_Value__c, trnsRecord.External_Value__c);
        }

		requestBean.Request.ApplicationDV.Entity01 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		requestBean.Request.ApplicationDV.Entity02 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		requestBean.Request.ApplicationDV.Entity03 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		requestBean.Request.ApplicationDV.Entity04 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		requestBean.Request.ApplicationDV.Entity05 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		requestBean.Request.ApplicationDV.Entity06 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		List<Application_Profile__c> associatedCCForMain = new List<Application_Profile__c>();
		List<Application_Profile__c> appProfile = new List<Application_Profile__c>();
		List<Application_Profile__c> associatedCCForSpouse = new List<Application_Profile__c>();

		Account accSpouse = new Account();
        appProfile = new ApplicationProfileSelector().getApplicationProfiles(application.Id);
		appProfile = ExposureController.orderedProfilesList(appProfile,opp.Id);

		List<Application_Principal__c> mainPrincipals = new List<Application_Principal__c>();
		List<Application_Profile__c> appProfile1 = new List<Application_Profile__c>();
		List<Application_Profile__c> appProfile2 = new List<Application_Profile__c>();
		List<Application_Profile__c> appProfile3 = new List<Application_Profile__c>();
		List<Application_Profile__c> appProfile4 = new List<Application_Profile__c>();
		List<Application_Principal__c> associatedPrincipals = new List<Application_Principal__c>();

		if (appPrincipalList.size() > 0 && appPrincipalList != null) {
			for (Application_Principal__c var : appPrincipalList) {
                if (var.Main__c == true) {
                    mainPrincipals.add(var);
                }
                else if(var.Main__c == false && var.Is_Part_Of_Application__c == true) {
                    associatedPrincipals.add(var); //need to check with Himani
                }
            }
		}

		for (Application_Profile__c var : appProfile) {
			if (mainPrincipals?.size() > 0) {
				if (var.Client_CIF_Code__c == mainPrincipals[0]?.CIF__c) {
					appProfile1.add(var);
				}
			}
			if (associatedPrincipals?.size() > 0) {
				if (var.Client_CIF_Code__c == associatedPrincipals[0]?.CIF__c) {
					appProfile2.add(var);
				}
				if (associatedPrincipals?.size() > 1) {
					if (var.Client_CIF_Code__c == associatedPrincipals[1]?.CIF__c) {
						appProfile3.add(var);
					}
				}
				if (associatedPrincipals?.size() > 2) {
					if (var.Client_CIF_Code__c == associatedPrincipals[2]?.CIF__c) {
						appProfile4.add(var);
					}
				}
			}
		}

		List<Account> principalAccounts = new List<Account>();
		Account accPrincipal = new Account();
		Account accPrincipal2 = new Account();
		Account accPrincipal3 = new Account();
		Account accPrincipal4 = new Account();

        String mainPrinIdNum = (mainPrincipals?.size() > 0 ? mainPrincipals[0].Id_Number__c: null),
            assPrinIdNum1 = (associatedPrincipals?.size() > 0 ? associatedPrincipals[0].Id_Number__c: null),
            assPrinIdNum2 = (associatedPrincipals?.size() > 1 ? associatedPrincipals[1].Id_Number__c: null),
            assPrinIdNum3 = (associatedPrincipals?.size() > 2 ? associatedPrincipals[2].Id_Number__c: null);

		Set<String> idAndRegNums = new Set<String>{mainPrinIdNum, assPrinIdNum1, assPrinIdNum2, assPrinIdNum3};
		idAndRegNums.remove(null);

		principalAccounts = [SELECT Id, Age__pc, ID_Type__c, ID_Type__pc, CIF__c, ID_Number__pc, Passport_Number__pc, Client_Type__c, Is_the_Client_a_Non_resident__c, Is_the_Client_a_Temporary_Resident__c, Age_years__c, Sic, Marital_Status__pc, Marital_Contract_Type__pc, Months_Since_Shareholding__c, Client_ever_been_declared_Insolvent__c, Company_Registration_Number__c, Registration_Number__c, Client_intends_to_declare_insolvency__c
		                     FROM Account
		                     WHERE ID_Number__pc IN :idAndRegNums OR Registration_Number__c IN :idAndRegNums OR id = :opp.Spouse_Account_Id__c];

		if (appPrincipalList?.size() > 0) {
			for (Account accp : principalAccounts) {
				if (accp.ID_Type__pc == 'SA Identity Document' || accp.ID_Type__pc == null) {
					if (mainPrincipals.size() > 0) {
						if (accp.ID_Number__pc == mainPrincipals[0].Id_Number__c) {
							accPrincipal = accp;
						}
					}

					if (associatedPrincipals.size() > 0) {
						if (accp.ID_Number__pc == associatedPrincipals[0].Id_Number__c) {
							accPrincipal2 = accp;
						}
					}

					if (associatedPrincipals.size() > 1) {
						if (accp.ID_Number__pc == associatedPrincipals[1].Id_Number__c) {
							accPrincipal3 = accp;
						}
					}

					if (associatedPrincipals.size() > 2) {
						if (accp.ID_Number__pc == associatedPrincipals[2].Id_Number__c) {
							accPrincipal4 = accp;
						}
					}

					if (opp.Spouse_Account_Id__c != null && accp.id == opp.Spouse_Account_Id__c) {
						accSpouse = accp;
					}
				}
				else {
					if (mainPrincipals.size() > 0) {
						if (accp.Registration_Number__c == mainPrincipals[0].Id_Number__c) {
							accPrincipal = accp;
						}
					}

					if (associatedPrincipals.size() > 0) {
						if (accp.Registration_Number__c == associatedPrincipals[0].Id_Number__c) {
							accPrincipal2 = accp;
						}
					}

					if (associatedPrincipals.size() > 1) {
						if (accp.Registration_Number__c == associatedPrincipals[1].Id_Number__c) {
							accPrincipal3 = accp;
						}
					}

					if (associatedPrincipals.size() > 2) {
						if (accp.Registration_Number__c == associatedPrincipals[2].Id_Number__c) {
							accPrincipal4 = accp;
						}
					}

					if (opp.Spouse_Account_Id__c != null && accp.id == opp.Spouse_Account_Id__c) {
						accSpouse = accp;
					}
				}
			}
		}

		Application_Profile__c MainAppProfileRec = new Application_Profile__c();
		Application_Profile__c SpouseAppProfileRec = new Application_Profile__c();
		Application_Profile__c MainPrin1AppProfileRec = new Application_Profile__c();
		Application_Profile__c MainPrin2AppProfileRec = new Application_Profile__c();
		Application_Profile__c MainPrin3AppProfileRec = new Application_Profile__c();
		Application_Profile__c MainPrin4AppProfileRec = new Application_Profile__c();
        Map<String,String> clientCodeRegNoMap = new Map<String,String>();

        for (Application_Profile__c var : appProfile) {
            clientCodeRegNoMap.put(var.Client_CIF_Code__c,var.Related_to_Client_Id_Or_Reg_Number__c);
			if (var.Applicant_Type__c == 'Main Applicant') {
				MainAppProfileRec = var;
			}

			if (var.Applicant_Type__c == 'Spouse') {
				SpouseAppProfileRec = var;
			}

			if (mainPrincipals.size() > 0 && mainPrincipals.size() != null) {
				if ((var.Client_CIF_Code__c != null && var.Client_CIF_Code__c == mainPrincipals[0].CIF__c) || var.Client_Name__c == mainPrincipals[0].Principal_Shareholder_Name__c && var.Client_Name__c != null) {
					MainPrin1AppProfileRec = var;
				}
			}

			if (associatedPrincipals.size() > 0 && associatedPrincipals != null) {
				if ((var.Client_CIF_Code__c != null && var.Client_CIF_Code__c == associatedPrincipals[0].CIF__c) || var.Client_Name__c == associatedPrincipals[0].Principal_Shareholder_Name__c && var.Client_Name__c != null) {
					MainPrin2AppProfileRec = var;
				}
			}

            if (associatedPrincipals.size() > 1){
				if ((var.Client_CIF_Code__c != null && var.Client_CIF_Code__c == associatedPrincipals[1].CIF__c) || var.Client_Name__c == associatedPrincipals[1].Principal_Shareholder_Name__c && var.Client_Name__c != null) {
					MainPrin3AppProfileRec = var;
                }
			}

            if (associatedPrincipals.size() > 2){
				if ((var.Client_CIF_Code__c != null && var.Client_CIF_Code__c == associatedPrincipals[2].CIF__c) || var.Client_Name__c == associatedPrincipals[2].Principal_Shareholder_Name__c && var.Client_Name__c != null) {
					MainPrin4AppProfileRec = var;
                }
			}

        	String regNo = (clientCodeRegNoMap != null ? clientCodeRegNoMap.get(acc.CIF__c) : null);

			if (regNo != null) {
				if (regNo.replaceAll('[\\/]', '') == var.Related_to_Client_ID_or_Reg_Number__c && var.Applicant_Type__c == null) {
					associatedCCForMain.add(var);
				}
			}

			if (SpouseAppProfileRec != null) {
                regNo = (clientCodeRegNoMap != null ? clientCodeRegNoMap.get(SpouseAppProfileRec?.Client_CIF_Code__c) : null);
				if (regNo != null && regNo.replaceAll('[\\/]', '') == var.Related_to_Client_ID_or_Reg_Number__c && var.Applicant_Type__c == null) {
					associatedCCForSpouse.add(var);
				}
			}

			/*if (acc.Registration_Number__c != null) {
				if (acc.Registration_Number__c.replaceAll('[\\/]', '') == var.Related_to_Client_ID_or_Reg_Number__c && var.Applicant_Type__c == null) {
					associatedCCForMain.add(var);
				}
			}

			if (accSpouse.id != null) {
				if (accSpouse.Registration_Number__c.replaceAll('[\\/]', '') == var.Related_to_Client_ID_or_Reg_Number__c && var.Applicant_Type__c == null) {
					associatedCCForSpouse.add(var);
				}
			}*/
		}

		//For Main Applicant
		PowerCurveNewApplication_Req_IB_v1.Entity01 Entity1 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		Entity1.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
		Entity1.INTENTNUMPARTICIPANTS1 = MainAppProfileRec.noOfJointPartcpnt__c != null ? MainAppProfileRec.noOfJointPartcpnt__c : '';
		Entity1.INTENTNUMPARTICIPANTS2 = associatedCCForMain.size() > 0 && associatedCCForMain[0].noOfJointPartcpnt__c != null ? associatedCCForMain[0].noOfJointPartcpnt__c : '';
		Entity1.INTENTNUMPARTICIPANTS3 = associatedCCForMain.size() > 1 && associatedCCForMain[1].noOfJointPartcpnt__c != null ? associatedCCForMain[1].noOfJointPartcpnt__c : '';
		Entity1.INTENTNUMPARTICIPANTS4 = associatedCCForMain.size() > 2 && associatedCCForMain[2].noOfJointPartcpnt__c != null ? associatedCCForMain[2].noOfJointPartcpnt__c : '';
		Entity1.INTENTNUMPARTICIPANTS5 = associatedCCForMain.size() > 3 && associatedCCForMain[3].noOfJointPartcpnt__c != null ? associatedCCForMain[3].noOfJointPartcpnt__c : '';
		Entity1.INTENTNUMPARTICIPANTS6 = associatedCCForMain.size() > 4 && associatedCCForMain[4].noOfJointPartcpnt__c != null ? associatedCCForMain[4].noOfJointPartcpnt__c : '';
		Entity1.INTENTUNDERJUDICIALMNGMNT = MainAppProfileRec.curatorshipHold__c != null ? MainAppProfileRec.curatorshipHold__c : '';
		Entity1.INTENTFINANCIALCRIMEHOLD = MainAppProfileRec.finCrimeHold__c != null ? MainAppProfileRec.finCrimeHold__c : '';
		Entity1.INTENTUNDERDEBTCOUNSELLING = MainAppProfileRec.applyDebtCounsel__c != null ? MainAppProfileRec.applyDebtCounsel__c : '';

		if (associatedCCForMain.size() > 0) {
			Entity1.INTENTCLIENTCODE2 = associatedCCForMain.size() > 0 && associatedCCForMain[0]?.Client_CIF_Code__c != null ? String.valueof(associatedCCForMain[0].Client_CIF_Code__c) : '';
			Entity1.INTENTCLIENTCODE3 = associatedCCForMain.size() > 1 && associatedCCForMain[1]?.Client_CIF_Code__c != null ? String.valueof(associatedCCForMain[1].Client_CIF_Code__c) : '';
			Entity1.INTENTCLIENTCODE4 = associatedCCForMain.size() > 2 && associatedCCForMain[2]?.Client_CIF_Code__c != null ? String.valueof(associatedCCForMain[2].Client_CIF_Code__c) : '';
			Entity1.INTENTCLIENTCODE5 = associatedCCForMain.size() > 3 && associatedCCForMain[3]?.Client_CIF_Code__c != null ? String.valueof(associatedCCForMain[3].Client_CIF_Code__c) : '';
			Entity1.INTENTCLIENTCODE6 = associatedCCForMain.size() > 4 && associatedCCForMain[4]?.Client_CIF_Code__c != null ? String.valueof(associatedCCForMain[4].Client_CIF_Code__c) : '';
		}

		Entity1.APPENTBUR.CONSINPNATID = acc.ID_Number__pc != null ? String.valueof(acc.ID_Number__pc) : null;
		Entity1.APPENTIDTYPE = getTranslatedValue(acc.ID_Type__pc == null || acc.ID_Type__pc == '' ? acc.ID_Type__c : acc.ID_Type__pc);
        Entity1.APPENTSHAREHOLDINGPERC = '0';
        //Entity1.APPENTMNTHSSHAREHOLDINGPERC = acc?.Months_Since_Shareholding__c != null ? acc?.Months_Since_Shareholding__c : '0';
		Entity1.INTENTCLIENTTYPE = getTranslatedValue(acc.Client_Type__c);
        Entity1.INTENTNONRESIDENT = ((acc?.Is_the_Client_a_Non_resident__c || acc?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');
		Entity1.INTENTRDET = new PowerCurveNewApplication_Req_IB_v1.INTENTRDET();
        Entity1.INTENTRDET.INTENTBUSNRESC = (acc?.Client_Intent_To_Go_Into_Business_Rescue__c ? 'Y' : 'N');

		List<Application_Exposure__c> appEx = new ApplicationExposureSelector().getAllApplicationExposure(application.Id);
		List<Application_Exposure_Risk__c> appExRisk = new ApplicationExposureRiskSelector().getAllApplicationExposureRisk(application.Id);
		List<Application_Triad__c> appTriadList = new ApplicationTriadsSelector().getTriadsByApplicationID(application.Id);
		List<Application_Exposure_Cash_and_Investment__c> appExCash = new ApplicationExposureCashInvSelector().getAllApplicationExposureCashInvestByAppId(application.Id);
		List<Application_Exposure_Facility__c> appExFin = new ApplicationExposureFacilitySelector().exposureFacilitiesUsingApplication(application.Id);
		List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(application.Id);

		Entity1 = getAccountDetails(acc, Entity1);
		Entity1 = getExposuresRisk(acc.CIF__c, MainAppProfileRec.Client_Name__c, appExRisk, application.Id, Entity1,clientCodeRegNoMap);
		Entity1 = getExposures(acc.CIF__c, MainAppProfileRec.Client_Name__c, appEx, application.Id, Entity1); //changes from acc name to MainAppProfileRec for W-012323
		Entity1 = getCashAndInvestments(acc.CIF__c, MainAppProfileRec.Client_Name__c,appExCash, application.Id, Entity1,clientCodeRegNoMap);
		Entity1 = getTriads(acc.CIF__c, appTriadList, application.Id, Entity1);

		/*if (acc.CIF__c != null && application.Id != null && Entity1 != null) {
			Entity1 = getFacilities(acc.CIF__c, appExFin, application.Id, Entity1);
		}*/

		//using the client name as the unique identifier and not the CIF code
		Entity1 = getFacilities(MainAppProfileRec.Client_Name__c, appExFin, application.Id, Entity1);
		Entity1 = getFinancialConduct(appFinConList, application.Id, Entity1);
		requestBean.Request.ApplicationDV.Entity01 = Entity1;

		//For Main Spouse
		PowerCurveNewApplication_Req_IB_v1.Entity01 Entity2 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
		if (opp.Spouse_Account_Id__c != null) {
			accSpouse = [SELECT Id, Age__pc, ID_Type__c, ID_Type__pc, CIF__c, ID_Number__pc, Passport_Number__pc, Client_Type__c, Is_the_Client_a_Non_resident__c, Is_the_Client_a_Temporary_Resident__c, Age_years__c, Sic, Marital_Status__pc, Marital_Contract_Type__pc, Months_Since_Shareholding__c, Client_ever_been_declared_Insolvent__c, Company_Registration_Number__c, Registration_Number__c, Client_intends_to_declare_insolvency__c
						FROM Account
						WHERE id = :opp.Spouse_Account_Id__c];
			Entity2.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();

			GetClientDetails_Resp_IB_v1 responseBean21;
			responseBean21 = GetClientDetails_IH_v1.getClientDetails(accSpouse.CIF__c, '0', accSpouse.Sic);//Before next callout
			Entity2.INTENTNUMPARTICIPANTS1 = SpouseAppProfileRec.noOfJointPartcpnt__c != null ? SpouseAppProfileRec.noOfJointPartcpnt__c : '';
			Entity2.INTENTUNDERJUDICIALMNGMNT = SpouseAppProfileRec.curatorshipHold__c != null ? SpouseAppProfileRec.curatorshipHold__c : '';
			Entity2.INTENTFINANCIALCRIMEHOLD = SpouseAppProfileRec.finCrimeHold__c != null ? SpouseAppProfileRec.finCrimeHold__c : '';
			Entity2.INTENTUNDERDEBTCOUNSELLING = SpouseAppProfileRec.applyDebtCounsel__c != null ? SpouseAppProfileRec.applyDebtCounsel__c : '';

			if (associatedCCForSpouse.size() > 0) {
				Entity2.INTENTNUMPARTICIPANTS2 = associatedCCForSpouse.size() > 0 && associatedCCForSpouse[0].noOfJointPartcpnt__c != null ? associatedCCForSpouse[0].noOfJointPartcpnt__c : '';
				Entity2.INTENTNUMPARTICIPANTS3 = associatedCCForSpouse.size() > 1 && associatedCCForSpouse[1].noOfJointPartcpnt__c != null ? associatedCCForSpouse[1].noOfJointPartcpnt__c : '';
				Entity2.INTENTNUMPARTICIPANTS4 = associatedCCForSpouse.size() > 2 && associatedCCForSpouse[2].noOfJointPartcpnt__c != null ? associatedCCForSpouse[2].noOfJointPartcpnt__c : '';
				Entity2.INTENTNUMPARTICIPANTS5 = associatedCCForSpouse.size() > 3 && associatedCCForSpouse[3].noOfJointPartcpnt__c != null ? associatedCCForSpouse[3].noOfJointPartcpnt__c : '';
				Entity2.INTENTNUMPARTICIPANTS6 = associatedCCForSpouse.size() > 4 && associatedCCForSpouse[4].noOfJointPartcpnt__c != null ? associatedCCForSpouse[4].noOfJointPartcpnt__c : '';
				//Entity2.INTENTCLIENTCODE1 = associatedCCForSpouse.size() > 0 && associatedCCForSpouse[0].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[0].Client_CIF_Code__c) : '';
				Entity2.INTENTCLIENTCODE2 = associatedCCForSpouse.size() > 0 && associatedCCForSpouse[0].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[0].Client_CIF_Code__c) : '';
				Entity2.INTENTCLIENTCODE3 = associatedCCForSpouse.size() > 1 && associatedCCForSpouse[1].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[1].Client_CIF_Code__c) : '';
				Entity2.INTENTCLIENTCODE4 = associatedCCForSpouse.size() > 2 && associatedCCForSpouse[2].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[2].Client_CIF_Code__c) : '';
				Entity2.INTENTCLIENTCODE5 = associatedCCForSpouse.size() > 3 && associatedCCForSpouse[3].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[3].Client_CIF_Code__c) : '';
				Entity2.INTENTCLIENTCODE6 = associatedCCForSpouse.size() > 4 && associatedCCForSpouse[4].Client_CIF_Code__c != null ? String.valueof(associatedCCForSpouse[4].Client_CIF_Code__c) : '';
			}

            if(accSpouse.ID_Type__pc.equalsIgnoreCase('SA Identity Document')){
            	Entity2.APPENTBUR.CONSINPNATID = accSpouse.ID_Number__pc != null ? String.valueof(accSpouse.ID_Number__pc) : null;
            } else if(accSpouse.ID_Type__pc.equalsIgnoreCase('Passport')){
                Entity2.APPENTBUR.CONSINPNATID = accSpouse.Passport_Number__pc != null ? String.valueof(accSpouse.Passport_Number__pc) : null;
            }
            Entity2.APPENTIDTYPE = getTranslatedValue(accSpouse.ID_Type__pc == null || accSpouse.ID_Type__pc == '' ? accSpouse.ID_Type__c : accSpouse.ID_Type__pc);
            Entity2.APPENTSHAREHOLDINGPERC = '0';
            //Entity2.APPENTMNTHSSHAREHOLDINGPERC = accSpouse?.Months_Since_Shareholding__c != null ? accSpouse?.Months_Since_Shareholding__c : '0';
			Entity2.INTENTCLIENTTYPE = getTranslatedValue(accSpouse.Client_Type__c);
            Entity2.INTENTNONRESIDENT = ((accSpouse?.Is_the_Client_a_Non_resident__c || accSpouse?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');

			Entity2 = getAccountDetails(accSpouse, Entity2);
			Entity2 = getExposuresRisk(accSpouse.CIF__c, SpouseAppProfileRec.Client_Name__c, appExRisk, application.Id, Entity2,clientCodeRegNoMap);
			Entity2 = getExposures(accSpouse.CIF__c, SpouseAppProfileRec.Client_Name__c, appEx, application.Id, Entity2);
			Entity2 = getCashAndInvestments(accSpouse.CIF__c,SpouseAppProfileRec.Client_Name__c, appExCash, application.Id, Entity2,clientCodeRegNoMap);
			Entity2 = getTriads(accSpouse.CIF__c, appTriadList, application.Id, Entity2);

			//Entity2 = getFacilities(accSpouse.CIF__c, appExFin, application.Id, Entity2);

			//using the client name as the unique identifier and not the CIF code
			Entity2 = getFacilities(SpouseAppProfileRec.Client_Name__c, appExFin, application.Id, Entity2);

			Entity2 = getFinancialConduct(appFinConList, application.Id, Entity2);
			requestBean.Request.ApplicationDV.Entity02 = Entity2;
		}

		//For Principals
		if (!appPrincipalList.isEmpty()) {
			//For Principal 1
			PowerCurveNewApplication_Req_IB_v1.Entity01 EntityP = new PowerCurveNewApplication_Req_IB_v1.Entity01();
			EntityP.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
			List<Application_Profile__c> associatedPrincipals01 = new List<Application_Profile__c>();
			List<Application_Profile__c> associatedPrincipals02 = new List<Application_Profile__c>();
			List<Application_Profile__c> associatedPrincipals03 = new List<Application_Profile__c>();
			List<Application_Profile__c> associatedPrincipals04 = new List<Application_Profile__c>();

			for (Application_Profile__c var : appProfile) {
                if(mainPrincipals.size()>0){
					if (var?.Related_to_Client_ID_or_Reg_Number__c == mainPrincipals[0]?.Id_Number__c && var.Applicant_Type__c == null) {
						associatedPrincipals01.add(var);
					}
                }

				if (associatedPrincipals != null && associatedPrincipals.size() > 0) {
					if (var?.Related_to_Client_ID_or_Reg_Number__c == associatedPrincipals[0]?.Id_Number__c && var?.Applicant_Type__c == null) {
						associatedPrincipals02.add(var);
					}
				}

				if (associatedPrincipals.size() > 1) {
					if (var.Related_to_Client_ID_or_Reg_Number__c == associatedPrincipals[1]?.Id_Number__c && var.Applicant_Type__c == null) {
						associatedPrincipals03.add(var);
					}
				}

				if (associatedPrincipals.size() > 2) {
					if (var.Related_to_Client_ID_or_Reg_Number__c == associatedPrincipals[2]?.Id_Number__c && var.Applicant_Type__c == null) {
						associatedPrincipals04.add(var);
					}
				}
			}

            Map<String, String> mapPrinPerc = new Map<String, String>();

            Integer countPrin = 0;
            for (Application_Principal__c aprincipal : appPrincipalList) {
                if (aprincipal.Is_Part_Of_Application__c == true) {
                    countPrin++;
                    mapPrinPerc.put('EntityP0' + countPrin, String.valueOf(aprincipal.Controlling_Interest__c));
                }
            }

			EntityP.INTENTNUMPARTICIPANTS1 = MainPrin1AppProfileRec.noOfJointPartcpnt__c != null ? MainPrin1AppProfileRec.noOfJointPartcpnt__c : '';
			EntityP.INTENTUNDERJUDICIALMNGMNT = MainPrin1AppProfileRec.curatorshipHold__c != null ? MainPrin1AppProfileRec.curatorshipHold__c : '';
			EntityP.INTENTFINANCIALCRIMEHOLD = MainPrin1AppProfileRec.finCrimeHold__c != null ? MainPrin1AppProfileRec.finCrimeHold__c : '';
			EntityP.INTENTUNDERDEBTCOUNSELLING = MainPrin1AppProfileRec.applyDebtCounsel__c != null ? MainPrin1AppProfileRec.applyDebtCounsel__c : '';
			EntityP.INTENTCLIENTCODE2 = associatedPrincipals01.size() > 0 && associatedPrincipals01[0].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals01[0].Client_CIF_Code__c) : '';
			EntityP.INTENTNUMPARTICIPANTS2 = associatedPrincipals01.size() > 0 && associatedPrincipals01[0].noOfJointPartcpnt__c != null ? associatedPrincipals01[0].noOfJointPartcpnt__c : '';
			EntityP.INTENTCLIENTCODE3 = associatedPrincipals01.size() > 1 && associatedPrincipals01[1].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals01[1].Client_CIF_Code__c) : '';
			EntityP.INTENTNUMPARTICIPANTS3 = associatedPrincipals01.size() > 1 && associatedPrincipals01[1].noOfJointPartcpnt__c != null ? associatedPrincipals01[1].noOfJointPartcpnt__c : '';
			EntityP.INTENTCLIENTCODE4 = associatedPrincipals01.size() > 2 && associatedPrincipals01[2].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals01[2].Client_CIF_Code__c) : '';
			EntityP.INTENTNUMPARTICIPANTS4 = associatedPrincipals01.size() > 2 && associatedPrincipals01[2].noOfJointPartcpnt__c != null ? associatedPrincipals01[2].noOfJointPartcpnt__c : '';
			EntityP.INTENTCLIENTCODE5 = associatedPrincipals01.size() > 3 && associatedPrincipals01[3].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals01[3].Client_CIF_Code__c) : '';
			EntityP.INTENTNUMPARTICIPANTS5 = associatedPrincipals01.size() > 3 && associatedPrincipals01[3].noOfJointPartcpnt__c != null ? associatedPrincipals01[3].noOfJointPartcpnt__c : '';
			EntityP.INTENTCLIENTCODE6 = associatedPrincipals01.size() > 4 && associatedPrincipals01[4].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals01[4].Client_CIF_Code__c) : '';
			EntityP.INTENTNUMPARTICIPANTS6 = associatedPrincipals01.size() > 4 && associatedPrincipals01[4].noOfJointPartcpnt__c != null ? associatedPrincipals01[4].noOfJointPartcpnt__c : '';

            EntityP.APPENTBUR.CONSINPNATID = accPrincipal.ID_Number__pc != null ? String.valueof(accPrincipal.ID_Number__pc) : null;
			EntityP.APPENTIDTYPE = getTranslatedValue(accPrincipal.ID_Type__pc == null || accPrincipal.ID_Type__pc == '' ? accPrincipal.ID_Type__c : accPrincipal.ID_Type__pc);
            EntityP.APPENTSHAREHOLDINGPERC = mapPrinPerc?.get('EntityP01') != null ? mapPrinPerc?.get('EntityP01') : '0';
            EntityP.APPENTMNTHSSHAREHOLDINGPERC = accPrincipal?.Months_Since_Shareholding__c != null ? String.valueof(accPrincipal?.Months_Since_Shareholding__c).substringBefore('.') : '0';
			EntityP.INTENTCLIENTTYPE = getTranslatedValue(accPrincipal?.Client_Type__c);
            EntityP.INTENTNONRESIDENT = ((accPrincipal?.Is_the_Client_a_Non_resident__c || accPrincipal?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');

			EntityP = getAccountDetails(accPrincipal, EntityP);
			string clientNameApp1 = '';
			if (appProfile1 != null && appProfile1.size() > 0) {
				clientNameApp1 = appProfile1[0]?.Client_Name__c;
			}
			EntityP = getExposuresRisk(accPrincipal.CIF__c, clientNameApp1, appExRisk, application.Id, EntityP,clientCodeRegNoMap);
			EntityP = getExposures(accPrincipal.CIF__c, clientNameApp1, appEx, application.Id, EntityP);
			EntityP = getCashAndInvestments(accPrincipal.CIF__c,clientNameApp1, appExCash, application.Id, EntityP,clientCodeRegNoMap);
			EntityP = getTriads(accPrincipal.CIF__c, appTriadList, application.Id, EntityP);

			//EntityP = getFacilities(accPrincipal.CIF__c, appExFin, application.Id, EntityP);

			//using the client name as the unique identifier and not the CIF code
			EntityP = getFacilities(MainPrin1AppProfileRec.Client_Name__c, appExFin, application.Id, EntityP);
			EntityP = getFinancialConduct(appFinConList, application.Id, EntityP);
			requestBean.Request.ApplicationDV.Entity03 = EntityP;

			//For Principal 2
			PowerCurveNewApplication_Req_IB_v1.Entity01 EntityP21 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
			EntityP21.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
			EntityP21.INTENTNUMPARTICIPANTS1 = MainPrin2AppProfileRec.noOfJointPartcpnt__c != null ? MainPrin2AppProfileRec.noOfJointPartcpnt__c : '';
			EntityP21.INTENTUNDERJUDICIALMNGMNT = MainPrin2AppProfileRec.curatorshipHold__c != null ? MainPrin2AppProfileRec.curatorshipHold__c : '';
			EntityP21.INTENTFINANCIALCRIMEHOLD = MainPrin2AppProfileRec.finCrimeHold__c != null ? MainPrin2AppProfileRec.finCrimeHold__c : '';
			EntityP21.INTENTUNDERDEBTCOUNSELLING = MainPrin2AppProfileRec.applyDebtCounsel__c != null ? MainPrin2AppProfileRec.applyDebtCounsel__c : '';
			EntityP21.INTENTCLIENTCODE2 = associatedPrincipals02.size() > 0 && associatedPrincipals02[0].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals02[0].Client_CIF_Code__c) : '';
			EntityP21.INTENTNUMPARTICIPANTS2 = associatedPrincipals02.size() > 0 && associatedPrincipals02[0].noOfJointPartcpnt__c != null ? associatedPrincipals02[0].noOfJointPartcpnt__c : '';
			EntityP21.INTENTCLIENTCODE3 = associatedPrincipals02.size() > 1 && associatedPrincipals02[1].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals02[1].Client_CIF_Code__c) : '';
			EntityP21.INTENTNUMPARTICIPANTS3 = associatedPrincipals02.size() > 1 && associatedPrincipals02[1].noOfJointPartcpnt__c != null ? associatedPrincipals02[1].noOfJointPartcpnt__c : '';
			EntityP21.INTENTCLIENTCODE4 = associatedPrincipals02.size() > 2 && associatedPrincipals02[2].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals02[2].Client_CIF_Code__c) : '';
			EntityP21.INTENTNUMPARTICIPANTS4 = associatedPrincipals02.size() > 2 && associatedPrincipals02[2].noOfJointPartcpnt__c != null ? associatedPrincipals02[2].noOfJointPartcpnt__c : '';
			EntityP21.INTENTCLIENTCODE5 = associatedPrincipals02.size() > 3 && associatedPrincipals02[3].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals02[3].Client_CIF_Code__c) : '';
			EntityP21.INTENTNUMPARTICIPANTS5 = associatedPrincipals02.size() > 3 && associatedPrincipals02[3].noOfJointPartcpnt__c != null ? associatedPrincipals02[3].noOfJointPartcpnt__c : '';
			EntityP21.INTENTCLIENTCODE6 = associatedPrincipals02.size() > 4 && associatedPrincipals02[4].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals02[4].Client_CIF_Code__c) : '';
			EntityP21.INTENTNUMPARTICIPANTS6 = associatedPrincipals02.size() > 4 && associatedPrincipals02[4].noOfJointPartcpnt__c != null ? associatedPrincipals02[4].noOfJointPartcpnt__c : '';

            EntityP21.APPENTBUR.CONSINPNATID = accPrincipal2.ID_Number__pc != null ? String.valueof(accPrincipal2.ID_Number__pc) : null;
			EntityP21.APPENTIDTYPE = getTranslatedValue(accPrincipal2.ID_Type__pc == null || accPrincipal2.ID_Type__pc == '' ? accPrincipal2.ID_Type__c : accPrincipal2.ID_Type__pc);
            EntityP21.APPENTSHAREHOLDINGPERC = mapPrinPerc?.get('EntityP02') != null ? mapPrinPerc?.get('EntityP02') : '0';
            EntityP21.APPENTMNTHSSHAREHOLDINGPERC = accPrincipal2?.Months_Since_Shareholding__c != null ? String.valueof(accPrincipal2?.Months_Since_Shareholding__c).substringBefore('.') : '0';
			EntityP21.INTENTCLIENTTYPE = getTranslatedValue(accPrincipal2?.Client_Type__c);
            EntityP21.INTENTNONRESIDENT = ((accPrincipal2?.Is_the_Client_a_Non_resident__c || accPrincipal2?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');

			EntityP21 = getAccountDetails(accPrincipal2, EntityP21);
			string clientNameApp2 = '';
			if (appProfile2 != null && appProfile2.size() > 0) {
				clientNameApp2 = appProfile2[0]?.Client_Name__c;
			}
			EntityP21 = getExposuresRisk(accPrincipal2.CIF__c, clientNameApp2, appExRisk, application.Id, EntityP21,clientCodeRegNoMap);
			EntityP21 = getExposures(accPrincipal2.CIF__c, clientNameApp2, appEx, application.Id, EntityP21);
			EntityP21 = getCashAndInvestments(accPrincipal2.CIF__c,clientNameApp2, appExCash, application.Id, EntityP21,clientCodeRegNoMap);
			EntityP21 = getTriads(accPrincipal2.CIF__c, appTriadList, application.Id, EntityP21);

			//EntityP21 = getFacilities(accPrincipal2.CIF__c, appExFin, application.Id, EntityP21);

			//using the client name as the unique identifier and not the CIF code
			EntityP21 = getFacilities(MainPrin2AppProfileRec.Client_Name__c , appExFin, application.Id, EntityP21);
			EntityP21 = getFinancialConduct(appFinConList, application.Id, EntityP21);
			requestBean.Request.ApplicationDV.Entity04 = EntityP21;

			//For Main Principal 3
			PowerCurveNewApplication_Req_IB_v1.Entity01 EntityP31 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
			EntityP31.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
			EntityP31.INTENTNUMPARTICIPANTS1 = MainPrin3AppProfileRec.noOfJointPartcpnt__c != null ? MainPrin3AppProfileRec.noOfJointPartcpnt__c : '';
			EntityP31.INTENTUNDERJUDICIALMNGMNT = MainPrin3AppProfileRec.curatorshipHold__c != null ? MainPrin3AppProfileRec.curatorshipHold__c : '';
			EntityP31.INTENTFINANCIALCRIMEHOLD = MainPrin3AppProfileRec.finCrimeHold__c != null ? MainPrin3AppProfileRec.finCrimeHold__c : '';
			EntityP31.INTENTUNDERDEBTCOUNSELLING = MainPrin3AppProfileRec.applyDebtCounsel__c != null ? MainPrin3AppProfileRec.applyDebtCounsel__c : '';
			EntityP31.INTENTCLIENTCODE2 = associatedPrincipals03.size() > 0 && associatedPrincipals03[0].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals03[0].Client_CIF_Code__c) : '';
			EntityP31.INTENTNUMPARTICIPANTS2 = associatedPrincipals03.size() > 0 && associatedPrincipals03[0].noOfJointPartcpnt__c != null ? associatedPrincipals03[0].noOfJointPartcpnt__c : '';
			EntityP31.INTENTCLIENTCODE3 = associatedPrincipals03.size() > 1 && associatedPrincipals03[1].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals03[1].Client_CIF_Code__c) : '';
			EntityP31.INTENTNUMPARTICIPANTS3 = associatedPrincipals03.size() > 1 && associatedPrincipals03[1].noOfJointPartcpnt__c != null ? associatedPrincipals03[1].noOfJointPartcpnt__c : '';
			EntityP31.INTENTCLIENTCODE4 = associatedPrincipals03.size() > 2 && associatedPrincipals03[2].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals03[2].Client_CIF_Code__c) : '';
			EntityP31.INTENTNUMPARTICIPANTS4 = associatedPrincipals03.size() > 2 && associatedPrincipals03[2].noOfJointPartcpnt__c != null ? associatedPrincipals03[2].noOfJointPartcpnt__c : '';
			EntityP31.INTENTCLIENTCODE5 = associatedPrincipals03.size() > 3 && associatedPrincipals03[3].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals03[3].Client_CIF_Code__c) : '';
			EntityP31.INTENTNUMPARTICIPANTS5 = associatedPrincipals03.size() > 3 && associatedPrincipals03[3].noOfJointPartcpnt__c != null ? associatedPrincipals03[3].noOfJointPartcpnt__c : '';
			EntityP31.INTENTCLIENTCODE6 = associatedPrincipals03.size() > 4 && associatedPrincipals03[4].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals03[4].Client_CIF_Code__c) : '';
			EntityP31.INTENTNUMPARTICIPANTS6 = associatedPrincipals03.size() > 4 && associatedPrincipals03[4].noOfJointPartcpnt__c != null ? associatedPrincipals03[4].noOfJointPartcpnt__C : '';

			EntityP31.APPENTBUR.CONSINPNATID = accPrincipal3.ID_Number__pc != null ? String.valueof(accPrincipal3.ID_Number__pc) : null;
			EntityP31.APPENTIDTYPE = getTranslatedValue(accPrincipal3.ID_Type__pc == null || accPrincipal3.ID_Type__pc == '' ? accPrincipal3.ID_Type__c : accPrincipal3.ID_Type__pc);
            EntityP31.APPENTSHAREHOLDINGPERC = mapPrinPerc?.get('EntityP03') != null ? mapPrinPerc?.get('EntityP03') : '0';
            EntityP31.APPENTMNTHSSHAREHOLDINGPERC = accPrincipal3?.Months_Since_Shareholding__c != null ? String.valueof(accPrincipal3?.Months_Since_Shareholding__c).subStringBefore('.') : '0';
			EntityP31.INTENTCLIENTTYPE = getTranslatedValue(accPrincipal3?.Client_Type__c);
            EntityP31.INTENTNONRESIDENT = ((accPrincipal3?.Is_the_Client_a_Non_resident__c || accPrincipal3?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');

			string clientNameApp = '';
			if (appProfile3 != null && appProfile3.size() > 0) {
				clientNameApp = appProfile3[0]?.Client_Name__c;
			}
			EntityP31 = getAccountDetails(accPrincipal3, EntityP31);
			EntityP31 = getExposuresRisk(accPrincipal3.CIF__c, clientNameApp, appExRisk, application.Id, EntityP31,clientCodeRegNoMap);
			EntityP31 = getExposures(accPrincipal3.CIF__c, clientNameApp, appEx, application.Id, EntityP31);
			EntityP31 = getCashAndInvestments(accPrincipal3?.CIF__c,clientNameApp, appExCash, application.Id, EntityP31,clientCodeRegNoMap);
			EntityP31 = getTriads(accPrincipal3.CIF__c, appTriadList, application.Id, EntityP31);

			//EntityP31 = getFacilities(accPrincipal3.CIF__c, appExFin, application.Id, EntityP31);

			//using the client name as the unique identifier and not the CIF code
			EntityP31 = getFacilities(MainPrin3AppProfileRec.Client_Name__c, appExFin, application.Id, EntityP31);

			EntityP31 = getFinancialConduct(appFinConList, application.Id, EntityP31);
			requestBean.Request.ApplicationDV.Entity05 = EntityP31;

			//For Main Principal 4
			PowerCurveNewApplication_Req_IB_v1.Entity01 EntityP41 = new PowerCurveNewApplication_Req_IB_v1.Entity01();
			EntityP41.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
			EntityP41.INTENTNUMPARTICIPANTS1 = MainPrin4AppProfileRec.noOfJointPartcpnt__c != null ? MainPrin4AppProfileRec.noOfJointPartcpnt__c : '';
			EntityP41.INTENTUNDERJUDICIALMNGMNT = MainPrin4AppProfileRec.curatorshipHold__c != null ? MainPrin4AppProfileRec.curatorshipHold__c : '';
			EntityP41.INTENTFINANCIALCRIMEHOLD = MainPrin4AppProfileRec.finCrimeHold__c != null ? MainPrin4AppProfileRec.finCrimeHold__c : '';
			EntityP41.INTENTUNDERDEBTCOUNSELLING = MainPrin4AppProfileRec.applyDebtCounsel__c != null ? MainPrin4AppProfileRec.applyDebtCounsel__c : '';
			EntityP41.INTENTCLIENTCODE2 = associatedPrincipals04.size() > 0 && associatedPrincipals04[0].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals04[0].Client_CIF_Code__c) : '';
			EntityP41.INTENTNUMPARTICIPANTS2 = associatedPrincipals04.size() > 0 && associatedPrincipals04[0].noOfJointPartcpnt__c != null ? associatedPrincipals04[0].noOfJointPartcpnt__c : '';
			EntityP41.INTENTCLIENTCODE3 = associatedPrincipals04.size() > 1 && associatedPrincipals04[1].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals04[1].Client_CIF_Code__c) : '';
			EntityP41.INTENTNUMPARTICIPANTS3 = associatedPrincipals04.size() > 1 && associatedPrincipals04[1].noOfJointPartcpnt__c != null ? associatedPrincipals04[1].noOfJointPartcpnt__c : '';
			EntityP41.INTENTCLIENTCODE4 = associatedPrincipals04.size() > 2 && associatedPrincipals04[2].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals04[2].Client_CIF_Code__c) : '';
			EntityP41.INTENTNUMPARTICIPANTS4 = associatedPrincipals04.size() > 2 && associatedPrincipals04[2].noOfJointPartcpnt__c != null ? associatedPrincipals04[2].noOfJointPartcpnt__c : '';
			EntityP41.INTENTCLIENTCODE5 = associatedPrincipals04.size() > 3 && associatedPrincipals04[3].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals04[3].Client_CIF_Code__c) : '';
			EntityP41.INTENTNUMPARTICIPANTS5 = associatedPrincipals04.size() > 3 && associatedPrincipals04[3].noOfJointPartcpnt__c != null ? associatedPrincipals04[3].noOfJointPartcpnt__c : '';
			EntityP41.INTENTCLIENTCODE6 = associatedPrincipals04.size() > 4 && associatedPrincipals04[4].Client_CIF_Code__c != null ? String.valueof(associatedPrincipals04[4].Client_CIF_Code__c) : '';
			EntityP41.INTENTNUMPARTICIPANTS6 = associatedPrincipals04.size() > 4 && associatedPrincipals04[4].noOfJointPartcpnt__c != null ? associatedPrincipals04[4].noOfJointPartcpnt__c : '';

            EntityP41.APPENTBUR.CONSINPNATID = accPrincipal4.ID_Number__pc != null ? String.valueof(accPrincipal4.ID_Number__pc) : null;
			EntityP41.APPENTIDTYPE = getTranslatedValue(accPrincipal4.ID_Type__pc == null || accPrincipal4.ID_Type__pc == '' ? accPrincipal4.ID_Type__c : accPrincipal4.ID_Type__pc);
            EntityP41.APPENTSHAREHOLDINGPERC = mapPrinPerc?.get('EntityP04') != null ? mapPrinPerc?.get('EntityP04') : '0';
            EntityP41.APPENTMNTHSSHAREHOLDINGPERC = accPrincipal4?.Months_Since_Shareholding__c != null ? String.valueof(accPrincipal4?.Months_Since_Shareholding__c).substringBefore('.') : '0';
			EntityP41.INTENTCLIENTTYPE = getTranslatedValue(accPrincipal4?.Client_Type__c);
            EntityP41.INTENTNONRESIDENT = ((accPrincipal4?.Is_the_Client_a_Non_resident__c || accPrincipal4?.Is_the_Client_a_Temporary_Resident__c) ? 'Y' : 'N');

			string clientNameApp4 = '';
			if (appProfile4 != null && appProfile4.size() > 0) {
				clientNameApp4 = appProfile4[0].Client_Name__c;
			}
			EntityP41 = getAccountDetails(accPrincipal4, EntityP41);
			EntityP41 = getExposuresRisk(accPrincipal4?.CIF__c, clientNameApp4, appExRisk, application.Id, EntityP41,clientCodeRegNoMap);
			EntityP41 = getExposures(accPrincipal4?.CIF__c, clientNameApp4, appEx, application.Id, EntityP41);
			EntityP41 = getCashAndInvestments(accPrincipal4?.CIF__c,clientNameApp4, appExCash, application.Id, EntityP41,clientCodeRegNoMap);
			EntityP41 = getTriads(accPrincipal4?.CIF__c, appTriadList, application.Id, EntityP41);

			//EntityP41 = getFacilities(accPrincipal4?.CIF__c, appExFin, application.Id, EntityP41);

			//using the client name as the unique identifier and not the CIF code
			EntityP41 = getFacilities(MainPrin4AppProfileRec.Client_Name__c, appExFin, application.Id, EntityP41);

			EntityP41 = getFinancialConduct(appFinConList, application.Id, EntityP41);
			requestBean.Request.ApplicationDV.Entity06 = EntityP41;
		}
		return requestBean;
	}

	/**
	 * @description method to get and map client Account details PCO
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param acc
	 * @param Entity
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getAccountDetails(Account acc, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity) {
		//Account Details
		Entity.INTENTBUR = new PowerCurveNewApplication_Req_IB_v1.INTENTBUR();
		//Entity.APPENTBUR = new PowerCurveNewApplication_Req_IB_v1.APPENTBUR();
		//String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Client Type', acc.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);

		if (acc != null) {
			//Entity.INTENTCLIENTTYPE = clientTypeTranslated != null ? clientTypeTranslated : '';
			Entity.INTENTCLIENTCODE1 = (acc.CIF__c != null ? acc.CIF__c : '');
            //Entity.INTENTNONRESIDENT = (acc.Is_the_Client_a_Non_resident__c ? 'Y' : 'N');

			if (acc.Age__pc != null) {  //refer Age__pc in sit
				String ageYears;
				String ageMonths;
                String agewithoutYears = '' + acc.Age__pc; //String.valueof(acc.Age_years__c).replaceAll('[\\ Years]', '');
				ageYears = agewithoutYears.substringBefore('.') != '' ? Integer.valueof(agewithoutYears.substringBefore('.')) > 9 ? agewithoutYears.substringBefore('.') : '0' + agewithoutYears.substringBefore('.') : '00';
				ageMonths = agewithoutYears.substringAfter('.') != '' ? Integer.valueof(agewithoutYears.substringAfter('.')) > 9 ? agewithoutYears.substringAfter('.') : '0' + agewithoutYears.substringAfter('.') : '00';
				Entity.APPENTAGE = ageYears + ageMonths;
			}
			else {
				Entity.APPENTAGE = '0000';
			}

			Entity.INTENTHIGHLEVELLIMITINDICATOR = 'N';//sending empty String as service not wrapped
			List<AccountContactRelation> accRList = new AccountContactRelationSelector().selectRelationByAccountId(acc.Id);
			AccountContactRelation accR = new AccountContactRelation();
			if (accRList.size() > 0) {
				accR = accRList[0];
			}

			//Entity.APPENTSHAREHOLDINGPERC = accR.Share_Percentage__c != null ? String.valueOf(accR.Share_Percentage__c).substringBefore('.') : '';
			String maritalStatus = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Marital Status', acc.Marital_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
			String maritalContractType = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('CIF', 'Marital Contract Type', acc.Marital_Contract_Type__pc, StringConstants.OUTBOUND_RECORD_TYPE);

			Entity.INTENTMARITALSTATUS = (maritalStatus != null ? maritalStatus : '');
			Entity.INTENTMARITALCONTRACT = (maritalContractType != null ? maritalContractType : '');

			/*if (acc.ID_Number__pc != null) {
				Entity.APPENTBUR.CONSINPNATID = String.valueof(acc.ID_Number__pc);
			}*/
			//Adding check for Trust Accounts Defect - W-011000.
			if (acc.Registration_Number__c != null && acc.Client_Type__c!='Trusts') {
				String strText = String.valueof(acc.Registration_Number__c);
				strText = strText.replaceAll('[^a-zA-Z0-9\\s+]', '');
				Entity.INTENTBUR.COMMINPREGNUMBER = strText; //send blank String when null
			}
			else {
				Entity.INTENTBUR.COMMINPREGNUMBER = '';
			}

            Entity.INTENTINSOLVENT = (acc.Client_ever_been_declared_Insolvent__c ? 'Y' : 'N'); //confirm these with Santjie, they are similar
            Entity.APPENTINTENTIONTOINSOLVENCY = (acc.Client_intends_to_declare_insolvency__c ? 'Y' : 'N');
		}
		else {
			throw new AuraHandledException('Error message to display in component');
		}

		return Entity;
	}

	/**
	 * @description method to get and map Exposures Risk to PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-29
	 * @param clientCode
	 * @param name
	 * @param appExRisk
	 * @param applicationId
	 * @param Entity
	 * @param clientCodeRegNoMap
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getExposuresRisk(String clientCode, String name, List<Application_Exposure_Risk__c> appExRisk, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity, Map<String,String> clientCodeRegNoMap) {
		if (clientCode != null && applicationId != null) {
			List<Application_Exposure_Risk__c> expRiskList = new List<Application_Exposure_Risk__c>();
			//Double EWLListing = 0.0, EWLListingCurrent = 0.0;
			/*
			for (Application_Exposure_Risk__c var : appExRisk) {
				if (var.client_code__c == clientCode) {
					expRiskList.add(var);
				}

				if (var.client_name__c == name) {
					EWLListingCurrent = var.Early_Warning_Listing__c == null ? 0 : Double.valueOf(var.Early_Warning_Listing__c);
					if(EWLListingCurrent > EWLListing) {
						EWLListing = EWLListingCurrent;
					}
				}
			}
			*/
			string EWLListing;
            string worstHoldCode;
            string worstCollectionType;
            string busRescue='N';
            string inLiquidation='N';
            string busRescueAffected='N';
            string fraudRisk='N';
			for (Application_Exposure_Risk__c var : appExRisk) {
                if(var.client_code__c==clientCode){
                    EWLListing=var.Worst_risk_PCO__c;
                    worstHoldCode=var.Worst_Risk_Hold__c;
                    worstCollectionType=var.Worst_Risk_Collection__c;
                }
                if(clientCodeRegNoMap.containskey(var.client_code__c) && clientCodeRegNoMap.get(var.client_code__c)==clientCodeRegNoMap.get(clientCode)){
                    if(var.In_Business_Rescue__c=='Y'){
                        busRescue='Y';
                    }
                    if(var.Business_Rescue_Affected_Party__c=='Y'){
                        busRescueAffected='Y';
                     }
                    if(var.In_Liquidation__c=='Y'){
                        inLiquidation='Y';
                    }
                    if(var.Forensic_Fraud_Indicator__c=='Y'){
                        fraudRisk='Y';
                    }
                }
				/*if (var.client_code__c == clientCode) {
					expRiskList.add(var);
				}*/
				/*
				if (var.client_name__c == name) {
					EWLListingCurrent = var.Early_Warning_Listing__c == null ? 0 : Double.valueOf(var.Early_Warning_Listing__c);
					if(EWLListingCurrent > EWLListing) {
						EWLListing = EWLListingCurrent;
					}
				}
				*/
			}

			Application_Exposure_Risk__c expRisk = (expRiskList?.size() > 0 ? expRiskList[0] : new Application_Exposure_Risk__c());
			Entity.INTENTWRSTRISKGRADE = expRisk.Worst_Risk_Grade__c != null ? expRisk.Worst_Risk_Grade__c : '0';
			Entity.INTENTUNDERDEBTCOUNSELLING = expRisk.In_Business_Rescue__c != null ? expRisk.In_Business_Rescue__c : '';
			//Entity.INTENTINLIQUIDATION = expRisk.In_Liquidation__c != null ? expRisk.In_Liquidation__c : '';
			//Entity.INTENTFRAUDRISKMNGMNT = expRisk.Forensic_Fraud_Indicator__c != null ? expRisk.Forensic_Fraud_Indicator__c : '';
			Entity.INTENTINLIQUIDATION = inLiquidation != null ? inLiquidation : '';
			Entity.INTENTFRAUDRISKMNGMNT = fraudRisk != null ? fraudRisk : '';

			if(Entity?.INTENTRDET == null) {
				Entity.INTENTRDET = new PowerCurveNewApplication_Req_IB_v1.INTENTRDET();
			}
            Entity.INTENTRDET.WRSTCOLLRISKTYPE = worstCollectionType != null ? worstCollectionType : '';
            Entity.INTENTRDET.WRSTARMSHOLD = worstHoldCode != null ? worstHoldCode : '';
			Entity.INTENTRDET.INBUSNRESC = busRescue != null ? busRescue : '';
            Entity.INTENTRDET.BUSNRESCAFFECTEDPARTY = busRescueAffected != null ? busRescueAffected : '';
			//Entity.INTENTRDET.INBUSNRESC = expRisk.In_Business_Rescue__c != null ? expRisk.In_Business_Rescue__c : '';
			//Entity.INTENTRDET.BUSNRESCAFFECTEDPARTY = expRisk.Business_Rescue_Affected_Party__c != null ? string.valueOf(expRisk.Business_Rescue_Affected_Party__c).replaceAll('[^.0-9]','') : '';  //W-012596
			//Entity.INTENTRDET.EWLLISTING = expRisk.Worst_risk_PCO__c != null ? string.valueOf(expRisk.Worst_risk_PCO__c).replaceAll('[^.0-9]', '') : '0.0'; //Saurabh : W11619 Removing Charcters
			Entity.INTENTRDET.EWLLISTING = EWLListing != null ? String.valueOf(EWLListing) : '0.0';
		}

		return Entity;
	}

	/**
	 * @description method to get and map Exposures to PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-29
	 * @param clientCode
	 * @param name
	 * @param appEx
	 * @param applicationId
	 * @param Entity
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getExposures(String clientCode, String name, List<Application_Exposure__c> appEx, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity) {
		//Exposures
		//Objects Declaration
		Entity.INTENTEXPO = new PowerCurveNewApplication_Req_IB_v1.INTENTEXPO();
		Entity.INTENTCMTM = new PowerCurveNewApplication_Req_IB_v1.INTENTCMTM();
		Entity.INTENTARRS = new PowerCurveNewApplication_Req_IB_v1.INTENTARRS();
		Entity.INTENTEXCS = new PowerCurveNewApplication_Req_IB_v1.INTENTEXCS();
		Entity.INTENTINST = new PowerCurveNewApplication_Req_IB_v1.INTENTARRS();
		Entity.INTENTLMTS = new PowerCurveNewApplication_Req_IB_v1.INTENTLMTS();
		List<Application_Exposure__c> appExposures = new List<Application_Exposure__c>();

		for (Application_Exposure__c exp : appEx) {
			//if (exp.Client_Code__c != null && exp.Client_Code__c == clientCode) { // No Rob I am not deleting this I might need it or someone else defect W-012338
			if (clientCode != null && exp.Client_Code__c != null &&
				(exp.Client_Code__c == Entity.INTENTCLIENTCODE1 || exp.Client_Code__c == Entity.INTENTCLIENTCODE2
				|| exp.Client_Code__c == Entity.INTENTCLIENTCODE3 || exp.Client_Code__c == Entity.INTENTCLIENTCODE4
				|| exp.Client_Code__c == Entity.INTENTCLIENTCODE5 || exp.Client_Code__c == Entity.INTENTCLIENTCODE6
				|| exp.Client_Code__c == clientCode)) {
				appExposures.add(exp);
			}
		}

		double calcVar;
		for (Application_Exposure__c exp : appExposures) {
			Entity.INTENTEXPO.CONTINGENTLIABILITY = '0';//sending empty String as service not wrapped
			if (exp.Exposure_Data_Type__c == 'Ordinary Credit - Total') {
				calcVar = Entity.INTENTEXPO.ORDCRED != null ? Double.valueof(Entity.INTENTEXPO.ORDCRED) : 0;
				Entity.INTENTEXPO.ORDCRED = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Mortgage Residential') {
				calcVar = Entity.INTENTEXPO.MORTGRES != null ? Double.valueof(Entity.INTENTEXPO.MORTGRES) : 0;
				Entity.INTENTEXPO.MORTGRES = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');

				calcVar = Entity.INTENTCMTM.MORTGRES != null ? Double.valueof(Entity.INTENTCMTM.MORTGRES) : 0;
				Entity.INTENTCMTM.MORTGRES = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Mortgage CPF') {
				calcVar = Entity.INTENTEXPO.MORTGCPF != null ? Double.valueof(Entity.INTENTEXPO.MORTGCPF) : 0;
				Entity.INTENTEXPO.MORTGCPF = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');

				calcVar = Entity.INTENTCMTM.MORTGCPF != null ? Double.valueof(Entity.INTENTCMTM.MORTGCPF) : 0;
				Entity.INTENTCMTM.MORTGCPF = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Mortgage Agriculture') {
				calcVar = Entity.INTENTEXPO.MORTGAGRI != null ? Double.valueof(Entity.INTENTEXPO.MORTGAGRI) : 0;
				Entity.INTENTEXPO.MORTGAGRI = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');

				calcVar = Entity.INTENTCMTM.MORTGAGRI != null ? Double.valueof(Entity.INTENTCMTM.MORTGAGRI) : 0;
				Entity.INTENTCMTM.MORTGAGRI = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Mortgage Total') {
				calcVar = Entity.INTENTEXPO.MORTGTOTAL != null ? Double.valueof(Entity.INTENTEXPO.MORTGTOTAL) : 0;
				Entity.INTENTEXPO.MORTGTOTAL = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');

				calcVar = Entity.INTENTCMTM.MORTGTOTAL != null ? Double.valueof(Entity.INTENTCMTM.MORTGTOTAL) : 0;
				Entity.INTENTCMTM.MORTGTOTAL = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Total Exposure') {
				calcVar = Entity.INTENTEXPO.TOTALDIRECTEXPOSURE != null ? Double.valueof(Entity.INTENTEXPO.TOTALDIRECTEXPOSURE) : 0;
				Entity.INTENTEXPO.TOTALDIRECTEXPOSURE = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');

				calcVar = Entity.INTENTEXPO.TOTALEXPOSURE != null ? Double.valueof(Entity.INTENTEXPO.TOTALEXPOSURE) : 0;
				Entity.INTENTEXPO.TOTALEXPOSURE = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Recovery Exposure') {
				calcVar = Entity.INTENTEXPO.RECOVERYEXPOSURE != null ? Double.valueof(Entity.INTENTEXPO.RECOVERYEXPOSURE) : 0;
				Entity.INTENTEXPO.RECOVERYEXPOSURE = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
			if (exp.Exposure_Data_Type__c == 'Ordinary Credit - Total') {
				calcVar = Entity.INTENTCMTM.ORDCREDIT != null ? Double.valueof(Entity.INTENTCMTM.ORDCREDIT) : 0;
				Entity.INTENTCMTM.ORDCREDIT = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
			}
		}

        for (Application_exposure__c exp : appEx) {
			if(exp.Client_Code__c == null && name == exp.Client_Name__c) {
				if (exp.Exposure_Data_Type__c == 'Other Ordinary Credit') {
					Entity.INTENTARRS.OTHEROC = exp.Arrears__c != null ? exp.Arrears__c.substringBefore('.') : '0';
					Entity.INTENTEXCS.OTHEROC = exp.Excess__c != null ? exp.Excess__c.substringBefore('.') : '0';
					Entity.INTENTINST.OTHEROC = exp.Installment__c != null ? exp.Installment__c.substringBefore('.') : '0';

					calcVar = Entity.INTENTLMTS.OTHEROC != null ? Double.valueOf(Entity.INTENTLMTS.OTHEROC) : 0;
					Entity.INTENTLMTS.OTHEROC = exp.Limit__c != null ? String.ValueOf(Double.valueof(exp.Limit__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
				}
				if (exp.Exposure_Data_Type__c == 'Loans') {
					Entity.INTENTARRS.TL = exp.Arrears__c != null ? String.ValueOf(Double.valueof(exp.Arrears__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTINST.TL = exp.Installment__c != null ? String.ValueOf(Double.valueof(exp.Installment__c).longValue()).substringBefore('.') : '0';
				}
				if (exp.Exposure_Data_Type__c == 'Cheques') {
					Entity.INTENTEXCS.CHEQACCS = exp.Excess__c != null ? String.ValueOf(Double.valueof(exp.Excess__c).longValue()).substringBefore('.') : '0';

					calcVar = Entity.INTENTLMTS.CHEQ != null ? Double.valueOf(Entity.INTENTLMTS.CHEQ) : 0;
					Entity.INTENTLMTS.CHEQ = exp.Limit__c != null ? String.ValueOf(Double.valueof(exp.Limit__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
				}
				if (exp.Exposure_Data_Type__c == 'Credit Card') {
					Entity.INTENTARRS.CC = exp.Arrears__c != null ? String.ValueOf(Double.valueof(exp.Arrears__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTEXCS.CC = exp.Excess__c != null ? String.ValueOf(Double.valueof(exp.Excess__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTINST.CC = exp.Installment__c != null ? String.ValueOf(Double.valueof(exp.Installment__c).longValue()).substringBefore('.') : '0';

					calcVar = Entity.INTENTLMTS.CC != null ? Double.valueOf(Entity.INTENTLMTS.CC) : 0;
					Entity.INTENTLMTS.CC = exp.Limit__c != null ? String.ValueOf(Double.valueof(exp.Limit__c).longValue() + calcVar.longValue()).substringBefore('.') : String.ValueOf(calcVar.longValue()).substringBefore('.');
				}
				if (exp.Exposure_Data_Type__c == 'Asset Finance') {
					Entity.INTENTEXPO.ASSETFINANCE = exp.Exposure__c != null ? String.ValueOf(Double.valueof(exp.Exposure__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTCMTM.ASSETFINANCE = exp.Liability__c != null ? String.ValueOf(Double.valueof(exp.Liability__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTARRS.ASSETFINANCE = exp.Arrears__c != null ? String.ValueOf(Double.valueof(exp.Arrears__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTINST.ASSETFINANCE = exp.Installment__c != null ? String.ValueOf(Double.valueof(exp.Installment__c).longValue()).substringBefore('.') : '0';
				}
				if (exp.Exposure_Data_Type__c == 'Mortgage Loans') {
					Entity.INTENTARRS.ML = exp.Arrears__c != null ? String.ValueOf(Double.valueof(exp.Arrears__c).longValue()).substringBefore('.') : '0';
					Entity.INTENTINST.ML = exp.Installment__c != null ? String.ValueOf(Double.valueof(exp.Installment__c).longValue()).substringBefore('.') : '0';
				}
			}
        }
		return Entity;
	}

	/**
	 * @description method to get and map Cash And Investments to PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-29
	 * @param clientCode
	 * @param ClientName
	 * @param appExCash
	 * @param applicationId
	 * @param Entity
	 * @param clientCodeRegNoMap
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getCashAndInvestments(String clientCode,String ClientName, List<Application_Exposure_Cash_and_Investment__c> appExCash, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity, Map<String,String> clientCodeRegNoMap) {
		//Cash and Investments
		Long TotalSavings = 0;
        Long TotalCHEQS = 0;
        Long TotalNOTICEDEPOSITS = 0;
        Long TotalTERMDEPOSITS = 0;
        Long TotalCUSTINVESTMENTS = 0;
		List<Application_Exposure_Cash_and_Investment__c> appCashList = new List<Application_Exposure_Cash_and_Investment__c>();
		for (Application_Exposure_Cash_and_Investment__c var : appExCash) {
            if(clientCodeRegNoMap.containskey(var.client_code__c) && clientCodeRegNoMap.get(var.client_code__c)==clientCodeRegNoMap.get(clientCode)){
               TotalSavings += Long.valueof(String.valueof(var.Savings__c != null?var.Savings__c:0));
               TotalCHEQS += Long.valueof(String.valueof(var.Cheque_In_Credit__c != null?var.Cheque_In_Credit__c:0));
               TotalNOTICEDEPOSITS += Long.valueof(String.valueof(var.Notice_of_Deposits__c != null?var.Notice_of_Deposits__c:0));
               TotalTERMDEPOSITS += Long.valueof(String.valueof(var.Term_Deposits__c != null?var.Term_Deposits__c:0));
               TotalCUSTINVESTMENTS += Long.valueof(String.valueof(var.Customer_Investment_Account__c != null?var.Customer_Investment_Account__c:0));
            }
			if (var.client_code__c == clientCode) {
				appCashList.add(var);
			}
		}
		if (appCashList.size() > 0) {
			Application_Exposure_Cash_and_Investment__c appCash = appCashList[0];
			//Entity.INTENTCTBALANCECHEQS = appCashList[0].Cheque_In_Credit__c != null ? String.valueof(appCashList[0].Cheque_In_Credit__c).substringBefore('.') : '0';
			Entity.INTENTCTBALANCECHEQS = TotalCHEQS!=null ? String.valueof(TotalCHEQS).substringBefore('.') : '0';
            //Entity.INTENTCTBALANCESAVINGS = appCashList[0].Savings__c != null ? String.valueof(appCashList[0].Savings__c).substringBefore('.') : '0';
			Entity.INTENTCTBALANCESAVINGS = TotalSavings!=null ? String.valueof(TotalSavings).substringBefore('.') : '0';
			Entity.INTENTCTBALANCENOTICEDEPOSITS = TotalNOTICEDEPOSITS!=null ? String.valueof(TotalNOTICEDEPOSITS).substringBefore('.') : '0';
            //Entity.INTENTCTBALANCENOTICEDEPOSITS = appCashList[0].Notice_of_Deposits__c != null ? String.valueof(appCashList[0].Notice_of_Deposits__c).substringBefore('.') : '0';
			Entity.INTENTCTBALANCETERMDEPOSITS = TotalTERMDEPOSITS!=null ? String.valueof(TotalTERMDEPOSITS).substringBefore('.') : '0';
            //Entity.INTENTCTBALANCETERMDEPOSITS = appCashList[0].Term_Deposits__c != null ? String.valueof(appCashList[0].Term_Deposits__c).substringBefore('.') : '0';
			Entity.INTENTCTBALANCECUSTINVESTMENTS = TotalCUSTINVESTMENTS!=null ? String.valueof(TotalCUSTINVESTMENTS).substringBefore('.') : '0';
            //Entity.INTENTCTBALANCECUSTINVESTMENTS = appCashList[0].Customer_Investment_Account__c != null ? String.valueof(appCashList[0].Customer_Investment_Account__c).substringBefore('.') : '0';
		}
		Entity.INTENTCTBALANCECASHCOVER = '0';

		return Entity;
	}

	/**
	 * @description method to get and map Triads to PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-29
	 * @param clientCode
	 * @param appTriads
	 * @param applicationId
	 * @param Entity
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getTriads(String clientCode, List<Application_Triad__c> appTriads, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity) {
		//Triad
		List<Application_Triad__c> appTriadList = new List<Application_Triad__c>();
		Decimal sumNumDebitsL6M = 0;

		for (Application_Triad__c var : appTriads) {
			if (var.client_code__c == clientCode) {
				appTriadList.add(var);

				List<Application_Triad_Detail__c> apptdlst = new ApplicationTriadDetailsSelector().getDetailsByApplicationTriadID(var.Id);

				if(apptdlst?.size() > 0) {
					Integer count = 0;
					for (Application_Triad_Detail__c apptd : apptdlst) {
						count++;
						Decimal numDebChq = apptd.Number_of_Debits_Cheques__c == null ? 0 : apptd.Number_of_Debits_Cheques__c;
						Decimal numDebDep = apptd.Number_of_Debits_Deposits__c == null ? 0 : apptd.Number_of_Debits_Deposits__c;
						sumNumDebitsL6M += (numDebChq + numDebDep);

						//get only info for last six months from latest month
						if(count >= 6) {
							break;
						}
					}
				}
			}
		}

		Application_Triad__c appTriad;
		if (appTriadList.size() > 0) {
			appTriad = appTriadList[0];
			String exclusionTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('Triad', 'Triad Exclusion Type', appTriad.Triad_Exclusion_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
			Entity.INTENTTRID = new PowerCurveNewApplication_Req_IB_v1.INTENTTRID();

			if (appTriad.Months_Since_Oldest_Relationship__c > 999) {
				Entity.INTENTTRID.MNTHSOLDESTCUSTREL = '999';
			}
			else {
				Entity.INTENTTRID.MNTHSOLDESTCUSTREL = appTriad.Months_Since_Oldest_Relationship__c != null ? String.valueof(appTriad.Months_Since_Oldest_Relationship__c).substringBefore('.') : '0';
			}
			if (appTriad.Months_Since_Oldest_Account__c > 999) {
				Entity.INTENTTRID.MNTHSOLDESTACCREL = '999';
			}
			else {
				Entity.INTENTTRID.MNTHSOLDESTACCREL = appTriad.Months_Since_Oldest_Account__c != null ? String.valueof(appTriad.Months_Since_Oldest_Account__c).substringBefore('.') : '0';
			}
			if (appTriad.Months_Since_Oldest_Cheque_Account__c > 999) {
				Entity.INTENTTRID.MNTHSOLDESTCHACCREL = '999';
			}
			else {
				Entity.INTENTTRID.MNTHSOLDESTCHACCREL = appTriad.Months_Since_Oldest_Cheque_Account__c != null ? String.valueof(appTriad.Months_Since_Oldest_Cheque_Account__c).substringBefore('.') : '0';
			}
			if (appTriad.Months_Since_Oldest_Savings_Account__c > 999) {
				Entity.INTENTTRID.MNTHSOLDESTSAVACCREL = '999';
			}
			else {
				Entity.INTENTTRID.MNTHSOLDESTSAVACCREL = appTriad.Months_Since_Oldest_Savings_Account__c != null ? String.valueof(appTriad.Months_Since_Oldest_Savings_Account__c).substringBefore('.') : '0';
			}

			Entity.APPENTAGEOLDESTRELATIONSHIP = appTriad.Months_Since_Oldest_Relationship__c != null ? String.valueof(appTriad.Months_Since_Oldest_Relationship__c) : '';
			Entity.INTENTTRID.EXCLUSIONTYPE = exclusionTypeTranslated != null ? exclusionTypeTranslated : '';
			Entity.INTENTTRID.EXCLUSIONCREDITFACILITY = appTriad.Credit_Facility_Exclusion__c != null ? appTriad.Credit_Facility_Exclusion__c : '';
			Entity.INTENTTRID.EXCLUSIONREASON = appTriad.Triad_Exclusion_Reason__c != null ? appTriad.Triad_Exclusion_Reason__c : '';

			if (appTriad.Customer_Alignment_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCORECUSTALIGN = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCORECUSTALIGN = appTriad.Customer_Alignment_Score__c != null ? String.valueof(appTriad.Customer_Alignment_Score__c) : '0';
			}
			if (appTriad.Cheque_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCORECHEQ = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCORECHEQ = appTriad.Cheque_Score__c != null ? String.valueof(appTriad.Cheque_Score__c) : '0';
			}
			if (appTriad.Credit_Card_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCORECC = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCORECC = appTriad.Credit_Card_Score__c != null ? String.valueof(appTriad.Credit_Card_Score__c) : '0';
			}
			if (appTriad.Mortgage_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCOREMORTG = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCOREMORTG = appTriad.Mortgage_Score__c != null ? String.valueof(appTriad.Mortgage_Score__c) : '0';
			}
			if (appTriad.AVAF_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCOREAVAF = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCOREAVAF = appTriad.AVAF_Score__c != null ? String.valueof(appTriad.AVAF_Score__c) : '0';
			}
			if (appTriad.Loan_Score__c > 999) {
				Entity.INTENTTRID.BEHAVSCORELOANS = '999';
			}
			else {
				Entity.INTENTTRID.BEHAVSCORELOANS = appTriad.Loan_Score__c != null ? String.valueof(appTriad.Loan_Score__c) : '0';
			}

			Entity.INTENTTRID.EXPECTEDCREDTURNOVCHEQ = '0';
			Entity.INTENTTRID.EXPECTEDCREDTURNOVCUST = '0';

			//Changing after confirmation from SA
			if (appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c > 999) {
				Entity.INTENTTRID.AVGCTOL3ML6M = '999.99';
			}
			else {
				Entity.INTENTTRID.AVGCTOL3ML6M = appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c != null ? String.valueof(appTriad.Average_Credit_TurnOver_Last_3_6_Mth__c) : '0';
			}
			if (appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c > 999) {
				Entity.INTENTTRID.AVGCTOL6ML12M = '999.99';
			}
			else {
				Entity.INTENTTRID.AVGCTOL6ML12M = appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c != null ? String.valueof(appTriad.Average_Credit_TurnOver_Last_6_12_Mth__c) : '0';
			}

			if (appTriad.Days_in_Credit_last_6_mth__c != null && appTriad.Days_in_Credit_last_6_mth__c > 999) {
				Entity.INTENTTRID.NUMDAYSCREDITINL6M = '999';
			}
			else {
				Entity.INTENTTRID.NUMDAYSCREDITINL6M = appTriad.Days_in_Credit_last_6_mth__c != null ? String.valueof(appTriad.Days_in_Credit_last_6_mth__c).substringBefore('.') : '0';
			}
			if (appTriad.Days_in_Debit_last_6_mth__c != null && appTriad.Days_in_Debit_last_6_mth__c > 999) {
				Entity.INTENTTRID.NUMDAYSDEBITINL6M = '999';
			}
			else {
				Entity.INTENTTRID.NUMDAYSDEBITINL6M = appTriad.Days_in_Debit_last_6_mth__c != null ? String.valueof(appTriad.Days_in_Debit_last_6_mth__c).substringBefore('.') : '0';
			}

			if (sumNumDebitsL6M > 999) {
				Entity.INTENTTRID.NUMDEBITSL6M = '999';
			}
			else {
				Entity.INTENTTRID.NUMDEBITSL6M = String.valueof(sumNumDebitsL6M).substringBefore('.');
				//Entity.INTENTTRID.NUMDEBITSL6M = appTriad.Number_of_Debits_Cheques_value__c != null ? String.valueof(appTriad.Number_of_Debits_Cheques_value__c).substringBefore('.') : '0';
			}

			Entity.INTENTTRID.NUMMNTHSEXCESSBALL6M = appTriad.Months_in_Excess_last_6_mth__c != null ? String.valueof(appTriad.Months_in_Excess_last_6_mth__c).substringBefore('.') : '0';
			if (appTriad.Maximum_Consecutive_Days_in_Excess__c > 999) {
				Entity.INTENTTRID.MAXCONSECDAYSINEXCESS = '999';
			}
			else {
				Entity.INTENTTRID.MAXCONSECDAYSINEXCESS = appTriad.Maximum_Consecutive_Days_in_Excess__c != null ? String.valueof(appTriad.Maximum_Consecutive_Days_in_Excess__c).substringBefore('.') : '0';
			}

			Entity.INTENTTRID.MAXOCSCORINGMANDATE = appTriad.Maximum_Ordinary_Credit_Exposure_Capped__c != null ? String.valueof(appTriad.Maximum_Ordinary_Credit_Exposure_Capped__c).substringBefore('.') : '0';
			Entity.INTENTTRID.AOL = appTriad.Additional_Overdraft_Limit__c != null ? String.valueof(appTriad.Additional_Overdraft_Limit__c).substringBefore('.') : '0';
			Entity.INTENTTRID.ACCL = appTriad.Additional_Credit_Card_Limit__c != null ? String.valueof(appTriad.Additional_Credit_Card_Limit__c).substringBefore('.') : '0';
			Entity.INTENTTRID.AMLR = appTriad.Additional_Monthly_Loan_Repayment__c != null ? String.valueof(appTriad.Additional_Monthly_Loan_Repayment__c).substringBefore('.') : '0';
			Entity.INTENTTRID.ABRA = appTriad.Additional_Asset_Finance_Repayment__c != null ? String.valueof(appTriad.Additional_Asset_Finance_Repayment__c).substringBefore('.') : '0';
			Entity.INTENTTRID.AMMR = appTriad.Additional_Monthly_Mortgage_Repayment__c != null ? String.valueof(appTriad.Additional_Monthly_Mortgage_Repayment__c).substringBefore('.') : '0';
			Entity.INTENTTRID.AMR = appTriad.Additional_Monthly_Repayment__c != null ? String.valueof(appTriad.Additional_Monthly_Repayment__c).substringBefore('.') : '0';

			if (appTriad.Total_Savings_RD_last_3_mth__c > 999) {
				Entity.INTENTTRID.NUMRDEVENTSSAVL3M = '999';
			}
			else {
				Entity.INTENTTRID.NUMRDEVENTSSAVL3M = appTriad.Total_Savings_RD_last_3_mth__c != null ? String.valueof(appTriad.Total_Savings_RD_last_3_mth__c).substringBefore('.') : '0';
			}
			if (appTriad.Total_Savings_RD_last_6_mth__c > 999) {
				Entity.INTENTTRID.NUMRDEVENTSSAVL6M = '999';
			}
			else {
				Entity.INTENTTRID.NUMRDEVENTSSAVL6M = appTriad.Total_Savings_RD_last_6_mth__c != null ? String.valueof(appTriad.Total_Savings_RD_last_6_mth__c).substringBefore('.') : '0';
			}
			if (appTriad.Total_Cheque_RD_last_3_mth__c > 999) {
				Entity.INTENTTRID.NUMRDEVENTSCHEQL3M = '999';
			}
			else {
				Entity.INTENTTRID.NUMRDEVENTSCHEQL3M = appTriad.Total_Cheque_RD_last_3_mth__c != null ? String.valueof(appTriad.Total_Cheque_RD_last_3_mth__c).substringBefore('.') : '0';
			}
			if (appTriad.Total_Cheque_RD_last_6_mth__c > 999) {
				Entity.INTENTTRID.NUMRDEVENTSCHEQL6M = '999';
			}
			else {
				Entity.INTENTTRID.NUMRDEVENTSCHEQL6M = appTriad.Total_Cheque_RD_last_6_mth__c != null ? String.valueof(appTriad.Total_Cheque_RD_last_6_mth__c).substringBefore('.') : '0';
			}
			if (appTriad.Returned_Items_Value_Savings_value__c > 999) {
				Entity.INTENTTRID.TOTSAVRETPAYMNTSL6M = '999';
			}
			else {
				Entity.INTENTTRID.TOTSAVRETPAYMNTSL6M = appTriad.Returned_Items_Value_Savings_value__c != null ? String.valueof(appTriad.Returned_Items_Value_Savings_value__c) : '';
			}
			if (appTriad.Returned_Items_Value_Cheques_value__c > 999) {
				Entity.INTENTTRID.TOTCHEQRETPAYMNTSL6M = '999';
			}
			else {
				Entity.INTENTTRID.TOTCHEQRETPAYMNTSL6M = appTriad.Returned_Items_Value_Cheques_value__c != null ? String.valueof(appTriad.Returned_Items_Value_Cheques_value__c) : '';
			}

			Entity.INTENTTRID.EXPECTEDCREDTURNOVCHEQ = appTriad.ECTO_Cheque_Monthly_Avg_Last_12_Mth__c != null ? String.valueof(appTriad.ECTO_Cheque_Monthly_Avg_Last_12_Mth__c).substringBefore('.') : '0';
			Entity.INTENTTRID.EXPECTEDCREDTURNOVCUST = appTriad.ECTO_Monthly_Avg_Last_12_Mth__c != null ? String.valueof(appTriad.ECTO_Monthly_Avg_Last_12_Mth__c).substringBefore('.') : '0';
		}
		return Entity;
	}

	/**
	 * @description method to get clien non scored facilities
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2020-09-29
	 * @param clientName
	 * @param appFac
	 * @param applicationId
	 * @param Entity
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getFacilities(String clientName, List<Application_Exposure_Facility__c> appFac, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity) {
		//Application Exposure Facility
		List<Application_Exposure_Facility__c> appExFacList = new List<Application_Exposure_Facility__c>();
		for (Application_Exposure_Facility__c var : appFac) {
			if (var.Client_Name__c == clientName) {
				appExFacList.add(var);
			}
		}

		decimal nonScoredInstallmentsOCTotal = 0;
		decimal nonScoredInstallmentsAFTotal = 0;
		decimal nonScoredInstallmentsMFTotal = 0;
		decimal nonScoredExposuresOCTotal = 0;
		decimal nonScoredExposuresAFTotal = 0;
		decimal nonScoredExposuresMFTotal = 0;

		if (appExFacList?.size() > 0) {

			Entity.APPENTEXPO = new PowerCurveNewApplication_Req_IB_v1.APPENTEXPO();
			Entity.APPENTAPRF = new PowerCurveNewApplication_Req_IB_v1.APPENTAPRF();

			for (Application_Exposure_Facility__c fac : appExFacList) {
				if (fac.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Retail') {
					nonScoredInstallmentsOCTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
					nonScoredExposuresOCTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
				}
				else if (fac.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Business Bank') {
					nonScoredInstallmentsOCTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
					nonScoredExposuresOCTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
				}
				else if (fac.Approved_Facility__c == 'Settlement Limits Approved') {
					Entity.APPENTEXPO.SETTLEMENTLIMITS = fac.Exposure_Non_Scored__c != null ? String.valueof(fac.Exposure_Non_Scored__c).substringBefore('.') : '0';
				}
				else if (fac.Approved_Facility__c == 'Approved Facilities Asset Finance - Business Bank') {
					nonScoredExposuresAFTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
					nonScoredInstallmentsAFTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
				}
				else if (fac.Approved_Facility__c == 'Approved Facilities Asset Finance - Retail') {
					nonScoredExposuresAFTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
					nonScoredInstallmentsAFTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
				}
				else if (fac.Approved_Facility__c == 'Approved Mortgage Facilities - Business Bank') {
					nonScoredExposuresMFTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
					nonScoredInstallmentsMFTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
				}
				else if (fac.Approved_Facility__c == 'Approved Mortgage Facilities - Retail') {
					nonScoredExposuresMFTotal += fac.Exposure_Non_Scored__c != null ? fac.Exposure_Non_Scored__c : 0;
					nonScoredInstallmentsMFTotal += fac.Installments_Non_Scored__c != null ? fac.Installments_Non_Scored__c : 0;
				}
			}

			Entity.APPENTEXPO.APPRFACILITIESODNONSCR = nonScoredExposuresOCTotal != 0 && nonScoredExposuresOCTotal != null ? String.valueof(nonScoredExposuresOCTotal).substringBefore('.') : '0';
			Entity.APPENTEXPO.APPRFACILITIESAFINNONSCR = nonScoredExposuresAFTotal != 0 && nonScoredExposuresAFTotal != null ? String.valueof(nonScoredExposuresAFTotal).substringBefore('.') : '0';
			Entity.APPENTEXPO.APPRFACILITIESMLNONSCR = nonScoredExposuresMFTotal != 0 && nonScoredExposuresMFTotal != null ? String.valueOf(nonScoredExposuresMFTotal).substringBefore('.') : '0';
			Entity.APPENTAPRF.INSTORDCREDNONSCORED = nonScoredInstallmentsOCTotal != 0 && nonScoredInstallmentsOCTotal != null ? String.valueof(nonScoredInstallmentsOCTotal).substringBefore('.') : '0';
			Entity.APPENTAPRF.INSTASSETFINNONSCORED = nonScoredInstallmentsAFTotal != 0 && nonScoredInstallmentsAFTotal != null ? String.valueOf(nonScoredInstallmentsAFTotal).substringBefore('.') : '0';
			Entity.APPENTAPRF.INSTMLOANNONSCORED = nonScoredInstallmentsMFTotal != 0 && nonScoredInstallmentsMFTotal != null ? String.valueof(nonScoredInstallmentsMFTotal).substringBefore('.') : '0';
		}

		return Entity;
	}

	/**
	 * @description method to get Financial Conduct
	 * @author englarmerdge.mongwe@absa.africa | 2020-09-29
	 * @param appFinConList
	 * @param applicationId
	 * @param Entity
	 * @return PowerCurveNewApplication_Req_IB_v1.Entity01
	**/
	@AuraEnabled
	public static PowerCurveNewApplication_Req_IB_v1.Entity01 getFinancialConduct(List<Application_Financial_Conduct__c> appFinConList, Id applicationId, PowerCurveNewApplication_Req_IB_v1.Entity01 Entity) {
		//Application Financial Conduct
		Application_Financial_Conduct__c appFinCon = appFinConList.size() > 0 ? appFinConList[0] : new Application_Financial_Conduct__c();
		Entity.INTENTCDUCTMAINPYTURNOVER = appFinCon.Previous_Credit_T_O__c != null ? String.valueof(appFinCon.Previous_Credit_T_O__c).substringBefore('.') : '0';

		return Entity;
	}

	/**
	 * @description method to map Existing Requested Products fields to PCO
	 * @author Saurabh.Pandey@absa.africa | 2020-09-29
	 * @param requestBean
	 * @param oppId
	 * @return PowerCurveNewApplication_Req_IB_v1
	**/
	public static PowerCurveNewApplication_Req_IB_v1 mapExistingRequestedProducts(PowerCurveNewApplication_Req_IB_v1 requestBean, String oppId) {
		Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestBean, true));
		Map<String, Object> Request = (Map<String, Object>)untypedMap.get('Request');
		Map<String, Object> ApplicationDV = (Map<String, Object>)Request.get('ApplicationDV');

		//Inner Query to get the related Terms of Business Data
		List<Application_Product__c> prodList = new ApplicationProductSelector().selectByOpportunityIdWithTOB(oppId, true, 'Prime Rate');
		
        Map<String, Application_Product__c> childProductMap = new Map<String, Application_Product__c>();
        Integer requestedCount = 1; Integer existingCount = 1;
		for (Application_Product__c appProduct : prodList) {
			//Creating a Child Map for cheque and Overdraft Product, Will have to revisit once we do more products
			if (appProduct.Application_Product_Parent__c != null) {
				childProductMap.put(appProduct.Application_Product_Parent__c, appProduct);
			}

			//This query will be moved to a selector, it's here just for testing we will have to make map with Application Product and Terms Of business
			///Terms_Of_Business__c termsOfBusiness = [SELECT Id, Existing_Account_Number__c FROM Terms_Of_Business__c WHERE Application_Product__c =: appProduct.Id and Tob_Description__c = 'Prime Rate'];
			String productTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('PowerCurve', 'Product', appProduct.Product_Name__c, StringConstants.OUTBOUND_RECORD_TYPE);
			String limitTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('PowerCurve', 'Overdraft Limit Type', childProductMap.get(appProduct.id)?.Limit_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);

             String paymentType ='';
            if(appProduct.TL_Method_of_Payment__c!=null){
            if(appProduct.TL_Method_of_Payment__c.equalsIgnoreCase('Debit Order')){
                paymentType= 'D';
            }else if(appProduct.TL_Method_of_Payment__c.equalsIgnoreCase('Cash Payment')){
                 paymentType= 'C';
            }
            }
            
			if (appProduct.Product_State__c == 'Existing') {
                PowerCurveNewApplication_Req_IB_v1.ExistingProducts01 ExistingProductObj = new PowerCurveNewApplication_Req_IB_v1.ExistingProducts01();
                ExistingProductObj.INTPRDEXST = new PowerCurveNewApplication_Req_IB_v1.INTPRDEXST();
				ExistingProductObj.APPPRDEXST = new PowerCurveNewApplication_Req_IB_v1.APPPRDEXST();

                ExistingProductObj.INTPRDEXST.PRODUCT = productTranslated != null ? productTranslated : '';//Integration Translation records
                ExistingProductObj.INTPRDEXST.CURRBALANCE = appProduct.Account_Balance__c != null ? String.valueOf(appProduct.Account_Balance__c).substringBefore('.') : '0';
             	ExistingProductObj.INTPRDEXST.CURRINTRATEPRIMEOFFSET = appProduct.Prime_Offset__c != null ? String.valueOf(appProduct.Prime_Offset__c) : '0';

                /* for (Terms_Of_Business__c termsOfBusiness : appProduct.Terms_Of_Business__r) {
                    if (termsOfBusiness.Application_Product__c == appProduct.Id) {
                        ExistingProductObj.INTPRDEXST.CURRINTRATEPRIMEOFFSET = termsOfBusiness.Existing_Account_Number__c != null ? String.valueOf(termsOfBusiness.Existing_Account_Number__c) : '0'; //.substringBefore('.') removed as per bug W: 9569
                    }
                }*/
                // ExistingProductObj.INTPRDEXST.CURRREDUCTIONAMNT = childProductMap.get(appProduct.id)?.Reduction_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Reduction_Amount__c).substringBefore('.') : '0';
                ExistingProductObj.INTPRDEXST.CURRREDUCTIONAMNT = childProductMap.get(appProduct.id)?.Current_Reduction_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Current_Reduction_Amount__c).substringBefore('.') : '0';
                ExistingProductObj.INTPRDEXST.CURRREDUCTIONFREQ = childProductMap.get(appProduct.id)?.Reduction_Frequency__c != null ? childProductMap.get(appProduct.id)?.Reduction_Frequency__c : '0';//API name of picklist value has the translated value
                //ExistingProductObj.INTPRDEXST.CURRONCEOFFREDUCTION = childProductMap.get(appProduct.id)?.Once_Off_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Once_Off_Amount__c).substringBefore('.') : '0';
                ExistingProductObj.INTPRDEXST.CURRONCEOFFREDUCTION = childProductMap.get(appProduct.id)?.Current_Once_Of_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Current_Once_Of_Amount__c).substringBefore('.') : '0';

				if (!Test.isRunningTest() && childProductMap.get(appProduct.id) != null) {
					ExistingProductObj.INTPRDEXST.CURREXISTEMPOWERMNTFUNDIND = childProductMap.get(appProduct.id)?.Existing_Alternative_Fund_Indicator__c == 'Yes'? 'Y' : 'N'; //Added for W:12376
				}

				ExistingProductObj.INTPRDEXST.CURREXISTEMPOWERMNTFUND = childProductMap.get(appProduct.id)?.Existing_Alternative_Fund_Code__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Existing_Alternative_Fund_Code__c).substring(0,3) : '';//sending first 3 digits coming from service as per confirmation from Santjie W:12376
				ExistingProductObj.INTPRDEXST.ACCOUNTNUMBER = appProduct.Account_Number__c != null ? String.valueOf(appProduct.Account_Number__c) : '';

				//Values mapped as blank currently to send the whole bean structure in the request. Update mapping when field becomes applicable
				ExistingProductObj.INTPRDEXST.CURRINSTALLMENT = '0';
				ExistingProductObj.INTPRDEXST.CURRINSTALMNTFREQ = '0';
				ExistingProductObj.INTPRDEXST.CURRSETTLEMENTAMNT = '0';
				ExistingProductObj.INTPRDEXST.CURRINITFEEPREVDEBITED = '';
				ExistingProductObj.INTPRDEXST.NCAMAXINITFEEAMNT = '0';
				ExistingProductObj.INTPRDEXST.ESPINSTRUCTION = '';
				ExistingProductObj.INTPRDEXST.CARDTYPE = '';

				ExistingProductObj.APPPRDEXST.APPLICATIONSTATUS = 'P';//For PCO New the value will always be Pending(P), PLEASE translate Stage__c for PCO Update
				if (appProduct.Current_Overdraft_Limit__c == 0) {
					ExistingProductObj.APPPRDEXST.REQFACILITYTYPE = '3';
				}
				else if (appProduct.Current_Overdraft_Limit__c > 0) {
					ExistingProductObj.APPPRDEXST.REQFACILITYTYPE = '4';
				}
				//adding some default mapping on top
				ExistingProductObj.INTPRDEXST.PRODUCTTYPE = appProduct.Product_Type__c != null ? appProduct.Product_Type__c : '';//API name of picklist value has the translated value
				ExistingProductObj.INTPRDEXST.CURRSUBPRODTYPE = '';
				ExistingProductObj.INTPRDEXST.CURRLIMIT = appProduct.Current_Overdraft_Limit__c != null ? String.valueOf(appProduct.Current_Overdraft_Limit__c).substringBefore('.') : '0';
				ExistingProductObj.APPPRDEXST.REQTOTALAMNT = childProductMap.get(appProduct.id)?.Product_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id).Product_Amount__c).substringBefore('.') : '0';
				ExistingProductObj.APPPRDEXST.REQCAMPAIGNCODE = childProductMap.get(appProduct.id)?.Campaign_Code__c != null ? childProductMap.get(appProduct.id)?.Campaign_Code__c.substringBefore('.') : '';
				//ExistingProductObj.APPPRDEXST.REQFACILITYTYPE = '0';//no field - calculation must be done derive value, currently mapped as 0 to add field to request structure
				ExistingProductObj.APPPRDEXST.REQPRODTYPE = appProduct.Product_Type__c != null ? appProduct.Product_Type__c : '';//API name of picklist value has the translated value
				//ExistingProductObj.APPPRDEXST.REQTOTALAMNT = (ExistingProductObj.APPPRDEXST.REQTOTALAMNT == null && childProductMap.get(appProduct.id)?.Product_Amount__c != null) ? String.valueOf(childProductMap.get(appProduct.id).Product_Amount__c).substringBefore('.') : '0';
				ExistingProductObj.APPPRDEXST.REQODLIMITTYPE = limitTypeTranslated != null ? limitTypeTranslated : '1';//Integration Translation records
				ExistingProductObj.APPPRDEXST.REQREDUCTIONAMNT = childProductMap.get(appProduct.id)?.Reduction_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Reduction_Amount__c).substringBefore('.') : '0';
				ExistingProductObj.APPPRDEXST.REQREDUCTIONFREQ = childProductMap.get(appProduct.id)?.Reduction_Frequency__c != null ? childProductMap.get(appProduct.id)?.Reduction_Frequency__c.substringBefore('.') : '0';//API name of picklist value has the translated value
				ExistingProductObj.APPPRDEXST.REQONCEOFFFREQAMNT = childProductMap.get(appProduct.id)?.Once_Off_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Once_Off_Amount__c).substringBefore('.') : '0';
				if (appProduct.Product_Name__c == 'Cheque') {
					ExistingProductObj.APPPRDEXST.REQPURPOSEFACILITYORLOAN = childProductMap.get(appProduct.id)?.Overdraft_Purpose__c != null ? childProductMap.get(appProduct.id)?.Overdraft_Purpose__c : '0';//API name of picklist value has the translated value
					// W-009412 - Validation 1 - Additional Amount. Expected 345678 (Existing Products (only 1 product requested)) - Tinashe M Shoko
                    decimal Current_Overdraft_Limit = appProduct?.Current_Overdraft_Limit__c != null ? appProduct?.Current_Overdraft_Limit__c : 0;
                    decimal Product_Amount = childProductMap.get(appProduct.id)?.Product_Amount__c != null ? childProductMap.get(appProduct.id)?.Product_Amount__c : 0;
                    ExistingProductObj.APPPRDEXST.REQADDITIONALAMNT = (ExistingProductObj.APPPRDEXST.REQADDITIONALAMNT == Null && Product_Amount - Current_Overdraft_Limit != null) ? String.valueOf(Product_Amount - Current_Overdraft_Limit).substringBefore('.') : '0';
                    // W-009412 - Validation 1 - Additional Amount. Expected 345678 (Existing Products (only 1 product requested)) - Tinashe M Shoko
				}
				else if (appProduct.Product_Name__c == 'Term Loan') {
					ExistingProductObj.APPPRDEXST.REQPURPOSEFACILITYORLOAN = appProduct.TL_Purpose_Of_Term_Loan__c;//Translation needed not applicable for now (OD/CHQ)
				}
				if (!Test.isRunningTest() && childProductMap.get(appProduct.id) != null) {
					ExistingProductObj.APPPRDEXST.REQREQEMPOWERMNTFUNDIND = childProductMap.get(appProduct.id)?.Alternative_Fund_Indicator__c ? 'Y' : 'N';
					ExistingProductObj.APPPRDEXST.SECUREDBYMORTGAGEBOND = childProductMap.get(appProduct.id)?.Secured_By_Mortgage_Bond__c ? 'Y' : 'N';
				}
				ExistingProductObj.APPPRDEXST.REQREQEMPOWERMNTFUND = childProductMap.get(appProduct.id)?.Alternative_Fund_Code__c != null ? childProductMap.get(appProduct.id)?.Alternative_Fund_Code__c : '';//API name of picklist value has the translated value
                if (!Test.isRunningTest() && childProductMap.get(appProduct.id) != null) {
                    ExistingProductObj.APPPRDEXST.SECUREDBYMORTGAGEBOND = childProductMap.get(appProduct.id)?.Secured_By_Mortgage_Bond__c ? 'Y' : 'N';
                }
				//Values mapped as blank currently to send the whole bean structure in the request. Update mapping when field becomes applicable
				ExistingProductObj.APPPRDEXST.REQSUBPRODTYPE = '';

				//Adding Credit card section at the end to avoid value overide
				if(appProduct.Product_Name__c == 'Credit Card') {
					ExistingProductObj.INTPRDEXST.PRODUCTTYPE = appProduct.Business_Credit_Card_Product_Type__c != null ? appProduct.Business_Credit_Card_Product_Type__c : '';//API name of picklist value has the translated value
					ExistingProductObj.INTPRDEXST.CURRSUBPRODTYPE = appProduct.Business_Credit_Card_Sub_Product_Type__c != null ? appProduct.Business_Credit_Card_Sub_Product_Type__c : '';
					ExistingProductObj.INTPRDEXST.CURRLIMIT = appProduct.Allocated_Limit__c != null ? String.valueOf(appProduct.Allocated_Limit__c).substringBefore('.') : '0';
					ExistingProductObj.APPPRDEXST.REQTOTALAMNT = appProduct.Requested_facility_limit__c != null ? String.valueOf(appProduct.Requested_facility_limit__c).substringBefore('.') : '0';
					ExistingProductObj.APPPRDEXST.REQCAMPAIGNCODE = appProduct.Campaign_Code__c != null ? appProduct.Campaign_Code__c : '';

					decimal Current_Overdraft_Limit = appProduct.Allocated_Limit__c != null ? appProduct.Allocated_Limit__c : 0;
					decimal Product_Amount = appProduct.Requested_facility_limit__c != null ? Decimal.valueOf(appProduct.Requested_facility_limit__c) : 0;
					decimal reqAdditionalAmnt = Product_Amount - Current_Overdraft_Limit;
					ExistingProductObj.APPPRDEXST.REQADDITIONALAMNT = String.valueOf(reqAdditionalAmnt).substringBefore('.');
				}
                // Credit block end
                
                //Adding 'Bank Guarantee' section at the end to avoid value overide
				if(appProduct.Product_Name__c == 'Bank Guarantee') {
                    ExistingProductObj.INTPRDEXST.ACCOUNTNUMBER = appProduct.Facility_account_number__c != null ? String.valueOf(appProduct.Facility_account_number__c) : '';
				    ExistingProductObj.INTPRDEXST.PRODUCTTYPE   = productTranslated != null ? productTranslated : 'BGE';
					ExistingProductObj.INTPRDEXST.PRODUCT  = productTranslated != null ? productTranslated : 'BGE';
                    ExistingProductObj.INTPRDEXST.CURRSUBPRODTYPE  = appProduct.Contract_sub_product_code__c != null ? appProduct.Contract_sub_product_code__c : 'GAR';
                    ExistingProductObj.INTPRDEXST.CURRLIMIT = appProduct.Facility_limit__c != null ? String.valueOf(appProduct.Facility_limit__c).substringBefore('.') : '0';
					ExistingProductObj.APPPRDEXST.REQTOTALAMNT = appProduct.Requested_facility_limit__c != null ? String.valueOf(appProduct.Requested_facility_limit__c).substringBefore('.') : '0';
					ExistingProductObj.APPPRDEXST.REQCAMPAIGNCODE = appProduct.Campaign_Code__c != null ? appProduct.Campaign_Code__c : '';

					decimal Current_BGE_Limit = appProduct.Facility_limit__c != null ? Decimal.valueOf(appProduct.Facility_limit__c) : 0;
					decimal Product_Amount = appProduct.Requested_facility_limit__c != null ? Decimal.valueOf(appProduct.Requested_facility_limit__c) : 0;
					decimal reqAdditionalAmnt = Product_Amount - Current_BGE_Limit;
					ExistingProductObj.APPPRDEXST.REQADDITIONALAMNT = String.valueOf(reqAdditionalAmnt).substringBefore('.');
				}

				ExistingProductObj.APPPRDEXST.REQREPAYMNTOPTION = '0';
				ExistingProductObj.APPPRDEXST.REQTERMOFLOAN = '0';
				ExistingProductObj.APPPRDEXST.REQINSTALLMENTFREQ = '0';
				ExistingProductObj.APPPRDEXST.REQNUMSKIPPEDPAYMNTS = '0';
				ExistingProductObj.APPPRDEXST.REQINITIATIONFEEPAYMNTMETHOD = 'D';//CHECK FOR MAPPING FOR THIS FIELD
				ExistingProductObj.APPPRDEXST.REQPAYMNTMETHOD = '';
				ExistingProductObj.APPPRDEXST.REQCREDLIFEPREMIUM = '0';
				ExistingProductObj.APPPRDEXST.REQLIMITTYPEIND = '0';
				ExistingProductObj.APPPRDEXST.REQPRODCOMBINATIONNUM = '0';
				ApplicationDV.put('ExistingProducts' + String.valueOf(existingCount).leftPad(2, '0'), ExistingProductObj);
				existingCount++;
			}
			else if (appProduct.Product_State__c == 'New') {

				PowerCurveNewApplication_Req_IB_v1.RequestedProducts01 RequestedProductObj = new PowerCurveNewApplication_Req_IB_v1.RequestedProducts01();
				RequestedProductObj.APPPRDNEWF = new PowerCurveNewApplication_Req_IB_v1.APPPRDNEWF();
				RequestedProductObj.APPPRDNEWF.UNIQUEPRODID = appProduct.Name; //line added by Almas Aleem for w-9668  //'CHQ-' + appProduct.Temp_Account_Number__c; //Sending the Application Name Auto Number as unique identifier - changed from Name to Temp_Account_Number__c by Tinashe - W-009421
				RequestedProductObj.APPPRDNEWF.APPLICATIONSTATUS = 'P';//For PCO New the value will always be Pending(P), PLEASE translate Stage__c for PCO Update
				RequestedProductObj.APPPRDNEWF.REQPRODUCT = productTranslated != null ? productTranslated : '';//Integration Translation records
				RequestedProductObj.APPPRDNEWF.REQFACILITYTYPE = '1';//no field - calculation must be done derive value, currently mapped as 0 to add field to request structure
				RequestedProductObj.APPPRDNEWF.REQPRODTYPE = appProduct.Product_Type__c != null ? appProduct.Product_Type__c : '';//API name of picklist value has the translated value

				// W-009412 - Validation 1 - Additional Amount. Expected 345678 (Existing Products (only 1 product requested)) - Tinashe M Shoko
				decimal Current_Overdraft_Limit = appProduct?.Current_Overdraft_Limit__c != null ? appProduct?.Current_Overdraft_Limit__c : 0;
				decimal Product_Amount = childProductMap.get(appProduct.id)?.Product_Amount__c != null ? childProductMap.get(appProduct.id)?.Product_Amount__c : 0;
				RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = Product_Amount - Current_Overdraft_Limit != null ? String.valueOf(Product_Amount - Current_Overdraft_Limit).substringBefore('.') : '0';
				// RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = appProduct.TL_Additional_Loan_Amount_Requested__c != null ? String.valueOf(appProduct.TL_Additional_Loan_Amount_Requested__c).substringBefore('.') : '0';//SHOULD BE MAPPED FOR TERM LOAN
				// W-009412 - Validation 1 - Additional Amount. Expected 345678 (Existing Products (only 1 product requested)) - Tinashe M Shoko

				RequestedProductObj.APPPRDNEWF.REQTOTALAMNT = childProductMap.get(appProduct.id)?.Product_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id).Product_Amount__c).substringBefore('.') : '0';
				//RequestedProductObj.APPPRDNEWF.REQODLIMITTYPE = limitTypeTranslated != null ? limitTypeTranslated : '1';//Integration Translation records
				RequestedProductObj.APPPRDNEWF.REQREDUCTIONAMNT = childProductMap.get(appProduct.id)?.Reduction_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Reduction_Amount__c).substringBefore('.') : '0';
				RequestedProductObj.APPPRDNEWF.REQREDUCTIONFREQ = childProductMap.get(appProduct.id)?.Reduction_Frequency__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Reduction_Frequency__c).substringBefore('.') : '0';//API name of picklist value has the translated value
				RequestedProductObj.APPPRDNEWF.REQONCEOFFFREQAMNT = childProductMap.get(appProduct.id)?.Once_Off_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Once_Off_Amount__c).substringBefore('.') : '0';
				if (appProduct.Product_Name__c == 'Cheque') {
                    // RequestedProductObj.APPPRDNEWF.REQFACILITYTYPE = '1';
                    RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = Product_Amount - Current_Overdraft_Limit != null ? String.valueOf(Product_Amount - Current_Overdraft_Limit).substringBefore('.') : '0';

                    RequestedProductObj.APPPRDNEWF.REQODLIMITTYPE = limitTypeTranslated != null ? limitTypeTranslated : '1';//Integration Translation records
					
					RequestedProductObj.APPPRDNEWF.REQPURPOSEFACILITYORLOAN = childProductMap.get(appProduct.id)?.Overdraft_Purpose__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Overdraft_Purpose__c) : '0';//API name of picklist value has the translated value
				}
				else if (appProduct.Product_Name__c == 'Term Loan') {
					RequestedProductObj.APPPRDNEWF.REQFACILITYTYPE = '0';
					RequestedProductObj.APPPRDNEWF.REQPURPOSEFACILITYORLOAN = appProduct.TL_Purpose_Of_Term_Loan__c != null ? appProduct.TL_Purpose_Of_Term_Loan__c : '';//Translation needed not applicable for now (OD)
					RequestedProductObj.APPPRDNEWF.REQTOTALAMNT = appProduct.TL_Total_Loan_Amount__c != null ? String.valueOf(appProduct.TL_Total_Loan_Amount__c).substringBefore('.') : '0';
					RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = appProduct.TL_Additional_Loan_Amount_Requested__c != null ? String.valueOf(appProduct.TL_Additional_Loan_Amount_Requested__c).substringBefore('.') : '0';//SHOULD BE MAPPED FOR TERM LOAN
				
                }
				RequestedProductObj.APPPRDNEWF.REQTERMOFLOAN = appProduct.TL_Term_of_Loan_Months__c != null ? String.valueOf(appProduct.TL_Term_of_Loan_Months__c).substringBefore('.') : '0';
				RequestedProductObj.APPPRDNEWF.REQINSTALLMENTFREQ = appProduct.TL_Instalment_Frequency__c != null ? String.valueOf(appProduct.TL_Instalment_Frequency__c).substringBefore('.') : '0';//Translation needed not applicable for now (OD)
				RequestedProductObj.APPPRDNEWF.REQNUMSKIPPEDPAYMNTS = appProduct.TL_Months_to_Skip__c != null ? String.valueOf(appProduct.TL_Months_to_Skip__c).substringBefore('.') : '0';//Translation needed not applicable for now (OD)
				RequestedProductObj.APPPRDNEWF.REQINITIATIONFEEPAYMNTMETHOD = 'D';//appProduct.TL_Initiation_Fee_Payment_Method__c != null ? appProduct.TL_Initiation_Fee_Payment_Method__c : 'D';//Translation needed not applicable for now (OD)
				RequestedProductObj.APPPRDNEWF.REQPAYMNTMETHOD = paymentType != null ? paymentType : 'D';//appProduct.TL_Method_of_Payment__c != null ? appProduct.TL_Method_of_Payment__c.substringBefore('.') : '';//Translation needed not applicable for now (OD)

				if (!Test.isRunningTest()) {
					RequestedProductObj.APPPRDNEWF.REQREQEMPOWERMNTFUNDIND = childProductMap.get(appProduct.id)?.Alternative_Fund_Indicator__c != null && childProductMap.get(appProduct.id)?.Alternative_Fund_Indicator__c ? 'Y' : 'N';
				}

				RequestedProductObj.APPPRDNEWF.REQREQEMPOWERMNTFUND = childProductMap.get(appProduct.id)?.Alternative_Fund_Code__c != null ? childProductMap.get(appProduct.id)?.Alternative_Fund_Code__c.substringBefore('.') : '';//API name of picklist value has the translated value
				RequestedProductObj.APPPRDNEWF.REQCAMPAIGNCODE = childProductMap.get(appProduct.id)?.Campaign_Code__c != null ? childProductMap.get(appProduct.id)?.Campaign_Code__c : '';

				if (!Test.isRunningTest()) {
					RequestedProductObj.APPPRDNEWF.SECUREDBYMORTGAGEBOND = childProductMap?.get(appProduct.id)?.Secured_By_Mortgage_Bond__c != null && childProductMap?.get(appProduct.id)?.Secured_By_Mortgage_Bond__c ? 'Y' : 'N';
				}

				RequestedProductObj.APPPRDNEWF.SETTLEMENTSAMNT = appProduct.TL_Total_Settlement_Amount__c != null ? String.valueOf(appProduct.TL_Total_Settlement_Amount__c).substringBefore('.') : '0';
				//Values mapped as blank currently to send the whole bean structure in the request. Update mapping when field becomes applicable
				RequestedProductObj.APPPRDNEWF.REQLIMIT = childProductMap.get(appProduct.id)?.Product_Amount__c != null ? String.valueOf(childProductMap.get(appProduct.id)?.Product_Amount__c).substringBefore('.') : '0';//Need to check with Subashini
				RequestedProductObj.APPPRDNEWF.REQREPAYMNTOPTION = '0';
				RequestedProductObj.APPPRDNEWF.REQCREDLIFEPREMIUM = '0';
				RequestedProductObj.APPPRDNEWF.REQLIMITTYPEIND = '';
				RequestedProductObj.APPPRDNEWF.REQPRODCOMBINATIONNUM = '0';
				RequestedProductObj.APPPRDNEWF.ESPINSTRUCTION = '';
				RequestedProductObj.APPPRDNEWF.CARDTYPE = '';

				RequestedProductObj.INTPRDNEWF = new PowerCurveNewApplication_Req_IB_v1.INTPRDNEWF();
				RequestedProductObj.INTPRDNEWF.NCAMAXINITFEEAMNT = '';

                if(appProduct.Product_Name__c == 'Credit Card'){
					RequestedProductObj.APPPRDNEWF.REQPRODTYPE = 'VISA';
                    RequestedProductObj.APPPRDNEWF.REQSUBPRODTYPE = appProduct.Product_Type__c;
                    RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = appProduct.Requested_facility_limit__c != null ? String.valueOf(appProduct.Requested_facility_limit__c).substringBefore('.') : '0';
                    RequestedProductObj.APPPRDNEWF.REQTOTALAMNT = appProduct.Requested_facility_limit__c != null ? String.valueOf(appProduct.Requested_facility_limit__c).substringBefore('.') : '0';
                    RequestedProductObj.APPPRDNEWF.REQLIMIT = appProduct.Requested_facility_limit__c != null ? String.valueOf(appProduct.Requested_facility_limit__c).substringBefore('.') : '0';
                }
                 // Adding new Block for Bank Gurantee
                if(appProduct.Product_Name__c == 'Bank Guarantee'){
                    RequestedProductObj.APPPRDNEWF.REQPRODUCT  = productTranslated != null ? productTranslated : 'BGE';
					RequestedProductObj.APPPRDNEWF.REQPRODTYPE = productTranslated != null ? productTranslated : 'BGE';
                    RequestedProductObj.APPPRDNEWF.REQSUBPRODTYPE = appProduct.Contract_sub_product_code__c != null ? appProduct.Contract_sub_product_code__c : 'GAR';
                    RequestedProductObj.APPPRDNEWF.REQADDITIONALAMNT = appProduct.Facility_limit__c != null ? String.valueOf(appProduct.Facility_limit__c).substringBefore('.') : '0';
                    RequestedProductObj.APPPRDNEWF.REQTOTALAMNT = appProduct.Facility_limit__c != null ? String.valueOf(appProduct.Facility_limit__c).substringBefore('.') : '0';
                    RequestedProductObj.APPPRDNEWF.REQLIMIT = appProduct.Facility_limit__c != null ? String.valueOf(appProduct.Facility_limit__c).substringBefore('.') : '0';
                }

				ApplicationDV.put('RequestedProducts' + String.valueOf(requestedCount).leftPad(2, '0'), RequestedProductObj);
				requestedCount++;
			}
		}
		requestBean = (PowerCurveNewApplication_Req_IB_v1)JSON.deserialize(JSON.serialize(untypedMap, true), PowerCurveNewApplication_Req_IB_v1.class);

		return requestBean;
	}

	/**
     * @description Method to change Salesforce field Type to PCO field Type
     *
     * @param fieldType - Salesforce field Type string
     * @return String - String with PCO field Type
     */
    public static String getTranslatedValue(String fieldType){
        String fieldTypePCO = '';

        if(fieldType != null){
			fieldTypePCO = translationMap.get(fieldType);
            if(fieldType.equalsIgnoreCase('SA Identity Document') || fieldType.equalsIgnoreCase('Registration Number') || fieldType.equalsIgnoreCase('Passport')){
                if(fieldTypePCO.length() == 1){
                    fieldTypePCO = '0' + fieldTypePCO;
                }
            }
        }

        return fieldTypePCO;
    }

    /**
     * @description method to getApplicationScoringEntities
     * @author Saurabh.Pandey@absa.africa | 2020-09-29
     * @param oppId
     * @return List<Map<String, String>>
     **/
    @AuraEnabled
    public static List<Map<String,String>> getApplicationScoringEntities(Id oppId){
    	return PowerCurveFinancialsResponseCtrl.getApplicationScoringEntities(oppId);
    }

    /**
     * @description getStage7Check
     * @author Himanshu.Nimje@absa.africa | 2021-06-14
     * @param oppId
     * @return Boolean
    **/
	@AuraEnabled
    public static Boolean getStage7Check(Id oppId) {
        Opportunity oppRec = [SELECT Id, Is_Call_7_Done__c from Opportunity where Id=:oppId LIMIT 1 ];
        return oppRec.Is_Call_7_Done__c;
    }
}