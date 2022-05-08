/**
 * @description       :
 * @author            : JQUEV
 * @last modified on  : 2021-07-12
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2021-01-05   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class PowerCurveUpdateController {
	/**
	 * @description
	 * @author JQUEV | 2021-01-05
	 * @param pcoNewRequestBean
	 * @param newPCO
	 * @param oppId
	 * @param appId
	**/
	public static void InsertNewPCO(PowerCurveNewApplication_Req_IB_v1 pcoNewRequestBean, PowerCurveNewApplication_Resp_IB_v1 newPCO, String oppId, String appId) {
		Application_Scoring__c appScoring = new Application_Scoring__c();
		Application__c app = new ApplicationsSelector().selectById(appId);
		List<Application_Scoring_Entity__c> appScoringEntityLst = new List<Application_Scoring_Entity__c>();
		String appNumber = String.valueOf(newPCO.Response.ApplicationDV?.APPAPPAPPLICATIONNUMBER);

		if (String.isNotBlank(appNumber)) {
            Decimal ordCred = 0;

            if(pcoNewRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null){
            	ordCred = pcoNewRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null ? Decimal.valueOf(pcoNewRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED) : 0;
            }

			if (newPCO?.Response?.ApplicationDV != null) {
				appScoring.Application_Number__c = appId;
				appScoring.Stage__c = '1';
				//appScoring.DERPCOUNIQUENUMBER__c = newPCO?.Response?.ApplicationDV?.DERPCOUNIQUENUMBER;
				app.DERPCOUNIQUENUMBER__c = newPCO?.Response?.ApplicationDV?.DERPCOUNIQUENUMBER;
				appScoring.JSON_Request__c = JSON.serialize(pcoNewRequestBean);

				if (newPCO?.Response?.ApplicationDV?.StratRes1 != null) {
					//Assign to Object for readability
					PowerCurveNewApplication_Resp_IB_v1.StratRes1 StratRes1_Obj = newPCO.Response.ApplicationDV.StratRes1;

					if (StratRes1_Obj.RESAPPSCRD != null) {
						appScoring.TRFCUTOFF__c = StratRes1_Obj.RESAPPSCRD.TRFCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.TRFCUTOFF) : null;
						appScoring.TLCUTOFF__c = StratRes1_Obj.RESAPPSCRD.TLCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.TLCUTOFF) : null;
						appScoring.ORDCREDSCORINGMANDATE__c = StratRes1_Obj.RESAPPSCRD.ORDCREDSCORINGMANDATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPSCRD.ORDCREDSCORINGMANDATE) : null;
						appScoring.ORDCREDLIMIT__c = StratRes1_Obj.RESAPPSCRD.ORDCREDLIMIT != null ? Decimal.valueOf(StratRes1_Obj.RESAPPSCRD.ORDCREDLIMIT) : null;
						appScoring.ODCUTOFF__c = StratRes1_Obj.RESAPPSCRD.ODCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.ODCUTOFF) : null;
						appScoring.MOODYCUTOFF__c = StratRes1_Obj.RESAPPSCRD.MOODYCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.MOODYCUTOFF) : null;
						appScoring.GCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.GCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.GCCUTOFF) : null;
						appScoring.FCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.FCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.FCCUTOFF) : null;
						appScoring.EPSCUTOFF__c = StratRes1_Obj.RESAPPSCRD.EPSCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.EPSCUTOFF) : null;
						appScoring.CPFCUTOFF__c = StratRes1_Obj.RESAPPSCRD.CPFCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.CPFCUTOFF) : null;
						appScoring.CHEQCUTOFF__c = StratRes1_Obj.RESAPPSCRD.CHEQCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.CHEQCUTOFF) : null;
						appScoring.BRLCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BRLCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BRLCUTOFF) : null;
						appScoring.BGCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BGCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BGCUTOFF) : null;
						appScoring.BCCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BCCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BCCCUTOFF) : null;
						appScoring.AGRICUTOFF__c = StratRes1_Obj.RESAPPSCRD.AGRICUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.AGRICUTOFF) : null;
					}
					if (StratRes1_Obj.RESAPPGPAM != null) {
						appScoring.GuinessRating__c = StratRes1_Obj.RESAPPGPAM.GUINESSRATING != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.GUINESSRATING) : null;
						appScoring.FraudReferralProcess__c = StratRes1_Obj.RESAPPGPAM.FRAUDREFERRALPROCESS != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.FRAUDREFERRALPROCESS) : null;
						appScoring.ExpIllustDaysRemove__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSREMOVE != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSREMOVE) : null;
						appScoring.ExpIllustDaysNoDecision__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSNODECISION != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSNODECISION) : null;
						appScoring.ExpIllustDaysAfterDecision__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSAFTERDECISION != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSAFTERDECISION) : null;
						appScoring.AbsaDataRfreshPeriod__c = StratRes1_Obj.RESAPPGPAM.ABSADATARFRESHPERIOD != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.ABSADATARFRESHPERIOD) : null;
					}
					if (StratRes1_Obj.RESAPPCMNG != null) {
						appScoring.SmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.SMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.SMMINPLUSMINRATE) : null;
						appScoring.SmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.SMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.SMMAXOFFSETREDUC) : null;
						appScoring.ReMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.REMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.REMINPLUSMINRATE) : null;
						appScoring.ReMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.REMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.REMAXOFFSETREDUC) : null;
						appScoring.PmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.PMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.PMMINPLUSMINRATE) : null;
						appScoring.PmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.PMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.PMMAXOFFSETREDUC) : null;
						appScoring.HocmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.HOCMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.HOCMMINPLUSMINRATE) : null;
						appScoring.HocmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.HOCMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.HOCMMAXOFFSETREDUC) : null;
					}

					appScoring.WRSTPRINCIPALP1VP2__c = StratRes1_Obj.RESAPPEXCS?.WRSTPRINCIPALP1VP2 != null ? StratRes1_Obj.RESAPPEXCS.WRSTPRINCIPALP1VP2 : null;

					if (newPCO?.Response?.ApplicationDV?.DerivedCalcAppData != null) {

						//Assign to Object for readability
						PowerCurveNewApplication_Resp_IB_v1.DerivedCalcAppData DerivedCalcAppData_Obj = newPCO.Response.ApplicationDV.DerivedCalcAppData;
						appScoring.SpouseDetailsRequiredInd__c = DerivedCalcAppData_Obj?.DERAPPSPSE?.SPOUSEDETAILSREQUIREDIND != null ? DerivedCalcAppData_Obj.DERAPPSPSE.SPOUSEDETAILSREQUIREDIND : null;
						appScoring.PrincApplicableInd__c = DerivedCalcAppData_Obj?.DERAPPPRIN?.PRINCAPPLICABLEIND != null ? DerivedCalcAppData_Obj.DERAPPPRIN.PRINCAPPLICABLEIND : null;
						appScoring.PreapprReprocessLowerLmtInd__c = DerivedCalcAppData_Obj?.DERAPPPAPR?.PREAPPRREPROCESSLOWERLMTIND != null ? DerivedCalcAppData_Obj.DERAPPPAPR.PREAPPRREPROCESSLOWERLMTIND : null;
						appScoring.PaprPreapprInd__c = DerivedCalcAppData_Obj?.DERAPPPAPR?.PREAPPRIND != null ? DerivedCalcAppData_Obj.DERAPPPAPR.PREAPPRIND : null;
						appScoring.ReqMaxTermVsPurpsLoanNotBond__c = DerivedCalcAppData_Obj?.DERAPPGPAM?.REQMAXTERMVSPURPSLOANNOTBOND != null ? DerivedCalcAppData_Obj.DERAPPGPAM.REQMAXTERMVSPURPSLOANNOTBOND : null;
						appScoring.ReqMaxTermVsPurpsLoanMaxTerm__c = DerivedCalcAppData_Obj?.DERAPPGPAM?.REQMAXTERMVSPURPSLOANMAXTERM != null ? Integer.valueOf(DerivedCalcAppData_Obj.DERAPPGPAM.REQMAXTERMVSPURPSLOANMAXTERM) : null;

						if (DerivedCalcAppData_Obj.DERAPPEXPO != null) {
                            appScoring.Potential_Ordinary_Credit__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC) + ordCred : null;
							appScoring.ReqTotAddPotentialOc__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC) : null;
							appScoring.ReqPotentialTotGroup__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTGROUP != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTGROUP) : null;
							appScoring.ReqPotentialTotDirect__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTDIRECT != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTDIRECT) : null;
							appScoring.ReqPotentialTgoe__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGOE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGOE) : null;
							appScoring.Potential_TGBE_Offered__c = appScoring.ReqPotentialTgbe__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGBE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGBE) : null;
							appScoring.ReqPotentialTgae__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGAE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGAE) : null;
							appScoring.Offered_Total_Financing_Limit__c = appScoring.ReqPotentialTfl__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTFL != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTFL) : null;
						}
					}
				}
			}
			update app;
			insert appScoring;

			//check mapResponseAppScoringEntityFields() for reference to what was here before;
		}
	}

	/**
	 * @description Method to map the PowerCurveUpdateApplication_Resp_IB_v1 Response to the Application_Scoring__c Object based on the Current Stage.
	 * @author JQUEV | 2021-01-05
	 * @param pcoUpdateRequestBean
	 * @param updateAppResponse
	 * @param application
	 * @param currentStage
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapResponseAppScoringFields(PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse, Application__c application, Integer currentStage) {
		Application_Scoring__c appScoring = new Application_Scoring__c(Application_Number__c = application.Id, Stage__c = String.valueOf(currentStage), JSON_Request__c = JSON.serialize(pcoUpdateRequestBean, true));
		application.DERPCOUNIQUENUMBER__c = pcoUpdateRequestBean?.Request?.ApplicationDV?.DERPCOUNIQUENUMBER;
        Decimal potOrdCred = 0;
        Decimal ordCred = 0;

        if(pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null){
            ordCred = pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null ? Decimal.valueOf(pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED) : 0;
        }

        if(updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPEXPO?.REQTOTADDPOTENTIALOC != null){
            potOrdCred = updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPEXPO?.REQTOTADDPOTENTIALOC != null ? Decimal.valueOf(updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPEXPO?.REQTOTADDPOTENTIALOC) + ordCred : 0;
        }

        //appScoring.DERPCOUNIQUENUMBER__c = pcoUpdateRequestBean?.Request?.ApplicationDV?.DERPCOUNIQUENUMBER;

		//Maps according to the Current Stage and all prior Stages.
		//E.g. IF currentStage == 3, It will call the mapping methods for stage 1, 2 & 3.
		if (currentStage >= 1) {
			appScoring = mapStage1AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 2) {
			appScoring = mapStage2AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 3) {
			appScoring = mapStage3AppScoringResponseFields(appScoring, updateAppResponse, potOrdCred);
		}
		if (currentStage >= 4) {
			appScoring = mapStage4AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 5) {
			appScoring = mapStage5AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 6) {
			appScoring = mapStage6AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 7) {
			appScoring = mapStage7AppScoringResponseFields(appScoring, updateAppResponse);
		}
		if (currentStage >= 8) {
			appScoring = mapStage8AppScoringResponseFields(appScoring, updateAppResponse);
		}

		//Perform DMLS
		//update application; // Saurabh : testing this 04/06/21 for soql error due to this update.
		insert appScoring;

		//Call Method to map and insert Application_Scoring_Entity__c Objects
		List<Application_Scoring_Entity__c> appScoringEntityList = mapResponseAppScoringEntityFields(updateAppResponse, appScoring, currentStage, application);

		//Call Method to map and insert Application_Scoring_Product__c Objects
		List<Application_Scoring_Product__c> appScoringProductList = mapResponseAppScoringProductFields(updateAppResponse, appScoring, currentStage);

		//Currently Product data is only mapped during stage 7. TBD
		if (currentStage == 7) {
			//commented for deployment
			UpdateCreditApplication.updateAppProdAfterStg7(application.Id, '' + currentStage);  //Saurabh commented string assignment as Method signature has been changed   String response =
		}
		/* if(currentStage == 8){ Removed as per disccussion not to update TOB after call 8
		 UpdateCreditApplication.updateAppProdAfterStg7(application.Id,''+currentStage);  //Saurabh commented string assignment as Method signature has been changed   String response =

		//SanctioningApprovalController.updateCall8Return(application.Opportunity__c);//Almas added method to update call 8 data :)

		 }*/

		return appScoring;
	}

	/**
	 * @description Method to map the PowerCurveUpdateApplication_Resp_IB_v1 Response to the Application_Scoring_Entity__c List based on the Current Stage.
	 * @author JQUEV | 2021-01-05
	 * @param updateAppResponse
	 * @param appScoring
	 * @param currentStage
	 * @param app
	 * @return List<Application_Scoring_Entity__c>
	**/
	public static List<Application_Scoring_Entity__c> mapResponseAppScoringEntityFields(PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse, Application_Scoring__c appScoring, Integer currentStage, Application__c app) {
		List<Application_Profile__c> applicationProfiles = new ApplicationProfileSelector().getApplicationProfilesByType(appScoring.Application_Number__c);

		//Create Application_Scoring_Entity__c Records for Each Entity returned in Response and add them to the Map with an Index
		Map<Integer, Application_Scoring_Entity__c> appScorEntityMap = new Map<Integer, Application_Scoring_Entity__c>();

		if (updateAppResponse?.Response?.ApplicationDV != null) {

			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//TO DO: Only create Application_Scoring_Entity__c for Entity/DerivedCalcEntity that have values. Empty ones will come back with '0' in all values. Identify Key Field to check

			List<Application_Exposure_Facility__c> appExpFacilities = new ApplicationExposureFacilitySelector().selectByOpportunityId(new Set<Id>{app.Opportunity__c});

			//Loop 6 times for the maximum allowed number of Entity Objects
			for (Integer i = 1; i <= 6; i++) {
				if (appDVMap.get('Entity0' + String.valueOf(i)) != null) {
					appScorEntityMap.put(i, new Application_Scoring_Entity__c(Entity_Number__c = String.valueOf(i), Application_Scoring__c = appScoring.Id));

					//Deserialize Entity Object into Untyped Map
					Map<String, Object> entityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('Entity0' + String.valueOf(i))));
					if (entityMap.get('INTENTAPRF') != null && currentStage == 2) {

						//Deserialize Entity Object into Untyped Map
						Map<String, Object> INTENTAPRFMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap.get('INTENTAPRF')));
						Application_Scoring_Entity__c appScoringEntity = appScorEntityMap.get(i);

                        appScoringEntity.RetailAssetFinInst__c = INTENTAPRFMap.get('RETAILASSETFININST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILASSETFININST'))) : null;
                        appScoringEntity.RetailAssetFin__c = INTENTAPRFMap.get('RETAILASSETFIN') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILASSETFIN'))) : null;
						appScoringEntity.RetailOcInst__c = INTENTAPRFMap.get('RETAILOCINST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILOCINST'))) : null;
						appScoringEntity.RetailOce__c = INTENTAPRFMap.get('RETAILOCE') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILOCE'))) : null;
						appScoringEntity.RetailMloanInst__c = INTENTAPRFMap.get('RETAILMLOANINST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILMLOANINST'))) : null;
						appScoringEntity.RetailMloanExp__c = INTENTAPRFMap.get('RETAILMLOANEXP') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('RETAILMLOANEXP'))) : null;
                        appScoringEntity.BbAssetFinInst__c = INTENTAPRFMap.get('BBASSETFININST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBASSETFININST'))) : null;
                        appScoringEntity.BbAssetFin__c = INTENTAPRFMap.get('BBASSETFIN') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBASSETFIN'))) : null;
						appScoringEntity.BbOceInst__c = INTENTAPRFMap.get('BBOCEINST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBOCEINST'))) : null;
						appScoringEntity.BbOce__c = INTENTAPRFMap.get('BBOCE') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBOCE'))) : null;
						appScoringEntity.BbMloanInst__c = INTENTAPRFMap.get('BBMLOANINST') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBMLOANINST'))) : null;
						appScoringEntity.BbMloanExp__c = INTENTAPRFMap.get('BBMLOANEXP') != null ? Decimal.valueOf(String.valueOf(INTENTAPRFMap.get('BBMLOANEXP'))) : null;
						appScoringEntity.Application_Scoring__c = appScoring.Id;
						appScorEntityMap.put(i, appScoringEntity);

						String clientCode = (entityMap?.get('INTENTCLIENTCODE1') != null ? (String)entityMap?.get('INTENTCLIENTCODE1') : null);

						for(Application_Exposure_Facility__c appExp :appExpFacilities) {
							if(appExp.Client_Code__c == clientCode) {
								if(appExp.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Business Bank') {
									appExp.Installments_Scored__c = appScoringEntity.BbOceInst__c;
									appExp.Exposure_Scored__c = appScoringEntity.BbOcE__c;
								}
								if(appExp.Approved_Facility__c == 'Approved Facilities Ordinary Credit - Retail') {
									appExp.Installments_Scored__c = appScoringEntity.RetailOcInst__c;
									appExp.Exposure_Scored__c = appScoringEntity.RetailOcE__c;
								}
								if(appExp.Approved_Facility__c == 'Approved Facilities Asset Finance - Business Bank') {
                                    appExp.Installments_Scored__c = appScoringEntity.BbAssetFinInst__c;
                                    appExp.Exposure_Scored__c = appScoringEntity.BbAssetFin__c;
								}
								if(appExp.Approved_Facility__c == 'Approved Facilities Asset Finance - Retail') {
                                    appExp.Installments_Scored__c = appScoringEntity.RetailAssetFinInst__c;
                                    appExp.Exposure_Scored__c = appScoringEntity.RetailAssetFin__c;
								}
								if(appExp.Approved_Facility__c == 'Approved Mortgage Facilities - Business Bank') {
									appExp.Installments_Scored__c = appScoringEntity.BbMloanInst__c;
									appExp.Exposure_Scored__c = appScoringEntity.BbMloanExp__c;
								}
								if(appExp.Approved_Facility__c == 'Approved Mortgage Facilities - Retail') {
									appExp.Installments_Scored__c = appScoringEntity.RetailMloanExp__c;
									appExp.Exposure_Scored__c = appScoringEntity.RetailMloanInst__c;
								}
								/*if(appExp.Approved_Facility__c == 'Settlement Limits Approved') {

								}*/
								//break;
							}
						}
					}
				}
				else {
					break;
				}
			}
			update appExpFacilities;
		}

		//Maps according to the Current Stage and all prior Stages.
		//E.g. IF currentStage == 3, It will call the mapping methods for stage 1, 2 & 3.
		if (currentStage >= 1) {
			appScorEntityMap = mapStage1AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		if (currentStage >= 2) {
			appScorEntityMap = mapStage2AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		if (currentStage >= 3) {
			appScorEntityMap = mapStage3AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
			String idRegPass = '';

			for (Application_Profile__c applicationProfile : applicationProfiles) {
				idRegPass = applicationProfile.Account__r.ID_Number__pc != null ? applicationProfile.Account__r.ID_Number__pc : applicationProfile.Account__r.Passport_Number__pc != null ? applicationProfile.Account__r.Passport_Number__pc : applicationProfile.Account__r.Registration_Number__c != null ? applicationProfile.Account__r.Registration_Number__c : null;
				for (Application_Scoring_Entity__c appScoringEntity : appScorEntityMap.values()) {
					if (applicationProfile.Client_CIF_Code__c != null) {
						if (String.valueOf(applicationProfile.Client_CIF_Code__c).replace(' ', '').equals(String.valueOf(appScoringEntity.INTENTCLIENTCODE1__c != null ? appScoringEntity.INTENTCLIENTCODE1__c : '').replace(' ', ''))) {
							appScoringEntity.Entity_Name__c = applicationProfile.Client_Name__c;
						}
					}
					else if (idRegPass != null) {
						if (idRegPass.equals(appScoringEntity.IdRegPassport__c)) {
							appScoringEntity.Entity_Name__c = applicationProfile.Client_Name__c;
						}
					}
				}
			}
		}

		if (currentStage >= 4) {
			appScorEntityMap = mapStage4AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		if (currentStage >= 5) {
			appScorEntityMap = mapStage5AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
			String idRegPass = '';

			for (Application_Profile__c applicationProfile : applicationProfiles) {
				idRegPass = applicationProfile.Account__r.ID_Number__pc != null ? applicationProfile.Account__r.ID_Number__pc : applicationProfile.Account__r.Passport_Number__pc != null ? applicationProfile.Account__r.Passport_Number__pc : applicationProfile.Account__r.Registration_Number__c != null ? applicationProfile.Account__r.Registration_Number__c : null;

				for (Application_Scoring_Entity__c appScoringEntity : appScorEntityMap.values()) {
					if (applicationProfile.Client_CIF_Code__c != null) {
						if (String.valueOf(applicationProfile.Client_CIF_Code__c).replace(' ', '').equals(String.valueOf(appScoringEntity.INTENTCLIENTCODE1__c != null ? appScoringEntity.INTENTCLIENTCODE1__c : '').replace(' ', ''))) {
							applicationProfile.PCCE_Id__c = appScoringEntity.Transunion_PCCE_Id__c != null ? appScoringEntity.Transunion_PCCE_Id__c : appScoringEntity.Experian_PCCE_Id__c != null ? appScoringEntity.Experian_PCCE_Id__c : null;
							applicationProfile.Bureau_Report_1__c = appScoringEntity.Report_1__c != null ? appScoringEntity.Report_1__c : null;
							applicationProfile.Bureau_Report_2__c = appScoringEntity.Report_2__c != null ? appScoringEntity.Report_2__c : null;
							applicationProfile.Bureau_Worst_Report__c = appScoringEntity.WRSTREPORT__c != null ? appScoringEntity.WRSTREPORT__c : null;
						}
					}
					else if (idRegPass != null) {
						if (idRegPass.equals(appScoringEntity.IdRegPassport__c)) {
							applicationProfile.PCCE_Id__c = appScoringEntity.Transunion_PCCE_Id__c != null ? appScoringEntity.Transunion_PCCE_Id__c : appScoringEntity.Experian_PCCE_Id__c != null ? appScoringEntity.Experian_PCCE_Id__c : null;
							applicationProfile.Bureau_Report_1__c = appScoringEntity.Report_1__c != null ? appScoringEntity.Report_1__c : null;
							applicationProfile.Bureau_Report_2__c = appScoringEntity.Report_2__c != null ? appScoringEntity.Report_2__c : null;
							applicationProfile.Bureau_Worst_Report__c = appScoringEntity.WRSTREPORT__c != null ? appScoringEntity.WRSTREPORT__c : null;
						}
					}
				}
			}

			update applicationProfiles;
		}

		if (currentStage >= 6) {
			appScorEntityMap = mapStage6AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		if (currentStage >= 7) {
			appScorEntityMap = mapStage7AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		if (currentStage >= 8) {
			appScorEntityMap = mapStage8AppScoringEntityResponseFields(appScorEntityMap, updateAppResponse);
		}

		//Perform DMLS

        insert appScorEntityMap.values();
        return appScorEntityMap.values();
	}

	/**
	 * @description Method to map the PowerCurveUpdateApplication_Resp_IB_v1 Response to the Application_Scoring_Product__c List based on the Current Stage.
	 * @author JQUEV | 2021-01-05
	 * @param updateAppResponse
	 * @param appScoring
	 * @param currentStage
	 * @return List<Application_Scoring_Product__c>
	**/
	public static List<Application_Scoring_Product__c> mapResponseAppScoringProductFields(PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse, Application_Scoring__c appScoring, Integer currentStage) {
		//Create Application_Scoring_Product__c Records for Each Existing Product returned in Response and add them to the Map with an Index
        Map<String, Application_Scoring_Product__c> appScorProductMap = new Map<String, Application_Scoring_Product__c>();

		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//TO DO: Only create Application_Scoring_Product__c for ExistingProducts/RequestedProducts that have values. Empty ones will come back with '0' in all values. Identify Key Field to check

			//Loop 30 times for the maximum allowed number of Existing / Requested Product Objects
			for (Integer i = 1; i <= 30; i++) {
				//Format the index to be a String an start with 0 if less then 10
				String responseIndex = String.valueOf(i).leftPad(2, '0');
				if (appDVMap.get('ExistingProducts' + responseIndex) != null) {
					appScorProductMap.put('ExistingProducts' + responseIndex, new Application_Scoring_Product__c(Product_Type_Number__c = 'ExistingProducts' + responseIndex, Application_Scoring__c = appScoring.Id));
				}
				if (appDVMap.get('RequestedProducts' + responseIndex) != null) {
					appScorProductMap.put('RequestedProducts' + responseIndex, new Application_Scoring_Product__c(Product_Type_Number__c = 'RequestedProducts' + responseIndex, Application_Scoring__c = appScoring.Id));
				}
			}
		}

		//Maps according to the Current Stage and all prior Stages.
		//E.g. IF currentStage == 3, It will call the mapping methods for stage 1, 2 & 3.
		if (currentStage >= 1) {
			appScorProductMap = mapStage1AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 2) {
			appScorProductMap = mapStage2AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 3) {
			appScorProductMap = mapStage3AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 4) {
			appScorProductMap = mapStage4AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 5) {
			appScorProductMap = mapStage5AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 6) {
			appScorProductMap = mapStage6AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 7) {
			appScorProductMap = mapStage7AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}
		if (currentStage >= 8) {
			appScorProductMap = mapStage8AppScoringProductResponseFields(appScorProductMap, updateAppResponse);
		}

		//Perform DMLS
		insert appScorProductMap.values();

		return appScorProductMap.values();
	}

	/**
	 * @description Stage 1 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage1AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPEXCS != null) {
			appScoring.WRSTPRINCIPALP1VP2__c = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPEXCS.WRSTPRINCIPALP1VP2;
		}
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPGPAM?.GUINESSRATING != null) {
			appScoring.GuinessRating__c = Decimal.valueOf(updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPGPAM.GUINESSRATING);
		}
		return appScoring;
	}

	/**
	 * @description Stage 2 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage2AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPSECO?.TOTASVOFFERED != null) {
			appScoring.ASV_Offered__c = Decimal.valueOf(updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPSECO.TOTASVOFFERED);
		}

		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPSECE?.SPECASVALLACCAVAIL != null) {
			appScoring.Specific_ASV_Available__c = Decimal.valueOf(updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPSECE.SPECASVALLACCAVAIL);
		}

		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPSECE?.NETEXSTASV != null) {
			appScoring.Net_Existing_ASV__c = Decimal.valueOf(updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPSECE.NETEXSTASV);
		}

		return appScoring;
	}

	/**
	 * @description Stage 3 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @param potOrdCred
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage3AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse, Decimal potOrdCred) {
		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPBCAP != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DERAPPBCAP DERAPPBCAP_Obj = updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPBCAP;

            appScoring.Potential_Ordinary_Credit__c = potOrdCred;
			appScoring.ClTurnFinal__c = DERAPPBCAP_Obj.CLTURNFINAL != null ? Decimal.valueOf(DERAPPBCAP_Obj.CLTURNFINAL) : null;
			appScoring.RubcTurnFinal__c = DERAPPBCAP_Obj.RUBCTURNFINAL != null ? Decimal.valueOf(DERAPPBCAP_Obj.RUBCTURNFINAL) : null;
			appScoring.RbcTurnFinal__c = DERAPPBCAP_Obj.RBCTURNFINAL != null ? Decimal.valueOf(DERAPPBCAP_Obj.RBCTURNFINAL) : null;
			appScoring.BeNetworth__c = DERAPPBCAP_Obj.BENETWORTH != null ? Decimal.valueOf(DERAPPBCAP_Obj.BENETWORTH) : null;
			appScoring.RbcBeNetworth__c = DERAPPBCAP_Obj.RBCBENETWORTH != null ? Decimal.valueOf(DERAPPBCAP_Obj.RBCBENETWORTH) : null;
		}
		return appScoring;
	}

	/**
	 * @description Stage 4 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage4AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPMIAE != null) {
			appScoring.MIAERequired__c = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPMIAE.REQUIRED;
		}
		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPBCAP != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DERAPPBCAP DERAPPBCAP_Obj = updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPBCAP;

			appScoring.PrNwTotal__c = DERAPPBCAP_Obj.PRNWTOTAL != null ? Decimal.valueOf(DERAPPBCAP_Obj.PRNWTOTAL) : null;
			appScoring.RubcPrNetworth__c = DERAPPBCAP_Obj.RUBCPRNETWORTH != null ? Decimal.valueOf(DERAPPBCAP_Obj.RUBCPRNETWORTH) : null;
			appScoring.RbcPrNetworth__c = DERAPPBCAP_Obj.RBCPRNETWORTH != null ? Decimal.valueOf(DERAPPBCAP_Obj.RBCPRNETWORTH) : null;
			appScoring.PrNetworth__c = DERAPPBCAP_Obj.PRNWORTH != null ? Decimal.valueOf(DERAPPBCAP_Obj.PRNWORTH) : null;
		}

		if (updateAppResponse?.Response?.ApplicationDV?.DecisionData?.DECAPPILST != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DECAPPILST DECAPPILST_Obj = updateAppResponse.Response.ApplicationDV.DecisionData.DECAPPILST;

			appScoring.ILST_Decision__c = DECAPPILST_Obj.DECISION;
			appScoring.ILST_Decision_Date__c = DECAPPILST_Obj.DECISIONDATE != null ? Date.valueOf(DECAPPILST_Obj.DECISIONDATE) : null;

			//Convert String value to Instance of Time
			if (DECAPPILST_Obj.DECISIONTIME != null) {
				String[] strTimeSplit = DECAPPILST_Obj.DECISIONTIME.split(':');
				appScoring.ILST_Decision_Time__c = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);
			}
			appScoring.ILST_Reason__c = DECAPPILST_Obj.REASON != null ? String.join(DECAPPILST_Obj.REASON, ',') : null;
			appScoring.ILST_Reason_Description__c = DECAPPILST_Obj.REASONDESCRIPTION != null ? String.join(DECAPPILST_Obj.REASONDESCRIPTION, ',') : null;
			appScoring.ILST_Exception__c = DECAPPILST_Obj.EXCEPTION_Z != null ? String.join(DECAPPILST_Obj.EXCEPTION_Z, ',') : null;
			appScoring.ILST_Exception_Description__c = DECAPPILST_Obj.EXCEPTIONDESCRIPTION != null ? String.join(DECAPPILST_Obj.EXCEPTIONDESCRIPTION, ',') : null;
		}

		//New Mappings Added 2021-01-20
		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPEXPO != null) {
			//Assign to Variable for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DERAPPEXPO DERAPPEXPO_Obj = updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPEXPO;

			//Do Mappings
			appScoring.Potential_TGBE_Offered__c = DERAPPEXPO_Obj.REQPOTENTIALTGBE != null ? Decimal.valueOf(DERAPPEXPO_Obj.REQPOTENTIALTGBE) : null;
			appScoring.ReqPotentialTotGroup__c = DERAPPEXPO_Obj.REQPOTENTIALTOTGROUP != null ? Decimal.valueOf(DERAPPEXPO_Obj.REQPOTENTIALTOTGROUP) : null;
			appScoring.Offered_Total_Financing_Limit__c = DERAPPEXPO_Obj.REQPOTENTIALTFL != null ? Decimal.valueOf(DERAPPEXPO_Obj.REQPOTENTIALTFL) : null;
		}

		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData?.DERAPPSECE != null) {
			//Assign to Variable for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DERAPPSECE DERAPPSECE_Obj = updateAppResponse.Response.ApplicationDV.DerivedCalcAppData.DERAPPSECE;

			//Do Mappings
			appScoring.ASV_Shortfall_Amount_after_Tolerance__c = DERAPPSECE_Obj.ASVSHORTFALLAFTERTOLER != null ? Decimal.valueOf(DERAPPSECE_Obj.ASVSHORTFALLAFTERTOLER) : null;
			appScoring.ASV_Shortfall_Amount__c = DERAPPSECE_Obj.ASVSHORTFALLAMNT != null ? Decimal.valueOf(DERAPPSECE_Obj.ASVSHORTFALLAMNT) : null;
		}

		return appScoring;
	}

	/**
	 * @description Stage 5 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage5AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoring;
	}

	/**
	 * @description Stage 6 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage6AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPSCRD != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.RESAPPSCRD RESAPPSCRD_Obj = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPSCRD;

			//Do Mappings
			appScoring.Variable_Months_With_Absa__c = RESAPPSCRD_Obj.VARSMONTHSWITHABSA != null ? Decimal.valueOf(RESAPPSCRD_Obj.VARSMONTHSWITHABSA) : null;
			appScoring.Variable_Total_Enquiries_L12_Months__c = RESAPPSCRD_Obj.VARSTOTENQL12M != null ? Decimal.valueOf(RESAPPSCRD_Obj.VARSTOTENQL12M) : null;
			appScoring.Variable_Total_Enquiries_L3_Months__c = RESAPPSCRD_Obj.VARSTOTENQL3M != null ? Decimal.valueOf(RESAPPSCRD_Obj.VARSTOTENQL3M) : null;
			appScoring.Variable_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.VARSWRSTARRSEVER;
			appScoring.Most_Recent_Payment_Profile_Opened__c = RESAPPSCRD_Obj.VARSDAYSMRECPPOPEN != null ? Decimal.valueOf(RESAPPSCRD_Obj.VARSDAYSMRECPPOPEN) : null;
			appScoring.Total_Num_Closed_Payment_Profiles__c = RESAPPSCRD_Obj.VARSTOTNUMCLOSEDPPS != null ? Decimal.valueOf(RESAPPSCRD_Obj.VARSTOTNUMCLOSEDPPS) : null;
			appScoring.Variable_Worst_Bureau_Report__c = RESAPPSCRD_Obj.VARSWRSTBURREPORT;
			appScoring.Overdraft_Score__c = RESAPPSCRD_Obj.ODSCORE != null ? Decimal.valueOf(RESAPPSCRD_Obj.ODSCORE) : null;
			appScoring.Score_Worst_Bureau_Report__c = RESAPPSCRD_Obj.SCORWRSTBURREPORT;
			appScoring.Score_Months_With_Absa__c = RESAPPSCRD_Obj.SCORMONTHSWITHABSA != null ? Decimal.valueOf(RESAPPSCRD_Obj.SCORMONTHSWITHABSA) : null;
			appScoring.Score_Days_Since_Last_Credit__c = RESAPPSCRD_Obj.SCORDAYSSNCELASTCREDIT != null ? Decimal.valueOf(RESAPPSCRD_Obj.SCORDAYSSNCELASTCREDIT) : null;
			appScoring.Score_Total_Enquiries_L12_Months__c = RESAPPSCRD_Obj.SCORTOTENQL12M != null ? Decimal.valueOf(RESAPPSCRD_Obj.SCORTOTENQL12M) : null;
			appScoring.Business_Entity_Excess_Indicator__c = RESAPPSCRD_Obj.SCORBEEXCSINDICATOR;
			appScoring.Principal_Worst_Excess_Indicator__c = RESAPPSCRD_Obj.SCOREXCSWRSTPRINCIPAL;
			appScoring.Score_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.SCORWRSTARRSEVER;
			appScoring.ScoreGuinessRating__c = RESAPPSCRD_Obj.SCORGUINESSRATING != null ? Integer.valueOf(RESAPPSCRD_Obj.SCORGUINESSRATING) : null;
			appScoring.Score_Total_Enquiries_L3_Months__c = RESAPPSCRD_Obj.SCORTOTENQL3M != null ? Integer.valueOf(RESAPPSCRD_Obj.SCORTOTENQL3M) : null;
			appScoring.Score_Absa_Chq_Acc_Relationship__c = RESAPPSCRD_Obj.SCORABSACHQACCRELATIONSHIP;
			appScoring.Score_Most_Recent_Payment_Profile_Opened__c = RESAPPSCRD_Obj.SCORDAYSMRECPPOPEN != null ? Integer.valueOf(RESAPPSCRD_Obj.SCORDAYSMRECPPOPEN) : null;
			appScoring.Score_Total_Num_Closed_Payment_Profiles__c = RESAPPSCRD_Obj.SCORTOTNUMCLOSEDPPS != null ? Integer.valueOf(RESAPPSCRD_Obj.SCORTOTNUMCLOSEDPPS) : null;
			appScoring.Score_Absa_Number_of_Products__c = RESAPPSCRD_Obj.SCORABSANUMBEROFPRODUCTS != null ? Integer.valueOf(RESAPPSCRD_Obj.SCORABSANUMBEROFPRODUCTS) : null;
			appScoring.OD_RNG_Time_Since_Last_Credit__c = RESAPPSCRD_Obj.ODRNGTIMESINCELASTCRED;
			appScoring.OD_RNG_Enq_P1_Tot_Num_L12M__c = RESAPPSCRD_Obj.ODRNGENQP1TOTNUML12M;
			appScoring.OD_RNG_P1_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.ODRNGP1WRSTEVERARRS;
			appScoring.OD_RNG_Tot_Guiness_Rating__c = RESAPPSCRD_Obj.ODRNGTOTGUINESSRATING!= null? RESAPPSCRD_Obj.ODRNGTOTGUINESSRATING.replaceAll('&lt;', '<'): null;
			appScoring.OD_RNG_Time_With_Absa__c = RESAPPSCRD_Obj.ODRNGTIMEWITHABSA!= null ? RESAPPSCRD_Obj.ODRNGTIMEWITHABSA.replaceAll('&lt;', '<'): null;
			appScoring.OD_RNG_Be_Excess_Ind__c = RESAPPSCRD_Obj.ODRNGBEEXCESSIND;
			appScoring.OD_RNG_Pr_Worst_Excess__c = RESAPPSCRD_Obj.ODRNGPRWRSTEXCESS;
			appScoring.OD_RNG_Pr_Worst_Report__c = RESAPPSCRD_Obj.ODRNGPRWRSTREPORT;
			appScoring.OD_SCR_Time_Since_Last_Credit__c = RESAPPSCRD_Obj.ODSCRTIMESINCELASTCRED != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRTIMESINCELASTCRED) : null;
			appScoring.OD_SCR_Enq_P1_Tot_Num_L12M__c = RESAPPSCRD_Obj.ODSCRENQP1TOTNUML12M != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRENQP1TOTNUML12M) : null;
			appScoring.OD_SCR_P1_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.ODSCRP1WRSTEVERARRS != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRP1WRSTEVERARRS) : null;
			appScoring.OD_SCR_Tot_Guiness_Rating__c = RESAPPSCRD_Obj.ODSCRTOTGUINESSRATING != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRTOTGUINESSRATING) : null;
			appScoring.OD_SCR_Time_With_Absa__c = RESAPPSCRD_Obj.ODSCRTIMEWITHABSA != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRTIMEWITHABSA) : null;
			appScoring.OD_SCR_Be_Excess_Ind__c = RESAPPSCRD_Obj.ODSCRBEEXCESSIND != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRBEEXCESSIND) : null;
			appScoring.OD_SCR_PR_Worst_Excess__c = RESAPPSCRD_Obj.ODSCRPRWRSTEXCESS != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRPRWRSTEXCESS) : null;
			appScoring.OD_SCR_PR_Worst_Report__c = RESAPPSCRD_Obj.ODSCRPRWRSTREPORT != null ? Integer.valueOf(RESAPPSCRD_Obj.ODSCRPRWRSTREPORT) : null;
			appScoring.TL_RNG_Absa_Chq_Acc__c = RESAPPSCRD_Obj.TLRNGABSACHQACC;
			appScoring.TL_RNG_Enq_P1_Tot_Num_L12M__c = RESAPPSCRD_Obj.TLRNGENQP1TOTNUML12M;
			appScoring.TL_RNG_Enq_P1_Tot_Num_L3M__c = RESAPPSCRD_Obj.TLRNGENQP1TOTNUML3M;
			appScoring.TL_RNG_Time_Since_Mrec_Op__c = RESAPPSCRD_Obj.TLRNGTIMESINCEMRECOP;
			appScoring.TL_RNG_P1_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.TLRNGP1WRSTEVERARRS;
			appScoring.TL_RNG_Absa_Num_Products__c = RESAPPSCRD_Obj.TLRNGABSANUMPRODUCTS;
			appScoring.TL_RNG_Tot_Guiness_Rating__c = RESAPPSCRD_Obj.TLRNGTOTGUINESSRATING;
			appScoring.TL_RNG_Be_Excess_Ind__c = RESAPPSCRD_Obj.TLRNGBEEXCESSIND;
			appScoring.TL_RNG_Pr_Worst_Excess__c = RESAPPSCRD_Obj.TLRNGPRWRSTEXCESS;
			appScoring.TL_RNG_Pr_Worst_Report__c = RESAPPSCRD_Obj.TLRNGPRWRSTREPORT;
			appScoring.TL_SCR_Absa_Chq_Acc__c = RESAPPSCRD_Obj.TLSCRABSACHQACC != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRABSACHQACC) : null;
			appScoring.TL_SCR_Enq_P1_Tot_Num_L12M__c = RESAPPSCRD_Obj.TLSCRENQP1TOTNUML12M != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRENQP1TOTNUML12M) : null;
			appScoring.TL_SCR_Enq_P1_Tot_Num_L3M__c = RESAPPSCRD_Obj.TLSCRENQP1TOTNUML3M != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRENQP1TOTNUML3M) : null;
			appScoring.TL_SCR_Time_Since_Mrec_Op__c = RESAPPSCRD_Obj.TLSCRTIMESINCEMRECOP != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRTIMESINCEMRECOP) : null;
			appScoring.TL_SCR_P1_Worst_Ever_Arrears__c = RESAPPSCRD_Obj.TLSCRP1WRSTEVERARRS != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRP1WRSTEVERARRS) : null;
			appScoring.TL_SCR_Absa_Num_Products__c = RESAPPSCRD_Obj.TLSCRABSANUMPRODUCTS != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRABSANUMPRODUCTS) : null;
			appScoring.TL_SCR_Tot_Guiness_Rating__c = RESAPPSCRD_Obj.TLSCRTOTGUINESSRATING != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRTOTGUINESSRATING) : null;
			appScoring.TL_SCR_Be_Excess_Ind__c = RESAPPSCRD_Obj.TLSCRBEEXCESSIND != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRBEEXCESSIND) : null;
			appScoring.TL_SCR_Pr_Worst_Excess__c = RESAPPSCRD_Obj.TLSCRPRWRSTEXCESS != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRPRWRSTEXCESS) : null;
			appScoring.TL_SCR_Pr_Worst_Report__c = RESAPPSCRD_Obj.TLSCRPRWRSTREPORT != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRPRWRSTREPORT) : null;
			appScoring.TL_RNG_PPS_All_Cls_PPS__c = RESAPPSCRD_Obj.TLRNGPPSALLCLSPPS;
			appScoring.TL_SCR_PPS_All_Cls_PPS__c = RESAPPSCRD_Obj.TLSCRPPSALLCLSPPS != null ? Integer.valueOf(RESAPPSCRD_Obj.TLSCRPPSALLCLSPPS) : null;
		}
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPRISK != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.RESAPPRISK RESAPPRISK_Obj = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPRISK;

			appScoring.OD_Applicant_Risk__c = RESAPPRISK_Obj.ODAPPLICANTRISK != null ? Integer.valueOf(RESAPPRISK_Obj.ODAPPLICANTRISK) : null;
			appScoring.TLN_Applicant_Risk__c = RESAPPRISK_Obj.TLNAPPLICANTRISK != null ? Integer.valueOf(RESAPPRISK_Obj.TLNAPPLICANTRISK) : null;
			appScoring.Worst_Applicant_Risk__c = RESAPPRISK_Obj.WRSTAPPLICANTRISK != null ? Integer.valueOf(RESAPPRISK_Obj.WRSTAPPLICANTRISK) : null;
		}
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPOVRD != null) {
			appScoring.Override_Allowable__c = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPOVRD.OVERRIDEALLOWABLE;
		}
		return appScoring;
	}

	/**
	 * @description Stage 7 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage7AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV?.DerivedCalcAppData != null) {
			//Assign to Variable for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DerivedCalcAppData derivedCalcAppData = updateAppResponse.Response.ApplicationDV.DerivedCalcAppData;

			if (derivedCalcAppData.DERAPPEXPO != null) {
				appScoring.Offered_Total_Financing_Limit__c = derivedCalcAppData.DERAPPEXPO.OFFRTOTFINANCINGLMT != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.OFFRTOTFINANCINGLMT) : null;
				appScoring.Final_Total_Financing_Limit__c = derivedCalcAppData.DERAPPEXPO.FINALTOTFINANCINGLMT != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.FINALTOTFINANCINGLMT) : null;
				//appScoring.Potential_TGBE_Offered__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGBEOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGBEOFFERED) : null;
				appScoring.Potential_TGAE_Offered__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGAEOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGAEOFFERED) : null;
				appScoring.Potential_TGBOE_Offered__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGBOEOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGBOEOFFERED) : null;
				appScoring.Potential_TGE_Offered__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGEOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGEOFFERED) : null;
				appScoring.Potential_OC_Offered__c = derivedCalcAppData.DERAPPEXPO.POTENTIALOCOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALOCOFFERED) : null;
				appScoring.Potential_TGBE_Final__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGBEFINAL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGBEFINAL) : null;
				appScoring.Potential_TGAE_Final__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGAEFINAL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGAEFINAL) : null;
				appScoring.Potential_TGBOE_Final__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGBOEFINAL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGBOEFINAL) : null;
				appScoring.Potential_TGE_Final__c = derivedCalcAppData.DERAPPEXPO.POTENTIALTGEFINAL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALTGEFINAL) : null;
				appScoring.Potential_OC_Final__c = derivedCalcAppData.DERAPPEXPO.POTENTIALOCFINAL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPEXPO.POTENTIALOCFINAL) : null;
			}
			if (derivedCalcAppData.DERAPPCOFC != null) {
				appScoring.Total_Cost_of_New_Facilities__c = derivedCalcAppData.DERAPPCOFC.TOTALTOTALCOSTFACILITIES != null ? Decimal.valueOf(derivedCalcAppData.DERAPPCOFC.TOTALTOTALCOSTFACILITIES) : null;
				appScoring.Total_Cost_of_Current_Facilities__c = derivedCalcAppData.DERAPPCOFC.TOTALCURRTOTALCOSTFACILITIES != null ? Decimal.valueOf(derivedCalcAppData.DERAPPCOFC.TOTALCURRTOTALCOSTFACILITIES) : null;
			}
			if (derivedCalcAppData.DERAPPMIAE != null) {
				appScoring.Necessary_Expenses_Shortfall__c = derivedCalcAppData.DERAPPMIAE.EXPNECESSARYSHORTFALL != null ? Decimal.valueOf(derivedCalcAppData.DERAPPMIAE.EXPNECESSARYSHORTFALL) : null;
			}
			if (derivedCalcAppData.APPAPPMIAE != null) {
				appScoring.Discret_Final__c = derivedCalcAppData.APPAPPMIAE.INCDISCRETFINAL != null ? Decimal.valueOf(derivedCalcAppData.APPAPPMIAE.INCDISCRETFINAL) : null;
				appScoring.Stress_Allowance__c = derivedCalcAppData.APPAPPMIAE.INCBUFFERAMNT != null ? Decimal.valueOf(derivedCalcAppData.APPAPPMIAE.INCBUFFERAMNT) : null;
				appScoring.Discret_Available__c = derivedCalcAppData.APPAPPMIAE.INCDISCRETAVAILABLE != null ? Decimal.valueOf(derivedCalcAppData.APPAPPMIAE.INCDISCRETAVAILABLE) : null;
				appScoring.Surplus__c = derivedCalcAppData.APPAPPMIAE.SURPLUS != null ? Decimal.valueOf(derivedCalcAppData.APPAPPMIAE.SURPLUS) : null;
			}
			if (derivedCalcAppData.DERAPPASV != null) {
				appScoring.Total_Offered__c = derivedCalcAppData.DERAPPASV.TOTALOFFERED != null ? Decimal.valueOf(derivedCalcAppData.DERAPPASV.TOTALOFFERED) : null;
			}
		}
		if (updateAppResponse?.Response?.ApplicationDV?.StratRes1?.RESAPPDLET != null) {
			appScoring.Decline_Letter_Codes__c = updateAppResponse.Response.ApplicationDV.StratRes1.RESAPPDLET.DECLINELETTERCODES;
		}
		if (updateAppResponse?.Response?.ApplicationDV?.DecisionData?.DECAPPSYST != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DECAPPSYST DECAPPSYST_Obj = updateAppResponse.Response.ApplicationDV.DecisionData.DECAPPSYST;

			appScoring.SYST_Decision__c = DECAPPSYST_Obj.DECISION;
			appScoring.SYST_Decision_Date__c = DECAPPSYST_Obj.DECISIONDATE != null ? Date.valueOf(DECAPPSYST_Obj.DECISIONDATE) : null;

			//Convert String value to Instance of Time
			if (DECAPPSYST_Obj.DECISIONTIME != null) {
				String[] strTimeSplit = DECAPPSYST_Obj.DECISIONTIME.split(':');
				appScoring.SYST_Decision_Time__c = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);
			}
		}
		if (updateAppResponse?.Response?.ApplicationDV?.DecisionData?.DECAPPFINAL != null) {
			//Assign to Object for readability
			PowerCurveUpdateApplication_Resp_IB_v1.DecisionData DecisionData_Obj = updateAppResponse.Response.ApplicationDV.DecisionData;

			appScoring.Final_Decision__c = DecisionData_Obj.DECAPPFINAL.DECISION;
			appScoring.Final_Decision_Date__c = DecisionData_Obj.DECAPPFINAL.DECISIONDATE != null ? Date.valueOf(DecisionData_Obj.DECAPPFINAL.DECISIONDATE) : null;
			//Convert String value to Instance of Time
			if (DecisionData_Obj.DECAPPFINAL.DECISIONTIME != null) {
				String[] strTimeSplit = DecisionData_Obj.DECAPPFINAL.DECISIONTIME.split(':');
				appScoring.Final_Decision_Time__c = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);
			}
			appScoring.Reason__c = DecisionData_Obj.DECAPPREASON != null ? String.join(DecisionData_Obj.DECAPPREASON, ',') : null;
			appScoring.Reason_Description__c = DecisionData_Obj.DECAPPREASONDESCRIPTION != null ? String.join(DecisionData_Obj.DECAPPREASONDESCRIPTION, ',') : null;
			appScoring.Exception__c = DecisionData_Obj.DECAPPEXCEPTION != null ? String.join(DecisionData_Obj.DECAPPEXCEPTION, ',') : null;
			appScoring.Exception_Description__c = DecisionData_Obj.DECAPPEXCEPTIONDESCRIPTION != null ? String.join(DecisionData_Obj.DECAPPEXCEPTIONDESCRIPTION, ',') : null;
		}
		return appScoring;
	}

	/**
	 * @description Stage 8 Mapping for Application_Scoring__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoring
	 * @param updateAppResponse
	 * @return Application_Scoring__c
	**/
	public static Application_Scoring__c mapStage8AppScoringResponseFields(Application_Scoring__c appScoring, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoring;
	}

	/**
	 * @description Stage 1 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage1AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {

		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));
			//For Each Entity

			for (Integer i = 1; i <= appScoringEntityMap.size(); i++) {
				//IF Entity variable Exists (e.g Entity01, Entity02, Entity03, etc...)
				if (appDVMap.get('Entity0' + String.valueOf(i)) != null) {
					//Deserialize Entity Object into Untyped Map
					Map<String, Object> entityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('Entity0' + String.valueOf(i))));

					//IF Entity.INTENTAPRF is not null
					if (entityMap.get('INTENTAPRF') != null) {
						//Deserialize INTENTAPRF Object into Untyped Map
						Map<String, Object> APRFMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap.get('INTENTAPRF')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).RetailOce__c = APRFMap.get('RETAILOCE') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILOCE'))) : null;
						appScoringEntityMap.get(i).RetailOcInst__c = APRFMap.get('RETAILOCINST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILOCINST'))) : null;
						appScoringEntityMap.get(i).RetailAssetFin__c = APRFMap.get('RETAILASSETFIN') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILASSETFIN'))) : null;
						appScoringEntityMap.get(i).RetailAssetFinInst__c = APRFMap.get('RETAILASSETFININST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILASSETFININST'))) : null;
						appScoringEntityMap.get(i).RetailMloanExp__c = APRFMap.get('RETAILMLOANEXP') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILMLOANEXP'))) : null;
						appScoringEntityMap.get(i).RetailMloanInst__c = APRFMap.get('RETAILMLOANINST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('RETAILMLOANINST'))) : null;
						appScoringEntityMap.get(i).BbOce__c = APRFMap.get('BBOCE') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBOCE'))) : null;
						appScoringEntityMap.get(i).BbOceInst__c = APRFMap.get('BBOCEINST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBOCEINST'))) : null;
						appScoringEntityMap.get(i).BbAssetFin__c = APRFMap.get('BBASSETFIN') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBASSETFIN'))) : null;
						appScoringEntityMap.get(i).BbAssetFinInst__c = APRFMap.get('BBASSETFININST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBASSETFININST'))) : null;
						appScoringEntityMap.get(i).BbMloanExp__c = APRFMap.get('BBMLOANEXP') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBMLOANEXP'))) : null;
						appScoringEntityMap.get(i).BbMloanInst__c = APRFMap.get('BBMLOANINST') != null ? Decimal.valueOf(String.valueOf(APRFMap.get('BBMLOANINST'))) : null;
					}
				}

				//IF DerivedCalcEntity variable Exists (e.g DerivedCalcEntity01, DerivedCalcEntity02, DerivedCalcEntity03, etc...)
				if (appDVMap.get('DerivedCalcEntity0' + String.valueOf(i)) != null) {
					//Deserialize Entity Object into Untyped Map
					Map<String, Object> derivedCalcEntityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('DerivedCalcEntity0' + String.valueOf(i))));

					//IF Entity.DERENTCUST is not null
					if (derivedCalcEntityMap.get('DERENTCUST') != null) {
						//Deserialize DERENTCUST Object into Untyped Map
						Map<String, Object> DERENTCUSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(derivedCalcEntityMap.get('DERENTCUST')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).ExistingCredClientIndicator__c = DERENTCUSTMap.get('EXISTINGCREDCLIENTINDICATOR') != null ? String.valueOf(DERENTCUSTMap.get('EXISTINGCREDCLIENTINDICATOR')) : null;
					}

					//IF Entity.DERENTINST is not null
					if (derivedCalcEntityMap.get('DERENTINST') != null) {
						//Deserialize DERENTINST Object into Untyped Map
						Map<String, Object> DERENTINSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(derivedCalcEntityMap.get('DERENTINST')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).TotalInstallments__c = DERENTINSTMap.get('TOTALINSTALLMENTS') != null ? Decimal.valueOf(String.valueOf(DERENTINSTMap.get('TOTALINSTALLMENTS'))) : null;
					}

					//IF Entity.DERENTLMTS is not null
					if (derivedCalcEntityMap.get('DERENTLMTS') != null) {
						//Deserialize DERENTLMTS Object into Untyped Map
						Map<String, Object> DERENTLMTSMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(derivedCalcEntityMap.get('DERENTLMTS')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).TotalLimit__c = DERENTLMTSMap.get('TOTALLIMIT') != null ? Decimal.valueOf(String.valueOf(DERENTLMTSMap.get('TOTALLIMIT'))) : null;
						appScoringEntityMap.get(i).TotalCurrLimit__c = DERENTLMTSMap.get('TOTALCURRLIMIT') != null ? Decimal.valueOf(String.valueOf(DERENTLMTSMap.get('TOTALCURRLIMIT'))) : null;
					}

					//IF Entity.DERENTEXCS is not null
					if (derivedCalcEntityMap.get('DERENTEXCS') != null) {
						//Deserialize DERENTEXCS Object into Untyped Map
						Map<String, Object> DERENTEXCSMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(derivedCalcEntityMap.get('DERENTEXCS')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Total_Amount_Excess__c = DERENTEXCSMap.get('TOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERENTEXCSMap.get('TOTALAMNT'))) : null;
						appScoringEntityMap.get(i).Excess_Indicator__c = DERENTEXCSMap.get('INDICATOR') != null ? String.valueOf(DERENTEXCSMap.get('INDICATOR')) : null;
					}
					//IF Entity.DERENTARRS is not null
					if (derivedCalcEntityMap.get('DERENTARRS') != null) {
						//Deserialize DERENTARRS Object into Untyped Map
						Map<String, Object> DERENTARRSMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(derivedCalcEntityMap.get('DERENTARRS')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Total_Amount_Arrears__c = DERENTARRSMap.get('TOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERENTARRSMap.get('TOTALAMNT'))) : null;
						appScoringEntityMap.get(i).Arrears_Indicator__c = DERENTARRSMap.get('INDICATOR') != null ? String.valueOf(DERENTARRSMap.get('INDICATOR')) : null;
					}
				}
			}
		}
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 2 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage2AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//For Each Entity
			for (Integer i = 1; i <= appScoringEntityMap.size(); i++) {

				//IF DerivedCalcEntity variable Exists (e.g DerivedCalcEntity01, DerivedCalcEntity02, DerivedCalcEntity03, etc...)
				if (appDVMap.get('DerivedCalcEntity0' + String.valueOf(i)) != null) {
					//Deserialize Entity Object into Untyped Map
					Map<String, Object> entityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('DerivedCalcEntity0' + String.valueOf(i))));

					//IF Entity.RESENTBSTM is not null
					if (entityMap.get('RESENTBSTM') != null) {
						//Deserialize RESENTBSTM Object into Untyped Map
						Map<String, Object> RESENTBSTMMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap.get('RESENTBSTM')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Adverse_Indicator__c = RESENTBSTMMap.get('ADVIND') != null ? String.valueOf(RESENTBSTMMap.get('ADVIND')) : null;
					}
					//IF Entity.RESENTFNST is not null
					if (entityMap.get('RESENTFNST') != null) {
						//Deserialize RESENTFNST Object into Untyped Map
						Map<String, Object> RESENTFNSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap.get('RESENTFNST')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Financials_Required__c = RESENTFNSTMap.get('REQUIRED') != null ? String.valueOf(RESENTFNSTMap.get('REQUIRED')) : null;
					}
				}
			}
		}
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 3 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage3AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//For Each Entity
			for (Integer i = 1; i <= appScoringEntityMap.size(); i++) {
				//IF DerivedCalcEntity variable Exists (e.g DerivedCalcEntity01, DerivedCalcEntity02, DerivedCalcEntity03, etc...)
				if (appDVMap.get('DerivedCalcEntity0' + String.valueOf(i)) != null) {
					//Deserialize Entity Object into Untyped Map
					Map<String, Object> dcEntityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('DerivedCalcEntity0' + String.valueOf(i))));
					Map<String, Object> entityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('Entity0' + String.valueOf(i))));
					String idRegPassport = '';

					if (entityMap?.get('APPENTBUR') != null) {
						Map<String, Object> entityAPPENTBUR = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap?.get('APPENTBUR')));
						idRegPassport = (String)entityAPPENTBUR.get('CONSINPNATID');
					}
					else if (entityMap?.get('INTENTBUR') != null) {
						Map<String, Object> entityINTENTBUR = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap?.get('INTENTBUR')));
						idRegPassport = (String)entityINTENTBUR.get('COMMINPREGNUMBER');
					}

					appScoringEntityMap.get(i).INTENTCLIENTCODE1__c = String.valueOf(entityMap?.get('INTENTCLIENTCODE1')) != null ? String.valueOf(entityMap?.get('INTENTCLIENTCODE1')) : null;
					appScoringEntityMap.get(i).IdRegPassport__c = idRegPassport != null || idRegPassport != '' ? idRegPassport : null;

					//IF Entity.RESENTFNST is not null
					if (dcEntityMap.get('RESENTFNST') != null) {
						//Deserialize RESENTFNST Object into Untyped Map
						Map<String, Object> RESENTFNSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dcEntityMap.get('RESENTFNST')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Financials_Type_Required__c = RESENTFNSTMap.get('TYPEREQUIRED') != null ? String.valueOf(RESENTFNSTMap.get('TYPEREQUIRED')) : null;
					}
				}
			}
		}
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 4 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage4AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 5 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage5AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//For Each Entity
			for (Integer i = 1; i <= appScoringEntityMap.size(); i++) {
				//IF DerivedCalcEntity variable Exists (e.g DerivedCalcEntity01, DerivedCalcEntity02, DerivedCalcEntity03, etc...)
				if (appDVMap.get('DerivedCalcEntity0' + String.valueOf(i)) != null && appDVMap.get('Entity0' + String.valueOf(i)) != null) {
					//Deserialize Entity Object into Untyped Map
					Map<String, Object> dcEntityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('DerivedCalcEntity0' + String.valueOf(i))));
					Map<String, Object> entityMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get('Entity0' + String.valueOf(i))));
					String idRegPassport = '';

					if (entityMap?.get('APPENTBUR') != null) {
						Map<String, Object> entityAPPENTBUR = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap?.get('APPENTBUR')));
						idRegPassport = (String)entityAPPENTBUR.get('CONSINPNATID');
					}
					else if (entityMap?.get('INTENTBUR') != null) {
						Map<String, Object> entityINTENTBUR = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(entityMap?.get('INTENTBUR')));
						idRegPassport = (String)entityINTENTBUR.get('COMMINPREGNUMBER');
					}

					appScoringEntityMap.get(i).Experian_PCCE_Id__c = dcEntityMap?.get('DEREXPBURENTPCCEID') != null ? String.valueOf(dcEntityMap?.get('DEREXPBURENTPCCEID')) : null;
					appScoringEntityMap.get(i).Transunion_PCCE_Id__c = dcEntityMap?.get('DERTUBURENTPCCEID') != null ? String.valueOf(dcEntityMap?.get('DERTUBURENTPCCEID')) : null;
					appScoringEntityMap.get(i).INTENTCLIENTCODE1__c = String.valueOf(entityMap?.get('INTENTCLIENTCODE1')) != null ? String.valueOf(entityMap?.get('INTENTCLIENTCODE1')) : null;
					appScoringEntityMap.get(i).IdRegPassport__c = idRegPassport != null || idRegPassport != '' ? idRegPassport : null;

					if (dcEntityMap.get('RESENTCBST') != null) {
						//Deserialize RESENTCBST Object into Untyped Map
						Map<String, Object> RESENTCBSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(dcEntityMap?.get('RESENTCBST')));

						//Map from Untyped Map to Application_Scoring_Entity__c in Map at the index
						appScoringEntityMap.get(i).Report_1__c = RESENTCBSTMap?.get('REPORT1') != null ? String.valueOf(RESENTCBSTMap?.get('REPORT1')) : null;
						appScoringEntityMap.get(i).Report_2__c = RESENTCBSTMap?.get('REPORT2') != null ? String.valueOf(RESENTCBSTMap?.get('REPORT2')) : null;
						appScoringEntityMap.get(i).WRSTREPORT__c = RESENTCBSTMap?.get('WRSTREPORT') != null ? String.valueOf(RESENTCBSTMap?.get('WRSTREPORT')) : null;
						appScoringEntityMap.get(i).Lookup_Period__c = RESENTCBSTMap?.get('LOOKUPPERIOD') != null ? Integer.valueOf(String.valueOf(RESENTCBSTMap?.get('LOOKUPPERIOD'))) : null;
						appScoringEntityMap.get(i).Enforce_Rework__c = RESENTCBSTMap?.get('ENFORCEREWORK') != null ? String.valueOf(RESENTCBSTMap?.get('ENFORCEREWORK')) : null;
					}
				}
			}
		}
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 6 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage6AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 7 Mapping for Application_Scoring_Entity__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage7AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringEntityMap;
	}

	/**
	 * @author JQUEV | 2021-01-05
	 * @param appScoringEntityMap
	 * @param updateAppResponse
	 * @return Map<Integer, Application_Scoring_Entity__c>
	 * @description Stage 8 Mapping for Application_Scoring_Entity__c
	**/
	public static Map<Integer, Application_Scoring_Entity__c> mapStage8AppScoringEntityResponseFields(Map<Integer, Application_Scoring_Entity__c> appScoringEntityMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringEntityMap;
	}

	/**
	 * @description Stage 1 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage1AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description Stage 2 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage2AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description Stage 3 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage3AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description Stage 4 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage4AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description Stage 5 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage5AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description 	Stage 6 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage6AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

	/**
	 * @description Stage 7 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage7AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		if (updateAppResponse?.Response?.ApplicationDV != null) {
			//Deserialize ApplicationDV into Untypes Map
			Map<String, Object> appDVMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(updateAppResponse.Response.ApplicationDV));

			//For Each Product - Max of 30 per Index. If less then 30, the reachedEndOfIndex variable will exit the loop
			for (Integer i = 1; i <= 30; i++) {
				//Format the index to be a String an start with 0 if less then 10
				String productIndex = 'ExistingProducts' + String.valueOf(i).leftPad(2, '0');

				//Boolean value to exit the loop when there are no longer any objects found at the productIndex
				Boolean reachedEndOfIndex = true;

				//IF ExistingProducts variable Exists (e.g ExistingProducts01, ExistingProducts02, ExistingProducts03, etc...)
				if (appDVMap.get(productIndex) != null) {
					reachedEndOfIndex = false;
					//Deserialize ExistingProducts Object into Untyped Map
					Map<String, Object> ExistingProductMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get(productIndex)));

					//IF Entity.DERPRDEXST is not null
					if (ExistingProductMap.get('DERPRDEXST') != null) {
						//Deserialize DERPRDEXST Object into Untyped Map
						Map<String, Object> DERPRDEXSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(ExistingProductMap.get('DERPRDEXST')));

						//Map from Untyped Map to Application_Scoring_Product__c in Map at the index
						appScoringProductMap.get(productIndex).Offer_Additional_Amount__c = DERPRDEXSTMap.get('OFFERADDITIONALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERADDITIONALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Total_Amount__c = DERPRDEXSTMap.get('OFFERTOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERTOTALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Amount__c = DERPRDEXSTMap.get('OFFERREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Frequency__c = DERPRDEXSTMap.get('OFFERREDUCTIONFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERREDUCTIONFREQ'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Period__c = DERPRDEXSTMap.get('OFFERREDUCTIONPERIOD') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERREDUCTIONPERIOD'))) : null;
						appScoringProductMap.get(productIndex).Offer_Once_Off_Reduction_Amount__c = DERPRDEXSTMap.get('OFFERONCEOFFREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERONCEOFFREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Term_of_Loan__c = DERPRDEXSTMap.get('OFFERTERMOFLOAN') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERTERMOFLOAN'))) : null;
						appScoringProductMap.get(productIndex).Offer_Instalment_Frequency__c = DERPRDEXSTMap.get('OFFERINSTALMENTFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERINSTALMENTFREQ'))) : null;
						appScoringProductMap.get(productIndex).Offer_Instalment__c = DERPRDEXSTMap.get('OFFERINSTALMENT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERINSTALMENT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Int_Rate_Prime_Plus__c = DERPRDEXSTMap.get('OFFERINTRATEPRIMEPLUS') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERINTRATEPRIMEPLUS'))) : null;
						appScoringProductMap.get(productIndex).Offer_Int_Rate__c = DERPRDEXSTMap.get('OFFERINTRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERINTRATE'))) : null;
						appScoringProductMap.get(productIndex).Offer_Service_Fee__c = DERPRDEXSTMap.get('OFFERSERVICEFEE') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERSERVICEFEE'))) : null;
						appScoringProductMap.get(productIndex).Offer_OD_Limit_Type__c = DERPRDEXSTMap.get('OFFERODLIMITTYPE') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERODLIMITTYPE'))) : null;
						appScoringProductMap.get(productIndex).NCA_Quote_Req__c = DERPRDEXSTMap.get('NCAQUOTEREQ') != null ? String.valueOf(DERPRDEXSTMap.get('NCAQUOTEREQ')) : null;
						appScoringProductMap.get(productIndex).NCA_Max_Rate__c = DERPRDEXSTMap.get('NCAMAXRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('NCAMAXRATE'))) : null;
						appScoringProductMap.get(productIndex).NCA_Max_Rate_Type__c = DERPRDEXSTMap.get('NCAMAXRATETYPE') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('NCAMAXRATETYPE'))) : null;
						appScoringProductMap.get(productIndex).Offer_Init_Fee_Amount__c = DERPRDEXSTMap.get('OFFERINITFEEAMOUNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('OFFERINITFEEAMOUNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Repayment_Method__c = DERPRDEXSTMap.get('OFFERREPAYMENTMETHOD') != null ? String.valueOf(DERPRDEXSTMap.get('OFFERREPAYMENTMETHOD')) : null;
						appScoringProductMap.get(productIndex).Final_Additional_Amount__c = DERPRDEXSTMap.get('FINALADDITIONALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALADDITIONALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Total_Amount__c = DERPRDEXSTMap.get('FINALTOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALTOTALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Amount__c = DERPRDEXSTMap.get('FINALREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Frequency__c = DERPRDEXSTMap.get('FINALREDUCTIONFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALREDUCTIONFREQ'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Period__c = DERPRDEXSTMap.get('FINALREDUCTIONPERIOD') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALREDUCTIONPERIOD'))) : null;
						appScoringProductMap.get(productIndex).Final_Once_Off_Reduction_Amount__c = DERPRDEXSTMap.get('FINALONCEOFFREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALONCEOFFREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Term_of_Loan__c = DERPRDEXSTMap.get('FINALTERMOFLOAN') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALTERMOFLOAN'))) : null;
						appScoringProductMap.get(productIndex).Final_Instalment_Frequency__c = DERPRDEXSTMap.get('FINALINSTALMENTFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALINSTALMENTFREQ'))) : null;
						appScoringProductMap.get(productIndex).Final_Instalment__c = DERPRDEXSTMap.get('FINALINSTALMENT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALINSTALMENT'))) : null;
						appScoringProductMap.get(productIndex).Final_Int_Rate__c = DERPRDEXSTMap.get('FINALINTRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALINTRATE'))) : null;
						appScoringProductMap.get(productIndex).Final_Service_Fee__c = DERPRDEXSTMap.get('FINALSERVICEFEE') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALSERVICEFEE'))) : null;
						appScoringProductMap.get(productIndex).Final_OD_Limit_Type__c = DERPRDEXSTMap.get('FINALODLIMITTYPE') != null ? Integer.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALODLIMITTYPE'))) : null;
						appScoringProductMap.get(productIndex).Final_Init_Fee_Amount__c = DERPRDEXSTMap.get('FINALINITFEEAMOUNT') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALINITFEEAMOUNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Repayment_Method__c = DERPRDEXSTMap.get('FINALREPAYMENTMETHOD') != null ? String.valueOf(DERPRDEXSTMap.get('FINALREPAYMENTMETHOD')) : null;
						appScoringProductMap.get(productIndex).Final_Int_Rate_Prime_Plus__c = DERPRDEXSTMap.get('FINALINTRATEPRIMEPLUS') != null ? Decimal.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALINTRATEPRIMEPLUS'))) : null;
						appScoringProductMap.get(productIndex).Final_Decision__c = DERPRDEXSTMap.get('FINALDECISION') != null ? String.valueOf(DERPRDEXSTMap.get('FINALDECISION')) : null;
						appScoringProductMap.get(productIndex).Final_Decision_Date__c = DERPRDEXSTMap.get('FINALDECDATE') != null ? Date.valueOf(String.valueOf(DERPRDEXSTMap.get('FINALDECDATE'))) : null;

						//Convert String value to Instance of Time
						if (DERPRDEXSTMap.get('FINALDECTIME') != null) {
							String[] strTimeSplit = String.valueOf(DERPRDEXSTMap.get('FINALDECTIME')).split(':');
							appScoringProductMap.get(productIndex).Final_Decision_Time__c = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);
						}
						appScoringProductMap.get(productIndex).Reason_Override__c = DERPRDEXSTMap.get('REASONOVERRIDE') != null ? String.valueOf(DERPRDEXSTMap.get('REASONOVERRIDE')) : null;
						appScoringProductMap.get(productIndex).Decline_Letter__c = DERPRDEXSTMap.get('DECLINELETTER') != null ? String.valueOf(DERPRDEXSTMap.get('DECLINELETTER')) : null;
					}
					if (ExistingProductMap.get('INTPRDEXST') != null) {
						Map<String, Object> INTPRDEXSTMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(ExistingProductMap.get('INTPRDEXST')));
						appScoringProductMap.get(productIndex).Account_Number__c = INTPRDEXSTMap.get('ACCOUNTNUMBER') != null ? String.valueOf(INTPRDEXSTMap.get('ACCOUNTNUMBER')) : null;
					}
				}

				//Change productIndex to be for RequestedProducts
				productIndex = 'RequestedProducts' + String.valueOf(i).leftPad(2, '0');

				//IF RequestedProducts variable Exists (e.g RequestedProducts01, RequestedProducts02, RequestedProducts03, etc...)
				if (appDVMap.get(productIndex) != null) {
					reachedEndOfIndex = false;
					//Deserialize RequestedProducts Object into Untyped Map
					Map<String, Object> requestedProductMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(appDVMap.get(productIndex)));

					//IF Product.DERPRDNEWF is not null
					if (requestedProductMap.get('DERPRDNEWF') != null) {
						//Deserialize DERPRDNEWF Object into Untyped Map
						Map<String, Object> DERPRDNEWFMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestedProductMap.get('DERPRDNEWF')));

						//Map from Untyped Map to Application_Scoring_Product__c in Map at the index
						appScoringProductMap.get(productIndex).Offer_Additional_Amount__c = DERPRDNEWFMap.get('OFFERADDITIONALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERADDITIONALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Total_Amount__c = DERPRDNEWFMap.get('OFFERTOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERTOTALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Amount__c = DERPRDNEWFMap.get('OFFERREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Frequency__c = DERPRDNEWFMap.get('OFFERREDUCTIONFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERREDUCTIONFREQ'))) : null;
						appScoringProductMap.get(productIndex).Offer_Reduction_Period__c = DERPRDNEWFMap.get('OFFERREDUCTIONPERIOD') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERREDUCTIONPERIOD'))) : null;
						appScoringProductMap.get(productIndex).Offer_Once_Off_Reduction_Amount__c = DERPRDNEWFMap.get('OFFERONCEOFFREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERONCEOFFREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Term_of_Loan__c = DERPRDNEWFMap.get('OFFERTERMOFLOAN') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERTERMOFLOAN'))) : null;
						appScoringProductMap.get(productIndex).Offer_Instalment_Frequency__c = DERPRDNEWFMap.get('OFFERINSTALMENTFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERINSTALMENTFREQ'))) : null;
						appScoringProductMap.get(productIndex).Offer_Instalment__c = DERPRDNEWFMap.get('OFFERINSTALMENT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERINSTALMENT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Int_Rate_Prime_Plus__c = DERPRDNEWFMap.get('OFFERINTRATEPRIMEPLUS') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERINTRATEPRIMEPLUS'))) : null;
						appScoringProductMap.get(productIndex).Offer_Int_Rate__c = DERPRDNEWFMap.get('OFFERINTRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERINTRATE'))) : null;
						appScoringProductMap.get(productIndex).Offer_Service_Fee__c = DERPRDNEWFMap.get('OFFERSERVICEFEE') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERSERVICEFEE'))) : null;
						appScoringProductMap.get(productIndex).Offer_OD_Limit_Type__c = DERPRDNEWFMap.get('OFFERODLIMITTYPE') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERODLIMITTYPE'))) : null;
						appScoringProductMap.get(productIndex).NCA_Quote_Req__c = DERPRDNEWFMap.get('NCAQUOTEREQ') != null ? String.valueOf(DERPRDNEWFMap.get('NCAQUOTEREQ')) : null;
						appScoringProductMap.get(productIndex).NCA_Max_Rate__c = DERPRDNEWFMap.get('NCAMAXRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('NCAMAXRATE'))) : null;
						appScoringProductMap.get(productIndex).NCA_Max_Rate_Type__c = DERPRDNEWFMap.get('NCAMAXRATETYPE') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('NCAMAXRATETYPE'))) : null;
						appScoringProductMap.get(productIndex).Offer_Init_Fee_Amount__c = DERPRDNEWFMap.get('OFFERINITFEEAMOUNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('OFFERINITFEEAMOUNT'))) : null;
						appScoringProductMap.get(productIndex).Offer_Repayment_Method__c = DERPRDNEWFMap.get('OFFERREPAYMENTMETHOD') != null ? String.valueOf(DERPRDNEWFMap.get('OFFERREPAYMENTMETHOD')) : null;
						appScoringProductMap.get(productIndex).Final_Additional_Amount__c = DERPRDNEWFMap.get('FINALADDITIONALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALADDITIONALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Total_Amount__c = DERPRDNEWFMap.get('FINALTOTALAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALTOTALAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Amount__c = DERPRDNEWFMap.get('FINALREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Frequency__c = DERPRDNEWFMap.get('FINALREDUCTIONFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALREDUCTIONFREQ'))) : null;
						appScoringProductMap.get(productIndex).Final_Reduction_Period__c = DERPRDNEWFMap.get('FINALREDUCTIONPERIOD') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALREDUCTIONPERIOD'))) : null;
						appScoringProductMap.get(productIndex).Final_Once_Off_Reduction_Amount__c = DERPRDNEWFMap.get('FINALONCEOFFREDUCTIONAMNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALONCEOFFREDUCTIONAMNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Term_of_Loan__c = DERPRDNEWFMap.get('FINALTERMOFLOAN') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALTERMOFLOAN'))) : null;
						appScoringProductMap.get(productIndex).Final_Instalment_Frequency__c = DERPRDNEWFMap.get('FINALINSTALMENTFREQ') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALINSTALMENTFREQ'))) : null;
						appScoringProductMap.get(productIndex).Final_Instalment__c = DERPRDNEWFMap.get('FINALINSTALMENT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALINSTALMENT'))) : null;
						appScoringProductMap.get(productIndex).Final_Int_Rate__c = DERPRDNEWFMap.get('FINALINTRATE') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALINTRATE'))) : null;
						appScoringProductMap.get(productIndex).Final_Service_Fee__c = DERPRDNEWFMap.get('FINALSERVICEFEE') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALSERVICEFEE'))) : null;
						appScoringProductMap.get(productIndex).Final_OD_Limit_Type__c = DERPRDNEWFMap.get('FINALODLIMITTYPE') != null ? Integer.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALODLIMITTYPE'))) : null;
						appScoringProductMap.get(productIndex).Final_Init_Fee_Amount__c = DERPRDNEWFMap.get('FINALINITFEEAMOUNT') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALINITFEEAMOUNT'))) : null;
						appScoringProductMap.get(productIndex).Final_Repayment_Method__c = DERPRDNEWFMap.get('FINALREPAYMENTMETHOD') != null ? String.valueOf(DERPRDNEWFMap.get('FINALREPAYMENTMETHOD')) : null;
						appScoringProductMap.get(productIndex).Final_Int_Rate_Prime_Plus__c = DERPRDNEWFMap.get('FINALINTRATEPRIMEPLUS') != null ? Decimal.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALINTRATEPRIMEPLUS'))) : null;
						appScoringProductMap.get(productIndex).Final_Decision__c = DERPRDNEWFMap.get('FINALDECISION') != null ? String.valueOf(DERPRDNEWFMap.get('FINALDECISION')) : null;
						appScoringProductMap.get(productIndex).Final_Decision_Date__c = DERPRDNEWFMap.get('FINALDECDATE') != null ? Date.valueOf(String.valueOf(DERPRDNEWFMap.get('FINALDECDATE'))) : null;

						//Convert String value to Instance of Time
						if (DERPRDNEWFMap.get('FINALDECTIME') != null) {
							String[] strTimeSplit = String.valueOf(DERPRDNEWFMap.get('FINALDECTIME')).split(':');
							appScoringProductMap.get(productIndex).Final_Decision_Time__c = Time.newInstance(Integer.valueOf(strTimeSplit[0]), Integer.valueOf(strTimeSplit[1]), Integer.valueOf(strTimeSplit[2]), 0);
						}
						appScoringProductMap.get(productIndex).Reason_Override__c = DERPRDNEWFMap.get('REASONOVERRIDE') != null ? String.valueOf(DERPRDNEWFMap.get('REASONOVERRIDE')) : null;
						appScoringProductMap.get(productIndex).Decline_Letter__c = DERPRDNEWFMap.get('DECLINELETTER') != null ? String.valueOf(DERPRDNEWFMap.get('DECLINELETTER')) : null;
					}
					if (requestedProductMap.get('APPPRDNEWF') != null) {
						Map<String, Object> APPPRDNEWFMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(requestedProductMap.get('APPPRDNEWF')));
						appScoringProductMap.get(productIndex).Unique_Product_ID__c = APPPRDNEWFMap.get('UNIQUEPRODID') != null ? String.valueOf(APPPRDNEWFMap.get('UNIQUEPRODID')) : null;
					}
				}
				if (reachedEndOfIndex) {
					break;
				}
			}
		}
		return appScoringProductMap;
	}

	/**
	 * @description Stage 8 Mapping for Application_Scoring_Product__c
	 * @author JQUEV | 2021-01-05
	 * @param appScoringProductMap
	 * @param updateAppResponse
	 * @return Map<String, Application_Scoring_Product__c>
	**/
	public static Map<String, Application_Scoring_Product__c> mapStage8AppScoringProductResponseFields(Map<String, Application_Scoring_Product__c> appScoringProductMap, PowerCurveUpdateApplication_Resp_IB_v1 updateAppResponse) {
		return appScoringProductMap;
	}

    
    /**
    * @description 
    * @author JQUEV | 2021-01-05
    * @param pcoUpdateRequestBean 
    * @param updatePCO 
    * @param oppId 
    * @param app 
    **/
    public static void InsertUpdatePCO(PowerCurveUpdateApplication_Req_IB_v1 pcoUpdateRequestBean, PowerCurveUpdateApplication_Resp_IB_v1 updatePCO, String oppId, Application__c app) {
		Application_Scoring__c appScoring = new Application_Scoring__c();
		List<Application_Scoring_Entity__c> appScoringEntityLst = new List<Application_Scoring_Entity__c>();
        //Application__c app=new ApplicationsSelector().selectById(appId);
		String appNumber = String.valueOf(updatePCO?.Response?.ApplicationDV?.APPAPPAPPLICATIONNUMBER);

		if (String.isNotBlank(appNumber)) {
            Decimal ordCred = 0;

            if(pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null){
            	ordCred = pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED != null ? Decimal.valueOf(pcoUpdateRequestBean?.Request?.ApplicationDV?.Entity01?.INTENTEXPO?.ORDCRED) : 0;
            }

			if (updatePCO?.Response?.ApplicationDV != null) {
				appScoring.Application_Number__c = app.Id;
				appScoring.Stage__c = '1';
				//appScoring.DERPCOUNIQUENUMBER__c = newPCO?.Response?.ApplicationDV?.DERPCOUNIQUENUMBER;
                app.DERPCOUNIQUENUMBER__c = updatePCO?.Response?.ApplicationDV?.DERPCOUNIQUENUMBER;
				appScoring.JSON_Request__c = JSON.serialize(pcoUpdateRequestBean);

				if (updatePCO?.Response?.ApplicationDV?.StratRes1 != null) {
					//Assign to Object for readability
					PowerCurveUpdateApplication_Resp_IB_v1.StratRes1 StratRes1_Obj = updatePCO.Response.ApplicationDV.StratRes1;

					if (StratRes1_Obj.RESAPPSCRD != null) {
						appScoring.TRFCUTOFF__c = StratRes1_Obj.RESAPPSCRD.TRFCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.TRFCUTOFF) : null;
						appScoring.TLCUTOFF__c = StratRes1_Obj.RESAPPSCRD.TLCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.TLCUTOFF) : null;
						appScoring.ORDCREDSCORINGMANDATE__c = StratRes1_Obj.RESAPPSCRD.ORDCREDSCORINGMANDATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPSCRD.ORDCREDSCORINGMANDATE) : null;
						appScoring.ORDCREDLIMIT__c = StratRes1_Obj.RESAPPSCRD.ORDCREDLIMIT != null ? Decimal.valueOf(StratRes1_Obj.RESAPPSCRD.ORDCREDLIMIT) : null;
						appScoring.ODCUTOFF__c = StratRes1_Obj.RESAPPSCRD.ODCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.ODCUTOFF) : null;
						appScoring.MOODYCUTOFF__c = StratRes1_Obj.RESAPPSCRD.MOODYCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.MOODYCUTOFF) : null;
						appScoring.GCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.GCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.GCCUTOFF) : null;
						appScoring.FCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.FCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.FCCUTOFF) : null;
						appScoring.EPSCUTOFF__c = StratRes1_Obj.RESAPPSCRD.EPSCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.EPSCUTOFF) : null;
						appScoring.CPFCUTOFF__c = StratRes1_Obj.RESAPPSCRD.CPFCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.CPFCUTOFF) : null;
						appScoring.CHEQCUTOFF__c = StratRes1_Obj.RESAPPSCRD.CHEQCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.CHEQCUTOFF) : null;
						appScoring.BRLCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BRLCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BRLCUTOFF) : null;
						appScoring.BGCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BGCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BGCUTOFF) : null;
						appScoring.BCCCUTOFF__c = StratRes1_Obj.RESAPPSCRD.BCCCUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.BCCCUTOFF) : null;
						appScoring.AGRICUTOFF__c = StratRes1_Obj.RESAPPSCRD.AGRICUTOFF != null ? Integer.valueOf(StratRes1_Obj.RESAPPSCRD.AGRICUTOFF) : null;
					}
					if (StratRes1_Obj.RESAPPGPAM != null) {
						appScoring.GuinessRating__c = StratRes1_Obj.RESAPPGPAM.GUINESSRATING != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.GUINESSRATING) : null;
						appScoring.FraudReferralProcess__c = StratRes1_Obj.RESAPPGPAM.FRAUDREFERRALPROCESS != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.FRAUDREFERRALPROCESS) : null;
						appScoring.ExpIllustDaysRemove__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSREMOVE != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSREMOVE) : null;
						appScoring.ExpIllustDaysNoDecision__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSNODECISION != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSNODECISION) : null;
						appScoring.ExpIllustDaysAfterDecision__c = StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSAFTERDECISION != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.EXPILLUSTDAYSAFTERDECISION) : null;
						appScoring.AbsaDataRfreshPeriod__c = StratRes1_Obj.RESAPPGPAM.ABSADATARFRESHPERIOD != null ? Integer.valueOf(StratRes1_Obj.RESAPPGPAM.ABSADATARFRESHPERIOD) : null;
					}
					if (StratRes1_Obj.RESAPPCMNG != null) {
						appScoring.SmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.SMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.SMMINPLUSMINRATE) : null;
						appScoring.SmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.SMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.SMMAXOFFSETREDUC) : null;
						appScoring.ReMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.REMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.REMINPLUSMINRATE) : null;
						appScoring.ReMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.REMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.REMAXOFFSETREDUC) : null;
						appScoring.PmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.PMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.PMMINPLUSMINRATE) : null;
						appScoring.PmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.PMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.PMMAXOFFSETREDUC) : null;
						appScoring.HocmMinPlusMinRate__c = StratRes1_Obj.RESAPPCMNG.HOCMMINPLUSMINRATE != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.HOCMMINPLUSMINRATE) : null;
						appScoring.HocmMaxOffsetReduc__c = StratRes1_Obj.RESAPPCMNG.HOCMMAXOFFSETREDUC != null ? Decimal.valueOf(StratRes1_Obj.RESAPPCMNG.HOCMMAXOFFSETREDUC) : null;
					}

					appScoring.WRSTPRINCIPALP1VP2__c = StratRes1_Obj.RESAPPEXCS?.WRSTPRINCIPALP1VP2 != null ? StratRes1_Obj.RESAPPEXCS.WRSTPRINCIPALP1VP2 : null;

					if (updatePCO?.Response?.ApplicationDV?.DerivedCalcAppData != null) {

						//Assign to Object for readability
						PowerCurveUpdateApplication_Resp_IB_v1.DerivedCalcAppData DerivedCalcAppData_Obj = updatePCO.Response.ApplicationDV.DerivedCalcAppData;
						appScoring.SpouseDetailsRequiredInd__c = DerivedCalcAppData_Obj?.DERAPPSPSE?.SPOUSEDETAILSREQUIREDIND != null ? DerivedCalcAppData_Obj.DERAPPSPSE.SPOUSEDETAILSREQUIREDIND : null;
						appScoring.PrincApplicableInd__c = DerivedCalcAppData_Obj?.DERAPPPRIN?.PRINCAPPLICABLEIND != null ? DerivedCalcAppData_Obj.DERAPPPRIN.PRINCAPPLICABLEIND : null;
						appScoring.PreapprReprocessLowerLmtInd__c = DerivedCalcAppData_Obj?.DERAPPPAPR?.PREAPPRREPROCESSLOWERLMTIND != null ? DerivedCalcAppData_Obj.DERAPPPAPR.PREAPPRREPROCESSLOWERLMTIND : null;
						appScoring.PaprPreapprInd__c = DerivedCalcAppData_Obj?.DERAPPPAPR?.PREAPPRIND != null ? DerivedCalcAppData_Obj.DERAPPPAPR.PREAPPRIND : null;
						appScoring.ReqMaxTermVsPurpsLoanNotBond__c = DerivedCalcAppData_Obj?.DERAPPGPAM?.REQMAXTERMVSPURPSLOANNOTBOND != null ? DerivedCalcAppData_Obj.DERAPPGPAM.REQMAXTERMVSPURPSLOANNOTBOND : null;
						appScoring.ReqMaxTermVsPurpsLoanMaxTerm__c = DerivedCalcAppData_Obj?.DERAPPGPAM?.REQMAXTERMVSPURPSLOANMAXTERM != null ? Integer.valueOf(DerivedCalcAppData_Obj.DERAPPGPAM.REQMAXTERMVSPURPSLOANMAXTERM) : null;

						if (DerivedCalcAppData_Obj.DERAPPEXPO != null) {
                            appScoring.Potential_Ordinary_Credit__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC) + ordCred : null;
							appScoring.ReqTotAddPotentialOc__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQTOTADDPOTENTIALOC) : null;
							appScoring.ReqPotentialTotGroup__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTGROUP != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTGROUP) : null;
							appScoring.ReqPotentialTotDirect__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTDIRECT != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTOTDIRECT) : null;
							appScoring.ReqPotentialTgoe__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGOE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGOE) : null;
							appScoring.Potential_TGBE_Offered__c = appScoring.ReqPotentialTgbe__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGBE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGBE) : null;
							appScoring.ReqPotentialTgae__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGAE != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTGAE) : null;
							appScoring.Offered_Total_Financing_Limit__c = appScoring.ReqPotentialTfl__c = DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTFL != null ? Decimal.valueOf(DerivedCalcAppData_Obj.DERAPPEXPO.REQPOTENTIALTFL) : null;
						}
					}
				}
			}
            update app;
			insert appScoring;

			//check mapResponseAppScoringEntityFields() for reference to what was here before;
		}
	}
}