/**
 * @description Queueable class to call the CIdeleteFromFICALockoutV1 service
 * @author  Mbuyiseni Mbhokane
 * @version v1.0
 * @since   13/11/2020
 * @updated 2021-05-27
 *
 */
public class DelFromFicaLockout implements Queueable, Database.AllowsCallouts {
	private Id opportunityId;
	public Boolean isSuccess = false;
	private static final Date TODAYS_DATE = Date.today();

	List<Sys_Log_Integration__c> sysLogs = new List<Sys_Log_Integration__c>();

	/**
	 * @description Constructor
	 * @param oppId
	 */
	public DelFromFicaLockout(ID oppId) {
		this.opportunityId = oppId;
	}
	/**
	 * @description execute
	 * @param context
	 */
	public void execute(QueueableContext context) {
		String dateVerified = String.valueOf(TODAYS_DATE).replace('-', '');
		Account accountDetails = new AccountsSelector().selectByOpportunityId(opportunityId);
		List<Opportunity> getOpportunityRecord = new OpportunitiesSelector().selectByOpportunityId(opportunityId);

		if (accountDetails != null && String.isNotBlank(accountDetails.CIF__c)) {
			String dateIdentified = String.valueOf(accountDetails.Date_Identified__c).replace('-', '');
			try {
				CIdeleteFromFICALockoutV1_Req_IB_v1 requestBean = CIdeleteFromFICALockoutV1_IU_v1.mapRequiredFields(
					accountDetails.CIF__c,
					dateIdentified,
					dateVerified
				);
				CIdeleteFromFICALockoutV1_Resp_IB_v1 responseBean = CIdeleteFromFICALockoutV1_IH_v1.deleteFromFicaLockout(requestBean);
				System.debug('Status Code: ' + responseBean.StatusCode);
				System.debug('Response Bean : ' + responseBean);
				if ((responseBean != null) && (responseBean.statusCode == 200)) {
					isSuccess = true;
					getOpportunityRecord.get(0).FICA_Message__c = responseBean.serialize(
						responseBean.CIdeleteFromFICALockoutV1Response.nbsmsgo3.msgEntry.msgTxt
					);
					//update the opportunity
					//update getOpportunityRecord;
				} else {
					getOpportunityRecord.get(0).FICA_Message__c = responseBean.statusCode + ' : ' + responseBean.message;
					System.debug('Response Message : ' + responseBean.message + ' Response Status Code: ' + responseBean.statusCode);
				}
			} catch (Exception e) {
				System.debug('Error occured : ' + e.getCause() + ' :' + e.getMessage());
			}
		}
		//Another service will only be called when the CIdeleteFromFICALockoutV1 was successful
		if (isSuccess) {
			 //if(!Test.isRunningTest()){
			//calling DigitalHoldUpdate
			Map<Opportunity, List<Sys_Log_Integration__c>> digiHoldLogsMap = new Map<Opportunity, List<Sys_Log_Integration__c>>();
			digiHoldLogsMap = DigitalHoldUpdate.digitalHoldUpdateCall(getOpportunityRecord[0]);
			List<Opportunity> digiHoldOpportunity = new List<Opportunity>(digiHoldLogsMap.keySet());
			if (!digiHoldLogsMap.isEmpty() && digiHoldLogsMap != null) {
				sysLogs.addAll(digiHoldLogsMap.get(digiHoldOpportunity[0]));
			}
			getOpportunityRecord[0].DigitalHoldSuccess__c = digiHoldOpportunity[0].DigitalHoldSuccess__c;
			getOpportunityRecord[0].Digital_Hold_Response__c = digiHoldOpportunity[0].Digital_Hold_Response__c;

			//calling DomicileChange on success of Digital Holds
			if (digiHoldOpportunity[0].DigitalHoldSuccess__c == true) {
				Map<Opportunity, List<Sys_Log_Integration__c>> domicileLogsMap = new Map<Opportunity, List<Sys_Log_Integration__c>>();
				domicileLogsMap = DomicileChange.domicileChangeCall(getOpportunityRecord[0]);
				List<Opportunity> domicileOpportunity = new List<Opportunity>(domicileLogsMap.keySet());
				if (!domicileLogsMap.isEmpty() && domicileLogsMap != null) {
					sysLogs.addAll(domicileLogsMap.get(domicileOpportunity[0]));
				}
				getOpportunityRecord[0].DomicileChangeSuccess__c = domicileOpportunity[0].DomicileChangeSuccess__c;
				getOpportunityRecord[0].Domicile_Response__c = domicileOpportunity[0].Domicile_Response__c;
			}
		//}
		 }
		update getOpportunityRecord;
		upsert sysLogs;
	}
}