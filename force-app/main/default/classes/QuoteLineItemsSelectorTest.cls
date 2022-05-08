@isTest 
public class QuoteLineItemsSelectorTest {
    @TestSetup static void makeData(){
        QuotingProcessTestDataFactory QuotProcessfactory = new QuotingProcessTestDataFactory();
    }
    
    @isTest static void quoteLineItemSelectTest(){
        User uA = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('User@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='User@testorg.com') {
                    uA=u;
                }
            }
        }
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id, SyncedQuoteId FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            Set<Id> idSet = new Set<Id>();
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {                    
                    Id oppId = myOpp.Id;
                    List<QuoteLineItem> qteLinItemList = QuotingProcessController.getQuoteLineItemsData(oppId);
                    System.assertEquals(3, qteLinItemList.size());
                    if (!qteLinItemList.isEmpty() && qteLinItemList != null) {
                        for (QuoteLineItem item : qteLinItemList) { 
                            idSet.add(item.Id);
                        }
                        
                        List<QuoteLineItem> newList = new QuoteLineItemsSelector().selectById(idSet);
                        if (!newList.isEmpty() && newList != null)
                            System.assertEquals(3, newList.size());
                        
                        newList = new QuoteLineItemsSelector().selectByQuoteIds(new Set<Id> {myOpp.SyncedQuoteId});
                        if (!newList.isEmpty() && newList != null)
                            System.assertEquals(3, newList.size());
                        
                        newList = new QuoteLineItemsSelector().selectRelatedLineItemsByPartyType(
                            myOpp.SyncedQuoteId,
                            'Lorem Ipsum',
                            null);
                        
                        newList = new QuoteLineItemsSelector().selectRelatedLineItemsByOppPartyType(
                            myOpp.SyncedQuoteId,
                            'Lorem Ipsum',
                            null);
                        
                        newList = new QuoteLineItemsSelector().selectByQuoteIdAndFinancialProduct(
                            myOpp.SyncedQuoteId,
                            new Set<String> {'Flexi Funeral'});
                    }
                }
            }
        } 
    }    
}