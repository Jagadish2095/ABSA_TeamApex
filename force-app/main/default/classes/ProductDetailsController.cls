/** 
 * This is the Controller Class for the Credit Product Details
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-06-09
*/
public with sharing class ProductDetailsController {
    @AuraEnabled
    public static OpportunityLineItem getProductDetails(Id oppId){

        return new OpportunityLineItemsSelector().selectByOppId(oppId, 1);        
    }
    
    @AuraEnabled
    public static void viewProductDetails() {

    }
}