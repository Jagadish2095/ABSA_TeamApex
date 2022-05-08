/**
 * @description This is a test data factory class for Pricing specific test data
 *
 * @author     Prashant Kumar Jain (Tetrad)
 * @since      2020/04/21
 * @UpdateDate 2020/04/21
 * @UpdateDate 2020/05/28
 *
 */

@IsTest
public with sharing class PricingTestDataFactory {
	private static Map<String, Schema.RecordTypeInfo> opportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

	public Account account;
	public Product2 parentProduct;
	public Product2 vasProduct1;
	public Product2 vasProduct2;
	public Product_Product_Entry__c vasProductProductEntry1;
	public Product_Product_Entry__c vasProductProductEntry2;
	public Opportunity opportunity;
	public OpportunityLineItem parentOpportunityLineItem;
	public OpportunityLineItem vasOpportunityLineItem;
	public Pricing_Formula__c pricingFormula;
	public Transaction_Group__c transactionGroup;
	public Transaction_Group__c transactionGroupSmartPay;
	public Transaction_Type__c fixedTransactionType;
	public Transaction_Type__c percentageTransactionType;
	public Transaction_Type__c allTransactionType; //Englarmerdge W004364
	public Transaction_Type__c allTransactionTypeSmartPay;
	public Price_Scheme__c standardPriceScheme;
	public Price_Scheme__c franchisePriceScheme;
	public Price_Scheme__c negotiatedPriceScheme;
	public Price_Scheme_Entry__c standardFixedPriceSchemeEntry;
	public Price_Scheme_Entry__c standardPercentagePriceSchemeEntry;
	public Price_Scheme_Entry__c franchisePriceSchemeEntry;
	public Price_Scheme_Entry__c negotiatedPriceSchemeEntry;
	public Price_Scheme_Entry__c allPriceSchemeEntry;
	public Price_Scheme_Entry__c allPriceSchemeEntrySmartPay;
	public Price_Scheme_Product_Entry__c standardPriceSchemeProductEntry;
	public Price_Scheme_Product_Entry__c negotiatedPriceSchemeProductEntry;

	/**
	 * @description constructor method
	 */
	public PricingTestDataFactory() {
		account = WillsTestDataFactory.createAccount();
		parentProduct = createProduct('Mobile - SmartPay', 'Merchant', 'Mobile;Simplex');
		vasProduct1 = createProduct('VAS 1', 'Merchant', 'Value Added Service');
		vasProduct2 = createProduct('VAS 2', 'Merchant', 'Value Added Service');
		vasProductProductEntry1 = createProductProductEntry(parentProduct.Id, vasProduct1.Id);
		vasProductProductEntry2 = createProductProductEntry(parentProduct.Id, vasProduct2.Id);
		opportunity = createMerchantOpportunity(account.Id);
		parentOpportunityLineItem = createOpportunityLineItem(opportunity.Id, parentProduct.Id, null);
		vasOpportunityLineItem = createOpportunityLineItem(opportunity.Id, vasProduct1.Id, parentOpportunityLineItem.Id);
		pricingFormula = createPricingFormula();

		transactionGroup = createTransactionGroup('MDF');
		transactionGroupSmartPay = createTransactionGroup('SmartPay Terminal Rent');

		fixedTransactionType = createTransactionType('fixedTransactionType', transactionGroup.Id);
		percentageTransactionType = createTransactionType('percentageTransactionType', transactionGroup.Id);
		allTransactionType = createTransactionType('All', transactionGroup.Id); //Englarmerdge W004364
		allTransactionTypeSmartPay = createTransactionType('All', transactionGroupSmartPay.Id); //Englarmerdge W004364

		standardPriceScheme = createPriceScheme('standardPriceScheme', 'Standard', null, 'Merchant');
		franchisePriceScheme = createPriceScheme('franchisePriceScheme', 'Franchise', null, 'Merchant');
		negotiatedPriceScheme = createPriceScheme('negotiatedPriceScheme', 'Negotiated', account.Id, 'Merchant');

		standardFixedPriceSchemeEntry = createFixedPriceSchemeEntry(standardPriceScheme.Id, fixedTransactionType.Id);
		standardPercentagePriceSchemeEntry = createPercentagePriceSchemeEntry(standardPriceScheme.Id, percentageTransactionType.Id);
		franchisePriceSchemeEntry = createFixedPriceSchemeEntry(franchisePriceScheme.Id, fixedTransactionType.Id);
		negotiatedPriceSchemeEntry = createFixedPriceSchemeEntry(negotiatedPriceScheme.Id, fixedTransactionType.Id);
		allPriceSchemeEntry = createFixedPriceSchemeEntry(standardPriceScheme.Id, allTransactionType.Id); //Englarmerdge W004364
		allPriceSchemeEntrySmartPay = createFixedPriceSchemeEntry(standardPriceScheme.Id, allTransactionTypeSmartPay.Id);

		standardPriceSchemeProductEntry = createPriceSchemeProductEntry(standardPriceScheme.Id, parentProduct.Id);
		negotiatedPriceSchemeProductEntry = createPriceSchemeProductEntry(negotiatedPriceScheme.Id, parentProduct.Id);

		transactionGroup.Pricing_Formula__c = pricingFormula.Id;
		update transactionGroup;

		transactionGroupSmartPay.Pricing_Formula__c = pricingFormula.Id;
		update transactionGroupSmartPay;

		fixedTransactionType.Pricing_Formula__c = pricingFormula.Id;
		update fixedTransactionType;

		parentProduct.Maximum_Quantity__c = 3;
		parentProduct.Contract_Duration_Type__c = 'Month to Month';
		update parentProduct;

		account.Is_Part_Of_Franchise__c = true;
		account.Franchise_Price_Scheme__c = franchisePriceScheme.Id;
		update account;

		standardFixedPriceSchemeEntry.Is_Negotiable__c = 'False';
		update standardFixedPriceSchemeEntry;
	}

	/**
	 * @description Create Opportunity
	 * @param accountId
	 * @return Opportunity
	 */
	public static Opportunity createMerchantOpportunity(Id accountId) {
		Opportunity testOpportunity = new Opportunity(
			RecordTypeId = opportunityRecordTypeMap.get('Merchant_Onboarding').getRecordTypeId(),
			Name = 'Test Opportunity',
			AccountId = accountId,
			CloseDate = Date.today().addDays(5),
			StageName = 'Confirm Client Eligibility'
		);

		insert testOpportunity;

		return testOpportunity;
	}

	/**
	 * @description Create OpportunityLineItems
	 * @param opportunityId
	 * @param productId
	 * @param parentOpportunityLineItemId
	 * @return OpportunityLineItem
	 */
	public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id productId, Id parentOpportunityLineItemId) {
		OpportunityLineItem opportunityLineItem = new OpportunityLineItem(
			Product2Id = productId,
			PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(productId),
			OpportunityId = opportunityId,
			Quantity = 1,
			TotalPrice = 0,
			Parent_Opportunity_Line_Item_Id__c = parentOpportunityLineItemId,
			Investment_amount_R__c = '20000',
			Merchant_Class__c = 'RETAIL'
		);

		insert opportunityLineItem;

		return opportunityLineItem;
	}

	/**
	 * @description Create Pricing Formula
	 * @return Pricing_Formula__c
	 */
	public static Pricing_Formula__c createPricingFormula() {
		Pricing_Formula__c pricingFormula = new Pricing_Formula__c(
			Name = 'Test Pricing Formula',
			Pricing_Template__c = 'Fixed Fee per Item',
			Fee_Amount_Picklist_Values__c = '0;1;2'
		);

		insert pricingFormula;

		return pricingFormula;
	}

	/**
	 * @description Create Transaction Group
	 * @param nameP
	 * @return Transaction_Group__c
	 */
	public static Transaction_Group__c createTransactionGroup(String nameP) {
		Transaction_Group__c transactionGroup = new Transaction_Group__c(Name = nameP);

		insert transactionGroup;

		return transactionGroup;
	}

	/**
	 * @description Create Transaction Type
	 * @param name
	 * @param transactionGroupId
	 * @return Transaction_Type__c
	 */
	public static Transaction_Type__c createTransactionType(String name, Id transactionGroupId) {
		Transaction_Type__c transactionType = new Transaction_Type__c(Name = name, Transaction_Group__c = transactionGroupId);

		insert transactionType;

		return transactionType;
	}

	/**
	 * @description Create Price Scheme
	 * @param name
	 * @param type
	 * @param accountId
	 * @param productFamily
	 * @return Price_Scheme__c
	 */
	public static Price_Scheme__c createPriceScheme(String name, String type, Id accountId, String productFamily) {
		Price_Scheme__c priceScheme = new Price_Scheme__c(
			Name = name,
			Start_Date__c = System.today(),
			No_End_Date__c = true,
			Is_Negotiable__c = true,
			Type__c = type,
			Account__c = accountId,
			Product_Family__c = productFamily
		);

		insert priceScheme;

		return priceScheme;
	}

	/**
	 * @description Create Fixed Price Scheme Entry
	 * @param priceSchemeId
	 * @param transactionTypeId
	 * @return Price_Scheme_Entry__c
	 */
	public static Price_Scheme_Entry__c createFixedPriceSchemeEntry(Id priceSchemeId, Id transactionTypeId) {
		Price_Scheme_Entry__c priceSchemetEntry = new Price_Scheme_Entry__c(
			Price_Scheme__c = priceSchemeId,
			Transaction_Type__c = transactionTypeId,
			Pricing_Template__c = 'Fixed Fee per Item',
			Fee_Type__c = 'Fixed',
			Fee_Amount_Fixed__c = 10
		);

		insert priceSchemetEntry;

		return priceSchemetEntry;
	}

	/**
	 * @description Create Percentage Price Scheme Entry
	 * @param priceSchemeId
	 * @param transactionTypeId
	 * @return Price_Scheme_Entry__c
	 */
	public static Price_Scheme_Entry__c createPercentagePriceSchemeEntry(Id priceSchemeId, Id transactionTypeId) {
		Price_Scheme_Entry__c priceSchemetEntry = new Price_Scheme_Entry__c(
			Price_Scheme__c = priceSchemeId,
			Transaction_Type__c = transactionTypeId,
			Pricing_Template__c = 'Fixed Fee per Item',
			Fee_Type__c = 'Percentage',
			Fee_Amount_Percent__c = 10
		);

		insert priceSchemetEntry;

		return priceSchemetEntry;
	}

	/**
	 * @description Create Price Scheme Product Entry
	 * @param priceSchemeId
	 * @param productId
	 * @return Price_Scheme_Product_Entry__c
	 */
	public static Price_Scheme_Product_Entry__c createPriceSchemeProductEntry(Id priceSchemeId, Id productId) {
		Price_Scheme_Product_Entry__c priceSchemeProductEntry = new Price_Scheme_Product_Entry__c(Price_Scheme__c = priceSchemeId, Product__c = productId);

		insert priceSchemeProductEntry;

		return priceSchemeProductEntry;
	}

	/**
	 * @description Create Product Product Entry
	 * @param parentProductId
	 * @param relatedProductId
	 * @return Product_Product_Entry__c
	 */
	public static Product_Product_Entry__c createProductProductEntry(Id parentProductId, Id relatedProductId) {
		Product_Product_Entry__c productProductEntry = new Product_Product_Entry__c(Parent_Product__c = parentProductId, Related_Product__c = relatedProductId);

		insert productProductEntry;

		return productProductEntry;
	}

	/**
	 * @description Create Product
	 * @param productName
	 * @param productFamily
	 * @param productClassification
	 * @return Product2
	 */
	public static Product2 createProduct(String productName, String productFamily, String productClassification) {
		Product2 product = new Product2(Name = productName, IsActive = true, Family = productFamily, Product_Classification__c = productClassification);

		insert product;

		return product;
	}

	/**
	 * @description Create Application
	 * @param opportunityId
	 * @return Application__c
	 */
	public static Application__c createApplication(Id opportunityId) {
		Application__c testApplication = new Application__c(Opportunity__c = opportunityId);

		insert testApplication;

		return testApplication;
	}
}