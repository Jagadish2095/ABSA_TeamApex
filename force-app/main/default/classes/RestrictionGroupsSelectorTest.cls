@isTest
public class RestrictionGroupsSelectorTest {

    @isTest
    public static void testRestrictionGroups() {
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account acct = new Account(Name = 'Test Account');
        Contact con = new Contact(Title='ContactTest',Phone='87837743123456769',LastName='ContactTest');
        insert con;
        insert acct;
        
        Case cse = new Case(Communication_Method__c = 'Email',
                            Status = 'New',
                            Origin = 'Email', 
                            AccountId = acct.Id,
                            Risk_Management_Centre__c = 'Digital Fraud',
                            Email__c = 'test@test.com',
                            recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                            Subject = 'test',
                            Description = 'test',
                            Expectation_of_the_Customer__c = 'test',
                            Incident_Date__c = date.today());
        insert cse;
        
        RestrictionGroup__c currentRestriction = new RestrictionGroup__c();
        currentRestriction.Status__c = 'Approved';
        currentRestriction.GroupID__c = 'Test';
        currentRestriction.Restriction_ID__c = 'Test';
        currentRestriction.Case__c = cse.Id;
        insert currentRestriction;
        
        RestrictionGroupsSelector selector = new RestrictionGroupsSelector();
        selector.selectByCaseId(new Set<Id>{cse.Id});
    }
}