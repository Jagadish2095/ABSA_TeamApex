/**
 * @description Controller for Absa Life Products
 * @author  Brian Maswanganyi
 * @created 2021-08-04
 */
public class BranchAbsaLifeFulfillmentController {
	/**
	 * @description check Absa Life Products was selected from ROA
	 * @param oppotunityId
	 * @return Boolean
	 **/
	@AuraEnabled
	public static Boolean isAbsaLifeSelectedInRoa(String oppotunityId) {
		Application__c application = [SELECT ROAQuestionnaire__c FROM Application__c WHERE Opportunity__c = :oppotunityId LIMIT 1];

		if (application != null && application.ROAQuestionnaire__c != null) {
			List<ROAController.ROAAnswer> listOfQuestionsAndAnswers = (List<ROAController.ROAAnswer>) JSON.deserialize(
				application.ROAQuestionnaire__c,
				List<ROAController.ROAAnswer>.class
			);

			if (listOfQuestionsAndAnswers.size() > 0) {
				for (ROAController.ROAAnswer answer : listOfQuestionsAndAnswers) {
					if (answer.QuestionId == 'Are you interested in an Absa Life product?' && answer.AnswerId == 'Yes') {
						return answer.IsSelected;
					}
				}
			}
		}

		return false;
	}
	/**
	 * @description Updating Opportunity for the Product
	 * @param opportunityId
	 * @param prodName
	 * @return string
	 **/
	@AuraEnabled
	public static string updateAbsaLifeOpportunityWithProducts(String opportunityId, String prodName) {
		string opportunityLineId = '';

		List<OpportunityLineItem> possibleOpportunities = [
			SELECT Id
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId AND Product_Name__c = :prodName
		];

		if (possibleOpportunities.size() == 0) {
			List<string> productNames = new List<String>();
			productNames.add(prodName);

			List<string> createdItems = createOpportunityProducts(opportunityId, productNames);
			if (createdItems.size() > 0) {
				opportunityLineId = createdItems.get(0);
			} else {
				throw new AuraHandledException('Error adding ' + prodName + ' to Opportunity ');
			}
		} else {
			opportunityLineId = possibleOpportunities.get(0).Id;
		}

		return opportunityLineId;
	}
	/**
	 * @description Creating Opportunity for the Product
	 * @param accountId
	 * @param productNames
	 * @return string
	 **/
	@AuraEnabled
	public static String createAbsaLifeOpportunityWithProducts(String accountId, list<String> productNames) {
		Opportunity currentOpportunity;

		list<Opportunity> opportunity = [
			SELECT Id
			FROM Opportunity
			WHERE AccountId = :accountId AND Name LIKE '% - ABSA LIFE' AND StageName = :StringConstants.OPPORTUNITY_STAGE_APPLY_PRODUCT
		];
		Account accounts = new AccountsSelector().selectAllById(accountId);
		PriceBook2 priceBookItem = new PriceBook2();
		priceBookItem = [SELECT id FROM priceBook2 WHERE name = 'Standard Price Book'];
		if (opportunity.size() == 0) {
			//create opp
			currentOpportunity = new Opportunity();
			currentOpportunity.AccountId = accountId;
			currentOpportunity.Name = accounts.Name + '-' + 'ABSA LIFE';
			currentOpportunity.stageName = 'New';
			currentOpportunity.CloseDate = system.today() + 7;
			currentOpportunity.priceBook2Id = priceBookItem.id;
			insert currentOpportunity;
		} else {
			currentOpportunity = opportunity.get(0);
		}

		createOpportunityProducts(currentOpportunity.Id, productNames);

		return currentOpportunity.Id;
	}
	/**
	 * @description Creating Opportunity Product
	 * @param opportunityId
	 * @param productNames
	 * @return List<string>
	 **/
	public static List<string> createOpportunityProducts(string opportunityId, list<String> productNames) {
		List<string> items = new List<string>();

		list<Product2> products = [SELECT Id FROM Product2 WHERE Name IN :productNames AND Family = 'WIMI'];
		List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
		for (Product2 product : products) {
			OpportunityLineItem lineItem = new OpportunityLineItem();
			lineItem.OpportunityId = opportunityId;
			lineItem.Product2Id = product.Id;
			lineItem.Price_Scheme_Code__c = '';
			lineItem.Quantity = 1;
			lineItem.TotalPrice = 0;
			lineItems.add(lineItem);
		}

		try {
			insert lineItems;
		} catch (DmlException ex) {
			throw ex;
		}
		for (OpportunityLineItem item : lineItems) {
			items.add(item.Id);
		}
		return items;
	}
	/**
	 * @description get Selected And Completed Products
	 * @param opportunityId
	 * @return List<SelectedAbsaLifeProducts>
	 **/
	@AuraEnabled
	public static List<SelectedAbsaLifeProducts> getSelectedAndComletedProducts(string opportunityId) {
		List<OpportunityLineItem> possibleOpportunities = [
			SELECT Id, Product_Name__c, Other_Extra_Description__c
			FROM OpportunityLineItem
			WHERE OpportunityId = :opportunityId
		];

		List<SelectedAbsaLifeProducts> selectedProducts = new List<SelectedAbsaLifeProducts>();

		List<Product2> products = [SELECT Id, Name, ProductCode, Description, Family, Maximum_Quantity__c FROM Product2 WHERE Family = 'WIMI'];

		for (Product2 product : products) {
			SelectedAbsaLifeProducts selectedProduct = new SelectedAbsaLifeProducts();
			selectedProduct.productName = product.Name;
			selectedProduct.description = product.Description;
			for (OpportunityLineItem item : possibleOpportunities) {
				if (item.Product_Name__c == product.Name) {
					selectedProduct.isSelected = true;
					selectedProduct.isFuifilled = item.Other_Extra_Description__c == 'Completed';
					break;
				}
			}
			selectedProduct.disclosures = getDisclosuresForProduct(product.Id);

			selectedProducts.add(selectedProduct);
		}

		return selectedProducts;
	}
	/**
	 * @description get disclosure for Product
	 * @param productID
	 * @return string
	 **/

	public static String getDisclosuresForProduct(String productID) {
		List<ContentDocumentLink> contentLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :productID];
		List<string> contentLinkIds = new List<string>();
		for (ContentDocumentLink contentLink : contentLinks) {
			contentLinkIds.add(contentLink.ContentDocumentId);
		}

		List<ContentNote> contentNotes = [SELECT Id, Title, TextPreview, Content FROM ContentNote WHERE Id IN :(contentLinkIds) AND Title = 'Disclosures'];

		if (contentNotes.size() > 0) {
			return EncodingUtil.base64Decode(EncodingUtil.base64Encode(contentNotes[0].Content)).toString();
		}

		return '';
	}
	/**
	 * @description Selected Absa Life Products
	 **/
	public class SelectedAbsaLifeProducts {
		/**
		 * @description productName
		 **/
		@AuraEnabled
		public String productName;
		/**
		 * @description description
		 **/
		@AuraEnabled
		public String description;
		/**
		 * @description isSelected
		 **/
		@AuraEnabled
		public Boolean isSelected;
		/**
		 * @description isFuifilled
		 **/
		@AuraEnabled
		public Boolean isFuifilled;
		/**
		 * @description disclosures
		 **/
		@AuraEnabled
		public String disclosures;
	}

	/**
	 * @description select all the WIMI Products into a multi-select pick list
	 * @return products
	 **/
	@AuraEnabled
	public static List<Product2> getAbsaLifeProducts() {
		List<Product2> products = [SELECT Id, Name, ProductCode, Description, Family, Maximum_Quantity__c FROM Product2 WHERE Family = 'WIMI'];
		return products;
	}
}