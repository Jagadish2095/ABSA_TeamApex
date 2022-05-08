/*
 * DocumentsMenuController
 * @author Almas Aleem
 * @Created 2020-11-13
 **/
public class DocumentsMenuController{
	
	public static Opportunity getOpportunity(Id opportunityId){
		return (new OpportunitiesSelector().selectByOpportunityId(opportunityId)).get(0);
	}

	
	@AuraEnabled
	public static List<Document__c> getAlDocuments(Id opportunityId){
        Opportunity opp = new OpportunitiesSelector().selectByOpportunityId(opportunityId).get(0);
		List<String> ecmItemTypes = new List<String>();
        List<Document__c> docList  = new DocumentsSelector().getOppDocuments(opp.Id, opp.accountId);
        Set<Id> casesIdSet = new Set<Id>();	
        List<Case> caseList = new CasesSelector().getCasesWithOppId(opp.Id);	
        if (!caseList.isEmpty() && caseList.size() > 0 && caseList != null){	
            for(Case cs : caseList){	
                casesIdSet.add(cs.Id);	
            }	
        }	
        if(casesIdSet.size() > 0){	
            List<Document__c> caseDocs = new DocumentsSelector().selectByCaseIds(casesIdSet);	
            docList.addAll(caseDocs);	
        }
		if (!docList.isEmpty() && docList.size() > 0 && docList != null){
			ecmItemTypes = Sys_Utilities_General.extractListValues(docList, 'ECM_Type__c');
        }
        List<Mandatory_Doc__mdt> mandatoryDocList = new MandatoryDocumentSelector().getMandatoryDocumentsWithEntitytype(opp.Entity_Type__c);
		if (!mandatoryDocList.isEmpty() && mandatoryDocList.size() > 0 && mandatoryDocList != null){
			for (Mandatory_Doc__mdt mdt : mandatoryDocList){
                String entType = mdt.ECM_Type__c;
                if (!ecmItemTypes.contains(entType)) {
                    Document__c doc = new Document__c();
                    doc.ECM_Type__c = entType;
                    doc.Opportunity__c = opportunityId;
                    docList.add(doc);
                }
			}
        }
        for (Document__c doc : docList) {
            system.debug('Doc ' + doc.Type__c + ' ' + doc.ECM_Type__c + ' ' + doc.Opportunity__c);
        }
		return docList;
	}
    
	 @AuraEnabled
    public static void dummyRefresh() {
        //this is a dummy refresh
    }
}