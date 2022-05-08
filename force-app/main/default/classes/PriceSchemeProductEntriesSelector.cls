/**
* Apex Enterprise Design Patterns
* Selector Layer for Price_Scheme_Product_Entry__c objects
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2020-04-21
*/
public class PriceSchemeProductEntriesSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Price_Scheme_Product_Entry__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Price_Scheme_Product_Entry__c.Id,
                Price_Scheme_Product_Entry__c.Name,
                Price_Scheme_Product_Entry__c.Product__c,
                Price_Scheme_Product_Entry__c.Price_Scheme__c
                };
                    }
    //MANDATORY ABSTRACT METHODS - END
    
    //INHERIT FROM BASE CLASS - START
    //get Price_Scheme_Product_Entry__c by id's 
    public List<Price_Scheme_Product_Entry__c> selectById(Set<Id> idSet) {
        return (List<Price_Scheme_Product_Entry__c>) selectSObjectsById(idSet);
    }
    //INHERIT FROM BASE CLASS - END

    /**
    * PJAIN: 20200421
    */
    public List<Price_Scheme_Product_Entry__c> selectByActiveTypeAccountProduct(Id productId, Id accountId, String priceSchemeType, Integer recordLimit) {
        
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Price_Scheme__c').
            selectField('Price_Scheme__r.Is_Negotiable__c').
            setCondition('Product__c =: pricingBean.productId' +
                         ' AND Price_Scheme__r.Type__c =: priceSchemeType' +
                         ' AND Price_Scheme__r.Account__c =: pricingBean.accountId' +
                         ' AND Price_Scheme__r.Start_Date__c <= TODAY' +
                         ' AND (Price_Scheme__r.End_Date__c >= TODAY' +
                         ' OR Price_Scheme__r.No_End_Date__c = true)').
            setLimit(recordLimit).
            toSOQL()
        );
    }

    /**
    * PJAIN: 20200422
    */
    public List<Price_Scheme_Product_Entry__c> selectByActiveTypeProduct(Id productId, String priceSchemeType, Integer recordLimit) {
        
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Price_Scheme__c').
            selectField('Price_Scheme__r.Is_Negotiable__c').
            setCondition('Product__c =: pricingBean.productId' +
                         ' AND Price_Scheme__r.Type__c =: priceSchemeType' +
                         ' AND Price_Scheme__r.Start_Date__c <= TODAY' +
                         ' AND (Price_Scheme__r.End_Date__c >= TODAY' +
                         ' OR Price_Scheme__r.No_End_Date__c = true)').
            setLimit(recordLimit).
            toSOQL()
        );
    }
}