/*
* Apex class for Covidfulfilment Lightning Component
*
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2020-11-23
*
*/
public class CovidFulfilmentController {
    
    @auraEnabled
    public static void createCasefulfilment(Id oppId){
        
        //create case 
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Credit FulFillment').getRecordTypeId();
        String apcId='';
        //query service group type and servie type
        /*Service_Type__c serviceType = [Select Id,Name From Service_Type__c where Name =:'Credit Fulfilment'];
        Service_Group__c serviceGroup = [Select Id,Name From Service_Group__c where Name=:'Business Banking'];*/
        
        Opportunity opp =  new OpportunitiesSelector().selectByOppId(oppId) ; 
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        
        List<Application_Product__c> appProdCredList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        
        if(appProdCredList.size() > 0 && appProdCredList != null) {
            apcId =''+appProdCredList[0].Id;
        }
        Case fulfilmentcase = new Case();
        fulfilmentcase.RecordTypeId = caseRecordTypeId;
        fulfilmentcase.Application_Product_Id__c =apcId;
        fulfilmentcase.Status ='New';
        fulfilmentCase.Opportunity__c = oppId;
        fulfilmentCase.Product__c='COVID-19 Bank Guarantee';
        fulfilmentCase.Subject='COVID-19 Bank Guarantee FulFilment';
        fulfilmentcase.Relationship_Banker__c = opp.OwnerId;
        fulfilmentCase.Account_Number__c = appList[0].Stock_Number__c;
        fulfilmentcase.AccountId = opp.AccountId;
       /* fulfilmentCase.Type__c ='Credit FulFillment';
        fulfilmentCase.Type ='Credit FulFillment';
        //add service group and service type
        //
        fulfilmentCase.sd_Service_Type_Id__c= serviceType.Id;
        fulfilmentCase.sd_Service_Group_Type_Id__c =serviceGroup.Id;
        fulfilmentCase.Service_Type_Search__c =serviceType.Id;
        fulfilmentCase.Service_Group_Search__c=serviceGroup.Id;*/
        
        
        //update opp stage
        
        opp.StageName = 'Submit For FulFilment';
        
        try{
            
            insert fulfilmentcase;
            update opp;
        }catch (Exception exp){
            system.debug('Exception---'+exp.getMessage());
        }
        
        
    }
    
    @auraEnabled
    public static List<CaseWrapper> fetchcaseHistory(Id oppId){
        List<CaseWrapper> casewrapperList = new List<CaseWrapper>();
        String apcId;
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Application_Product__c> appProdCredList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        
        if(appProdCredList.size() > 0 && appProdCredList != null) {
            apcId =''+appProdCredList[0].Id;
        }
        //read case history and make wrapper class 
        String query = 'SELECT Case.CaseNumber,Case.Account_Number__c,Case.Requested_Amount__c,Case.Status,CreatedDate,CreatedById, OldValue, NewValue, Field  FROM CaseHistory where Case.Application_Product_Id__c='+'\''+apcId+'\'' ;
        system.debug('query---'+query);
        
        List<CaseHistory> historyList = retrieveCaseHistory(null,apcId);
            //Database.query(query); //change to selector
        
        for(CaseHistory hisRec : historyList){
            if(hisRec.Field.equalsIgnoreCase('created')){
                CaseWrapper caseWrap = new CaseWrapper();
                caseWrap.product='Bank Guarantee';
                caseWrap.productType='COVID-19 Bank Guarantee';
                caseWrap.accountNumber = hisRec.Case.Account_Number__c == null ? '#####':hisRec.Case.Account_Number__c;
                caseWrap.amount =0.0;//hisRec.Case.Requested_Amount__c;
                caseWrap.Status = ''+hisRec.Case.Status;
                caseWrap.caseNum = hisRec.Case.CaseNumber;
                caseWrap.lastUpdated=hisRec.CreatedDate;
                
                casewrapperList.add(caseWrap);
            }
            
            if(hisRec.Field.equalsIgnoreCase('Status')){
               
                CaseWrapper caseWrap = new CaseWrapper();
                caseWrap.product='Bank Guarantee';
                caseWrap.productType='COVID-19 Bank Guarantee';
                caseWrap.accountNumber = hisRec.Case.Account_Number__c == null ? '####':hisRec.Case.Account_Number__c;
                caseWrap.amount =0.0;//hisRec.Case.Requested_Amount__c;
                caseWrap.Status = ''+hisRec.NewValue;
                caseWrap.caseNum = hisRec.Case.CaseNumber;
                caseWrap.lastUpdated=hisRec.CreatedDate;
                
                casewrapperList.add(caseWrap);
            }
            
        }
        
        return casewrapperList;
    }
    
    public class CaseWrapper {
        @auraEnabled public string product;
        @auraEnabled public string productType;
        @auraEnabled public string accountNumber;
        @auraEnabled public Decimal amount;
        @auraEnabled public string caseNum;
        @auraEnabled public string Status;
        @auraEnabled public DateTime lastUpdated;
        
        
        public CaseWrapper(){
            this.product ='';
            this.productType = '';
            this.accountNumber= '';
            this.amount = 0;
            this.caseNum='';
            this.Status='';
            this.lastUpdated=System.now();
        }
    }
    
 public static List<CaseHistory> retrieveCaseHistory(Id caseId,Id apcId){
     List<CaseHistory> csh;
     if(Test.isRunningTest()){  //if TEST, create dummy AccountHistory
         csh = new List<CaseHistory>{}; //OldValue, NewValue not writeable
         csh.add(new CaseHistory(CaseId=caseId, Field='Status'));
     }
     else 
     {
        String query = 'SELECT Case.CaseNumber,Case.Account_Number__c,Case.Requested_Amount__c,Case.Status,CreatedDate,CreatedById, OldValue, NewValue, Field  FROM CaseHistory where Case.Application_Product_Id__c='+'\''+apcId+'\'' ;
        system.debug('query---'+query);
        
        csh = Database.query(query); //change to selector  
     }

     return csh;
    }
}