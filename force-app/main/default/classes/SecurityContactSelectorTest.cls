/**
* Apex Enterprise Design Patters
* Test Class for the Selector layer for Security_Offered_Contact_Relationship__c objects
*
* @author  Himani Joshi
* @since   17/10/2020
*/
@IsTest
public class SecurityContactSelectorTest {
    @testSetup static void createData(){
        Account ac = new Account();
        ac.Name='SOUTH AFRICAN COMPENSATORS (PTY) LTD';
        insert ac;
        Contact con=new Contact();
        con.AccountId=ac.Id;
        con.FirstName='alfie';
        con.lastname='Smithers';
        con.Email='takalani.ndou@absa.africa';
        con.Phone='0782895686';
        con.MobilePhone='0782895686';
        insert con;
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.accountid=ac.Id;
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
    static testMethod void testGetSObjectType() {
        test.startTest();
        System.assert(new SecurityContactSelector().getSObjectType() != null);
        test.stopTest();
    }

    static testMethod void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new SecurityContactSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    static testMethod void testgetSecurityContacts() {
        Security_Offered__c soc=[select Id from Security_Offered__c Limit 1];
        Contact contact=[select Id from contact Limit 1];
        test.startTest();
        System.assert(new SecurityContactSelector().getSecurityContacts(soc.Id,contact.Id) != null);
        test.stopTest();
    }

}