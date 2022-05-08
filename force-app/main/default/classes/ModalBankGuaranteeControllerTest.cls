/*
* Test Class For ModalBankGuaranteeController
* @author  Himani Joshi: Absa
* @version v1.0
* @since   2021-05-25
*
*/
@IsTest
public class ModalBankGuaranteeControllerTest {
    @testSetup static void createData(){
        Application_Financial_Account__c fin=new Application_Financial_Account__c();
        fin.ClientCode__c='EAEROSP006';
        fin.Facility_account_number__c='18000383364';
        fin.Facility_limit__c='0';
        fin.Product__c='Bank Guarantee';
        fin.Total_Contract_Balance__c='4000';
        fin.Review_date__c=Date.newInstance(2002,07,30);
        fin.Requested_facility_limit__c='6000';
        fin.Requested_review_date__c=Date.today();
        fin.isSelected__c=false;
        insert fin;
        Contract__c con=new Contract__c();
        con.Application_Financial_Account__c=fin.Id;
        con.Contract_amount__c=4000;
        con.Contract_balance__c='4000';
        con.Contract_number__c='899300018';
        con.Contract_sub_product_code__c='LU';
        con.Contract_type__c='2';
        insert con;
    }
    @isTest static void testgetBankGuarantees(){
        Contract__c con=[select Application_Financial_Account__c from Contract__c];
        system.assertNotEquals(null,con);
        test.startTest();
        List<Contract__c> conList=ModalBankGuaranteeController.getLinkedContracts(con.Application_Financial_Account__c);
        test.stopTest();
        
    }

}