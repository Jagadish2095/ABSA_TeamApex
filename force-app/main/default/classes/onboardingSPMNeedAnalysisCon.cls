/**
* @description Apex class for onboardingSPMNeedAnalysis Lightning Component
* @author  Diksha : Absa
* @version v1.0
* @since   2020-10-12
*/
public class onboardingSPMNeedAnalysisCon {
    /**
		* @description get Ids
		* @param oppId
		* @return List<IdsfromObj>
	*/
    @AuraEnabled
    public static List<IdsfromObj> getIds(String oppId){
        List<IdsfromObj> getIDsLst =new List<IdsfromObj>();
        Opportunity opp =new OpportunitiesSelector().selectByOpptId(oppId);
        List<OpportunityLineItem> oppproduct=[select id,name,Investment_Allocation__c,product2id,product2.Name from OpportunityLineItem where OpportunityId=:oppId AND product2.Name='SPM Equity Product'] ;
        List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List< Application_Product__c> appproduct = [select id, name from Application_Product__c where Opportunity__c=:oppId ];
        
        IdsfromObj idobj= new IdsfromObj();
        idobj.opplineitemId=oppproduct[0].id;
        idobj.appId=app[0].id ;
        idobj.appProductId=appproduct[0].id ;
        getIDsLst.add(idobj);
        
        return getIDsLst;
    }
    /** 
     * @description Wrapper Class To display Ids from different objects 
   */
    public class IdsfromObj {
        /** 
     		* @description opplineitem
   		*/
        @auraEnabled public String opplineitemId {get;set;} 
 		/** 
     		* @description appId
   		*/       
        @auraEnabled public String appId {get;set;}
         /** 
     		* @description appProductId
   		*/
        @auraEnabled public String appProductId {get;set;}
    } 
    /**
		* @description update app details
		* @param investmentamountR
		* @param cashaccruals
		* @param regularwithdrawalamountR
		* @param frequencyofpaymentrequired
		* @param otherspecialrequirements
		* @param opplineId
		* @param appproductId
		* @return string
	*/
    @AuraEnabled
    public static string updateDetails(string investmentamountR, string cashaccruals,string regularwithdrawalamountR,
                                       string frequencyofpaymentrequired, string otherspecialrequirements,
                                       Id opplineId,Id appproductId)
    {
        
        try{
            List<OpportunityLineItem> oppproduct=[select id,name,Investment_amount_R__c,Investment_Allocation__c,product2id,product2.Name from OpportunityLineItem where Id=:opplineId] ;
            system.debug('oppproduct'+oppproduct[0]);    
            List< Application_Product__c> appproduct = [select id, name,Cash_accruals__c,Regular_withdrawal_amount_R__c,Frequency_of_payment_required__c,Other_special_requirements__c from Application_Product__c where Id=:appproductId ];
            system.debug('appproduct'+appproduct[0]);   
            
            
            oppproduct[0].Investment_amount_R__c= investmentamountR;
            appproduct[0].Cash_accruals__c= cashaccruals;
            appproduct[0].Regular_withdrawal_amount_R__c= regularwithdrawalamountR;
            appproduct[0].Frequency_of_payment_required__c= frequencyofpaymentrequired;
            appproduct[0].Other_special_requirements__c= otherspecialrequirements;
            
            update oppproduct[0];
            Update appproduct[0];
            
            return 'SUCCESS';
        }catch(Exception e){
            system.debug(e.getMessage());
            return 'FAILURE';
        }
        
    }
    /**
		* @description get appPrdct details
		* @param oppId
		* @return Application_Product__c
	*/
      @AuraEnabled
    public static Application_Product__c getAppPrdctRec(Id oppId) {
        List<Application_Product__c> appPrdctRec= new ApplicationProductSelector().selectByOpportunityId(oppId);
        return appPrdctRec[0];    
        
    }   
     /**
		* @description get products
		* @param oppId
		* @return List<DisplayProducts>
	*/
    @AuraEnabled
    public static List<DisplayProducts> getProducts(String oppId){ 
        Opportunity opp =new OpportunitiesSelector().selectByOpptId(oppId);
        List<OpportunityLineItem> oppproduct=[select id,name,Investment_amount_R__c,Investment_Allocation__c,product2id,product2.Name from OpportunityLineItem where OpportunityId=:oppId] ;
        List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List< Application_Product__c> appproduct = [select id, name from Application_Product__c where Opportunity__c=:oppId ];
        List<Product_Product_Entry__c> SPMProductlst=[select id ,name ,Related_Product__r.name,Related_Product__r.id , Parent_Product__r.name  ,Related_Product__r.Risk_Profile__c, Geographical_Scope__c  from Product_Product_Entry__c where Parent_Product__r.Name='SPM Equity Product'];      
        List<DisplayProducts> addList = new List<DisplayProducts>();
        List<DisplayProducts> displayproductList=new List<DisplayProducts>();
        string Investvalue;
        Map<String ,string> opplineitemMap = new  Map<String ,string>();
        
        for(OpportunityLineItem opplines:oppproduct){
            opplineitemMap.put(opplines.product2.name ,opplines.Investment_Allocation__c);
            if(opplines.product2.name=='SPM Equity Product')
                Investvalue=opplines.Investment_amount_R__c; 
        }
        
        for(Product_Product_Entry__c prod:SPMProductlst){
            
            DisplayProducts dspr= new DisplayProducts();
            dspr.RiskProfile=prod.Related_Product__r.Risk_Profile__c;
            dspr.RelatedProductName=prod.Related_Product__r.name;
            dspr.ProductType = prod.Geographical_Scope__c;
            if(!oppproduct.isEmpty() && (opplineitemMap.containsKey(dspr.RelatedProductName))){
                dspr.InvestmentAllocation= opplineitemMap.get(dspr.RelatedProductName);
                if(opplineitemMap.get(dspr.RelatedProductName) != null && Investvalue!=null){
                    dspr.InvestmentAllocationAmt= (double.valueof(opplineitemMap.get(dspr.RelatedProductName))* double.valueof(Investvalue))/100;  
                }
            }
            
            else{
                dspr.InvestmentAllocation = null; 
                dspr.InvestmentAllocationAmt=0;  
            }
           displayproductList.add(dspr);
        }
        /*try{
            app[0].Portfolio_value__c =portfoliovalue;
            update app[0]; 
            system.debug('app'+app[0]); 
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }*/
        
        system.debug('displayproductList'+displayproductList.size()); 
        return  displayproductList ;
    }
    
    /** @description Wrapper Class To display product in Account Information
*/
    public class DisplayProducts{
		/** @description RiskProfile
		*/       
        @auraEnabled public String RiskProfile {get;set;}
        /** @description RelatedProductName
		*/ 
        @auraEnabled public String RelatedProductName {get;set;}
        /** @description InvestmentAllocation
		*/ 
        @auraEnabled public String InvestmentAllocation {get;set;} 
        /** @description InvestmentAllocationAmt
		*/ 
        @auraEnabled public double InvestmentAllocationAmt {get;set;}
        /** @description ProductType
		*/ 
        @auraEnabled public String ProductType {get;set;}
    } 
    /**
		* @description get accounts
		* @param recordId
		* @return Account
	*/
     @AuraEnabled
    public static Account getAccount(Id recordId){
        Account accounts = new AccountsSelector().selectByOpportunityId(recordId);
            System.debug('accounts>>>>>>' + accounts);
        return accounts;
    }
    /**
		* @description save portfolios
		* @param oppId
		* @param savedvalues
		* @return List<OpportunityLineItem>
	*/
    @AuraEnabled
    public static List<OpportunityLineItem> savePortfolios(String oppId, string savedvalues){
        system.debug('savedvalues'+savedvalues); // [{"InvestmentAllocation":"19","id":"row-0"},{"InvestmentAllocation":"30","id":"row-1"}]
        List<SPMInvestmentValue>  sPMInvestmentValuelst = (List<SPMInvestmentValue>)JSON.deserialize(savedvalues, List<SPMInvestmentValue>.class);
        List<OpportunityLineItem> oppproduct=[select id,name,Investment_amount_R__c,Investment_Allocation__c,product2id,product2.Name from OpportunityLineItem where OpportunityId=:oppId] ;
        String parentOppId = oppproduct.isEmpty() ? null : oppproduct[0].Id;
		System.debug('parentOppId: ' + parentOppId);
        System.debug('oppproduct existing: ' + oppproduct);
        Map<String ,opportunityLineItem> opplineitemMap = new  Map<String ,opportunityLineItem>();
        for(OpportunityLineItem opplines:oppproduct){
            opplineitemMap.put(opplines.product2id  ,opplines);
        }
        
        
        List<OpportunityLineItem> listOLI = new List<OpportunityLineItem>();
        List<Product_Product_Entry__c> SPMProductlst=[select id ,name ,Related_Product__r.id ,Related_Product__r.name , Parent_Product__r.name  ,Related_Product__r.Risk_Profile__c from Product_Product_Entry__c where Parent_Product__r.Name='SPM Equity Product'];      
        OpportunityLineItem opportunityLineItem;
        System.debug('SPMProductlst Product_Product_Entry__c: ' + SPMProductlst);
        System.debug('opplineitemMap: ' + opplineitemMap);
        for (SPMInvestmentValue spmvalue :sPMInvestmentValuelst ){
            string stringRowCount = spmvalue.id.substringAfterLast('-');        
            string spmProductId = SPMProductlst[Integer.valueof(stringRowCount)].Related_Product__r.id ;
            
            if(!oppproduct.isEmpty() && (opplineitemMap.containsKey(spmProductId))){
                opportunityLineItem = opplineitemMap.get(spmProductId);
                System.debug('spmProductId opportunityLineItem: ' + opportunityLineItem);
                opportunityLineItem.Investment_Allocation__c= spmvalue.InvestmentAllocation; 
                if(opportunityLineItem.id != opplineitemMap.get(spmProductId).id ){
                    System.debug('IDs are not the same');
                    opportunityLineItem = new OpportunityLineItem();
                    opportunityLineItem.OpportunityId = oppId;
                    opportunityLineItem.Product2Id = spmProductId; 
                    opportunityLineItem.TotalPrice = 0;
                    opportunityLineItem.Quantity = 1;
                    opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(spmProductId);
                    opportunityLineItem.Investment_Allocation__c=spmvalue.InvestmentAllocation;
                    opportunityLineItem.Parent_Opportunity_Line_Item_Id__c  = parentOppId;
                    listOLI.add(opportunityLineItem);   
                } 
                listOLI.add(opportunityLineItem);  
            }
            else{
                System.debug('in else');
                opportunityLineItem = new OpportunityLineItem();
                opportunityLineItem.OpportunityId = oppId;
                opportunityLineItem.Product2Id = spmProductId; 
                opportunityLineItem.TotalPrice = 0;
                opportunityLineItem.Quantity = 1;
                opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(spmProductId);
                opportunityLineItem.Investment_Allocation__c=spmvalue.InvestmentAllocation;
                opportunityLineItem.Parent_Opportunity_Line_Item_Id__c  = parentOppId;
                listOLI.add(opportunityLineItem);  
            }
        }
        try{
        upsert listOLI;
     
        }
         catch(Exception e){
            system.debug(e.getMessage());
        }
        return listOLI;   
 
    } 
    
    
    
    /** @description Wrapper Class To Map the response from json
*/
    public class SPMInvestmentValue{
        /** @description id
		*/
        @auraEnabled public String id {get;set;}
        /** @description InvestmentAllocation
		*/
        @auraEnabled public String InvestmentAllocation{get;set;}
    } 
}