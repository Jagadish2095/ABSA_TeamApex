/**@description CrossSellProductsController description
 * Controller for Quoting Process Lightning component
 * @author  Pranav
 * @created 2020-10-26
 */

public without sharing class CrossSellProductsController {
	private static final String QUEUE_DD_INBOUND_NON_ADVICE_NAME = 'DD Non-Advice Inbound';
	private static final String QUEUE_DD_INBOUND_REFERRAL_ADVICE_STI_NAME = 'DD_Referral_Advice_STI';
	private static final String LEAD_STATUS_ALLOCATED = 'Allocated';
	private static final String DD_LEAD_REC_TYPE_DEV_NAME = 'Direct_Delivery_Sales_Lead';
	private static final String STI_LEAD_REC_TYPE_DEV_NAME = 'DD_STI_Lead';
	private static final String FINANCIAL_PRODUCT_CODE_STI = 'STI';

	/**@description getPremiumPlan description
	* Added for Flexi Funneral Functionality  
	* 
	* Method that return Premiums for Law 4 u product

	*@return List<Flexi_Funeral_Relationship_Code__mdt>
	*/
	@AuraEnabled
	public static List<Flexi_Funeral_Relationship_Code__mdt> getPremiumPlan() {
		return [SELECT MasterLabel, Benefit_Level__c, Premium__c FROM Flexi_Funeral_Relationship_Code__mdt WHERE Premium__c != NULL];
	}

	/**@description getproducts description
	 * @param OppId (Id):OppId The opportunity Id to get the product name
	 *
	 * @return List<String> all cross sell products related to the main product
	 */
	@AuraEnabled
	public static List<String> getProducts(Id OppId) {
	List<String> productsToRender = new List<String>();
		System.debug('>>>>>> OppId' + OppId);
		//OpportunitiesSelector oppSelector = new OpportunitiesSelector();
		List<Opportunity> opportunities = [SELECT Id, Product_Interest__r.Name,CampaignId,Campaign.name FROM Opportunity WHERE ID = :oppId];
		if (!opportunities.isEmpty()) {
			String products = [
				SELECT Cross_Sell_Products__c
				FROM Flexi_Funeral_Relationship_Code__mdt
				WHERE Product__c = :opportunities[0].Product_Interest__r.Name
			]
			.Cross_Sell_Products__c;
			System.debug('>>>>>> products' + products);
			productsToRender = products.split(',');
            if(opportunities[0].CampaignId != null){
                for(integer i =0 ;i<productsToRender.size(); i++){
                    if(opportunities[0].Campaign.name.contains('Upgrades') && productsToRender[i].equalsIgnoreCase('flexi funeral')){
                        productsToRender.remove(i);
                    }
                }
            }
		}
		System.debug('>>>>>> productsToRender' + productsToRender);

		return productsToRender;
	}

	/**@description getPricingmatrix description
	 * Method that gets the premium as the cover amount picklist is changed
	 *
	 * @param oppId (Id):oppId
	 * @param planName (String):planName
	 * @param lowestRange (String):lowestRange
	 * @param highestRange (String):highestRange
	 * @param recordType (String):recordType
	 * @return EPP_Pricing_Matrix__c Pricing Matrix for product
	 */
	@AuraEnabled
	public static EPP_Pricing_Matrix__c getPricingMatrix(Id oppId, String planName, String lowestRange, String highestRange, String recordType) {
		if (recordType == 'Credit Life Cover') {
			List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectCreditLifePlanRecordType(planName, recordType);
			System.debug('pricingMatrices' + pricingMatrices);
			if ((!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1)) {
				return pricingMatrices.get(0);
			}
		} else if (recordType == 'Credit Life Discount Fee' || recordType == 'Extended Cover') {
			List<EPP_Pricing_Matrix__c> pricingMatricesDiscount = new PricingMatricesSelector()
				.selectCreditLifeDiscountRecordType(Double.valueOf(String.valueOf(lowestRange)), Double.valueOf(String.valueOf(highestRange)), recordType);
			if ((!pricingMatricesDiscount.isEmpty() && pricingMatricesDiscount != null && pricingMatricesDiscount.size() == 1)) {
				return pricingMatricesDiscount.get(0);
			}
		}
		return null;
	}

	/**
	 * @description deleteOppPartyData description
	 *
	 * @param oppPartyListdelete (list<Opportunity_Party__c>): oppPartyListdelete
	 * @param oppPartyId (Id): oppPartyId
	 * @param roadCover (boolean): roadCover
	 * @param healthAssis (boolean): healthAssis
	 */
	@AuraEnabled
	public static void deleteOppPartyData(list<Opportunity_Party__c> oppPartyListdelete, Id oppPartyId, boolean roadCover, boolean healthAssis) {
		//quote delete
		List<QuoteLineItem> quoteItem = new List<QuoteLineItem>();
		if (oppPartyId != null) {
			if (roadCover) {
				QuoteItem = [
					SELECT id, OpportunityPartyId__c, Benefit__c
					FROM QuoteLineItem
					WHERE OpportunityPartyId__c = :oppPartyId AND Benefit__c = 'Road Cover'
				];
			} else if (healthAssis) {
				QuoteItem = [
					SELECT id, OpportunityPartyId__c, Benefit__c
					FROM QuoteLineItem
					WHERE OpportunityPartyId__c = :oppPartyId AND Benefit__c = 'Health Assistance'
				];
			}
		}
		system.debug('oppPartyListInsert ' + oppPartyListdelete);
		Opportunity_Party__c existOpp = [
			SELECT id, DD_Cross_Sell_Product_Member_Type__c
			FROM Opportunity_Party__c
			WHERE id = :oppPartyId
		];
		list<string> valueList = new List<string>();
		list<string> finalList = new List<string>();
		string finalValues = '';
		list<Opportunity_Party__c> updateopp1 = new List<Opportunity_Party__c>();
		if (existOpp.DD_Cross_Sell_Product_Member_Type__c != null) {
			valueList = existOpp.DD_Cross_Sell_Product_Member_Type__c.split(';');
		}

		for (Opportunity_Party__c op : oppPartyListdelete) {
			if (valueList != null && valueList.size() > 1) {
				if (valueList.contains(op.DD_Cross_Sell_Product_Member_Type__c)) {
					Integer result = valueList.indexOf(op.DD_Cross_Sell_Product_Member_Type__c);
					valueList.remove(result);
					//finalList.addAll(valueList);
					finalValues = string.join(valueList, ';');
					finalValues = finalValues.removeStart(';');
					op.DD_Cross_Sell_Product_Member_Type__c = finalValues;
					updateopp1.add(op);
				}
			} else if (valueList != null && valueList.size() == 1 && valueList.contains(op.DD_Cross_Sell_Product_Member_Type__c)) {
				op.DD_Cross_Sell_Product_Member_Type__c = '';
				updateopp1.add(op);
			}
		}
		list<Opportunity_Party__c> updateopp = new List<Opportunity_Party__c>();
		if (updateopp1.isempty() == false) {
			try {
				database.update(updateopp1);
			} catch (Exception ex) {
				AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'deleteOppPartyData', 'update party data');
			}
		}
		if (oppPartyId != null) {
			if (QuoteItem != null && QuoteItem.size() > 0) {
				try {
					database.delete(QuoteItem);
				} catch (Exception ex) {
					AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'delte quote', 'delete quote data');
				}
			}
		}
	}

	/**@description insertOppPartyData description
	 * Added for Flexi Funneral Functionality
	 *
	 * Method that upsert a list of all specific opportunity parties
	 *
	 *
	 * @param oppPartyList (List<Opportunity_Party__c>):oppPartyList
	 * @return List<Opportunity_Party__c>
	 */
	@AuraEnabled
	public static List<Opportunity_Party__c> insertOppPartyData(List<Opportunity_Party__c> oppPartyList) {
		set<id> oppPartyId = new Set<id>();
		for (Opportunity_Party__c opp : oppPartyList) {
			if (opp.id != null) {
				oppPartyId.add(opp.id);
			}
		}
		//querying existing values from multipikclist field which is used to append new values
		list<Opportunity_Party__c> opportunityPartyList = [
			SELECT Id, DD_Cross_Sell_Product_Member_Type__c
			FROM Opportunity_Party__c
			WHERE Id IN :oppPartyId
		];
		Map<id, Opportunity_Party__c> opportunityPartyMap = new Map<id, Opportunity_Party__c>(); // to hold id, oppparty data

		for (Opportunity_Party__c op : opportunityPartyList) {
			opportunityPartyMap.put(op.id, op);
		}

		List<Opportunity_Party__c> oppPartyIsset = new List<Opportunity_Party__c>();
		List<Opportunity_Party__c> oppPartyUpdate = new List<Opportunity_Party__c>(); // used to update the oppparty with new values

		system.debug('oppPartyList ' + oppPartyList);
		for (Opportunity_Party__c oppParty : oppPartyList) {
			if (oppParty.id != null && opportunityPartyMap.containskey(oppParty.id)) {
				if (
					opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c != null &&
					opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c.contains(oppParty.DD_Cross_Sell_Product_Member_Type__c) == false
				) {
					oppParty.DD_Cross_Sell_Product_Member_Type__c =
						oppParty.DD_Cross_Sell_Product_Member_Type__c +
						';' +
						opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c;
					oppPartyUpdate.add(oppParty);
				} else if (
					opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c != null &&
					opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c.contains(oppParty.DD_Cross_Sell_Product_Member_Type__c) == true
				) {
					oppParty.DD_Cross_Sell_Product_Member_Type__c = opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c;
					oppPartyUpdate.add(oppParty);
				} else if (opportunityPartyMap.get(oppParty.id).DD_Cross_Sell_Product_Member_Type__c == null) {
					// added on 12-11-2020
					oppParty.DD_Cross_Sell_Product_Member_Type__c = oppParty.DD_Cross_Sell_Product_Member_Type__c;
					oppPartyUpdate.add(oppParty);
				}
			} else {
				oppPartyUpdate.add(oppParty);
			}
		}
		system.debug('oppPartyUpdate ' + oppPartyUpdate);
		if (oppPartyUpdate != null) {
			List<Database.upsertResult> upsertResult = database.upsert(oppPartyUpdate);
			system.debug('upsertResult ' + upsertResult);
			for (Database.upsertResult result : upsertResult) {
				if (result.isSuccess() && result.getId() != null) {
					oppPartyId.add(result.getId());
					//oppPartyIsset.add(getSingleParty(result.getId()));
				} else {
					system.debug('error' + result.getErrors());
				}
			}
		}
		oppPartyIsset = getSingleParty(oppPartyId);
		return oppPartyIsset;
	}

	/**@description getSingleParty description
	 * Method that gets a single specific opportunity party
	 *
	 * @param oppPartyId (set<Id>):oppPartyId
	 * @return list<Opportunity_Party__c>
	 */
	//@AuraEnabled
	public static list<Opportunity_Party__c> getSingleParty(set<Id> oppPartyId) {
		List<Opportunity_Party__c> opportunityParty = new OpportunityPartiesSelector().selectByOpportunityPartyIdSet(oppPartyId);

		return opportunityParty;
	}

	/**@description getPartyData description
	 * Added for Flexi Funneral Functionality
	 * Method that gets a list of all specific opportunity pareties
	 * @param oppId (Id)- opportunity Id
	 * @return List<Opportunity_Party__c>
	 */
	@AuraEnabled
	public static List<Opportunity_Party__c> getPartyData(Id oppId) {
		List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityId(oppId);
		return opportunityParties;
	}

	/**@description fetchOpportunityRecord description
	 * Method that gets opportunity details
	 * @param oppId (Id):oppId - opportunity Id
	 * @return List<Opportunity> - opportunity details
	 */
	@AuraEnabled
	public static List<Opportunity> fetchOpportunityRecord(Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		if (!opportunities.isEmpty() && opportunities != null) {
			return opportunities;
		}
		return null;
	}

	/**@description getQuoteData description
	 * Method that gets opportunity details
	 * @param oppId (Id):oppId
	 * @return List<quote> - opportunity details
	 */
	@AuraEnabled
	public static List<quote> getQuoteData(Id oppId) {
		List<quote> quotes = new QuotesSelector().selectQuoteByOpportunityId(oppId);
		if (!quotes.isEmpty() && quotes != null) {
			return quotes;
		}
		return null;
	}

	/**@description getQuoteData1 description
	 * Method that gets opportunity details
	 * @param oppId (Id):oppId - opportunity Id
	 * @param productName
	 * @return List<Opportunity> - opportunity details
	 */
	@AuraEnabled
	public static List<quote> getQuoteData1(Id oppId, string productName) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
		List<quote> quotes = new QuotesSelector().selectByProductName(oppId, productName);
		if (!quotes.isEmpty() && quotes != null) {
			return quotes;
		}
		return null;
	}

	/**@description Search Client in Salesforce based on Name description
	 * @param  searchValue (string):searchValue
	 * @return List<Account>
	 */
	@AuraEnabled
	public static list<Account> getAccountData(string searchValue) {
		list<Account> accountsList = new List<Account>();
		String clientProfilesBean;
		String searchTypeForCIF = 'identityDocument';
		if (searchValue != null) {
			accountsList = new AccountsSelector().searchByValueOnAllFields(searchValue, 1);
			//clientProfilesBean=ClientFinderBase.getAdapt360ClientBean(searchTypeForCIF,searchValue);
		}
		return accountsList;
	}

	/**@description Poulami-- Added for DD quote to fetch only specific Line Items description
	 * Method that gets specific line item added to quote
	 * @param oppId (Id):oppId - opportunity Id
	 * @param partyType (String):partyType - Party Type like Main Member,Spouse
	 * @param productName (String):productName - Product Name
	 * @return List<QuoteLineItem> - products
	 */
	@AuraEnabled
	public static List<QuoteLineItem> getQuoteLineItemsData(Id oppId, String partyType, String productName) {
        //List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
		List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
		Id prodId = new ProductsSelector().selectByName(productName, 1).id;
		if (!quotes.isEmpty() && quotes != null) {
			List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(quotes.get(0).Id, partyType, prodId);
			if (!quoteLineItems.isEmpty() && quoteLineItems != null) {
				return quoteLineItems;
			}
		}
		return null;
	}

	/**
	 * @description getQuoteLineItemsDataByProduct description
	 *
	 * @param oppId (Id): oppId
	 * @param productName (String): productName
	 * @return Return List<QuoteLineItem>: Return description
	 */
	@AuraEnabled
	public static List<QuoteLineItem> getQuoteLineItemsDataByProduct(Id oppId, String productName) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
		List<Quote> quotes = new QuotesSelector().selectByProductName(oppId, productName);
		if (!quotes.isEmpty() && quotes != null) {
			List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectByQuoteId(quotes.get(0).Id);
			if (!quoteLineItems.isEmpty() && quoteLineItems != null) {
				return quoteLineItems;
			}
		}
		return null;
	}

	/**@description dataload description
	 * Inner data class
	 * <p>
	 * Inner data class that stores the
	 * line items values
	 * of a Quote and Opportunity for Direct Delivery
	 */
	public class DataLoad {
		public String Name;
		public Double premium;
		public String SumInsured;
		public String OppPartyId;
	}

	/**@description createDDQuote description
	 * Method that creates a new Direct Delivery quote by given parameters
	 *
	 * @param oppId (Id):oppId - opportunity Id
	 * @param totalPremium (String):totalPremium - total premium amount
	 * @param product (String):product -  product to quote
	 * @param lineItems (String):lineItems
	 * @param partyType (String):partyType
	 * @param description (String):description
	 * @param spouseChecked (Boolean):spouseChecked
	 * @param childChecked (Boolean):childChecked
	 * @param extendedFamilyChecked (Boolean):extendedFamilyChecked
	 * @param oppData (oppData):oportunity
	 * @param quoteStatus (String):quoteStatus
	 */
	@AuraEnabled
	public static void createDDQuote(
		Id oppId,
		String totalPremium,
		String product,
		String lineItems,
		String partyType,
		String description,
		Boolean spouseChecked,
		Boolean childChecked,
		Boolean extendedFamilyChecked,
		opportunity oppData,
		String quoteStatus
	) {
		List<DataLoad> lineItem = (List<DataLoad>) System.JSON.deserialize(lineItems, List<DataLoad>.class);
		List<Database.SaveResult> srList = new List<Database.SaveResult>();
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		Id prodId = new ProductsSelector().selectByName(product, 1).id;
		Id quoteId;
		List<Pricebook2> priceBooks = new PriceBooksSelector().selectByName('Standard Price Book');
		
		if (!opportunities.isEmpty() && opportunities != null) {
			Boolean quoteAlreadyAdded = false;
			if (opportunities.get(0).SyncedQuoteId != null) {
				quoteAlreadyAdded = true;
			}

			List<Quote> quotes = new QuotesSelector().selectByProductName(oppId, product);
			if (!quotes.isEmpty() && quotes != null) {
				List<QuoteLineItem> quoteLineItemsbyParty = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(quotes.get(0).Id, partyType, prodId);
				if (!quoteLineItemsbyParty.isEmpty() && quoteLineItemsbyParty != null) {
					try {
						delete quoteLineItemsbyParty;
					} catch (Exception ex) {
						AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete Quote');
					}
				}
			}
			List<QuoteLineItem> quoteLineItems = getQuoteLineItemsDataByProduct(oppId, product);
			//Create and Insert Quote
			if (quotes.isEmpty() || quotes == null) {
				Quote quote = new Quote();
				quote.OpportunityId = oppId;
				if (!Test.isRunningTest()) {
					quote.Pricebook2Id = priceBooks.get(0).id;
				} else {
					quote.Pricebook2Id = Test.getStandardPricebookId();
				}
				quote.Description = product;
				quote.Product_Name__c = product;
				quote.Name = product;
				quote.Quote_Outcome__c = oppData.Quote_Outcome__c; //added by pranv
				quote.Quote_Outcome_Reason__c = oppData.Quote_Outcome_Reason__c; //added by pranv
				quote.Status = quoteStatus;
				try {
					insert quote;
					quoteId = quote.id;
				} catch (Exception ex) {
					AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote');
				}
			} else {
				quoteId = quotes.get(0).Id;
				quotes.get(0).Material_Disclosure_Status__c = 'New';
				quotes.get(0).Quote_Outcome__c = oppData.Quote_Outcome__c; //added by pranv
				quotes.get(0).Quote_Outcome_Reason__c = oppData.Quote_Outcome_Reason__c; //added by pranv
				quotes.get(0).Status = quoteStatus;
			}
			try {
				//Create Each Quote Line Item if Applicable
				if (quoteLineItems == null) {
					quoteLineItems = new List<QuoteLineItem>();
				}

				List<QuoteLineItem> quoteItem = new List<QuoteLineItem>();
				for (Integer i = 0; i < lineItem.size(); i++) {
					QuoteLineItem quoteLineItem = new QuoteLineItem();
					quoteLineItem.QuoteId = quoteId;
					quoteLineItem.Product2Id = prodId;
					quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName(product, 1).id;
					quoteLineItem.Quantity = 1;
					quoteLineItem.Benefit__c = lineItem.get(i).Name;
					quoteLineItem.OpportunityPartyId__c = lineItem.get(i).OppPartyId;
					quoteLineItem.Relationship_Type__c = partyType;
					quoteLineItem.Policy_Cover__c = Double.valueOf(lineItem.get(i).SumInsured);
					quoteLineItem.Premium__c = Double.valueOf(lineItem.get(i).premium);
					quoteLineItem.UnitPrice = Double.valueOf(lineItem.get(i).premium);
					quoteLineItems.add(quoteLineItem);
				}

				try {
					if (quoteLineItems.size() > 0) {
						upsert quoteLineItems;
					}
				} catch (DmlException e) {
					System.debug(e.getMessage());
				}
			} catch (Exception ex) {
				AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote line item');
			}
			//added by pranav for credit life Product on 26-01-2021
			if (oppData != null) {
				opportunities.get(0).CreditLife_Plans__c = oppData.CreditLife_Plans__c;
				opportunities.get(0).Absa_Staff_Member__c = oppData.Absa_Staff_Member__c;
				opportunities.get(0).Card_Life_Plan__c = oppData.Card_Life_Plan__c;
				opportunities.get(0).Secondary_Life__c = oppData.Secondary_Life__c;
				opportunities.get(0).Commission__c = oppData.Commission__c;
				opportunities.get(0).Intial_Loan_Amount__c = oppData.Intial_Loan_Amount__c;
				opportunities.get(0).DD_PhotoFinishSelected__c = oppData.DD_PhotoFinishSelected__c;
				opportunities.get(0).Intial_Loan_Amount__c = oppData.Intial_Loan_Amount__c;
				opportunities.get(0).DD_Premium__c = oppData.DD_Premium__c;
				opportunities.get(0).DD_Additional_Cover_Selected__c = oppData.DD_Additional_Cover_Selected__c;
				opportunities.get(0).Photo_Finish_Premium__c = oppData.Photo_Finish_Premium__c;
			}
			//---end
			if (product == 'STI' && quoteStatus != 'Accepted') {
				opportunities.get(0).StageName = 'Closed';
			} else {
				opportunities.get(0).StageName = 'In Progress';
			}
			opportunities.get(0).SyncedQuoteId = quoteId;
			if (spouseChecked == true || childChecked == true || extendedFamilyChecked == true) {
				opportunities.get(0).Quote_on_Spouse__c = spouseChecked;
				opportunities.get(0).Quote_on_Child__c = childChecked;
				opportunities.get(0).Quote_on_Extended_Family__c = extendedFamilyChecked;
			}
			if (quoteAlreadyAdded) {
				opportunities.get(0).Material_Disclosure_Status__c = 'Incomplete';
			}
			try {
				//if (Schema.sObjectType.Contact.isDeletable()) {

				update opportunities;
				update quotes;
			} catch (Exception ex) {
				AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Update opportunity');
			}
		}
	}

	/**@description submitPolicy description
	 * @param policy (String):policy
	 * @param opportunityId (Id):opportunityId
	 * @param coverAmount (String):coverAmount
	 * @param chosenProduct (String):chosenProduct
	 * @return Integer
	 * Param 1: policy in JSON structure
	 * Param 2: opportunityId is our Opportunity Id from the Autolaunched Flow
	 * Param 3: coverAmount - cover amount chosen
	 * Param 4: chosenProduct - what product chosen i.e. Estate Bridging
	 */
	@AuraEnabled
	public static Integer submitPolicy(String policy, Id opportunityId, String coverAmount, String chosenProduct) {
		System.debug('Inside submitPolicy');
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(opportunityId);
		if (!Sys_Utilities_General.isListBlank(opportunities)) {
			Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
			if (account != null) {
				List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);

				WBIF_IB_String_v1 policyResponse = WBIF_IH_v1.wbifPolicyCreate(users.get(0), account, opportunities.get(0));
                /**
                 * @description debug description
                 *
                 * @param statusCode ('WBIFPolicyStatusCode:'+policyResponse.): statusCode
                 * @return Return System.: Return description
                 */
				System.debug('WBIF Policy Status Code: ' + policyResponse.statusCode);

				WBIF_IB_String_v1 wbifResponse = WBIF_IH_v1.getWBIFSubmitPolicy(users.get(0), account, opportunities.get(0));
				System.debug('WBIF Submit Response: ' + wbifResponse);
				System.debug('WBIF Submit Status Code: ' + wbifResponse.statusCode);
				return wbifResponse.statusCode;
			}
		}

		return null;
	}

	/**@description getpolicy description
	 * @param oppId (Id):oppId
	 * @return String
	 * Method that gets the policy and stores it as a session variable
	 * Return value to be used in WBIF calculate calls for member and spouse premium
	 * Param 1: opportunityId is our Opportunity Id from the Autolaunched Flow
	 */

	@AuraEnabled
	public static String getPolicy(Id oppId) {
		String strResp = QuotingProcessController.getPolicy(oppId);
		return strResp;
	}

/**
 * @description getMemberPremiumWbif description
 *
 * @param policy (String): policy
 * @param oppId (Id): oppId
 * @param sumInsured (String): sumInsured
 * @param recordType (String): recordType
 * @return Return Double: Return description
 */
	@AuraEnabled
	public static Double getMemberPremiumWbif(String policy, Id oppId, String sumInsured, String recordType) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		if (!opportunities.isEmpty() && opportunities != null) {
			Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
			if (recordType == 'Death and Accidental Disability') {
				Double sumIns = Double.valueOf(String.valueOf(sumInsured));
				Double newAge = account.Age__pc + 1;
				Double age = Math.floor(newAge);
				Map<String, String> productCodeMap = new Map<String, String>();
				productCodeMap.put('U01_U03', sumInsured);
				WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1) JSON.deserialize(policy, WBIF_IB_String_v1.class);
				WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, null, null);
				if (resp != null && resp.statusCode == 200) {
					return Double.valueOf(resp.CalculateResponse.CalculateResult.MainMember.Premium);
				} else {
					return null;
				}
			} else if (recordType == 'Accidental Death Benifit and Accidental Disability') {
				Double sumIns = Double.valueOf(String.valueOf(sumInsured));
				Double newAge = account.Age__pc + 1;
				Double age = Math.floor(newAge);
				Map<String, String> productCodeMap = new Map<String, String>();
				productCodeMap.put('U02_U03', sumInsured);
				WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1) JSON.deserialize(policy, WBIF_IB_String_v1.class);
				WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, null, null);
				if (resp != null && resp.statusCode == 200) {
					return Double.valueOf(resp.CalculateResponse.CalculateResult.MainMember.Premium);
				} else {
					return null;
				}
			}
		}
		return null;
	}

	/**@description getselectOptions description
	 * Method that gets all picklist data
	 * @param objObject (sObject) - Id of the specific opportunity party being removed
	 * @param fld (String) - field name i.e. Clause_Name__c
     * @return List<String>
	 */
	@AuraEnabled
	public static List<String> getselectOptions(sObject objObject, string fld) {
		List<String> allOpts = new List<String>();
		Schema.sObjectType objType = objObject.getSObjectType();
		Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
		map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
		list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
		for (Schema.PicklistEntry a : values) {
			allOpts.add(a.getValue().replaceAll('\\s', ''));
		}
		//allOpts.sort();
		return allOpts;
	}

	/**@description getPolicyFee description
	 * Method that gets the policy fee from the pricing matrix
	 * This is extra overhead but prevents hardcoding the policy fee (usually R10.00)
	 *
	 * @return Double - policy fee
	 */
	@AuraEnabled
	public static Double getPolicyFee() {
		List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectByRecordTypeName('Policy Fee', 1);
		if (!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1) {
			return pricingMatrices.get(0).Premium__c;
		}
		return null;
	}

	/**@description checkAccountValid description
	 * Method that get the maximum age for a spouse
	 *
	 * @param oppId (Id) - opportunity Id
	 * @return Decimal - maximum age
	 */
	@AuraEnabled
	public static String checkAccountValid(Id oppId) {
		Boolean validAccount = true;
		String inValidMultiReason = 'The following fields are blank and are required for quorting ';
		String inValidSingleReason = 'The following field is blank and is required for quorting ';
		String fields = '';
		Integer numberOfFields = 0;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
		if (!opportunities.isEmpty() && opportunities != null) {
			Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
			if (account.Country_of_Birth__pc == null) {
				fields = fields + ', Country of Birth';
				validAccount = false;
				numberOfFields++;
			}
			if (account.Country_of_Residence__pc == null) {
				fields = fields + ', Country of Residence';
				validAccount = false;
				numberOfFields++;
			}
			if (account.Nationality__pc == null) {
				fields = fields + ', Nationality';
				validAccount = false;
				numberOfFields++;
			}
			if (account.Age__pc == null) {
				fields = fields + ', Age';
				validAccount = false;
				numberOfFields++;
			}
			if (account.Income_Source__pc == null) {
				fields = fields + ', Income Source';
				validAccount = false;
				numberOfFields++;
			}
			if (account.CIF__c == null) {
				fields = fields + ', CIF';
				validAccount = false;
				numberOfFields++;
			}
			if (numberOfFields > 1) {
				fields = inValidMultiReason + fields;
			} else {
				fields = inValidSingleReason + fields;
			}
			fields = fields + '.';
		}
		if (validAccount) {
			return 'Valid';
		} else {
			return fields;
		}
	}
	/**@description casacheck description
	 * Method that get the maximum age for a spouse
	 *
	 * @param oppId (Id) - opportunity Id
	 * @return Decimal - maximum age
	 */
	@AuraEnabled
	public static String casaCheck(Id oppId) {
		Boolean validAccount = true;
		String inValidSingleReason = 'Please finish the CASA and Risk Rating before proceeding to Quote ';
		String fields = '';
		Integer numberOfFields = 0;
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		if (!opportunities.isEmpty() && opportunities != null) {
			//Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
			system.debug('****' + opportunities[0].Account.CASA_Reference_Number__pc);
			system.debug('&&&& ' + opportunities[0].Risk_Rating__c);
			if (opportunities[0].Account.CASA_Reference_Number__pc == null) {
				//fields = fields+', Country of Birth';
				validAccount = false;
				numberOfFields++;
			}
			if (opportunities[0].Risk_Rating__c == null) {
				//fields = fields+', Country of Birth';
				validAccount = false;
				numberOfFields++;
			}

			if (numberOfFields > 1) {
				fields = inValidSingleReason;
			} else {
				fields = inValidSingleReason;
			}
			fields = fields + '.';
		}
		if (validAccount) {
			return 'Valid';
		} else {
			return fields;
		}
	}
	/**@description calculateOpportunityPartyAge description
	 * Method that calculates Opportunity Party Age before data is stored
	 *
	 * @param dateOfBirth (String)
	 * @return Integer
	 */
	@AuraEnabled
	public static Integer calculateOpportunityPartyAge(String dateOfBirth) {
		Integer age = 0;
		Date birthDate = Date.valueOf(dateOfBirth);

		Integer temp = birthDate.daysBetween(Date.Today());
		age = Integer.valueOf(temp / 365);

		return age;
	}

/**
 * @description pushToPortal description
 *
 * @param oppId (Id): oppId
 * @return Return String: Return description
 */
	@AuraEnabled
    public static String pushToPortal(Id oppId) {
       	string message  = ShortTermInsurancePushLead.PushToPortal(oppId);
        return message;
    }
    
    /**
	 * @description pushToWebsure description
	 *
	 * @param oppId (Id): oppId
	 * @return Return String: Return description
	 */
	@AuraEnabled
    public static String pushToWebsure(Id oppId) {
       	WebsureGetToken_Resp_IB_v1 webresponseBean = WebsureGetToken_IH_v1.WebsureGetToken();
        if(webresponseBean.ReturnCode == 0 && webresponseBean.ReturnMessage == 'Success'){
            String websureURL = 'https://br04.websure.co.za';
            String websurecontent = '?'+'pagename='+EncodingUtil.urlEncode('GlbMenuFrames', 'UTF-8')+'&token='+EncodingUtil.urlEncode(webresponseBean.Token, 'UTF-8')+'&Product='+EncodingUtil.urlEncode('Websure', 'UTF-8')+'&SearchStr='+EncodingUtil.urlEncode('8311235241083', 'UTF-8')+'&ClientId='+EncodingUtil.urlEncode('1-RMDBXC', 'UTF-8')+'&System='+EncodingUtil.urlEncode('Siebel', 'UTF-8');
        	String websureURLPost = websureURL+'/scripts/absauat.dll'+websurecontent;
            System.debug('websureURLPost'+websureURLPost);
            return websureURLPost;
        }
        else
        	return null;
    }

	/**@description updateOpportunity description
	 * Aded by praanav on 16032021
	 * @param opprecord (Opportunity)
	 * @param oppId (Id)
	 */
	@AuraEnabled
	public static void updateOpportunity(Opportunity opprecord, Id oppId) {
		List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
		if (!opportunities.isEmpty() && opportunities != null) {
			opportunities.get(0).STI_Policy_Number__c = opprecord.STI_Policy_Number__c;
			opportunities.get(0).Policy_Inception_Date__c = opprecord.Policy_Inception_Date__c;
			opportunities.get(0).Product_Provider__c = opprecord.Product_Provider__c;
			opportunities.get(0).Policy_Income_Type__c = opprecord.Policy_Income_Type__c;
            opportunities.get(0).StageName = 'Quote';
			try {
				update opportunities;
			} catch (Exception ex) {
				AuditTrailLog.logException(ex, 'New', 'Error', 'CrossSellProductsController', 'UpdateOpp', 'Update opportunity');
			}
		}
	}
    
    /**
	 * @description retrievePriNumber description
	 *
	 * @param oppId (Id): oppId
	 * @return Return String: Return description
	 */
	@AuraEnabled
	public static String retrievePriNumber(Id oppId) {
		PRICreationByCommSystem_Resp_IB_v1 prinumber = PRICreationByCommSystem_IH_v1.GetPRIforAtowrk(oppId);
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        if(prinumber.PRIResponses.size() > 0){            
            if (!opportunities.isEmpty() && opportunities != null) {
                if(opportunities[0].Opportunity_Record_Type_Name__c == 'DD STI Opportunity'){
                    opportunities.get(0).PRI_Number__c = prinumber.PRIResponses[0].PRIResponse.PRINumber;
					try {
						update opportunities;
                        updateOpportunity(opportunities[0],oppId);
					} catch (Exception ex) {
						AuditTrailLog.logException(ex, 'New', 'Error', 'CrossSellProductsController', 'UpdateOpp', 'Update opportunity');
					}
                }
            }
            return String.valueof(prinumber.PRIResponses);
        }
        else
            return null;
	}


	/**@description Method to set the lead details and assign to campaign description
	 * @param leadRecord (Lead) the lead record to be passed
	 * @param relatedClient (Account) the account related to the lead
	 * @param financialProductRecord (Financial_Product__c) the financial product selected by the user
	 * @param isReferral (Boolean) if this is a referral lead or not
	 * @param campaignName (String) the campaign to link the lead to
	 * @param userOrQueue (Id) route the lead to a queue
	 * @author Minal (Bsky)
	 * @date 2021-01-19
	 * @return lead record
	 */
	@AuraEnabled
	public static Lead createNewDDLead(
		Lead leadRecord,
		Account relatedClient,
		Financial_Product__c financialProductRecord,
		Boolean isReferral,
		String campaignName,
		Id userOrQueue
	) {
		CampaignMember leadCampaignMember = new CampaignMember();
		List<Campaign> campaigns = new List<Campaign>();
		Map<String, Schema.RecordTypeInfo> leadRecordTypeMap = Lead.SObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		List<Group> allQueues = new List<Group>();
        List<Flexi_Funeral_Relationship_Code__mdt> ddSettings = new List<Flexi_Funeral_Relationship_Code__mdt>();
		//Check if this is a referral lead
		if (isReferral) {
			system.debug('campaignName@@' + campaignName);
			campaigns = [SELECT Id, Name FROM Campaign WHERE Name LIKE :+'%' + campaignName + '%' LIMIT 1];
			if (!campaigns.isEmpty()) {
				system.debug('campaignName@@' + campaignName);
				List<Referral_Setting__mdt> allReferralSettings = [
					SELECT Id, Lead_Record_Type_Developer_Name__c, Campaign_Name__c, Queue_Developer_Name__c, Financial_Product_Name__c
					FROM Referral_Setting__mdt
					WHERE Campaign_Name__c = :campaignName
					LIMIT 1
				];
				if (!allReferralSettings.isEmpty()) {
					//added by divya

					if (userOrQueue == null) {
						allQueues = [SELECT Id FROM Group WHERE DeveloperName = :allReferralSettings[0].Queue_Developer_Name__c LIMIT 1];
						if (!allQueues.isEmpty()) {
							userOrQueue = allQueues[0].Id;
						}
					}

					if (allReferralSettings[0].Lead_Record_Type_Developer_Name__c != null) {
						leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName()
							.get(allReferralSettings[0].Lead_Record_Type_Developer_Name__c)
							.getRecordTypeId();
					}
					if (String.isNotBlank(allReferralSettings[0].Financial_Product_Name__c)) {
						List<Financial_Product__c> financialProducts = [
							SELECT Id, Name
							FROM Financial_Product__c
							WHERE Name = :allReferralSettings[0].Financial_Product_Name__c
							LIMIT 1
						];
						if (!financialProducts.isEmpty()) {
							leadRecord.Financial_Product__c = financialProducts[0].Id;
						}
						leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName()
							.get(allReferralSettings[0].Lead_Record_Type_Developer_Name__c)
							.getRecordTypeId();
					}
				} /*else{ 

                    List<Direct_delivery_campaigns__mdt> ddcampaigns = [SELECT Id,Label,DeveloperName,Lead_Record_Type_Developer_Name__c, Opportunity_Record_Type_Developer_Name__c, Queue_Developer_Name__c FROM Direct_delivery_campaigns__mdt WHERE Campaign_Name__c = :campaignName LIMIT 1];
                    allQueues = [SELECT Id FROM Group WHERE DeveloperName = :ddcampaigns[0].Queue_Developer_Name__c LIMIT 1];
                    if(ddcampaigns[0].Lead_Record_Type_Developer_Name__c != null){
                        leadRecord.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(ddcampaigns[0].Lead_Record_Type_Developer_Name__c).getRecordTypeId();
                    }
                }*/

				leadCampaignMember.CampaignId = campaigns[0].Id;
			} else {
				throw new AuraHandledException('There are no campaigns named ' + campaignName);
			}
		} 
        else {
                //Check if there is a campaign associated to the financial product based on custom metadata setting, if there is then associate the campaign to the lead
				ddSettings = [
					SELECT Id, Inbound_Campaign_Name__c
					FROM Flexi_Funeral_Relationship_Code__mdt
					WHERE Product__c = :financialProductRecord.Name
					LIMIT 1
				];
			if (!ddSettings.isEmpty()) {
				campaigns = [SELECT Id, Name FROM Campaign WHERE Name = :ddSettings[0].Inbound_Campaign_Name__c LIMIT 1];
				if (!campaigns.isEmpty()) {
					leadCampaignMember.CampaignId = campaigns[0].Id;
				}
			}
		}

		//Assign to user or queue
		if (userOrQueue != null) {
			leadRecord.OwnerId = userOrQueue;

			if (String.valueOf(userOrQueue).startsWith('005')) {
				leadRecord.Status = LEAD_STATUS_ALLOCATED;
			}
		} else {
			//Default to the inbound queue
			List<Group> directDeliveryQueue = new GroupsSelector().selectByNameAndType(QUEUE_DD_INBOUND_NON_ADVICE_NAME, 'Queue');
			if (!directDeliveryQueue.isEmpty()) {
				leadRecord.OwnerId = directDeliveryQueue[0].Id;
			}
		}

		//Link related account to lead
		if (relatedClient != null) {
			leadRecord.FinServ__RelatedAccount__c = relatedClient.Id;
		}

		//Set other lead fields
		leadRecord.Is_inbound__c = true;

		//Check financialProduct parameter
		if (leadRecord.Financial_Product__c == null) {
			leadRecord.Financial_Product__c = financialProductRecord != null ? financialProductRecord.Id : null;
		}

		if (leadRecord.RecordTypeId == null) {
			if (financialProductRecord.Name == 'STI') {
				leadRecord.RecordTypeId = leadRecordTypeMap.get(STI_LEAD_REC_TYPE_DEV_NAME).getRecordTypeId();
			} else {
				leadRecord.RecordTypeId = leadRecordTypeMap.get(DD_LEAD_REC_TYPE_DEV_NAME).getRecordTypeId();
			}
		}

		try {
			insert leadRecord;
			System.debug('Id of Lead >>>>>>>>>>' + leadRecord.Id);

			//Check if campaign is found for a product and insert campaign member
			if (!campaigns.isEmpty()) {
				leadCampaignMember.LeadId = leadRecord.Id;
				insert leadCampaignMember;
			}
		} catch (Exception ex) {
			System.debug('There was an error creating the Lead - ' + ex.getMessage());
			AuditTrailLog.logException(ex, 'New', 'Error', 'LeadOverrideController', 'createNewDirectDeliveryLead', 'Trying to insert new DD lead');
			throw new AuraHandledException(ex.getMessage());
		}

		return leadRecord;
	}
}