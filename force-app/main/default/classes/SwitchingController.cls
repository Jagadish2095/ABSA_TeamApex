/**
 * @description       : Switching controller
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-17   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/
public without sharing class SwitchingController {
	public static OpportunityLineItem oppProduct;

	/**
	 * @description getFinancialInstitutions
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @return List<String>
	 **/
	@AuraEnabled
	public static List<String> getFinancialInstitutions() {
		List<String> pickListValuesList = new List<String>();
		Schema.DescribeFieldResult fieldResult = Switching_Institution__c.Financial_Institutions__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry pickListVal : ple) {
			pickListValuesList.add(pickListVal.getLabel());
		}
		return pickListValuesList;
	}

	/**
	 * @description switchingCustomerData
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchingO
	 * @return String
	 **/
	@AuraEnabled
	public static String switchingCustomerData(Switching switchingO) {
		Account account = getAccount(switchingO.accountId);
		getOpprLineItem(switchingO.opportunityId);
		SwitchingCustomers_Resp_IB_v1 customerResp = SwitchingCustomers_IH_v1.getSwitchingCustomer(account.ID_Number__pc);
		
		if (customerResp != null) {
			if (customerResp.createdBy == null && customerResp.creationDate == null) {
				//Step 2 - Create Customer if not exist
				SwitchingCustomers_Req_IB_v1 requestBean = new SwitchingCustomers_Req_IB_v1();
				requestBean.bankAccountNumber = oppProduct.Policy_Number__c;
				requestBean.bankAccountType = oppProduct.Product_Family__c.toUpperCase();
				requestBean.bankBranch = '632005';
				requestBean.identifier = account.ID_Number__pc;
				requestBean.name = account.FirstName;
				requestBean.surname = account.LastName;
				requestBean.mobileNumber = account.PersonMobilePhone;
				requestBean.preferredLanguage = account.Communication_Language__pc == 'Afrikaans' ? 'AFR' : 'ENG';
				requestBean.communicationMethod = account.Communication_Method__c;
				requestBean.email = account.PersonEmail;
				requestBean.state = 'NOT_WELCOMED';
				requestBean.previousAccountNumber = switchingO.previousAccountNumber;
				if (switchingO.previousAccountType == '') {
					requestBean.previousAccountType = null;
				} else {
					requestBean.previousAccountType = switchingO.previousAccountType.toUpperCase();
				}

				try {
					SwitchingCustomers_Resp_IB_v1 customerCreateResp = SwitchingCustomers_IH_v1.createSwitchingCustomer(requestBean);
					String customerId = customerCreateResp.x_links.self.href.substring(customerCreateResp.x_links.self.href.lastIndexOf('/') + 1);
					//Step 3 - WELCOME Trigger against customer
					SwitchingCustomers_Resp_IB_v1 customerTriggerResp = SwitchingCustomers_IH_v1.customerTrigger(customerId, 'WELCOME');
					return customerCreateResp.x_links.self.href;
				} catch (Exception ex) {
					throw new AuraHandledException('Error creating Switching Customer: ' + ex.getMessage());
				}
			}
		}

		return customerResp.x_links.self.href;
	}

	/**
	 * @description switchingSalaryData
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchingO
	 * @param customerLink
	 * @return String
	 **/
	@AuraEnabled
	public static String switchingSalaryData(Switching switchingO, String customerLink) {
		String returnMessage = 'SUCCESS';
		User currentUser = SwitchingHelper.getUser();
		getOpprLineItem(switchingO.opportunityId);

		//Step 4.1 - Create Switch (Salary)
		//Step 4.2 - Setup Switch Institution against each switch
		//Step 4.3 - Setup Switch Customer against each switch
		//Step 4.4 - SUBMIT Trigger against Switch
		//Step 4.5 - Get Salary Switch Letter
		Switches_Req_IB_v1 requestSalaryBean = new Switches_Req_IB_v1();
		if (switchingO.isSalary) {
			requestSalaryBean.accountNumber = oppProduct.Policy_Number__c;
			requestSalaryBean.previousAccountNumber = switchingO.previousAccountNumber;
			if (switchingO.previousAccountType == '') {
				requestSalaryBean.previousAccountType = null;
			} else {
				requestSalaryBean.previousAccountType = switchingO.previousAccountType.toUpperCase();
			}

			requestSalaryBean.previousInstitution = switchingO.previousBank;
			requestSalaryBean.dueDate = switchingO.datePaid;
			requestSalaryBean.frequency = 'MONTHLY';
			requestSalaryBean.notes = 'Salary Notes';
			requestSalaryBean.overdue = false;
			requestSalaryBean.channel = 'Salesforce';
			requestSalaryBean.state = 'READY_TO_SUBMIT';
			requestSalaryBean.switchType = 'SALARY';
			requestSalaryBean.originEmployeeName = currentUser.FirstName;
			requestSalaryBean.originEmployeeSurname = currentUser.LastName;
			requestSalaryBean.originEmployeeNumber = currentUser.EmployeeNumber;
			requestSalaryBean.originSiteCode = currentUser.SiteCode__c;

			Switches_Resp_IB_v1 salaryResp = Switches_IH_v1.createSwitch(requestSalaryBean);
			String switchId = salaryResp.x_links.self.href.substring(salaryResp.x_links.self.href.lastIndexOf('/') + 1);
			
			if (switchingO.employer != null) {
				try {
					SwitchingInstitutions_Resp_IB_v1.Item institutionResp = SwitchingInstitutions_IH_v1.getSwitchInstitutionByName(switchingO.employer);
					String empInstitutionLink = institutionResp.x_links.self.href.substring(institutionResp.x_links.self.href.lastIndexOf('/') + 1);
					String linkInstitutionSwitchSA = Switches_IH_v1.LinkInstitutionSwitch(switchId, empInstitutionLink);
				} catch (Exception ex) {
					throw new AuraHandledException('Error linking Switching Institution: ' + ex.getMessage());
				}
			}

			try {
				String linkCustomerSwitch = Switches_IH_v1.LinkCustomerSwitch(switchId, customerLink);
				Switches_Resp_IB_v1 switchTrigger = Switches_IH_v1.switchTrigger(switchId, 'SUBMIT');
			} catch (Exception ex) {
				throw new AuraHandledException('Error linking Switches: ' + ex.getMessage());
			}
			//update SF data after callouts
			if (oppProduct.Switches__c == null) {
				oppProduct.Switches__c = switchId + ',';
			} else {
				oppProduct.Switches__c = oppProduct.Switches__c + switchId + ',';
			}
			if (!Test.isRunningTest()) {
				update oppProduct;
				if (switchingO.pendingSalarySwitchId != null) {
					SwitchingHelper.updateSwitchSuccessful(switchingO.pendingSalarySwitchId);
				}
			}
		}
		return returnMessage;
	}

	/**
	 * @description switchingDebitOrderData
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param debitOrder
	 * @param customerLink
	 * @param previousAccountNumber
	 * @param previousAccountType
	 * @param previousInstitution
	 * @return String
	 **/
	@AuraEnabled
	public static String switchingDebitOrderData(
		String debitOrder,
		String customerLink,
		String previousAccountNumber,
		String previousAccountType,
		String previousInstitution
	) {
		String returnMessage = 'SUCCESS';
		SwitchingDebitOrder debOrder = (SwitchingDebitOrder) JSON.deserialize(debitOrder, SwitchingDebitOrder.class);
		User currentUser = SwitchingHelper.getUser();
		getOpprLineItem(debOrder.opportunityId);

		//Step 5.1 - Create Switches (DO's)
		//Step 5.2 - Setup Switch Institution against each switch
		//Step 5.3 - Setup Switch Customer against each switch
		//Step 5.4 - SUBMIT Trigger against Switch

		Switches_Req_IB_v1 requestDOBean = new Switches_Req_IB_v1();
		requestDOBean.amount = debOrder.amount;
		requestDOBean.switchType = 'DEBIT_ORDER';
		requestDOBean.channel = 'Salesforce';
		requestDOBean.dueDate = debOrder.dueDate;
		requestDOBean.frequency = debOrder.frequency.toUpperCase();
		requestDOBean.notes = 'Debit Order';
		requestDOBean.overdue = false;
		requestDOBean.accountNumber = debOrder.refAccountNumber;
		requestDOBean.state = 'READY_TO_SUBMIT';
		requestDOBean.previousAccountNumber = previousAccountNumber;
		if (previousAccountType == '') {
			requestDOBean.previousAccountType = null;
		} else {
			requestDOBean.previousAccountType = previousAccountType.toUpperCase();
		}
		requestDOBean.previousInstitution = previousInstitution;
		requestDOBean.originEmployeeName = currentUser.FirstName;
		requestDOBean.originEmployeeSurname = currentUser.LastName;
		requestDOBean.originEmployeeNumber = currentUser.EmployeeNumber;
		requestDOBean.originSiteCode = currentUser.SiteCode__c;

		Switches_Resp_IB_v1 debitOrderResp = Switches_IH_v1.createSwitch(requestDOBean);
		String doSwitchId = debitOrderResp.x_links.self.href.substring(debitOrderResp.x_links.self.href.lastIndexOf('/') + 1);

		if (debOrder.serviceProvider != null) {
			try {
				SwitchingInstitutions_Resp_IB_v1.Item institutionResp = SwitchingInstitutions_IH_v1.getSwitchInstitutionByName(debOrder.serviceProvider);
				String serviceProviderLink = institutionResp.x_links.self.href.substring(institutionResp.x_links.self.href.lastIndexOf('/') + 1);
				String linkInstitutionSwitchDO = Switches_IH_v1.LinkInstitutionSwitch(doSwitchId, serviceProviderLink);
			} catch (Exception ex) {
				throw new AuraHandledException('Error linking Switching Institution: ' + ex.getMessage());
			}
		}
		try {
			String linkCustomerSwitchDO = Switches_IH_v1.LinkCustomerSwitch(doSwitchId, customerLink);
			Switches_Resp_IB_v1 switchTriggerDO = Switches_IH_v1.switchTrigger(doSwitchId, 'SUBMIT');
		} catch (Exception ex) {
				throw new AuraHandledException('Error Triggering Submit (Debit Order): ' + ex.getMessage());
		}
		//update SF data after callouts
		if (oppProduct.Switches__c == null) {
			oppProduct.Switches__c = doSwitchId + ',';
		} else {
			oppProduct.Switches__c = oppProduct.Switches__c + doSwitchId + ',';
		}
		if (!Test.isRunningTest()) {
			update oppProduct;
			if (debOrder.pendingDebitOrderId != null) {
				SwitchingHelper.updateSwitchSuccessful(debOrder.pendingDebitOrderId);
			}
		}
		return returnMessage;
	}

	/**
	 * @description getAccount
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param accId
	 * @return Account
	 **/
	public static Account getAccount(Id accId) {
		AccountsSelector aSelector = new AccountsSelector();
		return aSelector.selectById(accId);
	}

	/**
	 * @description getOpprLineItem
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param opportunityId
	 **/
	public static void getOpprLineItem(string opportunityId) {
		List<OpportunityLineItem> oppproducts = [
			SELECT Id, Product_Family__c, Policy_Number__c, Switches__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId
			WITH SECURITY_ENFORCED
		];

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Cheque' || o.Product_Family__c == 'Savings') {
				oppProduct = o;
				break;
			}
		}
	}

	/**
	 * @description getSwitchingInstitution
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param institutionId
	 * @return Switching_Institution__c
	 **/
	public static Switching_Institution__c getSwitchingInstitution(Id institutionId) {
		Switching_Institution__c institution = [SELECT Id, Name, Links__c FROM Switching_Institution__c WHERE Id = :institutionId WITH SECURITY_ENFORCED];
		return institution;
	}

	/**
	 * @description getSwitch
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchId
	 * @return SwitchSummary
	 **/
	@AuraEnabled
	public static SwitchSummary getSwitch(String switchId) {
		SwitchSummary summary = new SwitchSummary();
		//Get switch details
		Switches_Resp_IB_v1 switchResponse = Switches_IH_v1.getSwitch(switchId);
		summary.switchId = switchId;
		summary.switchType = switchResponse.switchType;

		//Get switch institution link
		SwitchingInstitutions_Resp_IB_v1.Item institutionResponse = SwitchingInstitutions_IH_v1.getSwitchInstitution(switchId);
		if (institutionResponse.exceptiondetails != null) {
			String returnMessage = institutionResponse.exceptiondetails.status + ': ' + institutionResponse.exceptiondetails.message;
			throw new AuraHandledException(returnMessage);
		}
		summary.institutionName = institutionResponse.name;
		summary.participation = institutionResponse.route;
		return summary;
	}

	/**
	 * @description SwitchSummary
	 */
	public class SwitchSummary {
		@AuraEnabled
		public String switchId;
		@AuraEnabled
		public String switchType;
		@AuraEnabled
		public String institutionName;
		@AuraEnabled
		public String participation;
	}

	/**
	 * @description getSwitchesFromOpprProduct
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param opportunityId
	 * @return String
	 **/
	@AuraEnabled
	public static String getSwitchesFromOpprProduct(String opportunityId) {
		String switchIds = '';
		Opportunity oppr = [
			SELECT Id, Name, (SELECT Id, Name, Switches__c FROM OpportunityLineItems)
			FROM Opportunity
			WHERE Id = :opportunityId
			WITH SECURITY_ENFORCED
		];
		List<OpportunityLineItem> opprProducts = oppr.opportunityLineItems;
		for (OpportunityLineItem opprProduct : opprProducts) {
			if (opprProduct.switches__c != null) {
				switchIds = opprProduct.switches__c;
			}
		}
		return switchIds;
	}

	/**
	 * @description getSwitchesLetter
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchId
	 * @return string
	 **/
	@AuraEnabled
	public static string getSwitchesLetter(string switchId) {
		String letter;
		//Get Switch Letter details
		try {
			letter = Switches_IH_v1.getSwitchLetter(switchId);
			letter = letter.substring(letter.IndexOf(',') + 1);
			return letter;
		} catch (Exception ex) {
			throw new AuraHandledException('Error getting Salary Letter: ' + ex.getMessage());
		}
	}

	/**
	 * @description saveDebitOrderEntries
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param debitOrder
	 * @param previousAccountNumber
	 * @param previousAccountType
	 * @param selectedBankName
	 * @param accountName
	 * @return string
	 **/
	@AuraEnabled
	public static string saveDebitOrderEntries(
		String debitOrder,
		String previousAccountNumber,
		String previousAccountType,
		string selectedBankName,
		string accountName
	) {
		return SwitchingHelper.createDebitOrderSwitchEntry(debitOrder, previousAccountNumber, previousAccountType, selectedBankName, accountName);
	}

	/**
	 * @description saveSalarySwitchEntry
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param switchingO
	 * @return string
	 **/
	@AuraEnabled
	public static string saveSalarySwitchEntry(Switching switchingO) {
		getOpprLineItem(switchingO.opportunityId);
		return SwitchingHelper.createSalarySwitchEntry(JSON.serialize(switchingO), oppProduct.Policy_Number__c);
	}

	/**
	 * @description getPendingSwitches
	 * @author André Pietersen (IQ Business) | 2021-06-17
	 * @param opportunityId
	 * @return List<Switching_Entry__c>
	 **/
	@AuraEnabled
	public static List<Switching_Entry__c> getPendingSwitches(string opportunityId) {
		try {
			List<Switching_Entry__c> switches = [
				SELECT
					Account_Number__c,
					Previous_Account_Number__c,
					Previous_Account_Type__c,
					Previous_Institution__c,
					Due_Date__c,
					Frequency__c,
					Notes__c,
					Overdue__c,
					Channel__c,
					State__c,
					Switch_Type__c,
					Origin_Employee_Name__c,
					Origin_Employee_Number__c,
					Origin_Employee_Surname__c,
					Origin_Site_Code__c,
					Amount__c,
					Previous_Account_Holder__c,
					Employer_Name__c,
					FixVar__c
				FROM Switching_Entry__c
				WHERE OpportunityId__c = :opportunityId AND Was_Switch_Successful__c = FALSE
				WITH SECURITY_ENFORCED
			];

			return switches;
		} catch (Exception e) {
			throw new AuraHandledException('Error Retrieving Switches: ' + e.getMessage());
		}
	}

	/**
	 * @description
	 * @author André Pietersen (IQ Business) | 2021-07-06
	 * @param debitOrderId
	 * @return string
	 **/
	@AuraEnabled
	public static string removePendingDebitOrder(string debitOrderId) {
		try {
			Switching_Entry__c debitOrder = [SELECT Id FROM Switching_Entry__c WHERE Id = :debitOrderId WITH SECURITY_ENFORCED];
			delete debitOrder;
			return 'SUCCESS';
		} catch (Exception e) {
			throw new AuraHandledException('Error Deleting Pending Debit Order: ' + e.getMessage());
		}
	}
}