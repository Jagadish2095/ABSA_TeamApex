/**
 * @description Controller for QuoteBuilder Component
 * @author Prashant Jain / Jason Quevauvilliers
 * @version v1.0
 * @since   2020-04-01
 */
public class QuoteBuilderController {
	/**
    * @description PJAIN: 20200414
    * This method queries pricing data from multiple objects and
    * populates PricingBean object.

    * The pricing is calculated in a hierarchical manner in the following order:
    * Negotiated price for Account for Product
    * Negotiated price for Account for Product Family
    * Franchise and Group price for Account Group
    * Standard price for Product
    * Standard price for Product Family
    * @param opportunityId
    * @param quoteType
    * @return String (JSON)
    */
	@AuraEnabled
	public static String getQuoteBuilderData(String opportunityId, String quoteType) {
		PricingBean pricingBean;
		if (String.isNotBlank(opportunityId)) {
			List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId, 1);
			if (opportunityLineItems != null && opportunityLineItems.size() > 0) {
				OpportunityLineItem opportunityLineItem = opportunityLineItems.get(0);
				pricingBean = new PricingBean();
				pricingBean.transactionVolume = opportunityLineItem.Investment_amount_R__c != null
					? double.valueOf(opportunityLineItem.Investment_amount_R__c)
					: null;
				pricingBean.opportunityId = opportunityId;
				pricingBean.opportunityRecordTypeId = opportunityLineItem.Opportunity.RecordTypeId; // PJAIN: 20200530
				pricingBean.quoteNumber = opportunityLineItem.Opportunity.Quote_Number__c;
				pricingBean.quoteGenerationDate = opportunityLineItem.Opportunity.Quote_Generation_Date__c;
				pricingBean.quoteStatus = opportunityLineItem.Opportunity.Quote_Status__c;
				pricingBean.opportunityLineItemId = opportunityLineItem.Id;
				pricingBean.accountId = opportunityLineItem.Opportunity.AccountId;
				pricingBean.accountName = opportunityLineItem.Opportunity.Account.Name;
				pricingBean.productId = opportunityLineItem.Product2Id;
				pricingBean.productName = opportunityLineItem.Product2.Name;
				pricingBean.productFamily = opportunityLineItem.Product2.Family;
				pricingBean.isNegotiable = true;
				pricingBean.selectedQuantity = (Integer) opportunityLineItem.Quantity;
				pricingBean.selectedContractDurationType = opportunityLineItem.Contract_Duration_Type__c;
				pricingBean.priceSchemeEntryMap = new Map<String, PriceSchemeEntryData>();

				//Populate Quantity Picklist Options
				populateQuantityPicklistOptions((Integer) opportunityLineItem.Product2.Maximum_Quantity__c, pricingBean);

				//Populate Contract Duration Type Picklist Options
				if (String.isNotBlank(opportunityLineItem.Product2.Contract_Duration_Type__c)) {
					pricingBean.contractDurationTypePicklistOptions = opportunityLineItem.Product2.Contract_Duration_Type__c.split(';');
				}

				//Populate Price Entries
				populateNegotiatedPriceEntriesForAccountProduct(pricingBean);
				populateNegotiatedPriceEntriesForAccountProductFamily(pricingBean);
				populateNegotiatedPriceEntriesForFranchise(pricingBean);
				populateStandardPriceEntriesForProduct(pricingBean);
				populateStandardPriceEntriesForProductFamily(pricingBean);

				//Populate Component Product Product Data
				populateComponentProductData(pricingBean);

				String cmpName;
				if (quoteType == 'Merchant Onboarding') {
					cmpName = 'MerchantQuoteBuilder';
				} else if (quoteType == 'SPM Onboarding') {
					cmpName = 'SPMQuoteBuilder';
				}

				//Populate Field Visibility Mdt
				pricingBean.fieldVisibilityMdtList = Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductNameAndFamily(
					cmpName,
					pricingBean.productName,
					pricingBean.productFamily
				);
			}
		}
		return JSON.serialize(pricingBean);
	}

	// PJAIN: 20201105
	/**
	 * @description Overloaded method to allow control whether all data is saved as negotiated
	 * price scheme and entries or only the updated values.
	 * @param jsonString
	 * @param saveOnlyUpdatedData
	 * @return String
	 */
	@AuraEnabled
	public static String saveQuoteBuilderData(String jsonString, Boolean saveOnlyUpdatedData) {
		PricingBean pricingBean = (PricingBean) JSON.deserialize(jsonString, PricingBean.class);
		List<Price_Scheme_Entry__c> priceSchemeEntriesToUpdate = new List<Price_Scheme_Entry__c>();
		List<Price_Scheme_Entry__c> priceSchemeEntriesToInsert = new List<Price_Scheme_Entry__c>();
		List<Price_Scheme_Entry__c> priceSchemeEntriesToDelete = new List<Price_Scheme_Entry__c>();
		Map<Id, PriceSchemeEntryData> priceSchemeEntryMapForInsert = new Map<Id, PriceSchemeEntryData>();
		PriceSchemeEntryData priceSchemeEntryData;

		for (String key : pricingBean.priceSchemeEntryMap.keySet()) {
			priceSchemeEntryData = pricingBean.priceSchemeEntryMap.get(key);
			if (
				!saveOnlyUpdatedData || (priceSchemeEntryData.updatedValue != null && priceSchemeEntryData.existingValue != priceSchemeEntryData.updatedValue)
			) {
				if (String.isBlank(pricingBean.negotiatedPriceSchemeId)) {
					// This insert (if required) would be executed only once in the loop.
					// Once inserted, the negotiatedPriceSchemeId will be set and the IF
					// condition would not be true again.
					insertAndPopulatePriceSchemeId(pricingBean);
				}

				if (String.isNotBlank(priceSchemeEntryData.negotiatedPriceSchemeEntryId)) {
					updatePriceSchemeEntry(priceSchemeEntryData, priceSchemeEntryData.negotiatedPriceSchemeEntryId, priceSchemeEntriesToUpdate);
				} else {
					// Populate a map of records to insert using transactionTypeId as the key so that
					// negotiatedPriceSchemeEntryId can be populated with the inserted record Ids.
					priceSchemeEntryMapForInsert.put(priceSchemeEntryData.transactionTypeId, priceSchemeEntryData);
					insertAndPopulatePriceSchemeEntryId(priceSchemeEntryData, pricingBean.negotiatedPriceSchemeId, priceSchemeEntriesToInsert);
				}
			} else if (priceSchemeEntryData.updatedValue == null && priceSchemeEntryData.negotiatedPriceSchemeEntryId != null) {
				priceSchemeEntriesToDelete.add(new Price_Scheme_Entry__c(Id = priceSchemeEntryData.negotiatedPriceSchemeEntryId));
				priceSchemeEntryData.negotiatedPriceSchemeEntryId = null;
			}
		}

		if (priceSchemeEntriesToUpdate.size() > 0) {
			update priceSchemeEntriesToUpdate;
		}

		if (priceSchemeEntriesToInsert.size() > 0) {
			insert priceSchemeEntriesToInsert;

			// Loop through the priceSchemeEntriesToInsert to populate negotiatedPriceSchemeEntryId
			// with the inserted record Ids based on Transaction_Type__c as the key.
			for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntriesToInsert) {
				priceSchemeEntryData = priceSchemeEntryMapForInsert.get(priceSchemeEntry.Transaction_Type__c);
				priceSchemeEntryData.negotiatedPriceSchemeEntryId = priceSchemeEntry.Id;
			}
		}

		if (priceSchemeEntriesToDelete.size() > 0) {
			delete priceSchemeEntriesToDelete;
		}

		//updateOpportunity(pricingBean);
		updateOpportunityLineItem(pricingBean);
		synchronizeCmpProductOpportunityLineItems(pricingBean);
		return JSON.serialize(pricingBean);
	}

	// PJAIN: 20200422 & JQUEV: 20200813
	/**
	 * @description This method creates Application and Application Product - Merchant records
	 * and Updates the Sales Stage of the Opportunity
	 * @param pricingBeanString
	 * @param metadataNameToValueMap
	 * @return Map<String, String>
	 */
	@AuraEnabled
	public static Map<String, String> createApplicationRecords(String pricingBeanString, Map<String, String> metadataNameToValueMap) {
		Map<String, String> idsMap = new Map<String, String>();
		PricingBean pricingBean = (PricingBean) JSON.deserialize(pricingBeanString, PricingBean.class);

		// Return error if Application record already exists.
		List<Application__c> applications = new ApplicationsSelector().selectByOpportunityOnboardId(pricingBean.opportunityId);
		if (applications != null && applications.size() > 0) {
			idsMap.put('error', StringConstants.MERCHANT_ERROR_APPLICATION_ALREADY_EXISTS);
			return idsMap;
		}

		// Return error if Application Product - Merchant record already exists.
		List<Application_Product_Merchant__c> applicationProductMerchantList = new ApplicationProductMerchantsSelector()
			.selectIdsByOpportunityLineItemId(pricingBean.opportunityLineItemId);
		if (applicationProductMerchantList != null && applicationProductMerchantList.size() > 0) {
			idsMap.put('error', StringConstants.MERCHANT_ERROR_APPLICATION_ALREADY_EXISTS);
			return idsMap;
		}

		if (String.isNotBlank(pricingBean.opportunityId) && String.isNotBlank(pricingBean.opportunityLineItemId)) {
			Savepoint sp = Database.setSavePoint();
			try {
				// Create Application record if it does not exist
				Application__c application = new Application__c();
				application.Opportunity__c = pricingBean.opportunityId;
				application.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByDeveloperName()
					.get(StringConstants.APPLICATION_RECORD_TYPE_MERCHANT_ONBOARDING)
					.getRecordTypeId(); // PJAIN: 20200530
				application.QA_Status__c = 'Not Started'; // PJAIN: 2020603
				application.QA_Status_Updated_By__c = UserInfo.getUserId(); // PJAIN: 2020603
				application.QA_Status_Updated_On__c = System.now(); // PJAIN: 2020603
				insert application;
				idsMap.put('applicationId', application.Id);

				//Dynamically assign the values to the Application_Product_Merchant__c Object based on the Metadata
				Application_Product_Merchant__c applicationProductMerchant = new Application_Product_Merchant__c();
				applicationProductMerchant.Opportunity_Product_Id__c = pricingBean.opportunityLineItemId;

				for (Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList) {
					//Get value from the Map
					String stringValue = metadataNameToValueMap.get(mtdRecord.DeveloperName);
					if (stringValue != null && mtdRecord.Additional_Attributes__c != null && mtdRecord.Object_Name__c == 'Application_Product_Merchant__c') {
						//Get AdditionalAttributes for this mdt record
						AdditionalAttributes addAttributes = (AdditionalAttributes) JSON.deserialize(
							mtdRecord.Additional_Attributes__c,
							AdditionalAttributes.class
						);
						//Check for Field API Name and Type of field
						if (addAttributes.fieldAPIName != null) {
							if (addAttributes.dataType == 'number') {
								//Assigns the value to the Field on the Object by API NAme
								applicationProductMerchant.put(addAttributes.fieldAPIName, decimal.valueOf(stringValue));
							} else {
								//Assigns the value to the Field on the Object by API NAme
								applicationProductMerchant.put(addAttributes.fieldAPIName, stringValue);
							}
						}
					}
				}
				insert applicationProductMerchant;
				idsMap.put('applicationProductMerchantId', applicationProductMerchant.Id);

				List<Device_Merchant__c> devices = new List<Device_Merchant__c>();
				Device_Merchant__c device;
				for (Integer i = 0; i < pricingBean.selectedQuantity; i++) {
					device = new Device_Merchant__c();
					device.Application_Product_Merchant__c = applicationProductMerchant.Id;
					devices.add(device);
				}
				if (devices.size() > 0) {
					insert devices;
				}
			} catch (Exception e) {
				Database.rollback(sp);
				idsMap.put('error', e.getMessage() + '. ' + e.getStackTraceString());
				return idsMap;
			}
		}
		return idsMap;
	}

	// JQUEV: 20200818
	/**
	 * @description This method deletes existing OpportunityLineItems Records
	 * Resets values on the Opportunity and selects a new Product
	 * There will no Application or Application Product Merchant Records at this point
	 * @param opportunityId
	 * @param productName
	 * @return Map<String, String>
	 */
	@AuraEnabled
	public static Map<String, String> changeSelectedProduct(String opportunityId, String productName) {
		Map<String, String> idsMap = new Map<String, String>();

		List<User> userList = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		if (userList[0].SiteCode__c != null) {
			//Select Product2 Record *** NOT USING SELECTOR as Query will change when we remove hard-coding of product names select list.
			//Because then we can query by ID
			List<Product2> selectedProductList = [SELECT Id FROM Product2 WHERE Name = :productName];

			if (selectedProductList.size() == 1) {
				Savepoint sp = Database.setSavePoint();
				try {
					//Delete existing OpportunityLineItems
					List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
					delete oppLineItemList;

					//Update Opportunity
					Opportunity opportunity = new OpportunitiesSelector().selectByOppId(opportunityId);
					opportunity.StageName = StringConstants.OPPORTUNITY_STAGE_ACCEPT_QUOTE;
					opportunity.Quote_Status__c = 'Pending';
					opportunity.SiteCode__c = userList[0].SiteCode__c;
					opportunity.SelectedProduct__c = productName;
					opportunity.Loss_Reason__c = null;
					opportunity.Loss_Reason_Type__c = null;
					opportunity.Quote_Number__c = null;
					opportunity.Quote_Generation_Date__c = null;
					update opportunity;

					//Insert new OpportunityLineItem
					OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
					opportunityLineItem.OpportunityId = opportunityId;
					opportunityLineItem.Product2Id = selectedProductList[0].Id;
					opportunityLineItem.TotalPrice = 0;
					opportunityLineItem.Quantity = 1;
					opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(selectedProductList[0].Id);
					insert opportunityLineItem;

					idsMap.put('opportunityProductId', opportunityLineItem.Id);
				} catch (Exception e) {
					Database.rollback(sp);
					idsMap.put('error', e.getMessage() + '. ' + e.getStackTraceString());
					return idsMap;
				}
			} else {
				idsMap.put('error', 'Error trying to find product record. Records returned: ' + selectedProductList.size());
				return idsMap;
			}
		} else {
			idsMap.put('error', StringConstants.MERCHANT_ERROR_USER_SITE_CODE_NOT_FOUND);
			return idsMap;
		}
		return idsMap;
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Quantity Picklist Options based on Contract_Duration_Type__c field on Product2
	 * @param productMaxQuantity
	 * @param pricingBean
	 */
	private static void populateQuantityPicklistOptions(Integer productMaxQuantity, PricingBean pricingBean) {
		pricingBean.quantityPicklistOptions = new List<Integer>();
		pricingBean.quantityPicklistOptions.add(1);
		if (productMaxQuantity != null && productMaxQuantity > 1) {
			for (Integer i = 2; i <= productMaxQuantity; i++) {
				pricingBean.quantityPicklistOptions.add(i);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Negotiated price for Account for Product.
	 * It queries Negotiated Price Scheme Id by querying Price Scheme Product Entry Object.
	 * @param pricingBean
	 */
	private static void populateNegotiatedPriceEntriesForAccountProduct(PricingBean pricingBean) {
		if (
			String.isNotBlank(pricingBean.accountId) &&
			String.isNotBlank(pricingBean.productId) &&
			pricingBean != null &&
			pricingBean.priceSchemeEntryMap != null
		) {
			List<Price_Scheme_Product_Entry__c> accountProductPriceSchemesProductEntries = new PriceSchemeProductEntriesSelector()
				.selectByActiveTypeAccountProduct(pricingBean.productId, pricingBean.accountId, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
			if (accountProductPriceSchemesProductEntries != null && accountProductPriceSchemesProductEntries.size() > 0) {
				Price_Scheme_Product_Entry__c accountProductPriceSchemesProductEntry = accountProductPriceSchemesProductEntries.get(0);
				if (pricingBean.isNegotiable) {
					pricingBean.isNegotiable = accountProductPriceSchemesProductEntry.Price_Scheme__r.Is_Negotiable__c;
				}
				populatePriceEntries(accountProductPriceSchemesProductEntry.Price_Scheme__c, true, pricingBean);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Negotiated price for Account.
	 * It queries Negotiated Price Scheme Id by querying Price Scheme Object.
	 * @param pricingBean
	 */
	private static void populateNegotiatedPriceEntriesForAccountProductFamily(PricingBean pricingBean) {
		if (
			String.isNotBlank(pricingBean.accountId) &&
			String.isNotBlank(pricingBean.productFamily) &&
			pricingBean != null &&
			pricingBean.priceSchemeEntryMap != null
		) {
			List<Price_Scheme__c> accountProductFamilyPriceSchemes = new PriceSchemesSelector()
				.selectByAccountTypeProductFamily(pricingBean.accountId, pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
			if (accountProductFamilyPriceSchemes != null && accountProductFamilyPriceSchemes.size() > 0) {
				Price_Scheme__c accountProductFamilyPriceScheme = accountProductFamilyPriceSchemes.get(0);
				if (pricingBean.isNegotiable) {
					pricingBean.isNegotiable = accountProductFamilyPriceScheme.Is_Negotiable__c;
				}
				populatePriceEntries(accountProductFamilyPriceScheme.Id, true, pricingBean);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Franchise and Group price for Account Group.
	 * It queries Franchise Price Scheme Id by querying Account Object.
	 * @param pricingBean
	 */
	private static void populateNegotiatedPriceEntriesForFranchise(PricingBean pricingBean) {
		if (String.isNotBlank(pricingBean.accountId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
			List<Account> accounts = new AccountsSelector().selectFranchisePriceSchemeIdById(pricingBean.accountId);
			if (accounts != null && accounts.size() > 0) {
				pricingBean.isNegotiable = false;
				populatePriceEntries(accounts.get(0).Franchise_Price_Scheme__c, true, pricingBean);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Standard price for Product.
	 * It queries Standard Price Scheme Id by querying Price Scheme Product Entry Object.
	 * @param pricingBean
	 */
	private static void populateStandardPriceEntriesForProduct(PricingBean pricingBean) {
		if (String.isNotBlank(pricingBean.productId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
			List<Price_Scheme_Product_Entry__c> productPriceSchemesProductEntries = new PriceSchemeProductEntriesSelector()
				.selectByActiveTypeProduct(pricingBean.productId, StringConstants.PRICE_SCHEME_TYPE_STANDARD, 1);
			if (productPriceSchemesProductEntries != null && productPriceSchemesProductEntries.size() > 0) {
				Price_Scheme_Product_Entry__c productPriceSchemesProductEntry = productPriceSchemesProductEntries.get(0);
				if (pricingBean.isNegotiable) {
					pricingBean.isNegotiable = productPriceSchemesProductEntry.Price_Scheme__r.Is_Negotiable__c;
				}
				populatePriceEntries(productPriceSchemesProductEntry.Price_Scheme__c, false, pricingBean);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Standard price for Product Family.
	 * It queries Standard Price Scheme Id by querying Price Scheme Object.
	 * @param pricingBean
	 */
	private static void populateStandardPriceEntriesForProductFamily(PricingBean pricingBean) {
		if (String.isNotBlank(pricingBean.productFamily) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
			List<Price_Scheme__c> standardProductFamilyPriceSchemes = new PriceSchemesSelector()
				.selectByTypeProductFamily(pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_STANDARD, 1);
			if (standardProductFamilyPriceSchemes != null && standardProductFamilyPriceSchemes.size() > 0) {
				Price_Scheme__c standardProductFamilyPriceScheme = standardProductFamilyPriceSchemes.get(0);
				if (pricingBean.isNegotiable) {
					pricingBean.isNegotiable = standardProductFamilyPriceScheme.Is_Negotiable__c;
				}
				populatePriceEntries(standardProductFamilyPriceScheme.Id, false, pricingBean);
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Price Scheme Entries.
	 * It queries Price Scheme Entries using the Price Scheme Id.
	 * @param priceSchemeId
	 * @param isNegotiated
	 * @param pricingBean
	 */
	private static void populatePriceEntries(Id priceSchemeId, Boolean isNegotiated, PricingBean pricingBean) {
		if (String.isNotBlank(priceSchemeId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
			List<Price_Scheme_Entry__c> priceSchemeEntries = new PriceSchemeEntriesSelector().selectByPriceSchemeId(priceSchemeId);
			Map<Id, Double> tieredPriceByPSEntryIdMap;

			if (!isNegotiated && pricingBean.transactionVolume != null) {
				tieredPriceByPSEntryIdMap = getTieredPriceByPSEntryIdMap(priceSchemeEntries, Integer.valueOf(pricingBean.transactionVolume));
			}

			for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntries) {
				// System.debug('populatePriceEntries priceSchemeEntry: ' + priceSchemeEntry);
				String transactionGroupName = priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Name;
				String transactionTypeName = priceSchemeEntry.Transaction_Type__r.Name;
				String mapKey = String.format(
					StringConstants.MERCHANT_PRICE_SCHEME_ENTRY_MAP_KEY_TEMPLATE,
					new List<String>{ transactionGroupName, transactionTypeName }
				);

				// Don't put in the map if the key already exists
				if (!pricingBean.priceSchemeEntryMap.containsKey(mapKey)) {
					PriceSchemeEntryData priceSchemeEntryData = new PriceSchemeEntryData();
					priceSchemeEntryData.feeType = priceSchemeEntry.Fee_Type__c;
					priceSchemeEntryData.pricingTemplate = priceSchemeEntry.Pricing_Template__c;
					priceSchemeEntryData.transactionTypeId = priceSchemeEntry.Transaction_Type__c;
					priceSchemeEntryData.TrasactionTypeName = priceSchemeEntry.Transaction_Type__r.Name;

					if (
						priceSchemeEntry.Pricing_Template__c == StringConstants.PRICE_SCHEME_ENTRY_PRICING_TEMPLATE_VARIABLE_PERCENTAGE &&
						tieredPriceByPSEntryIdMap != null &&
						tieredPriceByPSEntryIdMap?.containsKey(priceSchemeEntry.Id)
					) {
						priceSchemeEntryData.existingValue = tieredPriceByPSEntryIdMap.get(priceSchemeEntry.Id);
					} else {
						if (priceSchemeEntry.Fee_Type__c == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
							priceSchemeEntryData.existingValue = priceSchemeEntry.Fee_Amount_Fixed__c;
						} else if (priceSchemeEntry.Fee_Type__c == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
							priceSchemeEntryData.existingValue = priceSchemeEntry.Fee_Amount_Percent__c;
						}
					}

					if (isNegotiated) {
						priceSchemeEntryData.negotiatedPriceSchemeEntryId = priceSchemeEntry.Id;
						if (String.isBlank(pricingBean.negotiatedPriceSchemeId)) {
							pricingBean.negotiatedPriceSchemeId = priceSchemeId;
						}
					}

					if (pricingBean.isNegotiable && priceSchemeEntry.Is_Negotiable__c == 'False') {
						PriceSchemeEntryData.isNegotiable = false;
					} else {
						PriceSchemeEntryData.isNegotiable = pricingBean.isNegotiable;
					}

					Set<String> picklistOptionSet = new Set<String>();
					if (priceSchemeEntryData.existingValue != null) {
						picklistOptionSet.add(String.valueOf(Decimal.valueOf(priceSchemeEntryData.existingValue).setScale(2)));
					}

					if (String.isNotBlank(priceSchemeEntry.Transaction_Type__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c)) {
						picklistOptionSet.addAll(priceSchemeEntry.Transaction_Type__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c.split(';'));
					} else if (String.isNotBlank(priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c)) {
						picklistOptionSet.addAll(
							priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c.split(';')
						);
					}

					// The following code takes the picklist options from Price Scheme
					// and Pricing Formula, converts it to Decimal with 2 decimal places,
					// sorts it and converts it back to a String list
					Set<Decimal> tempDecimalSet = new Set<Decimal>();
					for (String currentItem : picklistOptionSet) {
						tempDecimalSet.add(Decimal.valueOf(currentItem).setScale(2));
					}

					List<Decimal> tempDecimalList = new List<Decimal>(tempDecimalSet);
					tempDecimalList.sort();
					priceSchemeEntryData.picklistOptions = new List<String>();

					for (Decimal currentItem : tempDecimalList) {
						priceSchemeEntryData.picklistOptions.add(String.valueOf(currentItem));
					}

					pricingBean.priceSchemeEntryMap.put(mapKey, priceSchemeEntryData);
				}
			}
		}
	}

	// PJAIN: 20201105
	/**
	 * @description This method queries Pricing Tier for various Price Scheme Entries,
	 * and creates a map with Price Scheme Entry Id as key and the tiered
	 * pricing as the value.
	 * @param priceSchemeEntries
	 * @param transactionVolume
	 * @return Map<Id, Double>
	 */
	private static Map<Id, Double> getTieredPriceByPSEntryIdMap(List<Price_Scheme_Entry__c> priceSchemeEntries, Integer transactionVolume) {
		Map<Id, String> priceSchemeEntriesMap;
		Map<Id, Double> tieredPriceByPSEntryIdMap;
		priceSchemeEntriesMap = new Map<Id, String>();
		for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntries) {
			if (priceSchemeEntry.Pricing_Template__c == StringConstants.PRICE_SCHEME_ENTRY_PRICING_TEMPLATE_VARIABLE_PERCENTAGE) {
				priceSchemeEntriesMap.put(priceSchemeEntry.Id, priceSchemeEntry.Fee_Type__c);
			}
		}
		if (priceSchemeEntriesMap?.size() > 0) {
			List<Pricing_Tier__c> pricingTiers = [
				SELECT Id, Fee_Amount_Fixed__c, Fee_Amount_Percent__c, Price_Scheme_Entry__c
				FROM Pricing_Tier__c
				WHERE Price_Scheme_Entry__c IN :priceSchemeEntriesMap.keySet() AND From__c <= :transactionVolume AND To__c >= :transactionVolume
				ORDER BY Price_Scheme_Entry__c, From__c ASC
			];
			if (pricingTiers?.size() > 0) {
				tieredPriceByPSEntryIdMap = new Map<Id, Double>();
				for (Pricing_Tier__c pricingTier : pricingTiers) {
					if (!tieredPriceByPSEntryIdMap.containsKey(pricingTier.Price_Scheme_Entry__c)) {
						if (priceSchemeEntriesMap.get(pricingTier.Price_Scheme_Entry__c) == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
							tieredPriceByPSEntryIdMap.put(pricingTier.Price_Scheme_Entry__c, pricingTier.Fee_Amount_Fixed__c);
						} else if (priceSchemeEntriesMap.get(pricingTier.Price_Scheme_Entry__c) == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
							tieredPriceByPSEntryIdMap.put(pricingTier.Price_Scheme_Entry__c, pricingTier.Fee_Amount_Percent__c);
						}
					}
				}
			}
		}
		return tieredPriceByPSEntryIdMap;
	}

	// PJAIN: 20200420
	/**
	 * @description This method populates Component Product Details
	 * It queries Product Product Entries using the Parent Product Id.
	 * @param pricingBean
	 */
	private static void populateComponentProductData(PricingBean pricingBean) {
		if (String.isNotBlank(pricingBean.productId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
			List<Product_Product_Entry__c> productProductEntries = new ProductProductEntriesSelector().selectByParentProductId(pricingBean.productId);

			if (productProductEntries != null && productProductEntries.size() > 0) {
				pricingBean.componentProductDataList = new List<ComponentProductData>();
				ComponentProductData componentProductData;

				List<OpportunityLineItem> componentOpportunityLineItems = new OpportunityLineItemsSelector()
					.selectRelatedLineItemsByParentId(pricingBean.opportunityLineItemId);
				Map<String, List<OpportunityLineItem>> componentOpportunityLineItemMap;
				if (componentOpportunityLineItems != null && componentOpportunityLineItems.size() > 0) {
					componentOpportunityLineItemMap = Sys_Utilities_General.convertListToMapWithStringKey(componentOpportunityLineItems, 'Product2Id');
				}

				for (Product_Product_Entry__c productProductEntry : productProductEntries) {
					componentProductData = new ComponentProductData();
					componentProductData.productId = productProductEntry.Related_Product__c;
					componentProductData.productName = productProductEntry.Related_Product__r.Name;

					if (componentOpportunityLineItemMap != null) {
						if (componentOpportunityLineItemMap.containsKey(componentProductData.productId)) {
							componentProductData.opportunityLineItemId = componentOpportunityLineItemMap.get(componentProductData.productId).get(0).Id;
							componentProductData.isSelected = true;
						} else {
							componentProductData.isSelected = false;
						}
					} else {
						componentProductData.isSelected = true;
					}
					pricingBean.componentProductDataList.add(componentProductData);
				}
			}
		}
	}

	// PJAIN: 20200420
	/**
	 * @description This method creates a new Price Scheme.
	 * @param pricingBean
	 */
	private static void insertAndPopulatePriceSchemeId(PricingBean pricingBean) {
		Price_Scheme__c priceScheme = new Price_Scheme__c();
		priceScheme.Name = StringConstants.PRICE_SCHEME_NAME_PATTERN + pricingBean.accountName;
		priceScheme.Start_Date__c = Date.today();
		priceScheme.No_End_Date__c = true;
		priceScheme.Is_Negotiable__c = true;
		priceScheme.Type__c = StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED;
		priceScheme.Account__c = pricingBean.accountId;
		priceScheme.Product_Family__c = pricingBean.productFamily;
		insert priceScheme;
		pricingBean.negotiatedPriceSchemeId = priceScheme.Id;
	}

	// PJAIN: 20200420
	/**
	 * @description This method updates Price Scheme Entry.
	 * @param priceSchemeEntryData
	 * @param negotiatedPriceSchemeEntryId
	 * @param priceSchemeEntries
	 */
	private static void updatePriceSchemeEntry(
		PriceSchemeEntryData priceSchemeEntryData,
		Id negotiatedPriceSchemeEntryId,
		List<Price_Scheme_Entry__c> priceSchemeEntries
	) {
		Price_Scheme_Entry__c priceSchemeEntry = new Price_Scheme_Entry__c(Id = negotiatedPriceSchemeEntryId);
		if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
			priceSchemeEntry.Fee_Amount_Fixed__c = priceSchemeEntryData.updatedValue;
		} else if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
			priceSchemeEntry.Fee_Amount_Percent__c = priceSchemeEntryData.updatedValue;
		}
		priceSchemeEntryData.existingValue = priceSchemeEntryData.updatedValue;
		priceSchemeEntries.add(priceSchemeEntry);
	}

	// PJAIN: 20200420
	/**
	 * @description This method creates a new Price Scheme Entry.
	 * @param priceSchemeEntryData
	 * @param negotiatedPriceSchemeId
	 * @param priceSchemeEntries
	 */
	private static void insertAndPopulatePriceSchemeEntryId(
		PriceSchemeEntryData priceSchemeEntryData,
		Id negotiatedPriceSchemeId,
		List<Price_Scheme_Entry__c> priceSchemeEntries
	) {
		Price_Scheme_Entry__c priceSchemeEntry = new Price_Scheme_Entry__c();
		priceSchemeEntry.Price_Scheme__c = negotiatedPriceSchemeId;
		priceSchemeEntry.Transaction_Type__c = priceSchemeEntryData.transactionTypeId;
		priceSchemeEntry.Pricing_Template__c = priceSchemeEntryData.pricingTemplate;
		priceSchemeEntry.Fee_Type__c = priceSchemeEntryData.feeType;

		if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
			priceSchemeEntry.Fee_Amount_Fixed__c = priceSchemeEntryData.updatedValue;
		} else if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
			priceSchemeEntry.Fee_Amount_Percent__c = priceSchemeEntryData.updatedValue;
		}
		priceSchemeEntryData.existingValue = priceSchemeEntryData.updatedValue;
		priceSchemeEntries.add(priceSchemeEntry);
	}

	// PJAIN: 20200422
	// This method updates Opportunity.
	/* private static void updateOpportunity (PricingBean pricingBean) {
        Opportunity opportunity = new Opportunity(
            Id = pricingBean.opportunityId,
            Quote_Number__c = pricingBean.quoteNumber,
            Quote_Generation_Date__c = pricingBean.quoteGenerationDate
        );
        update opportunity;
    } */

	// PJAIN: 20200420 & JQUEV: 20200813
	/**
	 * @description This method updates Opportunity Line Item.
	 * @param pricingBean
	 */
	private static void updateOpportunityLineItem(PricingBean pricingBean) {
		// PJAIN: 20201105
		// Skip executing the method if fieldVisibilityMdtList is null
		if (pricingBean.fieldVisibilityMdtList == null) {
			return;
		}

		OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
		opportunityLineItem.Id = pricingBean.opportunityLineItemId;

		//deserialize the bean into an Untyped Object. Which allows us to use a get by valueReadPath method
		String jsonStr = JSON.serialize(pricingBean);
		Map<String, Object> untypedMap = (Map<String, Object>) JSON.deserializeUntyped(jsonStr);

		for (Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList) {
			if (mtdRecord.Additional_Attributes__c != null && mtdRecord.Object_Name__c == 'OpportunityLineItem') {
				AdditionalAttributes addAttributes = (AdditionalAttributes) JSON.deserialize(mtdRecord.Additional_Attributes__c, AdditionalAttributes.class);

				if (addAttributes.fieldAPIName != null) {
					//If there is a key then we get the value from the Map. Else get by valueReadPath
					if (addAttributes.priceSchemeEntryMapKey != null) {
						PriceSchemeEntryData entryData = pricingBean.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);

						if (entryData != null && entryData.updatedValue != null) {
							//Assigns the value to the Field on the Object by API NAme
							opportunityLineItem.put(addAttributes.fieldAPIName, entryData.updatedValue);
						}
					} else {
						if (untypedMap.get(addAttributes.valueReadPath) != null) {
							//Assigns the value to the Field on the Object by API NAme
							opportunityLineItem.put(addAttributes.fieldAPIName, untypedMap.get(addAttributes.valueReadPath));
						}
					}
				}
			}
		}
		update opportunityLineItem;
	}

	// PJAIN: 20200420
	/**
	 * @description This method inserts Opportunity Line Item for Component Products.
	 * @param pricingBean
	 */
	private static void synchronizeCmpProductOpportunityLineItems(PricingBean pricingBean) {
		List<OpportunityLineItem> insertOpportunityLineItems = new List<OpportunityLineItem>();
		List<OpportunityLineItem> deleteOpportunityLineItems = new List<OpportunityLineItem>();
		OpportunityLineItem opportunityLineItem;

		for (ComponentProductData componentProductData : pricingBean.componentProductDataList) {
			// Component Product lines which are selected from UI but do not already exist will be inserted
			if (componentProductData.isSelected && String.isBlank(componentProductData.opportunityLineItemId)) {
				opportunityLineItem = new OpportunityLineItem();
				opportunityLineItem.OpportunityId = pricingBean.opportunityId;
				opportunityLineItem.Parent_Opportunity_Line_Item_Id__c = pricingBean.opportunityLineItemId;
				opportunityLineItem.Product2Id = componentProductData.productId;
				opportunityLineItem.TotalPrice = 0;
				opportunityLineItem.Quantity = 1;
				opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(componentProductData.productId);
				insertOpportunityLineItems.add(opportunityLineItem);
			}

			// Component Product lines which are deselected from UI but already exist will be deleted
			if (!componentProductData.isSelected && String.isNotBlank(componentProductData.opportunityLineItemId)) {
				opportunityLineItem = new OpportunityLineItem(Id = componentProductData.opportunityLineItemId);
				deleteOpportunityLineItems.add(opportunityLineItem);
				componentProductData.opportunityLineItemId = null;
			}
		}

		if (insertOpportunityLineItems.size() > 0) {
			insert insertOpportunityLineItems;

			// Populate the newly created Opportunity Line Item Id on the bean
			for (OpportunityLineItem newOpportunityLineItem : insertOpportunityLineItems) {
				for (ComponentProductData componentProductData : pricingBean.componentProductDataList) {
					if (newOpportunityLineItem.Product2Id == componentProductData.productId) {
						componentProductData.opportunityLineItemId = newOpportunityLineItem.Id;
					}
				}
			}
		}

		if (deleteOpportunityLineItems.size() > 0) {
			delete deleteOpportunityLineItems;
		}
	}

	/**
	 * @description PJAIN: 20200724
	 * @param documentGenerationMap
	 * @return String
	 */
	@AuraEnabled
	public static String generateMerchantQuoteDocument(Map<String, String> documentGenerationMap) {
		String templateName = System.Label.Merchant_Quote_Document_Template_Name;
		return GenerateDocument.autoGenerateDoc(templateName, documentGenerationMap);
	}

	// PJAIN: 20200414
	/**
	 * @description This inner classes defines the structure of the response message from Apex controller
	 */
	public class PricingBean {
		public Id opportunityId;
		public Id opportunityRecordTypeId; // PJAIN: 20200530
		public String quoteNumber;
		public Datetime quoteGenerationDate;
		public String quoteStatus;
		public Id opportunityLineItemId;
		public Id accountId;
		public String accountName;
		public Id productId;
		public String productName;
		public String productFamily;
		public Boolean isNegotiable;
		public Id negotiatedPriceSchemeId;
		public List<Integer> quantityPicklistOptions;
		public Integer selectedQuantity;
		public List<String> contractDurationTypePicklistOptions;
		public String selectedContractDurationType;
		public Double transactionVolume; // PJAIN: 20201105
		public Map<String, PriceSchemeEntryData> priceSchemeEntryMap;
		public List<ComponentProductData> componentProductDataList;
		public List<Field_Visibility_Per_Product__mdt> fieldVisibilityMdtList; //JQUEV20200713
	}

	// PJAIN: 20200414
	/**
	 * @description This inner classes defines the structure of the response message from Apex controller
	 */
	public class PriceSchemeEntryData {
		public Id negotiatedPriceSchemeEntryId;
		public String pricingTemplate;
		public String feeType;
		public Id transactionTypeId;
		public String TrasactionTypeName;
		public Boolean isNegotiable;
		public Double existingValue;
		public Double updatedValue;
		public List<String> picklistOptions;
	}

	// PJAIN: 20200420
	/**
	 * @description This inner classes defines the structure of the response message from Apex controller
	 */
	public class ComponentProductData {
		public Id opportunityLineItemId;
		public Id productId;
		public String productName;
		public Boolean isSelected;
	}

	// JQUEV: 20200804
	/**
	 * @description This inner classes defines the structure of the Additional Attributes JSON for Field_Visibility_Per_Product__mdt
	 */
	public class AdditionalAttributes {
		public String priceSchemeEntryMapKey;
		public String valueReadPath;
		public String valueWritePath;
		public String picklistOptionsPath;
		public String helpTxt;
		public String dataType;
		public String fieldAPIName;
		public String fieldType; //detailed or roll-up
		public String layoutItemSize;
		public List<Action_cls> actions;
		public List<Attributes_cls> attributes;
	}

	// JQUEV: 20200806
	/**
	 * @description This inner classes defines the structure actions that Fields can have e.g. onChange and the method it calls
	 */
	public class Action_cls {
		public String action;
		public String method;
	}

	// JQUEV: 20200807
	/**
	 * @description This inner classes defines the structure for name/value pairs of html attributes
	 */
	public class Attributes_cls {
		public String name;
		public String value;
	}

	// eSign the doc //Story W-004373 - Tinashe Shoko - START
	/**
	 * @description tory W-004373 - Tinashe Shoko
	 * @param opportunityId
	 * @return List<Map<String, Object>>
	 */
	@SuppressWarnings('PMD.AvoidDebugStatements')
	@AuraEnabled
	public static List<Map<String, Object>> getSignatoriesData(Id opportunityId) {
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			return DocumentsShareControllerESign.getSignatoriesData(docList[0].Id);
		} else {
			system.debug('Signatories Data not found....');
		}
		return null;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * Assumption being there is only one quote document per Opportunity or rather last one
	 * uploaded/generated is valid
	 * Check if it is valid for e-signing i.e. it has not already been or send for esigning
	 * @param opportunityId
	 * @return boolean
	 */
	@AuraEnabled
	public static boolean documentRestricted(Id opportunityId) {
		boolean restricted = false;
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			restricted = DocumentsShareControllerESign.documentRestricted(opportunityId, docList[0].Id);
		} else {
			return true;
		}
		return restricted;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getAllClientEmailsSignature(Id opportunityId) {
		return DocumentsShareControllerESign.getAllClientEmailsSignature(opportunityId);
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getMobile(Id opportunityId) {
		return DocumentsShareControllerESign.getMobile(opportunityId);
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param fld
	 * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getDigitalSignatorySelectOptions(string fld) {
		return DocumentsShareControllerESign.getDigitalSignatorySelectOptions(fld);
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @param signatoryId
	 * @param signatoriesInput
	 * @param method
	 * @param mobile
	 * @param email
	 * @return List<Map<String, Object>>
	 */
	@AuraEnabled
	public static List<Map<String, Object>> getUpdatedSignatoriesData(
		Id opportunityId,
		Id signatoryId,
		String signatoriesInput,
		String method,
		String mobile,
		String email
	) {
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			return DocumentsShareControllerESign.getUpdatedSignatoriesData(opportunityId, docList[0].Id, signatoryId, signatoriesInput, method, mobile, email);
		}
		return listTotal;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @param signatories
	 * @return String
	 */
	@AuraEnabled
	public static String sendForImpressionSignature(Id opportunityId, String signatories) {
		String wid;
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			return DocumentsShareControllerESign.sendForImpressionSignature(docList[0].Id, signatories);
		}
		return wid;
	}

	/**
	 * @description Tinashe Shoko
	 * Method that gets a list of all Impression requests for an Opportunity
	 * @param opportunityId
	 * @return List<ImpressionRequest__c>
	 */
	@AuraEnabled
	public static List<ImpressionRequest__c> fetchImpressionRequest(Id opportunityId) {
		List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectRequestsByOpptyId(opportunityId);
		return impressionRequests;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @param sharingMethod
	 * @param clientEmail
	 * @return String
	 */
	@AuraEnabled
	public static String getDocumentContent(Id opportunityId, String sharingMethod, String clientEmail) {
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		List<Map<String, Object>> listTotal = new List<Map<String, Object>>();
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			return DocumentsShareControllerESign.getDocumentContent(opportunityId, docList[0].Id, sharingMethod, clientEmail);
		}
		return null;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 * @return String
	 */
	@AuraEnabled
	public static String getQuoteDocumentName(Id opportunityId) {
		String docName;
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			docName = docList[0].Name;
		}
		return docName;
	}

	/**
	 * @description Tinashe Shoko - W-004373
	 * @param opportunityId
	 */
	@SuppressWarnings('PMD.AvoidDebugStatements')
	@AuraEnabled
	public static void sendDocumentSharingEmail(String opportunityId) {
		List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId, StringConstants.QUOTE_DOCUMENT_TYPE);
		if (!docList.isEmpty() && docList != null && docList.size() > 0) {
			String idListJSON = '["' + docList[0].Id + '"]';
			List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId, 1);
			if (oppLineItemList != null && oppLineItemList.size() > 0 && !oppLineItemList.isEmpty()) {
				List<Map<String, Object>> signatoriesData = getSignatoriesData(opportunityId);
				if (signatoriesData != null && signatoriesData.size() > 0 && !signatoriesData.isEmpty()) {
					Map<String, Object> mySignData = signatoriesData[0];
					String clientEmail = String.valueOf(mySignData.get('Email'));
					DocumentsShareControllerESign.sendDocumentSharingEmail(opportunityId, clientEmail, idListJSON);
				} else {
					system.debug('Error getSignatoriesData');
				}
			}
		}
	}

	// eSign the doc //Story W-004373 - Tinashe Shoko - END

	/**
	 * @description Method to send the email for SPM
	 * @param jsonString
	 * @param recId
	 * @return String
	 */
	@AuraEnabled
	public static string sendEmailSPM(String jsonString, Id recId) {
		String response = '';
		Opportunity OppRec = new OpportunitiesSelector().selectByOppId(recId);
		PricingBean pricingBean = (PricingBean) JSON.deserialize(jsonString, PricingBean.class);
		Double i = pricingBean.priceSchemeEntryMap.get('[Initial advice fee]:[All]').updatedValue;
		if (i > 3) {
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			Id targetObjectId = [SELECT id FROM Contact WHERE Email != '' LIMIT 1].Id; //get any dummy contact just for sake of passing it
			message.setTargetObjectId(targetObjectId);
			message.setTreatTargetObjectAsRecipient(false);
			EmailTemplate emailTemplate = [
				SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
				FROM EmailTemplate
				WHERE name = 'SPM Initial fees in excess of IFA notification'
			];
			message.setTemplateID(emailTemplate.Id);
			message.setWhatId(recId); //This is important for the merge fields in template to work

			message.toAddresses = new List<String>{ 'haritha.police@absa.africa' };
			String htmlBody1 = message.getHTMLBody();
			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

			if (results[0].success) {
				response = 'success';
			} else {
				return 'The email failed to send: ' + results[0].errors[0].message;
			}
		}

		PriceSchemeEntryData anualManagementFee = pricingBean.priceSchemeEntryMap.get('[Annual management fee]:[All]');

		if (anualManagementFee.picklistOptions.size() > 0) {
			if (anualManagementFee.updatedValue < Double.valueOf(anualManagementFee.picklistOptions[0])) {
				//set approval field
				OppRec.Trigger_Approval_Process__c = 'SPM Fees deviation';
				update OppRec;
				response = 'success';
			} else {
				return 'failed ';
			}
		}

		//Double j = pricingBean.priceSchemeEntryMap.get('[Annual management fee]:[All]').existingValue; 
		//Double k = pricingBean.priceSchemeEntryMap.get('[Annual management fee]:[All]').updatedValue;
		//updatedValue
		return response;
	}

	/**
	 * @description This is bulkified to return multiple Price Scheme Entries based on the input.
	 * @param priceSchemeNameToChargeLogIdMap Map of Price Scheme Names to their respective Chare Log Ids
	 * @param chargeLogList List of Charge Logs
	 * @return Map<Id, Price_Scheme_Entry__c>
	 */
	public static Map<Id, Price_Scheme_Entry__c> getPriceSchemeEntriesForChargeLogs(
		Map<Id, String> priceSchemeNameToChargeLogIdMap,
		List<Charge_Log__c> chargeLogList
	) {
		//Add all Price Scheme Names to Set and Query all Price Schemes
		Set<String> priceSchemeNameSet = new Set<String>(priceSchemeNameToChargeLogIdMap.values());
		List<Price_Scheme__c> priceSchemeList = new PriceSchemesSelector().selectByNameSet(priceSchemeNameSet);

		//For Each Charge_Log__c add Transaction Code  to the Set to query Transaction Types
		Set<String> transactionCodeSet = new Set<String>();
		for (Charge_Log__c chargeLog : chargeLogList) {
			if (chargeLog.Transaction_Code__c != null) {
				transactionCodeSet.add(chargeLog.Transaction_Code__c);
			}
		}
		//Query all Transaction Types that contain the Transaction Codes in the Set
		List<Transaction_Type__c> transactionTypeList = new TransactionTypesSelector().selectByTransactionCode(transactionCodeSet);

		//Add all Price Scheme Ids to the Set to Query Price_Scheme_Entry__c
		Set<Id> priceSchemeIdSet = new Set<Id>();
		for (Price_Scheme__c priceScheme : priceSchemeList) {
			priceSchemeIdSet.add(priceScheme.Id);
		}
		//Add all Transaction Type Ids to the Set to Query Price_Scheme_Entry__c
		Set<Id> transactionTypeIdSet = new Set<Id>();
		for (Transaction_Type__c transactionType : transactionTypeList) {
			transactionTypeIdSet.add(transactionType.Id);
		}
		//Query Price_Scheme_Entry__c
		List<Price_Scheme_Entry__c> priceSchemeEntryList = new PriceSchemeEntriesSelector()
			.selectByPriceSchemeIdAndTransactionTypeId(priceSchemeIdSet, transactionTypeIdSet);

		Map<String, Price_Scheme_Entry__c> priceSchemeEntryToCombiIdMap = new Map<String, Price_Scheme_Entry__c>();
		for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntryList) {
			priceSchemeEntryToCombiIdMap.put(
				String.valueOf(priceSchemeEntry.Price_Scheme__c) + String.valueOf(priceSchemeEntry.Transaction_Type__c),
				priceSchemeEntry
			);
		}
		//Convert to: Map of Price_Scheme__c to Price Scheme Name
		Map<String, List<Price_Scheme__c>> priceSchemeMap = (Map<String, List<Price_Scheme__c>>) Sys_Utilities_General.convertListToMapWithStringKey(
			priceSchemeList,
			'Name'
		);
		//Convert to: Map of Transaction_Type__c to Transaction_Code__c
		Map<String, List<Transaction_Type__c>> transactionCodeMap = (Map<String, List<Transaction_Type__c>>) Sys_Utilities_General.convertListToMapWithStringKey(
			transactionTypeList,
			'Transaction_Code__c'
		);
		//Map to return
		Map<Id, Price_Scheme_Entry__c> priceSchemeEntryToChargeLogId = new Map<Id, Price_Scheme_Entry__c>();
		for (Charge_Log__c chargeLog : chargeLogList) {
			//Get Price_Scheme__c for this Charge_Log__c
			String priceSchemeName = priceSchemeNameToChargeLogIdMap.get(chargeLog.Id);
			if(priceSchemeMap.get(priceSchemeName) != null && transactionCodeMap.get(chargeLog.Transaction_Code__c) != null){
				Price_Scheme__c priceScheme = priceSchemeMap.get(priceSchemeName)[0];
				//Get Transaction_Type__c for this Charge_Log__c
				Transaction_Type__c transactionType = transactionCodeMap.get(chargeLog.Transaction_Code__c)[0];
				//Get Price_Scheme_Entry__c for this Charge_Log__c and add it to the Map to return
				priceSchemeEntryToChargeLogId.put(
					chargeLog.Id,
					priceSchemeEntryToCombiIdMap.get(String.valueOf(priceScheme.Id) + String.valueOf(transactionType.Id))
				);
			}
		}
		return priceSchemeEntryToChargeLogId;
	}
}