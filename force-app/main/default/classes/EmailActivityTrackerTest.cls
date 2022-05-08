/**
 * @description       : EmailActivityTrackerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class EmailActivityTrackerTest {
    @testSetup private static void setupData(){
        Map<String,Schema.RecordTypeInfo> rtInfo = CommonUtils.getRecordTypesForsObject('Account');
        Id accRecordTypeId = rtInfo.get('Individual_Prospect').getRecordTypeId();
        Account account = new Account();
        account.FirstName = 'Test';
        account.LastName = 'Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'SNIFFEL001';
        account.Sic = '35790';
        account.AccountNumber = '0';
        account.RecordTypeId = accRecordTypeId;
        account.Registration_Number__c = '1990/011515/23';
        account.PersonEmail='testaccount@absa.africa';
        insert account;
        Account acc = new Account();
        acc.Name = 'Test Service';
        acc.Type = 'Service';
        insert acc;
        List<Opportunity> oppsList = TestDataFactory.getOpportunities(null, 'Investment_Opportunity', 1);
        oppsList[0].StageName = 'In Progress';
        oppsList[0].Sub_Status__c = 'Discovery Stage';
        oppsList[0].accountId = account.Id;
        insert oppsList;
    }

    @isTest private static void sendEmailTest(){
        EmailActivityTracker.FlowInputs emailTracker = new EmailActivityTracker.FlowInputs();
        Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE RecordType.Name='Investment Opportunity' and AccountId != null LIMIT 1];
        Test.startTest();
        emailTracker.OpportunityId = opp.Id;
        emailTracker.AccountId = opp.AccountId;
        emailTracker.templateName = 'Investment_Opp_Finalised';
        EmailActivityTracker.sendEmail(new List<EmailActivityTracker.FlowInputs>{emailTracker});
        Test.stopTest();
        EmailMessage emg = [SELECT Id FROM EmailMessage WHERE relatedtoid =: opp.Id LIMIT 1];
        system.assertEquals(emg != null, true);
    }

}