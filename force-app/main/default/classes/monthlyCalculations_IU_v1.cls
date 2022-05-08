/**
 * Intergration Utility for GetTriadsAggregation Service
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
public class monthlyCalculations_IU_v1 {
	public static monthlyCalculations_Req_IB_v1 monthlyCalculations(List<Application_Triad__c> apptriadlst, List<Application_triad_Detail__c> monthlyList) {
		List<monthlyCalculations_Req_IB_v1.monthlyData> mdtlst = new List<monthlyCalculations_Req_IB_v1.monthlyData>();
		monthlyCalculations_Req_IB_v1 requestBeanclient = new monthlyCalculations_Req_IB_v1();
		monthlyCalculations_Req_IB_v1.client requestBean = new monthlyCalculations_Req_IB_v1.client();

		if (!apptriadlst.isEmpty()) {
			Application_Triad__c apptriad = apptriadlst[0];
			requestBean.name = apptriad.Client_Name__c;
            requestBean.primaryClientCode = apptriad.Client_Code__c;

			if (!monthlyList.isempty()) {
				for (Application_Triad_Detail__c at : monthlyList) {
					monthlyCalculations_Req_IB_v1.monthlyData mdt = new monthlyCalculations_Req_IB_v1.monthlyData();
					DateTime d = at.Month__c;
					String dateStr = d.format('dd/MM/yyyy');
					mdt.month = dateStr;
					mdt.chequeRDValue = at.Number_of_Cheque_RD_Events_value__c;
					mdt.savingsRDValue = at.Number_of_Savings_RD_Events_value__c;
					mdt.numChequeRDEvents = at.Number_of_Cheque_RD_Events__c;
					mdt.numSavingsRDEvents = at.Number_of_Savings_RD_Events__c;
					mdt.numChequeDebits = at.Number_of_Debits_Cheques__c;
					mdt.numSavingsDebits = at.Number_of_Debits_Deposits__c;
					mdtlst.add(mdt);
				}
			}
		}

		requestBean.monthlyData = mdtlst;
		requestBeanclient.client = requestBean;
		System.debug('requestBeanclient::: ' + JSON.serializePretty(requestBeanclient));
		return requestBeanclient;
	}
}