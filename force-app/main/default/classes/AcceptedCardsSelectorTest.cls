@isTest
public class AcceptedCardsSelectorTest {

    @TestSetup
    static void makeData(){
        Transaction_Group__c transactionGroup = new Transaction_Group__c();
        insert transactionGroup;

        Accepted_Card__c acceptedCard = new Accepted_Card__c();
        acceptedCard.Name = 'American Express';
        acceptedCard.Transaction_Group__c = transactionGroup.Id;
        acceptedCard.Plan_Type__c = 'CP1';
        acceptedCard.Pre_Selected_for_Merchant_Class__c = 'RETAIL';
        acceptedCard.Available_for_Merchant_Class__c = 'RESTAURANT';
        acceptedCard.Type__c = StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD;
        acceptedCard.Product_Family__c = 'Merchant';
        insert acceptedCard;
    }

    @isTest
    private static void testSelectById() {
        Accepted_Card__c acceptedCard = [SELECT Id FROM Accepted_Card__c LIMIT 1];

        Set<Id> IdSet = new Set<Id>();
        IdSet.add(acceptedCard.Id);
        List<Accepted_Card__c> acceptedCardLst = new AcceptedCardsSelector().selectById(IdSet);

        System.assertEquals(acceptedCardLst.size(), 1);
    }

    @isTest
    private static void testSelectByMerchantClass() {
        List<Accepted_Card__c> acceptedCardLst = new AcceptedCardsSelector().selectByMerchantClass('RETAIL', StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD, 'Merchant');

        System.assertEquals(acceptedCardLst.size(), 1);
    }

    @isTest
    private static void testSelectByName() {
        List<Accepted_Card__c> acceptedCardLst = new AcceptedCardsSelector().selectByName(new Set<String>{'American Express'}, StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD);

        System.assertEquals(acceptedCardLst.size(), 1);
    }

    @isTest
    private static void testSelectByType() {
        List<Accepted_Card__c> acceptedCardLst = new AcceptedCardsSelector().selectByType(StringConstants.MERCHANT_ACCEPTED_CARD_TYPE_CARD);

        System.assertEquals(acceptedCardLst.size(), 1);
    }
}