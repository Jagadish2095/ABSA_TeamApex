/**
 * @description getTranslationValues
 */
public with sharing class SavingUpdaccntconditionController {
	public static List<User> userRec;
	/**
	 * @description getTranslationValues
	 * @return List<String>
	 * @param systemName
	 * @param valueType
	 * @param direction
	 */
	@AuraEnabled
	public static List<String> getTranslationValues(String systemName, String valueType, String direction) {
		return BranchFunctions.getTranslationValues(systemName, valueType, direction);
	}

	/**
	 * @description getTranslationValues
	 * @return svlistproductconditionperaccount_Req_v3
	 * @param accountnbr
	 * @param noticePeriod
	 * @param withdrawalPercentage	 *
	 * @param investTerm
	 * @param riskrating
	 * @param prodcode
	 */
	@AuraEnabled
	public static string updateAccountConditionsRequest (string accountnbr, string noticePeriod,  string  withdrawalPercentage,string investTerm, string riskrating,  string prodcode)
	{
		
		string  returnmessage = 'success';
		 userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		svupdateaccountconditionsv2_IB_Req_v1 requestBean = new svupdateaccountconditionsv2_IB_Req_v1();
		svupdateaccountconditionsv2_IB_Req_v1.NBSAPDPI NBSAPDPI = new svupdateaccountconditionsv2_IB_Req_v1.NBSAPDPI();
		svupdateaccountconditionsv2_IB_Req_v1.NBSAPLI NBSAPLI = new svupdateaccountconditionsv2_IB_Req_v1.NBSAPLI();
		NBSAPLI.application = 'SALEFORCE';
		NBSAPLI.channel = 'SALEFORCE';
		NBSAPLI.trace = 'N';
		NBSAPDPI.NBSAPLI = NBSAPLI;
		svupdateaccountconditionsv2_IB_Req_v1.MSGI MSGI = new svupdateaccountconditionsv2_IB_Req_v1.MSGI();
		svupdateaccountconditionsv2_IB_Req_v1.NBSMSGI NBSMSGI = new svupdateaccountconditionsv2_IB_Req_v1.NBSMSGI();
		NBSMSGI.messageLanguage = 'E';
		NBSMSGI.messageTarget = 'STD';
		MSGI.NBSMSGI = NBSMSGI;

		svupdateaccountconditionsv2_IB_Req_v1.SVSP05I SVSP05I = new svupdateaccountconditionsv2_IB_Req_v1.SVSP05I();
		svupdateaccountconditionsv2_IB_Req_v1.SVSP05I_INPUT_AREA SVSP05I_INPUT_AREA = new svupdateaccountconditionsv2_IB_Req_v1.SVSP05I_INPUT_AREA();

		SVSP05I_INPUT_AREA.accountNumber =  accountnbr; // pass from front end
		SVSP05I_INPUT_AREA.savingsDepositType = 'D';
		SVSP05I_INPUT_AREA.parameterRetrieveType = '1'; //"3",
		SVSP05I_INPUT_AREA.chargeIndicator = 'N';
		SVSP05I_INPUT_AREA.tableCount = 2;
		Date dateToday = Date.today();
		svupdateaccountconditionsv2_IB_Req_v1.UpdateTable updateTable = new svupdateaccountconditionsv2_IB_Req_v1.UpdateTable();
		List<svupdateaccountconditionsv2_IB_Req_v1.UpdateTable> updateTables = new List<svupdateaccountconditionsv2_IB_Req_v1.UpdateTable>();
	//	svupdateaccountconditionsv2_IB_Req_v1.SVSP05I_INPUT_AREA.updateTable  update =  new SVSP05I_INPUT_AREA.updateTable();

	if (prodcode == '09308')
	 { 
		 	String noticepriod = String.valueOf(noticePeriod).leftPad(50, ' ');
	  updateTable.parameterID = 'NIA';
		updateTable.conditionValue = noticepriod;
		updateTable.capturedAmount = '0';
		updateTable.capturedAmountSign = '+';
		updateTable.capturedPercentageIndicator = 'N';
		updateTable.capturedRiskIndicator = riskrating; //supply risk
		updateTable.capturedDate = integer.valueOf(CVSServicesHelper.getDateForSalesforce(dateToday));
		updateTable.authourisationCode = '';
		updateTable.supervisor = 0;
	}
	else {
		String investmentterm = String.valueOf(investTerm).leftPad(18, '0');
		
		updateTable.parameterID = 'INT';
		updateTable.conditionValue = '';
		updateTable.capturedAmount = investmentterm;
		updateTable.capturedAmountSign = '+';
		updateTable.capturedPercentageIndicator = 'N';
		updateTable.capturedRiskIndicator = riskrating; //supply risk
		updateTable.capturedDate = integer.valueOf(CVSServicesHelper.getDateForSalesforce(dateToday));
		updateTable.authourisationCode = '';
		updateTable.supervisor = 0;
	}
	    string percunformated = withdrawalPercentage + ',';
		
	    String perc = '';
		if(withdrawalPercentage !='0')
		{
		perc = String.valueOf(percunformated).rightPad(7, '0');
		}
		else {
			perc = String.valueOf(percunformated).rightPad(6, '0');	
		}
		string percwithsign =  perc + '%';
		string percFormated = (percwithsign).leftPad(50, ' ');

		updateTables.add(updateTable);
		svupdateaccountconditionsv2_IB_Req_v1.UpdateTable updateTable1 = new svupdateaccountconditionsv2_IB_Req_v1.UpdateTable();
		updateTable1.parameterID = 'PER';
		updateTable1.conditionValue = percFormated; // PASS VALUE FROM FRONT END
		updateTable1.capturedAmount = '0';
		updateTable1.capturedAmountSign = '+';
		updateTable1.capturedPercentageIndicator = 'N';
		updateTable1.capturedRiskIndicator = riskrating;
		updateTable1.capturedDate = integer.valueOf(CVSServicesHelper.getDateForSalesforce(dateToday));
		updateTable1.authourisationCode = '';
		updateTable1.supervisor = 0;
		updateTables.add(updateTable1);

		SVSP05I_INPUT_AREA.divisionCode = 'ABS'; //pass correct value
		SVSP05I_INPUT_AREA.workStation = '99';
		SVSP05I_INPUT_AREA.branchCode = Integer.valueOf(userRec[0].SiteCode__c);
		SVSP05I_INPUT_AREA.agencyCode = Integer.valueOf(userRec[0].SiteCode__c);
		SVSP05I_INPUT_AREA.agencySiteType ='';// userRec[0].SiteType__c;
		SVSP05I_INPUT_AREA.tellerCode = Integer.valueOf(userRec[0].Teller_Operator_Code__c);
		SVSP05I_INPUT_AREA.supervisorCode = 0;
		SVSP05I_INPUT_AREA.branchSiteType = userRec[0].SiteType__c;		
		SVSP05I.SVSP05I_INPUT_AREA = SVSP05I_INPUT_AREA;
		SVSP05I.SVSP05I_INPUT_AREA.updateTable = updateTables;	   
		requestBean.SVSP05I = SVSP05I;
		requestBean.NBSAPDPI = NBSAPDPI;
		requestBean.MSGI = MSGI;
		String requestxd = JSON.serializePretty(requestBean);
		//
			
		svupdateaccountconditionsv2_IB_Resp_v1 responseBean = svupdateaccountconditionsv2_IH_v1.updateaccountcondition(requestBean);
												  
		String requestBeanBeanobj = JSON.serializePretty(responseBean);
		
		if((responseBean!= null) 
		    &&  responseBean.SVSP05I != null
			&& responseBean.SVSP05I.SVSP05I_INPUT_AREA != null
			&& responseBean.SVSP05I.SVSP05I_INPUT_AREA.updateTable.size() >0)
			{
				for (svupdateaccountconditionsv2_IB_Resp_v1.UpdateTable updttable : responseBean.SVSP05I.SVSP05I_INPUT_AREA.updateTable)
				{
                  if(updttable.conditionValue != null && updttable.conditionValue != ''  )
				  {
					returnmessage += 'error ' +  updttable.conditionValue;
					//system.debug('updttable.conditionValue' + updttable.conditionValue);
					//return returnmessage;
				  }

				}

			}
		return returnmessage;
	}
	
}