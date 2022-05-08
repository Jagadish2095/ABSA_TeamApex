/** 
 * @description This is the Controller Class for the Opportunity Wizard Component for the creation of Opportunity records
 * @author  Nelson Chisoko (Dariel)
 * @since   2019-01-10
*/

public with sharing class OpportunityWizardController {

    // Get Opportunity Record Type Map
    public static Map <String, Schema.RecordTypeInfo> opportunityRecordTypesMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
    // Get Asset Record Type Map
    static Map <String, Schema.RecordTypeInfo> assetRecordTypesMap = Asset.sObjectType.getDescribe().getRecordTypeInfosByName();

    /**
     * @description This is a method to pre populate the available record types for Opportunity
     * @return  Map<String, Id>
     */
    @AuraEnabled
    public static Map<String, Id> getOpportunityRecordTypesMap() {

        Map<String, Id> temp = new Map<String, Id>();

        for (Schema.RecordTypeInfo recordTypeInfo : opportunityRecordTypesMap.values()) {

            if (recordTypeInfo.isAvailable() && recordTypeInfo.getName() != 'Master') {

                temp.put(recordTypeInfo.getName(), recordTypeInfo.getRecordTypeId());

            }
        }

        return temp;

    }

    /**
     * @description This is a method to get an opportunity record type fields from custom metadata in order to populate the opportunity
     * creation form
     * @param   recordTypeName  The record type name
     * @return  List<String>    A list of field names
     */
    @AuraEnabled
    public static List<String> getSelectedOpportunityRecordTypeFields(String recordTypeName) {
        //System.debug('recordTypeName: ' + recordTypeName);

        List<Opportunity_Record_Type_Field_Set__mdt> opportunityRecordTypeFieldSets = [
                SELECT Id,Record_Type_Fields__c
                FROM Opportunity_Record_Type_Field_Set__mdt
                WHERE Label =: recordTypeName
        ];

        //System.debug('opportunityRecordTypeFieldSets: ' + opportunityRecordTypeFieldSets);

        List<String> selectedOpportunityRecordTypeFields = new List<String>();

        if (!opportunityRecordTypeFieldSets.isEmpty()) {

            Opportunity_Record_Type_Field_Set__mdt opportunityRecordTypeFieldSet =  opportunityRecordTypeFieldSets.get(0);
            List<String> temp = opportunityRecordTypeFieldSet.Record_Type_Fields__c.split(',');

            for (String s : temp) {

                s = s.trim();
                selectedOpportunityRecordTypeFields.add(s);

            }

        }

        return selectedOpportunityRecordTypeFields;

    }

    /**
     * @description This is a method to get the selected Opportunity record type Id
     * @param opportunityRecordTypeName
     * @return  String  The record type Id
     */
    @AuraEnabled
    public static String getSelectedOpportunityRecordTypeId(String opportunityRecordTypeName) {

        return opportunityRecordTypesMap.get(opportunityRecordTypeName).getRecordTypeId();

    }

    /**
     * @description This is a method to delete the already created opportunity during the wizard process in the event of a cancel action
     * @param   oppId   The opportunity Id
     */
    @AuraEnabled
    public static void deleteOpportunity(Id oppId) {

        List<Opportunity> opportunitiesList = new OpportunitiesSelector().selectByOpportunityId(oppId, 1);

        if (!opportunitiesList.isEmpty()) {

            Opportunity opp = opportunitiesList.get(0);

            try {
                delete new ApplicationsSelector().selectByOpportunityId(opp.Id);
                delete new AssetsSelector().selectAssetsByOpportunityId(opp.Id, assetRecordTypesMap.get('Will').getName());
                delete opp;

            } catch(DmlException e) {
                String msg = e.getMessage();
                //System.debug('An unexpected error has occurred: ' + e.getMessage());

            }
        }
    }

    /**
     * @description This is a method to update the already created opportunity with the selected account
     *
     * @param   oppId           The opportunity Id
     * @param   accountData     The account data from the client finder results
     * @param   productData
     * @param   adviserId
     * @param   siteId
     * @param  willDetailString
     * @param  willBankingDetailsString
     * @param  willAssetsLiabilitiesString
     * @param  willType
     */
    @AuraEnabled
    public static void updateOpportunity(Id oppId, Account accountData, ClientFinderProduct productData, Id adviserId, Id siteId, String willDetailString, String willBankingDetailsString, String willAssetsLiabilitiesString, String willType) {

        Account client;
        GetWillDetails_Resp_IB_v1 willDetails;
        WillBankingDetails_IB_v1 willBankingDetails;
        GetAssetsLiabilities_Resp_IB_v1 willAssetsLiabilities;
        Long willNumber;
        PaymentPlan paymentPlan;
        //System.debug('accountData' + accountData);
        
        if (willDetailString != null) {    
            willDetails = (GetWillDetails_Resp_IB_v1) JSON.deserialize(willDetailString, GetWillDetails_Resp_IB_v1.class);       
        }
        
        //System.debug('willBankingDetailsString: ' + willBankingDetailsString);
        if (willBankingDetailsString != null) {
            
            willBankingDetails = (WillBankingDetails_IB_v1) JSON.deserialize(willBankingDetailsString, WillBankingDetails_IB_v1.class);    
            
            if (willBankingDetails.BankingDetailsResponse.statusCode == 200) {
                
                if (!willBankingDetails.BankingDetailsResponse.RCMessage.contains('WILL NOT IN SCF DATABASE')){  //lulu changes
                    // || !willBankingDetails.BankingDetailsResponse.RCMessage.contains('AWM130S  WILL NOT IN SCF DATABASE')) {
                    
                    paymentPlan = new PaymentPlan();
                    paymentPlan.accNumber = willBankingDetails.BankingDetailsResponse.AccountNumber;
                    paymentPlan.accType = willBankingDetails.BankingDetailsResponse.AccountType;
                    paymentPlan.bankName = willBankingDetails.BankingDetailsResponse.BankName;
                    paymentPlan.branchCode = willBankingDetails.BankingDetailsResponse.BranchCode;
                    paymentPlan.branchName = willBankingDetails.BankingDetailsResponse.BranchName;
                    paymentPlan.name = paymentPlan.accType + ' - ' + paymentPlan.accNumber;
                    paymentPlan.frequency = 'Yearly';
                    paymentPlan.amount = 115;
                    paymentPlan.method = 'Debit Instruction';
                    paymentPlan.status = 'New';
                    paymentPlan.type = 'Will Safe Custody Fee';
                    
                } else {
                    paymentPlan = null;   
                    
                }
            }
            //System.debug('paymentPlan: ' + paymentPlan);
        }       
        if (willAssetsLiabilitiesString != null) {
            
             willAssetsLiabilities = (GetAssetsLiabilities_Resp_IB_v1) JSON.deserialize(willAssetsLiabilitiesString, GetAssetsLiabilities_Resp_IB_v1.class);             
        }
        
       /* System.debug('accountData: ' + accountData);
        System.debug('productData: ' + productData);
        System.debug('willDetails: ' + willDetails);
        System.debug('willBankingDetails: ' + willBankingDetails);
        System.debug('willAssetsLiabilities: ' + willAssetsLiabilities); */
        
        if (accountData != null) {
            if (accountData.Id != null) {           
                client = new AccountsSelector().selectById(accountData.Id);
                
            } else {
                
                //Search if client already exists in SF
                Account searchResult;  
                try {
                    
                    searchResult = new AccountsSelector().selectByCIF(accountData.CIF__c);
                    client = searchResult;  
                } catch (QueryException e) { 
                    String msg = e.getMessage();
                    //System.debug('An unexpected error has occurred: ' + e.getMessage());   
                }
            }
        }
        
        if (productData != null) {
            willNumber = Long.valueOf(productData.accountNumber); 
        }
        
        //Update opportunity with accountId and create asset and application records
        Opportunity opp;
        try {
            opp = new OpportunitiesSelector().selectByOpportunityId(oppId, 1).get(0);
            if (opp != null) {
                
                if (client != null)
                    opp.AccountId = client.Id;
                if (adviserId != null)
                    opp.Adviser_Employee__c = adviserId;
                if (siteId != null)
                    opp.Site__c = siteId;
                
                update opp;
                //System.debug('opp: ' + opp);
                
                if (productData != null) {
                    //Check if application record exists, else create and associate with the opportunity
                    List<Application__c> applications = new ApplicationsSelector().selectByOpportunityId(opp.Id);
                    //System.debug('applications found: ' + applications);
                    Application__c application;
                    
                    if (applications.isEmpty()) { 
                        application = new Application__c(
                            Opportunity__c = opp.Id
                        );
                        //System.debug('paymentPlan != null: ' + paymentPlan != null);
                        
                        if (paymentPlan != null) {
                            application.Safe_Custody_Is_Required__c = 'Yes';
                            application.Safe_Custody_Status__c = 'Valid';
                            application.Safe_Custody_Payment_Same_As_Drafting__c = 'No';    
                        }else{
                            // 
                            application.Safe_Custody_Is_Required__c = 'No'; //lulu changes
                            application.Safe_Custody_Status__c = 'Valid'; //lulu changes
                        }
                        if (willType != null) {
                            application.Will_Type__c = willType;
                        }
                        insert application;
                        //System.debug('application created: ' + application);
                        
                    } else {
                        application = applications.get(0);
                        //System.debug('application found: ' + application);
                    }
                    if (paymentPlan != null) {
                        //Create payment plan record
                        Payment_Plan__c safeCustodyPaymentPlan = new Payment_Plan__c(
                            Application__c = application.Id,
                            Type__c = paymentPlan.type,
                            Account_Number__c = paymentPlan.accNumber,
                            Account_Type__c = paymentPlan.accType,
                            Bank_Name__c = paymentPlan.bankName,
                            Branch_Name__c = paymentPlan.branchName,
                            Name = paymentPlan.accType + ' - ' + paymentPlan.accNumber,
                            Frequency__c = paymentPlan.frequency,
                            Amount__c = paymentPlan.amount,
                            Method__c = paymentPlan.method,
                            Status__c = paymentPlan.status
                        );
                        if (paymentPlan.branchCode != null) {
                            safeCustodyPaymentPlan.Branch_Code__c = Integer.valueOf(paymentPlan.branchCode);  
                        }
                        insert safeCustodyPaymentPlan;
                        //System.debug('safeCustodyPaymentPlan: ' + safeCustodyPaymentPlan);
                    }

                    //Create FNA record
                    Financial_Needs_Analysis__c financialNeedsAnalysis = new Financial_Needs_Analysis__c(
                        Account__c = client.Id,
                        Other_Assets__c = willAssetsLiabilities.AssetAmt,
                        Other_liabilities__c = willAssetsLiabilities.LiabilAmt,
                        Full_Liquidity__c = true
                    );

                    insert financialNeedsAnalysis;
                    //System.debug('financialNeedsAnalysis: ' + financialNeedsAnalysis);
                    
                    //Update opportunity
                    opp.Financial_Needs_Analysis__c = financialNeedsAnalysis.Id;
                    
                    update opp;
                    //System.debug('FNA opp: ' + opp);
                    
                    //Check if asset exists, remap to new Opportunity
                    List<Asset> willSearch = new AssetsSelector().selectAssetNumber(String.valueOf(willNumber));
                    Asset will;
                    if (!willSearch.isEmpty()) {   
                        will = willSearch.get(0);
                        will.Opportunity__c = opp.Id;
                        will.AccountId = client.Id;
                        update will;
                        
                    } else {
                        
                        will = new Asset(
                            RecordTypeId = assetRecordTypesMap.get('Will').getRecordTypeId(),
                            Name = String.valueOf(willNumber),
                            SerialNumber = String.valueOf(willNumber),
                            AccountId = client.Id,
                            Opportunity__c = opp.Id
                        );
                        
                        if (willDetails != null) { 
                            will.Adviser_Code__c = String.valueOf(willDetails.BrokerCode);  
                        }
                        insert will;
                        //System.debug('will: ' + will);   
                    } 
                }
                
            }
        } catch (DmlException e) {
          //System.debug('An unexpected error has occurred: ' + e.getMessage());  
          String msg = e.getMessage();
        }
        
        
    }

      /**
     * @description This is a method to get Will Details
     * @param   productData           
     * @return   String : accountData    
    **/
    @AuraEnabled
    public static String getWillDetails(ClientFinderProduct productData) {

        GetWillDetails_Resp_IB_v1 willDetailsResponse;

        if (productData != null) {

            Long willNumber = Long.valueOf(productData.accountNumber);
            //System.debug('willNumber: ' + willNumber);

            willDetailsResponse = GetWillDetails_IH_v1.getWillDetails(String.valueOf(willNumber));
            //System.debug('willDetailsResponse: ' + JSON.serialize(willDetailsResponse));

        }

        return JSON.serialize(willDetailsResponse);

    }
    
     /**
     * @description This is a method to get Will Banking Details
     * @param   productData           
     * @return   String : accountData    
    **/
    @AuraEnabled
    public static String getWillBankingDetails(ClientFinderProduct productData) {

        WillBankingDetails_IB_v1 willBankingDetailsResponse;

        if (productData != null) {

            Long willNumber = Long.valueOf(productData.accountNumber);
            //System.debug('willNumber: ' + willNumber);

            willBankingDetailsResponse = GetWillBankingDetails_IH_v1.getWillBankingDetails(String.valueOf(willNumber));
            //System.debug('willBankingDetailsResponse: ' + willBankingDetailsResponse);

        }

        return JSON.serialize(willBankingDetailsResponse);

    }

    /**
     * @description This is a method to get Will Assets Liabilities
     * @param   productData           
     * @return   String : accountData    
    **/
    @AuraEnabled
    public static String getWillAssetsLiabilities(ClientFinderProduct productData) {

        GetAssetsLiabilities_Resp_IB_v1 willAssetsLiabilitiesResponse;

        if (productData != null) {

            Long willNumber = Long.valueOf(productData.accountNumber);
            //System.debug('willNumber: ' + willNumber);

            willAssetsLiabilitiesResponse = GetAssetsLiabilities_IH_v1.getAssetsLiabilities(String.valueOf(willNumber));
            //System.debug('willAssetsLiabilitiesResponse: ' + willAssetsLiabilitiesResponse);

        }

        return JSON.serialize(willAssetsLiabilitiesResponse);
    }

    /**
     * @description  This is a method to check adviser is ACTIVE OR INACTIVE 
     * @param AdviserId
     * @return boolean true or false
     */
    @AuraEnabled
    public static Boolean CheckInactiveBroker(Id AdviserId) {
        
      Employee__c adviser = new EmployeesSelector().selectById(AdviserId);
      
        //System.debug('adviser'+adviser);  
        
        if(adviser.Active__c){
            return true;
        }
        else{
            return false;
        }
    }
    
    
    /**
     * @description  This is a method to create Client
     * @param accountData
     * @return string
*/
    @AuraEnabled
    public static String createClient(Account accountData) {

        //Create the client record
        Map<String, Object> accountDataMap = accountData.getPopulatedFieldsAsMap();
        Map<String, Object> temp = new Map<String, Object>();
        temp.putAll(accountDataMap);
        temp.remove('Name');
        Account client = (Account)JSON.deserialize(JSON.serialize(temp), Account.class);
        //System.debug('client ' + client);
        
        AccountCreate_CIF_MDM.GIPResponse createdAccount;
        /*System.debug('client.Name: ' + client.Name);
        System.debug('client.ID_Number__pc: ' + client.ID_Number__pc);
        System.debug('client.CIF__c: ' + client.CIF__c); */
        
        if(client.CIF__c != null){
            //System.debug('CIF Key');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(client.CIF__c, '0', '009970');
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'SA Identity Document'){
            //System.debug('SA Identity Document');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('SAID', client.ID_Number__pc);
            
        }else if(client.ID_Type__pc != null && client.ID_Type__pc == 'Passport'){
            //System.debug('Passport');
            createdAccount = AccountCreate_CIF_MDM.createAccountFromMDM('Passport', client.ID_Number__pc);
            
        }else{
            
            return 'No ID number, Passport number or CIF number was found';
        }
        return createdAccount.response;

    }

    /**=================================================================================================================================
* @description Created By Eduardo Salia 14/03/2021
* @param caseId this is the Case record Id from the Opportunity Wizard Component
* @return Flag (Boolean) on Opportunity Wizard Component
* 
===================================================================================================================================**/
    @AuraEnabled
    public static boolean isVirtualAdvisorCase(Id caseId)
    {
        //Get Case By Id
        List<Case> cases = new CasesSelector().selectCasesById(caseId);
        
        //Proceed if Cases found
        if(!Sys_Utilities_General.isListBlank(cases)
           && (cases[0].RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_MATURITY
              || cases[0].RecordType.DeveloperName == StringConstants.CASE_RECORD_TYPE_CLIENT_REVIEW))
            return true;
        return false;
           
    }
/**
* @description Created By Divya getAccountRecordId
* @param  caseId
* @return String
**/
    @AuraEnabled
    public static String getAccountRecordId(Id caseId)
    {
        List<Case> cases = new CasesSelector().selectcasebyAccountId(new Set<id>{caseId});
        if(!Sys_Utilities_General.isListBlank(cases))
        {
            return cases[0].AccountId;
        }
        return null;
    }
/**
* @description Created By Divya updateOppRecord
* @param  oppId
* @param newOwner
**/
     @AuraEnabled
    public static void updateOppRecord(String oppId,String newOwner)
    {
    	List<Opportunity> Opportunities = new OpportunitiesSelector().selectById(new Set<id>{oppId});
        if(!Sys_Utilities_General.isListBlank(Opportunities))
        {
            Opportunities[0].ownerId=newOwner;
            Opportunities[0].Sys_BypassValidation__c = true;
            update Opportunities[0];
        }
    }
}