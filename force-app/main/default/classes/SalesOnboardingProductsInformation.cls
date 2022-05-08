/**
 * @description Sales Onboarding Products Information
 * @author  Koketso Mpshane
 * @date    01/09/2021
 */
public class SalesOnboardingProductsInformation {
    
    /**
	 * @description get Sales Onboarding Product Type Mapping
	 * @return String
	 */
    @AuraEnabled
    public static String getProductTypesMapping() {
        
        StaticResource results = [Select Id, Body From StaticResource Where Name =: 'SalesOnboardingProductTypeMap' Limit 1];
        return results.Body.toString();
        
    }
    
    /**
 	* @description retriving Products Information from ROA Feature object
	* @param productCodes
	* @return String
 	*/
    @AuraEnabled
    public static String getProductsInformation(List<String> productCodes) {
        
        List<ROAFeature__c> roaFeatureList = [Select Id, Name, Product_Code__c, Montly_Fee__c, Recommended_Income__c, Pdf_Url__c From ROAFeature__c Where Product_Code__c in:productCodes Order By Name];
		return JSON.serialize(roaFeatureList);
        
    }

}