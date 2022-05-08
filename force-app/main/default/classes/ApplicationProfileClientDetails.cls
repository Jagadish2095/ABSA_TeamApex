public class ApplicationProfileClientDetails implements Queueable {
	Set<Id> AppProfileids = new Set<Id>();
	public ApplicationProfileClientDetails(Set<ID> AppProfileids) {
		this.AppProfileids = AppProfileids;
	}

	public void execute(QueueableContext context) {
		ApplicationProfileClientDetails.updateAppProfiles(AppProfileids);
	}

	@future(callout = true)
	public static void updateAppProfiles(Set<id> AppProfileids) {
		List<Application_Profile__c> appprincipalList = new ApplicationProfileSelector().getApplicationProfilesbyId(AppProfileids);
		List<Application_Profile__c> appprincipalListUpdate = new List<Application_Profile__c>();
		system.debug('appprincipalList' + appprincipalList);
		if (appprincipalList != Null && appprincipalList.size() > 0) {
			for (Application_Profile__c approf : appprincipalList) {
				system.debug('approf.Client_CIF_Code__c' + approf.Client_CIF_Code__c);
				system.debug('approf.Application__r.Opportunity__r.Account.sic' + approf.Application__r.Opportunity__r.Account.sic);
				if (String.isNotBlank(approf.Client_CIF_Code__c)) {
					GetClientDetails_Resp_IB_v1 responseBean11;
					responseBean11 = GetClientDetails_IH_v1.getClientDetails(approf.Client_CIF_Code__c, '0', approf.Application__r.Opportunity__r.Account.Sic);
					system.debug('responseBean11' + responseBean11);
					if (responseBean11 != Null) {
						system.debug('responseBean11.noOfJointPartcpnt' + responseBean11.noOfJointPartcpnt);
						system.debug('responseBean11.curatorshipHold__c' + responseBean11.curatorshipHold);
						system.debug('responseBean11.finCrimeHold__c' + responseBean11.finCrimeHold);
						system.debug('responseBean11.applyDebtCounsel__c' + responseBean11.applyDebtCounsel);
						approf.noOfJointPartcpnt__c = responseBean11.noOfJointPartcpnt != Null ? responseBean11.noOfJointPartcpnt : Null;
						approf.curatorshipHold__c = responseBean11.curatorshipHold != Null ? responseBean11.curatorshipHold : Null;
						approf.finCrimeHold__c = responseBean11.finCrimeHold != Null ? responseBean11.finCrimeHold : Null;
						approf.applyDebtCounsel__c = responseBean11.applyDebtCounsel != Null ? responseBean11.applyDebtCounsel : Null;
						appprincipalListUpdate.add(approf);
					}
				}
			}
			if (appprincipalListUpdate.size() > 0) {
				update appprincipalListUpdate;
			}
		}
	}
}