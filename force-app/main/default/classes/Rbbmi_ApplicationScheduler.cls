/**
 * @description       : Rbbmi_ApplicationScheduler class.
 * @author            : Rajesh
 * @last modified on  : 2021-07-14
 * @last modified by  : robertml@absa.africa
 * Modifications Log
 * Ver   Date         Author                 Modification
 * 1.0   2020-09-23   Rajesh                 Initial Version
 **/

global class Rbbmi_ApplicationScheduler implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {
	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param SC
	 **/
	global void execute(SchedulableContext SC) {
		Rbbmi_ApplicationScheduler batch = new Rbbmi_ApplicationScheduler();
		Database.executeBatch(batch, 2000);
	}
	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param BC
	 * @return Database.QueryLocator
	 **/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			'Select Id,Policy_Number__c,Application__c from OpportunityLineItem Where Policy_Number__c != null AND Application__c != null'
		);
	}

	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param BC
	 * @param scope
	 **/
	global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope) {
		if (scope != null) {
			List<Rbbmi_Resp_IB_v1> response = Rbbmi_IH_v1.callRbbmiService();
			if (response != null) {
				Map<String, Rbbmi_Resp_IB_v1> accNumVSnotActivatedDayMap = new Map<String, Rbbmi_Resp_IB_v1>();
				for (Rbbmi_Resp_IB_v1 obj : response) {
					accNumVSnotActivatedDayMap.put(obj.Account_Number, obj);
				}
				Rbbmi_IH_v1.compareAndUpdateApplication(scope, accNumVSnotActivatedDayMap);
			}
		}
	}

	/**
	 * @description
	 * @author Rajesh | 2020-09-23
	 * @param BC
	 **/
	global void finish(Database.BatchableContext BC) {
	}
}