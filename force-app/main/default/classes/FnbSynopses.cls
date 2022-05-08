/**
 * @description       : FnbSynopses
 * @author            : Jabulani Mashia
 * @last modified on  : 2021-08-11
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-15   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-11   André Pietersen (IQ Business)   Pricing expansion
 **/
public class FnbSynopses{
	/**
	 * @description getProductDetails
	 * @author André Pietersen (IQ Business) | 2021-07-15
	 * @param Products
	 * @return List<FnbSynopsesWrapper.Product>
	 **/
	@AuraEnabled
	public static List<FnbSynopsesWrapper.Product> getProductDetails(String Products){
		List<FnbSynopsesWrapper.Product> returnProducts = new List<FnbSynopsesWrapper.Product>();
		List<ROAProduct__c> productsList = [SELECT ProductId__c, Description__c, Code__c, PackageChargeOption__c, Synopsis__c
		                                    FROM ROAProduct__c
		                                    WHERE ProductId__c IN :Products.split(',')];
		List<String> productsListDescription = new List<String>();
		for (ROAProduct__c product : productsList){
			productsListDescription.add(product.Description__c);
		}
		List<String> productsListCodes = new List<String>();
		for (ROAProduct__c product : productsList){
			productsListCodes.add(product.Code__c);
		}

		List<ROAFeature__c> roaFeatures = [SELECT Name, Recommended_Income__c, Montly_Fee__c, Cheque_Monthly_Fee__c, Credit_Card_Monthly_Account_Fee__c, Credit_Card_Facility_Fee__c, Pdf_Url__c
		                                   FROM ROAFeature__c
		                                   WHERE Name IN :productsListDescription];

		Map<String, Boolean> availabilityMap = areProductsAvailableForSelection(productsListCodes);

		if (productsList != null){
			for (ROAProduct__c roaProduct : productsList){
				FnbSynopsesWrapper.Product productWrapper = new FnbSynopsesWrapper.Product();
				if (roaFeatures.size() > 0){
					for (ROAFeature__c roaFeature : roaFeatures){
						if (roaFeature.Name == roaProduct.Description__c){
							productWrapper.RecommendedIncome = roaFeature.Recommended_Income__c;
							productWrapper.MonthlyFee = roaFeature.Montly_Fee__c;
							productWrapper.ChequeFee = roaFeature.Cheque_Monthly_Fee__c;
							productWrapper.CreditCardFee = roaFeature.Credit_Card_Monthly_Account_Fee__c;
							productWrapper.FacilityFee = roaFeature.Credit_Card_Facility_Fee__c;
							productWrapper.PdfUrl = roaFeature.Pdf_Url__c;
							break;
						}
					}
				} else{
					productWrapper.RecommendedIncome = 'No ROA Feature Information found.';
				}

				List<String> codeAndChargeOption = roaProduct.Code__c.split(' ');
				if (codeAndChargeOption[0] != null){
					productWrapper.Code = codeAndChargeOption[0];
				}

				if (roaProduct.PackageChargeOption__c != null){
					productWrapper.PackageChargeOption = roaProduct.PackageChargeOption__c;
				} else if (codeAndChargeOption.size() > 1){
					productWrapper.PackageChargeOption = codeAndChargeOption[1];
				}

				productWrapper.IsAvailableForSelection = availabilityMap.get(roaProduct.Code__c);
				productWrapper.Description = roaProduct.Description__c;
				productWrapper.ProductId = roaProduct.ProductId__c;
				productWrapper.Synopsis = roaProduct.Synopsis__c;
				productWrapper.IsSelected = false;
				returnProducts.add(productWrapper);

			}
		}
		return returnProducts;
	}

	private static Map<String, Boolean> areProductsAvailableForSelection(List<String> productsListCodes){

		List<Product_Product_Entry__c> relatedProducts = [SELECT Related_Product__c, Parent_Product__r.ProductCode, Related_Product__r.ProductCode
		                                                 FROM Product_Product_Entry__c
		                                                 WHERE Parent_Product__r.ProductCode IN :productsListCodes
														 AND Related_Product__c IN (SELECT Product2Id FROM PricebookEntry )];

		Map<String, Boolean> availablelityMapping = new Map<String, Boolean>();

		for (String productCode : productsListCodes){
				availablelityMapping.put(productCode, false);
		}

		for (Product_Product_Entry__c product : relatedProducts){
			availablelityMapping.put(product.Parent_Product__r.ProductCode, true);
		}

		return availablelityMapping;
	}
}