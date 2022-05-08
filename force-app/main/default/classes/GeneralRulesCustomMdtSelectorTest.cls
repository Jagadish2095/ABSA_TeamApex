@isTest
public class GeneralRulesCustomMdtSelectorTest {
    @TestSetup static void makeData(){
        QuotingProcessTestDataFactory QuotProcessfactory = new QuotingProcessTestDataFactory();
    }
    
    @isTest static void generalRulesCustomMdtSelectorTest(){
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
            Set<Id> idSet = new Set<Id>();
            List<Opportunity> myOppList = [SELECT Id FROM Opportunity WHERE OwnerID = :uA.Id AND Name ='EPP 1'];
            if (!myOppList.isEmpty() && myOppList != null) {
                for (Opportunity myOpp : myOppList) {                    
                    Id oppId = myOpp.Id;
                    System.assertEquals(18,QuotingProcessController.getSpouseMinAge(oppId));
                    System.assertEquals(65,QuotingProcessController.getSpouseMaxAge(oppId));
                }
            }
            List<General_Rules__mdt> eppSpouseInfoList = new  GeneralRulesCustomMdtSelector().selectByLabelandProduct('EPP Spouse', 'Estate Provider Plan');
            if (!eppSpouseInfoList.isEmpty() && eppSpouseInfoList != null) {
                idSet.add(eppSpouseInfoList.get(0).Id);
                List<General_Rules__mdt> newList = new GeneralRulesCustomMdtSelector().selectById(idSet);
                if (!newList.isEmpty() && newList != null) {
                    System.assertEquals(1, newList.size());
                }
            }
        }
    }
}