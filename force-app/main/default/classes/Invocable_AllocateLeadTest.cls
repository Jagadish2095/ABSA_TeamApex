@isTest
public class Invocable_AllocateLeadTest {

    @isTest
    static void runLeadAllocationTest(){

        //Create Parent Group
        Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 
 
        
		
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
       system.runAs(thisUser){
       
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
           
        UserRole r = new UserRole(DeveloperName = 'Test_Role1', Name = 'Test Role1');
        insert r;

            User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = 'puser000@cs.com',
                Username = 'puser000@cs.com' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = r.Id
            );
           
           insert u;
       }

        Service_Type__c tstServT = new Service_Type__c();
        insert tstServT;
        
        Service_Group__c tstServQ = new Service_Group__c();
        tstServQ.Name = 'Test Group1';
        insert tstServQ;
        
        Service_Group_Type__c tstServQT = new Service_Group_Type__c();
        tstServQT.Service_type__c = tstServT.Id;
        tstServQT.Service_Group__c = tstServQ.Id;
        insert tstServQT;
       
        List<Lead_Allocation_Staging__c> recList = new List<Lead_Allocation_Staging__c>();
        
        Lead_Allocation_Staging__c la = new Lead_Allocation_Staging__c();
        
        la.Process_Status__c = 'New';
        la.CIF__c = 'TEST CIF';
        la.Lead_Source__c= 'Email';
        la.Product_Interest__c= '';
        la.Lead_Status__c= '';
        la.Service_Group__c= 'Test Group1';
        la.Campaign_Name__c= '';
        la.First_Name__c= 'testlead';
        la.Last_Name__c= 'testlead';
        la.ID_Number__c= '';
        la.Cell_Phone_Number__c= '8989898';
        la.Email_Address__c= 'test@test.com';
        la.Phone_Number__c= '01187878';
        la.Role__c = 'Test Role1';
		
        recList.add(la);
        
		Lead_Allocation_Staging__c la2 = new Lead_Allocation_Staging__c();
        la2.Process_Status__c = 'New';
        la2.CIF__c = 'TEST CIF2';
        la2.Lead_Source__c= 'Email';
        la2.Product_Interest__c= '';
        la2.Lead_Status__c= '';
        la2.Service_Group__c= 'Test Group';
        la2.Campaign_Name__c= '';
        la2.First_Name__c= 'testlead2';
        la2.Last_Name__c= 'testlead2';
        la2.ID_Number__c= '';
        la2.Cell_Phone_Number__c= '8989898';
        la2.Email_Address__c= 'test2@test.com';
        la2.Phone_Number__c= '01187878';       
        
        recList.add(la2);
        
        Lead_Allocation_Staging__c la3 = new Lead_Allocation_Staging__c();
        la3.Process_Status__c = 'New';
        la3.CIF__c = 'TEST CIF';
        la3.Lead_Source__c= 'Email';
        la3.Product_Interest__c= '';
        la3.Lead_Status__c= '';
        la3.Service_Group__c= 'Test Groupxx';
        la3.Campaign_Name__c= '';
        la3.First_Name__c= 'testlead';
        la3.Last_Name__c= 'testlead';
        la3.ID_Number__c= '';
        la3.Cell_Phone_Number__c= '8989898';
        la3.Email_Address__c= 'test@test.com';
        la3.Phone_Number__c= '01187878';
        la3.Role__c = 'Test Role1';
        
        recList.add(la3);
        
        Lead_Allocation_Staging__c la4 = new Lead_Allocation_Staging__c();
        
        la4.Process_Status__c = 'New';
        la4.CIF__c = 'TEST CIF';
        la4.Lead_Source__c= 'Email';
        la4.Product_Interest__c= '';
        la4.Lead_Status__c= '';
        la4.Service_Group__c= 'Test Group1';
        la4.Campaign_Name__c= '';
        la4.First_Name__c= 'testlead';
        la4.Last_Name__c= 'testlead';
        la4.ID_Number__c= '';
        la4.Cell_Phone_Number__c= '8989898';
        la4.Email_Address__c= 'test@test.com';
        la4.Phone_Number__c= '01187878';
        recList.add(la4);
        
        insert recList;

        Test.startTest();
        List<Invocable_AllocateLead.Request> requestList = new List<Invocable_AllocateLead.Request>();
        
        Invocable_AllocateLead.Request request = new Invocable_AllocateLead.Request();
        request.role = la.Role__c;
        request.serviceGroup = la.Service_Group__c;
        requestList.add(request);



        Invocable_AllocateLead.Request request2 = new Invocable_AllocateLead.Request();
        request2.role = la2.Role__c;
        request2.serviceGroup = la2.Service_Group__c;
        requestList.add(request2);

        Invocable_AllocateLead.Request request3 = new Invocable_AllocateLead.Request();
        request3.role = la3.Role__c;
        request3.serviceGroup = la3.Service_Group__c;
        requestList.add(request3);

        Invocable_AllocateLead.Request request4 = new Invocable_AllocateLead.Request();
        request4.role = la4.Role__c;
        request4.serviceGroup = la4.Service_Group__c;
        requestList.add(request4);

        List<Invocable_AllocateLead.Result> assignedLeads = Invocable_AllocateLead.assignLead(requestList);

        System.assertEquals('There are no users for Lead assignment in this branch Test Group1, or not configured correctly, please ask your administrator for help!',assignedLeads[0].errorMessage);
        System.assertEquals('There are no users for Lead assignment in this branch Test Group, or not configured correctly, please ask your administrator for help!',assignedLeads[1].errorMessage);
        System.assertEquals('There are no users for Lead assignment in the public group Test Groupxx, or not configured correctly, please ask your administrator for help!',assignedLeads[2].errorMessage);
        System.assertNotEquals(null,assignedLeads[3].ownerId);
            
       
        Test.stopTest();
    } 
   
}