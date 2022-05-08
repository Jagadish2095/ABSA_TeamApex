public class GenerateIndemnityFormROTController {
    
    public Account accountRecord {get;set;}
    public Case caseRecord {get;set;}
    public List<RestrictionGroupWrapper> resWrap {get;set;}
    
    public GenerateIndemnityFormROTController(){
        
        Id caseID = apexpages.currentpage().getparameters().get('id');
        //String caseId = '5009E00000FDJbOQAX';
        caseRecord = [SELECT Id, AccountId, OwnerId, CaseNumber FROM Case WHERE Id = :caseID LIMIT 1];
        resWrap = new List<RestrictionGroupWrapper>();
        if(string.isNotBlank(caseRecord.Id)){
            
            accountRecord = [Select Id,Name,ID_Number__pc,Registration_Number__c from Account where Id=:caseRecord.AccountId];
            
            for(RestrictionGroup__c resGrp : [
                SELECT Id,Name,GroupID__c,Restriction_ID__c,Case__c,EffectiveStartDate__c,EffectiveEndDate__c,Status__c,Description__c, 
                	(select id,Name,Status__c,EffectiveStartDate__c, EffectiveEndDate__c,RestrictionGroupId__c,CustomerKey__c from RestrictionGroupCustomers__r WHERE Status__c !='Deleted'),
                	(select id,Name,Status__c,EffectiveStartDate__c, EffectiveEndDate__c,RestrictionGroupId__c,Excluded_Account__c,AccountNumber__c from RestrictionGroupAccount__r WHERE Status__c !='Deleted'),
                	(select id,Name,Status__c,Effective_Start_Date__c, Effective_End_Date__c,Restriction_Group_ID__c,Description__c from RestrictionGroupTransactionTypes__r WHERE Status__c !='Deleted')
                FROM RestrictionGroup__c
                where Case__c =: caseId
                and Status__c !='Deleted'
            ]) {
                RestrictionGroupWrapper objWrap = new RestrictionGroupWrapper();
                objWrap.groupName = resGrp.Description__c;
                objWrap.customers = resGrp.RestrictionGroupCustomers__r.size()>0 ? resGrp.RestrictionGroupCustomers__r : new List<RestrictionGroupCustomer__c>();
                objWrap.transactionTypes = resGrp.RestrictionGroupTransactionTypes__r.size()>0 ? resGrp.RestrictionGroupTransactionTypes__r : new List<RestrictionGroupTransactionType__c>();
                
                if(resGrp.RestrictionGroupAccount__r.size()>0){
                    
                    List<RestrictionGroupAccount__c> excluded = new List<RestrictionGroupAccount__c>();
                    List<RestrictionGroupAccount__c> included = new List<RestrictionGroupAccount__c>();
                    for(RestrictionGroupAccount__c obj : resGrp.RestrictionGroupAccount__r){
                        if(obj.Excluded_Account__c){
                            excluded.add(obj);
                        }
                        else{
                            included.add(obj);
                        }
                    }
                    objWrap.includedAccounts = included;
                    objWrap.excludedAccounts = excluded;
                }
                else{
                    objWrap.includedAccounts = new List<RestrictionGroupAccount__c>();
                    objWrap.excludedAccounts = new List<RestrictionGroupAccount__c>();
                }
                resWrap.add(objWrap);
            }
            system.debug('resWrap=='+resWrap[0].customers);
            system.debug('resWrap==1'+resWrap[0].transactionTypes);
            system.debug('resWrap==2'+resWrap[0].includedAccounts);
            system.debug('resWrap==3'+resWrap[0].excludedAccounts);
        }
    }
    
    public class RestrictionGroupWrapper {
        
        public String groupName {get; set;}
        public List<RestrictionGroupCustomer__c> customers {get; set;}
        public List<RestrictionGroupAccount__c> excludedAccounts {get; set;}
        public List<RestrictionGroupAccount__c> includedAccounts {get; set;}
        public List<RestrictionGroupTransactionType__c> transactionTypes {get; set;}
    }
}