/**
 * @description       : Controller class for PowerCurveFinancialsResponse aura component
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-07-19
 * @last modified by  : Ephetehe Mokgopanyane
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   2021-07-19   Ephetehe Mokgopanyane   Initial Version
**/

public class PowerCurveFinancialsResponseCtrl {

    /**
    * @description : Method to get all the application scoring entities
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    * @param oppId 
    * @return List<Map<String, String>> 
    **/
    @AuraEnabled(Cacheable=true)
    public static List<Map<String,String>> getApplicationScoringEntities(Id oppId){
        List<Map<String,String>> appScrEntMaps = new List<Map<String,String>>();
        List<Application_Scoring__c> appScorings = new ApplicationScoringSelector().selectLatestByOpportunityId(oppId);
        Map<String, String> cifWithAssetsInd = getFinancialsAndAssets(oppId);

        if(appScorings != null && appScorings.size() > 0){
            List<Application_Scoring_Entity__c> appScoringEnties = new ApplicationScoringEntitiesSelector().selectByApplicationScoringId(new Set<Id>{appScorings[0].Id});

            if(appScoringEnties != null && appScoringEnties.size() > 0){
                for(Application_Scoring_Entity__c appScoringEntity : appScoringEnties){
                    String finAvailable;

                    if(appScoringEntity.INTENTCLIENTCODE1__c != null){
                        finAvailable = cifWithAssetsInd.get(String.valueOf(appScoringEntity.INTENTCLIENTCODE1__c).replace(' ',''));
                    }

                    if(appScoringEntity.Entity_Name__c != null && appScoringEntity.Entity_Name__c != ''){
                        if(Integer.valueOf(appScoringEntity.Entity_Number__c) != 1){
                            String required = appScoringEntity.Financials_Required__c == 'N' ? 'No' : appScoringEntity.Financials_Required__c == 'Y' ? 'Yes' : '';

                            Map<String,String> appScrEntMap = new Map<String,String>();
                            appScrEntMap.put('clientName', appScoringEntity.Entity_Name__c);
                            appScrEntMap.put('required', appScoringEntity.Financials_Required__c == 'N' ? 'No' : appScoringEntity.Financials_Required__c == 'Y' ? 'Yes' : '');
                            appScrEntMap.put('typeRequired', required == 'No' || required == null ? '' : appScoringEntity.Financials_Type_Required__c);
                            appScrEntMap.put('available', required == 'No' || required == null ? '' : finAvailable != null && finAvailable != '' ? finAvailable : 'No');
                            appScrEntMap.put('clientCode', appScoringEntity.INTENTCLIENTCODE1__c);
                            appScrEntMap.put('entNum', String.valueOf(appScoringEntity.Entity_Number__c));
                            appScrEntMap.put('lastModified', String.valueOf(appScoringEntity.LastModifiedDate));

                            appScrEntMaps.add(appScrEntMap);
                        }
                    }
                }
            }
        }

    	return appScrEntMaps;
    }

    /**
    * @description : Method to get Financials and Assets
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    * @param oppId 
    * @return Map<String, String> 
    **/
    public static Map<String, String> getFinancialsAndAssets(Id oppId){
        List<Application_Principal__c> appPrincipals = new ApplicationPrincipalsSelector().selectApplicationPrincipalByOpportunityId(new Set<Id>{oppId});
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        Map<String, String> cifWithAssetsInd = new Map<String, String>();
        Set<String> cifCodes = new Set<String>();
        Set<Id> accIds = new Set<Id>();

        if(appPrincipals != null && appPrincipals.size() > 0){
            for(Application_Principal__c appPrincipal : appPrincipals){
                cifCodes.add(appPrincipal.CIF__c);
            }

            List<Account> accounts = new AccountsSelector().selectByCIF(cifCodes,6);

            if(accounts != null && accounts.size() > 0){
                for(Account account : accounts){
                    accIds.add(account.Id);
                }

                List<Application_Assets_and_Liabilities__c> appAsstsLiabs = new ApplicationAssetsAndLiabilitiesSelector().selectByAccountIdApplicationId(accIds, new Set<Id>{app.Id});

                if(appAsstsLiabs != null && appAsstsLiabs.size() > 0){
                    for(Application_Assets_and_Liabilities__c appAsstLiab : appAsstsLiabs){
                        for(Application_Principal__c appPrincipal : appPrincipals){
                            if(appAsstLiab.Primary_Owner__r.CIF__c == appPrincipal.CIF__c){
                                cifWithAssetsInd.put(String.valueOf(appPrincipal.CIF__c).replace(' ',''), 'Yes');
                            }
                        }
                    }
                }

                List<Financial_Information__c> finInfoRecs = new FinancialInformationSelector().selectByAccountIds(accIds);

                if(finInfoRecs != null && finInfoRecs.size() > 0){
                    for(Financial_Information__c finInfo : finInfoRecs){
                        for(Application_Principal__c appPrincipal : appPrincipals){
                            if(finInfo.Account__r.CIF__c == appPrincipal.CIF__c){
                                cifWithAssetsInd.put(String.valueOf(appPrincipal.CIF__c).replace(' ',''), 'Yes');
                            }
                        }
                    }
                }
            }
        }

        return cifWithAssetsInd;
    }

    /**
    * @description : Method to get account details
    * @author Ephetehe Mokgopanyane | 2021-07-19 
    * @param oppId 
    * @return Account 
    **/
    @AuraEnabled
    public static Account getAccDetails(id oppId){
        return new AccountsSelector().selectAllById([Select Id, AccountId from Opportunity WHERE Id =: oppId].AccountId);
    }
}