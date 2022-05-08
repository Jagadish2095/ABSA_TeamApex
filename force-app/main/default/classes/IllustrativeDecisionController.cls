/*
 * Controller for loading Illustrative Decision Data
 * @author  Himani Joshi: Absa
 * @version v1.0
 * @since   2021-01-10
 *
 */
public class IllustrativeDecisionController {
	@AuraEnabled
	public static List<Application_Scoring__c> GetDecisionSummary(Id oppId) {
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Application_Scoring__c> appScoring = new List<Application_Scoring__c>();
		appScoring = [SELECT Id, Stage__c, ILST_Decision__c, ILST_Decision_Date__c, ILST_Decision_Time__c, Potential_TGBE_Offered__c, ReqPotentialTotGroup__c, Offered_Total_Financing_Limit__c, ASV_Offered__c, ILST_Reason__c, ILST_Reason_Description__c, ILST_Exception__c, ILST_Exception_Description__c, ASV_Shortfall_Amount_after_Tolerance__c
		              FROM Application_Scoring__c
		              WHERE Application_Number__c = :application.Id AND Stage__c = '4'];
		return appScoring;
	}

	@AuraEnabled
	public static String getDecisionTime(Id oppId) {
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Application_Scoring__c> appScoring = [SELECT Id, Stage__c, ILST_Decision_Time__c, Application_Number__c
		                                           FROM Application_Scoring__c
		                                           WHERE Application_Number__c = :application.Id AND Stage__c = '4'];
		if (appScoring.size() > 0) {
			String decTime = String.valueOf(appScoring[0].ILST_Decision_Time__c);
			return decTime;
		}
		return null;
	}

	@AuraEnabled
	public static Map<String, List<String>> GetReasonsAndExceptions(Id oppId) {
		Map<String, List<String>> responseMap = new Map<String, List<String>>();
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Application_Scoring__c> appScoring = new List<Application_Scoring__c>();
		appScoring = [SELECT Id, Stage__c, ILST_Decision__c, ILST_Decision_Date__c, ILST_Decision_Time__c, Potential_TGBE_Offered__c, ReqPotentialTotGroup__c, Offered_Total_Financing_Limit__c, ASV_Offered__c, ILST_Reason__c, ILST_Reason_Description__c, ILST_Exception__c, ILST_Exception_Description__c, ASV_Shortfall_Amount_after_Tolerance__c
		              FROM Application_Scoring__c
		              WHERE Application_Number__c = :application.Id AND Stage__c = '4'];

		List<String> ReasonList = new List<String>();
		List<String> ReasonDescriptionList = new List<String>();
		List<String> ExceptionList = new List<String>();
		List<String> ExceptionDescriptionList = new List<String>();

		if (appScoring[0].ILST_Reason__c != null) {
			ReasonList = appScoring[0].ILST_Reason__c.split(',');
		}

		if (appScoring[0].ILST_Reason_Description__c != null) {
			ReasonDescriptionList = appScoring[0].ILST_Reason_Description__c.split(',');
			if (ReasonDescriptionList.size() > 0) {
				for (integer i = 0; i < ReasonDescriptionList.size(); i++) {
					if (ReasonDescriptionList[i].contains('&lt;')) {
						String removeHTMl = ReasonDescriptionList[i];
						ReasonDescriptionList[i] = removeHTMl.unescapeHtml4();
					}
				}
			}
		}

		if (appScoring[0].ILST_Exception__c != null) {
			ExceptionList = appScoring[0].ILST_Exception__c.split(',');
		}

		if (appScoring[0].ILST_Exception_Description__c != null) {
			ExceptionDescriptionList = appScoring[0].ILST_Exception_Description__c.split(',');
			if (ExceptionDescriptionList.size() > 0) {
				for (Integer i = 0; i < ExceptionDescriptionList.size(); i++) {
					if (ExceptionDescriptionList[i].contains('&lt;')) {
						String removeHTMl = ExceptionDescriptionList[i];
						ExceptionDescriptionList[i] = removeHTMl.unescapeHtml4();
					}
				}
			}
		}

		responseMap.put('ReasonList', ReasonList);
		responseMap.put('ReasonDescriptionList', ReasonDescriptionList);
		responseMap.put('ExceptionList', ExceptionList);
		responseMap.put('ExceptionDescriptionList', ExceptionDescriptionList);
		return responseMap;
	}

	@AuraEnabled
	public static List<Application_Product__c> getRequestedProduct(Id oppId) {
		//List<Application_Product__c>appProduct = new List<Application_Product__c>();
		//List<Application_Product__c> appPrdList = [SELECT  Product_Name__c,Temp_Account_Number__c,Product_Type__c,Product_State__c,Overdraft_Limit_New_Amount__c  FROM Application_Product__c WHERE  Opportunity__c=:oppId];
		List<Application_Product__c> appPrdList = [SELECT Id, Product_Amount__c, Application_Product_Parent__r.Product_Name__c, Application_Product_Parent__r.Temp_Account_Number__c, Application_Product_Parent__r.Account_Number__c, Application_Product_Parent__r.Product_Type__c, Application_Product_Parent__r.Product_State__c
		                                           FROM Application_Product__c
		                                           WHERE Opportunity__c = :oppId AND Product_Name__c = 'overdraft'];

		List<Product2> prodList = new ProductsSelector().selectByFamily('Cheque');
		List<Price_Scheme__c> priceList = new PriceSchemesSelector().selectByFamily('Cheque');
		for (Application_Product__c apd : appPrdList) {
			if (apd.Application_Product_Parent__r.Product_Type__c != null) {
				apd.Application_Product_Parent__r.Product_Type__c = ChequeAndOverdraftController.getProductTypeName(prodList, priceList, String.valueOf(apd.Application_Product_Parent__r.Product_Type__c).right(2));
			}
			//appProduct.add(apd);
		}

		return appPrdList;
	}

	@AuraEnabled
	public static List<Submission_History__c> GetSubmissionHistory(Id oppId) {
		String version = '1';
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		List<Submission_History__c> lstofSubHist = new List<Submission_History__c>();
		List<Submission_History__c> lstofSubHist1 = new List<Submission_History__c>();
		List<Submission_History__c> responseList = new List<Submission_History__c>();
		List<Application_Scoring__c> appScoring = [SELECT Id, Stage__c, ILST_Decision__c FROM Application_Scoring__c WHERE Stage__c = '4' AND Application_Number__c = :application.Id];
		lstofSubHist = [SELECT Id, Name, System_Decision__c FROM Submission_History__c WHERE type__c = 'Illustrative Decision' AND Application__c = :application.Id order by Version__c desc];

		if (lstofSubHist.size() == 0) {
			Submission_History__c sh = new Submission_History__c();
			sh.application__c = application.Id;
			sh.StageId__c = application.name;
			sh.Type__c = 'Illustrative Decision';
			sh.Version__c = version;
			sh.Submitted_By__c = application.createdby.name;
			sh.Submitted__c = application.LastModifiedDate;
			if (appScoring.size() > 0) {
				sh.System_Decision__c = appScoring[0].ILST_Decision__c;
			}
			responseList.add(sh);
		}
		if (lstofSubHist.size() > 0 && appScoring.size() > 0) {
			if (lstofSubHist[0].System_Decision__c != appScoring[0].ILST_Decision__c) {
				Submission_History__c sh = new Submission_History__c();
				sh.application__c = application.Id;
				sh.StageId__c = application.name;
				sh.Type__c = 'Illustrative Decision';
				sh.Version__c = String.valueof(lstofSubHist.size()+1);
				sh.Submitted_By__c = application.createdby.name;
				sh.Submitted__c = application.LastModifiedDate;
				sh.System_Decision__c = appScoring[0].ILST_Decision__c;
				responseList.add(sh);
			}
		}

		insert responseList;
		lstofSubHist = [SELECT Id, Name, StageId__c, Type__c, Version__c, application__c, Submitted_By__c, Submitted__c, System_Decision__c
		                FROM Submission_History__c
		                WHERE type__c = 'Illustrative Decision' AND Application__c = :application.Id
		                order by Version__c desc];

		return lstofSubHist;
	}

	@AuraEnabled
	public static String reprocess(Id oppId) {
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		//For Existing Securities
		application.asv_securities__c = 0;
		application.masv_bonds__c = 0;
		update application;

		List<Application_Security__c> appSecurityList = [SELECT Id FROM Application_Security__c WHERE Application_Id_Text__c = :application.Id];

		if (appSecurityList.size() > 0) {
			delete appSecurityList;
			Database.emptyRecycleBin(appSecurityList);
		}

		//For Spouse Deletion
		Opportunity opp = [SELECT Id, Spouse_Account_Id__c, Is_Spouse_Captured__c FROM opportunity WHERE Id = :oppId];
		List<Account> accSpouse = [SELECT Id FROM account WHERE Id = :opp.Spouse_Account_Id__c];

		if (accSpouse.size() > 0) {
			delete accSpouse;
			Database.emptyRecycleBin(accSpouse);
			opp.Is_Spouse_Captured__c = false;
			update opp;
		}

		List<Application_Profile__c> appProfileList = [SELECT Id FROM application_profile__c WHERE application__c = :application.Id];

		if (appProfileList.size() > 0) {
			delete appProfileList;
			Database.emptyRecycleBin(appProfileList);
			AllocateStockNumberController.createAppProfileRecords(oppId);
		}

		//For Exposures
		List<Application_Exposure_Risk__c> appExpRisk = [SELECT Id FROM Application_Exposure_Risk__c WHERE application__c = :application.Id];

		if (appExpRisk.size() > 0) {
			delete appExpRisk;
			Database.emptyRecycleBin(appExpRisk);
		}

		List<Application_Exposure__c> appExposureList = [SELECT Id FROM application_exposure__c WHERE application__c = :application.Id];

		if (appExposureList.size() > 0) {
			delete appExposureList;
			Database.emptyRecycleBin(appExposureList);
		}

		List<Application_Exposure_Cash_and_Investment__c> appCash = [SELECT Id FROM Application_Exposure_Cash_and_Investment__c WHERE Application__c = :application.Id];

		if (appCash.size() > 0) {
			delete appCash;
			Database.emptyRecycleBin(appCash);
		}

		List<Application_Exposure_Total_Group__c> appTotalGroup = [SELECT Id FROM Application_Exposure_Total_Group__c WHERE Application__c = :application.Id];

		if (appTotalGroup.size() > 0) {
			delete appTotalGroup;
			Database.emptyRecycleBin(appTotalGroup);
		}

		List<Application_Exposure_Facility__c> appFacility = [SELECT Id FROM Application_Exposure_Facility__c WHERE Application__c = :application.Id];

		upsert appFacility;

		//if(appFacility.size()>0){
		//delete appFacility;
		//Database.emptyRecycleBin(appFacility);
		//}

		//For Triads
		List<Application_Triad__c> appTriad = [SELECT Id FROM Application_Triad__c WHERE application__c = :application.Id];
		List<Application_Triad_Detail__c> appTriadDetails = new List<Application_Triad_Detail__c>();

		for (Application_Triad__c atrd : appTriad) {
			appTriadDetails = [SELECT Id FROM Application_Triad_Detail__c WHERE Application_Triad__c = :atrd.Id];
		}
		if (appTriad.size() > 0) {
			delete appTriad;
			Database.emptyRecycleBin(appTriad);
		}
		if (appTriadDetails.size() > 0) {
			delete appTriadDetails;
			Database.emptyRecycleBin(appTriadDetails);
		}

		//Principal Financials
		/*
		 List<Application_Assets_and_Liabilities__c>prinFinList=[SELECT Id FROM Application_Assets_and_Liabilities__c WHERE Application__c=:application.Id];
		 if(prinFinList.size()>0){
		 delete prinFinList;
		 Database.emptyRecycleBin(prinFinList);
		 }
		 */

		//PCO related records
		List<Application_Scoring__c> appScore = [SELECT Id FROM Application_Scoring__c WHERE Application_Number__c = :application.Id];

		List<Application_Scoring_Product__c> scoreProduct = new List<Application_Scoring_Product__c>();
		List<Application_Scoring_Entity__c> scoringEntity = new List<Application_Scoring_Entity__c>();
		if (appScore.size() > 0) {
			for (Application_Scoring__c var : appScore) {
				scoreProduct = [SELECT Id FROM Application_Scoring_Product__c WHERE Application_Scoring__c = :var.Id];
				scoringEntity = [SELECT Id FROM Application_Scoring_Entity__c WHERE Application_Scoring__c = :var.Id];
			}
		}

		if (scoreProduct.size() > 0) {
			delete scoreProduct;
			Database.emptyRecycleBin(scoreProduct);
		}
		if (scoringEntity.size() > 0) {
			delete scoringEntity;
			Database.emptyRecycleBin(scoringEntity);
		}
		if (appScore.size() > 0) {
			delete appScore;
			Database.emptyRecycleBin(appScore);
		}
		opp.Reprocessing__c = true;
		update opp;
		return 'Yes';
	}

	@AuraEnabled
	public static String submit(String oppId) {
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		if (opp.Illustrative_Decision__c == true) {
			PowerCurveController.pcoStageHandler(oppId, '05', True);
		}
		return 'Yes';
	}
}