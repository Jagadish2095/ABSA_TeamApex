/*
Controller Class For merchantOnboardingAcceptedCards component
*
* @author  Tinashe Mutsungi Shoko : Jordiflash
* @version v1.0
* @since   2020-04-02
*
* PJAIN: 20200520: Rewritten the code to make the available and pre selected cards
* selection dynamic based on Merchant Class rather than being hardcoded. The code
* uses a new custom object Accepted_Card__c for configuration.
*
*/
public class merchantOnboardingAcceptedCardsCtrlr {

    @AuraEnabled
    public static Map<String, String> getAcceptedCardsData(String opportunityId, String applicationProductMerchantId, String productFamily) {
        Map<String, String> responseMap = new Map<String, String>();
        List<Application_Product_Merchant__c> applicationProductMerchantList;
        Application_Product_Merchant__c applicationProductMerchant;
        String merchantClass;
        String selectedCards;

        List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(opportunityId, 1);

        if (opportunityLineItems != null && opportunityLineItems.size() > 0) {
            merchantClass = opportunityLineItems.get(0).Merchant_Class__c;

            if (String.isBlank(merchantClass)) {
                // Return with error if merchantClass is blank
                responseMap.put('error', StringConstants.MERCHANT_ERROR_ACCEPTED_CARDS_MERCHANT_CLASS_BLANK);
                return responseMap;
            }
        }

        if (String.isNotBlank(applicationProductMerchantId)) {
            applicationProductMerchantList = new ApplicationProductMerchantsSelector().selectById((Id)applicationProductMerchantId);
        } else {
            applicationProductMerchantList = new ApplicationProductMerchantsSelector().selectByOpportunityId(opportunityId);
        }

        if (applicationProductMerchantList != null && applicationProductMerchantList.size() > 0) {
            applicationProductMerchant = applicationProductMerchantList.get(0);
            applicationProductMerchantId = applicationProductMerchant.Id;
            selectedCards = applicationProductMerchant.Selected_Cards__c;
            responseMap.put('applicationProductMerchantId', applicationProductMerchantId);
        } else {
            // Return with error if applicationProductMerchantId is blank
            responseMap.put('error', StringConstants.MERCHANT_ERROR_APPLICATION_PRODUCT_MERCHANT_NOT_FOUND);
            return responseMap;
        }

        List<Accepted_Card__c> acceptedCards = new AcceptedCardsSelector().selectByMerchantClass(merchantClass, StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD, productFamily);

        Set<String> preSelectedCardSet = new Set<String>();
        Set<String> availableCardSet = new Set<String>();

        // If cards have already been selected and saved on applicationProductMerchant
        // record then add them to preSelectedCardSet
        if (String.isNotBlank(selectedCards)) {
            preSelectedCardSet.addAll(selectedCards.split(';'));
        }

        for (Accepted_Card__c acceptedCard : acceptedCards) {
            // If no cards have been selected and saved on applicationProductMerchant
            // record and the current card record has the merchant class selected then
            // add the current card to the set. If some cards have already been selected
            // then skip this check.
            String preSelectedCards = acceptedCard.Pre_Selected_for_Merchant_Class__c;
            String availableCards = acceptedCard.Available_for_Merchant_Class__c;
            if (String.isBlank(selectedCards) && String.isNotBlank(preSelectedCards) && preSelectedCards.split(';').contains(merchantClass)) {
                preSelectedCardSet.add(acceptedCard.Name);
            }

            // If the current card record has the merchant class selected then add
            // the current card to the set.
            if ((String.isNotBlank(preSelectedCards) && preSelectedCards.split(';').contains(merchantClass)) || (String.isNotBlank(availableCards) && availableCards.split(';').contains(merchantClass))) {
                availableCardSet.add(acceptedCard.Name);
            }
        }

        // Add all cards to available cards
        availableCardSet.addAll(preSelectedCardSet);

        // Convert the set to list to be able to sort and join
        List<String> preSelectedCardList = new List<String>(preSelectedCardSet);
        List<String> availableCardList = new List<String>(availableCardSet);

        // Sort the card lists
        preSelectedCardList.sort();
        availableCardList.sort();

        // Put the cards on the map as a semicolon separated string
        responseMap.put('preSelectedCards', String.join(preSelectedCardList, ';'));
        responseMap.put('availableCards', String.join(availableCardList, ';'));

        return responseMap;
    }
}