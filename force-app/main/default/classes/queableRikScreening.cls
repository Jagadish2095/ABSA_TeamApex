/**
 * @description Queuable Class for Risk Rating
 * @author Masechaba Maseli
 */
public class queableRikScreening implements Queueable, Database.AllowsCallouts {
	private String opportunityId;
	private String accountRecordType;
	private String cifCheck;
	private String accountId;

   /**
	 * @description 
	 * @param opportunityId
    * @param accountRecordType
    * @param cifCheck
    * @param accountId
	 */
	public queableRikScreening(String opportunityId, String accountRecordType, String cifCheck, String accountId) {
		this.opportunityId = opportunityId;
		this.accountRecordType = accountRecordType;
		this.cifCheck = cifCheck;
		this.accountId = accountId;
	}

   /**
	 * @description 
	 * @param context
	 */
	public void execute(QueueableContext context) {
		OnboardingRiskRatingController.saveRikInfo(opportunityId);

		if (!Test.isRunningTest()) {
			System.enqueueJob(new queableCallToCreateCIF(opportunityId, accountRecordType, cifCheck, accountId));
		}
	}
}