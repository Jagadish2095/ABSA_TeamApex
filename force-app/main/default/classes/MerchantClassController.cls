/**
* Controller used by MerchantClass
*
* @author  Jason Quevauvilliers
* @version v1.0
* @since   2020-05-21
*/
public class MerchantClassController {

    /**
    * Method that returns the Id for the parent Opportunity Product
    *
    * @param opportunityIdP - Id of the opportunity
    */
    @AuraEnabled
    public static Id getOpportunityLineItemId(Id opportunityIdP) {

        OpportunityLineItemsSelector oppLineItemSelector = new OpportunityLineItemsSelector();
        List<OpportunityLineItem> oppLineItemList = oppLineItemSelector.selectParentLineItemsByOpportunityId(opportunityIdP, 1);

        if(oppLineItemList != null && oppLineItemList.size() > 0){
            return oppLineItemList[0].Id;
        }else{
            return null;
        }
    }
}