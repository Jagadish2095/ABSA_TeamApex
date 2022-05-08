/**
 * @description       :Apex class for multiProduct Selection based upon sales process type
 * @author            : Gulafsha
 * @last modified on  : 2021-06-11
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author    Modification
 * 1.0   2021-06-10   Gulafsha   Initial Version
**/
public class MultiProductSelectionController {
    /**
    * @description
    * @author Gulafsha | 2021-06-10
    * @param ObjectName
    * @param OpportunityId
    * @return List<String>
    **/
    @AuraEnabled
    public static List<String> getmultiselectpicklistvaluesforproductfamilies(String ObjectName,String OpportunityId){
        String sQuery;
        List<String> tmpString = new List<String>();

        if(ObjectName=='OnboardingSalesProcessType'){
            List<Opportunity> opp = new List<Opportunity>();
            opp = [select id,Sales_Process_Type__c,Sales_Process_Type__r.Product_Family__c from Opportunity where id=:OpportunityId];

            for (Opportunity obj: opp) {
                if(obj.Sales_Process_Type__c!=null){
                    if(obj.Sales_Process_Type__r.Product_Family__c!=null){
                        tmpString.addAll(obj.Sales_Process_Type__r.Product_Family__c.split(';'));
                    }
                }
            }

            return tmpString;
        } else{
            //For other streams add your logic here for passing search list
        }

        return new List<String>();
    }

    /**
    * @description : Apex method to return search results
    * @author Gulafsha | 2021-06-10
    * @param searchKeyWord
    * @param ObjectName
    * @param ExcludeitemsList
    * @return List<sObject>
    **/
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        String sQuery;
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }

        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records
        sQuery = 'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
        List<sObject> lstOfRecords = Database.query(String.escapeSingleQuotes(sQuery));

        for(sObject obj: lstOfRecords) {
            returnList.add(obj);
        }

        return returnList;
    }

    /**
    * @description : Apex method to save Selected Product Family
    * @author Gulafsha | 2021-06-10
    * @param oppId
    * @param productfamily
    * @param illustrativeDecision
    * @return Map<String, String>
    **/
    @AuraEnabled
    public static Map<String, String> saveOpportunityproductfamily (Id oppId, String productfamily,Boolean illustrativeDecision){
        try{
            Map<String, String> idsMap = new Map<String, String>();
            Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
            List<User> userList = new Usersselector().userwithSiteCode(UserInfo.getUserId());
            callOrchestrationService(oppId, productFamily);
            //Boolean isError = false;

            //  If Opportunity is Credit Onboarding then
            If (opportunity.RecordType.Name == Label.Credit_Onboarding ) {
                opportunity.Illustrative_Decision__c = illustrativeDecision;
                opportunity.Product_Selected_Business_Evolve__c = false;
                opportunity.Selected_Product_Family__c = productfamily;
                if(userList[0].SiteCode__c != null) {
                    opportunity.SiteCode__c = userList[0].SiteCode__c;
                    idsMap.put('userSite', userList[0].SiteCode__c);
                }

                update opportunity;
            }

            return idsMap;
        }
        catch (Exception e) {
            System.debug('ProductvsProductFamilyCtr.saveOpportunityproductfamily. Exception: ' + e);
            throw new AuraHandledException('Something went wrong: '+ e);
        }
    }


    /**
    * @description  : Apex method to get Opp Record
    * @author Himani | 2021-06-10
    * @param oppId
    * @return Opportunity
    **/
    @AuraEnabled
    public static Opportunity getOpportunity(Id oppId) {
        Opportunity opportunity = new OpportunitiesSelector().selectByOppId(oppId);
        return opportunity;
    }


    /**
    * @description  : Apex method to get accounts related to opportunity
    * @author Epetehe | 2021-06-10
    * @param oppId
    * @param productFamilies
    **/
    @future(callout=true)
    public static void callOrchestrationService(Id oppId, String productFamilies){
        Account account = new AccountsSelector().selectByOpportunityId(oppId);
        Application__c app = new ApplicationsSelector().selectByOpportunityId(oppId)[0];
        User user = new UsersSelector().selectById(UserInfo.getUserId());

        if(account != null && account.CIF__c != null){
            ChequeServicesOrchestration_Resp_IB_v1 resp = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(account.CIF__c, productFamilies,'0',user.SiteCode__c, '0');

            if(resp.statusCode == 200) {
                app.Accounts_Orchestration_JSON__c = JSON.serialize(resp);
                update app;
            }
        }
    }
}