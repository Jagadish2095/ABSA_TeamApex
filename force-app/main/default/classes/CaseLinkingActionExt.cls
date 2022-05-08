public class CaseLinkingActionExt {
    
    @AuraEnabled
    public static list<Case> getRelatedCase(String parentCaseId){ 
        
        List<Case> lstCases = new list<Case>();

        Set<Id> idSet = new Set<Id>();
        idSet.add(parentCaseId);
        
        List<Case> parentCase = new CasesSelector().selectByIdWithEmailFields(idSet, 1);
        
        if(parentCase.size() > 0){
            
            lstCases = new CasesSelector().selectByAccountIdAndRelatedEmails(parentCase[0].AccountId, 
                                                                             parentCase[0].SuppliedEmail,  
                                                                             parentCase[0].Email__c, 
                                                                             parentCase[0].Email_From_Address__c,
                                                                             parentCaseId,
                                                                             10 );
        }
 
        return lstCases;
    }
    
    @AuraEnabled
    public static list<Case> searchCases(String searchCaseNumber, String searchSubject, String searchFrom){
        
        List<Case> relatedCases = new list<Case>();
        
        String  sql = 'Select Id, Subject, Status, CaseNumber,Owner.Name,Type__c, Subtype__c,' + 
            'Description, Contact.Name, Contact.Email, ' + 
            'IsClosed, CreatedDate, Account.Name ' +
            'From Case Where IsClosed = false';
        
            if( String.isNotBlank(searchCaseNumber) ){
                sql+= ' AND CaseNumber like \'%' + searchCaseNumber + '%\'';
            }else{
                if(String.isNotBlank(searchSubject) && String.isNotBlank(searchFrom)){
            		sql+= ' AND (Subject like \'%' + searchSubject + '%\' AND Email_From_Address__c like \'%' + searchFrom + '%\')';
                }else{
                    if( String.isNotBlank(searchSubject) ){
                         sql+= ' AND Subject like \'%' + searchSubject + '%\'';
                    }
                    if( String.isNotBlank(searchFrom) ){
                         sql+= ' AND Email_From_Address__c like \'%' + searchFrom + '%\'';
                    }
                } 
            }
        
        sql+= ' Order by CreatedDate Desc Limit 10';
        
        relatedCases = Database.query(sql);
 
        return relatedCases;
    }
    
    @AuraEnabled
    public static void linkEmailToCase(String selectedCaseId, String linkCaseId){
        List<Attachment> lstAttachments = new list<Attachment>();
        List<FeedItem> feedList = new list<FeedItem>();

        Set<Id> selectedCaseIdSet = new Set<Id>();
        selectedCaseIdSet.add(selectedCaseId);
        List<Case> parentCase = new CasesSelector().selectByIdWithClassification(selectedCaseIdSet, 1);
 
        Set<Id> linkCaseIdSet = new Set<Id>();
        LinkCaseIdSet.add(linkCaseId);
        List<Case> childCase = new CasesSelector().selectByIdWithClassification(linkCaseIdSet, 1);
            
            
        if(parentCase.size() > 0 && childCase.size() > 0){
            
            childCase[0].Status = 'Closed';
            childCase[0].ParentId = parentCase[0].Id;
            childCase[0].Type__c = parentCase[0].Type__c;
            childCase[0].Subtype__c = parentCase[0].Subtype__c;
            childCase[0].sd_Email_Template_Case_Closure__c = null;
            childCase[0].Case_Linked__c = true;
            
            try{
                
                update childCase[0];
                
            }catch(DMLException ex){
                System.debug(ex.getMessage());
            }
            //disabled below to the keep current case owner
            /*parentCase[0].OwnerId = UserInfo.getUserId();
            
            try{
                update parentCase[0];
            }catch(DMLException ex){
                System.debug(ex.getMessage());
            }*/
        }
    }
   
}