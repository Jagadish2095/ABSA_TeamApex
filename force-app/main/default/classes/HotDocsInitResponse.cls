/**
 * @description an object to model responses when initialising a HotDocs interaction.
 */
public class HotDocsInitResponse {
	
	@AuraEnabled public String url { get; set; }
	@AuraEnabled public String token { get; set; }
	@AuraEnabled public String answerSetId { get; set; }
	@AuraEnabled public String templateId { get; set; }
	
}