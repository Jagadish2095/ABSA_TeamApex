/**
 * @description       : SwitchingHelper
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-17   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/
public without sharing class SwitchingHelper {
	/**
	 * @description getUser
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @return User
	 **/
	public static User getUser() {
		string usr = UserInfo.getUserId();
		User userInfo = [SELECT EmployeeNumber, SiteCode__c, AB_Number__c, FirstName, LastName FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
		return userInfo;
	}

	/**
	 * @description createSalarySwitchEntry
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchingObj
	 * @param accountNumber
	 * @return String
	 **/
	public static String createSalarySwitchEntry(String switchingObj, string accountNumber) {
		User currentUser = getUser();
		Switching switchingO = (Switching) JSON.deserialize(switchingObj, Switching.class);
		if (switchingO.pendingSalarySwitchId == '') {
			Switching_Entry__c switchEntry = new Switching_Entry__c();
			switchEntry.Was_Switch_Successful__c = false;
			switchEntry.OpportunityId__c = switchingO.opportunityId;
			switchEntry.Account_Number__c = accountNumber;
			switchEntry.Previous_Account_Holder__c = switchingO.previousAccountHolder;
			switchEntry.Previous_Account_Number__c = switchingO.previousAccountNumber;
			switchEntry.Previous_Account_Type__c = switchingO.previousAccountType;
			switchEntry.Previous_Institution__c = switchingO.previousBank;
			switchEntry.Due_Date__c = switchingO.datePaid;
			switchEntry.Frequency__c = 'MONTHLY';
			switchEntry.Notes__c = 'Salary Notes';
			switchEntry.Overdue__c = false;
			switchEntry.Channel__c = 'Salesforce';
			switchEntry.State__c = 'READY_TO_SUBMIT';
			switchEntry.Switch_Type__c = 'SALARY';
			switchEntry.Employer_Name__c = switchingO.employer;
			switchEntry.Origin_Employee_Name__c = currentUser.FirstName;
			switchEntry.Origin_Employee_Number__c = currentUser.EmployeeNumber;
			switchEntry.Origin_Employee_Surname__c = currentUser.LastName;
			switchEntry.Origin_Site_Code__c = currentUser.SiteCode__c;

			try {
				insert switchEntry;
				return switchEntry.Id;
			} catch (DmlException ex) {
				throw ex;
			}
		} else {
			Switching_Entry__c switchEntry = [SELECT Id FROM Switching_Entry__c WHERE Id = :switchingO.pendingSalarySwitchId WITH SECURITY_ENFORCED];
			switchEntry.Was_Switch_Successful__c = false;
			switchEntry.OpportunityId__c = switchingO.opportunityId;
			switchEntry.Account_Number__c = accountNumber;
			switchEntry.Previous_Account_Holder__c = switchingO.previousAccountHolder;
			switchEntry.Previous_Account_Number__c = switchingO.previousAccountNumber;
			switchEntry.Previous_Account_Type__c = switchingO.previousAccountType;
			switchEntry.Previous_Institution__c = switchingO.previousBank;
			switchEntry.Due_Date__c = switchingO.datePaid;
			switchEntry.Frequency__c = 'MONTHLY';
			switchEntry.Notes__c = 'Salary Notes';
			switchEntry.Overdue__c = false;
			switchEntry.Channel__c = 'Salesforce';
			switchEntry.State__c = 'READY_TO_SUBMIT';
			switchEntry.Switch_Type__c = 'SALARY';
			switchEntry.Employer_Name__c = switchingO.employer;
			switchEntry.Origin_Employee_Name__c = currentUser.FirstName;
			switchEntry.Origin_Employee_Number__c = currentUser.EmployeeNumber;
			switchEntry.Origin_Employee_Surname__c = currentUser.LastName;
			switchEntry.Origin_Site_Code__c = currentUser.SiteCode__c;

			try {
				update switchEntry;
				return switchEntry.Id;
			} catch (DmlException ex) {
				throw ex;
			}
		}
	}

	/**
	 * @description createDebitOrderSwitchEntry
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param debOrderObj
	 * @param previousAccountNumber
	 * @param previousAccountType
	 * @param selectedBankName
	 * @param accountName
	 * @return String
	 **/
	public static String createDebitOrderSwitchEntry(
		String debOrderObj,
		String previousAccountNumber,
		String previousAccountType,
		String selectedBankName,
		String accountName
	) {
		User currentUser = getUser();
		SwitchingDebitOrder debOrder = (SwitchingDebitOrder) JSON.deserialize(debOrderObj, SwitchingDebitOrder.class);
		if (debOrder.pendingDebitOrderId == null) {
			Switching_Entry__c switchEntry = new Switching_Entry__c();
			switchEntry.Was_Switch_Successful__c = false;
			switchEntry.OpportunityId__c = debOrder.opportunityId;
			switchEntry.Amount__c = debOrder.amount;
			switchEntry.Switch_Type__c = 'DEBIT_ORDER';
			switchEntry.Channel__c = 'Salesforce';
			switchEntry.Due_Date__c = debOrder.dueDate;
			switchEntry.Frequency__c = debOrder.frequency;
			switchEntry.FixVar__c = debOrder.fixvar;
			switchEntry.Notes__c = 'Debit Order';
			switchEntry.Overdue__c = false;
			switchEntry.Account_Number__c = debOrder.refAccountNumber;
			switchEntry.State__c = 'READY_TO_SUBMIT';
			switchEntry.Previous_Account_Holder__c = accountName;
			switchEntry.Previous_Institution__c = selectedBankName;
			switchEntry.Previous_Account_Number__c = previousAccountNumber;
			switchEntry.Previous_Account_Type__c = previousAccountType;
			switchEntry.Employer_Name__c = debOrder.serviceProvider;
			switchEntry.Origin_Employee_Name__c = currentUser.FirstName;
			switchEntry.Origin_Employee_Surname__c = currentUser.LastName;
			switchEntry.Origin_Employee_Number__c = currentUser.EmployeeNumber;
			switchEntry.Origin_Site_Code__c = currentUser.SiteCode__c;

			try {
				insert switchEntry;
				return switchEntry.Id;
			} catch (DmlException ex) {
				throw ex;
			}
		} else {
			Switching_Entry__c switchEntry = [SELECT Id FROM Switching_Entry__c WHERE Id = :debOrder.pendingDebitOrderId WITH SECURITY_ENFORCED];
			switchEntry.Was_Switch_Successful__c = false;
			switchEntry.OpportunityId__c = debOrder.opportunityId;
			switchEntry.Amount__c = debOrder.amount;
			switchEntry.Switch_Type__c = 'DEBIT_ORDER';
			switchEntry.Channel__c = 'Salesforce';
			switchEntry.Due_Date__c = debOrder.dueDate;
			switchEntry.Frequency__c = debOrder.frequency;
			switchEntry.FixVar__c = debOrder.fixvar;
			switchEntry.Notes__c = 'Debit Order';
			switchEntry.Overdue__c = false;
			switchEntry.Account_Number__c = debOrder.refAccountNumber;
			switchEntry.State__c = 'READY_TO_SUBMIT';
			switchEntry.Previous_Account_Holder__c = accountName;
			switchEntry.Previous_Institution__c = selectedBankName;
			switchEntry.Previous_Account_Number__c = previousAccountNumber;
			switchEntry.Previous_Account_Type__c = previousAccountType;
			switchEntry.Employer_Name__c = debOrder.serviceProvider;
			switchEntry.Origin_Employee_Name__c = currentUser.FirstName;
			switchEntry.Origin_Employee_Surname__c = currentUser.LastName;
			switchEntry.Origin_Employee_Number__c = currentUser.EmployeeNumber;
			switchEntry.Origin_Site_Code__c = currentUser.SiteCode__c;

			try {
				update switchEntry;
				return switchEntry.Id;
			} catch (DmlException ex) {
				throw ex;
			}
		}
	}

	/**
	 * @description UpdateSwitchSuccessful
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param pendingSwitchId
	 **/
	public static void updateSwitchSuccessful(string pendingSwitchId) {
		Switching_Entry__c switchItem = [SELECT Id, Was_Switch_Successful__c FROM Switching_Entry__c WHERE Id = :pendingSwitchId WITH SECURITY_ENFORCED];
		switchItem.Was_Switch_Successful__c = true;
		update switchItem;
	}
}