/**
 * @description       : Test class for the selector layer of WorstRiskSelector
 * @author            : Himani Joshi
 * @last modified on  : 2021-07-12
 * @last modified by  : Himani Joshi
 * Modifications Log 
 * Ver   Date         Author         Modification
 * 1.0   2021-07-12   Himani Joshi   Initial Version
**/

@IsTest
public class WorstRiskSelectorTest {
   
    @IsTest static void testGetSObjectType() {
        test.startTest();
        System.assert(new WorstRiskSelector().getSObjectType() != null);
        test.stopTest();
    }

    @IsTest static  void testGetSObjectFieldList() {
        test.startTest();
        System.assert(new WorstRiskSelector().getSObjectFieldList() != null);
        test.stopTest();
    }
    @IsTest static void testgetApplicationExposureRisks() {
        test.startTest();
        System.assert(new WorstRiskSelector().getSequenceNumber() != null);
        test.stopTest();
    }

}