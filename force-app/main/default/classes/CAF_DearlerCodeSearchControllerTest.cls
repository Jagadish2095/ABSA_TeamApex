/**
*@description:  Apex Enterprise Design Patters
* Application_Product_CAF__c objects
* @description CAF_DearlerCodeSearchControllerTest
* @author  Rajesh
* @since   04/30/2021 
*/

@isTest()
public class CAF_DearlerCodeSearchControllerTest {
    
    @isTest static void testCustomLookup()
    {
        Account acc = new Account();
        acc.name ='Test';
        insert acc;
        
        List <String> fieldstoShow = new List <String>();
        fieldstoShow.add('Id');
        fieldstoShow.add('Name');
        
        List < sObject > returnList = CAF_DearlerCodeSearchController.fetchLookUpValues('Test', 'Account');
        System.assert(returnList != null);
        
    }
    
}