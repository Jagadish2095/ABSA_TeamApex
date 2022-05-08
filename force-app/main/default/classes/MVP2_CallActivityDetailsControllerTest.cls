/*
*  Test class for MVP2_NoContactNoticeController
*  @author  Vitthal Jivrag
*  @version v1.0
*  @since   2021-02-25
*
*/

@isTest
public class MVP2_CallActivityDetailsControllerTest {
    
    @testSetup
    private static void setTestData(){
        Id leadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('STI Lead').getRecordTypeId();
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('STI').getRecordTypeId();
        
        
        Account acc=new Account();
        acc.Name='Test Acc';
        insert acc;
        
        String oid=userinfo.getuserId();
        
        
        Opportunity opp = new Opportunity();
        opp.Name='test1';
        opp.Parent_Account__c=acc.id;
        opp.OwnerId=oid;
        opp.StageName='In Progress';
        opp.RecordTypeId=oppRecordTypeId;
        opp.CloseDate=date.today()+2;
        insert opp;
        
        
        Task tskObj=new Task();
        tskObj.Call_ID__c='Tsest';
        insert tskObj;        
        
    }
    
    @isTest
    public static void testCallactivity(){
      Opportunity opp=[select id from Opportunity];  
      MVP2_CallActivityDetailsController.getListOfCallActivity(opp.Id);
    }
}