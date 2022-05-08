/*
Controller Test Class For BranchSiteInfoController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2021-02-19
*
*/

@isTest
public class BranchSiteInfoControllerTest {
    @testSetup
    static void dataCreation(){
        Id recordTypeIdBranch = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Branch Site').getRecordTypeId();
        Site__c site = new Site__c(
            Name = 'Santon',
            Site_Code__c = '1234',
            Unique_Site_Code__c = 'B1234',
            Active__c = true,
            Responsible_Area__c = 'Physical Channel - Branch',
            RecordTypeId = recordTypeIdBranch
        );
        insert site;
    }

    @isTest
    public static void searchNameLike(){
        Test.startTest();
        List<Map<String,Object>> siteinfo = BranchSiteInfoController.searchNameLike('san');
        System.assert(siteinfo != null, 'Test Working');
        Test.stopTest();
    }
}