/**
 * Controller class for PrincipalFinancialsIndividual aura component
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date September 2020
 */
public class PrincipalFinancialsIndividualCtrl {
	/** 
	 * get list of related parties for an account
     *
     * @param oppId opportunity Id
     * 
     * @return List<Map<String, Object>>
    */
    @AuraEnabled(Cacheable=false)
    public static List<Application_Assets_and_Liabilities__c> getPrincipalAssetsLiabilities(Id opportunityId, Id accountId){
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);
        ApplicationAssetsAndLiabilitiesSelector appAssetLiabilitySelector = new ApplicationAssetsAndLiabilitiesSelector();
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = appAssetLiabilitySelector.selectByAccountIdApplicationId(new Set<Id>{accountId}, new Set<Id>{application.Id});
        
        if(appAssetLiabilities != null && appAssetLiabilities.size() > 0){
            return appAssetLiabilities;
        } else{
            List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities = new FinServAssetsAndLiabilitiesSelector().selectAssetsAndLiabilitiesByAccountId(new Set<Id>{accountId});
        	appAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
            
            if(accAssetsLiabilities != null && accAssetsLiabilities.size() > 0){
                List<Application_Assets_and_Liabilities__c> existingAppAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
                
                for(FinServ__AssetsAndLiabilities__c accAssetsLiability : accAssetsLiabilities){
                    Application_Assets_and_Liabilities__c appAssetLiability = new Application_Assets_and_Liabilities__c();
                    appAssetLiability.RecordTypeId = getRecordTypeId(accAssetsLiability.FinServ__AssetsAndLiabilitiesType__c);
                    appAssetLiability.Type__c = accAssetsLiability.FinServ__AssetsAndLiabilitiesType__c;
                    appAssetLiability.Application__c = application.Id;
                    appAssetLiability.Primary_Owner__c = accAssetsLiability.FinServ__PrimaryOwner__c;
                    appAssetLiability.Amount_Owners_Valuation__c = accAssetsLiability.Amount_Owners_Valuation__c;
                    appAssetLiability.Amount__c = accAssetsLiability.FinServ__Amount__c;
                    existingAppAssetLiabilities.add(appAssetLiability);
                }
                
                if(existingAppAssetLiabilities.size() < 28){
                    String validPicklistValString = validAssetLiabTypes();
                    List<String> validPicklistVals = validPicklistValString.split(';');
                    
                    for(Integer i = 0; i < validPicklistVals.size(); i++){
                        for(Application_Assets_and_Liabilities__c appAssetLiability : existingAppAssetLiabilities){
                            if(appAssetLiability.Type__c == validPicklistVals.get(i)){
                                validPicklistVals.remove(i);
                            }
                        }
                    }
                    
                    appAssetLiabilities = createNewAppAssetsAndLiabilities(String.join(validPicklistVals, ';'), application, accountId);
                    
                    if(existingAppAssetLiabilities != null && existingAppAssetLiabilities.size() > 0){
                        appAssetLiabilities.addAll(existingAppAssetLiabilities);
                    }
                } else {
                    appAssetLiabilities.addAll(existingAppAssetLiabilities);
                }
            } else {
                appAssetLiabilities = createNewAppAssetsAndLiabilities(validAssetLiabTypes(), application, accountId);
            }
            
            try{
                insert appAssetLiabilities;
                
                appAssetLiabilities = addTotalRecords(appAssetLiabilitySelector.selectByAccountIdApplicationId(new Set<Id>{accountId}, new Set<Id>{application.Id}));
                upsert appAssetLiabilities;
            } catch(Exception exc){
                throw new AuraHandledException(String.valueOf(exc));
            }
            
            appAssetLiabilities = appAssetLiabilitySelector.selectByAccountIdApplicationId(new Set<Id>{accountId}, new Set<Id>{application.Id});
            return appAssetLiabilities;
        }
    }
    
    /** 
	 * get list of related parties for an account
     *
     * @param oppId opportunity Id
     * 
     * @return List<Map<String, Object>>
    */
    @AuraEnabled(Cacheable=false)
    public static String upsertAssetsLiabilities(List<Application_Assets_and_Liabilities__c> appAssetLiabilities, String deedsOfficeSearch, Date dateDeedsOfficeSearch, String deedsOutcomePositive, Date asAtDate){
        String upsertSuccess = 'Success';
        setValidations(appAssetLiabilities[0].Application__c);
        
        Account account = new Account(Id = appAssetLiabilities[0].Primary_Owner__c);
        account.Date_deeds_office_search__c = dateDeedsOfficeSearch;
        account.Deeds_office_search_available_Y_N__c = deedsOfficeSearch;
        account.Outcome_positive_Y_N__c = deedsOutcomePositive;
        account.As_at_date__c = asAtDate;
        
        try{
            update appAssetLiabilities;
            update account;
        } catch(Exception exc){
            upsertSuccess = String.valueOf(exc);
        }
        
        return upsertSuccess;
    }
    
    public static void setValidations(Id applicationId){
        Application__c app = new ApplicationsSelector().selectById(applicationId);
        Id opportunityId = app.Opportunity__c;
        List<Validations__c> fieldValidationList = [SELECT Id, Related_to_Object_Record_Id__c, Validation_Value__c, Related_to_Object_Api_Name__c, Name
                                                    FROM Validations__c
                                                    WHERE Related_to_Object_Record_Id__c = :opportunityId AND Name = 'Principal_Financials_Captured'];
        
        if(fieldValidationList == null || fieldValidationList.size() == 0){
            PowerCurveController.setValidationFields(opportunityId, 'Principal_Financials_Captured', true);
        }
    }
    
    private static List<Application_Assets_and_Liabilities__c> createNewAppAssetsAndLiabilities(String validPicklistVals, Application__c application, Id accountId){
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
        Schema.sObjectType objType = Application_Assets_and_Liabilities__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get('Type__c').getDescribe().getPickListValues();
        
        for (Schema.PicklistEntry value : values) {
            for(String picklistVal : validPicklistVals.split(';')){
                if(value.getValue() == picklistVal){
                	Application_Assets_and_Liabilities__c appAssetLiability = new Application_Assets_and_Liabilities__c();
                    appAssetLiability.RecordTypeId = getRecordTypeId(picklistVal);
                    appAssetLiability.Name = picklistVal;
                    appAssetLiability.Type__c = picklistVal;
                    appAssetLiability.Application__c = application.Id;
                    appAssetLiability.Primary_Owner__c = accountId;
                    appAssetLiabilities.add(appAssetLiability);
                }
            }
        }
        
        return appAssetLiabilities;
    }
    
    /** 
	 * method to generate Total records
     *
     * @param appAssetLiabilities - list of existing Application_Assets_and_Liabilities__c records
     * 
     * @return Application_Assets_and_Liabilities__c - list of Application_Assets_and_Liabilities__c
    */
    public static List<Application_Assets_and_Liabilities__c> addTotalRecords(List<Application_Assets_and_Liabilities__c> appAssetLiabilities){
        Decimal totalAssetsOwnrVal = 0;
        Decimal totalAssetsBrnchVal = 0;
        Decimal totalLiabsVal = 0;
        Decimal totalPropsVal = 0;
        Decimal netWrthOwnVal = 0;
        Decimal netWrthManVal = 0;
        
        if(appAssetLiabilities != null && appAssetLiabilities.size() > 0){
            
            for(Application_Assets_and_Liabilities__c appAssetLiab : appAssetLiabilities){
                if(appAssetLiab.RecordType.Name == 'Asset'){
                    totalAssetsOwnrVal += appAssetLiab.Amount_Owners_Valuation__c != null ? appAssetLiab.Amount_Owners_Valuation__c : 0;
                    totalAssetsBrnchVal += appAssetLiab.Amount__c != null ? appAssetLiab.Amount__c : 0;
                } else if(appAssetLiab.RecordType.Name == 'Liability'){
                    totalLiabsVal += appAssetLiab.Amount__c != null ? appAssetLiab.Amount__c : 0;
                } else if(appAssetLiab.RecordType.Name == 'Fixed Property Bond'){
                    totalPropsVal += appAssetLiab.Amount__c != null ? appAssetLiab.Amount__c : 0;
                } 
            }
            
            netWrthOwnVal = totalAssetsOwnrVal - totalLiabsVal;
            netWrthManVal = totalAssetsBrnchVal - totalLiabsVal;
            
            appAssetLiabilities.add(new Application_Assets_and_Liabilities__c(Name = 'Total Assets', Type__c = 'Total Assets', RecordTypeId = getRecordTypeId('Total Assets'), Amount__c = totalAssetsBrnchVal, Application__c = appAssetLiabilities[0].Application__c, Primary_Owner__c =  appAssetLiabilities[0].Primary_Owner__c));
            appAssetLiabilities.add(new Application_Assets_and_Liabilities__c(Name = 'Total Liabilities', Type__c = 'Total Liabilities', RecordTypeId = getRecordTypeId('Total Liabilities'), Amount__c = totalLiabsVal, Application__c = appAssetLiabilities[0].Application__c, Primary_Owner__c =  appAssetLiabilities[0].Primary_Owner__c));
            appAssetLiabilities.add(new Application_Assets_and_Liabilities__c(Name = 'Total Properties', Type__c = 'Total Properties', RecordTypeId = getRecordTypeId('Total Properties'), Amount__c = totalPropsVal, Application__c = appAssetLiabilities[0].Application__c, Primary_Owner__c =  appAssetLiabilities[0].Primary_Owner__c));
            appAssetLiabilities.add(new Application_Assets_and_Liabilities__c(Name = 'Net Worth Owner\'s Estimate', Type__c = 'Net Worth Owner\'s Estimate', RecordTypeId = getRecordTypeId('Net Worth Owner\'s Estimate'), Amount__c = netWrthOwnVal, Application__c = appAssetLiabilities[0].Application__c, Primary_Owner__c =  appAssetLiabilities[0].Primary_Owner__c));
            appAssetLiabilities.add(new Application_Assets_and_Liabilities__c(Name = 'Net Worth Manager\'s Estimate', Type__c = 'Net Worth Manager\'s Estimate', RecordTypeId = getRecordTypeId('Net Worth Manager\'s Estimate'), Amount__c = netWrthManVal, Application__c = appAssetLiabilities[0].Application__c, Primary_Owner__c =  appAssetLiabilities[0].Primary_Owner__c));
        }
        
        return appAssetLiabilities;
    }
    
    /** 
	 * get list of Asset and Liability records
     *
     * @return String
    */
    public static String validAssetLiabTypes(){
        String validPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;';
		validPicklistVals += 'Loan Accounts to Businesses;Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
		validPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
		validPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);';
		validPicklistVals += 'Other Assets;Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;';
		validPicklistVals += 'Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities;Fixed Properties Bonded;';
		validPicklistVals += 'Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
		
        return validPicklistVals;
    }
    
    /** 
	 * get record type Id of a picklist value
     *
     * @param picklistVal - picklist value for which to get record id
     * 
     * @return Id - record type Id
    */
    private static Id getRecordTypeId(String picklistVal){
        String assetPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;Loan Accounts to Businesses;';
        assetPicklistVals += 'Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
        assetPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
        assetPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);Other Assets';
        String liabilityPicklistVals = 'Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities';
        String fixedPropPicklistVals = 'Fixed Properties Bonded;Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
        String totalsPicklistVals = 'Total Assets;Total Liabilities;Net Worth Owner\'s Estimate;Net Worth Manager\'s Estimate;Total Properties';
        
        for(String assetPicklistVal : assetPicklistVals.split(';')){
            if(picklistVal == assetPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
            }
        }
        
        for(String liabilityPicklistVal : liabilityPicklistVals.split(';')){
            if(picklistVal == liabilityPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
            }
        }
        
        for(String fixedPropPicklistVal : fixedPropPicklistVals.split(';')){
            if(picklistVal == fixedPropPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
            }
        }
        
        for(String totalsPicklistVal : totalsPicklistVals.split(';')){
            if(picklistVal == totalsPicklistVal){
                return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Totals').getRecordTypeId();
            }
        }
        
        return null;
    }
}