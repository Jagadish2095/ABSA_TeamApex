/**
 * @description       :InvClientVerificationControllerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-12
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class InvClientVerificationControllerTest {
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
        account.PersonEmail=userinfo.getUserEmail();
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

    @isTest private static void getUserAccessTest(){
        Opportunity opp = [SELECT Id FROM Opportunity WHERE RecordType.Name='Investment Opportunity'LIMIT 1];
        Test.startTest();
        Boolean result = InvClientVerificationController.getUserAccess(opp.Id);
        Test.stopTest();
        System.assertEquals(result, true);
    }
}