public with sharing class ProductOnboardingSigningInstructionsCtrl {
    @AuraEnabled
    public static OpportunityLineItem getOpportunityProduct(id oppId) {
        OpportunityLineItem oppLineItem;

        List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(oppId,1);
        if(oppLineItemList != null && oppLineItemList.size() > 0 && !oppLineItemList.isEmpty()){
            oppLineItem = oppLineItemList[0];
        }
        return oppLineItem;
    }
}