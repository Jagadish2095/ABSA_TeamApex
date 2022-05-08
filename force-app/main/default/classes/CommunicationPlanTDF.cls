/**
 * @description       : To create test data for the Communication plan object, the class caters for each record type
 * @author            : robertml@absa.africa
 * @last modified on  : 2021-06-21
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2021-06-21   robertml@absa.africa   Initial Version
 **/
@isTest
public with sharing class CommunicationPlanTDF {
	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 **/
	public CommunicationPlanTDF() {
	}

	/**
	 * @description
	 * @author robertml@absa.africa | 2021-06-21
	 * @param name
	 * @return sd_Communication_Plan__c
	 **/
	public static sd_Communication_Plan__c addCommPlan(String name) {
		sd_Communication_Plan__c commPlanCase = new sd_Communication_Plan__c(Name = name);
		insert commPlanCase;
		return commPlanCase;
	}
}