/**
 * @description       : SwitchingInstitutions_IH_v1
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-17   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/
public class SwitchingInstitutions_IH_v1 {
	public static final String SwitchingInstitutions = 'SwitchingInstitutionsGET';
	public static final String SwitchingInstitutionsByName = 'GetSwitchingInstitutionByName';
	public static final String SwitchingInstitutionCreate = 'Switching Institutions POST';
	public static final String SwitchesGET = 'Switches GET';

	/**
	 * @description getSwitchingInstitutions
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @return SwitchingInstitutions_Resp_IB_v1
	 **/
	public static SwitchingInstitutions_Resp_IB_v1 getSwitchingInstitutions() {
		SwitchingInstitutions_Resp_IB_v1 responseBean = (SwitchingInstitutions_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			null,
			SwitchingInstitutions,
			SwitchingInstitutions_Resp_IB_v1.class
		);
		return responseBean;
	}

	/**
	 * @description getSwitchingInstitutionsWithSizeLimits
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param page
	 * @param size
	 * @return SwitchingInstitutions_Resp_IB_v1
	 **/
	public static SwitchingInstitutions_Resp_IB_v1 getSwitchingInstitutionsWithSizeLimits(string page, string size) {
		SwitchingInstitutions_Resp_IB_v1 responseBean = (SwitchingInstitutions_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			'?page=' +
			page +
			'&size=' +
			size,
			SwitchingInstitutions,
			SwitchingInstitutions_Resp_IB_v1.class
		);
		return responseBean;
	}

	/**
	 * @description getSwitchInstitutionByName
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param name
	 * @return SwitchingInstitutions_Resp_IB_v1.Item
	 **/
	public static SwitchingInstitutions_Resp_IB_v1.Item getSwitchInstitutionByName(String name) {
		string nameCleaned = name.trim().replace(' ', '%20');
		SwitchingInstitutions_Resp_IB_v1 responseBean = (SwitchingInstitutions_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			'/search/findByName?name=' + nameCleaned,
			SwitchingInstitutions,
			SwitchingInstitutions_Resp_IB_v1.class
		);
		return responseBean.x_embedded.items[0];
	}

	/**
	 * @description getSwitchInstitutionByNameAndArchived
	 * @author André Pietersen (IQ Business) | 2021-07-12
	 * @param archived
	 * @param name
	 * @return SwitchingInstitutions_Resp_IB_v1.Item
	 **/
	public static List<SwitchingInstitutions_Resp_IB_v1.Item> getSwitchInstitutionByNameAndArchived(String archived, String name) {
		string nameCleaned = name.trim().replace(' ', '%20');
		SwitchingInstitutions_Resp_IB_v1 responseBean = (SwitchingInstitutions_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			'?archived=' +
			archived +
			'&name=' +
			nameCleaned,
			SwitchingInstitutionsByName,
			SwitchingInstitutions_Resp_IB_v1.class
		);
		return responseBean.x_embedded.items;
	}

	/**
	 * @description getSwitchInstitution
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchId
	 * @return SwitchingInstitutions_Resp_IB_v1.Item
	 **/
	public static SwitchingInstitutions_Resp_IB_v1.Item getSwitchInstitution(String switchId) {
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = (SwitchingInstitutions_Resp_IB_v1.Item) Sys_Utilities_Integration.integrationServiceCall(
			null,
			'/' +
			switchId +
			'/institution',
			SwitchesGET,
			SwitchingInstitutions_Resp_IB_v1.Item.class
		);
		return responseBean;
	}

	/**
	 * @description createSwitchingInstitution
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param requestBean
	 * @return SwitchingInstitutions_Resp_IB_v1.Item
	 **/
	public static SwitchingInstitutions_Resp_IB_v1.Item createSwitchingInstitution(SwitchingInstitutions_Req_IB_v1 requestBean) {
		SwitchingInstitutions_Resp_IB_v1.Item responseBean = (SwitchingInstitutions_Resp_IB_v1.Item) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			SwitchingInstitutionCreate,
			SwitchingInstitutions_Resp_IB_v1.Item.class
		);
		return responseBean;
	}

	/**
	 * @description createSwitchingInstitutionInSalesforce
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param institutions
	 * @return List<Switching_Institution__c>
	 **/
	public static List<Switching_Institution__c> createSwitchingInstitutionInSalesforce(List<SwitchingInstitutions_Resp_IB_v1.Item> institutions) {
		List<Switching_Institution__c> newInstitutions = new List<Switching_Institution__c>();

		for (SwitchingInstitutions_Resp_IB_v1.Item institution : institutions) {
			Switching_Institution__c newInstitute = new Switching_Institution__c(
				CreatedBy__c = institution.createdBy,
				LastModifiedBy__c = institution.lastModifiedBy,
				CreationDate__c = institution.creationDate,
				LastModifiedDate__c = institution.lastModifiedDate,
				Name = institution.name,
				Contact_Person__c = institution.contactPerson,
				Contact_Email__c = institution.contactEmail,
				Contact_department__c = institution.contactDepartment,
				Debit_Order_Automated_Email__c = institution.debitOrderAutomatedEmail,
				Salary_Automated_Email__c = institution.salaryAutomatedEmail,
				Regex_Patterns__c = JSON.serialize(institution.regexPatterns),
				Debit_Order_Acknowledge_Hours_SLA__c = institution.debitOrderAcknowledgeHoursSLA,
				Debit_Order_Resolve_Hours_SLA__c = institution.debitOrderResolveHoursSLA,
				Salary_Acknowledge_Hours_SLA__c = institution.salaryAcknowledgeHoursSLA,
				Salary_Resolve_Hours_SLA__c = institution.salaryResolveHoursSLA,
				Route__c = institution.route == null ? 'NON_PARTICIPATING' : institution.route,
				Categories__c = JSON.serialize(institution.categories),
				Batch_File_Type__c = institution.batchFileType,
				Batch_Formatter_Type__c = institution.batchFormatterType,
				Batch_Integration_Type__c = institution.batchIntegrationType,
				Connection_Prefix__c = institution.connectionPrefix,
				Template__c = institution.template,
				Links__c = JSON.serialize(institution.x_links)
			);
			newInstitutions.add(newInstitute);
		}
		return newInstitutions;
	}
}