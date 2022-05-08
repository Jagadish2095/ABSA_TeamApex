/**
 * @description       : PickListControllerTest
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
@isTest
public class PickListControllerTest {
    @isTest private static  void testAll() {
        test.startTest();
        Document__c doc = new Document__c();
        PickListController.getselectOptions(doc, 'Type__c');
        List<String> result = PickListController.getPickListValuesUsingObjectName('Document__c', 'Type__c');
        PickListController.getPickListValuesWithParentDocumentName('Proof of Address - South African Companies ');
        test.stopTest();
        System.assertEquals(result.isEmpty(), false);
    }
}