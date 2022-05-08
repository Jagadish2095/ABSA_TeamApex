/**
* @description Test class for BusinessHoursSelector
* @since 2019-04-27
**/
@isTest
public with sharing class BusinessHoursSelectorTest {

    /**
    * @description 
    * @author 
    * 
    */
    @isTest
    static void runBusinessHoursSelectorTest(){
        Test.startTest();
            //Id bhrId = [Select Id From BusinessHours Where IsDefault = true].Id;
            BusinessHours bh = [Select Id From BusinessHours Where IsDefault = true];
            Set<Id> ids = new Set<Id>();
            ids.add(bh.Id);
            List<BusinessHours> bhr = new BusinessHoursSelector().selectById(ids);
            bhr = new BusinessHoursSelector().selectDefault();
            bhr = new BusinessHoursSelector().selectSanctioningBusinessHours();
            List<BusinessHours> bhObj = new BusinessHoursSelector().selectByIdName('Mondays to Fridays (08h30 - 17h00) excluding Public Holidays' , 1);
            System.assertEquals(1 ,  bhObj.size());
        Test.stopTest();
    }
}