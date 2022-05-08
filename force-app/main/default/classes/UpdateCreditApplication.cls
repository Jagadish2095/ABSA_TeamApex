/**
 * @description       : Apex Class for Updating Application product  from PCO update service Response for Requested Product (W-005392)
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-10-18
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class UpdateCreditApplication {
	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param appId
	 * @param stageId
	 **/
	public static void updateAppProdAfterStg7(Id appId, String stageId) {
		String systemDecision;
		String FinalDecision;

		List<Application_Scoring__c> appScoring = [
			SELECT Id, stage__c, SYST_Decision__c, Application_Number__c
			FROM Application_Scoring__c
			WHERE Application_Number__c = :appId AND stage__c = :stageId
		];
		

		if (appScoring.size() > 0) {
			if (appScoring[0].SYST_Decision__c == 'A') {
				systemDecision = 'Accepted';
			} else if (appScoring[0].SYST_Decision__c == 'D') {
				systemDecision = 'Declined';
			} else if (appScoring[0].SYST_Decision__c == 'R') {
				systemDecision = 'Credit Refer';
			} else if (appScoring[0].SYST_Decision__c == 'C') {
				systemDecision = 'Compliance Decline';
			} else if (appScoring[0].SYST_Decision__c == 'O') {
				systemDecision = 'Decline Override';
			} else if (appScoring[0].SYST_Decision__c == 'M') {
				systemDecision = 'Manual Refer';
			}

			Application__c updateApplication = new Application__c();
			updateApplication.Id = appScoring[0].Application_Number__c;
			updateApplication.Credit_System_Decision__c = systemDecision;

			List<Application_Product__c> updateAppProd = new List<Application_Product__c>();

			Application__c app = [SELECT id, opportunity__c FROM Application__c WHERE Id = :appId];

			List<Application_Product__c> appProdList = [
				SELECT
					id,
					Name,
					Product_Name__c,
					Account_Number__c,
					Product_State__c,
					Product_Status__c,
					Limit_Type__c,
					Temp_Account_Number__c,
					toLabel(Product_Type__c) producttype,
					Review_Date__c,
					Expiry_Date__c,
					NCA_Appplicable__c,
					Maximum_NCA_Rate_Type__c,
                    NCA_Quote_Required__c,
                    Facility_account_number__c,
					Maximum_NCA_Rate__c
				FROM Application_Product__c
				WHERE opportunity__c = :app.Opportunity__c AND Application_Product_Parent__c = NULL
			];

			

			List<Application_Scoring_Product__c> appScoringProd = [
				SELECT Id, Name, Final_Decision__c, Unique_Product_ID__c,NCA_Quote_Req__c, Application_Scoring__c, Account_Number__c
				FROM Application_Scoring_Product__c
				WHERE Application_Scoring__c = :appScoring[0].Id
			];
			

			if (appScoringProd.size() > 0) {
				for (Application_Scoring_Product__c appScorProd : appScoringProd) {
					if (appProdList.size() > 0) {
						for (Application_Product__c apProd : appProdList) {
							if (appScorProd.Unique_Product_ID__c != null) {
								//New Prod

								if (apProd.Name == appScorProd.Unique_Product_ID__c) {
									if (appScorProd.Final_Decision__c == 'A') {
										FinalDecision = 'Accepted';
									} else if (appScorProd.Final_Decision__c == 'C' || appScorProd.Final_Decision__c == 'D') {
										FinalDecision = 'Declined';
									} else if (
										appScorProd.Final_Decision__c == 'O' ||
										appScorProd.Final_Decision__c == 'M' ||
										appScorProd.Final_Decision__c == 'R' ||
										appScorProd.Final_Decision__c == 'P'
									) {
										FinalDecision = 'Pending';
									}

									apProd.System_Decision__c = systemDecision;
									apProd.Final_Decision__c = FinalDecision;
									apProd.Product_Status__c = FinalDecision;
                                    //Added for W-013202
                                    apProd.NCA_Quote_Required__c = appScorProd.NCA_Quote_Req__c != Null ? appScorProd.NCA_Quote_Req__c : '';
									updateAppProd.add(apProd);
								}
							} else if (appScorProd.Account_Number__c != null) {
								//Existing Prod

								if ((string.valueof(apProd.Account_Number__c) == appScorProd.Account_Number__c)|| (string.valueof(apProd.Facility_account_number__c) == appScorProd.Account_Number__c)) {
                                    // W-014052 Added match for Bank Guarranty Facility Product
									if (appScorProd.Final_Decision__c == 'A') {
										FinalDecision = 'Accepted';
									} else if (appScorProd.Final_Decision__c == 'C' || appScorProd.Final_Decision__c == 'D') {
										FinalDecision = 'Declined';
									} else if (
										appScorProd.Final_Decision__c == 'O' ||
										appScorProd.Final_Decision__c == 'M' ||
										appScorProd.Final_Decision__c == 'R' ||
										appScorProd.Final_Decision__c == 'P'
									) {
										FinalDecision = 'Pending';
									}

									apProd.System_Decision__c = systemDecision;
									apProd.Final_Decision__c = FinalDecision;
									apProd.Product_Status__c = FinalDecision;
                                    //Added for W-013202
                                    apProd.NCA_Quote_Required__c = appScorProd.NCA_Quote_Req__c != Null ? appScorProd.NCA_Quote_Req__c : '';
									updateAppProd.add(apProd);
								}
							}
						}
					}
				}
			}
			
			try {
				update updateApplication;
				update updateAppProd;
			} catch (Exception e) {
				AuditTrailLog.logException(e, 'New', 'Warning', 'Product Terms Of Business', 'Track', ''+e.getStackTraceString());

			}

			SetProductTOBController.mapFromPCOResponse(appProdList, stageId);
			SetProductTOBController.mapCCTOBFromPCOResponse(appId, appProdList, stageId);
            SetProductTOBController.mapLDPTOBFromPCOResponse(appId, appProdList, stageId);
			IncomeAndExpenseController.updateDisposalAfterCall7(appId, appScoring[0].Id);
		}
	}
}