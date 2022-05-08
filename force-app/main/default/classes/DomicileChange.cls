/**
 *@description Apex Class DomicileChange
 * @author  Mbuyiseni Mbhokane
 * @version v1.0
 * @since   2020-01-31
 * @updated 2021-05-27 : Anka Ganta
 */

public class DomicileChange {
	private ID oppRecordId;
	private String accountNumber;
	private String bankerSiteCode;
	public static Map<Opportunity, List<Sys_Log_Integration__c>> mapOppDomicileLogs = new Map<Opportunity, List<Sys_Log_Integration__c>>();

	/**
	 * @description domicileChangeCall changed enqueue job to static method
	 * @param getOpportunity
	 * @return Map<Opportunity,List<Sys_Log_Integration__c>>
	 */
	public static Map<Opportunity, List<Sys_Log_Integration__c>> domicileChangeCall(Opportunity getOpportunity) {
		if (getOpportunity.Id != null) {
			List<Opportunity> getOpportunityRecord = new OpportunitiesSelector().selectByOpportunityId(getOpportunity.Id);

			OpportunityLineItem opportunityProduct = new OpportunityLineItemsSelector().selectByOppId(getOpportunityRecord[0].Id, 1);

			List<Sys_Log_Integration__c> CqUpdAcctDomicileChangev2Logs = new List<Sys_Log_Integration__c>();

			if (opportunityProduct != null) {
				if (String.isNotBlank(opportunityProduct.Policy_number__c) && opportunityProduct.Product2.family.containsIgnoreCase('Cheque')) {
					User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
					String newBranch;

					if (currentUser.Virtual_Chanel_User__c) {
						newBranch = getOpportunityRecord[0].Branch_Region_Site__c;
					} else {
						if (currentUser.SiteCode__c != null) {
							newBranch = currentUser.SiteCode__c;
						} else {
							newBranch = getOpportunityRecord[0].Branch_Region_Site__c;
						}
					}

					//currentUser.SiteCode__c changing this to CMS branch site for W-8053 by Diksha 11/30/2020
					//getOpportunityRecord[0].Branch_Region_Site__c Replaced by Sipho Mbulawa 14/04/2021
					Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(
						opportunityProduct.Policy_number__c,
						newBranch,
						System.Label.ElectronicSiteForAccount,
						System.Label.DomicileTellerCode,
						System.Label.DomicileSupervisorCode
					);
					CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];

					//Logging the request
					CqUpdAcctDomicileChangev2Logs = responseMap.values()[0];

					if (responseBean != null) {
						getOpportunityRecord[0].Domicile_Response__c = responseBean.statusCode != 200
							? 'Change Domicile Site Code failed'
							: responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.msgEntry.msgTxt;
						getOpportunityRecord[0].DomicileChangeSuccess__c = responseBean.statusCode != 200 ? false : true;
					}

					//Insert the logs
					if (CqUpdAcctDomicileChangev2Logs != null && !CqUpdAcctDomicileChangev2Logs.isEmpty()) {
						//upsert CqUpdAcctDomicileChangev2Logs;
						mapOppDomicileLogs.put(getOpportunityRecord[0], CqUpdAcctDomicileChangev2Logs);
					}
				}

				if (String.isNotBlank(opportunityProduct.Policy_number__c) && opportunityProduct.Product2.family == 'Savings') {
					User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
					String newBranch;

					if (currentUser.Virtual_Chanel_User__c) {
						newBranch = getOpportunityRecord[0].Branch_Region_Site__c;
					} else {
						if (currentUser.SiteCode__c != null) {
							newBranch = currentUser.SiteCode__c;
						} else {
							newBranch = getOpportunityRecord[0].Branch_Region_Site__c;
						}
					}
					SVChangeAccountDomcileBranch_Req_IB_v1 requestbean = SVChangeAccountDomcileBranch_IU_v1.mapRequestFields(
						opportunityProduct.Policy_number__c,
						newBranch
					);
					SVChangeAccountDomcileBranch_Resp_IB_v1 respbean = SVChangeAccountDomcileBranch_IH_v1.changeDomcileBranch(requestbean);

					if (respbean != null) {
						//getOpportunityRecord[0].Domicile_Response__c = respbean.statusCode != 200 ? 'Change Domicile Site Code failed' : respbean.SVchangeAccountDomcileBranchV1Response.Nbsmsgo.msgEntry.get(0).msgTxt;
						getOpportunityRecord[0].Domicile_Response__c = respbean.statusCode != 200
							? 'Change Domicile Site Code failed'
							: respbean.SVchangeAccountDomcileBranchV1Response.Nbsmsgo.msgEntry.get(0).msgTxt != null
									? respbean.SVchangeAccountDomcileBranchV1Response.Nbsmsgo.msgEntry.get(0).msgTxt
									: 'Success';
						getOpportunityRecord[0].DomicileChangeSuccess__c = respbean.statusCode != 200 ? false : true;
					}
				}
				//update the opportunity
				//update getOpportunityRecord;
				mapOppDomicileLogs.put(getOpportunityRecord[0], CqUpdAcctDomicileChangev2Logs);
			}
		}
		return mapOppDomicileLogs;
	}
}