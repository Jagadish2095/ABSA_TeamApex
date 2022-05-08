/**
 * @description Handler for the account trigger
 * @author  Kyle Alexander
 * @created 2018-11-07
 */
public class TriggerHandlerAccount extends TriggerHandler {
	public virtual override void beforeUpdate(Map<Id, sObject> triggerNew, Map<Id, sObject> triggerOld) {
		Map<Id, Account> accTriggerNew = (Map<Id, Account>) triggerNew;
		Map<Id, Account> accTriggerOld = (Map<Id, Account>) triggerOld;
		List<Account> accounts = convertMapToList(accTriggerNew);
		Set<Id> accountIds = new Set<Id>();
		List<Account> validateAccounts = new List<Account>();
		Id usrId = UserInfo.getUserId();
		User runUser = new UsersSelector().selectById(usrId);
		String runUserProf = runUser.Profile.Name;
		if (!runUserProf.contains('System Administrator')) {
			for (Account account : accounts) {
				if(String.isEmpty(account.Registration_Number__c) && (!String.isEmpty(account.Trust_Number__c) || !String.isEmpty(account.Trust_Number_New_format__c))){
					account.Registration_Number__c = account.Trust_Number__c != null ? account.Trust_Number__c : account.Trust_Number_New_format__c;
				}
				if(String.isEmpty(account.Trust_Number__c) && !String.isEmpty(account.Trust_Number_New_format__c)){
					account.Trust_Number__c = account.Trust_Number_New_format__c;
				}
				accountIds.add(account.Id);
				if (!account.Valid_Update_Bypass__c) {
					validateAccounts.add(account);
				} else {
					account.Valid_Update_Bypass__c = false;
				}
			}
		}
		List<Opportunity> opportunities = new OpportunitiesSelector().selectBySetAccountIds(accountIds);
		List<Lead> leadlst = new List<Lead>();
		Map<id, list<Lead>> AccIdVSLeadMap = new Map<id, list<Lead>>();
		set<id> AccIdSet = new Set<id>();
		for (Account account : accounts) {
			AccIdSet.add(account.id);
		}
		for (Lead Ld : [SELECT Id, Account__c FROM Lead WHERE Account__c IN :AccIdSet]) {
			if (AccIdVSLeadMap.get(Ld.Account__c) == null) {
				AccIdVSLeadMap.put(Ld.Account__c, new List<lead>{ Ld });
			} else {
				AccIdVSLeadMap.get(Ld.Account__c).add(Ld);
			}
		}
		for (Account account : accounts) {
			if (account.IsPersonAccount) {
				if (
					accTriggerOld.get(account.id).FirstName != account.FirstName ||
					accTriggerOld.get(account.id).LastName != account.LastName ||
					accTriggerOld.get(account.id).ID_Type__pc != account.ID_Type__pc ||
					accTriggerOld.get(account.id).ID_Type__c != account.ID_Type__c ||
					accTriggerOld.get(account.id).ID_Number__pc != account.ID_Number__pc ||
					accTriggerOld.get(account.id).Client_Type__c != account.Client_Type__c ||
					accTriggerOld.get(account.id).PersonBirthdate != account.PersonBirthdate ||
					accTriggerOld.get(account.id).Nationality__pc != account.Nationality__pc ||
					accTriggerOld.get(account.id).Country_of_Residence__pc != account.Country_of_Residence__pc
				) {
					account.Casa_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.CASA_Status__c = 'Incomplete';
					}
				}
				if (
					accTriggerOld.get(account.id).Occupation__pc != account.Occupation__pc ||
					accTriggerOld.get(account.id).Occupation_Category__pc != account.Occupation_Category__pc ||
					accTriggerOld.get(account.id).Occupation_Status__pc != account.Occupation_Status__pc ||
					accTriggerOld.get(account.id).Client_Type__c != account.Client_Type__c ||
					accTriggerOld.get(account.id).ID_Number__pc != account.ID_Number__pc ||
					accTriggerOld.get(account.id).Income_Source__pc != account.Income_Source__pc ||
					accTriggerOld.get(account.id).Source_of_Income__c != account.Source_of_Income__c ||
					accTriggerOld.get(account.id).Standard_Industry_SIC_Code__c != account.Standard_Industry_SIC_Code__c
				) {
					account.Risk_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.Risk_Status__c = 'Incomplete';
					}
				}
				if (
					accTriggerOld.get(account.id).FirstName != account.FirstName ||
					accTriggerOld.get(account.id).LastName != account.LastName ||
					accTriggerOld.get(account.id).ID_Type__pc != account.ID_Type__pc ||
					accTriggerOld.get(account.id).ID_Type__c != account.ID_Type__c ||
					accTriggerOld.get(account.id).ID_Number__pc != account.ID_Number__pc ||
					accTriggerOld.get(account.id).Gender__pc != account.Gender__pc ||
					accTriggerOld.get(account.id).Phone != account.Phone ||
					accTriggerOld.get(account.id).Occupation__pc != account.Occupation__pc ||
					accTriggerOld.get(account.id).PersonEmail != account.PersonEmail
				) {
					account.Fraud_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.Fraud_Status__c = 'Incomplete';
					}
				}
				if (accTriggerOld.get(account.id).ID_Number__pc != account.ID_Number__pc || accTriggerOld.get(account.id).ID_Type__pc != account.ID_Type__pc) {
					account.Person_Unique_Identifier__pc = account.ID_Type__pc + account.ID_Number__pc;
				}
				//System.debug('STATUS 89 ' + accTriggerOld.get(account.id).FinServ__Status__c + ' NEW STATUS ' + account.FinServ__Status__c);
				Boolean isLeadAvailable = false;
				try {
					List<Lead> leadList = new List<Lead>();
					leadList = AccIdVSLeadMap.get(account.Id);
					if (leadList != null && leadList.size() > 0) {
						isLeadAvailable = true;
					}
				} catch (Exception e) {
					//System.debug('The following exception has occurred: ');
					throw e;
				}
				if (account.FinServ__Status__c == 'Active' && !isLeadAvailable) {
					Lead newLeadRec = new Lead();
					List<Group> groupQMerch = new GroupsSelector().selectByNameAndType('Merch Fulfilment', 'Queue');
					List<Group> groupQWeb = new GroupsSelector().selectByNameAndType('Web Merchant Leads', 'Queue');
					List<Application__c> appRec = new ApplicationsSelector().applicationRelatedToAcc(account.Id);
					Id merchantRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Merchant Lead').getRecordTypeId();
					if (appRec != null && appRec.size() > 0 && appRec[0].Product_Interest__c != null) {
						if (appRec[0].Product_Interest__c.contains('Other Merchant Solutions')) {
							newLeadRec.OwnerId = groupQMerch[0].Id;
						} else if (appRec[0].Product_Interest__c.contains('Merchant Smartpay')) {
							newLeadRec.OwnerId = groupQWeb[0].Id;
						}
						newLeadRec.Account__c = account.id;
						newLeadRec.LastName = account.LastName;
						newLeadRec.FirstName = account.FirstName;
						newLeadRec.MobilePhone = account.PersonMobilePhone;
						newLeadRec.RecordTypeId = merchantRecordTypeId;
						leadlst.add(newLeadRec);
						EcpLeads_IH_v1.sendEcpLead(account.Id, appRec[0].Product_Interest__c, account.FinServ__Status__c);
						//ECPLeadRequest.ECPLeadRequestCall(account.Id, appRec[0].Product_Interest__c, account.FinServ__Status__c);
					}
				}
			} else {
				if (
					accTriggerOld.get(account.id).Name != account.Name ||
					accTriggerOld.get(account.id).ID_Type__c != account.ID_Type__c ||
					accTriggerOld.get(account.id).Client_Type__c != account.Client_Type__c ||
					accTriggerOld.get(account.id).Country_of_Incorporation__c != account.Country_of_Incorporation__c ||
					accTriggerOld.get(account.id).Country_of_Operation__c != account.Country_of_Operation__c ||
					accTriggerOld.get(account.id).Countries_Traded_With__c != account.Countries_Traded_With__c ||
					accTriggerOld.get(account.id).Country_of_Registration__c != account.Country_of_Registration__c ||
					accTriggerOld.get(account.id).Registration_Number__c != account.Registration_Number__c
				) {
					account.Casa_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.CASA_Status__c = 'Incomplete';
					}
				}
				if (
					accTriggerOld.get(account.id).Occupation__pc != account.Occupation__pc ||
					accTriggerOld.get(account.id).Occupation_Category__pc != account.Occupation_Category__pc ||
					accTriggerOld.get(account.id).Occupation_Status__pc != account.Occupation_Status__pc ||
					accTriggerOld.get(account.id).Source_of_Income__c != account.Source_of_Income__c ||
					accTriggerOld.get(account.id).Standard_Industry_SIC_Code__c != account.Standard_Industry_SIC_Code__c ||
					accTriggerOld.get(account.id).Country_of_Incorporation__c != account.Country_of_Incorporation__c ||
					accTriggerOld.get(account.id).Country_of_Operation__c != account.Country_of_Operation__c ||
					accTriggerOld.get(account.id).Countries_Traded_With__c != account.Countries_Traded_With__c ||
					accTriggerOld.get(account.id).The_Client_is_involved_in_High_Risk_Indu__c != account.The_Client_is_involved_in_High_Risk_Indu__c ||
					accTriggerOld.get(account.id).Work_Item_Classification__c != account.Work_Item_Classification__c ||
					accTriggerOld.get(account.id).Country_of_Registration__c != account.Country_of_Registration__c
				) {
					account.Risk_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.Risk_Status__c = 'Incomplete';
					}
				}
				if (
					accTriggerOld.get(account.id).Name != account.Name ||
					accTriggerOld.get(account.id).ID_Type__c != account.ID_Type__c ||
					accTriggerOld.get(account.id).Registration_Number__c != account.Registration_Number__c
				) {
					account.Fraud_Status__c = 'Incomplete';
					for (Opportunity opportunity : opportunities) {
						opportunity.Fraud_Status__c = 'Incomplete';
					}
				}
			}
		}
		if (leadlst.size() > 0 && leadlst != null) {
			insert leadlst;
		}
		if (opportunities.size() != 0) {
			for (opportunity opp : opportunities) {
				opp.ByPassValidationInApex__c = true;
				opp.Sys_BypassValidation__c = true;
			}
		}
		update opportunities;

		if (validateAccounts.size() == 0) {
			for (Account account : accounts) {
				account.Valid_Update__c = true;
			}
		} else {
			for (Account vAcc : validateAccounts) {
				Integer caseCount = 0;
				Integer leadCount = 0;
				Integer oppCount = 0;
				Integer lstCount = 0;
				List<Case> lstCase = new CasesSelector().selectIsOpenByOwnerByAccount(usrId, vAcc.Id);
				List<Lead> lstLead = new LeadsSelector().selectIsOpenByOwnerByAccount(usrId, vAcc.Id);
				List<Opportunity> lstOpp = new OpportunitiesSelector().selectIsOpenByOwnerByAccount(usrId, vAcc.Id);
				if (lstCase != null) {
					caseCount = lstCase.size();
				}
				if (lstLead != null) {
					leadCount = lstLead.size();
				}
				if (lstOpp != null) {
					oppCount = lstOpp.size();
				}
				lstCount = caseCount + leadCount + oppCount;
				if (lstCount > 0) {
					vAcc.Valid_Update__c = true;
				} else {
					vAcc.Valid_Update__c = false;
				}
			}
		}
	}
	/**
    * @description beforeInsert //00001 -casa issue
    * @param newRecords
    */
    public virtual override void beforeInsert(List<sObject> newRecords) {
        List<Account> accounts;
        if(newRecords !=null & newRecords.size() > 0){
            accounts =(List<Account>) newRecords;
        }        
        for (Account account : accounts) {
            if(String.isEmpty(account.Registration_Number__c) && (!String.isEmpty(account.Trust_Number__c) || !String.isEmpty(account.Trust_Number_New_format__c))){
                account.Registration_Number__c = account.Trust_Number__c != null ? account.Trust_Number__c : account.Trust_Number_New_format__c;
            }
            if(String.isEmpty(account.Trust_Number__c) && !String.isEmpty(account.Trust_Number_New_format__c)){
                account.Trust_Number__c = account.Trust_Number_New_format__c;
            }
        }
    }

	/**
	 * @description
	 * @param triggerMap
	 * @return List<Account>
	 **/
	private static List<Account> convertMapToList(Map<Id, Account> triggerMap) {
		List<Account> accounts = new List<Account>();
		for (Account account : triggerMap.values()) {
			accounts.add(account);
		}
		return accounts;
	}
}