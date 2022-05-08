@isTest
public class LiveChatTranscriptTriggerTest {
    
    static testMethod void testLiveChat(){
        
        LiveChatVisitor lcv = new LiveChatVisitor();
      
        insert lcv;
   
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
        lct.Visitor_Name__c = 'Chat Client';
        lct.Email__c = 'chat@testchat.com';
        lct.Body = 'Some body text';
        insert lct;
   
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'EndVisitor';
        le.time = system.now();
      
        insert le;
        
        test.startTest();
        
        lct.Transcript_Emailed__c = false;
        update lct;
        
        test.stopTest();
       
    }
    
     static testMethod void testLiveChat1(){
        
         
         //dummy contact
         
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        testContact.Email ='chat@testchat.com'; 
        insert testContact;
         
        LiveChatVisitor lcv = new LiveChatVisitor();
      
        insert lcv;
   
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.LiveChatVisitorid = lcv.id;
        lct.Visitor_Name__c = 'Chat Client';
        lct.Email__c = 'chat@testchat.com';
        lct.Body = 'Some body text';
        lct.ContactId = testContact.Id;
        lct.ChatKey='chat@testchat.com' ;
        lct.Transcript_Emailed__c=true;
        insert lct;
   
        LiveChatTranscriptEvent le = new LiveChatTranscriptEvent();
        le.LiveChatTranscriptId = lct.id;
        le.type = 'EndVisitor';
        le.time = system.now();
      
        insert le;
         
         
        
        test.startTest();
        
        //lct.Transcript_Emailed__c = false;
        update lct;
        
        test.stopTest();
       
    }
   
}