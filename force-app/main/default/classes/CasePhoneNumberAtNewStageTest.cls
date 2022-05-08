/**  
* @description Test Class for CasePhoneNumberAtNewStage
* @Author       : Chenna Kesava Reddy    
* @Created Date : 2021-05-24
*/
@isTest
public class CasePhoneNumberAtNewStageTest {
  
     @isTest static void CaseQAChecklistSelectorTest(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        Case caseRec = new Case(Communication_Method__c = 'Email', 
                                Status = 'New', 
                                Origin = 'Email',
                                Account = account ,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('ATM').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
         System.assert(caseRec != null, 'case Id is null');
        CasePhoneNumberAtNewStage.checkSatgeAsNew('');
        CasePhoneNumberAtNewStage.checkSatgeAsNew(caseRec.id);
        
    }
    }