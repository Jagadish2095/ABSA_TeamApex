/**
* Sanctioning SLA Tracking batch test to update business hours 
*
* @author  Almas Aleem :absa
* @since   2020-07-21
*/
@isTest
public class SanctioningSLATrackingBatchTest {

 @testSetup
    static void createTestData(){
        List<User> usersList = new List<User>();
        System.runAs(new User(Id=UserInfo.getUserId())){
            usersList = TestDataFactory.getTestUsers('System Administrator (Custom)', 2);
            usersList[0].Business_Area__c = 'WIMI';
            insert usersList;             
        }
        System.runAs(usersList[0]){
            
            List<Opportunity> oppsList = TestDataFactory.getOpportunities(null,'Opportunity_Business_Bank',3);
            insert oppsList;         
        }
    
    }
    
    
    public static testMethod void testSLATracking(){
          List<Opportunity> oppsList = [SELECT Id, Sanctioning_SLA_Hours_Calculated__c,Sanctioning_SLA_End_Date__c,Sanctioning_SLA_Start_Date__c,OwnerId FROM Opportunity WHERE Name LIKE '%Test%'];
         List<User> usersList = [SELECT Id from User WHERE username LIKE '%testuser1%'];
        System.runAs(usersList[0]){
            Integer i =4;
            for(Opportunity opp : oppsList ){
                  
                opp.Sanctioning_SLA_Start_Date__c = system.now();
               
                opp.Sanctioning_SLA_End_Date__c = system.now().addHours(i);
                opp.Is_Submitted_Sanctioning__c = true;
                i=i+4;
            }
             oppsList[0].Sanctioning_SLA_Temp_End_Date__c = system.now().addHours(i-4);
             oppsList[0].Sanctioning_SLA_Temp_Start_Date__c = system.now().addHours(i-8);
             oppsList[0].Sanctioning_SLA_End_Date__c = null;
             update oppsList;
            
            
            Test.startTest();
        
        //Schedule Batch
        SanctioningSLASchedulable sh1 = new SanctioningSLASchedulable();
        String sch = '1 00 * * * ?'; 
        system.schedule('Test SanctioningSLASchedulable', sch, sh1); 
        
        Test.stopTest(); 
          system.assertNotEquals(oppsList[0].Sanctioning_SLA_Temp_Start_Date__c, null);  
        }
    }
}