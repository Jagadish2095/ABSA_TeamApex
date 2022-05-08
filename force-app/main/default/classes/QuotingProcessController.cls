/**
* Controller for Quoting Process Lightning component
* @author  Kyle Alexander
* @created 2018-10-11
*/
public class QuotingProcessController {
    
    
    /**
	* Method that gets opportunity details
	* @param oppId - opportunity Id
	* @return List<Opportunity> - opportunity details
	*/
    @AuraEnabled
    public static List<quote> getQuoteData(Id oppId) {
        List<quote> quotes = new QuotesSelector().selectQuoteByOpportunityId(oppId);
        if(!quotes.isEmpty() && quotes != null){
            return quotes;
        }
        return null;
    }

    /**
	* Method that gets opportunity details
	* @param oppId - opportunity Id
	* @return List<Opportunity> - opportunity details
	*/
    @AuraEnabled
    public static List<quote> getQuoteDatawithoutchilds(Id oppId,string productName) {
        List<quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
        if(!quotes.isEmpty() && quotes != null){
            return quotes;
        }
        return null;
    }
    /**
     * Method that checks if spouse was added to a quote
     *
     * @param oppId - opportunity Id
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static Boolean checkIfSpouseAdded(Id oppId) {
        List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId, 'Spouse');
        if(!opportunityParties.isEmpty() && opportunityParties != null){
            return true;
        }
        return false;
    }

     /**
     * Method that gets the minimum age for a spouse
     *
     * @param oppId - opportunity Id
     * @return Decimal - minimum age
     */
    @AuraEnabled
    public static Decimal getSpouseMinAge(Id oppId) {
        //Get min age and max age from metadata
        List<General_Rules__mdt> eppSpouseInfoList = new  GeneralRulesCustomMdtSelector().selectByLabelandProduct('EPP Spouse', 'Estate Provider Plan');
        General_Rules__mdt rulesMdt = new General_Rules__mdt();
        Decimal minAge = null;
        if (!eppSpouseInfoList.isEmpty() && eppSpouseInfoList != null) {
            rulesMdt = eppSpouseInfoList.get(0);
            minAge = eppSpouseInfoList.get(0).Minimum_Age__c;
        } else {
            AuditTrailLog.logException(null, 'New', 'Error', 'QuotingProcessController', 'getSpouseMinAge', 'GeneralRulesCustomMdtSelector().selectByLabelandProduct("EPP Spouse", "Estate Provider Plan") returned no results but should check if GeneralRulesCustomMdt values exist.');
        }
        return minAge;
    }

    /**
     * Method that get the maximum age for a spouse
     *
     * @param oppId - opportunity Id
     * @return Decimal - maximum age
     */
    @AuraEnabled
    public static Decimal getSpouseMaxAge(Id oppId) {
        //Get min age and max age from metadata
        List<General_Rules__mdt> eppSpouseInfoList = new  GeneralRulesCustomMdtSelector().selectByLabelandProduct('EPP Spouse', 'Estate Provider Plan');
        General_Rules__mdt rulesMdt = new General_Rules__mdt();
        Decimal maxAge = null;
        if (!eppSpouseInfoList.isEmpty() && eppSpouseInfoList != null) {
            rulesMdt = eppSpouseInfoList.get(0);
            maxAge = eppSpouseInfoList.get(0).Maximum_Age__c;
        } else {
            AuditTrailLog.logException(null, 'New', 'Error', 'QuotingProcessController', 'getSpouseMinAge', 'GeneralRulesCustomMdtSelector().selectByLabelandProduct("EPP Spouse", "Estate Provider Plan") returned no results but should check if GeneralRulesCustomMdt values exist.');
        }
        return maxAge;
    }

    /**
     * Method that gets the spouses date of birth that was added during quote process
     *
     * @param oppId - opportunity Id
     * @return Date - spouses birthdate
     */
    @AuraEnabled
    public static Date getSpouseDOB(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if(!opportunities.isEmpty() && opportunities != null){
            return opportunities.get(0).Spouse_Date_of_Birth__c;
        }
        return null;
    }

    /**
     * Method that gets the total premium from quote
     *
     * @param oppId - opportunity Id
     * @return String - total premium
     */
    @AuraEnabled
    public static String getTotalQuoteData(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty() && quotes != null){
            return String.valueOf(quotes.get(0).GrandTotal.setScale(0));
        }
        return null;
    }

    /**
     * Method that gets every product added to quote
     *
     * @param oppId - opportunity Id
     * @return List<QuoteLineItem> - products
     */
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemsData(Id oppId) {
        List<Opportunity> oppRecord = fetchOpportunityRecord(oppId);
        if(oppRecord[0].Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity'){
           List<QuoteLineItem> quoteLineItems = getQuoteLineItemsDataByProduct(oppId,'Flexi Funeral');
           return quoteLineItems; 
        }
        else{
            List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        	if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectByQuoteId(quotes.get(0).Id);
            if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                return quoteLineItems;
            }
          }
        }
        
        return null;
    }
    
    /**
     * Method that gets every product added to quote
     *
     * @param oppId - opportunity Id
     * @return List<QuoteLineItem> - products
     */
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemsDataByProduct(Id oppId,String productName) {
        
        List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,productName);
        if(!quotes.isEmpty() && quotes != null){
            List<QuoteLineItem> quoteLineItems = new QuoteLineItemsSelector().selectByQuoteId(quotes.get(0).Id);
            if(!quoteLineItems.isEmpty() && quoteLineItems != null){
                return quoteLineItems;
            }
        }
        return null;
    }

    /**
     * Method that gets opportunity details
     *
     * @param oppId - opportunity Id
     * @return List<Opportunity> - opportunity details
     */
    @AuraEnabled
    public static List<Opportunity> fetchOpportunityRecord(Id oppId) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId , 1);
        if(!opportunities.isEmpty() && opportunities != null){
                return opportunities;
            }
        return null;
    }
    
    /**
     * Method that checks if a previous quote was done and returns the total premium
     *
     * @param oppId - opportunity Id
     * @return Double - total premium
     */
    @AuraEnabled
    public static Double checkIfQuoteExists(Id oppId) {
        
         List<Opportunity> oppRecord = fetchOpportunityRecord(oppId);
        if(oppRecord[0].Opportunity_Record_Type_Name__c == 'Direct Delivery Sales Opportunity'){
            List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,oppRecord[0].Product_Interest__r.Product__c);
        	if(!quotes.isEmpty() && quotes != null){
            return quotes.get(0).GrandTotal;
        	} 
        }
        else{
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        if(!quotes.isEmpty() && quotes != null){
            return quotes.get(0).GrandTotal;
        }
        }
        return null;
    }

    /**
     * Method that gets the policy fee from the pricing matrix
     * This is extra overhead but prevents hardcoding the policy fee (usually R10.00)
     *
     * @param oppId - opportunity Id
     * @return Double - policy fee
     */
    @AuraEnabled
    public static Double getPolicyFee() {

        List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectByRecordTypeName('Policy Fee', 1);
        if(!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1){
            return pricingMatrices.get(0).Premium__c;
        }
        return null;
    }
    
	 /**
     * Method that gets the premium as the cover amount picklist is changed
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param product - what product chosen i.e. Direct Sales
     * @return Pricing Matrix for product
     */
    @AuraEnabled
    public static EPP_Pricing_Matrix__c getPricingMatrix(Id oppId, String sumInsured, String product) {
  
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId,1);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            Double newAge = opportunities[0].Person_Account_Age__c ;
            if(product == 'Flexi Funeral Rate'){
                List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectPremiumRecordType(newAge, 'Flexi Funeral Fee');
                if((!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1)){
					 return pricingMatrices.get(0);
                 }
            }
           else if(product == 'Flexi Funeral Discount'){
                List<EPP_Pricing_Matrix__c> pricingMatricesDiscount = new PricingMatricesSelector().selectPremiumDiscountRecordType(Double.valueOf(String.valueOf(sumInsured)), 'Flexi Funeral Discount Fee');
                if((!pricingMatricesDiscount.isEmpty() && pricingMatricesDiscount != null && pricingMatricesDiscount.size() == 1)){
					 return pricingMatricesDiscount.get(0);
                }
            }
        }
        return null;
    }
    
    /**
     * Method that gets the member premium as the cover amount picklist is changed
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param recordType - what product chosen i.e. Estate Bridging
     * @return Double - premium for member for product
     */
    @AuraEnabled
    public static Double getMemberPremium(Id oppId, String sumInsured, String recordType) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            if(recordType == 'Family Funeral'){
                List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectByRecordTypeName(recordType, 1);
                if(!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1){
                    return pricingMatrices.get(0).Premium__c;
                }
            }
            else{
                Double sumIns = Double.valueOf(String.valueOf(sumInsured));
                Double newAge = account.Age__pc;
                Double age = Math.floor(newAge);
                List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectSumAndAgeAndRecordType(sumIns, age, recordType);
                if(!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1){
                    return pricingMatrices.get(0).Premium__c;
                }
            }
        }
        return null;
    }

    /**
     * Method that gets the member premium as the cover amount picklist is changed
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param recordType - what product chosen i.e. Estate Bridging
     * @return Double - premium for member for product
     */
    @AuraEnabled
    public static Double getMemberPremiumWbif(String policy, Id oppId, String sumInsured, String recordType) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            if(recordType == 'Family Funeral'){
                Map<String, String> productCodeMap = new Map<String, String>();
                productCodeMap.put('UFN', '30000');
                productCodeMap.put('UEF', '30000');
                WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1)JSON.deserialize(policy, WBIF_IB_String_v1.class);
                System.debug('policySession'+policySession);
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, null, null);
                if(!Test.isRunningTest()){
                if(resp != null && resp.statusCode == 200){
                    List<WBIF_IB_String_v1.cls_Benefit> benefitList = resp.CalculateResponse.CalculateResult.MainMember.Benefits.Benefit;
                          if (!benefitList.isEmpty() && benefitList != null) {
                        for(WBIF_IB_String_v1.cls_Benefit benefit : benefitList){
                            if(benefit.BenefitID == 'UFN'){
                                return Double.valueOf(benefit.Premium);
                            }
                        }
                    }
                    
                  
                }
                }else{
                    return null;
                }
            }
            else if(recordType == 'Executors Fees Cover'){
                Double sumIns = Double.valueOf(String.valueOf(sumInsured));
                Double newAge = account.Age__pc + 1;
                Double age = Math.floor(newAge);
                Map<String, String> productCodeMap = new Map<String, String>();
                productCodeMap.put('UEF', sumInsured);
                WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1)JSON.deserialize(policy, WBIF_IB_String_v1.class);
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, null, null);
                if(resp != null && resp.statusCode == 200){
                    return Double.valueOf(resp.CalculateResponse.CalculateResult.MainMember.Premium);
                } else{
                    return null;
                }
            }
            else if(recordType == 'Estate Bridging Benefit'){
                Double sumIns = Double.valueOf(String.valueOf(sumInsured));
                Double newAge = account.Age__pc + 1;
                Double age = Math.floor(newAge);
                Map<String, String> productCodeMap = new Map<String, String>();
                productCodeMap.put('UEF', '40000');
                productCodeMap.put('UBR', sumInsured);
                WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1)JSON.deserialize(policy, WBIF_IB_String_v1.class);
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, null, null);
                if(resp != null && resp.statusCode == 200){
                    List<WBIF_IB_String_v1.cls_Benefit> benefitList = resp.CalculateResponse.CalculateResult.MainMember.Benefits.Benefit;
                    if (!benefitList.isEmpty() && benefitList != null) {
                        for(WBIF_IB_String_v1.cls_Benefit benefit : benefitList){
                            if(benefit.BenefitID == 'UBR'){
                                return Double.valueOf(benefit.Premium);
                            }
                        }
                    }
                } else{
                    return null;
                }
            }
        }
        return null;
    }

    /**
     * Method that gets the spouses premium as the cover amount picklist is changed
     * This only happens when a spouse is selected
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param recordType - what product chosen i.e. Estate Bridging
     * @return Double - premium for spouse for product
     */
    @AuraEnabled
    public static Double getSpousePremium(Id oppId, String sumInsured, Double age, String recordType) {
        //this is done due to bug - https://salesforce.stackexchange.com/questions/204942/system-unexpectedexception-illegal-arguments-during-execution-of-lightning-serv?rq=1
        Double sumIns = Double.valueOf(String.valueOf(sumInsured));
        Integer ageNextBirthday = null;
        if (age!= null) {
            ageNextBirthday = Integer.valueOf(age) + 1;
        }
        List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectSumAndAgeAndRecordType(sumIns, ageNextBirthday, recordType);
        if(!pricingMatrices.isEmpty() && pricingMatrices != null && pricingMatrices.size() == 1){
            return pricingMatrices.get(0).Premium__c;
        }
        return null;
    }

    /**
     * Method that gets the spouses premium as the cover amount picklist is changed
     * This only happens when a spouse is selected
     *
     * @param oppId - opportunity Id
     * @param sumInsured - cover amount chosen
     * @param recordType - what product chosen i.e. Estate Bridging
     * @return Double - premium for spouse for product
     */
    @AuraEnabled
    public static Double getSpousePremiumWbif(String policy, Id oppId, String sumInsured, Double age, Date spouseDOB, String recordType) {
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            Integer ageNextBirthday = Integer.valueOf(age) + 1;
            if(recordType == 'Executors Fees Cover'){
                Map<String, String> productCodeMap = new Map<String, String>();
                productCodeMap.put('UEF', sumInsured);
                productCodeMap.put('UEFS', sumInsured);
                WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1)JSON.deserialize(policy, WBIF_IB_String_v1.class);
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, String.valueOf(spouseDOB), String.valueOf(ageNextBirthday));
                if(resp != null && resp.statusCode == 200){
                    return Double.valueOf(resp.CalculateResponse.CalculateResult.Spouse.Premium);
                } else{
                    return null;
                }
            }
            else if(recordType == 'Estate Bridging Benefit'){
                Map<String, String> productCodeMap = new Map<String, String>();
                productCodeMap.put('UEF', '40000');
                productCodeMap.put('UEFS', '40000');
                productCodeMap.put('UBR', sumInsured);
                productCodeMap.put('UBRS', sumInsured);
                WBIF_IB_String_v1 policySession = (WBIF_IB_String_v1)JSON.deserialize(policy, WBIF_IB_String_v1.class);
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCalculate(policySession, productCodeMap, String.valueOf(spouseDOB), String.valueOf(ageNextBirthday));
                if(resp != null && resp.statusCode == 200){
                    List<WBIF_IB_String_v1.cls_Benefit> benefitList = resp.CalculateResponse.CalculateResult.Spouse.Benefits.Benefit;
                    if (!benefitList.isEmpty() && benefitList != null) {
                        for(WBIF_IB_String_v1.cls_Benefit benefit : benefitList){
                            if(benefit.BenefitID == 'UBRS'){
                                return Double.valueOf(benefit.Premium);
                            }
                        }
                    }
                } else{
                    return null;
                }
            }
        }
        return null;
    }
    
     /**
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
            public String OppParty;
		}
    
    /**
     * Method that creates a new Direct Delivery quote by given parameters
     *
     * @param oppId - opportunity Id
     * @param totalPremium - total premium amount
     * @param product -  product to quote
     * @param description - Description of quote if any is provided
     */
    	@AuraEnabled
    	public static void createDDQuote(Id oppId, String totalPremium, String product, String lineItems, String partyType,
                                     String description, Boolean spouseChecked, Boolean childChecked, Boolean extendedFamilyChecked,opportunity oppData,string quoteStatus) {
      
        	List<DataLoad> lineItem = (List<DataLoad>)System.JSON.deserialize(lineItems, List<DataLoad>.class);
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
           
            Id prodId = new ProductsSelector().selectByName(product, 1).id; 
            Id quoteId;                            
        	List<Pricebook2> priceBooks = new PriceBooksSelector().selectByName('Standard Price Book');
        	List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        	if (!opportunities.isEmpty() && opportunities != null) {
            	Boolean quoteAlreadyAdded = false;
            if(opportunities.get(0).SyncedQuoteId != null){
                quoteAlreadyAdded = true;
            }
            
  			 List<Quote> quotes = new QuotesSelector().selectByProductName(oppId,product);
        	 if(!quotes.isEmpty() && quotes != null){
                List<QuoteLineItem> quoteLineItemsbyParty = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(quotes.get(0).Id,partyType,prodId);
                if(!quoteLineItemsbyParty.isEmpty() && quoteLineItemsbyParty != null){
                	try {
                    	delete quoteLineItemsbyParty;
                	} catch (Exception ex) {
                    	AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete Quote');
                	}
                 }
            }
                
            List<QuoteLineItem> quoteLineItems = getQuoteLineItemsDataByProduct(oppId,product);
            //Create and Insert Quote
            if(quotes.isEmpty() || quotes == null){
                 Quote quote = new Quote();
            	 quote.OpportunityId = oppId;
            	 if(!Test.isRunningTest()){
                	quote.Pricebook2Id = priceBooks.get(0).id;
            	 }
            	else{
                	quote.Pricebook2Id = Test.getStandardPricebookId();
            	}
            	quote.Description = product;
                quote.Product_Name__c = product;
            	quote.Name = product;
                quote.Quote_Outcome__c= oppData.Quote_Outcome__c;//added by pranv
                  quote.Quote_Outcome_Reason__c=oppData.Quote_Outcome_Reason__c;//added by pranv
                  quote.Status=quoteStatus;
                try {
                    insert quote; 
                    quoteId = quote.id;
                } catch (Exception ex) {
                		AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote');
            	}
              }
              else{
                    quoteId = quotes.get(0).Id;
                    quotes.get(0).Quote_Outcome__c= oppData.Quote_Outcome__c;//added by pranv
                    quotes.get(0).Quote_Outcome_Reason__c=oppData.Quote_Outcome_Reason__c;//added by pranv
                  quotes.get(0).Status=quoteStatus;
                    quotes.get(0).Material_Disclosure_Status__c = 'New';
                }           	
                
              try {
                    //Create Each Quote Line Item if Applicable
                    if(quoteLineItems == null){
                          quoteLineItems = new List<QuoteLineItem>();
                     }
                        	
                     List<QuoteLineItem> QuoteItem = new List<QuoteLineItem>();
                     for(Integer i = 0; i < lineItem.size(); i++){
                     QuoteLineItem quoteLineItem = new QuoteLineItem();
                     quoteLineItem.QuoteId = quoteId;
                     quoteLineItem.Product2Id = prodId;
                     quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName(product, 1).id;
                     quoteLineItem.Quantity = 1;
                     quoteLineItem.Benefit__c = lineItem.get(i).Name;
                     if(lineItem.get(i).OppParty == null || lineItem.get(i).OppParty == ''){
                         quoteLineItem.OpportunityPartyId__c = opportunities.get(0).AccountId;
                     }
					 else
                         quoteLineItem.OpportunityPartyId__c = lineItem.get(i).OppParty;
                     quoteLineItem.Relationship_Type__c = partyType;
                     quoteLineItem.Policy_Cover__c = Double.valueOf(lineItem.get(i).SumInsured);
                     quoteLineItem.Premium__c = Double.valueOf(lineItem.get(i).premium);
                     quoteLineItem.UnitPrice = Double.valueOf(lineItem.get(i).premium);
                     quoteLineItems.add(quoteLineItem);    
                  }

                  try {
						if(quoteLineItems.size()>0){
                             upsert quoteLineItems;
                      }
				  } catch (DmlException e) {
    				   System.debug(e.getMessage());	
				}
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote line item');
                }

              opportunities.get(0).StageName = 'Proposal';
              opportunities.get(0).SyncedQuoteId = quoteId;
              if(spouseChecked == true || childChecked == true || extendedFamilyChecked == true){
                opportunities.get(0).Quote_on_Spouse__c = spouseChecked;
            	opportunities.get(0).Quote_on_Child__c = childChecked;
            	opportunities.get(0).Quote_on_Extended_Family__c = extendedFamilyChecked;
              }

              if(quoteAlreadyAdded){
                opportunities.get(0).Material_Disclosure_Status__c = 'Incomplete';
              }
              try {
                  update opportunities;
                  update quotes;
              } catch (Exception ex) {
                  AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Update opportunity');
             }
         }
    }
    
    /**
     * Method that creates a new quote by given parameters
     *
     * @param oppId - opportunity Id
     * @param totalPremium - total premium amount
     * @param policyFee - policy fee amount to be added as product to quote
     * @param executorFeePremium - Executor fee premium amount to be added as product to quote
     * @param executorFeeCover - Executor fee cover amount to be added as product to quote
     * @param estateBridgingPremium - Estate Bridging premium amount to be added as product to quote
     * @param estateBridgingCover - Estate Bridging cover amount to be added as product to quote
     * @param funeralFeePremium - Funeral fee premium amount to be added as product to quote
     * @param executorFeePremiumSpouse - Executor fee premium for the spouse amount to be added as product to quote
     * @param estateBridgingPremiumSpouse - Estate Bridging premium for the spouse amount to be added as product to quote
     * @param spouseDOB - Spouses date of birth
     * @param description - Description of quote if any is provided
     */
    @AuraEnabled
    public static void createQuote(Id oppId, String totalPremium, String policyFee, String executorFeePremium, String executorFeeCover, String estateBridgingPremium, String estateBridgingCover, String funeralFeePremium, String executorFeePremiumSpouse, String estateBridgingPremiumSpouse, Boolean funeralFeePremiumSpouse, String spouseDOB, Boolean deleteSpouse, String description) {
        Id oppLineItemExecutorFee;
        Id oppLineItemExecutorFeeSpouse;
        Id oppLineItemEstateBridging;
        Id oppLineItemEstateBridgingSpouse;
        Id oppLineItemFuneralFee;
        Id oppLineItemFuneralFeeSpouse;
        Id oppLineItemPolicyFee;
        String funeralFeeCover;
        Boolean spouseAdded = false;
        List<Pricebook2> priceBooks = new PriceBooksSelector().selectByName('Standard Price Book');
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            Boolean quoteAlreadyAdded = false;
            if(opportunities.get(0).SyncedQuoteId != null){
                quoteAlreadyAdded = true;
            }
            List<OpportunityLineItem> oppLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
            //Check if quote line items already exist and delete all of them
            if(!oppLineItems.isEmpty() && oppLineItems != null){
                try {
                    delete oppLineItems;
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete opportunity line items');
                }
            }
            //Get Funeral Fee Cover
            List<EPP_Pricing_Matrix__c> pricingMatrices = new PricingMatricesSelector().selectByRecordTypeName('Family Funeral', 1);
            if (!pricingMatrices.isEmpty() && pricingMatrices != null) {
                if(!Test.isRunningTest()){
                    funeralFeeCover = String.valueOf(pricingMatrices.get(0).Sum_Insured__c);
                }
                else{
                    funeralFeeCover = '30000';
                }
                //Create Each Opportunity Line Item if Applicable
                try {
                    if(Double.valueOf(executorFeePremium.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Executor Fees Policy', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Executor Fees Policy', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(executorFeePremium.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(executorFeePremium.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemExecutorFee = oppLineItem.id;
                    }
                    if(Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Executor Fees Policy Spouse', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Executor Fees Policy Spouse', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemExecutorFeeSpouse = oppLineItem.id;
                        spouseAdded = true;
                    }
                    if(Double.valueOf(estateBridgingPremium.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Estate Bridging Benefit', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Estate Bridging Benefit', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(estateBridgingPremium.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(estateBridgingPremium.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemEstateBridging = oppLineItem.id;
                    }
                    if(Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Estate Bridging Benefit Spouse', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Estate Bridging Benefit Spouse', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemEstateBridgingSpouse = oppLineItem.id;
                        spouseAdded = true;
                    }
                    if(Double.valueOf(funeralFeePremium.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(funeralFeePremium.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(funeralFeePremium.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemFuneralFee = oppLineItem.id;
                    }
                    if(funeralFeePremiumSpouse){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = 0;
                        oppLineItem.TotalPrice = 0;
                        insert oppLineItem;
                        oppLineItemFuneralFeeSpouse = oppLineItem.id;
                    }
                    if(Double.valueOf(policyFee.replaceAll('\\s+', '')) > 0){
                        OpportunityLineItem oppLineItem = new OpportunityLineItem();
                        oppLineItem.OpportunityId = opportunities.get(0).id;
                        oppLineItem.Product2Id = new ProductsSelector().selectByName('Policy Fee', 1).id;
                        oppLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('Policy Fee', 1).id;
                        oppLineItem.Quantity = 1;
                        oppLineItem.Premium__c = Double.valueOf(policyFee.replaceAll('\\s+', ''));
                        oppLineItem.TotalPrice = Double.valueOf(policyFee.replaceAll('\\s+', ''));
                        insert oppLineItem;
                        oppLineItemPolicyFee = oppLineItem.id;
                    }
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert opportunity line items');
                }
            }
            //Create and Insert Quote
            Quote quote = new Quote();
            quote.OpportunityId = oppId;
            if(!Test.isRunningTest()){
                quote.Pricebook2Id = priceBooks.get(0).id;
            }
            else{
                quote.Pricebook2Id = Test.getStandardPricebookId();
            }
            quote.Description = description;
            quote.Name = String.valueOf(DateTime.now());
            try {
                insert quote;
                try {
                    //Create Each Quote Line Item if Applicable
                    if(Double.valueOf(executorFeePremium.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemExecutorFee;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Executor Fees Policy', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Executor Fees Policy', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(executorFeeCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = Double.valueOf(executorFeePremium.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(executorFeePremium.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                    if(Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemExecutorFeeSpouse;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Executor Fees Policy Spouse', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Executor Fees Policy Spouse', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(executorFeeCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                    if(Double.valueOf(estateBridgingPremium.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemEstateBridging;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Estate Bridging Benefit', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Estate Bridging Benefit', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(estateBridgingCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = Double.valueOf(estateBridgingPremium.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(estateBridgingPremium.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                    if(Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemEstateBridgingSpouse;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Estate Bridging Benefit Spouse', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Estate Bridging Benefit Spouse', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(estateBridgingCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                    if(Double.valueOf(funeralFeePremium.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemFuneralFee;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(funeralFeeCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = Double.valueOf(funeralFeePremium.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(funeralFeePremium.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                    if(funeralFeePremiumSpouse){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemFuneralFeeSpouse;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('EPP Funeral Benefit Spouse', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = Double.valueOf(funeralFeeCover.replaceAll('\\s+', ''));
                        quoteLineItem.Premium__c = 0;
                        quoteLineItem.UnitPrice = 0;
                        insert quoteLineItem;
                    }
                    if(Double.valueOf(policyFee.replaceAll('\\s+', '')) > 0){
                        QuoteLineItem quoteLineItem = new QuoteLineItem();
                        quoteLineItem.QuoteId = quote.id;
                        quoteLineItem.OpportunityLineItemId = oppLineItemPolicyFee;
                        quoteLineItem.Product2Id = new ProductsSelector().selectByName('Policy Fee', 1).id;
                        quoteLineItem.PricebookEntryId = new PriceBookEntriesSelector().selectByName('Policy Fee', 1).id;
                        quoteLineItem.Quantity = 1;
                        quoteLineItem.Policy_Cover__c = 0;
                        quoteLineItem.Premium__c = Double.valueOf(policyFee.replaceAll('\\s+', ''));
                        quoteLineItem.UnitPrice = Double.valueOf(policyFee.replaceAll('\\s+', ''));
                        insert quoteLineItem;
                    }
                } catch (Exception ex) {
                    AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote line item');
                }
            } catch (Exception ex) {
                AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Insert quote');
            }
            Date currentDate = Date.today();
            Date nextmonth = currentDate.addmonths(1);
            Date firstDate = date.valueof(nextmonth).toStartOfMonth();
            //Calculate Commission
            CommissionCalculator.CommissionRequest commissionRequest = new CommissionCalculator.CommissionRequest();
            commissionRequest.opportunityId = oppId;
            commissionRequest.quoteId = quote.Id;
            commissionRequest.dateOfBirth = account.PersonBirthdate;
            commissionRequest.dateOfCommencement = firstDate;
            commissionRequest.executorFeePremium = Double.valueOf(executorFeePremium.replaceAll('\\s+', '')) + Double.valueOf(executorFeePremiumSpouse.replaceAll('\\s+', ''));
            commissionRequest.estateBridgingPremium = Double.valueOf(estateBridgingPremium.replaceAll('\\s+', '')) + Double.valueOf(estateBridgingPremiumSpouse.replaceAll('\\s+', ''));
            commissionRequest.familyFuneralPremium = Double.valueOf(funeralFeePremium.replaceAll('\\s+', ''));
            commissionRequest.policyFee = Double.valueOf(policyFee.replaceAll('\\s+', ''));
            List<CommissionCalculator.CommissionRequest> requests = new List<CommissionCalculator.CommissionRequest>();
            requests.add(commissionRequest);
            CommissionCalculator.calculateCommission(requests);
            opportunities.get(0).StageName = 'Proposal';
            if(spouseDOB != null){
                opportunities.get(0).Spouse_Date_of_Birth__c = Date.valueOf(spouseDOB);
            }
            opportunities.get(0).SyncedQuoteId = quote.Id;
            if(quoteAlreadyAdded){
                opportunities.get(0).Material_Disclosure_Status__c = 'Incomplete';
            }
            try {
                update opportunities;
            } catch (Exception ex) {
                AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Update opportunity');
            }
            if(deleteSpouse){
                List<Opportunity_Party__c> opportunityParties = new OpportunityPartiesSelector().selectByOpportunityIdAndPartyType(oppId ,'Dependant');
                List<Opportunity_Party__c> opportunityPartiesSpouse = new List<Opportunity_Party__c>();
                if (!opportunityParties.isEmpty() && opportunityParties != null) {
                    for (Opportunity_Party__c oppParty : opportunityParties) {
                        if (oppParty.Relationship__c == 'Spouse') {
                            opportunityPartiesSpouse.add(oppParty);
                        }
                    }
                }
                if (!opportunityPartiesSpouse.isEmpty() && opportunityPartiesSpouse != null) {
                    try {
                        delete opportunityPartiesSpouse;
                    } catch (Exception ex) {
                        AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'createQuote', 'Delete spouse opportunity party');
                    }
                }
            }
        }
    }

    /**
     * Method that gets the first year commission previously calculated from the quote
     *
     * @param oppId - opportunity Id
     * @return Double - first year commission
     */
    @AuraEnabled
    public static Double getFirstYearCommission(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        Double comm1stYear = null;
        if(!quotes.isEmpty() && quotes != null){
            comm1stYear = quotes.get(0).Commission_1st_Year__c.setScale(2);
        }
        return comm1stYear;
    }

    /**
     * Method that gets the second year commission previously calculated from the quote
     *
     * @param oppId - opportunity Id
     * @return Double - second year commission
     */
    @AuraEnabled
    public static Double getSecondYearCommission(Id oppId) {
        List<Quote> quotes = new QuotesSelector().selectByOpportunityId(oppId);
        Double comm2ndYear = null;
        if(!quotes.isEmpty() && quotes != null){
            comm2ndYear = quotes.get(0).Commission_2nd_Year__c.setScale(2);
        }
        return comm2ndYear;
    }

    /**
     * Method that sets email on the opportunity
     *
     * @param oppId - opportunity Id
     * @param emailAddress - email address being sent to
     * @param altEmailAddress - alternate email address being sent to
     * @param isAlternative - boolean indicating if email is being sent to alternate email address
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static Boolean setOppEmail(Id oppId, String emailAddress,String altEmailAddress, Boolean isAlternative) {
        Boolean r ;
        try{
            List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
            List<Account> accounts = new List<Account>();
            if (!opportunities.isEmpty() && opportunities != null) {
                accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
                if(!isAlternative){
                    opportunities.get(0).Selected_Email__c = emailAddress;
                    update opportunities;
                }else {
                    opportunities.get(0).Selected_Email__c = altEmailAddress;
                    if (!accounts.isEmpty() && accounts != null) {
                        if(accounts.get(0).Alternative_Email__c == null){
                            accounts.get(0).Alternative_Email__c = altEmailAddress;
                        }
                        else if(accounts.get(0).Alternative_Email_1__c == null){
                            accounts.get(0).Alternative_Email_1__c = altEmailAddress;
                        }
                        else if(accounts.get(0).Alternative_Email_2__c == null){
                            accounts.get(0).Alternative_Email_2__c = altEmailAddress;
                        }
                        else if(accounts.get(0).Alternative_Email_3__c == null){
                            accounts.get(0).Alternative_Email_3__c = altEmailAddress;
                        }
                        else if(accounts.get(0).Alternative_Email_4__c == null){
                            accounts.get(0).Alternative_Email_4__c = altEmailAddress;
                        }
                    }
                    update opportunities;
                    update accounts;
                }
            }
            r = true;
        }
        catch(Exception ex){
            AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'setOppEmail', 'Update opportunity with email addrerss');
            r = false;
        }
        return r;
    }

    /**
     * Method that sends email to client
     *
     * @param oppId - opportunity Id
     * @param emailAddress - email address being sent to
     * @param isAlternative - if the email address being sent to in an alternative one or not
     * @return Boolean - successful send or not
     */
    @AuraEnabled
    public static Boolean sendEmail(Id oppId,String emailAddress) {
        Boolean r ;
        try{
            r = QuotingHelperClass.sendMailMethod(emailAddress, oppId);
        }
        catch(Exception ex){
            AuditTrailLog.logException(ex, 'New', 'Error', 'QuotingProcessController', 'sendEmail', 'Send email with attached quote');
            r = false;
        }
        return r;
    }

    /**
     * Method that gets all of the clients emails
     *
     * @param oppId - opportunity Id
     * @return List<String> - list of clients emails
     */
    @AuraEnabled
    public static List<String> getEmails(Id oppId) {
        List<String> emails = new List<String>();
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);
        if (!opportunities.isEmpty() && opportunities != null) {
            if(opportunities.get(0).Selected_Email__c != null){
                emails.add(opportunities.get(0).Selected_Email__c);
            }
            List<Account> accounts = new AccountsSelector().selectEmailFieldsById(opportunities.get(0).AccountId, 1);
            if (!accounts.isEmpty() && accounts != null) {
                if(opportunities.get(0).Selected_Email__c != accounts.get(0).PersonEmail){
                    emails.add(accounts.get(0).PersonEmail);
                }
                if(accounts.get(0).Alternative_Email__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email__c){
                    emails.add(accounts.get(0).Alternative_Email__c);
                }
                if(accounts.get(0).Alternative_Email_1__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_1__c){
                    emails.add(accounts.get(0).Alternative_Email_1__c);
                }
                if(accounts.get(0).Alternative_Email_2__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_2__c){
                    emails.add(accounts.get(0).Alternative_Email_2__c);
                }
                if(accounts.get(0).Alternative_Email_3__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_3__c){
                    emails.add(accounts.get(0).Alternative_Email_3__c);
                }
                if(accounts.get(0).Alternative_Email_4__c != null && opportunities.get(0).Selected_Email__c != accounts.get(0).Alternative_Email_4__c){
                    emails.add(accounts.get(0).Alternative_Email_4__c);
                }
            }
        }
        return emails;
    }

    /**
     * Method that gets the policy and stores in as a session variable to be passed into wbif calculate calls for member and spouse premium
     *
     * @param oppId - opportunity Id
     * @return String - policy in JSON structure
     */
    @AuraEnabled
    public static String getPolicy(Id oppId) {
        String strResp;
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        if (!opportunities.isEmpty() && opportunities != null) {
            Account account = new AccountsSelector().selectByOpportunityId(opportunities.get(0).AccountId, 1);
            List<User> users = new UsersSelector().selectByOpportunityOwnerId(opportunities.get(0).OwnerId);
            System.debug('users'+users.get(0));
            System.debug('account'+account);
            System.debug('opportunities.get(0)'+opportunities.get(0));
            if(!Test.isRunningTest()){
            if (!users.isEmpty() && users != null) {
                WBIF_IB_String_v1 resp = WBIF_IH_v1.wbifPolicyCreate(users.get(0), account, opportunities.get(0));
                system.debug('---main resp'+resp);
                strResp = JSON.serialize(resp);
            }
            }
        }
        return strResp;
    }

    /**
     * Method that gets all picklist data
     *
     * @param objObject - Id of the specific opportunity party being removed
     * @param fld - field name i.e. Clause_Name__c
     */
    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        List<String> allOpts = new List<String> ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue().replaceAll('\\s',''));
        }
        //allOpts.sort();
        return allOpts;
    }

    /**
     * Method that get the maximum age for a spouse
     *
     * @param oppId - opportunity Id
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
            fields = fields+', Country of Birth';
            validAccount = false;
            numberOfFields++;
        }
        if (account.Country_of_Residence__pc == null) {
            fields = fields+', Country of Residence';
            validAccount = false;
            numberOfFields++;
        }
        if (account.Nationality__pc == null) {
            fields = fields+', Nationality';
            validAccount = false;
            numberOfFields++;
        }
        if (account.Income_Source__pc == null) {
            fields = fields+', Income Source';
            validAccount = false;
                numberOfFields++;
            }
            if (account.CIF__c == null) {
                fields = fields+', CIF';
                validAccount = false;
                numberOfFields++;
            }
            if (numberOfFields >1) {
                fields = inValidMultiReason+fields;
            }
            else {
                fields = inValidSingleReason+fields;
            }
            fields = fields+'.';
        }
        if (validAccount) {
            return 'Valid';
        }else {
            return fields;
        }
    }
}