/**
 * @description       : BranchChequeStandAloneController
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-09-01
 * @last modified by  : André Pietersen (IQ Business)
 * 1.1   2021-09-01   André Pietersen (IQ Business)   Multiple source of funds transfer added
 **/

public class BranchChequeStandAloneController {
	/**
	 * @description setupStandAloneCheque
	 * @author André Pietersen (IQ Business) | 2021-09-01
	 * @param recordId
	 * @param opportunityId
	 * @param flowName
	 * @return String
	 **/
	@AuraEnabled
	public static String setupStandAloneCheque(string recordId, string opportunityId, string flowName) {
		string oldOpportunityId = opportunityId;
		try {
			string productName = getProductName(opportunityId);
			string newOpportunityId = SalesProcessBase.createOpportunityForStandAloneProduct(recordId, '11032', productName, flowName);
			transferOpportunityData(oldOpportunityId, newOpportunityId);
			return newOpportunityId;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description getProductName
	 * @author André Pietersen (IQ Business) | 2021-09-01
	 * @param opportunityId
	 * @return string
	 **/
	public static string getProductName(string opportunityId) {
		string productName = '';
        OpportunityLineItem oppproduct = new OpportunityLineItem();
		List<OpportunityLineItem> oppproducts = [
			SELECT Id, Product_Family__c, Product2.Name
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId
			WITH SECURITY_ENFORCED
		];

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Cheque') {
				oppproduct = o;
				break;
			}
		}
		return productName = oppproduct.Product2.Name;
	}

	/**
	 * @description transferOpportunityData
	 * @author André Pietersen (IQ Business) | 2021-09-01
	 * @param oldOpportunityId
	 * @param newOpportunityId
	 **/
	public static void transferOpportunityData(string oldOpportunityId, string newOpportunityId) {
		Opportunity oldOpportunity = [SELECT Id, CIF_Number__c, CBPIndicator__c FROM Opportunity WHERE Id = :oldOpportunityId WITH SECURITY_ENFORCED];
		Opportunity newOpportunity = [SELECT Id FROM Opportunity WHERE Id = :newOpportunityId WITH SECURITY_ENFORCED];

		newOpportunity.CBPIndicator__c = oldOpportunity.CBPIndicator__c;
		update newOpportunity;

		Application__c oldApplication = [
			SELECT
				Source_of_Funds__c,
				Source_of_Funds_Savings__c,
				ROAQuestionnaire__c,
				Absa_Reward__c,
				Currently_Undergoing_Debt_Counselling__c,
				Credit_Life_Benefit__c,
				Electronic_Statements__c,
				Application_Correctness_Consent__c
			FROM Application__c
			WHERE Opportunity__c = :oldOpportunityId
            WITH SECURITY_ENFORCED
		];
		Application__c newApplication = [SELECT Id FROM Application__c WHERE Opportunity__c = :newOpportunityId WITH SECURITY_ENFORCED];

		newApplication.Source_of_Funds__c = oldApplication.Source_of_Funds__c;
		newApplication.Source_of_Funds_Savings__c = oldApplication.Source_of_Funds_Savings__c;
		newApplication.ROAQuestionnaire__c = oldApplication.ROAQuestionnaire__c;
		newApplication.Absa_Reward__c = oldApplication.Absa_Reward__c;
		newApplication.Currently_Undergoing_Debt_Counselling__c = oldApplication.Currently_Undergoing_Debt_Counselling__c;
		newApplication.Credit_Life_Benefit__c = oldApplication.Credit_Life_Benefit__c;
		newApplication.Electronic_Statements__c = oldApplication.Electronic_Statements__c;
		newApplication.Application_Correctness_Consent__c = oldApplication.Application_Correctness_Consent__c;
		update newApplication;
	}
}