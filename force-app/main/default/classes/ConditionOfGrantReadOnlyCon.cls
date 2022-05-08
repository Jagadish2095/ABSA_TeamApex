/**
 * @description       : Controller used by lightning components for Conditions of grant
 * @author            : Gulafsha
 * @last modified on  : 2021-07-13
 * @last modified by  : Gulafsha
 * Modifications Log 
 * Ver   Date         Author     Modification
 * 1.0   2021-07-13   Gulafsha   Initial Version
**/


public class ConditionOfGrantReadOnlyCon {
    /**
    * @description getApplicationDetails
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return Application__c 
    **/
    @AuraEnabled
    public static Application__c getApplicationDetails(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        return app;
    }
    /**
    * @description getApplicationConditions
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return List<Application_Condition__c> 
    **/
    @AuraEnabled
    public static List<Application_Condition__c> getApplicationConditions(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Condition__c> appconditionList = new List<Application_Condition__c>([SELECT Id,Type__c,Category__c,Condition__c,Comment__c FROM Application_Condition__c where application__c =:app.id]);
        return appconditionList;
    }
    /**
    * @description getApplicationConditionPrecedent
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return List<Application_Condition__c> 
    **/
    @AuraEnabled
    public static List<Application_Condition__c> getApplicationConditionPrecedent(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id CPRecId =  rtMapByName.get('Conditions Precedent').getrecordtypeId();
        List<Application_Condition__c> appconditionList = new List<Application_Condition__c>([SELECT Id,SignedByBothParties__c,
                                                                                              Copy_of_BR_CD__c,SignedCopyECI__c,
                                                                                              FormAcceptable__c, CertifiedCopyResolution__c,
                                                                                              FICA_Info_Reqd__c,No_Conditions_Precedent__c
                                                                                              FROM Application_Condition__c
                                                                                              where application__c =:app.id 
                                                                                              and recordtypeid=:CPRecId limit 1]);
        return appconditionList;
        
    }
    /**
    * @description deleteApplicationConditions
    * @author Gulafsha | 2021-07-13 
    * @param appCondition 
    **/
    @AuraEnabled
    public static void deleteApplicationConditions(Id appCondition) {
        Application_Condition__c appconditionrec = new Application_Condition__c();
        appconditionrec.id=appCondition;
        delete appconditionrec;
    }
    /**
    * @description getApplicationConditionsRecordTypes
    * @author Gulafsha | 2021-07-13 
    * @return map<String, Id> 
    **/
    @AuraEnabled
    public static map<String,Id> getApplicationConditionsRecordTypes() {
        map<String,Id>  recordtypemap =  new map<String,Id>(); 
        Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        recordtypemap.put('CustomerCondition',rtMapByName.get('Customer Condition').getrecordtypeId());
        recordtypemap.put('InternalCondition',rtMapByName.get('Internal Condition').getrecordtypeId());
        return recordtypemap;   
    }
    /**
    * @description saveCoP
    * @author Gulafsha | 2021-07-13 
    * @param values 
    * @param oppId 
    **/
    @AuraEnabled
    public static void saveCoP(List<String> values,Id oppId) {
        List<Application_Condition__c> apclist = getApplicationConditionPrecedent(oppId);
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id CPRecId =  rtMapByName.get('Conditions Precedent').getrecordtypeId();
        Application_Condition__c apc = new Application_Condition__c();
        if(values!=null && values.size()>0){
            apc.Application__c =  app.Id;
            apc.Name = 'App Condition'+app.Name;
            apc.RecordTypeId = CPRecId;
            apc.SignedByBothParties__c = values[0];
            apc.Copy_of_BR_CD__c = values[1];
            apc.SignedCopyECI__c = values[2];
            apc.FormAcceptable__c = values[3];
            apc.CertifiedCopyResolution__c = values[4];
            apc.FICA_Info_Reqd__c = values[5];
            apc.No_Conditions_Precedent__c = values[6];
            if(apclist!=Null && apclist.size()>0){
                apc.Id = apclist[0].Id;
            }
            upsert apc;
        }
    }
    /**
    * @description getRelatedParties
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return List<AccountContactRelation> 
    **/
    @AuraEnabled
    public static List<AccountContactRelation> getRelatedParties(Id oppId) {
        Account acc=new AccountsSelector().selectIndvByOpportunityId(oppId);
        System.debug('acc '+acc);
        List<Map<String,Object>> listParties = new List<Map<String,Object>>();
        List<AccountContactRelation> accnRelList = new List<AccountContactRelation>();
         accnRelList =  [SELECT Id, Contact.FirstName, Contact.LastName, Contact.Title,Roles,
                         Share_Percentage__c 
                         FROM AccountContactRelation 
                         WHERE AccountId =: acc.id AND Roles INCLUDES('Director','Shareholder/Controller') order by Share_Percentage__c];
     return accnRelList;
    }
    /**
    * @description getSpecialCondition
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return List<Application_Condition__c> 
    **/
   @AuraEnabled
    public static List<Application_Condition__c> getSpecialCondition(Id oppId) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id SCRecId =  rtMapByName.get('Special Condition').getrecordtypeId();
        List<Application_Condition__c> appconditionList = new List<Application_Condition__c>([SELECT Id,Negative_Pledge__c,
                                                                                              Subordination_Agreement__c,Shareholder_s_Directors_s__c,
                                                                                              External_Conditions_of_Grant__c, Internal_Conditions_of_Grant__c
                                                                                              FROM Application_Condition__c
                                                                                              where application__c =:app.id 
                                                                                              and recordtypeid=:SCRecId limit 1]);
        return appconditionList;
        
    }
    /**
    * @description saveSpecialCondition
    * @author Gulafsha | 2021-07-13 
    * @param values 
    * @param oppId 
    * @param ShareholderDirectorVal 
    * @param ExternalCOG 
    * @param InternalCOG 
    **/
     @AuraEnabled
    public static void saveSpecialCondition(List<String> values,Id oppId, String ShareholderDirectorVal,String ExternalCOG,String InternalCOG) {
        List<Application_Condition__c> apclist = getApplicationConditionPrecedent(oppId);
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Schema.DescribeSObjectResult d = Schema.SObjectType.Application_Condition__c;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Id SCRecId =  rtMapByName.get('Special Condition').getrecordtypeId();
        Application_Condition__c apc = new Application_Condition__c();
        if(values!=null && values.size()>0){
            apc.Application__c =  app.Id;
            apc.Name = 'App Condition'+app.Name;
            apc.RecordTypeId = SCRecId;
            apc.Subordination_Agreement__c = values[0];
            apc.Negative_Pledge__c = values[1];
            apc.Shareholder_s_Directors_s__c = ShareholderDirectorVal;
            apc.External_Conditions_of_Grant__c = ExternalCOG;
            apc.Internal_Conditions_of_Grant__c = InternalCOG;
            
            if(apclist!=Null && apclist.size()>0){
                apc.Id = apclist[0].Id;
            }
            upsert apc;
        }
    }
    /**
    * @description getSecuritiesOffered
    * @author Gulafsha | 2021-07-13 
    * @param oppId 
    * @return List<Security_Offered__c> 
    **/
     @AuraEnabled
    public static List<Security_Offered__c> getSecuritiesOffered(Id oppId){
        List<Security_Offered__c> rtnList = new List<Security_Offered__c>();
        //String sObjName = oppId.getSObjectType().getDescribe().getName();
        List<Application__c> applicationLst = new List<Application__c>();
        OpportunitiesSelector opprunitySelector = new OpportunitiesSelector();
            List<Opportunity> opprunityList = opprunitySelector.selectByOpportunityId(oppId);
            applicationLst  = new ApplicationsSelector().selectByOpportunityId(oppId);
            List<String> BondType = new List<String>();
            BondType.add('CESSBOND - CESSION OF EXTERNAL BOND');
            BondType.add('MARBOND - MARINE BOND');
            BondType.add('AIRBOND - AIROPLANE BOND');
            BondType.add('99YLR - 99-YEAR LEASEHOLD RIGHTS');
        system.debug('Applicationn'+applicationLst);
        system.debug('BondTypee'+BondType);
        if(applicationLst.size() > 0 && applicationLst != null ){
            rtnList = new securitiesOfferedSelector().selectByApplicationIdCOG(applicationLst[0].Id,'Bonds and 99-year Leasehold',BondType);
            
            /*rtnList = [select id,bond_type__c,Client_Name__c from Security_Offered__c 
                       where Application__c=:applicationLst[0].Id AND Security_Type__c='Bonds and 99-year Leasehold'
                      AND bond_type__c in:BondType];*/
        }
        return rtnList;
    }
    /**
    * @description saveOtherSecurities
    * @author Gulafsha | 2021-07-13 
    * @param updateSOList 
    **/
    @AuraEnabled
    public static void saveOSec(List<Security_Offered__c> updateSOList) {
        List<Security_Offered__c> newList = new List<Security_Offered__c>();
        Security_Offered__c secOffRec = new Security_Offered__c();
        for(Security_Offered__c secrec: updateSOList){
            secOffRec = new Security_Offered__c();
            if(secrec.Id!=Null){
               secOffRec.Id = secrec.Id;
               secOffRec.Other_Securities__c = secrec.Other_Securities__c;
               newList.add(secOffRec);
            }
            
        }
        if(newList.size()>0){
            update newList;
        }
           
    }

}