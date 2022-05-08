/**
 *@Author       : Kalyani Papineni
 *@Created Date : 2021/0129
 *@Purpose      : Test class for PricingMatricesSelector
 */

@isTest
public class PricingMatricesSelectorTest {
    
    public static List<EPP_Pricing_Matrix__c> eppPriMatList = new List<EPP_Pricing_Matrix__c>();
    
    public static void initdata() {
        
        eppPriMatList.add(createEppPriceMatrix(Date.today()-1,18,38,'2.86','1.32','2.86','1.36','1.26',20,'Plan A','Flexi Funeral Fee'));
        eppPriMatList.add(createEppPriceMatrix(System.today(),null,null,'0','0','0','0','10.00',20,'Plan B','Policy Fee'));
    	insert eppPriMatList;
    }
    
    public static EPP_Pricing_Matrix__c createEppPriceMatrix(Date efectDate, Integer endAge, Integer startAge, String execCov, String estCov, String funPlan, string sumIns, string prem, Integer insurance, String plan, String recordType) {
        Map <String, Schema.RecordTypeInfo> EPPPricMatRecordTypeMap = EPP_Pricing_Matrix__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        EPP_Pricing_Matrix__c eppPM = new EPP_Pricing_Matrix__c();
        eppPM.RecordTypeId = EPPPricMatRecordTypeMap.get(recordType).getRecordTypeId();
        eppPM.Effective_Date__c = efectDate;
        eppPM.End_Age__c = endAge;
        eppPM.After_Burial_Benefit_Rate__c = decimal.valueof(estCov);
        eppPM.Child_Rate__c = decimal.valueof(execCov);
        eppPM.Extended_Member_Rate__c = decimal.valueof(funPlan);
        eppPM.Grocery_Benefit_Rate__c = decimal.valueof(prem);
        eppPM.Start_age__c = startAge;
        eppPM.Spouse_Rate__c = decimal.valueof(sumIns);
        eppPM.Premium__c = decimal.valueof(prem);
        eppPM.Sum_Insured__c = decimal.valueof(insurance);
        eppPM.Credit_Life_Plan__c = plan;
        eppPM.Credit_Life_Lowest_Range_Amount__c = decimal.valueof(endAge);
        eppPM.Credit_Life_Highest_Range_Amount__c = decimal.valueof(startAge);
        return eppPM;
    }
    
    @isTest public static void pricematrixtest() {
        
        initdata();
        Test.startTest();
        PricingMatricesSelector ctrl = new PricingMatricesSelector();
        Schema.SObjectType objtype = ctrl.getSObjectType();
        List<Schema.SObjectField> objlist =  ctrl.getSObjectFieldList();
        List<EPP_Pricing_Matrix__c> pricelist = ctrl.selectById(new Set<Id>{eppPriMatList[0].Id,eppPriMatList[1].Id});
        pricelist = ctrl.selectSumAndAgeAndRecordType(double.valueof(20),double.valueof(25),'Flexi Funeral Fee');
        pricelist = ctrl.selectPremiumDiscountRecordType(double.valueof(25),'Flexi Funeral Fee');
        pricelist = ctrl.selectCreditLifePlanRecordType('Plan A','Flexi Funeral Fee');
        pricelist = ctrl.selectCreditLifeDiscountRecordType(double.valueof(18),double.valueof(38),'Flexi Funeral Fee');
        pricelist = ctrl.selectPremiumRecordType(double.valueof(18),'Flexi Funeral Fee');
        pricelist = ctrl.selectByRecordTypeName('Flexi Funeral Fee',1);
        system.assertEquals(pricelist.size(), 1);
        Test.stopTest();
        
    }

}