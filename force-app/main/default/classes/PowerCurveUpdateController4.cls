/**
 * @description PCO Stage 4 request Mapping
 * @author  Himani Joshi: Absa
 * @version v1.0
 * @since   2020-09-15
 *
 */
public class PowerCurveUpdateController4 {
	/**
	 * @description method to map stage 4 fields of PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-15
	 * @param requestBean
	 * @param opp
	 * @return PowerCurveUpdateApplication_Req_IB_v1
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1 mapStage4Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Opportunity opp) {
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(opp.Id);
		List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().selectByApplicationId(app.Id);
        List<Application_Profile__c> appProfiles = new ApplicationProfileSelector().getApplicationProfilesbyAppIdSet(new Set<String>{app.Id});

		Set<Id> accIds = new Set<Id>();

        for(Application_Profile__c appProfile : appProfiles){
            accIds.add(appProfile.Account__c);
        }

		List<Financial_Information__c> finInfoList = new FinancialInformationSelector().selectByAccountIds(accIds);
		Map<Id, List<Application_Assets_and_Liabilities__c>> appProfAssetsAndLiabs = getAppProfAssetsAndLiabilities(accIds, app.Id);
        Map<Id, Financial_Information__c> finInfoByAccId = getFinInfoMap(finInfoList);
		String entity3RegOrId = requestBean?.Request?.ApplicationDV?.Entity03?.APPENTBUR?.CONSINPNATID != null ? requestBean?.Request?.ApplicationDV?.Entity03?.APPENTBUR?.CONSINPNATID : requestBean?.Request?.ApplicationDV?.Entity03?.INTENTBUR.COMMINPREGNUMBER;
        String entity4RegOrId = requestBean?.Request?.ApplicationDV?.Entity04?.APPENTBUR?.CONSINPNATID != null ? requestBean?.Request?.ApplicationDV?.Entity04?.APPENTBUR?.CONSINPNATID : requestBean?.Request?.ApplicationDV?.Entity04?.INTENTBUR.COMMINPREGNUMBER;
        String entity5RegOrId = requestBean?.Request?.ApplicationDV?.Entity05?.APPENTBUR?.CONSINPNATID != null ? requestBean?.Request?.ApplicationDV?.Entity05?.APPENTBUR?.CONSINPNATID : requestBean?.Request?.ApplicationDV?.Entity05?.INTENTBUR.COMMINPREGNUMBER;
        String entity6RegOrId = requestBean?.Request?.ApplicationDV?.Entity06?.APPENTBUR?.CONSINPNATID != null ? requestBean?.Request?.ApplicationDV?.Entity06?.APPENTBUR?.CONSINPNATID : requestBean?.Request?.ApplicationDV?.Entity06?.INTENTBUR.COMMINPREGNUMBER;

        for(Application_Profile__c appProfile : appProfiles){
            if(entity3RegOrId != Null && (entity3RegOrId.equalsIgnoreCase(appProfile?.Account__r?.ID_Number__pc) || entity3RegOrId.equalsIgnoreCase(appProfile?.Account__r?.Registration_Number__c))){
                requestBean.Request.ApplicationDV.Entity03 = mapEntityData(requestBean.Request.ApplicationDV.Entity03, finInfoByAccId.get(appProfile.Account__c), appProfAssetsAndLiabs.get(appProfile.Account__c));

            } else if(entity4RegOrId != Null && (entity4RegOrId.equalsIgnoreCase(appProfile?.Account__r.ID_Number__pc) || entity4RegOrId.equalsIgnoreCase(appProfile?.Account__r.Registration_Number__c))){
                requestBean.Request.ApplicationDV.Entity04 = mapEntityData(requestBean.Request.ApplicationDV.Entity04, finInfoByAccId.get(appProfile.Account__c), appProfAssetsAndLiabs.get(appProfile.Account__c));

            } else if(entity5RegOrId != Null && (entity5RegOrId.equalsIgnoreCase(appProfile?.Account__r.ID_Number__pc) || entity5RegOrId.equalsIgnoreCase(appProfile?.Account__r.Registration_Number__c))){
                requestBean.Request.ApplicationDV.Entity05 = mapEntityData(requestBean.Request.ApplicationDV.Entity05, finInfoByAccId.get(appProfile.Account__c), appProfAssetsAndLiabs.get(appProfile.Account__c));

            } else if(entity6RegOrId != Null && (entity6RegOrId.equalsIgnoreCase(appProfile?.Account__r.ID_Number__pc) || entity6RegOrId.equalsIgnoreCase(appProfile?.Account__r.Registration_Number__c))){
                requestBean.Request.ApplicationDV.Entity06 = mapEntityData(requestBean.Request.ApplicationDV.Entity06, finInfoByAccId.get(appProfile.Account__c), appProfAssetsAndLiabs.get(appProfile.Account__c));
            }
        }

		return requestBean;
	}

	/**
	 * @description method to get asset and liabilities for stage 4 of PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-15
	 * @param accIds
	 * @param appId
	 * @return Map<Id, List<Application_Assets_and_Liabilities__c>>
	**/
	public static Map<Id, List<Application_Assets_and_Liabilities__c>> getAppProfAssetsAndLiabilities(Set<Id> accIds, Id appId) {
		Map<Id, List<Application_Assets_and_Liabilities__c>> appProfAssetsAndLiabs = new Map<Id, List<Application_Assets_and_Liabilities__c>>();
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = new ApplicationAssetsAndLiabilitiesSelector().selectByAccountIdApplicationId(accIds, new Set<Id>{appId});

		for (Application_Assets_and_Liabilities__c appAssetLiability : appAssetLiabilities) {
			List<Application_Assets_and_Liabilities__c> accAppAssetLiabilities = appProfAssetsAndLiabs.get(appAssetLiability.Primary_Owner__c);
			if (accAppAssetLiabilities == null || accAppAssetLiabilities.size() == 0) {
				appProfAssetsAndLiabs.put(appAssetLiability.Primary_Owner__c, new List<Application_Assets_and_Liabilities__c>{appAssetLiability});
			}
			else {
				accAppAssetLiabilities.add(appAssetLiability);
				appProfAssetsAndLiabs.put(appAssetLiability.Primary_Owner__c, accAppAssetLiabilities);
			}
		}
		return appProfAssetsAndLiabs;
	}

	/**
	 * @description method to get financial info
	 * @author Himani.Joshi@absa.africa | 2020-09-15
	 * @param finInfoList
	 * @return Map<Id, Financial_Information__c>
	**/
	public static Map<Id, Financial_Information__c> getFinInfoMap(List<Financial_Information__c> finInfoList) {
		Map<Id, Financial_Information__c> finInfoById = new Map<Id, Financial_Information__c>();
		for (Financial_Information__c finInfo : finInfoList) {
			finInfoById.put(finInfo.Account__c, finInfo);
		}
		return finInfoById;
	}

	/**
	 * @description method to map entity data for stage 4 of PCO
	 * @author Himani.Joshi@absa.africa | 2020-09-15
	 * @param entity
	 * @param finInfo
	 * @param assetsAndLiabs
	 * @return PowerCurveUpdateApplication_Req_IB_v1.Entity01
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 mapEntityData(PowerCurveUpdateApplication_Req_IB_v1.Entity01 entity, Financial_Information__c finInfo, List<Application_Assets_and_Liabilities__c> assetsAndLiabs) {
		if (entity.INTENTSECE == null) {
			entity.INTENTSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTENTSECE();
		}
		if (entity.APPENTFNST == null) {
			entity.APPENTFNST = new PowerCurveUpdateApplication_Req_IB_v1.APPENTFNST();
		}
		if (entity.APPENTASLB == null) {
			entity.APPENTASLB = new PowerCurveUpdateApplication_Req_IB_v1.APPENTASLB();
		}
		if (entity.APPENTBUR == null) {
			entity.APPENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.APPENTBUR();
		}
		if (entity.INTENTBUR == null) {
			entity.INTENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.INTENTBUR();
        }

		Map<String, String> assetLiabAmounts = new Map<String, String>();
		List<String> validAssetsLiabilities = new List<String>{'Net Worth Manager\'s Estimate', 'Total Properties', 'Deeds Office Search Available', 'Notarial Bond Amount', 'Net Worth Owner\'s Estimate'};
		String assAndLiabAvailable = 'N';
		Date audCertificateDate;
        Date statementDateYearEnd;

		if (assetsAndLiabs != null && assetsAndLiabs.size() > 0) {
			assAndLiabAvailable = 'Y';
			for (Application_Assets_and_Liabilities__c assetAndLiab : assetsAndLiabs) {
				if (validAssetsLiabilities.contains(assetAndLiab.Type__c)) {
					assetLiabAmounts.put(assetAndLiab.Type__c, String.valueOf(assetAndLiab.Amount__c));

                    if(assetLiabAmounts.get('Deeds Office Search Available') == null){
                        if(assetAndLiab.Primary_Owner__r.Deeds_office_search_available_Y_N__c != null){
                            assetLiabAmounts.put('Deeds Office Search Available', String.valueOf(assetAndLiab.Primary_Owner__r.Deeds_office_search_available_Y_N__c) == 'Yes' ? 'Y' : 'N');
                        } else {
                            assetLiabAmounts.put('Deeds Office Search Available', '');
                        }
                    }
				}
			}
        }

		if (finInfo?.Auditor_s_Certificate_Date__c != null) {
			audCertificateDate = finInfo?.Auditor_s_Certificate_Date__c;
		}
		if (finInfo?.Statement_Date_Year_end__c != null) {
			statementDateYearEnd = finInfo?.Statement_Date_Year_end__c;
        }

		Date dateToday = System.today();
		Integer mnthsSnceAudCert = audCertificateDate?.monthsBetween(dateToday);
        Integer mnthsSnceStateDate = statementDateYearEnd?.monthsBetween(dateToday);

		if (dateToday.day() > audCertificateDate?.day()) {
			mnthsSnceAudCert++;
		}
		if (dateToday.day() > statementDateYearEnd?.day()) {
			mnthsSnceStateDate++;
        }

        Map<String,String> mapFinStaTypes = new Map<String,String>{null => '0','Audited - Qualified' => 'A','Audited - Unqualified' => 'A', 'Unaudited' => 'U', 'Draft' => 'D','Interim' => 'I','Management Accounts' => 'M'};
        Map<String,String> mapFinStaQua = new Map<String,String>{null => '0','YES' => 'Y','NO' => 'N'};

		entity.INTENTSECE.SURETYSHIPIFOAPPLICANT = '0';
		entity.APPENTFNST.AVAILABLE = (finInfo != null ? 'Y' : 'N');// if finacial statements available
        entity.APPENTFNST.SOLEFULLAVAILABLE = (finInfo != null && !assetLiabAmounts.IsEmpty() ? 'Y' : 'N'); //if " and Assest and Liabilitties
        entity.APPENTFNST.TYPE_Z = (mapFinStaTypes?.get(finInfo?.Financial_Statement_Type__c) != null ? mapFinStaTypes?.get(finInfo?.Financial_Statement_Type__c) : '0');
		entity.APPENTFNST.PERIODOFINCSTAT = (finInfo?.No_of_Days__c != null ? String.valueOf(finInfo?.No_of_Days__c) : '0');
		entity.APPENTFNST.TMSNCE = String.valueof(statementDateYearEnd);
        entity.APPENTFNST.TMSNCECERTDATE = String.valueof(audCertificateDate);
        entity.APPENTFNST.QUALIFIED = (mapFinStaQua?.get(finInfo?.Financial_Statement_Qualified_Issue__c) != null ? mapFinStaQua?.get(finInfo?.Financial_Statement_Qualified_Issue__c) : '0');
		entity.APPENTFNST.TURNOVER = (finInfo?.Net_Sales__c != null ? String.valueOf(finInfo?.Net_Sales__c).substringBefore('.') : '0');
		entity.APPENTFNST.PROJTURNOVER = (finInfo?.Net_Sales__c != null ? String.valueOf(finInfo?.Net_Sales__c).substringBefore('.') : '0');
		entity.APPENTFNST.NETWORTH = (finInfo?.Net_Worth_or_Equity__c != null ? String.valueOf(finInfo?.Net_Worth_or_Equity__c).substringBefore('.') : '0');
		entity.APPENTFNST.TOTALASSETS = (finInfo?.Total_Asset_Turnover__c != null ? String.valueOf(finInfo?.Total_Asset_Turnover__c).substringBefore('.') : '0');
		entity.APPENTFNST.SALESGROWTHPERC = (finInfo?.Sales_Growth__c != null ? String.valueOf(finInfo?.Sales_Growth__c) : '0');
		entity.APPENTFNST.NETPROFITPERC = (finInfo?.Net_Profit_Profit_before_Tax_Net_Sale__c != null ? String.valueOf(finInfo?.Net_Profit_Profit_before_Tax_Net_Sale__c) + '.00' : '0.00');
		entity.APPENTFNST.LIABSHAREHFUNDS = (finInfo?.Shareholders_Funds_Capital_Account__c != null ? String.valueOf(finInfo?.Shareholders_Funds_Capital_Account__c).substringBefore('.') : '0');
		entity.APPENTFNST.ASSINTANGIBLES = (finInfo?.Intangible_Assets__c != null ? String.valueOf(finInfo?.Intangible_Assets__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABLOANSFROMPRCEDED = (finInfo?.Loans_from_Principals_Ceded__c != null ? String.valueOf(finInfo?.Loans_from_Principals_Ceded__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABLOANSTOPR = (finInfo?.Loans_to_Principals_Associates__c != null ? String.valueOf(finInfo?.Loans_to_Principals_Associates__c).substringBefore('.') : '0');
		entity.APPENTFNST.GROSSPROFIT = (finInfo?.Gross_Profit__c != null ? String.valueOf(finInfo?.Gross_Profit__c).substringBefore('.') : '0');
		entity.APPENTFNST.PROFITNET = (finInfo?.Net_Profit__c != null ? String.valueOf(finInfo?.Net_Profit__c).substringBefore('.') : '0');
        entity.APPENTFNST.RETAINEDEARNINGS = (finInfo?.Retained_Earnings_Deficit__c != null ? String.valueOf(finInfo?.Retained_Earnings_Deficit__c).substringBefore('.') : '0');

		//Asset And Liabilities -- if non -individual, full financials and if not the  just income sstement if there.
		entity.APPENTASLB.NETWORTHCREDIT = (assetLiabAmounts.get('Net Worth Manager\'s Estimate') != null ? String.valueOf(assetLiabAmounts.get('Net Worth Manager\'s Estimate')).substringBefore('.') : '0');
		entity.APPENTASLB.NETWORTHME = (assetLiabAmounts.get('Net Worth Manager\'s Estimate') != null ? String.valueOf(assetLiabAmounts.get('Net Worth Manager\'s Estimate')).substringBefore('.') : '0');
		entity.APPENTASLB.TOTALPROPERTIES = (assetLiabAmounts.get('Total Properties') != null ? String.valueOf(assetLiabAmounts.get('Total Properties')).substringBefore('.') : '0');
		entity.APPENTASLB.DEEDSSEARCHAVAILABLE = (assetLiabAmounts.get('Deeds Office Search Available') != null ? String.valueOf(assetLiabAmounts.get('Deeds Office Search Available')) : '');
		entity.APPENTASLB.NOTARIALBOND = (assetLiabAmounts.get('Notarial Bond Amount') != null ? String.valueOf(assetLiabAmounts.get('Notarial Bond Amount')).substringBefore('.') : '0');
		entity.APPENTASLB.AVAILABLE = assAndLiabAvailable;
        entity.APPENTASLB.NETWORTH = (assetLiabAmounts.get('Net Worth Owner\'s Estimate' ) != null ? String.valueOf(assetLiabAmounts.get('Net Worth Owner\'s Estimate')).substringBefore('.') : '0');

		//Income Statement
		entity.APPENTFNST.PROFITBEFORETAX = (finInfo?.Profit_Before_Interest_And_Tax_EBIT__c != null ? String.valueOf(finInfo?.Profit_Before_Interest_And_Tax_EBIT__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABLOANTOINSIDEPARTIES = (finInfo?.Loans_to_Principals_Associates__c != null ? String.valueOf(finInfo?.Loans_to_Principals_Associates__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABLOANFROMOTHINSTITUTIONS = (finInfo?.Loans_from_Associates__c != null ? String.valueOf(finInfo?.Loans_from_Associates__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABTOTCURRLIAB = (finInfo?.Total_Current_Liabilities__c != null ? String.valueOf(finInfo?.Total_Current_Liabilities__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABTOTSTOCK = (finInfo?.Total_Liabilities__c != null ? String.valueOf(finInfo?.Total_Liabilities__c).substringBefore('.') : '0');
		entity.APPENTFNST.LIABTOTLONGTERMDEBT = (finInfo?.Long_Term_Debt__c != null ? String.valueOf(finInfo?.Long_Term_Debt__c).substringBefore('.') : '0');
		entity.APPENTFNST.CURRENTRATIO = (finInfo?.Current_Ratio__c != null ? String.valueOf(finInfo?.Current_Ratio__c) + '.00' : '0.00');
		entity.APPENTFNST.GROSSPROFITPERC = (finInfo?.Gross_Profit_Ratio__c != null ? String.valueOf(finInfo?.Gross_Profit_Ratio__c) + '.00' : '0.00');
		entity.APPENTFNST.ACIDTEST = (finInfo?.Acid_Test_Excl_Stock__c != null ? String.valueOf(finInfo?.Acid_Test_Excl_Stock__c) + '.00' : '0.00');
		entity.APPENTFNST.IBDTOEQUITY = (finInfo?.Interest_Bearing_Debt_Equity__c != null ? String.valueOf(finInfo?.Interest_Bearing_Debt_Equity__c) + '.00' : '0.00');
		entity.APPENTFNST.IBDTOEBITDA = (finInfo?.IBD_EBITDA__c != null ? String.valueOf(finInfo?.IBD_EBITDA__c) + '.00' : '0.00');
		entity.APPENTFNST.LONGTERMDEBTTOEBITDA = (finInfo?.Long_Term_Debt_EBITDA__c != null ? String.valueOf(finInfo?.Long_Term_Debt_EBITDA__c) : '0');
		entity.APPENTFNST.ICR = (finInfo?.Interest_Cover_Ratio__c != null ? String.valueOf(finInfo?.Interest_Cover_Ratio__c) + '.00' : '0.00');
		entity.APPENTFNST.TOTALASSETTURNOVER = (finInfo?.Total_Asset_Turnover__c != null ? String.valueOf(finInfo?.Total_Asset_Turnover__c) : '0');
		entity.APPENTFNST.OPERATINGPROFITMARGIN = (finInfo?.Operating_Profit_Margin__c != null ? String.valueOf(finInfo?.Operating_Profit_Margin__c) : '0');
		entity.APPENTFNST.EBITDA = (finInfo?.IBD_EBITDA__c != null ? String.valueOf(finInfo?.IBD_EBITDA__c) : '0');
		return entity;
	}
}