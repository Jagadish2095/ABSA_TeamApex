global class ApplicationProductCashflowBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'Select Id,Opportunity_Product_Id__c,Registered__c from Application_Product__c where Registered__c = false And Cash_Flow_Manager__c = true And Internet_Banking__c = true and Opportunity_Product_Id__c != null ';  
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext BC,List<Application_Product__c> applicationList) {
        List<Application_Product__c>lstOfUpdateApplication = new List<Application_Product__c>();
        List<String> cifKeyLst = new List<String>();
        List<Id> IdNumberlist = new List<Id>();
        
        for(Application_Product__c applicationProduct:applicationList){
            IdNumberlist.add(applicationProduct.Opportunity_Product_Id__c);}
        
        List<OpportunityLineItem>oppLineItems = new OpportunityLineItemsSelector().selectByListOfIds(IdNumberlist);
        Map<String,String> cifMap = new Map<String,String>();
        for(OpportunityLineItem oppLineLoop:oppLineItems){
            cifMap.put(oppLineLoop.Id, oppLineLoop.Opportunity.CIF_Number__c);}
        
        String cif;
        
        try {   
            for(Application_Product__c applicationProduct:applicationList){
                
                cif = cifMap.get(applicationProduct.Opportunity_Product_Id__c);
                Application_Product__c appProduct = applicationProduct;

                If(cif != null){
                    cifKeyLst.add(cif);
                    appProduct.Registered__c = true;
                    lstOfUpdateApplication.add(appProduct);
                    
                }}
            CVMopteddata_Req_IB_v1 requestBean = CVMopteddata_IU_v1.mapRequestFields(cifKeyLst);
            CVMopteddata_Res_IB_v1 responseBean = CVMopteddata_IH_v1.cvMopteddata(requestBean);
            
        } catch(DmlException ex){
            System.debug('Error getting application Product ' + ex);
            
        }
        update lstOfUpdateApplication; 
        
    }
    
    global void finish(Database.BatchableContext BC) {
        system.debug('Application Product CashflowBatch  for all new Opportunity is finished processing!');
        
    }
    
}