/**
 * @description       : This is the Controller Class for the Power Curve Update Calls 3 and 5
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-12-07
 * @last modified by  : Himani Joshi
**/

public class PowerCurveUpdateController3And5 {
	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param requestBean 
	* @param opp 
	* @param app 
	* @param stage 
	* @return PowerCurveUpdateApplication_Req_IB_v1 
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1 mapPowerCureveUpdateRequest(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Opportunity opp, Application__c app, Integer stage) {
		List<Application_Principal__c> appPrinList = new ApplicationPrincipalsSelector().selectByApplicationId(app.Id);

		requestBean.Request.ApplicationDV.Entity01.INTENTSECE = new PowerCurveUpdateApplication_Req_IB_v1.INTENTSECE();
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST = new PowerCurveUpdateApplication_Req_IB_v1.APPENTFNST();
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB = new PowerCurveUpdateApplication_Req_IB_v1.APPENTASLB();
		requestBean.Request.ApplicationDV.Entity01.APPENTTIME = new PowerCurveUpdateApplication_Req_IB_v1.APPENTTIME();

		if (requestBean.Request.ApplicationDV.Entity02 == null) {
			requestBean.Request.ApplicationDV.Entity02 = new PowerCurveUpdateApplication_Req_IB_v1.Entity01();
			requestBean.Request.ApplicationDV.Entity02.APPENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.APPENTBUR();
			requestBean.Request.ApplicationDV.Entity02.INTENTBUR = new PowerCurveUpdateApplication_Req_IB_v1.INTENTBUR();
		}

		if (stage >= 3) {
			requestBean = mapStage3Fields(requestBean, opp, app, appPrinList);
		}

		if (stage >= 5) {
			requestBean = mapStage5Fields(requestBean, opp, app, appPrinList);
		}

		return requestBean;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param requestBean 
	* @param opp 
	* @param app 
	* @param appPrinList 
	* @return PowerCurveUpdateApplication_Req_IB_v1 
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1 mapStage3Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Opportunity opp, Application__c app, List<Application_Principal__c> appPrinList) {
        List<Application_Security__c> appSecList = new ApplicationSecuritySelector().selectByApplicationIdAndSecType(app.Id,'Suretyship');

        List<Application_Assets_and_Liabilities__c> assAndLiabList = new ApplicationAssetsAndLiabilitiesSelector().selectByAccountIdApplicationId(new Set<Id>{opp.AccountId}, new Set<Id>{app.Id});
		Financial_Information__c finInfo = getFinacials(app.Id);

        String suretyshipForApplicant = 'N', assAndLiabAvailable = 'N';

		if (appSecList?.size() > 0) {
			for (Application_Security__c appSec : appSecList) {
				for (Application_Principal__c appPrin : appPrinList) {
					if (appSec.Client_Code__c == appPrin.CIF__c) {
						suretyshipForApplicant = 'Y';
						break;
					}
				}
			}
		}

		List<String> assLiaNames = new List<String>{'Net Worth Owner\'s Estimate', 'Net Worth Manager\'s Estimate', 'Total Properties', 'Deeds Office Search Available', 'Notarial Bond Amount', 'Net Worth Owner\'s Estimate'};
		Map<String, Object> mapAssAndLiab = new Map<String, Object>();

		if (assAndLiabList?.size() > 0) {
			assAndLiabAvailable = 'Y';
			for (Application_Assets_and_Liabilities__c assAndLiab : assAndLiabList) {
				if (assLiaNames?.contains(assAndLiab.Type__c)) {
					mapAssAndLiab.put(assAndLiab.Type__c, assAndLiab.Amount__c);
				}
                if(mapAssAndLiab.get('Deeds Office Search Available') == null){
                    if(assAndLiab.Primary_Owner__r.Deeds_office_search_available_Y_N__c != null){
                        mapAssAndLiab.put('Deeds Office Search Available', String.valueOf(assAndLiab.Primary_Owner__r.Deeds_office_search_available_Y_N__c) == 'Yes' ? 'Y' : 'N');
                    } else {
                        mapAssAndLiab.put('Deeds Office Search Available', '');
                    }
                }
			}
		}

		Map<String, String> mapFinStaTypes = new Map<String, String>{null => '0', 'Audited - Qualified' => 'A', 'Audited - Unqualified' => 'A', 'Unaudited' => 'U', 'Draft' => 'D', 'Interim' => 'I', 'Management Accounts' => 'M'};
		Map<String, String> mapFinStaQua = new Map<String, String>{null => '0', 'YES' => 'Y', 'NO' => 'N'};

		//Income Statement
		requestBean.Request.ApplicationDV.Entity01.INTENTSECE.SURETYSHIPIFOAPPLICANT = suretyshipForApplicant;
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.AVAILABLE = (finInfo?.Financial_Statement_Type__c != null ? 'Y' : 'N');// if finacial statements available
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.SOLEFULLAVAILABLE = (finInfo != null && !mapAssAndLiab.IsEmpty() ? 'Y' : 'N'); //if " and Assest and Liabilitties
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TYPE_Z = mapFinStaTypes?.get(finInfo?.Financial_Statement_Type__c); //(finInfo?.Financial_Type__c != null ? finInfo?.Financial_Type__c : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PERIODOFINCSTAT = (finInfo?.No_of_Days__c != null ? String.valueOf(finInfo?.No_of_Days__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TMSNCE = (finInfo?.Statement_Date_Year_end__c != null ? String.valueOf(monthsBwDays(finInfo?.Statement_Date_Year_end__c, System.today())) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TMSNCECERTDATE = (finInfo?.Auditor_s_Certificate_Date__c != null ? String.valueOf(monthsBwDays(finInfo?.Auditor_s_Certificate_Date__c, System.today())) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.QUALIFIED = mapFinStaQua?.get(finInfo?.Financial_Statement_Qualified_Issue__c);//(finInfo?.Financial_Statement_Qualified_Issue__c != null ? String.valueOf(finInfo?.Financial_Statement_Qualified_Issue__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TURNOVER = (finInfo?.Net_Sales__c != null ? String.valueOf(finInfo?.Net_Sales__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROJTURNOVER = (finInfo?.Net_Sales__c != null ? String.valueOf(finInfo?.Net_Sales__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.NETWORTH = (finInfo?.Net_Worth_or_Equity__c != null ? String.valueOf(finInfo?.Net_Worth_or_Equity__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TOTALASSETS = (finInfo?.Total_Asset_Turnover__c != null ? String.valueOf(finInfo?.Total_Asset_Turnover__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.SALESGROWTHPERC = (finInfo?.Sales_Growth__c != null ? String.valueOf(finInfo?.Sales_Growth__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.NETPROFITPERC = (finInfo?.Net_Profit_Profit_before_Tax_Net_Sale__c != null ? String.valueOf(finInfo?.Net_Profit_Profit_before_Tax_Net_Sale__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABSHAREHFUNDS = (finInfo?.Shareholders_Funds_Capital_Account__c != null ? String.valueOf(finInfo?.Shareholders_Funds_Capital_Account__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ASSINTANGIBLES = (finInfo?.Intangible_Assets__c != null ? String.valueOf(finInfo?.Intangible_Assets__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANSFROMPRCEDED = (finInfo?.Loans_from_Principals_Ceded__c != null ? String.valueOf(finInfo?.Loans_from_Principals_Ceded__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANSTOPR = (finInfo?.Loans_to_Principals_Associates__c != null ? String.valueOf(finInfo?.Loans_to_Principals_Associates__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.GROSSPROFIT = (finInfo?.Gross_Profit__c != null ? String.valueOf(finInfo?.Gross_Profit__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROFITNET = (finInfo?.Net_Profit__c != null ? String.valueOf(finInfo?.Net_Profit__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.RETAINEDEARNINGS = (finInfo?.Retained_Earnings_Deficit__c != null ? String.valueOf(finInfo?.Retained_Earnings_Deficit__c).substringBefore('.') : '0');

		//Asset And Liabilities -- if non -individual, full financials and if not the  just income sstement if there.
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTHCREDIT = (mapAssAndLiab.get('Net Worth Manager\'s Estimate') != null ? String.valueOf(mapAssAndLiab.get('Net Worth Manager\'s Estimate')).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTHME = (mapAssAndLiab.get('Net Worth Manager\'s Estimate') != null ? String.valueOf(mapAssAndLiab.get('Net Worth Manager\'s Estimate')).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.TOTALPROPERTIES = (mapAssAndLiab.get('Total Properties') != null ? String.valueOf(mapAssAndLiab.get('Total Properties')).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.DEEDSSEARCHAVAILABLE = (mapAssAndLiab.get('Deeds Office Search Available') != null ? String.valueOf(mapAssAndLiab.get('Deeds Office Search Available')) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NOTARIALBOND = (mapAssAndLiab.get('Notarial Bond Amount') != null ? String.valueOf(mapAssAndLiab.get('Notarial Bond Amount')).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.AVAILABLE = assAndLiabAvailable;
		requestBean.Request.ApplicationDV.Entity01.APPENTASLB.NETWORTH = (mapAssAndLiab.get('Net Worth Owner\'s Estimate') != null ? String.valueOf(mapAssAndLiab.get('Net Worth Owner\'s Estimate')).substringBefore('.') : '0');

		//Income Statement
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.PROFITBEFORETAX = (finInfo?.Profit_Before_Interest_And_Tax_EBIT__c != null ? String.valueOf(finInfo?.Profit_Before_Interest_And_Tax_EBIT__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANTOINSIDEPARTIES = (finInfo?.Loans_to_Principals_Associates__c != null ? String.valueOf(finInfo?.Loans_to_Principals_Associates__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABLOANFROMOTHINSTITUTIONS = (finInfo?.Loans_from_Associates__c != null ? String.valueOf(finInfo?.Loans_from_Associates__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTCURRLIAB = (finInfo?.Total_Current_Liabilities__c != null ? String.valueOf(finInfo?.Total_Current_Liabilities__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTSTOCK = (finInfo?.Total_Liabilities__c != null ? String.valueOf(finInfo?.Total_Liabilities__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LIABTOTLONGTERMDEBT = (finInfo?.Long_Term_Debt__c != null ? String.valueOf(finInfo?.Long_Term_Debt__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.CURRENTRATIO = (finInfo?.Current_Ratio__c != null ? String.valueOf(finInfo?.Current_Ratio__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.GROSSPROFITPERC = (finInfo?.Gross_Profit_Ratio__c != null ? String.valueOf(finInfo?.Gross_Profit_Ratio__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ACIDTEST = (finInfo?.Acid_Test_Excl_Stock__c != null ? String.valueOf(finInfo?.Acid_Test_Excl_Stock__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.IBDTOEQUITY = (finInfo?.Interest_Bearing_Debt_Equity__c != null ? String.valueOf(finInfo?.Interest_Bearing_Debt_Equity__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.IBDTOEBITDA = (finInfo?.IBD_EBITDA__c != null ? String.valueOf(finInfo?.IBD_EBITDA__c).substringBefore('.') : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.LONGTERMDEBTTOEBITDA = (finInfo?.Long_Term_Debt_EBITDA__c != null ? String.valueOf(finInfo?.Long_Term_Debt_EBITDA__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.ICR = (finInfo?.Interest_Cover_Ratio__c != null ? String.valueOf(finInfo?.Interest_Cover_Ratio__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.TOTALASSETTURNOVER = (finInfo?.Total_Asset_Turnover__c != null ? String.valueOf(finInfo?.Total_Asset_Turnover__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.OPERATINGPROFITMARGIN = (finInfo?.Operating_Profit_Margin__c != null ? String.valueOf(finInfo?.Operating_Profit_Margin__c) : '0');
		requestBean.Request.ApplicationDV.Entity01.APPENTFNST.EBITDA = (finInfo?.IBD_EBITDA__c != null ? String.valueOf(finInfo?.IBD_EBITDA__c).substringBefore('.') : '0');

		requestBean.Request.ApplicationDV.Entity01 = mapFinancialConduct(requestBean.Request.ApplicationDV.Entity01, app.Id);

		return requestBean;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param requestBean 
	* @param opp 
	* @param app 
	* @param appPrinList 
	* @return PowerCurveUpdateApplication_Req_IB_v1 
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1 mapStage5Fields(PowerCurveUpdateApplication_Req_IB_v1 requestBean, Opportunity opp, Application__c app, List<Application_Principal__c> appPrinList) {
		List<Application_Profile__c> appProfList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
		Account spouseAcc = (opp.Spouse_Account_Id__c != null ? new AccountsSelector().selectById(new Set<Id>{opp.Spouse_Account_Id__c})[0] : (new Account()));

		Map<String, Map<String, String>> mapKIMNumber = new Map<String, Map<String, String>>();
		List<Application_Profile__c> appProfPrinNewList = new List<Application_Profile__c>();
        Set<String> accIds = new Set<String>{opp.Account.Id};
            if(spouseAcc.Id!=null){
               accIds.add(spouseAcc.Id);
            }
		//Set<String> accIds = new Set<String>{opp.Account.Id, spouseAcc.Id};

		for (Application_Profile__c appProf : appProfList) {
			String KIMNumberNoPossibleMatch = '';

			if (appProf.Applicant_Type__c == 'Main Applicant' && appProf.KIMNumber__c != null) {
				KIMNumberNoPossibleMatch = (appProf.KIM_Number_No_Possible_Match__c == false ? '' : String.valueOf(appProf.KIM_Number_No_Possible_Match__c));
				mapKIMNumber.put(appProf.Client_CIF_Code__c, new Map<String, String>{'KIMNumber' => String.valueOf(appProf.KIMNumber__c), 'NoPossibleMatch' => KIMNumberNoPossibleMatch});
			}

			if (appProf.Applicant_Type__c == 'Principal') {
				if (appProf.KIMNumber__c != null) {
					KIMNumberNoPossibleMatch = (appProf.KIM_Number_No_Possible_Match__c == false ? '' : String.valueOf(appProf.KIM_Number_No_Possible_Match__c));
					mapKIMNumber.put(appProf.Client_CIF_Code__c, new Map<String, String>{'KIMNumber' => String.valueOf(appProf.KIMNumber__c), 'NoPossibleMatch' => KIMNumberNoPossibleMatch});
				}
			}
		}

		for (Application_Principal__c appPrin : appPrinList) {
			for (Application_Profile__c appProf : appProfList) {
				if (appProf.Applicant_Type__c == 'Principal') {
					if ((appProf.Client_CIF_Code__c != null && appProf.Client_CIF_Code__c == appPrin.CIF__c)
						|| (appProf.Client_CIF_Code__c == null && appProf.Related_to_Client_Id_Or_Reg_Number__c != null && appPrin.Id_Number__c == String.valueof(appProf.Related_to_Client_Id_Or_Reg_Number__c).replaceAll('[^a-zA-Z0-9\\s+]', ''))
						|| (appPrin.Principal_Shareholder_Name__c == appProf.Client_Name__c)) {
						appProfPrinNewList.add(appProf);
						accIds.add(appProf.Account__r.Id);
						break;
					}
				}
			}
		}

		Map<String, sObject> mapAccount = new Map<String, sObject>();
		List<String> accIdsList = new List<String>(accIds);
		List<Address__c> addressList = new AddressesSelector().selectByAccountIds(accIds);
		Address__c residAddress01 = getAddress(addressList, (accIdsList?.size() > 0 ? accIdsList[0] : null));

		mapAccount.put('Entity01', opp);
		requestBean.Request.ApplicationDV.Entity01 = mapEntityData(requestBean.Request.ApplicationDV.Entity01, mapAccount, residAddress01, null, mapKIMNumber);
        //saurabh changed this from entity type to client type
		if (String.valueOf(opp.Account.Client_Type__c).equalsIgnoreCase('Sole Trader')) {
			Address__c residAddress02 = getAddress(addressList, (accIdsList?.size() > 1 ? accIdsList[1] : null));
			if (spouseAcc.Is_Spouse_Contribute__c) {
				mapAccount.put('Entity02', spouseAcc);
				requestBean.Request.ApplicationDV.Entity02 = mapEntityData(requestBean.Request.ApplicationDV.Entity02, mapAccount, residAddress02, null, mapKIMNumber);
                
			}
		}

		Application_Profile__c appPrin03 = (appProfPrinNewList?.size() > 0 ? appProfPrinNewList[0] : null);
		Address__c residAddress03 = getAddress(addressList, (accIdsList?.size() > 2 ? accIdsList[2] : null));
		requestBean.Request.ApplicationDV.Entity03 = mapEntityData(requestBean.Request.ApplicationDV.Entity03, null, residAddress03, appPrin03, mapKIMNumber);

		Application_Profile__c appPrin04 = (appProfPrinNewList?.size() > 1 ? appProfPrinNewList[1] : null);
		Address__c residAddress04 = getAddress(addressList, (accIdsList?.size() > 3 ? accIdsList[3] : null));
		requestBean.Request.ApplicationDV.Entity04 = mapEntityData(requestBean.Request.ApplicationDV.Entity04, null, residAddress04, appPrin04, mapKIMNumber);

		Application_Profile__c appPrin05 = (appProfPrinNewList?.size() > 2 ? appProfPrinNewList[2] : null);
		Address__c residAddress05 = getAddress(addressList, (accIdsList?.size() > 4 ? accIdsList[4] : null));
		requestBean.Request.ApplicationDV.Entity05 = mapEntityData(requestBean.Request.ApplicationDV.Entity05, null, residAddress05, appPrin05, mapKIMNumber);

		Application_Profile__c appPrin06 = (appProfPrinNewList?.size() > 3 ? appProfPrinNewList[3] : null);
		Address__c residAddress06 = getAddress(addressList, (accIdsList?.size() > 5 ? accIdsList[5] : null));
		requestBean.Request.ApplicationDV.Entity06 = mapEntityData(requestBean.Request.ApplicationDV.Entity06, null, residAddress06, appPrin06, mapKIMNumber);

		return requestBean;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param entity 
	* @param mapAccount 
	* @param residAddress 
	* @param appPrin 
	* @param mapKIMNumber 
	* @return PowerCurveUpdateApplication_Req_IB_v1.Entity01 
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 mapEntityData(PowerCurveUpdateApplication_Req_IB_v1.Entity01 entity, Map<String, sObject> mapAccount, Address__c residAddress, Application_Profile__c appPrin, Map<String, Map<String, String>> mapKIMNumber) {
		entity.APPENTBUR.CONSINPRESADDR1 = (residAddress.Address1__c != null ? residAddress.Address1__c.left(25) : '');
		entity.APPENTBUR.CONSINPRESADDR2 = (residAddress.Address2__c != null ? residAddress.Address2__c.left(25) : '');
		entity.APPENTBUR.CONSINPRESSUBURB = (residAddress.Shipping_Suburb__c != null ? residAddress.Shipping_Suburb__c.left(25) : '');
		entity.APPENTBUR.CONSINPRESCTY = (residAddress.Shipping_City__c != null ? residAddress.Shipping_City__c.left(25) : '');
		entity.APPENTBUR.CONSINPRESPOSTCDE = (residAddress.Shipping_Zip_Postal_Code__c != null ? residAddress.Shipping_Zip_Postal_Code__c.left(5) : '');
		entity.APPENTBUR.CONSINPPSTADDR1 = (residAddress.Address1__c != null ? residAddress.Address1__c.left(30) : '');
		entity.APPENTBUR.CONSINPPSTSUBURB = (residAddress.Shipping_Suburb__c != null ? residAddress.Shipping_Suburb__c.left(30) : '');
		entity.APPENTBUR.CONSINPPSTCTY = (residAddress.Shipping_City__c != null ? residAddress.Shipping_City__c.left(30) : '');
		entity.APPENTBUR.CONSINPPSTPOSTCDE = (residAddress.Shipping_Zip_Postal_Code__c != null ? residAddress.Shipping_Zip_Postal_Code__c.left(6) : '');

		if (mapAccount != null) {
			Opportunity opp = (mapAccount?.get('Entity01') != null ? (Opportunity)mapAccount.get('Entity01') : null);
			Account spouseAcc = (mapAccount?.get('Entity02') != null ? (Account)mapAccount.get('Entity02') : null);

			if (spouseAcc != null) {
                
				entity.APPENTBUR.CONSINPSNAME = (spouseAcc.LastName != null ? spouseAcc.LastName.left(25) : '');
				entity.APPENTBUR.CONSINPFNAME1 = (spouseAcc.FirstName != null ? spouseAcc.FirstName.left(15) : '');
				//entity.APPENTBUR.CONSINPFNAME2 = (spouseAcc.FirstName != null ? spouseAcc.FirstName.left(15) : ''); removing as per Confirmation from W: 10644
				entity.APPENTBUR.CONSINPDOB = (spouseAcc.PersonBirthdate != null ? String.valueOf(spouseAcc.PersonBirthdate).remove('-') : '');
				entity.APPENTBUR.CONSINPOCC = (spouseAcc.Occupation__pc != null ? spouseAcc.Occupation__pc.left(20) : '');
				entity.APPENTBUR.CONSINPEMP = (spouseAcc.Employer_Name__pc != null ? spouseAcc.Employer_Name__pc.left(20) : '');
				entity.APPENTBUR.CONSINPHMPHN = (spouseAcc.PersonMobilePhone != null ? spouseAcc.PersonMobilePhone.left(13) : '');
				entity.APPENTBUR.CONSINPHMPHNCDE = (spouseAcc.PersonMobilePhone != null ? spouseAcc.PersonMobilePhone.left(3) : '');
				entity.APPENTBUR.CONSINPWRKPHN = (spouseAcc.PersonOtherPhone != null ? spouseAcc.PersonOtherPhone.left(13) : '');
				entity.APPENTBUR.CONSINPWRKPHNCDE = (spouseAcc.PersonOtherPhone != null ? spouseAcc.PersonOtherPhone.left(3) : '');
				entity.INTENTBUR.COMMINPKIMNUMBER = (mapKIMNumber.get(spouseAcc.CIF__c) != null ? String.valueOf(mapKIMNumber.get(spouseAcc.CIF__c).get('KIMNumber')) : '');
				entity.INTENTBUR.COMMINPVATNUMBER = (spouseAcc.VAT_Registration_Number__c != null ? String.valueOf(spouseAcc.VAT_Registration_Number__c) : '');
				entity.INTENTBUR.COMMINPTRADINGNAME = (spouseAcc.Trading_Name__c != null ? spouseAcc.Trading_Name__c : '');
				entity.INTENTBUR.COMMINPBUSNAME = (spouseAcc.FirstName != null ? spouseAcc.FirstName+spouseAcc.LastName : '');
				entity.INTENTBURCOMMNOPOSSIBLEMATCH = (mapKIMNumber.get(spouseAcc.CIF__c) != null ? String.valueOf(mapKIMNumber.get(spouseAcc.CIF__c).get('NoPossibleMatch')) : '');
			}
			else if (opp != null) {
				entity.APPENTBUR.CONSINPSNAME = (opp.Account.LastName != null ? opp.Account.LastName.left(25) : '');
				entity.APPENTBUR.CONSINPFNAME1 = (opp.Account.FirstName != null ? opp.Account.FirstName.left(15) : '');
				entity.APPENTBUR.CONSINPFNAME2 = (opp.Account.MiddleName != null ? opp.Account.MiddleName.left(15) : '');
				entity.APPENTBUR.CONSINPDOB = (opp.Account.PersonBirthdate != null ? String.valueOf(opp.Account.PersonBirthdate).remove('-') : '');
				entity.APPENTBUR.CONSINPOCC = (opp.Account.Occupation__pc != null ? opp.Account.Occupation__pc.left(20) : '');
				entity.APPENTBUR.CONSINPEMP = (opp.Account.Employer_Name__pc != null ? opp.Account.Employer_Name__pc.left(20) : '');
				entity.APPENTBUR.CONSINPHMPHN = (opp.Account.PersonMobilePhone != null ? opp.Account.PersonMobilePhone.left(13) : '');
				entity.APPENTBUR.CONSINPHMPHNCDE = (opp.Account.PersonMobilePhone != null ? opp.Account.PersonMobilePhone.left(3) : '');
				entity.APPENTBUR.CONSINPWRKPHN = (opp.Account.PersonOtherPhone != null ? opp.Account.PersonOtherPhone.left(13) : '');
				entity.APPENTBUR.CONSINPWRKPHNCDE = (opp.Account.PersonOtherPhone != null ? opp.Account.PersonOtherPhone.left(3) : '');
				entity.INTENTBUR.COMMINPKIMNUMBER = (mapKIMNumber.get(opp.Account.CIF__c) != null ? String.valueOf(mapKIMNumber.get(opp.Account.CIF__c).get('KIMNumber')).left(9) : '');
				entity.INTENTBUR.COMMINPVATNUMBER = (opp.Account.VAT_Registration_Number__c != null ? String.valueOf(opp.Account.VAT_Registration_Number__c).left(10) : '');
				entity.INTENTBUR.COMMINPTRADINGNAME = (opp.Account.Trading_Name__c != null ? opp.Account.Trading_Name__c.left(60) : '');
				entity.INTENTBUR.COMMINPBUSNAME = (opp.Account.Name != null ? opp.Account.Name.left(60) : '');
				entity.INTENTBURCOMMNOPOSSIBLEMATCH = (mapKIMNumber.get(opp.Account.CIF__c) != null ? String.valueOf(mapKIMNumber.get(opp.Account.CIF__c).get('NoPossibleMatch')) : '');
			}
		}
		else {
			entity.APPENTBUR.CONSINPSNAME = (appPrin?.Account__r.LastName != null ? appPrin?.Account__r.LastName.left(25) : '');
			entity.APPENTBUR.CONSINPFNAME1 = (appPrin?.Account__r.FirstName != null ? appPrin?.Account__r.FirstName.left(15) : '');
			entity.APPENTBUR.CONSINPFNAME2 = (appPrin?.Account__r.MiddleName != null ? appPrin?.Account__r.MiddleName.left(15) : '');
			entity.APPENTBUR.CONSINPDOB = (appPrin?.Account__r.PersonBirthdate != null ? String.valueOf(appPrin?.Account__r.PersonBirthdate).remove('-') : '');
			entity.APPENTBUR.CONSINPOCC = (appPrin?.Account__r.Occupation__pc != null ? appPrin?.Account__r.Occupation__pc.left(20) : '');
			entity.APPENTBUR.CONSINPEMP = (appPrin?.Account__r.Employer_Name__pc != null ? appPrin?.Account__r.Employer_Name__pc.left(20) : '');
			entity.APPENTBUR.CONSINPHMPHN = (appPrin?.Account__r.PersonMobilePhone != null ? appPrin?.Account__r.PersonMobilePhone.left(13) : '');
			entity.APPENTBUR.CONSINPHMPHNCDE = (appPrin?.Account__r.PersonMobilePhone != null ? appPrin?.Account__r.PersonMobilePhone.left(3) : '');
			entity.APPENTBUR.CONSINPWRKPHN = (appPrin?.Account__r.PersonOtherPhone != null ? appPrin?.Account__r.PersonOtherPhone.left(13) : '');
			entity.APPENTBUR.CONSINPWRKPHNCDE = (appPrin?.Account__r.PersonOtherPhone != null ? appPrin?.Account__r.PersonOtherPhone.left(3) : '');
			entity.INTENTBUR.COMMINPKIMNUMBER = (mapKIMNumber.get(appPrin?.Account__r.CIF__c) != null ? String.valueOf(mapKIMNumber.get(appPrin?.Account__r.CIF__c).get('KIMNumber')) : '');
			entity.INTENTBUR.COMMINPVATNUMBER = (appPrin?.Account__r.VAT_Registration_Number__c != null ? String.valueOf(appPrin?.Account__r.VAT_Registration_Number__c).left(10) : '');
			entity.INTENTBUR.COMMINPTRADINGNAME = (appPrin?.Account__r.Trading_Name__c != null ? appPrin?.Account__r.Trading_Name__c.left(60) : '');
			entity.INTENTBUR.COMMINPBUSNAME = (appPrin?.Account__r.Name != null ? appPrin?.Account__r.Name.left(60) : '');
			entity.INTENTBURCOMMNOPOSSIBLEMATCH = (mapKIMNumber.get(appPrin?.Account__r.CIF__c) != null ? String.valueOf(mapKIMNumber.get(appPrin?.Account__r.CIF__c).get('NoPossibleMatch')) : '');
		}

		return entity;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param entity 
	* @param appId 
	* @return PowerCurveUpdateApplication_Req_IB_v1.Entity01 
	**/
	public static PowerCurveUpdateApplication_Req_IB_v1.Entity01 mapFinancialConduct(PowerCurveUpdateApplication_Req_IB_v1.Entity01 entity, Id appId) {
		List<Application_Financial_Conduct__c> appFinConducts = new ApplicationFinancialConductSelector().selectByApplicationId(appId);

		if (appFinConducts != null && appFinConducts.size() > 0) {
			for (Application_Financial_Conduct__c appFinConduct : appFinConducts) {
				if (String.valueOf(appFinConduct.Conduct_Type__c).equalsIgnoreCase('Primary Conduct')) {
					entity.INTENTCDUCTDAYSSNCELASTCREDIT = appFinConduct.Days_Since_Last_Credit_Date__c != null ? String.valueOf(appFinConduct.Days_Since_Last_Credit_Date__c) : '-6';
				}
			}
		}
		else {
			entity.INTENTCDUCTDAYSSNCELASTCREDIT = '-6';
		}

		return entity;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param addressList 
	* @param accId 
	* @return Address__c 
	**/
	private static Address__c getAddress(List<Address__c> addressList, Id accId) {
		Address__c residAddress = new Address__c();
		if (addressList?.size() > 0 && accId != null) {
			for (Address__c address : addressList) {
				if (address.Address_Type__c == 'Residential' && address.Account__c == accId) {
					residAddress.Address1__c = address.Address1__c;
					residAddress.Address2__c = address.Address2__c;
					residAddress.Billing_Suburb__c = address.Billing_Suburb__c;
					residAddress.Billing_City__c = address.Billing_City__c;
					residAddress.Billing_Zip_Postal_Code__c = address.Billing_Zip_Postal_Code__c;
					residAddress.Shipping_Street__c = address.Shipping_Street__c;
					residAddress.Shipping_Suburb__c = address.Shipping_Suburb__c;
					residAddress.Shipping_City__c = address.Shipping_City__c;
					residAddress.Shipping_Zip_Postal_Code__c = address.Shipping_Zip_Postal_Code__c;
				}
			}
		}

		return residAddress;
	}

	
	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param date1 
	* @param date2 
	* @return Integer 
	**/
	public static Integer monthsBwDays(Date date1, Date date2) {
		Integer monthDiff;
		if (date1 != Null && date2 != Null) {
			monthDiff = date1.monthsBetween(date2);
			if (date2.day() > date1.day())
				monthDiff++;
		}
		return monthDiff;
	}

	/**
	* @description 
	* @author Himani Joshi | 2021-12-07 
	* @param appId 
	* @return Financial_Information__c 
	**/
	public static Financial_Information__c getFinacials(String appId) {
		List<Application_Financial_Info_Relationship__c> finInfoRelList = new ApplicationFinancialInfoRelSelector().selectByApplicationId(appId);
		Set<Id> finIds = new Set<Id>();

		if(finInfoRelList?.size() > 0) {
			for(Application_Financial_Info_Relationship__c appFinInfoRel :finInfoRelList) {
				finIds.add(appFinInfoRel.FinancialInfoId__c);
			}
		}

        List<Financial_Information__c> finInfoList = (finIds != null ? new FinancialInformationSelector().selectByFinancialIdsAndYearSel(finIds, new Set<String>{'Forecast'}) : null);
		Financial_Information__c finInfo = new Financial_Information__c();

		if(finInfoList?.size() > 0) {
			for(Financial_Information__c finInfoOut :finInfoList) {
				if(finInfoOut.Year_Selection__c == 'Year3') {
					finInfo = finInfoOut;
					break;
				}
				if(finInfoOut.Year_Selection__c == 'Year2') {
					finInfo = finInfoOut;
					break;
				}
				if(finInfoOut.Year_Selection__c == 'Year1') {
					finInfo = finInfoOut;
					break;
				}
			}
		}

		return finInfo;
	}
}