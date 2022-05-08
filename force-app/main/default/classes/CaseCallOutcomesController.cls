/*
 * Created by Vitthal Jivrag on 2021/03/10.
 */

/**
 * @description CaseCallOutcomesController
 */

public with sharing class CaseCallOutcomesController {
	/**
	 * @description CaseException
	 */
	public class CaseException extends Exception {
	}
	public static string recordType;
	/**
	 * @description getOutcomes
	 * @param recordId
	 * @return Map<String,List<string>>
	 */
	@AuraEnabled
	public static Map<String, List<String>> getOutcomes(Id recordId) {
		//Added By Divya
		String ObjectName = recordId.getSObjectType().getDescribe().getName();
		Opportunity opprec;
		Case caseObj;
		if (ObjectName == 'Opportunity') {
			opprec = [SELECT Id, recordtype.developername FROM Opportunity WHERE Id = :recordId LIMIT 1];
			recordType = opprec.recordtype.developername;
		} else {
			caseObj = [SELECT Id, recordtype.developername FROM Case WHERE Id = :recordId LIMIT 1];
			recordType = caseObj.recordtype.developername;
		}

		Map<String, List<String>> outcomesAndReasons = new Map<String, List<String>>();

		String product = '';
		if (recordType == 'VA_Client_Review') {
			product = 'Client Review';
		} else if (recordType == 'VA_Maturity') {
			//else if(caseObj.recordtype.developername == 'VA_Maturity'){
			product = 'Maturity';
		} else if (recordType == 'Investment_Opportunity') {
			product = 'Investement';
		}

		for (VA_Outcome_Setting__mdt outcome : [
			SELECT Outbound_Outcome__c, Inbound_Outcome__c, Inbound_Primary_Reason__c, Outbound_Primary_Reason__c
			FROM VA_Outcome_Setting__mdt
			WHERE Product__c = :product
			ORDER BY Outbound_Outcome__c ASC
		]) {
			List<String> primaryOutcomes = new List<String>();
			if (outcome.Outbound_Outcome__c != null) {
				if (outcome.Outbound_Primary_Reason__c != null) {
					if (outcomesAndReasons != null && outcomesAndReasons.containskey(outcome.Outbound_Outcome__c)) {
						primaryOutcomes = outcomesAndReasons.get(outcome.Outbound_Outcome__c);
						primaryOutcomes.add(outcome.Outbound_Primary_Reason__c);
					} else {
						primaryOutcomes = outcome.Outbound_Primary_Reason__c.split(',');
					}
				}
				outcomesAndReasons.put(outcome.Outbound_Outcome__c, primaryOutcomes);
			}
		}
		//System.debug('outcomes >>>>' + outcomesAndReasons);
		return outcomesAndReasons;
	}
	/**
	 * @param  recordId
	 * @param  outcome
	 * @param  reason
	 * @param  callBackTime
	 * @param  callBackLanguage
	 * @description saveOutcome
	 * @return String
	 **/
	@AuraEnabled
	public static string saveOutcome(Id recordId, String outcome, String reason, Datetime callBackTime, String callBackLanguage) {
		//Added By Divya
		String ObjectName = recordId.getSObjectType().getDescribe().getName();
		Opportunity opprec;
		Case caseObj;
		Id TaskRecordType;

		//system.debug('-->' + outcome);
		if (ObjectName == 'Opportunity') {
			opprec = [SELECT Id, recordtype.developername, Account.Name, Sub_Status__c, stageName FROM Opportunity WHERE Id = :recordId LIMIT 1];
			recordType = opprec.recordtype.developername;
			TaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Investment_Call_Task').getRecordTypeId();
		} else {
			caseObj = [SELECT id, recordtype.developername, Customer_Full_Name__c FROM Case WHERE id = :recordId];
			recordType = caseObj.recordtype.developername;
			caseObj.Bypass_Validation_Rules__c = true;
			TaskRecordType = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Client_Review_Call_Task').getRecordTypeId();
			TriggerDispatcher.skip(CaseTriggerHandler.class.getName());
			update caseObj;
		}

		Task outcomeTask = new Task();
		if (recordType == 'VA_Client_Review') {
			outcomeTask.Type__c = 'Client Review';
			outcomeTask.Client_Name__c = caseObj.Customer_Full_Name__c;
		} else if (recordType == 'VA_Maturity') {
			outcomeTask.Type__c = 'Maturity';
			outcomeTask.Client_Name__c = caseObj.Customer_Full_Name__c;
		}
		else if(recordType == 'Investment_Opportunity')
	    {
		     outcomeTask.Type__c='Investment';
	         outcomeTask.Client_Name__c=opprec.Account.Name;
		}
		outcomeTask.TaskSubtype = 'Call';
		outcomeTask.ActivityDate = System.today();
		outcomeTask.Status = 'Completed';
		outcomeTask.Subject = 'Call';
		outcomeTask.OwnerId = UserInfo.getUserId();

		outcomeTask.Outcome__c = outcome;

		if (!reason.contains('None')) {
			//   outcomeTask.Primary_outcome_reason__c = reason;
			outcomeTask.Primary_Lead_Outcome_reasons__c = reason;
		}
		outcomeTask.WhatId = recordId;

		outcomeTask.Type = 'Call';
		outcomeTask.RecordTypeId = TaskRecordType;

		if (outcome == 'Uncontactable') {
			List<task> listOfTask = [
				SELECT Call_ID__c, Call_Start_Time__c, Call_Duration__c
				FROM task
				WHERE WhatId = :recordId AND GlobalRefId__c != NULL
				ORDER BY Call_Start_Time__c ASC
			];
			if (listOfTask.size() < 3) {
				throw new CaseException(
					'Three call activity not found on ' +
					ObjectName +
					', please call the client 3 times before selecting Uncontactable outcome.'
				);
			}
		}
		if (
			outcome == 'Client Not Interested' &&
			(recordType == 'VA_Maturity' ||
			(recordType == 'VA_Client_Review' &&
			outcomeTask.Primary_Lead_Outcome_reasons__c == 'Client Not Interested - Voice') ||
			ObjectName == 'Opportunity')
		) {
			//system.debug('recordtype-->' + recordType + '--' + outcomeTask.Primary_Lead_Outcome_reasons__c);
			List<task> listOfTask = [
				SELECT Call_ID__c, Call_Start_Time__c, Call_Duration__c
				FROM task
				WHERE WhatId = :recordId AND GlobalRefId__c != NULL
				ORDER BY Call_Start_Time__c ASC
			];
			if (listOfTask.size() < 1) {
				throw new CaseException('Please call the client One time before selecting Client Not Interested outcome.');
			}
		}
		if (outcome == 'ID&V Not Successful') {
			List<task> listOfTask = [
				SELECT Call_ID__c, Call_Start_Time__c, Call_Duration__c
				FROM task
				WHERE WhatId = :recordId AND GlobalRefId__c != NULL
				ORDER BY Call_Start_Time__c ASC
			];
			if (listOfTask.size() < 1) {
				throw new CaseException('Please call the client One time before selecting ID&V Not Successful outcome.');
			}
		}
		if (outcome == 'Call Back') {
			List<task> listOfTask = [
				SELECT Call_ID__c, Call_Start_Time__c, Call_Duration__c
				FROM task
				WHERE WhatId = :recordId AND GlobalRefId__c != NULL
				ORDER BY Call_Start_Time__c ASC
			];
			if (listOfTask.size() < 1) {
				throw new CaseException('Please call the client One time before creating a Call back task.');
			}
			if (callBackTime == null) {
				throw new CaseException('Please enter a callback date');
			}
			if (ObjectName != 'Opportunity' && String.isBlank(callBackLanguage)) {
				throw new CaseException('Please enter a call back language');
			}
			if (callBackTime != null && ((String.isNotBlank(callBackLanguage) && ObjectName != 'Opportunity') || ObjectName == 'Opportunity')) {
				if (System.now() > callBackTime) {
					throw new CaseException('Call back date cannot be in the past');
				}
				outcomeTask.Call_Back_Language__c = callBackLanguage;
				outcomeTask.Call_Back_Date__c = callBackTime;
				//  outcomeTask.Primary_outcome_reason__c = 'Call Back';
				//system.debug('--' + callBackLanguage + '--' + outcome);
			}
		}

		try {
			//system.debug('---' + outcomeTask);
			insert outcomeTask;
		} catch (Exception ex) {
			throw new CaseException('There was an error ' +ex.getMessage() +'Line: ' +ex.getLineNumber() +' Cause :' +ex.getCause() +'  type:' +ex.getTypeName(), ex);
		}

		return outcomeTask.Id;
	}
}