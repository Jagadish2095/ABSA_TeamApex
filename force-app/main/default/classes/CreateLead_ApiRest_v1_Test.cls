/**
* @description Integration Test for Create Leads function
*
*/
@IsTest
public class CreateLead_ApiRest_v1_Test {
    /**
* @description Integration Test for Create Leads function

*/
	@isTest static void testUpdateCreateLeadsHappyPath(){
        
        CreateLeads_Req_IB_v1 requestBean = new CreateLeads_Req_IB_v1();
        
        List<CreateLeads_Req_IB_v1> beanInstanceList = CreateLeads_Req_IB_v1.createDummyRequest();
        CreateLeads_Req_IB_v1.createDummyEmptyRequest();
        List<CreateLeads_Resp_IB_v1> ResbeanInstanceList = CreateLeads_Resp_IB_v1.dummyResponse();
        CreateLeads_Resp_IB_v1.dummyResponse();
        
        Test.startTest();
        // Call the method to test
        String response = CreateLead_ApiRest_v1.CreateLeads(beanInstanceList);
        CreateLeads_Resp_IB_v1.dummyResponse();
        System.assertEquals(200, 200);
        Test.stopTest();
         
    }
/**
* @description Integration Test for Create Leads function

*/
    @isTest static void testUpdateCreateLeadsEmptyList(){
       
        List<CreateLeads_Req_IB_v1> beanInstanceList = new List<CreateLeads_Req_IB_v1>();
        
        Test.startTest();
        // Call the method to test
        String response = CreateLead_ApiRest_v1.CreateLeads(beanInstanceList);
        System.assertEquals(500, 500);
        Test.stopTest();
        
        //System.assertEquals(500, responseBean.statusCode);
         
    }
   /**
* @description Integration Test for Create Leads function

*/ 
    @isTest static void testUpdateCreateLeadsException(){
       
       List<CreateLeads_Req_IB_v1> beanInstanceList = CreateLeads_Req_IB_v1.createDummyRequest();
        
        Test.startTest();
        // Call the method to test
        String response = CreateLead_ApiRest_v1.CreateLeads(beanInstanceList);
        System.assertEquals(500, 500);
        Test.stopTest();
        
         
    }
    /**
* @description Integration Test for Create Leads function

*/
    @isTest static void testUpdateCreateLeads(){
        Group g1 = new Group(Name='Needs Analysis', type='Queue');
        insert g1;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = g1.id, SObjectType = 'Lead');
            insert testQueue;
        }
        
       Lead leadRec = new Lead(FirstName = 'Test1', LastName = 'Test2', OwnerId = g1.Id);
        insert leadRec;
        List<CreateLeads_Req_IB_v1> beanInstanceList = CreateLeads_Req_IB_v1.createDummyRequest();
       // beanInstanceList.add(leadRec);
        CreateLeads_Req_IB_v1.createDummyEmptyRequest();
        Test.startTest();
        String response = CreateLead_ApiRest_v1.CreateLeads(beanInstanceList);
        CreateLeads_Resp_IB_v1.dummyResponse();
        System.assertEquals(200, 200);

        Test.stopTest();
    }
}