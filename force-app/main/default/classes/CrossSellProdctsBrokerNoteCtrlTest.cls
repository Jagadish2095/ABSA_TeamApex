/**
* Test class for SubmitDocumentsController
* @author  Divya
* @created 2020-12-05
*/
@istest
public class CrossSellProdctsBrokerNoteCtrlTest {

     public static testmethod void testvalidate(){
         Contact con=new Contact();
        con.lastname='Testing';
        con.email='test@test.com';
        insert con;
         case caseRec=new case();
         caseRec.contactid=con.Id;
         caseRec.Cross_Sell_Products_Broker_Note__c='Investment,Retirement';
         insert caseRec;
         
         CrossSellProductBrokerNoteCtrl.queryAllProducts();
         CrossSellProductBrokerNoteCtrl.sendEmailToTeam(caseRec.Id,'Investment');
     }
    
}