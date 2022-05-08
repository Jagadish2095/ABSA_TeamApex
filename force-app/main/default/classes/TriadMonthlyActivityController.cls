/**
 * @description Lightning Component Controller for Triad Monthly Activity
 *
 * @author  Gopi Budaraju (ZA)
 * @version v1.0n
 * @since   2020/09/20
 * @UserStory W:006253
 *
 * @update Englarmerge Mongwe
 * @date 2021-01-07
 * Complete UserStory W:006253
 */
public class TriadMonthlyActivityController {


	/**
	 * @description future method to get Monthly Calculation
	 * @author englarmerdge.mongwe@absa.africa | 2020/09/20
	 * @param appTriadList
	 * @param monthlyList
	 * @return Boolean
	**/
	//@Future(callout=true)
	public static Boolean getMonthlyCalculationsFromServiceFuture(List<Application_Triad__c> appTriadList, List<Application_triad_Detail__c> monthlyList) {
		monthlyCalculations_Req_IB_v1 requestBean = monthlyCalculations_IU_v1.monthlyCalculations(appTriadList, monthlyList);
		monthlyCalculations_Resp_IB_v1 responseBean = getMonthlyCalculationService(requestBean);

		Decimal Cheque_RD = 0.00;
		Decimal Savings_RD = 0.00;
		Decimal Debits_Cheques = 0.00;
		Decimal Debits_Deposits = 0.00;
		Application_Triad__c apptriad = (appTriadList?.size() > 0 ? appTriadList[0] : null);

		if (responseBean?.aggregation != null && apptriad != null) {
			for (monthlyCalculations_Resp_IB_v1.aggregation MCAg : responseBean.aggregation) {
				if (MCAg.type.equalsIgnoreCase('Cheque RD Events_Last 3 Months')) {
					apptriad.Total_Cheque_RD_last_3_mth__c = Cheque_RD = MCAg.total;
				}
				if (MCAg.type.equalsIgnoreCase('Savings RD Events_Last 3 Months')) {
					apptriad.Total_Savings_RD_last_3_mth__c = Savings_RD = MCAg.total;
				}
				if (MCAg.type.equalsIgnoreCase('Cheque RD Events_Last 6 Months')) {
					apptriad.Total_Cheque_RD_last_6_mth__c = Debits_Cheques = MCAg.total;
				}
				if (MCAg.type.equalsIgnoreCase('Savings RD Events_Last 6 Months')) {
					apptriad.Total_Savings_RD_last_6_mth__c = Debits_Deposits = MCAg.total;
				}
			}

			List<Application_Triad_Detail__c> apptdUpdatelst = new List<Application_Triad_Detail__c>();
			List<Application_Triad_Detail__c> apptdlst = new ApplicationTriadDetailsSelector().getDetailsByApplicationTriadID(apptriad.Id);

			if(apptdlst?.size() > 0) {
				for (Application_Triad_Detail__c apptd : apptdlst) {
					apptd.Number_of_Cheque_RD_Events_value__c = Cheque_RD;
					apptd.Number_of_Savings_RD_Events_value__c = Savings_RD;
					apptd.Number_of_Debits_Cheques_value__c = Debits_Cheques;
					apptd.Number_of_Debits_Deposits_value__c = Debits_Deposits;
					apptdUpdatelst.add(apptd);
				}
			}

			try {
				upsert apptriad;
				upsert apptdUpdatelst;
			}
			catch (Exception ex) {
				System.debug('Monthly Triad Save Failed: ' + ex.getDmlMessage(0));
			}
		}

		return true;
	}

    /**
     * @description method to get Application Triad Monthly Activities
     * @author englarmerdge.mongwe@absa.africa | 2020/09/20
     * @param oppID
     * @return List<Application_Triad_Detail__c>
    **/
	@AuraEnabled
    public static List<Application_Triad_Detail__c> getApplicationTriadMonthlyActivities(Id oppID) {
		Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
		Account acc = new AccountsSelector().selectByOpportunityId(oppID);
		List<Application_Triad__c> triadList = new ApplicationTriadsSelector().getTriadsByApplicationAndClientCode(app.Id, acc.CIF__c);
		List<Application_triad_Detail__c> triadDetList = (triadList?.size() == 0 ? null : new ApplicationTriadDetailsSelector().getDetailsByApplicationTriadID(triadList[0].Id));

		Boolean monthlyAggrDone = getMonthlyCalculationsFromServiceFuture(triadList, triadDetList);

		if(monthlyAggrDone) {
			List<Application_Triad_Detail__c> triadDetailList = (triadList?.size() == 0 ? null : new ApplicationTriadDetailsSelector().getDetailsByApplicationTriadID(triadList[0].Id));
			if(triadDetailList?.size() > 0) {
				return triadDetailList;
			}
		}

        return null;
	}

	/**
	 * @description method to get Monthly Calculation from Service
	 * @author englarmerdge.mongwe@absa.africa | 2020/09/20
	 * @param req
	 * @return monthlyCalculations_Resp_IB_v1
	**/
	public static monthlyCalculations_Resp_IB_v1 getMonthlyCalculationService(monthlyCalculations_Req_IB_v1 req){

        if(Test.isRunningTest()) {
            monthlyCalculations_IH_v1_Test.monthlyCalTestMock();
        }

		//Just to test, remove dummy data when done
		//monthlyCalculations_Req_IB_v1 reqDummy = monthlyCalculations_Req_IB_v1.createDummyRequest();
		//monthlyCalculations_Resp_IB_v1 resp = monthlyCalculations_IH_v1.monthlyCalculations(reqDummy);
		monthlyCalculations_Resp_IB_v1 resp = monthlyCalculations_IH_v1.getmonthlyCalculations(req);

		if(resp?.statusCode == 200) {
			if(resp?.aggregation != null) {
				return resp;
			}
		}

        return null;
    }
}