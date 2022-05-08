/**
 * @description Class controller for the following lightning components.
 * @Security Validator
 * @Payout Validator
 * @Payout Release
 *
 * @author Jaco de Lange
 * @since 2020-12-24
 **/
global with sharing class ApplicationValidatorLightning {
    /**
     * @description This method is used to insert records into the Decision_History__c object
     * No return type
     * @param caseId
     * @param detail
     * @param comments
     * @param grant
     * @param requestInfo
     * @param typeOfValidator
     * @param infoSource

     **/
    @AuraEnabled
    public static void insertDecisionHistoryRec(String caseId, String detail, String comments, Boolean grant, Boolean requestInfo, String typeOfValidator,String infoSource) {
        List<Decision_History__c> dh = new List<Decision_History__c>();
        Decision_History__c newDH = new Decision_History__c();

        //Approved
        if (grant) {
            newDH.Decision__c = 'Approved';
            newDH.Details__c = 'Approved as is';
            if (comments != null) {
                newDH.Comments__c = comments;
            }
            if (caseId != null) {
                newDH.Case__c = caseId;
            }
            newDH.Sanctioner__c = UserInfo.getUserId();
            newDH.Process_Name__c = typeOfValidator;
            dh.add(newDH);
        }
        //Request more Info
        if (requestInfo) {
            newDH.Decision__c = 'Rejected';
            if (detail != null) {
                newDH.Details__c = detail;
            }
            if (comments != null) {
                newDH.Comments__c = comments;
            }
            if (caseId != null) {
                newDH.Case__c = caseId;
            }
            newDH.Sanctioner__c = UserInfo.getUserId();
            newDH.Process_Name__c = typeOfValidator;
            dh.add(newDH);
        }

        if (!dh.isEmpty() && dh.size() > 0) {
            try {
                insert dh;
                system.debug('Decision history record ## ' + dh);
            } catch (DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }

        try {
            if (caseId != null) {
                Set<Id> caseIdSet = new Set<Id>();
                caseIdSet.add(caseId);

                List<Case> currentCase = new CasesSelector().selectcasebyAccountId(caseIdSet);
                List<Group> groupQ = new GroupsSelector().selectByNameAndType('Payout Release', 'Queue');

               
                //currentCase[0].OwnerId = groupQ[0].Id;
                if (typeOfValidator == 'Payout Release' && grant) {
                    currentCase[0].OwnerId = groupQ[0].Id;
                    currentCase[0].Status = 'Case Closed';
                    update currentCase;
                } else if (typeOfValidator == 'Payout Validator' && grant) {
                    currentCase[0].OwnerId = groupQ[0].Id;
                    currentCase[0].Status = 'Payout Release';
                    update currentCase;
                } else{
                    //changeOwner(String caseId, String processName, String caseStatus, String infoSource)
                   CAF_Sanctioning_Controller.changeOwner(caseId, typeOfValidator, '', infoSource);}

                
            }
        } catch (exception e) {
            system.debug('Unable to assign case owner to payout release q :: ' + e.getMessage());
        }
    }

    /**
     * @description This method is used to retrieve the list of Decision History records for an Application Product CAF
     * @return list of decision history records for specific case record
     * @param caseId
     **/
    @AuraEnabled
    public static List<Decision_History__c> getHistory(String caseId) {
        List<Case> caseList = new List<Case>();

        if (caseId != null) {
            Set<Id> caseIdSet = new Set<Id>();
            caseIdSet.add(caseId);
            caseList = new CasesSelector().selectByIdWithDecisionHistoryTracking(caseIdSet);
        }

        List<Decision_History__c> decisionHistoryRecords = new List<Decision_History__c>();
        if (caseList.size() > 0 && caseList != null) {
            for (Case eachAppProduct : caseList) {
                decisionHistoryRecords.addAll(eachAppProduct.Decision_Histories__r);
            }
        }
        if (decisionHistoryRecords.size() > 0) {
            return decisionHistoryRecords;
        } else {
            return null;
        }
    }

    /**
     * @description This method is used to retrieve the opportunity and account records
     * @return: opportunity and account
     * @param oppId
     * @return null
     **/
    @AuraEnabled
    public static List<Opportunity> getOppsList(String oppId) {
        List<Opportunity> currentOppList = new List<Opportunity>();

        if (oppId != null) {
            currentOppList = new OpportunitiesSelector().selectByOpportunityId(oppId);
        }
        if (currentOppList.size() > 0 && currentOppList != null) {
            return currentOppList;
        } else {
            return null;
        }
    }

    /**
     * @description This method is used to do the National Credit Act (NCA) check
     * @return type - True or False
     * @param oppId
     * @param agreementSize
     * @param securedByMortgage
     * @param numberOfTrustees
     * @param annualTurnover
     * @param netAssetValue
     **/
    @AuraEnabled
    public static Boolean checkNCAStatus(String oppId, Double agreementSize, String securedByMortgage, Integer numberOfTrustees, Double annualTurnover, Double netAssetValue) {
        Boolean isApproved = false;

        if (String.isBlank(oppId)) {
            throw new AuraHandledException('oppId is null.');
        }

        //get client type from opp record
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppId);

        if (opp == null) {
            throw new AuraHandledException('Opportunity with Id ' + oppId + ' not found.');
        }

        if (String.isBlank(opp.AccountId)) {
            throw new AuraHandledException('AccountId on Opportunity with Id ' + oppId + ' is null.');
        }

        Account acc = new AccountsSelector().selectAllById(opp.AccountId);

        if (acc == null) {
            throw new AuraHandledException('Account with Id ' + opp.AccountId + ' not found.');
        }

        if (
            opp.Client_type__c != 'Central Government' &&
            opp.Client_type__c != 'Finacial Government Enterprises' &&
            opp.Client_type__c != 'Local Government' &&
            opp.Client_type__c != 'Non-Finacial Government Enterprises' &&
            opp.Client_type__c != 'Provincial Government' &&
            opp.Client_type__c != 'Schools' &&
            opp.Client_type__c != 'State Owned Company' &&
            opp.Client_type__c != 'State Owned Company (Soc Ltd)' &&
            (opp.Client_type__c == 'Individual' ||
            opp.Client_type__c == 'Sole Trader' ||
            ((opp.Client_type__c == 'Trusts' || opp.Client_type__c == 'Foreign Trust') && numberOfTrustees != null && numberOfTrustees <= 2) ||
            (annualTurnover != null && annualTurnover < 1000000 && netAssetValue != null && netAssetValue < 1000000 && ((agreementSize != null && agreementSize < 250000) || securedByMortgage == 'No')))
        ) {
            isApproved = true;
            acc.Client_NCA_Status__c = 'YES';
        } else {
            isApproved = false;
            acc.Client_NCA_Status__c = 'NO';
        }

        opp.stageName = 'Complete Product Details';

        if (annualTurnover != null) {
            opp.Annual_turnover__c = annualTurnover;
        }

        update acc;
        update opp;
        return isApproved;
    }

    /**
     * @description This method is used get the oppId on the case
     * @return type : oppId
     * @param caseId
     **/
    @AuraEnabled
    public static String getOppId(String caseId) {
        Set<Id> cIdset = new Set<Id>();
        String oppId;
        if (caseId != null) {
            cIdset.add(caseId);
        }
        List<Case> c = new CasesSelector().selectcasebyAccountId(cIdset);

        if (c.size() > 0 && c != null) {
            oppId = c[0].Opportunity__c;
            return oppId;
        } else {
            return null;
        }
    }

    /**
     * @description This method is used get the current case
     * @return type : case
     * @param caseId
     **/
    @AuraEnabled
    public static OpportunityLineItem getApplicationId(String caseId){ 
        Application_Product_CAF__c application = new ApplicationProductCAFSelector().selectByCaseId(caseId);
        OpportunityLineItem oppLine = new OpportunityLineItemsSelector().byApplicationProductCAF(application.Id);
        system.debug('oppLine '+oppLine);
        return oppLine;
    }
    
    /**
     * @description This method is used get the current case
     * @return type : case
     * @param caseId
     **/
    @AuraEnabled
    public static Case getCase(String caseId) {
        if (caseId != null) {
            Case c = new CasesSelector().selectPayoutValidation(caseId);
            return c;
        } else {
            return null;
        }
    }

    /**
     * @description This method is used get the Picklist values on the case of selected field
     * @return type : List of picklist values
     * @param objectType 
     * @param selectedField
     **/
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(String objectType, String selectedField) {
        List<String> pickListValuesList = new List<String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectType);
        Schema.DescribeSObjectResult res = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = res.fields.getMap().get(selectedField).getDescribe();
        List<Schema.PicklistEntry> pickListEnterValuesList = fieldResult.getPicklistValues();
        pickListValuesList.add('choose one...');
        for (Schema.PicklistEntry pickListVal : pickListEnterValuesList) {
            pickListValuesList.add(pickListVal.getLabel());
        }
        return pickListValuesList;
    }

    /**
     * @description This method is used get the Picklist values on the case of selected field
     * @return type : List of picklist values
     * @param accountId
     **/
    @AuraEnabled
    public static Integer queryNumberOfTrustees(String accountId) {
        List<AccountContactRelation> accountContactRelations = new AccountContactRelationSelector().selectbyActiveDirectors(accountId, 'Trustees');
        if (accountContactRelations != null) {
            return accountContactRelations.size();
        } else {
            return 0;
        }
    }
    
    /**
     * @description This method is used get the Picklist values on the case of selected field
     * @return type : List of picklist values
     * @param caseId
     **/
    @AuraEnabled 
    public static Map<Object,Object> fetchSendToFromCase(String caseId){
        Map<Object,Object> dataMap = new Map<Object,Object>();
        Case cs = [Select Id,OwnerId,Information_Source__c,Decision_Data__c From Case Where Id =: caseId LIMIT 1];
        
        if(cs.Decision_Data__c != '' && cs.Decision_Data__c != null){
            String[] dataArray = cs.Decision_Data__c.split('#####');
            System.debug('dataArray '+dataArray);
            if(dataArray[1] == UserInfo.getUserId()){
                dataMap.put('ISSAMEOWNER', 'TRUE');
                dataMap.put('COMPNAME', dataArray[0]);
            }else{
                dataMap.put('ISSAMEOWNER', 'FALSE');
            }
        }
        return dataMap;
    } 
    /**
     * @description This method is used get the Picklist values on the case of selected field
     * @param caseId
     * @param componentName
     * @param ownerId
     **/
    @AuraEnabled 
    public static void updateDecisionDataToCase(String caseId,String componentName,String ownerId){
        Case cs = [Select Id,OwnerId,Decision_Data__c From Case Where Id =: caseId LIMIT 1];
        Boolean isCaseOwnerQueue = true;
        String ownId = ownerId;//String.valueOf(cs.OwnerId);
        System.debug('ownId '+ownId);
        if(cs != null){
            System.debug('IS USER '+ownId.StartsWith('005'));
            if(ownId.StartsWith('005')){
                isCaseOwnerQueue = false;
            } 
            System.debug('isCaseOwnerQueue '+isCaseOwnerQueue);
            if(!isCaseOwnerQueue){
                cs.Decision_Data__c = componentName+'#####'+cs.OwnerId;
            }else{
                cs.Decision_Data__c = '';
            }
            System.debug('Decision_Data__c' +cs.Decision_Data__c);
            update cs;
        }
    }
}