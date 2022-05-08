@IsTest
public class TestOmniChannelController {

    static testMethod void testOmniChannelController() {
        User ownerId =[Select id from user where Isactive = true and profileId ='00e1r000001zvFKAAY' limit 1];
        ownerId.HasLogin__c = false;
        Update ownerId;
        
        System.runAs(ownerId) {

             
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
       
        OmniChannelQue__mdt Que = [Select MasterLabel, sd_Original_Service_QueueId__c from OmniChannelQue__mdt Limit 1];
        system.debug(Que);
        
        Case caseRec = new Case(Communication_Method__c = 'Email', Status = 'New', Origin = 'Email', AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud', OwnerId = ownerId.Id, sd_Original_Service_Queue__c =Que.MasterLabel
                               );
        insert caseRec;
        
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = caseRec.Id; 
        email.ThreadIdentifier = '12323232';
        insert email;
         
       Test.startTest();     
      
          
        OmniChannelController.RassignCase();
            
        OmniChannelController.LoginOnOmniChannel((String)OwnerId.id);
         Test.stopTest();           
        }   
    } 
    
}