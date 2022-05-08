public class WWYTDTDController {
    
    public static Id createOpportunityWithLineItemsCAF(Id accountId, String productCode, String productType, String contextRef) {
        
        //Todo: Below process needs to cater for Application_Product_CAF__c object instead of the default Application_Product__c object
        Map<String, String> oppApplicationMap = SalesProcessBase.createOpportunityWithLineItems(accountId, productCode, productType, contextRef);
        
        return Id.valueOf(oppApplicationMap.get('opportunityId'));
        
    }

}