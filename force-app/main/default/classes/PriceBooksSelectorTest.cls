@isTest
public class PriceBooksSelectorTest {
    @TestSetup static void makeData(){
        QuotingProcessTestDataFactory QuotProcessfactory = new QuotingProcessTestDataFactory();
    }
    
    @isTest static void priceBooksSelectorTest(){
        User uA = new User();
        User uadmin = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('User@testorg.com');
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size()>0) {
            for (User u : userList) {
                if (u.Email=='User@testorg.com') {
                    uA=u;
                }else if (u.Email=='UserAdmin@testorg.com') {
                    uadmin=u;
                }
            }
        }
        System.runAs(uA){
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {
                    Id oppId = myOpp.Id;
                    QuotingProcessController.createQuote(oppId, '300', '10', '50', '50', '30000', '50', '30000', '50', '50', true, '1990-05-05', false, 'Description');
                }
            }
        }
        System.runAs(uadmin){
            Set<Id> idSet = new Set<Id>();
            idSet.add(Test.getStandardPricebookId());
            List<Pricebook2> newList = new PriceBooksSelector().selectById(idSet);
            if (!newList.isEmpty() && newList != null) {
                System.assertEquals(1, newList.size());
            }
        }
    }
}