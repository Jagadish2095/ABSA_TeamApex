/**
 * @description InFlightApplicationDetailsController
 * @author: added comments by Jabulani
 */
public without sharing class InFlightApplicationDetailsController {
	/**
	 * @description InFlightApplication
	 */
	public class InFlightApplication {
		@AuraEnabled
		public string opportunityId;
		@AuraEnabled
		public string stage;
		@AuraEnabled
		public string products;
		@AuraEnabled
		public string createdDate;
		@AuraEnabled
		public string closeDate;
		@AuraEnabled
		public string name;
	}
	/**
	 * @description getInFlightApplications
	 * @return List<InFlightApplication>
	 * @param accountId
	 */
	@AuraEnabled
	public static List<InFlightApplication> getInFlightApplications(String accountId) {
		List<InFlightApplication> applications = new List<InFlightApplication>();

		List<Opportunity> opportunities = [
			SELECT Id, StageName, CreatedDate, CloseDate, Name
			FROM Opportunity
			WHERE AccountId = :accountId AND RecordTypeName__c = 'Retail' AND StageName IN ('Apply Product', 'Open')
			WITH SECURITY_ENFORCED
		];

		for (Opportunity opportunity : opportunities) {
			InFlightApplication inflightApplication = new InFlightApplication();
			inflightApplication.opportunityId = opportunity.Id;
			inflightApplication.stage = opportunity.StageName;
			inflightApplication.createdDate = String.valueof(opportunity.CreatedDate);
			inflightApplication.closeDate = String.valueof(opportunity.CloseDate);
			inflightApplication.name = opportunity.Name;
			inflightApplication.products = '';
			getLineItem(inflightApplication, opportunity.Id);
			applications.Add(inflightApplication);
		}
		return applications;
	}

	private static void getLineItem(InflightApplication inflightApplication, string opportunityId) {
		List<OpportunityLineItem> lineItems = [SELECT Name FROM OpportunityLineItem WHERE OpportunityId = :opportunityId WITH SECURITY_ENFORCED];
		for (OpportunityLineItem application : lineItems) {
			inflightApplication.products += inflightApplication.products == '' ? '' : ' - ';
			inflightApplication.products += application.Name + ' ';
		}
	}
}