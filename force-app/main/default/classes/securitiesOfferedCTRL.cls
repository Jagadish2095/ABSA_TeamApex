/**
 * @description       : 
 * @author            : saurabh.pandey@absa.africa ,tinashe.shoko@absa.africa
 * @last modified on  : 2021-06-11
 * @last modified by  : almas.aleem@absa.africa
 * Modifications Log 
 * Ver   Date         Author                    Modification
 * 1.0   2021-06-11   tinashe.shoko@absa.africa,thabo   Initial Version
**/

public class securitiesOfferedCTRL {

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppId 
    * @return List<Map<String, Object>> 
    **/
    @AuraEnabled
    public static List<Map<String, Object>> getRelatedParties(Id oppId) {

        List<Map<String,Object>> listParties = new List<Map<String,Object>>();
        Account acccount = new AccountsSelector().selectByOpportunityId(oppId);

        //Tinashe - Defect W-010641 CLUBS - Securities Offered: Related Parties must not be displayed for selection
        if (acccount.Client_Type__c == 'Clubs' || acccount.Client_Type__c == 'Clubs/Societies/Associations/Other Informal Bodies'
        || acccount.Client_Type__c == 'Schools' || acccount.Client_Type__c == 'Non Profit Organizations (NGO)'
        || acccount.Client_Type__c == 'Non-Profit Organisations and Friendly Societies' || acccount.Client_Type__c == 'Non Profit Companies'){
            return listParties;
        }
        //Tinashe - Defect W-010641 CLUBS - Securities Offered: Related Parties must not be displayed for selection

        List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);
        List<Application__c> applicationRecList = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);

       // System.debug('accnRelList '+accnRelList);

        Application__c application = new Application__c();
        if (applicationRecList != null && applicationRecList.size() > 0)
            application = applicationRecList[0];

        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);

        for(AccountContactRelation accnRel : accnRelList) {
            if(accnRel.Share_Percentage__c>0){
            Map<String,String> mapObj = new Map<String,String>();
            mapObj.put('Id', accnRel.Id);
            mapObj.put('AccountId', accnRel.AccountId);
            mapObj.put('ContactId', accnRel.ContactId);
            mapObj.put('FullName', String.valueOf(accnRel.Contact.FirstName + ' ' + accnRel.Contact.LastName));
            mapObj.put('IDNumber', accnRel.Contact.ID_Number__c);
            mapObj.put('CIF', accnRel.Account.CIF__c);
            mapObj.put('Nationality', accnRel.Contact.Nationality__c);

            listParties.add(mapObj);
            }
           // system.debug('value of Map '+listParties);
        }
        return listParties;
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param memberId 
    * @return AccountContactRelation 
    **/
    @AuraEnabled
    public static AccountContactRelation getSelectedMemberDetails(id memberId) {
        AccountContactRelation accnRelList = new AccountContactRelation();
        try{
            accnRelList = new AccountContactRelationSelector().selectbyAccountContactRelationId(memberId);
        } catch(Exception e){
            system.debug('ERROR ' + e.getMessage());
            accnRelList = null;
        }
        return accnRelList;
    }
    
    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppId 
    * @return List<OpportunityLineItem> 
    **/
    @AuraEnabled
    public static List<OpportunityLineItem> getOpportunityLineItems (Id oppId){
        return new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param opportunityId 
    * @return String 
    **/
    @AuraEnabled
    public static String getApplicationId(Id opportunityId){
        return new ApplicationsSelector().selectByOpportunityId(opportunityId).get(0).Id;
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppId 
    * @return List<Security_Offered__c> 
    **/
    @AuraEnabled
    public static List<Security_Offered__c> getSecuritiesOffered(Id oppId){
        List<Security_Offered__c> rtnList = new List<Security_Offered__c>();
        String sObjName = oppId.getSObjectType().getDescribe().getName();
        List<Application__c> applicationLst = new List<Application__c>();
        if(sObjName =='Opportunity'){
            OpportunitiesSelector opprunitySelector = new OpportunitiesSelector();
            List<Opportunity> opprunityList = opprunitySelector.selectByOpportunityId(oppId);
            applicationLst  = new ApplicationsSelector().selectByOpportunityId(oppId);

        }
        else if(sObjName =='Case'){
            Case caseRec= [select id,Subject,Opportunity__c from case where Opportunity__c= :oppId];
            //oppId = caseRec.Opportunity__c;
            applicationLst  = new ApplicationsSelector().selectByOpportunityId(caseRec.Opportunity__c);
        }
        if(applicationLst.size() > 0 && applicationLst != null ){
            rtnList = new securitiesOfferedSelector().selectByApplicationId(applicationLst[0].Id);
        }
        return rtnList;
    }

    
    /**
    * @description getSecuritiesOfferedByAccount description
     * Should this not return only the securities offered by the particular Security Provider?
    * @author Tinashe.shoko@absa.africa | 2021-06-11 
    * @param oppId 
    * @param memberId 
    * @return List<Security_Offered__c> 
    **/
    @AuraEnabled
    public static List<Security_Offered__c> getSecuritiesOfferedByAccount(Id oppId,id memberId){
        List<Application__c> applicationLst  = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Security_Offered__c> secOffList = new List<Security_Offered__c>();
        try {
            if (DocumentController.getParentObjectName(memberId) == 'AccountContactRelation') {
                AccountContactRelation accnRec = new AccountContactRelationSelector().selectbyAccountContactRelationId(memberId);
                if(!applicationLst.isEMpty() && applicationLst.size() > 0 && applicationLst != null  && accnRec != null ){
                    secOffList = new securitiesOfferedSelector().selectByAppIdAndContactId(applicationLst.get(0).id, accnRec.ContactId);
                }
            } else if (DocumentController.getParentObjectName(memberId) == 'Account' && !applicationLst.isEMpty() && applicationLst.size() > 0 && applicationLst != null ) {
                secOffList = new securitiesOfferedSelector().selectByAppIdAndAccountId(applicationLst.get(0).id, memberId);
            } else {
                secOffList = new securitiesOfferedSelector().selectExternalSecuritiesOffered(applicationLst.get(0).id);
            }
        }catch(Exception e){
            system.debug('ERROR ' + e.getMessage());
        }
        return secOffList;
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppId 
    * @return List<Security_Offered__c> 
    **/
    @AuraEnabled
    public static List<Security_Offered__c> getSecuritiesOfferedByExternalEntity(Id oppId){
        List<Application__c> applicationLst  = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Security_Offered__c> secOffList = new List<Security_Offered__c>();
        if (!applicationLst.isEMpty() && applicationLst.size() > 0 && applicationLst != null) {
            secOffList = new securitiesOfferedSelector().selectExternalSecuritiesOffered(applicationLst.get(0).id);
        }else {
            system.debug('ERROR - No Application List');
        }
        return secOffList;
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppId 
    * @return Account 
    **/
    @AuraEnabled
    public static Account getPrimaryAccount(Id oppId){
        Account account = new Account();
        if (DocumentController.getParentObjectName(oppId) == 'Opportunity')
            account = new AccountsSelector().selectByOpportunityId(oppId);

        if (DocumentController.getParentObjectName(oppId) == 'Account')
            account = new AccountsSelector().selectAllById(oppId);

        return account;
    }

    /**
    * @description 
    * @author almas.aleem@absa.africa | 2021-06-11 
    * @param oppid 
    * @param productid 
    * @return List<opportunitylineitem> 
    **/
    @AuraEnabled
    public static List<opportunitylineitem> getProductList(Id oppid, Id productid){
        List<opportunitylineitem> oppproduct= new  OpportunityLineItemsSelector().selectByOpportunityId(oppId);
        return oppproduct;
    }

    /**
    * @description 
    * @author  Tinashe.shoko@absa.africa  | 2021-06-11 
    * @param oppId 
    * @return List<Application_Product__c> 
    **/
    @AuraEnabled
    public static List<Application_Product__c> getOpportunityApplicationProducts(String oppId) {
        List<Application_Product__c> appPrdList = new List<Application_Product__c>();
        appPrdList = new ApplicationProductSelector().selectLinkedUniqueIDAndRefAccByOppId(oppId); //selectByOpportunityId(oppId); // Tinashe
        return appPrdList;
    }

    /**
    * @description 
    * @author  Tinashe.shoko@absa.africa  | 2021-06-11 
    * @param oppId 
    * @return List<Application_Product__c> 
    **/
    @AuraEnabled
    public static List<Application_Product__c> getUniqueIdentifiers(String oppId) {
        List<Application_Product__c> appPrdList = new List<Application_Product__c>();
        appPrdList = new ApplicationProductSelector().selectUniqueIentifiers(oppId); //selectByOpportunityId(oppId); // Tinashe
        return appPrdList;
    }
    /**
     * @description Method to get the new and existing application products based on opportunity
     * @Author : Manish :Absa
     * @param  oppId - opportunity Id
     * @return List<Application_Product__c>
    **/
    @AuraEnabled
    public static List<Application_Product__c> getNewExistingProducts(String oppId) {
        List<Application_Product__c> appPrdList = new List<Application_Product__c>();
        appPrdList = new ApplicationProductSelector().selectApplicationProductByCreditOppId(oppId); 
        return appPrdList;
    }
    
    /**
    * @description This validation needs to be run on POwerCurve class before adding Security Offered
    * @author Tinashe.shoko@absa.africa | 2021-06-11 
    * @param oppId 
    * @param sectionName 
    * @param validationValue 
    **/
    @AuraEnabled
    public static void setValidationFields(String oppId, String sectionName, Boolean validationValue){
        try {
            PowerCurveController.setValidationFields(oppId, 'Securities_Offered', True);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description 
    * @author  Tinashe.shoko@absa.africa  | 2021-06-11 
    * @param oppId 
    * @param isCurrCheque 
    * @return String 
    **/
    @AuraEnabled
    public static String getChequeAndOverdraft(String oppId, Boolean isCurrCheque) {
        return ChequeAndOverdraftController.getChequeAndOverdraft(oppId, true);
    }

   
    /**
    * @description deleteSecurityOfferedRecord description
     * Delete the given security offered record
     * ## secId (Id): secId
    * @author  Tinashe.shoko@absa.africa  | 2021-06-11 
    * @param secId 
    **/
    @AuraEnabled
    public static void deleteSecurityOfferedRecord(Id secId){
        try {
            List<Security_Offered__c> secOffList = new securitiesOfferedSelector().selectById(secId);
            if (!secOffList.isEmpty() && secOffList.size() > 0 && secOffList != null) {
                delete secOffList.get(0);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}