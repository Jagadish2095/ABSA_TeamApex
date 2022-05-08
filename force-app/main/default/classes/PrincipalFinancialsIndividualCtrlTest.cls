/**  * Test class for PrincipalFinancialsIndividualCtrl
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date September 2020
 *
 **/
@IsTest
public class PrincipalFinancialsIndividualCtrlTest {
    @testSetup
    public static void dataCreation() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.CIF__c = 'SNIFFEL001';
        account.Sic='35790';
        account.AccountNumber='0';
        account.Registration_Number__c = '1990/011515/23';
        account.Client_Type__c = 'Individual';
        insert account;
        
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp Onboarding 1';
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'New';
        opportunity.AccountId=account.Id;
        insert opportunity;
        
        Application__c application = new Application__c();
        application.Opportunity__c = opportunity.id;
        application.Account_Access__c = 'Cellphone';
        application.Surplus_Cash__c = 'Fixed Deposits';
        application.Borrowing_Requiment_General__c = 'Credit Card';
        application.Protection_Of_Services__c = 'Retirement';
        application.Title__c = 'dd';
        application.FirstNameSignature__c = 'Litha';
        application.SurnameSignature__c = 'Nosekeleza';
        application.Signing_Date__c = System.today();
        application.Stock_Number__c = '';
        insert application;
    }
    
    @IsTest
    static void shouldGetPrincipalAssetsLiabilitiesWithAccAssets(){
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        User user = [SELECT Name, Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetLicenseAssign WHERE PermissionSetLicense.MasterLabel = 'Financial Services Cloud Standard') AND IsActive=true AND Profile.Name = 'Standard User (Business Banker)' LIMIT 1];
        
        System.runAs(user) {
            List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities = new List<FinServ__AssetsAndLiabilities__c>();
            Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
            String validPicklistVals = validAssetLiabTypes();
            
            for (Schema.PicklistEntry value : values) {
                for(String picklistVal : validPicklistVals.split(';')){
                    if(value.getValue() == picklistVal){
                        FinServ__AssetsAndLiabilities__c accAssetsLiability = new FinServ__AssetsAndLiabilities__c();
                        accAssetsLiability.Name = picklistVal;
                        accAssetsLiability.FinServ__AssetsAndLiabilitiesType__c = picklistVal;
                        accAssetsLiability.FinServ__Amount__c = 0.00;
                        accAssetsLiability.Amount_Owners_Valuation__c = 0.00;
                        accAssetsLiability.FinServ__PrimaryOwner__c = opportunity.AccountId;
                        accAssetsLiability.RecordTypeId = getRecordTypeId(picklistVal,'FinServ__AssetsAndLiabilities__c');
                        accAssetsLiabilities.add(accAssetsLiability);
                    }
                }
            }
            
            insert accAssetsLiabilities;
        }
        
        Test.startTest();
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = PrincipalFinancialsIndividualCtrl.getPrincipalAssetsLiabilities(opportunity.Id, opportunity.AccountId);
        Test.stopTest();
        
        System.assertNotEquals(null, appAssetLiabilities);
        System.assertNotEquals(0, appAssetLiabilities.size());
        System.assertEquals(33, appAssetLiabilities.size());
    }
    
    @IsTest
    static void shouldGetPrincipalAssetsLiabilitiesWithOneAccAsset(){
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        User user = [SELECT Name, Id FROM User WHERE Id IN (SELECT AssigneeId FROM PermissionSetLicenseAssign WHERE PermissionSetLicense.MasterLabel = 'Financial Services Cloud Standard') AND IsActive=true LIMIT 1];
        
        System.runAs(user) {
            List<FinServ__AssetsAndLiabilities__c> accAssetsLiabilities = new List<FinServ__AssetsAndLiabilities__c>();
            Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
            map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
            list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
            String validPicklistVals = validAssetLiabTypes();
            
            FinServ__AssetsAndLiabilities__c accAssetsLiability = new FinServ__AssetsAndLiabilities__c();
            accAssetsLiability.Name = 'Fixed properties and all improvements to properties';
            accAssetsLiability.FinServ__AssetsAndLiabilitiesType__c = 'Fixed properties and all improvements to properties';
            accAssetsLiability.FinServ__Amount__c = 0.00;
            accAssetsLiability.Amount_Owners_Valuation__c = 0.00;
            accAssetsLiability.FinServ__PrimaryOwner__c = opportunity.AccountId;
            accAssetsLiability.RecordTypeId = getRecordTypeId('Fixed properties and all improvements to properties','FinServ__AssetsAndLiabilities__c');
            
            insert accAssetsLiability;
        }
        
        Test.startTest();
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = PrincipalFinancialsIndividualCtrl.getPrincipalAssetsLiabilities(opportunity.Id, opportunity.AccountId);
        Test.stopTest();
        
        System.assertNotEquals(null, appAssetLiabilities);
        System.assertNotEquals(0, appAssetLiabilities.size());
        System.assertEquals(33, appAssetLiabilities.size());
    }
    
    @IsTest
    static void shouldGetPrincipalAssetsLiabilitiesNoAccAssets(){
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        
        Test.startTest();
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = PrincipalFinancialsIndividualCtrl.getPrincipalAssetsLiabilities(opportunity.Id, opportunity.AccountId);
        Test.stopTest();
        
        System.assertNotEquals(null, appAssetLiabilities);
        System.assertNotEquals(0, appAssetLiabilities.size());
        System.assertEquals(33, appAssetLiabilities.size());
    }
    
    @IsTest
    static void shouldGetPrincipalAssetsLiabilitiesWithAppAssets(){
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id];
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
        Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
        String validPicklistValString = validAssetLiabTypes();
        
        for (Schema.PicklistEntry value : values) {
            for(String picklistVal : validPicklistValString.split(';')){
                if(value.getValue() == picklistVal){
                    Application_Assets_and_Liabilities__c appAssetLiability = new Application_Assets_and_Liabilities__c();
                    appAssetLiability.RecordTypeId = getRecordTypeId(picklistVal,'Application_Assets_and_Liabilities__c');
                    appAssetLiability.Name = picklistVal;
                    appAssetLiability.Type__c = picklistVal;
                    appAssetLiability.Application__c = application.Id;
                    appAssetLiability.Primary_Owner__c = opportunity.AccountId;
                    appAssetLiabilities.add(appAssetLiability);
                }
            }
        }
        
        insert appAssetLiabilities;
        
        Test.startTest();
        appAssetLiabilities = PrincipalFinancialsIndividualCtrl.getPrincipalAssetsLiabilities(opportunity.Id, opportunity.AccountId);
        Test.stopTest();
        
        System.assertNotEquals(null, appAssetLiabilities);
        System.assertNotEquals(0, appAssetLiabilities.size());
        System.assertEquals(28, appAssetLiabilities.size());
    }
    
    @IsTest
    static void shouldUpsertAssetsLiabilities(){
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity LIMIT 1];
        Application__c application = [SELECT Id FROM Application__c WHERE Opportunity__c =: opportunity.Id];
        List<Application_Assets_and_Liabilities__c> appAssetLiabilities = new List<Application_Assets_and_Liabilities__c>();
        Schema.sObjectType objType = FinServ__AssetsAndLiabilities__c.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get('FinServ__AssetsAndLiabilitiesType__c').getDescribe().getPickListValues();
        String validPicklistValString = validAssetLiabTypes();
        
        for (Schema.PicklistEntry value : values) {
            for(String picklistVal : validPicklistValString.split(';')){
                if(value.getValue() == picklistVal){
                    Application_Assets_and_Liabilities__c appAssetLiability = new Application_Assets_and_Liabilities__c();
                    appAssetLiability.RecordTypeId = getRecordTypeId(picklistVal,'Application_Assets_and_Liabilities__c');
                    appAssetLiability.Name = picklistVal;
                    appAssetLiability.Type__c = picklistVal;
                    appAssetLiability.Application__c = application.Id;
                    appAssetLiability.Primary_Owner__c = opportunity.AccountId;
                    appAssetLiabilities.add(appAssetLiability);
                }
            }
        }
        
        insert appAssetLiabilities;
//(List<Application_Assets_and_Liabilities__c> appAssetLiabilities, String deedsOfficeSearch, Date dateDeedsOfficeSearch, String deedsOutcomePositive, Date asAtDate){
        Test.startTest();
        String upsertSuccess = PrincipalFinancialsIndividualCtrl.upsertAssetsLiabilities(appAssetLiabilities, 'Yes',System.today(), 'No', System.today());
        Test.stopTest();
        
        System.assertNotEquals(null, upsertSuccess);
        System.assertEquals('Success', upsertSuccess);
    }

    /** 
	 * get list of Asset and Liability records
     *
     * @return String
    */
    private static String validAssetLiabTypes(){
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
    private static Id getRecordTypeId(String picklistVal, String objectName){
        String assetPicklistVals = 'Fixed properties and all improvements to properties;Shares in Private Company or Member\'s interest in Close Corporation;Loan Accounts to Businesses;';
        assetPicklistVals += 'Local Financial Instruments Listed (shares, unit trusts, etc.);Cash Investments (fixed and notice deposits);';
        assetPicklistVals += 'Total Foreign Assets;Net Capital of Business, Trade, Profession or Farming;Equipment, Machinery, Implements;Motor Vehicles, Caravans, Boats;';
        assetPicklistVals += 'Debtors;Stock;Livestock - elected values;Cash on Hand, in Bank and Other Similar Institutions;Personal Effects (Jewellery, paintings, furniture, etc.);Other Assets';
        String liabilityPicklistVals = 'Shareholder’s equity (if negative);Total Foreign Liabilities;Mortgage Bonds;Loan Accounts;Bank Overdraft;Credit Cards;Creditors;Other Liabilities';
        String fixedPropPicklistVals = 'Fixed Properties Bonded;Fixed Properties Unbonded;Fixed Properties Informal;Total Bond Registered;Notarial Bond Amount';
        
        for(String assetPicklistVal : assetPicklistVals.split(';')){
            if(picklistVal == assetPicklistVal){
                if(objectName == 'FinServ__AssetsAndLiabilities__c'){
                    return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
                } else {
                    return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('NonfinancialAsset').getRecordTypeId();
                }
            }
        }
        
        for(String liabilityPicklistVal : liabilityPicklistVals.split(';')){
            if(picklistVal == liabilityPicklistVal){
                if(objectName == 'FinServ__AssetsAndLiabilities__c'){
                    return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
                } else {
                    return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Liability').getRecordTypeId();
                }
            }
        }
        
        for(String fixedPropPicklistVal : fixedPropPicklistVals.split(';')){
            if(picklistVal == fixedPropPicklistVal){
                if(objectName == 'FinServ__AssetsAndLiabilities__c'){
                    return Schema.SObjectType.FinServ__AssetsAndLiabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
                } else {
                    return Schema.SObjectType.Application_Assets_and_Liabilities__c.getRecordTypeInfosByDeveloperName().get('Fixed_Property_Bond').getRecordTypeId();
                }
            }
        }
        
        return null;
    }
}