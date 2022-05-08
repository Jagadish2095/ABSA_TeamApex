public class TriggerHandlerFinancialInformation extends TriggerHandler {
	public virtual override void afterInsert(Map<Id, sObject> newRecords) {
		Map<Id, Financial_Information__c> FinInfoTriggerNew = (Map<Id, Financial_Information__c>)newRecords;
		map<Id, Financial_Information__c> fininfoaccmap = new map<Id, Financial_Information__c>();
		Set<Id> AccountIdvc = new Set<Id>();

		for (Financial_Information__c FinInfo : FinInfoTriggerNew.values()) {
			if ((FinInfo.Status__c == 'Draft') && (FinInfo.Account__c != Null)) {
				fininfoaccmap.put(FinInfo.Id, fininfo);
				AccountIdvc.add(fininfo.Account__c);
			}
		}

		if (fininfoaccmap.values().size() > 0) {
			Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Financial_Capture_Request').getRecordTypeId();
			List<Case> Caselist = new CasesSelector().selectByAccountIdSet(AccountIdvc, recordTypeId);
			Set<String> serviceGroupName = new Set<String>{'Financial Capture Group'};
			List<Service_Group__c> serviceGroup = new ServiceGroupsSelector().selectByName(serviceGroupName);
			Case caserec;
			Task taskrec;
			List<Case> newCaselist = new List<Case>();
			List<Task> newTaskList = new List<Task>();
			List<Financial_Information__c> newFinList = new List<Financial_Information__c>();
			Financial_Information__c finrec = new Financial_Information__c();
			Set<Id> idSet = new Set<Id>{serviceGroup[0].Id};
			List<Service_Group_Type__c> serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithGroupAndServiceInfo(idSet);
			Set<Id> SetAccwithCases = new Set<Id>();
			Map<Id, Id> accountidcaseid = new Map<Id, Id>();
			List<Group> groupDetail = new GroupsSelector().selectByNameAndType('Credit Support Consultant', 'Queue');

			if (Caselist.size() > 0) {
				for (Case c : Caselist) {
					SetAccwithCases.add(c.AccountId);
					accountidcaseid.put(c.AccountId, c.Id);
				}
			}

			for (Financial_Information__c FinInfo : fininfoaccmap.values()) {
				if (!SetAccwithCases.contains(FinInfo.Account__c)) {
					system.debug('FinInfo Account__c' + FinInfo.Account__c);
					caserec = new case();
					caserec.AccountId = FinInfo.Account__c;
					caserec.Status = 'New';
					caserec.Subject = 'Financial Information Case';
					caserec.Relationship_Banker__c = FinInfo.OwnerId;
					caserec.Subject = serviceGroupTypes[0].Service_Type__r.Name; // 'Financial Capture Request';
					caserec.Origin = 'Web';
					caserec.Status = 'New';
					caserec.Priority = 'High';
					caserec.RecordTypeId = recordTypeId;
					caserec.Type__c = serviceGroupTypes[0].Service_Type__r.Name;
					caserec.Type = serviceGroupTypes[0].Service_Type__r.Name;
					caserec.sd_Service_Group_Id__c = serviceGroupTypes[0].Service_Group__r.Id;
					caserec.sd_Service_Group_Type_Id__c = serviceGroupTypes[0].Id;
					caserec.sd_Original_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
					caserec.sd_Original_Service_Queue__c = serviceGroupTypes[0].Service_Group__r.Queue__c;
					caserec.sd_Service_Type_Id__c = serviceGroupTypes[0].Service_Type__r.Id;
					caserec.sd_Service_Type__c = serviceGroupTypes[0].Service_Type__c;
					caserec.sd_Service_Level_Id__c = serviceGroupTypes[0].Service_Level__c;
					caserec.sd_Service_Group__c = serviceGroupTypes[0].Service_Group__r.Name;
					caserec.BusinessHoursId = serviceGroupTypes[0].Service_Group__r.Business_Hours__c;
					newCaselist.add(caserec);
					SetAccwithCases.add(FinInfo.Account__c);
				}
				User usr = new UsersSelector().selectById(userinfo.getUserId());
				if (usr.profile.name == 'Standard User (Business Banker)' ||usr.profile.name=='System Administrator (Custom)'){
					taskrec = new task();
					taskrec.WhatId = FinInfo.Account__c;
					taskrec.Description = 'Capture Financial Document';
					taskrec.Subject = 'Capture Financial Document';
					taskrec.Status = 'Open';
					taskrec.Priority = 'Normal';
					taskrec.OwnerId = groupDetail[0].Id;
					taskrec.ActivityDate = date.today();
					newTaskList.add(taskrec);
				}
			}

			if (newCaselist.size() > 0 ) {
				insert newCaselist;
				for (case c : newCaselist) {
					accountidcaseid.put(c.AccountId, c.Id);
				}
			}

			if (newTaskList.size() > 0 && (!Test.isRunningTest())) {
				insert newTaskList;
			}

			for (Financial_Information__c FinInfo : fininfoaccmap.values()) {
				if (accountidcaseid.containskey(FinInfo.Account__c)) {
					finrec = new Financial_Information__c();
					finrec.Id = FinInfo.Id;
					finrec.Case__c = accountidcaseid.get(FinInfo.Account__c);
					newFinList.add(finrec);
				}
			}

			if (newFinList.size() > 0) {
				update newFinList;
			}
		}
	}

	public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
		Map<Id, Financial_Information__c> FinInfoTriggerNew = (Map<Id, Financial_Information__c>)newRecords;
		Map<Id, Financial_Information__c> FinInfoTriggerOld = (Map<Id, Financial_Information__c>)oldRecords;
        system.debug('$$$$FinInfoTriggerNew'+FinInfoTriggerNew);
        system.debug('$$$$FinInfoTriggerOld'+FinInfoTriggerOld);
        //System.debug('same value $$$'+FinInfoTriggerNew.values()[0]==FinInfoTriggerOld.values()[0]?'True':'False'); 
		Set<String> ApplicationIds = new Set<String>();
		List<Financial_Information__c> FinInfoList = new List<Financial_Information__c>();
		Set<Id> AccountIds = new set<Id>();
		List<Application_Financial_Info_Relationship__c> AppFinInfoRelNameList = new List<Application_Financial_Info_Relationship__c>();
		Application_Financial_Info_Relationship__c AppFinInfoRelName = new Application_Financial_Info_Relationship__c();
		Date todaydate = date.today();
		Date StatementDateMin = todaydate.addMonths(-18);
		for (Financial_Information__c FinInfo : FinInfoTriggerNew.values()) {
            system.debug('$$$FinInfo.Status__c'+FinInfo.Status__c);
            system.debug('$$$FinInfo.Client_Name__c'+FinInfo.Client_Name__c);
            system.debug('$$$FinInfo.Account__c'+FinInfo.Account__c);
            system.debug('$$$FinInfoTriggerOld.get(FinInfo.Id).Status__c'+FinInfoTriggerOld.get(FinInfo.Id).Status__c);
			if ((FinInfo.Status__c == 'Verified Complete') 
                && (FinInfoTriggerOld.get(FinInfo.Id).Status__c != FinInfo.Status__c) 
                && (FinInfo.Account__c != Null) && (FinInfo.Statement_Date_Year_end__c >=StatementDateMin) ) {
				FinInfoList.add(FinInfo);
				AccountIds.add(FinInfo.Account__c);
			}
		}

		if (FinInfoList.size() > 0) {
			Schema.DescribeSObjectResult d = Schema.SObjectType.Opportunity;
			Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
			Id onboardingrecId = rtMapByName.get('Credit Onboarding').getrecordtypeId();
			List<Opportunity> opplist = new OpportunitiesSelector().selectByAccountIdset(AccountIds, onboardingrecId);
			List<Application__c> Applist = new List<Application__C>();
			Map<Id, List<Id>> AccountApplicationMap = new Map<Id, List<Id>>();
			Set<Id> oppidset = new set<Id>();

			if (opplist.size() > 0) {
				for (Opportunity opp : opplist) {
					oppidset.add(opp.Id);
				}
			}

			Applist = new ApplicationsSelector().selectByOpportunityIdList2(oppidset);

			for (Application__c app : Applist) {
				if (!AccountApplicationMap.containskey(app.opportunity__r.Account.Id)) {
					AccountApplicationMap.put(app.opportunity__r.Account.Id, new list<Id>());
				}
				AccountApplicationMap.get(app.opportunity__r.Account.Id).add(app.Id);
			}

			for (Financial_Information__c FinInfo : FinInfoList) {
				if (AccountApplicationMap.containskey(FinInfo.Account__c)) {
					for (Id appid : AccountApplicationMap.get(FinInfo.Account__c)) {
						AppFinInfoRelName = new Application_Financial_Info_Relationship__c();
						AppFinInfoRelName.ApplicationId__c = appid;
						AppFinInfoRelName.FinancialInfoId__c = FinInfo.Id;
						AppFinInfoRelNameList.add(AppFinInfoRelName);
					}
				}
			}

			if (AppFinInfoRelNameList != Null && AppFinInfoRelNameList.size() > 0) {
				insert AppFinInfoRelNameList;
			}
		}
	}
}