@isTest 
public class ServiceLevelsSelectorTest {
    
    @isTest
    private static void testSelectById() {
    
        Service_Level__c tstServT = new Service_Level__c();
        
        insert tstServT;
    
        Set<Id> idSet = new Set<Id>();
        idSet.add(tstServT.Id);
        
        Test.startTest();
        
        List<Service_Level__c> lst = new ServiceLevelsSelector().selectById(idSet);
        lst = new ServiceLevelsSelector().selectDefaultServiceType();
        
        Test.stopTest();

    }
}