// Controller for MerchantQuoteBuilder Component
// @author  Prashant Jain / Jason Quevauvilliers
// @version v1.0
// @since   2020-04-01

public class MerchantQuoteBuilderController {

    // PJAIN: 20200414
    // This method queries pricing data from multiple objects and
    // populates PricingBean object.

    // The pricing is calculated in a hierarchical manner in the following order:
    // Negotiated price for Account for Product
    // Negotiated price for Account for Product Family
    // Franchise and Group price for Account Group
    // Standard price for Product
    // Standard price for Product Family

    @AuraEnabled
    public static String getQuoteBuilderData(String opportunityId) {
        PricingBean pricingBean;

        if (String.isNotBlank(opportunityId)) {
            List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId, 1);

            if (opportunityLineItems != null && opportunityLineItems.size() > 0) {
                OpportunityLineItem opportunityLineItem = opportunityLineItems.get(0);
                pricingBean = new PricingBean();

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
                pricingBean.selectedQuantity = (Integer)opportunityLineItem.Quantity;
                pricingBean.selectedContractDurationType = opportunityLineItem.Contract_Duration_Type__c;
                pricingBean.priceSchemeEntryMap = new Map<String, PriceSchemeEntryData>();

                //Populate Quantity Picklist Options
                populateQuantityPicklistOptions((Integer)opportunityLineItem.Product2.Maximum_Quantity__c, pricingBean);

                //Populate Contract Duration Type Picklist Options
                if(String.isNotBlank(opportunityLineItem.Product2.Contract_Duration_Type__c)){
                    pricingBean.contractDurationTypePicklistOptions = opportunityLineItem.Product2.Contract_Duration_Type__c.split(';');
                }

                //Populate Price Entries
                populateNegotiatedPriceEntriesForAccountProduct(pricingBean);
                populateNegotiatedPriceEntriesForAccountProductFamily(pricingBean);
                populateNegotiatedPriceEntriesForFranchise(pricingBean);
                populateStandardPriceEntriesForProduct(pricingBean);
                populateStandardPriceEntriesForProductFamily(pricingBean);

                //Populate VAS Product Data
                populateVASProductData(pricingBean);

                //Populate Field Visibility Mdt
                pricingBean.fieldVisibilityMdtList = Sys_Utilities_Metadata.getFieldVisibilityMetadataByProductNameAndFamily('MerchantQuoteBuilder', pricingBean.productName, pricingBean.productFamily);
            }
        }
        return JSON.serialize(pricingBean);
    }

    // PJAIN: 20200420
    // This method saves the updated data.
    // If needed, create new Price Scheme.
    // If price entry exists, update it otherwise create it.
    // It updates the Opportunity Lime Item.
    @AuraEnabled
    public static String saveQuoteBuilderData(String jsonString){
        PricingBean pricingBean = (PricingBean)JSON.deserialize(jsonString, PricingBean.class);
        List<Price_Scheme_Entry__c> priceSchemeEntriesToUpdate = new List<Price_Scheme_Entry__c>();
        List<Price_Scheme_Entry__c> priceSchemeEntriesToInsert = new List<Price_Scheme_Entry__c>();
        Map<Id, PriceSchemeEntryData> priceSchemeEntryMapForInsert = new Map<Id, PriceSchemeEntryData>();
        PriceSchemeEntryData priceSchemeEntryData;

        for (String key : pricingBean.priceSchemeEntryMap.keySet()) {
            priceSchemeEntryData = pricingBean.priceSchemeEntryMap.get(key);
            if (priceSchemeEntryData.updatedValue != null && priceSchemeEntryData.existingValue != priceSchemeEntryData.updatedValue) {
                if (String.isBlank(pricingBean.negotiatedPriceSchemeId)) {
                    // This insert (if required) would be executed only once in the loop.
                    // Once inserted, the negotiatedPriceSchemeId will be set and the IF
                    // condition would not be true again.
                    insertAndPopulatePriceSchemeId(pricingBean);
                }

                if (String.isNotBlank(priceSchemeEntryData.negotiatedPriceSchemeEntryId)) {
                    updatePriceSchemeEntry (priceSchemeEntryData, priceSchemeEntryData.negotiatedPriceSchemeEntryId, priceSchemeEntriesToUpdate);
                } else {
                    // Populate a map of records to insert using transactionTypeId as the key so that
                    // negotiatedPriceSchemeEntryId can be populated with the inserted record Ids.
                    priceSchemeEntryMapForInsert.put(priceSchemeEntryData.transactionTypeId, priceSchemeEntryData);
                    insertAndPopulatePriceSchemeEntryId (priceSchemeEntryData, pricingBean.negotiatedPriceSchemeId, priceSchemeEntriesToInsert);
                }
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

        //updateOpportunity(pricingBean);
        updateOpportunityLineItem(pricingBean);
        synchronizeVASOpportunityLineItems(pricingBean);

        return JSON.serialize(pricingBean);
    }

    // PJAIN: 20200422 & JQUEV: 20200813
    // This method creates Application and Application Product - Merchant records
    // and Updates the Sales Stage of the Opportunity
    @AuraEnabled
    public static Map<String, String> createApplicationRecords(String pricingBeanString, Map<String,String> metadataNameToValueMap ) {
        Map<String, String> idsMap = new Map<String, String>();
        PricingBean pricingBean = (PricingBean)JSON.deserialize(pricingBeanString, PricingBean.class);

        // Return error if Application record already exists.
        List<Application__c> applications = new ApplicationsSelector().selectByOpportunityOnboardId(pricingBean.opportunityId);
        if (applications != null && applications.size() > 0) {
            idsMap.put('error', StringConstants.MERCHANT_ERROR_APPLICATION_ALREADY_EXISTS);
            return idsMap;
        }

        // Return error if Application Product - Merchant record already exists.
        List<Application_Product_Merchant__c> applicationProductMerchantList = new ApplicationProductMerchantsSelector().selectIdsByOpportunityLineItemId(pricingBean.opportunityLineItemId);
        if (applicationProductMerchantList != null && applicationProductMerchantList.size() > 0) {
            idsMap.put('error', StringConstants.MERCHANT_ERROR_APPLICATION_ALREADY_EXISTS);
            return idsMap;
        }

        if (String.isNotBlank(pricingBean.opportunityId) && String.isNotBlank(pricingBean.opportunityLineItemId)) {

            Savepoint sp = Database.setSavePoint();
            try{
                // Create Application record if it does not exist
                Application__c application = new Application__c();
                application.Opportunity__c = pricingBean.opportunityId;
                application.RecordTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByDeveloperName().get(StringConstants.APPLICATION_RECORD_TYPE_MERCHANT_ONBOARDING).getRecordTypeId(); // PJAIN: 20200530
                application.QA_Status__c = 'Not Started'; // PJAIN: 2020603
                application.QA_Status_Updated_By__c = UserInfo.getUserId(); // PJAIN: 2020603
                application.QA_Status_Updated_On__c = System.now(); // PJAIN: 2020603
                insert application;
                idsMap.put('applicationId', application.Id);

                //Dynamically assign the values to the Application_Product_Merchant__c Object based on the Metadata
                Application_Product_Merchant__c applicationProductMerchant = new Application_Product_Merchant__c();
                applicationProductMerchant.Opportunity_Product_Id__c = pricingBean.opportunityLineItemId;

                for(Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList){
                    //Get value from the Map
                    String stringValue = metadataNameToValueMap.get(mtdRecord.DeveloperName);
                    if(stringValue != null && mtdRecord.Additional_Attributes__c != null && mtdRecord.Object_Name__c == 'Application_Product_Merchant__c'){
                        //Get AdditionalAttributes for this mdt record
                        AdditionalAttributes addAttributes = (AdditionalAttributes)JSON.deserialize(mtdRecord.Additional_Attributes__c, AdditionalAttributes.class);
                        //Check for Field API Name and Type of field
                        if(addAttributes.fieldAPIName != null){
                            if(addAttributes.dataType == 'number'){
                                //Assigns the value to the Field on the Object by API NAme
                                applicationProductMerchant.put(addAttributes.fieldAPIName, decimal.valueOf(stringValue));
                            }else{
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
            }catch(Exception e){
                Database.rollback(sp);
                idsMap.put('error', e.getMessage() + '. ' + e.getStackTraceString());
                return idsMap;
            }
        }
        return idsMap;
    }

    // JQUEV: 20200818
    // This method deletes existing OpportunityLineItems Records
    // Resets values on the Opportunity and selects a new Product
    // There will no Application or Application Product Merchant Records at this point
    @AuraEnabled
    public static Map<String, String> changeSelectedProduct(String opportunityId, String productName){

        Map<String, String> idsMap = new Map<String, String>();

        List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());

        if(userList[0].SiteCode__c != null){

            //Select Product2 Record *** NOT USING SELECTOR as Query will change when we remove hardcoding of product names select list.
            //Becauuse then we can query by ID
            List<Product2> selectedProductList = [SELECT Id FROM Product2 WHERE Name =: productName];

            if(selectedProductList.size() == 1){

                Savepoint sp = Database.setSavePoint();
                try{
                    //Delete existing OpportunityLineItems
                    List<OpportunityLineItem>  oppLineItemList = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
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

                }catch(Exception e){
                    Database.rollback(sp);
                    idsMap.put('error', e.getMessage() + '. ' + e.getStackTraceString());
                    return idsMap;
                }
            }else{
                idsMap.put('error', 'Error trying to find product record. Records returned: ' + selectedProductList.size());
                return idsMap;
            }
        }else{
            idsMap.put('error', StringConstants.MERCHANT_ERROR_USER_SITE_CODE_NOT_FOUND);
            return idsMap;
        }
        return idsMap;
    }

    // PJAIN: 20200420
    // This method populates Quantity Picklist Options based on Contract_Duration_Type__c field on Product2
    private static void populateQuantityPicklistOptions (Integer productMaxQuantity, PricingBean pricingBean) {
        pricingBean.quantityPicklistOptions = new List<Integer>();
        pricingBean.quantityPicklistOptions.add(1);
        if(productMaxQuantity != null && productMaxQuantity > 1){
            for(Integer i = 2; i <= productMaxQuantity; i++){
                pricingBean.quantityPicklistOptions.add(i);
            }
        }
    }

    // PJAIN: 20200420
    // This method populates Negotiated price for Account for Product.
    // It queries Negotiated Price Scheme Id by querying Price Scheme Product Entry Object.
    private static void populateNegotiatedPriceEntriesForAccountProduct(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.accountId) && String.isNotBlank(pricingBean.productId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Price_Scheme_Product_Entry__c> accountProductPriceSchemesProductEntries =
                new PriceSchemeProductEntriesSelector().selectByActiveTypeAccountProduct(pricingBean.productId, pricingBean.accountId, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
                System.debug('populateNegotiatedPriceEntriesForAccountProduct accountProductPriceSchemesProductEntries: ' + accountProductPriceSchemesProductEntries);
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
    // This method populates Negotiated price for Account.
    // It queries Negotiated Price Scheme Id by querying Price Scheme Object.
    private static void populateNegotiatedPriceEntriesForAccountProductFamily(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.accountId) && String.isNotBlank(pricingBean.productFamily) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Price_Scheme__c> accountProductFamilyPriceSchemes =
                new PriceSchemesSelector().selectByAccountTypeProductFamily(pricingBean.accountId, pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
                System.debug('populateNegotiatedPriceEntriesForAccountProductFamily accountProductFamilyPriceSchemes: ' + accountProductFamilyPriceSchemes);
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
    // This method populates Franchise and Group price for Account Group.
    // It queries Franchise Price Scheme Id by querying Account Object.
    private static void populateNegotiatedPriceEntriesForFranchise(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.accountId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Account> accounts = new AccountsSelector().selectFranchisePriceSchemeIdById(pricingBean.accountId);
            System.debug('populateNegotiatedPriceEntriesForFranchise accounts: ' + accounts);
            if (accounts != null && accounts.size() > 0) {
                pricingBean.isNegotiable = false;
                populatePriceEntries(accounts.get(0).Franchise_Price_Scheme__c, true, pricingBean);
            }
        }
    }

    // PJAIN: 20200420
    // This method populates Standard price for Product.
    // It queries Standard Price Scheme Id by querying Price Scheme Product Entry Object.
    private static void populateStandardPriceEntriesForProduct(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.productId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Price_Scheme_Product_Entry__c> productPriceSchemesProductEntries =
                new PriceSchemeProductEntriesSelector().selectByActiveTypeProduct(pricingBean.productId, StringConstants.PRICE_SCHEME_TYPE_STANDARD, 1);
                System.debug('populateStandardPriceEntriesForProduct productPriceSchemesProductEntries: ' + productPriceSchemesProductEntries);
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
    // This method populates Standard price for Product Family.
    // It queries Standard Price Scheme Id by querying Price Scheme Object.
    private static void populateStandardPriceEntriesForProductFamily(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.productFamily) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Price_Scheme__c> standardProductFamilyPriceSchemes =
                new PriceSchemesSelector().selectByTypeProductFamily(pricingBean.productFamily, StringConstants.PRICE_SCHEME_TYPE_STANDARD, 1);
                System.debug('populateStandardPriceEntriesForProductFamily standardProductFamilyPriceSchemes: ' + standardProductFamilyPriceSchemes);
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
    // This method populates Price Scheme Entries.
    // It queries Price Scheme Entries using the Price Scheme Id.
    private static void populatePriceEntries(Id priceSchemeId, Boolean isNegotiated, PricingBean pricingBean) {
        if (String.isNotBlank(priceSchemeId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Price_Scheme_Entry__c> priceSchemeEntries = new PriceSchemeEntriesSelector().selectByPriceSchemeId(priceSchemeId);

            for (Price_Scheme_Entry__c priceSchemeEntry : priceSchemeEntries) {
                System.debug('populatePriceEntries priceSchemeEntry: ' + priceSchemeEntry);
                String transactionGroupName = priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Name;
                String transactionTypeName = priceSchemeEntry.Transaction_Type__r.Name;
                String mapKey = String.format(StringConstants.MERCHANT_PRICE_SCHEME_ENTRY_MAP_KEY_TEMPLATE, new List<String> {transactionGroupName, transactionTypeName});

                // Don't put in the map if the key already exists
                if (!pricingBean.priceSchemeEntryMap.containsKey(mapKey)) {
                    PriceSchemeEntryData priceSchemeEntryData = new PriceSchemeEntryData();
                    priceSchemeEntryData.feeType = priceSchemeEntry.Fee_Type__c;
                    priceSchemeEntryData.pricingTemplate = priceSchemeEntry.Pricing_Template__c;
                    priceSchemeEntryData.transactionTypeId = priceSchemeEntry.Transaction_Type__c;

                    if (priceSchemeEntry.Fee_Type__c == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
                        priceSchemeEntryData.existingValue = priceSchemeEntry.Fee_Amount_Fixed__c;
                    } else if (priceSchemeEntry.Fee_Type__c == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
                        priceSchemeEntryData.existingValue = priceSchemeEntry.Fee_Amount_Percent__c;
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
                    picklistOptionSet.add(String.valueOf(Decimal.valueOf(priceSchemeEntryData.existingValue).setScale(2)));

                    if (String.isNotBlank(priceSchemeEntry.Transaction_Type__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c)) {
                        picklistOptionSet.addAll(priceSchemeEntry.Transaction_Type__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c.split(';'));
                    } else if (String.isNotBlank(priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c)) {
                        picklistOptionSet.addAll(priceSchemeEntry.Transaction_Type__r.Transaction_Group__r.Pricing_Formula__r.Fee_Amount_Picklist_Values__c.split(';'));
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

    // PJAIN: 20200420
    // This method populates VAS Product Details
    // It queries Product Product Entries using the Parent Product Id.
    private static void populateVASProductData(PricingBean pricingBean) {
        if (String.isNotBlank(pricingBean.productId) && pricingBean != null && pricingBean.priceSchemeEntryMap != null) {
            List<Product_Product_Entry__c> productProductEntries = new ProductProductEntriesSelector().selectByParentProductId(pricingBean.productId);

            if (productProductEntries != null && productProductEntries.size() > 0) {
                pricingBean.vasProductDataList = new List<VASProductData>();
                VASProductData vasProductData;

                List<OpportunityLineItem> vasOpportunityLineItems = new OpportunityLineItemsSelector().selectRelatedLineItemsByParentId(pricingBean.opportunityLineItemId);
                Map<String, List<OpportunityLineItem>> vasOpportunityLineItemMap;
                if (vasOpportunityLineItems != null && vasOpportunityLineItems.size() > 0) {
                    vasOpportunityLineItemMap = Sys_Utilities_General.convertListToMapWithStringKey(vasOpportunityLineItems, 'Product2Id');
                }

                for (Product_Product_Entry__c productProductEntry : productProductEntries) {
                    vasProductData = new VASProductData();
                    vasProductData.productId = productProductEntry.Related_Product__c;
                    vasProductData.productName = productProductEntry.Related_Product__r.Name;

                    if (vasOpportunityLineItemMap != null) {
                        if (vasOpportunityLineItemMap.containsKey(vasProductData.productId)) {
                            vasProductData.opportunityLineItemId = vasOpportunityLineItemMap.get(vasProductData.productId).get(0).Id;
                            vasProductData.isSelected = true;
                        } else {
                            vasProductData.isSelected = false;
                        }
                    } else {
                        vasProductData.isSelected = true;
                    }
                    pricingBean.vasProductDataList.add(vasProductData);
                }
            }
        }
    }

    // PJAIN: 20200420
    // This method creates a new Price Scheme.
    private static void insertAndPopulatePriceSchemeId (PricingBean pricingBean) {
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
    // This method updates Price Scheme Entry.
    private static void updatePriceSchemeEntry (PriceSchemeEntryData priceSchemeEntryData, Id negotiatedPriceSchemeEntryId, List<Price_Scheme_Entry__c> priceSchemeEntries) {
        Price_Scheme_Entry__c priceSchemeEntry = new Price_Scheme_Entry__c(
            Id = negotiatedPriceSchemeEntryId
        );
        if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_FIXED) {
            priceSchemeEntry.Fee_Amount_Fixed__c = priceSchemeEntryData.updatedValue;
        } else if (priceSchemeEntryData.feeType == StringConstants.PRICE_SCHEME_ENTRY_FEE_TYPE_PERCENTAGE) {
            priceSchemeEntry.Fee_Amount_Percent__c = priceSchemeEntryData.updatedValue;
        }
        priceSchemeEntryData.existingValue = priceSchemeEntryData.updatedValue;
        priceSchemeEntries.add(priceSchemeEntry);
    }

    // PJAIN: 20200420
    // This method creates a new Price Scheme Entry.
    private static void insertAndPopulatePriceSchemeEntryId (PriceSchemeEntryData priceSchemeEntryData, Id negotiatedPriceSchemeId, List<Price_Scheme_Entry__c> priceSchemeEntries) {
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
    // This method updates Opportunity Line Item.
    private static void updateOpportunityLineItem (PricingBean pricingBean) {

        OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
        opportunityLineItem.Id = pricingBean.opportunityLineItemId;

        //deserialize the bean into an Untyped Object. Which allows us to use a get by valueReadPath method
        String jsonStr = JSON.serialize(pricingBean);
        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);

        for(Field_Visibility_Per_Product__mdt mtdRecord : pricingBean.fieldVisibilityMdtList){

            if(mtdRecord.Additional_Attributes__c != null && mtdRecord.Object_Name__c == 'OpportunityLineItem'){

                AdditionalAttributes addAttributes = (AdditionalAttributes)JSON.deserialize(mtdRecord.Additional_Attributes__c, AdditionalAttributes.class);

                if(addAttributes.fieldAPIName != null){
                    //If there is a key then we get the value from the Map. Else get by valueReadPath
                    if(addAttributes.priceSchemeEntryMapKey != null){
                        PriceSchemeEntryData entryData = pricingBean.priceSchemeEntryMap.get(addAttributes.priceSchemeEntryMapKey);

                        if(entryData != null && entryData.updatedValue != null){
                            //Assigns the value to the Field on the Object by API NAme
                            opportunityLineItem.put(addAttributes.fieldAPIName, entryData.updatedValue);
                        }
                    }else{
                        if(untypedMap.get(addAttributes.valueReadPath) != null){
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
    // This method inserts Opportunity Line Item for Value Added Services (VAS).
    private static void synchronizeVASOpportunityLineItems (PricingBean pricingBean) {
        List<OpportunityLineItem> insertOpportunityLineItems = new List<OpportunityLineItem>();
        List<OpportunityLineItem> deleteOpportunityLineItems = new List<OpportunityLineItem>();
        OpportunityLineItem opportunityLineItem;

        for (VASProductData vasProductData : pricingBean.vasProductDataList) {
            // VAS lines which are selected from UI but do not already exist will be inserted
            if (vasProductData.isSelected && String.isBlank(vasProductData.opportunityLineItemId)) {
                opportunityLineItem = new OpportunityLineItem();
                opportunityLineItem.OpportunityId = pricingBean.opportunityId;
                opportunityLineItem.Parent_Opportunity_Line_Item_Id__c = pricingBean.opportunityLineItemId;
                opportunityLineItem.Product2Id = vasProductData.productId;
                opportunityLineItem.TotalPrice = 0;
                opportunityLineItem.Quantity = 1;
                opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(vasProductData.productId);
                insertOpportunityLineItems.add(opportunityLineItem);
            }

            // VAS lines which are deselected from UI but already exist will be deleted
            if (!vasProductData.isSelected && String.isNotBlank(vasProductData.opportunityLineItemId)) {
                opportunityLineItem = new OpportunityLineItem(Id = vasProductData.opportunityLineItemId);
                deleteOpportunityLineItems.add(opportunityLineItem);
                vasProductData.opportunityLineItemId = null;
            }
        }

        if (insertOpportunityLineItems.size() > 0) {
            insert insertOpportunityLineItems;

            // Populate the newly created Opportunity Line Item Id on the bean
            for (OpportunityLineItem newOpportunityLineItem : insertOpportunityLineItems) {
                for (VASProductData vasProductData : pricingBean.vasProductDataList) {
                    if (newOpportunityLineItem.Product2Id == vasProductData.productId) {
                        vasProductData.opportunityLineItemId = newOpportunityLineItem.Id;
                    }
                }
            }
        }

        if (deleteOpportunityLineItems.size() > 0) {
            delete deleteOpportunityLineItems;
        }
    }

    // PJAIN: 20200724
    @AuraEnabled
    public static String generateMerchantQuoteDocument(Map<String, String> documentGenerationMap) {
        String templateName = System.Label.Merchant_Quote_Document_Template_Name;
        return GenerateDocument.autoGenerateDoc(templateName, documentGenerationMap);
    }

    // PJAIN: 20200414
    // This inner classes defines the structure of the response message from Apex controller
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
        public Map<String, PriceSchemeEntryData> priceSchemeEntryMap;
        public List<VASProductData> vasProductDataList;
        public List<Field_Visibility_Per_Product__mdt> fieldVisibilityMdtList; //JQUEV20200713
    }

    // PJAIN: 20200414
    // This inner classes defines the structure of the response message from Apex controller
    public class PriceSchemeEntryData {
        public Id negotiatedPriceSchemeEntryId;
        public String pricingTemplate;
        public String feeType;
        public Id transactionTypeId;
        public Boolean isNegotiable;
        public Double existingValue;
        public Double updatedValue;
        public List<String> picklistOptions;
    }

    // PJAIN: 20200420
    // This inner classes defines the structure of the response message from Apex controller
    public class VASProductData {
        public Id opportunityLineItemId;
        public Id productId;
        public String productName;
        public Boolean isSelected;
    }

    // JQUEV: 20200804
    // This inner classes defines the structure of the Additional Attributes JSON for Field_Visibility_Per_Product__mdt
    public class AdditionalAttributes {
        public String priceSchemeEntryMapKey;
        public String valueReadPath;
        public String valueWritePath;
        public String picklistOptionsPath;
        public String helpTxt;
        public String dataType;
        public String fieldAPIName;
        public List<Action_cls> actions;
        public List<Attributes_cls> attributes;
    }

    // JQUEV: 20200806
    // This inner classes defines the structure actions that Fields can have e.g. onChane and the method it calls
    public class Action_cls {
        public String action;
        public String method;
    }

    // JQUEV: 20200807
    // This inner classes defines the structure for name/value pairs of html attributes
    public class Attributes_cls {
        public String name;
        public String value;
    }

    // esign the doc //Story W-004373 - Tinashe Shoko - START
    @AuraEnabled
    public static List<Map<String, Object>> getSignatoriesData(Id opportunityId) {
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            return DocumentsShareControllerESign.getSignatoriesData( docList[0].Id  );
        } else {
            system.debug('Signatories Data not found....');
        }
        return null;
    }

    /***
* Tinashe Shoko - W-004373
* Assumption being there is only one quote document per Opportunity or rather last one
* uploaded/generated is valid
* Check if it is valid for e-signing i.e. it has not already been or send for esigning
* Pass Opp Id
* Return Boolean
*/
    @AuraEnabled
    public static boolean documentRestricted(Id opportunityId) {
        boolean restricted = false;
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            restricted = DocumentsShareControllerESign.documentRestricted(opportunityId, docList[0].Id  );
        } else {
            return true;
        }
        return restricted;
    }

    @AuraEnabled
    public static List<String> getAllClientEmailsSignature(Id opportunityId) {
        return DocumentsShareControllerESign.getAllClientEmailsSignature(opportunityId);
    }

    @AuraEnabled
    public static List<String> getMobile(Id opportunityId) {
        return DocumentsShareControllerESign.getMobile(opportunityId);
    }

    @AuraEnabled
    public static List <String> getDigitalSignatorySelectOptions(string fld) {
        return DocumentsShareControllerESign.getDigitalSignatorySelectOptions(fld);
    }

    @AuraEnabled
    public static List<Map<String, Object>> getUpdatedSignatoriesData(Id opportunityId, Id signatoryId, String signatoriesInput, String method, String mobile, String email) {
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        List<Map<String,Object>> listTotal = new List<Map<String,Object>>();
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            return DocumentsShareControllerESign.getUpdatedSignatoriesData(opportunityId, docList[0].Id, signatoryId, signatoriesInput, method, mobile, email);
        }
        return listTotal;
    }

    @AuraEnabled
    public static String sendForImpressionSignature(Id opportunityId, String signatories) {
        String wid;
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        List<Map<String,Object>> listTotal = new List<Map<String,Object>>();
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            return DocumentsShareControllerESign.sendForImpressionSignature(docList[0].Id, signatories);
        }
        return wid;
    }

    /**
* @author Tinashe Shoko
* Method that gets a list of all Impression requests for an Opportunity
*
* @param opportunityId
* @return impressionRequests
*/
    @AuraEnabled
    public static List<ImpressionRequest__c> fetchImpressionRequest(Id opportunityId) {
        List<ImpressionRequest__c> impressionRequests = new ImpressionRequestsSelector().selectRequestsByOpptyId(opportunityId);
        return impressionRequests;
    }

    @AuraEnabled
    public static String getDocumentContent(Id opportunityId, String sharingMethod, String clientEmail) {
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        List<Map<String,Object>> listTotal = new List<Map<String,Object>>();
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            return DocumentsShareControllerESign.getDocumentContent(opportunityId, docList[0].Id, sharingMethod, clientEmail);
        }
        return null;
    }

    @AuraEnabled
    public static String getQuoteDocumentName(Id opportunityId) {
        String docName;
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            docName = docList[0].Name;
        }
        return docName;
    }

    @AuraEnabled
    public static void sendDocumentSharingEmail(String opportunityId) {
        List<Document__c> docList = new DocumentsSelector().selectByTypeAndOppId(opportunityId,StringConstants.QUOTE_DOCUMENT_TYPE);
        if (!docList.isEmpty() && docList != null && docList.size() > 0) {
            String idListJSON = '["' + docList[0].Id + '"]';
            List<OpportunityLineItem> oppLineItemList = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId,1);
            if(oppLineItemList != null && oppLineItemList.size() > 0 && !oppLineItemList.isEmpty()){
                List<Map<String, Object>> signatoriesData = getSignatoriesData(opportunityId);
                if(signatoriesData != null && signatoriesData.size() > 0 && !signatoriesData.isEmpty()){
                    Map<String, Object> mySignData = signatoriesData[0];
                    String clientEmail = String.valueof(mySignData.get('Email'));
                    DocumentsShareControllerESign.sendDocumentSharingEmail(opportunityId, clientEmail, idListJSON);
                } else {
                    system.debug('Error getSignatoriesData');
                }
            }
        }
    }

    // esign the doc //Story W-004373 - Tinashe Shoko - END
}