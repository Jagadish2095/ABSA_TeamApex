/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-07-09
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-07-07   Sandeep Golla   Initial Version
**/
@isTest
public class DataPrivacyRBCaseSelectorTest {

    @isTest
    public static void testMandate(){

        List<Data_Privacy_RB_Case__mdt> dpList = new List<Data_Privacy_RB_Case__mdt>();
        Data_Privacy_RB_Case__mdt md1=new Data_Privacy_RB_Case__mdt();
        md1.Queue_Name__c = 'SPM_Data_Privacy';
        md1.RBB_Super_Region__c='Central';
        md1.SBU_Segment__c='106';

        Data_Privacy_RB_Case__mdt md2=new Data_Privacy_RB_Case__mdt();
        md2.Queue_Name__c='Business_Private_Banking';
        md2.RBB_Super_Region__c='';
        md2.SBU_Segment__c='H';

        Test.startTest();

        List<Data_Privacy_RB_Case__mdt> lst = new DataPrivacyRBCaseSelector().getQueueBasedOnSBUSegmentAndRegion('H','');
        System.assertEquals(lst.size(), 1);
        Test.stopTest();
    }
}