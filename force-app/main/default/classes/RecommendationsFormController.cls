/**
 * @description       : Investment RecommendationsFormController
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class RecommendationsFormController {
    /**
	 * @description check user access for Opportunity
	 *
	 * @param  oppId
	 * @return Map<String,Boolean>
	 */
    @AuraEnabled
    public static Map<String,Boolean> getUserAccess(Id oppId) {
        Map<String,Boolean> checkUserAccess = new Map<String,Boolean>();
        checkUserAccess.put('recordAccess', InvestmentOppUtility.getRecordAccess(oppId));
        checkUserAccess.put('recommendationAccess', FeatureManagement.checkPermission('Authority_for_Recommendation_Edit'));
        return checkUserAccess;
    }

    /**
	 * @description update opportunitylineitems
	 *
	 * @param  updateOppLineItems
	 */
    @AuraEnabled
    public static void updateOpportunityLineItem (String updateOppLineItems){
        OppLineItems oppLineItems = (OppLineItems)system.JSON.deserializeStrict(updateOppLineItems, OppLineItems.class);
        List<Sobject> objects = new List<Sobject>();
        objects.add(oppLineItems.appProduct);
        objects.add(oppLineItems.financialProduct);
        objects.add(oppLineItems.lineItem);
        objects.add(oppLineItems.opportunity);
        updateOppProductHistory(oppLineItems);
        update objects;
    }
    /**
	 * @description create opportunitylineitems
	 * @param oppId
	 * @param productId
     * @return Map<String, String>
	 */
    @AuraEnabled
    public static Map<String, String> saveOpportunityLineItem (Id oppId, Id productId){
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        Regulatory_Financial_Account__c rfa = new Regulatory_Financial_Account__c();
        Application_Product__c apc = new Application_Product__c();
        Map<String, String> idsMap = new Map<String, String>();
        List<OpportunityLineItem> lineItems = [Select Id From OpportunityLineItem WHERE OpportunityId =: oppId];
        Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
        Product2 selectedProduct = new ProductsSelector().selectById(productId);
        Boolean isUpdated = false;
        if(lineItems.size() > 0){
            delete lineItems;
            isUpdated = true;
        }
        opportunityLineItem.OpportunityId = oppId;
        opportunityLineItem.Product2Id = selectedProduct.Id;
        opportunityLineItem.TotalPrice = 0;
        opportunityLineItem.Quantity = 1;
        opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(productId);
        insert opportunityLineItem;
        idsMap.put('opportunityProductId',opportunityLineItem.Id);
        if(isUpdated){
            List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(oppId);
            List<Regulatory_Financial_Account__c> financialAcc= new RegulatoryFinancialAccountsSelector().selectByAccountId(opportunity.AccountId);
            if(appProducts.size()>0)apc.Id = appProducts[0].Id;
            if(financialAcc.size()>0)rfa.Id = financialAcc[0].Id;
        }
        apc.Opportunity_Product_Id__c = opportunityLineItem.Id;
        apc.Opportunity__c = oppId;
        apc.Product_Amount__c = null;
        apc.Premium_Type__c = '';
        apc.Reduction_Amount__c = null;
        apc.Discretionary_Money_Voluntary__c = '';
        apc.Term_Of_Investment__c = '';
        apc.Income_Source__c = '';
        apc.Ongoing_Fee_Percent__c = null;
        apc.Variable_Amount_1__c = null;
        apc.Upfront_Fee_Percent__c = null;
        upsert apc;
        idsMap.put('applicationId',apc.Id);
        rfa.Account__c = opportunity.AccountId;
        rfa.Product__c = opportunityLineItem.Id;
        rfa.Source_of_Funds__c = '';
        upsert rfa;
        idsMap.put('financialAccId',rfa.Id);
        List<Opportunity_Product_History__c> history = [SELECT Id FROM Opportunity_Product_History__c WHERE Opportunity__c=:oppId];
        if(history.size()>0) delete history;
        return idsMap;
    }
    /**
	 * @description create opportunitylineitems
	 * @param oppId
     * @return OppLineItems
	 */
    @AuraEnabled
    public static OppLineItems getOpportunityLineItem (Id oppId){
        Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
        List<Application_Product__c> appProducts = new ApplicationProductSelector().selectByOpportunityId(oppId);
        List<Regulatory_Financial_Account__c> financialAcc = new RegulatoryFinancialAccountsSelector().selectByAccountId(opportunity.AccountId);
        OpportunitylineItem oppLineItem = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
        OppLineItems items = new OppLineItems();
        items.appProduct = appProducts[0];
        items.financialProduct = financialAcc[0];
        items.lineItem = oppLineItem;
        items.opportunity = opportunity;
        return items;
    }

    private static void updateOppProductHistory(OppLineItems oppLineItems){
        if(oppLineItems.opportunity.Id != null){
            List<Opportunity_Product_History__c> oppProductHistory = new List<Opportunity_Product_History__c>();
            List<Opportunity_Product_History_Tracking__mdt> settings = [SELECT Data_Type__c,Field_Name__c,ObjectAPIName__c,Field_Label__c FROM Opportunity_Product_History_Tracking__mdt];
            List<Application_Product__c> oldAppProducts = new ApplicationProductSelector().selectByOpportunityId(oppLineItems.opportunity.Id);
            List<Regulatory_Financial_Account__c> oldFinancialAcc = new RegulatoryFinancialAccountsSelector().selectByAccountId(oppLineItems.opportunity.AccountId);
            OpportunitylineItem oldOppLineItem = new OpportunityLineItemsSelector().selectByOppId(oppLineItems.opportunity.Id, 1);
            for(Opportunity_Product_History_Tracking__mdt setting : settings){
                Object newValue;
                Object oldValue;
                Boolean isChanged = false;
                Opportunity_Product_History__c trackRecord = new Opportunity_Product_History__c();
                if(setting.ObjectAPIName__c == 'Application_Product__c'){
                    newValue = oppLineItems.appProduct.get(setting.Field_Name__c);
                    oldValue = oldAppProducts[0].get(setting.Field_Name__c);
                    if(newValue != oldValue){
                        isChanged = true;
                        mappedProductHistory(trackRecord,newValue,oldValue,oppLineItems);
                    }
                }
                else if(setting.ObjectAPIName__c == 'Regulatory_Financial_Account__c'){
                    newValue = oppLineItems.financialProduct.get(setting.Field_Name__c);
                    oldValue = oldFinancialAcc[0].get(setting.Field_Name__c);
                    if(newValue != oldValue){
                        isChanged = true;
                        mappedProductHistory(trackRecord,newValue,oldValue,oppLineItems);
                    }
                }
                else{
                    newValue = oppLineItems.lineItem.get(setting.Field_Name__c);
                    oldValue = oldOppLineItem.get(setting.Field_Name__c);
                    if(newValue != oldValue){
                        isChanged = true;
                        mappedProductHistory(trackRecord,newValue,oldValue,oppLineItems);
                    }
                }
                if(isChanged){
                    trackRecord.Data_Type__c = setting.Data_Type__c;
            		trackRecord.Field_Name__c = setting.Field_Label__c;
                    oppProductHistory.add(trackRecord);
                }
            }
            if(oppProductHistory.size()>0) insert oppProductHistory;
        }
    }
    private static Opportunity_Product_History__c mappedProductHistory(Opportunity_Product_History__c trackRecord,Object newValue,Object oldValue,OppLineItems oppLineItems){
        trackRecord.Modified_By__c = Userinfo.getUserId();
        trackRecord.Modified_Date_Time__c = system.now();
        trackRecord.New_Value__c = String.valueOf(newValue);
        trackRecord.Old_Value__c = String.valueOf(oldValue);
        trackRecord.Opportunity_Product__c = oppLineItems.lineItem.Id;
        trackRecord.Opportunity__c = oppLineItems.lineItem.OpportunityId;
        return trackRecord;
    }
    /**
     * @description : OppLineItems Wrapper
    **/
    public class OppLineItems{
        /** @description : appProduct **/
        @AuraEnabled public  Application_Product__c appProduct {set;get;}
        /** @description : financialProduct **/
        @AuraEnabled public  Regulatory_Financial_Account__c financialProduct {set;get;}
        /** @description : lineItem **/
        @AuraEnabled public  OpportunitylineItem lineItem {set;get;}
        /** @description : opportunity **/
        @AuraEnabled public  Opportunity opportunity {set;get;}
    }
}