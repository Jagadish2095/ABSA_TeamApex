/**
 * @description This is the Class for the NonScoredApprovedFacilities
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-27
 *
 * @UserStory W-007274
 **/
public class NonScoredApprovedFacilitiesCtrl {

	/**
	 * @description Non Scored Approved Facilities wrapper class
	 */
	public class NonScoredApprovedFacilities {
		/** @description property Id */
		@AuraEnabled public Id Id { get; set; }
		/** @description property ClientName */
		@AuraEnabled public String ClientName { get; set; }
		/** @description property ClientCode */
		@AuraEnabled public String ClientCode { get; set; }
		/** @description property ApprovedFacility */
		@AuraEnabled public String ApprovedFacility { get; set; }
		/** @description property ExposureNonScored */
		@AuraEnabled public Decimal ExposureNonScored { get; set; }
		/** @description property InstallmentsNonScored */
		@AuraEnabled public Decimal InstallmentsNonScored { get; set; }
		/** @description property IsFirstInPVis */
		@AuraEnabled public Boolean IsFirstInPVis { get; set; }
		/** @description property IsInput */
		@AuraEnabled public Boolean IsInput { get; set; }
		/** @description property IsOutput */
		@AuraEnabled public Boolean IsOutput { get; set; }
		/** @description property ExposureNonScoredTotal */
		@AuraEnabled public Decimal ExposureNonScoredTotal { get; set; }
		/** @description property InstallmentsNonScoredTotal */
		@AuraEnabled public Decimal InstallmentsNonScoredTotal { get; set; }
		/** @description property LastRefreshDate */
		@AuraEnabled public Datetime LastRefreshDate { get; set; }

		/**
		 * @description Non Scored Approved Facilities construtor
		 */
		public NonScoredApprovedFacilities() {
			Id = null;
			ClientName = null;
			ClientCode = null;
			ApprovedFacility = null;
			ExposureNonScored = null;
			InstallmentsNonScored = null;
			IsFirstInPVis = null;
			IsInput = null;
			IsOutput = null;
			ExposureNonScoredTotal = null;
			InstallmentsNonScoredTotal = null;
			LastRefreshDate = null;
		}
	}

	/**
	 * @description  test method to Get Non Scored Approved Facilities
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 * @param oppId
	 * @return String
	**/
	@AuraEnabled
	public static String getNonScoredApprovedFacilities(String oppId){
		Application__c appDet = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
		List<Application_Exposure_Facility__c> appExpFacList = new NonScoredApprovedFacilitiesSelector().selectByApplicationId(appDet.Id);
        List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().selectByApplicationId(appDet.Id);
		Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);
		List<Application_Exposure_Facility__c> appExpFacListSp = new List<Application_Exposure_Facility__c>();
		Application_Exposure_Facility__c appExpFac;
		List<String> appFac = approvedFacility();
		Boolean isExpFacListEmpty = false;
        //Adding a check to handle Main Applicant record with Spouse for defect #W-013807
		if (appExpFacList?.size() == 0 || (appExpFacList?.size() == 8 && appExpFacList[0].Client_Name__c != opp.Account.Name)){
            //Application_Exposure_Facility__c appExpFac;
			//List<String> appFac = approvedFacility();
			for (Integer i = 0; i < appFac.size(); i++){
				appExpFac = new Application_Exposure_Facility__c();
				appExpFac.Application__c = appDet.Id;
				appExpFac.Id = null;
				appExpFac.Client_Name__c = opp.Account.Name;//(i == 0 ? opp.Account.Name : '');
				appExpFac.Client_Code__c = opp.Account.CIF__c;
				appExpFac.Approved_Facility__c = appFac[i];
				appExpFac.Exposure_Non_Scored__c = 0.00;
				appExpFac.Installments_Non_Scored__c = 0.00;
				appExpFacList.add(appExpFac);
                system.debug('coming here'+appExpFacList);
			}

			//add spouse details if they exits and linked to account
			//TO DO:

			//add principal spouse details if they exits and linked to account as principal
			if (appPrinList != null){
				for (Application_Principal__c output : appPrinList){
					for (Integer i = 0; i < appFac.size(); i++){
						appExpFac = new Application_Exposure_Facility__c();
						appExpFac.Application__c = appDet.Id;
						appExpFac.Id = null;
						appExpFac.Client_Name__c = output.Principal_Shareholder_Name__c;//(i == 0 ? output.Principal_Shareholder_Name__c : '');
						appExpFac.Client_Code__c = output.CIF__c;
						appExpFac.Approved_Facility__c = appFac[i];
						appExpFac.Exposure_Non_Scored__c = 0.00;
						appExpFac.Installments_Non_Scored__c = 0.00;
						appExpFacList.add(appExpFac);
                      
					}
				}
			}
			isExpFacListEmpty = true;
		}
		else {
			//put this back up in the spouse when tabflow is fixed
			if (opp.AccountId != null && opp.Is_Spouse_Captured__c && opp.Spouse_Account_Id__c != null){
				Set<Id> idSet = new Set<Id>{opp.Spouse_Account_Id__c};
				Account accDet = new AccountsSelector().selectById(idSet, 1)[0];
				Boolean isSpouseFacCaptured = false;

				if (appExpFacList != null) {
					for(Application_Exposure_Facility__c appExpFacOut :appExpFacList) {
						if(appExpFacOut?.Client_Name__c == accDet?.Name) {
							isSpouseFacCaptured = true;
						}
					}
				}

				if(!isSpouseFacCaptured) {
					for (Integer i = 0; i < appFac.size(); i++) {
						appExpFac = new Application_Exposure_Facility__c();
						appExpFac.Application__c = appDet.Id;
						appExpFac.Id = null;
						appExpFac.Client_Name__c = accDet.Name;//(i == 0 ? accDet.Name : '');
						appExpFac.Client_Code__c = accDet.CIF__c;
						appExpFac.Approved_Facility__c = appFac[i];
						appExpFac.Exposure_Non_Scored__c = 0.00;
						appExpFac.Installments_Non_Scored__c = 0.00;
						appExpFacListSp.add(appExpFac);
                        
					}
				}
			}
		}

		try{
			if(appExpFacList?.size() > 0 && isExpFacListEmpty) {
				upsert appExpFacList; // testing smething
			}
			if (appExpFacListSp ?.size() > 0){
				insert appExpFacListSp;
			}
		} catch (Exception ex){
			throw new AuraHandledException('Error Inserting Non Scored Infomation: ' + ex.getMessage()+' ' + ex.getStackTraceString());
		}

		appExpFacList = new NonScoredApprovedFacilitiesSelector().selectByApplicationId(appDet.Id);
		return JSON.serialize(nonScrdFacList(appExpFacList));
	}

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 * @param oppId
	 * @param jsonObj
	 * @param isNonScored
	 * @return Map<String, String>
	 **/
	@AuraEnabled
	public static Map<String, String> saveNonScoredApprovedFacilities(String oppId, String jsonObj, Boolean isNonScored){
		Boolean recExists = false;
		Map<String, String> mapStatus = new Map<String, String>();
		Application__c appDet = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
		Account accDet = new AccountsSelector().selectByOpportunityId(appDet.Opportunity__c);
		List<Application_Exposure_Facility__c> appExpFacList = new List<Application_Exposure_Facility__c>();
		List<NonScoredApprovedFacilities> nonScrdAppFacList = (List<NonScoredApprovedFacilities>)JSON.deserialize(jsonObj, NonScoredApprovedFacilities[].class);

		ApplicationAIPSCTRL.getAipsData(appDet);

		if (nonScrdAppFacList ?.size() > 0){
			Application_Exposure_Facility__c appExpFac;
			for (NonScoredApprovedFacilities curOutput : nonScrdAppFacList){
				appExpFac = new Application_Exposure_Facility__c();
				appExpFac.Id = (curOutput.Id == null ? null : curOutput.Id);
				appExpFac.Client_Name__c = curOutput.ClientName;
				appExpFac.Client_Code__c = curOutput.ClientCode;
				appExpFac.Approved_Facility__c = curOutput.ApprovedFacility;
				appExpFac.Exposure_Non_Scored__c = (curOutput.ExposureNonScored == null ? curOutput.ExposureNonScoredTotal : curOutput.ExposureNonScored);
				appExpFac.Installments_Non_Scored__c = (curOutput.InstallmentsNonScored == null ? curOutput.InstallmentsNonScoredTotal : curOutput.InstallmentsNonScored);
				appExpFac.Application__c = appDet.Id;
				appExpFacList.add(appExpFac);
				recExists = (appExpFac.Id != null ? true : false);
			}
		}

		appDet.Is_Non_Scored_Approved_Facilities__c = isNonScored;

		try{
			if (isNonScored){
				upsert appExpFacList;
			} else{
				if (recExists){
					delete appExpFacList;
				}
			}
			update appDet;
			mapStatus.put('Status', 'Non Scored Approved Facilities Saved Successfully!');
		} catch (Exception ex){
			mapStatus.put('Status', 'Non Scored Approved Facilities Save Failed: ' + ex.getMessage());
		}

		Boolean isValid = (!mapStatus.isEmpty() ? mapStatus.get('Status').contains('Successfully') : false);

		if (isValid){
			PowerCurveController.setValidationFields(oppId, 'Non_Scored_Approved_Facilities', true);
			List<Application_Profile__c> appProfList = new ApplicationProfileSelector().getApplicationProfiles(appDet.Id);
			Set<Id> ApplicationProfileIds = new Set<Id>();
			for (Application_Profile__c aprofile : appProfList){
				if (aprofile.Client_CIF_Code__c != null){
					ApplicationProfileIds.add(aprofile.Id);
				}
			}
			updateInterestOffset(oppId);
			ApplicationProfileClientDetails ApplicationProfiles = new ApplicationProfileClientDetails(ApplicationProfileIds);
			Id JobId1 = System.enqueueJob(ApplicationProfiles);
		}
		return mapStatus;
	}

	/**
	 * @description
	 * @author Almas.Aleem@absa.africa | 2021-06-12
	 * @param oppID
	 **/
	@future(callout = true)
	public static void updateInterestOffset(Id oppID){
		//use selector layer
		List<Application_Product__c> ProductList = [SELECT id, Name, Application__r.Credit_Application_Accepted__c, Product_Name__c, Account_Number__c, Product_State__c, Product_Status__c
		                                            FROM Application_Product__c
		                                            WHERE Opportunity__c = :oppID AND Application_Product_Parent__c = null AND Product_State__c = 'Existing' AND Product_Name__c = 'Cheque'];
		if (ProductList != null){
			for (Application_Product__c appProd : ProductList){
				CQgetInterestRateDetailsV1_Resp_IB_v1 responseBean = CQgetInterestRateDetailsV1_IH_v1.getInterestRateDetails(String.valueOf(appProd.Account_Number__c));

				if (responseBean != null){
					if (responseBean.CQgetInterestRateDetailsV1Response.cqh451o.debitIntTiers != null){
						Decimal primeoffset = responseBean.CQgetInterestRateDetailsV1Response.cqh451o.debitIntTiers.debitOffset == null ? 0 : responseBean.CQgetInterestRateDetailsV1Response.cqh451o.debitIntTiers.debitOffset;
						appProd.Prime_Offset__c = primeoffset;
					}
				}
			}
		}

		try{
			update ProductList;
		} catch (Exception e){
			system.debug('Exception ----' + e.getStackTraceString());
		}
	}

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 * @return List<String>
	 **/
	private static List<String> approvedFacility(){
		return (new List<String>{'Settlement Limits Approved',
								 'Approved Facilities Ordinary Credit - Business Bank',
								 'Approved Facilities Ordinary Credit - Retail',
								 'Approved Facilities Asset Finance - Business Bank',
								 'Approved Facilities Asset Finance - Retail',
								 'Approved Mortgage Facilities - Business Bank',
								 'Approved Mortgage Facilities - Retail',
								 'Approved Facilities Total'});
	}

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 * @param appId
	 * @param opp
	 **/
	public static void addSpouseFacilities(Id appId, Opportunity opp){
		List<Application_Exposure_Facility__c> appExpFacList = new List<Application_Exposure_Facility__c>();
		List<Application_Exposure_Facility__c> existingAppFacs = new NonScoredApprovedFacilitiesSelector().selectByApplicationId(appId);
		List<String> appFacs = approvedFacility();
		Application_Exposure_Facility__c appExpFac;

		if (opp != null){
			Boolean isExistSpouseAppFacs = false;
			Account account = new AccountsSelector().selectAllById(opp.Spouse_Account_Id__c);

			if (existingAppFacs != null) {
				for (Application_Exposure_Facility__c existingAppFac : existingAppFacs){
					String clientName = existingAppFac?.Client_Name__c,
					accClientName = account?.FirstName + ' ' + account?.LastName;
					if (clientName != null && String.valueOf(clientName).equalsIgnoreCase(accClientName)){
						isExistSpouseAppFacs = true;
						break;
					}
				}
			}

			if (!isExistSpouseAppFacs){
				for (String appFac : appFacs){
					appExpFac = new Application_Exposure_Facility__c();
					appExpFac.Application__c = appId;
					appExpFac.Id = null;
					appExpFac.Client_Name__c = account.FirstName + ' ' + account.LastName;
					appExpFac.Client_Code__c = account.CIF__c;
					appExpFac.Approved_Facility__c = appFac;
					appExpFac.Exposure_Non_Scored__c = 0.00;
					appExpFac.Installments_Non_Scored__c = 0.00;
					appExpFacList.add(appExpFac);
				}

				try{
					if (appExpFacList != null && appExpFacList.size() > 0){
						insert appExpFacList;
					}
				} catch (Exception exc){
					throw new AuraHandledException(String.valueOf(exc));
				}
			}
		}
	}

	/**
	 * @description
	 * @author englarmerdge.mongwe@absa.africa | 2021-06-12
	 * @param appExpFacList
	 * @return List<NonScoredApprovedFacilities>
	 **/
	private static List<NonScoredApprovedFacilities> nonScrdFacList(List<Application_Exposure_Facility__c> appExpFacList){
		List<NonScoredApprovedFacilities> nonScrdFacList = new List<NonScoredApprovedFacilities>();
		NonScoredApprovedFacilities nonSrdFac;
		for (Application_Exposure_Facility__c output : appExpFacList) {
            Boolean isInput = (output.Approved_Facility__c == 'Approved Facilities Total' ? false : true),
					isOutput = (output.Approved_Facility__c == 'Approved Facilities Total' ? true : false),
					isFirstInPVisible = (output.Approved_Facility__c == 'Settlement Limits Approved' ? false : true);
			nonSrdFac = new NonScoredApprovedFacilities();
			nonSrdFac.Id = output.Id;
			nonSrdFac.ClientName = output.Client_Name__c;
			nonSrdFac.ClientCode = output.Client_Code__c;
			nonSrdFac.ApprovedFacility = output.Approved_Facility__c;
			if (isInput){
				nonSrdFac.ExposureNonScored = output.Exposure_Non_Scored__c;
				nonSrdFac.InstallmentsNonScored = output.Installments_Non_Scored__c;
			}
			nonSrdFac.IsFirstInPVis = isFirstInPVisible;
			nonSrdFac.IsInput = isInput;
			nonSrdFac.IsOutput = isOutput;
			if (isOutput){
				nonSrdFac.ExposureNonScoredTotal = (output.Exposure_Non_Scored__c == null ? 0.00 : output.Exposure_Non_Scored__c);
				nonSrdFac.InstallmentsNonScoredTotal = (output.Installments_Non_Scored__c == null ? 0.00 : output.Installments_Non_Scored__c);
			}
			nonSrdFac.LastRefreshDate = output.LastModifiedDate;
			nonScrdFacList.add(nonSrdFac);
		}
		return nonScrdFacList;
	}
}