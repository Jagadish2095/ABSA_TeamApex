/* @author  Thabo Senkomane
* @since   2020-09-25
*/
@isTest
public class securitiesOfferedSelectorTest {
     /**
     * @description 
     * @author Thabo Senkomane| 2021-06-12 
     **/
     @testSetup static void createData(){
        Account ac =  new Account();
        ac.Name='SOUTH AFRICAN COMPENSATORS (PTY) LTD';
        insert ac;

        contact conRecord=new contact();
        conRecord.AccountId=ac.id;
        conrecord.lastname='TestCon1114';
        insert conRecord;

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.accountid=ac.Id;
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        insert opp;
        Application__c application = new Application__c();
        application.Opportunity__c = opp.Id;
        insert application;
        Security_Offered__c sc1=new Security_Offered__c();
        sc1.Application__c=application.Id;
        sc1.Account__c=ac.Id;
        sc1.Physical_Address_line_1__c=null;
        insert sc1;
     }
 @isTest
 static  void testGetSObjectType() {

        System.assert(new securitiesOfferedSelector().getSObjectType() != null);

    }

    @isTest
        static  void testGetSObjectFieldList() {
        System.assert(new securitiesOfferedSelector().getSObjectFieldList() != null);
    }

    @isTest
    static  void testselectByApplicationId() {

        Opportunity testOpportunity = [select Id, accountId from Opportunity LIMIT 1];
        Contact con=[select Id from Contact LIMIT 1];
        Application__c app=[select Id from Application__c LIMIT 1];

        System.assert(new securitiesOfferedSelector().selectByApplicationId(testOpportunity.Id) != null);
        new securitiesOfferedSelector().selectByContactId(con.Id);
        new securitiesOfferedSelector().selectByAppIdAndContactId(app.Id, con.Id);
        new securitiesOfferedSelector().selectByAppIdAndAccountId(app.Id, testOpportunity.accountId);
        new securitiesOfferedSelector().selectByAppIdAndRefNum(app.Id, '1234567890');
        new securitiesOfferedSelector().selectExternalSecuritiesOffered(app.Id);
    }
    //Not my method.Added By Himani Joshi just to increase the code coverage.
    @isTest
    static  void testselectByAccountId() {
       Account acc=[select Id from Account Limit 1];
       test.startTest(); 
       System.assert(new securitiesOfferedSelector().selectByAccountId(acc.Id) != null);
       test.stopTest();

    }

    //Added By Himani Joshi
    @isTest
    static  void testselectById() {
        Security_Offered__c soc=[select Id from Security_Offered__c LIMIT 1];
        test.startTest();
        System.assert(new securitiesOfferedSelector().selectById(soc.Id) != null);
        test.stopTest();
    }
}