/*
 * Controller for Credit Case Fullfillment Details
 * @author  Almas Aleem: Absa
 * @version v1.0
 * @since   2020-06-26
 *
 * @update Englarmerdge Mongwe
 * @dateUpdated 2020-08-24
 * Changed Application_Product_Credit__c to Application_Product__c object
*/

public class CreditCaseFulfillmentController {
    /*
     * return product specific details for
     * Application Product Object
     *
    */
    
     @auraEnabled
    public static  List<String> getProductFields(String productname) {
		/*
		* query custom metadata Credit_Case_Field__mdt
		* to get Application_Product Fields
		* based on product
		*
		*/
		system.debug('productname---'+productname);
		Credit_Case_Field__mdt productField = [SELECT MasterLabel,Field_Names__c,Product_Name__c FROM Credit_Case_Field__mdt where Product_Name__c=:productname];
		if(productField !=null) {
		List <String> fieldnames = productField.Field_Names__c.split(',');
			system.debug('fieldnames---'+fieldnames);
			return fieldnames;
		}

		return null;
    }
      /* @auraEnabled
    public static  ProductDataWrapper getOverdraftProductFields(Id appProdId) {
		/*
		* query custom metadata Credit_Case_Field__mdt
		* to get Application_Product Fields
		* based on product
		*
		*/

		/*Credit_Case_Field__mdt productField = [SELECT MasterLabel,Field_Names__c,Product_Name__c FROM Credit_Case_Field__mdt where Product_Name__c=:productname];
		if(productField !=null) {
		List <String> fieldnames = productField.Field_Names__c.split(',');
			system.debug('fieldnames---'+fieldnames);
			return fieldnames;
		}*/

       /*  Application_Product__c product = [SELECT Id, Product_Name__c,Action_Required__c,CMS_ACB_Limit__c,
                                           Overdraft_Type__c,Review_Only__c,Overdraft_Limit__c,Credit_life_required__c,Account_Number__c,
                                           Domicible_Branch_Code__c,Initiation_Fee__c,Expiry_Date__c,Debit_interest_Type__c,Review_Date__c,
                                           Interest_Type__c,Regular_Payday__c,Margin__c,Scoring_required__c,Effective_Rate__c,
                                           Economic_Empowerment_Classification__c,
                                           Application_Product_Parent__c, Temp_Account_Number__c,
                                                   Application_Product_Parent__r.Product_Name__c,Application_Product_parent__r.Account_Number__c,
                                                   toLabel(Application_Product_Parent__r.Product_Type__c), Application_Product_Parent__r.Temp_Account_Number__c,
                                                   Application_Product_Parent__r.Product_State__c,
                                                   Application_Product_Parent__r.System_Decision__c,
                                                   Application_Product_Parent__r.Final_Decision__c,
                                                   Application_Product_Parent__r.Product_Status__c,
                                                   Opportunity__c
                                                   FROM Application_Product__c
                                                   WHERE  Application_Product_Parent__c =: appProdId ]; //
        //System.debug('appPrdList' + appPrdList);
        ProductDataWrapper RequestedApplicationProduct = new ProductDataWrapper();
        //for(Application_Product__c product : appPrdList){
            
            ProductDataWrapper productData = new ProductDataWrapper();
            
            String nameConcat = product.Application_Product_Parent__r.Product_Name__c + ' ' + product.Product_Name__c;
            productData.productName = nameConcat;
            productData.productType = product.Application_Product_Parent__r.Product_Type__c;
            productData.productAccountNumber = ''+ product.Application_Product_Parent__r.Account_Number__c; //  product.Temp_Account_Number__c Need to check 
            productData.productAmount = product.Product_Amount__c;     
            productData.systemDecision = product.Application_Product_Parent__r.System_Decision__c;    
            productData.finalDecision = product.Application_Product_Parent__r.Final_Decision__c;     
            productData.productStatus = product.Application_Product_Parent__r.Product_Status__c;    
            productData.productState = product.Application_Product_Parent__r.Product_State__c; 
            productData.Id = product.Application_Product_Parent__c; // Parent Id 
             productData.ActionRequired =  product.Action_Required__c;
         productData.CMSACBLimit =product.CMS_ACB_Limit__c  ;
         productData.OverdraftType =''+product.Overdraft_Type__c;
        productData.ReviewOnly=product.Review_Only__c;
         productData.OverdraftLimit = ''+product.Product_Amount__c;
         productData.Creditliferequired = product.Credit_life_required__c;
         productData.DomicibleBranchCode = '' +product.Domicible_Branch_Code__c;
         productData.InitiationFee = ''+product.Initiation_Fee__c;
        productData.ExpiryDate = '' +product.Expiry_Date__c;
        productData.DebitinterestType= '' +product.Debit_interest_Type__c;
         productData.ReviewDate=''+product.Review_Date__c;
         productData.InterestType= ''+product.Interest_Type__c;
         productData.RegularPayday = ''+product.Regular_Payday__c;
         productData.Margin =''+product.Margin__c;
        productData.Scoringrequired =''+product.Scoring_required__c;
		productData.EffectiveRate =''+product.Effective_Rate__c;
         productData.EconomicEmpowermentClassification=''+product.Economic_Empowerment_Classification__c;
           
            
            
           RequestedApplicationProduct = productData; 
        //}
        
        System.debug('WrapperAppProd : ' + RequestedApplicationProduct);
        
        return RequestedApplicationProduct;
        
        
		return null; 

    }
    
   //Custom wrapper class to consolidate product Cheque and OverDraft data
    public class ProductDataWrapper{
        @AuraEnabled public String Id;
        @AuraEnabled public String productName;
        @AuraEnabled public String productType;
        @AuraEnabled public String productAccountNumber;
        @AuraEnabled public Decimal productAmount;
        @AuraEnabled public String systemDecision;
        @AuraEnabled public String finalDecision;
        @AuraEnabled public String productStatus;
        @AuraEnabled public String productState;
         @AuraEnabled public String ActionRequired;
         @AuraEnabled public Boolean CMSACBLimit;
         @AuraEnabled public String OverdraftType;
         @AuraEnabled public Boolean ReviewOnly;
         @AuraEnabled public String OverdraftLimit;
         @AuraEnabled public Boolean Creditliferequired;
         @AuraEnabled public String DomicibleBranchCode;
         @AuraEnabled public String InitiationFee;
         @AuraEnabled public String ExpiryDate;
         @AuraEnabled public String DebitinterestType;
         @AuraEnabled public String ReviewDate;
         @AuraEnabled public String InterestType;
         @AuraEnabled public String RegularPayday;
         @AuraEnabled public String Margin;
         @AuraEnabled public String Scoringrequired;
         @AuraEnabled public String EffectiveRate;
         @AuraEnabled public String EconomicEmpowermentClassification;
    }*/
}