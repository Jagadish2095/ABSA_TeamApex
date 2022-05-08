/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-07-10
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         HAppy                                Modification
 * 1.0   03-18-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class EntityInformationStokvelControllerTest 
{

    private static Account GetstokvelTestAccount() {
        Account account = new Account();

        account.FirstName = '';
        account.LastName = 'Stoweni stokvel';
        account.ID_Type__pc = '';
        account.ID_Number__pc = '';
        account.Client_Group__c = 'Non Individual';
        account.PersonBirthdate = null;
        account.Nationality_List__pc = 'South African';
        account.Country_of_Residence__pc = 'South Africa';
        account.Country_of_Birth__pc = 'South Africa';

        account.CASA_Reference_Number__pc = '' ;
        account.Occupation_Category__pc = 'Advertising';
        account.Occupation_Status__pc = '' ;
     

        List<String> selectOptions = new List<String>();
        Schema.DescribeFieldResult fieldResult = Schema.Account.Source_of_Income__pc.getDescribe();
        account.Source_of_Income__pc = fieldResult.getPicklistValues()[0].getValue();

        insert account;

        return account;
    }  
   

    @isTest 
    public static void TestStokvelCasaScreening() {

        Account account = GetstokvelTestAccount();
        Test.startTest();
        string res = EntityInformationStokvelController.CallScreening(account.Id);
         System.assertNotEquals('',res);
         Test.stopTest();
       
    }
    @isTest
    public static void TestGetRecordTypeId(){

        Test.startTest();
        String resp = EntityInformationStokvelController.getRecordTypeId('IndustriesBusiness', 'Account');
        System.assertNotEquals('', resp);
        Test.stopTest();
    }
 }