/**
 * @description       : Credit Group View Controller
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-25   Himanshu.Nimje@absa.africa   Initial Version
 **/
public class CreditGroupViewController {
	/**
	 * @description get Clients
	 * @author Himanshu.Nimje@absa.africa | 2021-06-25
	 * @param accId
	 * @return account
	 **/
	@AuraEnabled
	public static account getAccounts(Id accId) {
		Account acc = [SELECT Id, Name, CIF__c FROM Account WHERE Id = :accId LIMIT 1];
		return acc;
	}

	/**
	 * @description Service call to get response frm credit group view
	 * @author Himanshu.Nimje@absa.africa | 2021-06-25
	 * @param accId
	 * @return List<CreditGrpViewWrapper>
	 **/
	@AuraEnabled
	public static List<CreditGrpViewWrapper> GetCreditGroupView(Id accId) {
		Account acc = [SELECT Id, Name, CIF__c FROM Account WHERE Id = :accId LIMIT 1];
		if (acc.CIF__c != null) {
			GBgetCmsFullCrGroups_Resp_IB_v1 grpViewResp = GBgetCmsFullCrGroups_IH_v1.GBgetCmsFullCrGroupsV1(acc.CIF__c);

			// GBgetCmsFullCrGroups_Resp_IB_v1 grpViewResp = GBgetCmsFullCrGroups_IH_v1.GBgetCmsFullCrGroupsV1('ADHAUS 003');
			System.debug('@@ GetCreditGroupView' + JSON.serializePretty(grpViewResp));

			string ultimatePrimaryClient = grpViewResp.GSB025O.GSB025O.GSB025O_ULT_PRIMARY_CLIENT;

			List<CreditGrpViewWrapper> listGrpWrapper = new List<CreditGrpViewWrapper>();
			for (GBgetCmsFullCrGroups_Resp_IB_v1.GSB025O_GROUP_DETAIL detail : grpViewResp.GSB025O.GSB025O.GSB025O_GROUP_DETAIL) {
				if (detail.GSB025O_CLIENT_LINK != null && String.isNotBlank(detail.GSB025O_CLIENT_LINK) && detail.GSB025O_CLIENT_LINK != '') {
					CreditGrpViewWrapper clientData = new CreditGrpViewWrapper();
					if (detail.GSB025O_PRIM_OR_GRPMEM == 'P') {
						// clientData.PrimaryClient = detail.GSB025O_CLIENT_LINK;
						clientData.PrimaryClient = getClientName(detail.GSB025O_CLIENT_LINK);
						clientData.ClientCode = detail.GSB025O_CLIENT_LINK;
					} else {
						// clientData.GroupMember = detail.GSB025O_CLIENT_LINK;
						clientData.GroupMember = getClientName(detail.GSB025O_CLIENT_LINK);
						clientData.ClientCode = detail.GSB025O_CLIENT_LINK;
					}
					clientData.StatusIndicator = detail.GSB025O_STATUS_IND;
					clientData.UltimateClient = getClientName(ultimatePrimaryClient);

					listGrpWrapper.add(clientData);
				}
			}

			System.debug('@@ listGrpWrapper' + JSON.serializePretty(listGrpWrapper));
			return listGrpWrapper;
		}

		return null;
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-25
	 * @param cif
	 * @return string
	 **/
	public static string getClientName(string cif) {
		List<Account> accList = [SELECT Id, Name, CIF__c FROM Account WHERE CIF__c = :cif LIMIT 1];
		if (accList.size() > 0) {
			return accList[0].Name;
		} else {
			CIgetClientDetailsV12_Resp_IB_v1 accResp = CIgetClientDetailsV12_IH_v1.CIgetClientDetailsV12('009970', cif, 0);
			return accResp.surname;
		}
	}

	/**
	 * @description       : Credit Group View Wrapper Class
	 * @author            : Himanshu.Nimje@absa.africa
	 * @last modified on  : 2021-07-09
	 */
	public class CreditGrpViewWrapper {
		@AuraEnabled
		public String PrimaryClient;
		@AuraEnabled
		public String GroupMember;
		@AuraEnabled
		public String ClientCode;
		@AuraEnabled
		public String StatusIndicator;
		@AuraEnabled
		public String UltimateClient;
	}
}