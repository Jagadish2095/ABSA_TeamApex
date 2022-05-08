/**
 * @description       : This is the Controller Class for the Cheque Account And Overdraft Details
 * @author            : englarmerdge.mongwe@absa.africa
 * @group             :
 * @last modified on  : 06-24-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-07-03   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class ChequeAndOverdraftController {
    private static Boolean isUpdate = false;
    private static Boolean isError = false;
    private static Boolean isValid = false;
    private static Integer numberOfProductTypes = 0;
    private static Map<String, String> mapStatus = new Map<String, String>();

    /** @description CurChequeAndOverdraft wrapper class */
    public class CurChequeAndOverdraft extends Overdraft {
        /** @description property Id */
        @auraEnabled public Id Id { get;set; }
        /** @description property ItemId */
        @auraEnabled public Integer ItemId { get;set; }
        /** @description property IsSavedAccount */
        @auraEnabled public Boolean IsSavedAccount { get;set; }
        /** @description property IsPrimaryConduct */
        @auraEnabled public Boolean IsPrimaryConduct { get;set; }
        /** @description property IsAdditionalConduct */
        @auraEnabled public Boolean IsAdditionalConduct { get;set; }
        /** @description property IsDeleteAccount */
        @auraEnabled public Boolean IsDeleteAccount { get;set; }
        /** @description property SevEncrytepAccountNumber */
        @auraEnabled public String SevEncrytepAccountNumber { get;set; }
        /** @description property SevAccountNameNumber */
        @auraEnabled public String SevAccountNameNumber { get;set; }
        /** @description property SevAccountType */
        @auraEnabled public String SevAccountType { get;set; }
        /** @description property SevAccountTypeCode */
        @auraEnabled public String SevAccountTypeCode { get;set; }
        /** @description property SevAccountBalance */
        @auraEnabled public String SevAccountBalance { get;set; }
        /** @description property SevCurrentODLimit */
        @auraEnabled public String SevCurrentODLimit { get;set; }
        /** @description property SevExpiryDate */
        @auraEnabled public String SevExpiryDate { get;set; }
        /** @description property SevFacilityReviewDate */
        @auraEnabled public String SevFacilityReviewDate { get;set; }
        /** @description property SevAlternativeFundIndicator */
        @auraEnabled public String SevAlternativeFundIndicator { get;set; }
        /** @description property SevAlternativeFundCode */
        @auraEnabled public String SevAlternativeFundCode { get;set; }
        /** @description property SevRestrictiveHold */
        @auraEnabled public String SevRestrictiveHold { get;set; }
        /** @description property SevBranchCode */
        @auraEnabled public String SevBranchCode { get;set; }
        /** @description property SevCurrentOnceOffAmount */
        @auraEnabled public String SevCurrentOnceOffAmount { get;set; }
        /** @description property SevCurrentReductionAmount */
        @auraEnabled public String SevCurrentReductionAmount { get;set; }

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
        **/
        public CurChequeAndOverdraft() {}

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
         * @param appPrd
         * @param appPrdOverdraft
        **/
        public CurChequeAndOverdraft(Application_Product__c appPrd, Application_Product__c appPrdOverdraft) {
            SevAccountTypeCode = appPrd.Product_Type__c;
            SevAccountBalance = String.valueOf(appPrd.Account_Balance__c);
            SevCurrentODLimit = String.valueOf(appPrd.Current_Overdraft_Limit__c);
            SevExpiryDate = String.valueOf(appPrd.Expiry_Date__c);
            SevFacilityReviewDate = String.valueOf(appPrd.Review_Date__c);
            SevAlternativeFundIndicator = String.valueOf(appPrd.Alternative_Fund_Indicator__c);
            SevAlternativeFundCode = appPrd.Alternative_Fund_Code__c;
            SevRestrictiveHold = appPrd.Restrictive_Hold__c;
            SevCurrentOnceOffAmount = String.valueOf(appPrd.Current_Once_Of_Amount__c);
            SevCurrentReductionAmount = String.valueOf(appPrd.Current_Reduction_Amount__c);

            Id = appPrd.Id;
            ApplicationProductChild = appPrdOverdraft.Id;
            AlternativeFundCode = appPrdOverdraft.Alternative_Fund_Code__c;
            AlternativeFundIndicator = appPrdOverdraft.Alternative_Fund_Indicator__c;
            CampaignCode = appPrdOverdraft.Campaign_Code__c;
            LimitType = appPrdOverdraft.Limit_Type__c;
            OnceOffAmount = appPrdOverdraft.Once_Off_Amount__c;
            OnceOffDate = appPrdOverdraft.Once_Off_Date__c;
            OverdraftLimitNewAmount = appPrdOverdraft.Product_Amount__c;
            OverdraftPurposeOther = appPrdOverdraft.Overdraft_Purpose_Other__c;
            OverdraftPurpose = appPrdOverdraft.Overdraft_Purpose__c;
            ReductionAmount = appPrdOverdraft.Reduction_Amount__c;
            ReductionDate = appPrdOverdraft.Reduction_Date__c;
            ReductionFrequency = appPrdOverdraft.Reduction_Frequency__c;
            SecuredByMortgageBond = appPrdOverdraft.Secured_By_Mortgage_Bond__c;
            VariableData = assignVariableData(appPrdOverdraft);
        }
    }

    /** @description ChequeAndOverdraft wrapper class */
    public class ChequeAndOverdraft extends Overdraft {
        /** @description property Id */
        @auraEnabled public Id Id { get;set; }
        /** @description property ItemId */
        @auraEnabled public Integer ItemId { get;set; }
        /** @description property AccountNumber */
        //@auraEnabled public Decimal AccountNumber { get;set; }
        /** @description property ChequeProductType */
        @auraEnabled public String ChequeProductType { get;set; }

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
         * @param appPrd
         * @param appPrdOverdraft
        **/
        public ChequeAndOverdraft(Application_Product__c appPrd, Application_Product__c appPrdOverdraft) {
            //construct cheque account data
            Id = appPrd.Id;
            //AccountNumber = appPrd.Account_Number__c;
            ChequeProductType = appPrd.Product_Type__c;
            TempAccountNumber = appPrd.Temp_Account_Number__c;

            //construct overdraft data as it is a child of cheque account
            ApplicationProductChild = appPrdOverdraft.Id;
            AlternativeFundCode = appPrdOverdraft.Alternative_Fund_Code__c;
            AlternativeFundIndicator = appPrdOverdraft.Alternative_Fund_Indicator__c;
            CampaignCode = appPrdOverdraft.Campaign_Code__c;
            LimitType = appPrdOverdraft.Limit_Type__c;
            OnceOffAmount = appPrdOverdraft.Once_Off_Amount__c;
            OnceOffDate = appPrdOverdraft.Once_Off_Date__c;
            OverdraftLimitNewAmount = appPrdOverdraft.Product_Amount__c;
            OverdraftPurposeOther = appPrdOverdraft.Overdraft_Purpose_Other__c;
            OverdraftPurpose = appPrdOverdraft.Overdraft_Purpose__c;
            ReductionAmount = appPrdOverdraft.Reduction_Amount__c;
            ReductionDate = appPrdOverdraft.Reduction_Date__c;
            EnforcedReducingLimit = appPrdOverdraft.Enforced_Reducing_Limit__c;
            ReductionFrequency = appPrdOverdraft.Reduction_Frequency__c;
            SecuredByMortgageBond = appPrdOverdraft.Secured_By_Mortgage_Bond__c;
            VariableData = assignVariableData(appPrdOverdraft);
        }
    }

    /** @description Overdraft wrapper class */
    public virtual class Overdraft {
        /** @description property AlternativeFundCode */
        @auraEnabled public String AlternativeFundCode { get;set; }
        /** @description property AlternativeFundIndicator */
        @auraEnabled public Boolean AlternativeFundIndicator { get;set; }
        /** @description property ApplicationProductChild */
        @auraEnabled public String ApplicationProductChild { get;set; }
        /** @description property CampaignCode */
        @auraEnabled public String CampaignCode { get;set; }
        /** @description property LimitType */
        @auraEnabled public String LimitType { get;set; }
        /** @description property OnceOffAmount */
        @auraEnabled public Decimal OnceOffAmount { get;set; }
        /** @description property OnceOffDate */
        @auraEnabled public Date OnceOffDate { get;set; }
        /** @description property OverdraftLimitNewAmount */
        @auraEnabled public Decimal OverdraftLimitNewAmount { get;set; }
        /** @description property OverdraftPurposeOther */
        @auraEnabled public String OverdraftPurposeOther { get;set; }
        /** @description property OverdraftPurpose */
        @auraEnabled public String OverdraftPurpose { get;set; }
        /** @description property ReductionAmount */
        @auraEnabled public Decimal ReductionAmount { get;set; }
        /** @description property ReductionDate */
        @auraEnabled public Date ReductionDate { get;set; }
        /** @description property ReductionFrequency */
        @auraEnabled public String ReductionFrequency { get;set; }
        /** @description property EnforcedReducingLimit */
        @auraEnabled public String EnforcedReducingLimit { get;set; }
        /** @description property SecuredByMortgageBond */
        @auraEnabled public Boolean SecuredByMortgageBond { get;set; }
        /** @description property TempAccountNumber */
        @auraEnabled public String TempAccountNumber { get;set; }
        /** @description property VariableData */
        @auraEnabled public List<Map<String,String>> VariableData { get;set; }

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
        **/
        public Overdraft(){}

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
         * @param alternativeFundCode
         * @param alternativeFundIndicator
         * @param applicationProductChild
         * @param campaignCode
         * @param limitType
         * @param onceOffAmount
         * @param onceOffDate
         * @param overdraftLimitNewAmount
         * @param overdraftPurposeOther
         * @param overdraftPurpose
         * @param reductionAmount
         * @param reductionDate
         * @param reductionFrequency
         * @param enforcedReducingLimit
         * @param securedByMortgageBond
         * @param tempAccountNumber
         * @param variableData
        **/
        public Overdraft(String alternativeFundCode,
                Boolean alternativeFundIndicator,
                String applicationProductChild,
                String campaignCode,
                String limitType,
                Decimal onceOffAmount,
                Date onceOffDate,
                Decimal overdraftLimitNewAmount,
                String overdraftPurposeOther,
                String overdraftPurpose,
                Decimal reductionAmount,
                Date reductionDate,
                String reductionFrequency,
                String enforcedReducingLimit,
                Boolean securedByMortgageBond,
                String tempAccountNumber,
                List<Map<String,String>> variableData
                ) {
            AlternativeFundCode = alternativeFundCode;
            AlternativeFundIndicator = alternativeFundIndicator;
            ApplicationProductChild = applicationProductChild;
            CampaignCode = campaignCode;
            LimitType = limitType;
            OnceOffAmount = onceOffAmount;
            OnceOffDate = onceOffDate;
            OverdraftLimitNewAmount = overdraftLimitNewAmount;
            OverdraftPurposeOther = overdraftPurposeOther;
            OverdraftPurpose = overdraftPurpose;
            ReductionAmount = reductionAmount;
            ReductionDate = reductionDate;
            ReductionFrequency = reductionFrequency;
            EnforcedReducingLimit = enforcedReducingLimit;
            SecuredByMortgageBond = securedByMortgageBond;
            TempAccountNumber = tempAccountNumber;
            VariableData = variableData;
        }
    }

    /** @description DisplayAccConduct wrapper class */
    public class DisplayAccConduct {
        /** @description property AccountNameNumber */
        @auraEnabled public Object AccountNameNumber { get;set; }
        /** @description property ChequeProductType */
        @auraEnabled public Object ChequeProductType { get;set; }
        /** @description property ChequeConductDetails */
        @auraEnabled public Object ChequeConductDetails { get;set; }

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
        **/
        public DisplayAccConduct() {}
    }

    /** @description Dictionery class */
    public class Dictionery {
        /** @description property label */
        @AuraEnabled public String label {get;set;}
        /** @description property value */
        @AuraEnabled public String value {get;set;}
        /** @description property selected */
        @AuraEnabled public Boolean selected {get;set;}

        /**
         * @description constructor
         * @author englarmerdge.mongwe@absa.africa | 2020-07-03
         * @param label
         * @param value
         * @param selected
        **/
        public Dictionery(String label, String value, Boolean selected){
            this.label = label;
            this.value = value;
            this.selected = selected;
        }
    }

    /**
     * @description method to get linked CHQ/Credit Card data from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @return String
    **/
    @AuraEnabled
    public static String getLinkedChequeAccounts(String oppId) {

        List<CurChequeAndOverdraft> accountList = new List<CurChequeAndOverdraft>();
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        CQgetOverdraftDetailsV4_Resp_IB_v1.CQgetOverdraftDetailsV4Response respOverDd;
        List<Product2> prodList = new ProductsSelector().selectByFamily('Cheque');
        List<Price_Scheme__c> priceList = new PriceSchemesSelector().selectByFamily('Cheque');

        List<Boolean> isUpdateList = new List<Boolean>();
        for(Application_Product__c output : appPrdList) {
            if(output.Application_Product_Parent__c == null) {
                isUpdateList.add((output.Id != null && output.Account_Balance__c != null && output.Account_Number__c != null && output.Product_Name__c == 'Cheque'));
            }
        }

        if(appPrdList != null && isUpdateList.contains(true)) {
            //then return saved data if any current cheque have been saved
            return getChequeAndOverdraft(oppId, true);
        }
        else {
            ChequeServicesOrchestration_Resp_IB_v1 respOrches = getBasicAccountDetailsService(oppId, user);

            //go to server and do a call out
            if(respOrches != null) {
                Integer count = 0;
                List<String> currProdTypes = new List<String>();
                Map<String,Application_Financial_Conduct__c> appFinConMap = new Map<String,Application_Financial_Conduct__c>();
                Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
                List<Application_Financial_Conduct__c> finconList = new ApplicationFinancialConductSelector().selectByApplicationId(application.Id);

                if(finconList != null){
                    for (Application_Financial_Conduct__c afc : finconList){
                         appFinConMap.put(afc.Account_Name_Number__c, afc);
                    }
                }

                for (ChequeServicesOrchestration_Resp_IB_v1.CQgetBasicAcctDetailsV7Responses output : respOrches.CQgetBasicAcctDetailsV7Responses) {
                    if(!currProdTypes.contains(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType)) {
                        numberOfProductTypes++;
                        currProdTypes.add(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType);
                    }

                    /*if(output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo != null){
                        appFinCon = new ApplicationFinancialConductSelector().selectApplicationFinancialByAccount(application.Id,new Set<String> {output.CQgetBasicAcctDetailsV7Response.cqh455o.accountNo});
                    }*/

                    //excludes Inactive, Cancelled, Revolving, CIB Mid Corp and Islamic accounts
                    if(!(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountStatus == '99' || output.CQgetBasicAcctDetailsV7Response.cqh455o.accountStatus == '0') && isInProductCode(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType)) {
                        count++;
                        CQgetOverdraftDetailsV4_Resp_IB_v1 odServResp = getOverdraftDetailsService(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountNo, user.SiteCode__c, user.SiteType__c, user.Teller_Operator_Code__c, user.SiteCode__c, '', user.Teller_Operator_Code__c, 'ABS');

                        if(odServResp != null) {
                            respOverDd = odServResp.CQgetOverdraftDetailsV4Response;
                        }

                        Map<String,Object> mapData = new Map<String,Object>();
                        mapData.put('ItemId', count);
                        mapData.put('EncrytepAccountNumber', encryptDecryptString(output.CQgetBasicAcctDetailsV7Response.cqh455o.accountNo, true));
                        //mapData.put('AccountNameNumber', getProductTypeName(prodList, priceList, output.cqh455o.accountType) + ' (**** ' + output.cqh455o.accountNo.right(4) + ')');
                        mapData.put('AccountNameNumber', getProductTypeName(prodList, priceList, output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType) + ' (' + output.CQgetBasicAcctDetailsV7Response.cqh455o.accountNo + ')');
                        mapData.put('AccountType', getProductTypeName(prodList, priceList, output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType));
                        mapData.put('AccountTypeCode', getProductTypeCode(prodList,getProductTypeName(prodList, priceList, output.CQgetBasicAcctDetailsV7Response.cqh455o.accountType)));
                        mapData.put('AccountBalance', 'R ' + output.CQgetBasicAcctDetailsV7Response.cqh455o.accountBalance);
                        mapData.put('CurrentODLimit', 'R ' + respOverDd?.cqh478o?.currentOverdraftLimit);
                        mapData.put('ExpiryDate', getFormatedDate(respOverDd?.cqh478o?.expiryDate));
                        mapData.put('FacilityReviewDate', getFormatedDate(respOverDd?.cqh478o?.reviewDate));
                        mapData.put('EnforcedReducingLimit ', respOverDd?.cqh478o?.enforcedReducingLimit);
                        mapData.put('AlternativeFundIndicator', (output.CQgetBasicAcctDetailsV7Response.cqh455o.empowermentFund == null ? 'NO' : 'YES'));
                        mapData.put('AlternativeFundCode', (output.CQgetBasicAcctDetailsV7Response.cqh455o.empowermentFund == null ? '' : output.CQgetBasicAcctDetailsV7Response.cqh455o.empowermentFund));
                        mapData.put('CurrentOnceOffAmount', (respOverDd?.cqh478o?.reduction1timeAmount == null ? '' : respOverDd?.cqh478o?.reduction1timeAmount));
                        mapData.put('CurrentReductionAmount',(respOverDd?.cqh478o?.reductionAmount == null ? '' :respOverDd?.cqh478o?.reductionAmount));

                        String accountHold = '';
                        for(ChequeServicesOrchestration_Resp_IB_v1.AccountHolds item : output.CQgetBasicAcctDetailsV7Response.cqh455o.accountHolds) {
                            if(item.accountHold != null) {
                                accountHold += item.accountHold + ', ';
                            }
                        }

                        mapData.put('RestrictiveHold', accountHold.removeEnd(', '));
                        mapData.put('BranchCode', output.CQgetBasicAcctDetailsV7Response.cqh455o.branchCode);

                        Application_Product__c appPrdCheque = new Application_Product__c();
                        Application_Product__c appPrdOverdraft = new Application_Product__c();
                        CurChequeAndOverdraft curChqAndOvr = new CurChequeAndOverdraft(appPrdCheque, appPrdOverdraft);

                        for(String str : mapData.keyset()) {

                            curChqAndOvr.ItemId = (str == 'ItemId' ? (Integer)mapData.get(str) : curChqAndOvr.ItemId);
                            curChqAndOvr.SevEncrytepAccountNumber = (str == 'EncrytepAccountNumber' ? (String)mapData.get(str) : curChqAndOvr.SevEncrytepAccountNumber);
                            curChqAndOvr.SevAccountNameNumber = (str == 'AccountNameNumber' ? (String)mapData.get(str) : curChqAndOvr.SevAccountNameNumber);
                            curChqAndOvr.SevAccountType = (str == 'AccountType' ? (String)mapData.get(str) : curChqAndOvr.SevAccountType);
                            curChqAndOvr.SevAccountTypeCode = (str == 'AccountTypeCode' ? (String)mapData.get(str) : curChqAndOvr.SevAccountTypeCode);
                            curChqAndOvr.SevAccountBalance = (str == 'AccountBalance' ? (String)mapData.get(str) : curChqAndOvr.SevAccountBalance);
                            curChqAndOvr.SevCurrentODLimit = (str == 'CurrentODLimit' ? (String)mapData.get(str) : curChqAndOvr.SevCurrentODLimit);
                            curChqAndOvr.SevExpiryDate = (str == 'ExpiryDate' ? (String)mapData.get(str) : curChqAndOvr.SevExpiryDate);
                            curChqAndOvr.SevFacilityReviewDate = (str == 'FacilityReviewDate' ? (String)mapData.get(str) : curChqAndOvr.SevFacilityReviewDate);
                            curChqAndOvr.EnforcedReducingLimit = (str == 'EnforcedReducingLimit' ? (String)mapData.get(str) : curChqAndOvr.EnforcedReducingLimit);
                            curChqAndOvr.SevAlternativeFundIndicator = (str == 'AlternativeFundIndicator' ? (String)mapData.get(str) : curChqAndOvr.SevAlternativeFundIndicator);
                            curChqAndOvr.SevAlternativeFundCode = (str == 'AlternativeFundCode' ? (String)mapData.get(str) : curChqAndOvr.SevAlternativeFundCode);
                            curChqAndOvr.SevRestrictiveHold = (str == 'RestrictiveHold' ? (String)mapData.get(str) : curChqAndOvr.SevRestrictiveHold);
                            curChqAndOvr.SevBranchCode = (str == 'BranchCode' ? (String)mapData.get(str) : curChqAndOvr.SevBranchCode);
                            curChqAndOvr.SevCurrentOnceOffAmount = (str == 'CurrentOnceOffAmount' ? (String)mapData.get(str) : curChqAndOvr.SevCurrentOnceOffAmount);
                            curChqAndOvr.SevCurrentReductionAmount = (str == 'CurrentReductionAmount' ? (String)mapData.get(str) : curChqAndOvr.SevCurrentReductionAmount);
                            if(appFinConMap.containsKey(string.valueOf(output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo))){
                            //curChqAndOvr.IsSavedAccount  = True;
                            curChqAndOvr.IsPrimaryConduct = (output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo != null && appFinConMap.get(string.valueOf(output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo))?.Conduct_Type__c == 'Primary Conduct' ? true : false);
                            curChqAndOvr.IsAdditionalConduct = (output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo != null && appFinConMap.get(string.valueOf(output?.CQgetBasicAcctDetailsV7Response?.cqh455o?.accountNo))?.Conduct_Type__c == 'Additional Conduct' ? true : false);
                            }
                        }
                        accountList.add(curChqAndOvr);
                    } //if(count == 1) {break;} //for testing purposes
                }

                if(numberOfProductTypes > 0) {
                    Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
                    app.Number_of_Product_Types__c = numberOfProductTypes;
                    app.Accounts_Orchestration_JSON__c = JSON.serialize(respOrches);

                    try {
                        update app;
                    }
                    catch (Exception ex) {
                        throw new AuraException('Update Application failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
                    }
                }
            }

            return JSON.serialize(accountList);
        }
    }

    /**
     * @description method to get and save conduct data to object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param objData
     * @return Map<String, String>
    **/
    @AuraEnabled
    public static Map<String, String> getAndSaveClientConductDetails(String oppId, String objData) {
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id);
        List<Object> conductObj = (List<Object>)JSON.deserializeUntyped(objData);

        if(appFinConList != null && appFinConList.size() >= 1) {
            isUpdate = true;
        }

        List<Application_Financial_Conduct__c> appFinConListUpdate = new List<Application_Financial_Conduct__c>();
        for(Object objItem : conductObj) {

            Map<String, Object> mapObj = (Map<String, Object>)objItem;
            String accountNbr = (String)mapObj.get('accountNo');
            String branchCode = (String)mapObj.get('branchCode');
            String conductType = (String)mapObj.get('conductType');

            accountNbr = encryptDecryptString(accountNbr, false);

            if(isUpdate) {

                for(Application_Financial_Conduct__c appFincon : appFinConList){
                    if(appFincon.Account_Name_Number__c == accountNbr){
                        appFincon.Conduct_Type__c = conductType;
                        appFinConListUpdate.add(appFincon);
                    }
                    else{
                        mapStatus.put('Status', 'Successfully!');
                    }
                }
            }

            if(!isUpdate) {
                CQgetClientConductV3_Resp_IB_v1 respBasic = getClientConductDetailsService(accountNbr, branchCode, user);//,'','','','','','');

                if(respBasic != null) {
                    CQgetClientConductV3_Resp_IB_v1.CQgetClientConductV3Response resp = respBasic.CQgetClientConductV3Response;
                    Application_Financial_Conduct__c appFinCon = new Application_Financial_Conduct__c();

                    appFinCon.Account_Name_Number__c = resp.cqh482o.accountNbrOut;
                    appFinCon.Amount_Last_Credit__c = Decimal.valueOf(resp.cqh482o.lastCreditAmnt);
                    appFinCon.Amount_Of_Last_Debit__c = Decimal.valueOf(resp.cqh482o.lastDebitAmnt);
                    appFinCon.Application__c = app.Id;
                    appFinCon.Balance__c = Decimal.valueOf(resp.cqh482o.currentBalance);
                    appFinCon.Cheque_Product_Type__c = resp.cqh482o.accountType;
                    appFinCon.Conduct_Type__c = conductType;
                    appFinCon.Current_Credit_T_O__c = Decimal.valueOf(resp.cqh482o.toCurrentYr);
                    appFinCon.Current_Highest_Balance__c = Decimal.valueOf(resp.cqh482o.highBalCurr);
                    appFinCon.Current_Lowest_Balance__c = Decimal.valueOf(resp.cqh482o.lowBalCurr);
                    appFinCon.Date_Last_Overdraft_Captured__c = getFormatedDate(resp.cqh482o.lastCreditDate);
                    appFinCon.Date_Last_Within_Limit__c = getFormatedDate(resp.cqh482o.lastWithinLmtDate);
                    appFinCon.Date_LST_Within_Limit__c = getFormatedDate(resp.cqh482o.lastWithinLmtDate);
                    appFinCon.Date_Of_Last_Credit__c = getFormatedDate(resp.cqh482o.lastCreditDate);
                    appFinCon.Date_Of_Last_Debit__c = getFormatedDate(resp.cqh482o.lastDebitDate);
                    appFinCon.Date_Of_Last_RD__c = getFormatedDate(resp.cqh482o.dateLastRd);
                    appFinCon.Date_Opened__c = getFormatedDate(resp.cqh482o.dateOpened);
                    appFinCon.Days_Since_Last_Credit_Date__c = getDateDifference(resp.cqh482o.lastCreditDate);
                    appFinCon.Excess_Amount__c = Decimal.valueOf(resp.cqh482o.excessAmount);
                    appFinCon.Expiry_Date__c = resp.cqh482o.overdraftExpiryDate;
                    appFinCon.Once_Off_Reduce_Amount__c = Decimal.valueOf(resp.cqh482o.reducibleAmt);//reduction1timeAmount
                    appFinCon.Once_Off_Reduce_Date__c = getFormatedDate(resp.cqh482o.paymentDate);//reduction1timeEffDte
                    appFinCon.Overdraft_Type__c = resp.cqh482o.overdraftType;
                    appFinCon.Payment_Date__c = getFormatedDate(resp.cqh482o.paymentDate);
                    appFinCon.Previous_Credit_T_O__c = Decimal.valueOf(resp.cqh482o.creditIntPrevious);
                    appFinCon.Previous_Highest_Balance__c = Decimal.valueOf(resp.cqh482o.highBalPrevious);
                    appFinCon.Previous_Lowest_Balance__c = Decimal.valueOf(resp.cqh482o.lowBalPrevious);
                    appFinCon.RD_CHQS_Current_Month__c = (Integer.valueOf(resp.cqh482o.rdDaysCurrent) / 4);
                    appFinCon.RD_CHQS_Current_Year__c = resp.cqh482o.rdCurrent;
                    appFinCon.RD_CHQS_Previous_Year__c = resp.cqh482o.rdPrev;
                    appFinCon.RD_Days_12_Months__c = Decimal.valueOf(resp.cqh482o.rdDays12);
                    appFinCon.Reduction_Amount__c = Decimal.valueOf(resp.cqh482o.reducibleAmt);
                    appFinCon.Unauth_OD_12_Months__c = Decimal.valueOf(resp.cqh482o.unauthOd12);
                    appFinCon.Year_Before_Last_T_O__c = resp.cqh482o.toYrBeforeLast;

                    appFinConList.Add(appFinCon);
                }
            }
        }

        if(appFinConList.size() > 0 && (!isUpdate)) {
            try{
                insert appFinConList;
                //Saurabh adding a additional validation here so that we can proceed after conduct is saved, it wont duplicate validation
                PowerCurveController.setValidationFields(OppId, 'Cheque_Overdraft_Validated', True);
            }
            catch(Exception ex) {
                mapStatus.put('Status', 'Client Conduct Details Save Failed!: ' + ex.getDmlMessage(0));
                return mapStatus;
            }

            mapStatus.put('Status', 'Client Conduct Details Saved Successfully!');
        }
        else if(appFinConListUpdate.size() > 0 && isUpdate) {
            try {
                update appFinConListUpdate;
                mapStatus.put('Status', 'Client Conduct Details Saved Successfully!');
            }
            catch (Exception ex) {
                mapStatus.put('Status', 'Client Conduct Details Save Failed!:' + ex.getDmlMessage(0));
            }
        }

        return (mapStatus.isEmpty() ? null : mapStatus);
    }

    /**
     * @description method to get conduct data from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param conductType
     * @return DisplayAccConduct
    **/
    @AuraEnabled
    public static DisplayAccConduct getClientConduct(String oppId, String conductType) {
        DisplayAccConduct dspr = new DisplayAccConduct();
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id);
        List<Product2> prodList = new ProductsSelector().selectByFamily('Cheque');
        List<Price_Scheme__c> priceList = new PriceSchemesSelector().selectByFamily('Cheque');

        if(appFinConList.size() != null && appFinConList.size() > 0) {

            for(Application_Financial_Conduct__c appFinCon : appFinConList) {

                if(appFinCon.Conduct_Type__c == conductType) {
                    //Saurabh : W: 12371 Translating the value for UI, dont want to impact existing usage of field
                    appFinCon.Overdraft_Type__c = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('PowerCurve', 'Overdraft Limit Type', appFinCon.Overdraft_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
                    Map<String,Object> mapData = new Map<String,Object>();
                    //mapData.put('AccountNameNumber', getProductTypeName(prodList, appFinCon.Cheque_Product_Type__c) + ' (**** ' + appFinCon.Account_Name_Number__c.right(4) + ')');
                    mapData.put('AccountNameNumber', getProductTypeName(prodList, priceList, appFinCon.Cheque_Product_Type__c) + ' (' + appFinCon.Account_Name_Number__c + ')');
                    mapData.put('ChequeProductType', getProductTypeName(prodList, priceList, appFinCon.Cheque_Product_Type__c));
                    mapData.put('ChequeConductDetails', appFinCon);

                    for(String str : mapData.keyset()) {
                        dspr.AccountNameNumber = (str == 'AccountNameNumber' ? mapData.get(str) : dspr.AccountNameNumber);
                        dspr.ChequeProductType = (str == 'ChequeProductType' ? mapData.get(str) : dspr.ChequeProductType);
                        dspr.ChequeConductDetails = (str == 'ChequeConductDetails' ? mapData.get(str) : dspr.ChequeConductDetails);
                    }
                }
            }
            return dspr;
        }
        return null;
    }

    /**
     * @description method to get product data from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param isCurrCheque
     * @return String
    **/
    @AuraEnabled
    public static String getChequeAndOverdraft(String oppId, Boolean isCurrCheque) {
        List<ChequeAndOverdraft> chqAndOvdList = new List<ChequeAndOverdraft>();
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        List<Product2> prodList = new ProductsSelector().selectByFamily('Cheque');
        List<Price_Scheme__c> priceList = new PriceSchemesSelector().selectByFamily('Cheque');

        if(appPrdList != null && appPrdList.size() > 0) {
            if(isCurrCheque) {
                List<CurChequeAndOverdraft> curChqList = new List<CurChequeAndOverdraft>();
                Integer count = 0;

                for(Application_Product__c output : appPrdList) {
                    Application_Financial_Conduct__c appFinCon;
                    //get only the parent cheque products and will in overdraft data
                    if(!output.IsMainProduct__c && output.Application_Product_Parent__c == null && output.Account_Number__c != null) {
                        count++;

                        //get child item data first and populate cheque account
                        Application_Product__c appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(output.Id);
                        CurChequeAndOverdraft curChqAndOvr = new CurChequeAndOverdraft(output, appPrdOverdraft);
                        String accountNumber = (output.Account_Number__c == null ? '' : String.valueOf(output.Account_Number__c));

                        try {
                            appFinCon = new ApplicationFinancialConductSelector().selectApplicationFinancialByAccount(app.Id,new Set<String> {accountNumber});
                        } catch (Exception ex) {
                            System.debug('Select Application Financial By Account failed!::: ' + ex.getMessage());
                        }

                        curChqAndOvr.ItemId = count;
                        curChqAndOvr.IsSavedAccount = true;
                        curChqAndOvr.IsPrimaryConduct = (appFinCon != null && appFinCon.Conduct_Type__c == 'Primary Conduct' ? true : false);
                        curChqAndOvr.IsAdditionalConduct = (appFinCon != null && appFinCon.Conduct_Type__c == 'Additional Conduct' ? true : false);
                        //curChqAndOvr.SevAccountNameNumber = output.Product_Type__c + ' (**** ' + accountNumber.right(4) + ')';
                        if (!Test.isRunningTest()){
                           curChqAndOvr.SevAccountNameNumber = getProductTypeName(prodList, priceList, output.Product_Type__c.right(2)) + ' (' + accountNumber + ')';
                           curChqAndOvr.SevAccountType = getProductTypeName(prodList, priceList, output.Product_Type__c.right(2));
                        }
                        curChqAndOvr.SevEncrytepAccountNumber = encryptDecryptString(accountNumber, true);
                        curChqAndOvr.SevAccountBalance = 'R ' + output.Account_Balance__c;
                        curChqAndOvr.SevCurrentODLimit = 'R ' + output.Current_Overdraft_Limit__c;
                        curChqAndOvr.SevAlternativeFundIndicator = (output.Alternative_Fund_Indicator__c == true ? 'YES' : 'NO');
                        curChqAndOvr.SevExpiryDate = String.valueOf(output.Expiry_Date__c);
                        curChqAndOvr.SevFacilityReviewDate = String.valueOf(output.Review_Date__c);
                        curChqAndOvr.SevAlternativeFundCode = output.Alternative_Fund_Code__c;
                        curChqAndOvr.SevRestrictiveHold = output.Restrictive_Hold__c;
                        //curChqAndOvr.SevBranchCode = output.
                        curChqAndOvr.SevCurrentOnceOffAmount = output.Current_Once_Of_Amount__c;
                        curChqAndOvr.SevCurrentReductionAmount = output.Current_Reduction_Amount__c;
                        curChqList.add(curChqAndOvr);
                    }
                }

                if(curChqList.size() > 0) {
                    return JSON.serialize(curChqList);
                }
            }
            else {
                Integer count = 0;

                for(Application_Product__c output : appPrdList) {
                    //get only the parent cheque products and will in overdraft data
                    if(!output.IsMainProduct__c && output.Application_Product_Parent__c == null
                        && output.Account_Number__c == null && output.Account_Balance__c == null) {
                        count++;

                        if(appPrdList.size() > 1) {
                            //get child item data first and populate cheque account
                            Application_Product__c appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(output.Id);
                            ChequeAndOverdraft chqAndOvr = new ChequeAndOverdraft(output, appPrdOverdraft);
                            chqAndOvr.ItemId = count;
                            chqAndOvdList.add(chqAndOvr);
                        }
                    }
                }
            }
        }

        return JSON.serialize(chqAndOvdList);
    }

    /**
     * @description method to get product temp data from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param itemNum
     * @return String
    **/
    @AuraEnabled
    public static String getTempChequeId(String oppId, Integer itemNum) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(app.Opportunity__c);

        if(app != null) {
            Application_Product__c appPrdCheque = new Application_Product__c();
            Application_Product__c appPrdOverdraft = new Application_Product__c();

            //if(isNotNullOrEmpty(appPrdList)) {
                itemNum++;
                //cheque product
                appPrdCheque.Opportunity_Product_Id__c = oppId;
                appPrdCheque.Opportunity__c = oppId;

                try {
                    insert appPrdCheque;
                }
                catch (Exception ex) {
                    return 'GetTempChequeId Insert failed: ' + ex.getDmlMessage(0);
                }

                appPrdCheque = new ApplicationProductSelector().selectApplicationProductById(appPrdCheque.Id);
                appPrdOverdraft = linkExistingProductToChequeAcc(appPrdList, appPrdCheque);
            //}

            ChequeAndOverdraft chqAndOvr = new ChequeAndOverdraft(appPrdCheque, appPrdOverdraft);
            chqAndOvr.ItemId = itemNum;

            return JSON.serialize(chqAndOvr);
        }

        return null;
    }

    /**
     * @description method to delete product temp data from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param appPrdId
     * @return String
    **/
    @AuraEnabled
    public static String deleteNewChequeTempId(String appPrdId) {
        Application_Product__c appPrdCheque = new ApplicationProductSelector().selectApplicationProductById(appPrdId);
        Application_Product__c appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(appPrdCheque.Id);
        List<OpportunityLineItem> oppLinItemList = new OpportunityLineItemsSelector().selectByOpportunityId(appPrdCheque.Opportunity__c);
        List<OpportunityLineItem> oppLineItemDelList = new List<OpportunityLineItem>();

        if(isNotNullOrEmpty(oppLinItemList)) {
            for(OpportunityLineItem output : oppLinItemList) {
                if(output.Account_Number__c == appPrdCheque.Temp_Account_Number__c) {
                    oppLineItemDelList.add(output);
                }
            }
        }

        try {

            delete oppLineItemDelList;

            /*//only delete product child records who is not the main product
            if(!appPrdOverdraft.IsMainProduct__c) {
                delete appPrdOverdraft;
            }*/

            delete appPrdOverdraft;

            //then delete parent
            delete appPrdCheque;
        }
        catch (Exception ex) {
            return 'Temp CHQ ID delete failed!: ' + ex.getDmlMessage(0);
            //throw new AuraException('Temp CHQ ID delete failed!: ' + ex.getMessage() + ' ' + e.getStackTraceString());
        }
        return 'Temp CHQ ID delete Successfull!';
    }

    /**
     * @description method to save product data from component
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param objData
     * @return Map<String, String>
    **/
    @AuraEnabled
    public static Map<String, String> saveChequeAndOverdraft(String oppId, String objData) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        List<Product2> prodList = new ProductsSelector().selectByFamily('Cheque');
        List<Price_Scheme__c> priceList = new PriceSchemesSelector().selectByFamily('Cheque');
        List<Object> prodObj = (List<Object>)JSON.deserializeUntyped(objData);

        //if(appPrdList.size() != null && appPrdList.size() >= 1) {
        if(appPrdList.size() != null) {
            Map<String, Object> mapObj = new Map<String, Object>();

            for(Object objItem : prodObj) {
                mapObj.putAll((Map<String, Object>)objItem);
            }

            if(!mapObj.isEmpty()) {
                List<OpportunityLineItem> oppLinItemList;
                List<CurChequeAndOverdraft> curChqAndOvrList = (List<CurChequeAndOverdraft>)JSON.deserialize(JSON.serialize(mapObj.get('CurChqAndOvrDft')), CurChequeAndOverdraft[].class);
                List<ChequeAndOverdraft> newChqAndOvrList = (List<ChequeAndOverdraft>)JSON.deserialize(JSON.serialize(mapObj.get('NewChqAndOvrDft')), ChequeAndOverdraft[].class);
                Application_Product__c appPrdCheque = new Application_Product__c();
                Application_Product__c appPrdOverdraft;
                String productName, lineItemParentId = null;

                if(curChqAndOvrList != null && curChqAndOvrList.size() > 0) {
                    Integer count = 0;

                    for(CurChequeAndOverdraft curOutput : curChqAndOvrList) {
                        count++;
                        lineItemParentId = null;

                        if (Test.isRunningTest()){
                            appPrdCheque = assignObjectData(curOutput, null, oppId, appPrdList[0].Id);
                        }
                        else{
                          appPrdCheque = assignObjectData(curOutput, null, oppId, null);
                        }

                        oppLinItemList = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

                        if(curOutput.IsDeleteAccount) {
                            List<OpportunityLineItem> oppLineItemDelList = new List<OpportunityLineItem>();
                            appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(appPrdCheque.Id);

                            for(OpportunityLineItem output : oppLinItemList) {
                                 if(output.Account_Number__c != null) {
                                    if(Decimal.valueOf(output.Account_Number__c) == appPrdCheque.Account_Number__c) {
                                        oppLineItemDelList.add(output);
                                    }
                                }
                            }

                            try {
                                //delete oppLineItemDelList;
                                deleteRecordList(oppLineItemDelList);
                                if(!appPrdOverdraft.IsMainProduct__c) {
                                    //delete appPrdOverdraft;
                                    deleteRecord(appPrdOverdraft);
                                }
                                //delete appPrdCheque;
                                deleteRecord(appPrdCheque);
                            }
                            catch (Exception ex) {
                                isError = true;
                            }
                            mapStatus.put('Status', 'Cheque And Overdraft Saved Successfully!');
                        }
                        else {
                            try {
                                //upsert appPrdCheque;
                                appPrdCheque = (Application_Product__c)upsertRecord(appPrdCheque);
                                mapStatus.put('Status', 'Cheque And Overdraft Saved Successfully!');

                                //add terms of business records in future context,
                                //update records  once pco call ready
                                List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(new List<Application_Product__c>{appPrdCheque}) ;   // tob based on products
                                if(prodtobList == null ||prodtobList.isEmpty()) {
                                    if (!Test.isRunningTest()){
                                        SetProductTOBController.insertTob(appPrdCheque.Id);  //terms of business
                                    }
                                }else{
                                    SetProductTOBController.updateTOB(appPrdCheque.Id); //update tob if any changes over product
                                }
                            }
                            catch (Exception ex) {
                                isError = true;
                            }

                            //since there's already a product item for overdraft, link it to the first cheque acc only on first entry
                            //and insert new child items for the next selected cheque acc
                            /*if(count >= 2) {
                                appPrdList = new ApplicationProductSelector().selectByOpportunityId(app.Opportunity__c);
                            }*/

                            isUpdate = (curOutput.Id == appPrdCheque.Id);
                            if(!isUpdate) {
                                //since there's already a product item for overdraft, link it to the first cheque acc only on first entry not update
                                appPrdOverdraft = linkExistingProductToChequeAcc(appPrdList, appPrdCheque);
                                isUpdate = false;
                            }

                            for(Application_Product__c output : appPrdList) {
                                if(output.Id == curOutput.Id) {
                                    isUpdate = (output.Id != null && output.Account_Balance__c != null && output.Account_Number__c != null);
                                    break;
                                }
                            }

                            //first add parent line item, Cheque product
                            if(appPrdCheque.Product_Type__c != null) {
                                productName = getProductTypeName(prodList, priceList, appPrdCheque.Product_Type__c.right(2));
                                if(!isUpdate) {
                                    mapStatus = addOpportunityLineItem(oppId, productName, lineItemParentId, appPrdCheque, app);
                                }
                            }

                            //if the item is a child of cheque account, then product name is overdraft
                            appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(appPrdCheque.Id);
                            if(appPrdOverdraft.Application_Product_Parent__c != null) {
                                appPrdOverdraft = assignObjectData(curOutput, null, oppId, appPrdOverdraft.Id);
                                appPrdOverdraft.Application_Product_Parent__c = appPrdCheque.Id;

                                try {
                                    //update appPrdOverdraft;
                                    appPrdOverdraft = (Application_Product__c)upsertRecord(appPrdOverdraft);
                                }
                                catch (Exception ex) {
                                    isError = true;
                                }

                                //if(oppLinItemList.size() > 1 && (!isUpdate)) {
                                if(oppLinItemList.size() >= 0 && (!isUpdate)) {
                                    productName = 'Overdraft';
                                    lineItemParentId = mapStatus.get('opportunityLineItemId');
                                    mapStatus = addOpportunityLineItem(oppId, productName, lineItemParentId, appPrdCheque, app);
                                }
                            }
                        }
                    }
                }

                if(newChqAndOvrList != null && newChqAndOvrList.size() > 0) {
                    for(ChequeAndOverdraft output : newChqAndOvrList) {
                        appPrdCheque = assignObjectData(null, output, oppId, null);
                        lineItemParentId = null;
                        oppLinItemList = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

                        for(Application_Product__c appPrdItem : appPrdList) {
                            if(output.Id == appPrdItem.Id) {
                                isUpdate = (appPrdItem.Id != null && (appPrdItem.Product_Type__c != null && appPrdCheque.Application_Product_Parent__c == null));
                                break;
                            }
                        }

                        try {
                            //update appPrdCheque;
                            appPrdCheque = (Application_Product__c)upsertRecord(appPrdCheque);
                            mapStatus.put('Status', 'Cheque And Overdraft Saved Successfully!');

                            //add terms of business records in future context,
                            //update records  once pco call ready
                            List<Terms_Of_Business__c> prodtobList = new TermsOfBusinessSelector().selectByAppProducts(new List<Application_Product__c>{appPrdCheque}) ;   // tob based on products
                            if(prodtobList == null ||prodtobList.isEmpty()) {
                                if (!Test.isRunningTest()){
                                	SetProductTOBController.insertTob(appPrdCheque.Id);  //terms of business
                                }
                            }
                            else {
                                SetProductTOBController.updateTOB(appPrdCheque.Id); //update tob if any changes over product
                            }
                        }
                        catch (Exception ex) {
                            isError = true;
                        }

                        //first add parent opportunity line item, Cheque product
                        if(appPrdCheque.Product_Type__c != null && appPrdCheque.Application_Product_Parent__c == null) {
                            productName = getProductTypeName(prodList, priceList, appPrdCheque.Product_Type__c.right(2));

                            if(!isUpdate) {
                                mapStatus = addOpportunityLineItem(oppId, productName, lineItemParentId, appPrdCheque, app);
                            }
                        }

                        //get child item of cheque account, then populate object and set product name to overdraft
                        appPrdOverdraft = new ApplicationProductSelector().selectApplicationProductByParentId(output.Id);

                        if(appPrdOverdraft.Application_Product_Parent__c != null) {
                            appPrdOverdraft = assignObjectData(null, output, oppId, appPrdOverdraft.Id);

                            try {
                                //update appPrdOverdraft;
                                appPrdOverdraft = (Application_Product__c)upsertRecord(appPrdOverdraft);
                            }
                            catch (Exception ex) {
                                isError = true;
                            }
                            if(oppLinItemList.size() > 1 && (!isUpdate)) {
                                productName = 'Overdraft';
                                lineItemParentId = mapStatus.get('opportunityLineItemId');
                                mapStatus = addOpportunityLineItem(oppId, productName, lineItemParentId, appPrdCheque, app);
                            }
                        }
                    }
                }

                isValid = (!mapStatus.isEmpty() ? mapStatus.get('Status').contains('Saved Successfully') : false);

                if(isValid) {
                    PowerCurveController.setValidationFields(OppId, 'Cheque_Overdraft_Validated', True);
                    getTriadExposureData(oppId);
                }
            }
            return mapStatus;
        }

        return null;
    }

    /**
     * @description method to get picklist items
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @return Map<String, Object>
    **/
    @AuraEnabled
    public static Map<String, Object> getPickListItems() {
        Application_Product__c appProd = new Application_Product__c();
        return (new Map<String,Object>{'selOverDrfPurpose'=> createPickListItems(appProd, 'Overdraft_Purpose__c')
                                        ,'selLimitTypes'=> createPickListItems(appProd, 'Limit_Type__c')
                                        ,'selRedFrequency'=> createPickListItems(appProd, 'Reduction_Frequency__c')
                                        ,'selAltFundCode'=> createPickListItems(appProd, 'Alternative_Fund_Code__c')
                                        ,'selChqPrdTypes'=> createPickListItems(appProd, 'Product_Type__c')});
    }

    private static Application_Product__c linkExistingProductToChequeAcc(List<Application_Product__c> appPrdList, Application_Product__c appPrdCheque) {
        Application_Product__c appPrdOverdraft = new Application_Product__c();
        try {
            /*if(appPrdList.size() == 1) {
                //since there's already a product item for overdraft, link it to the first cheque acc
                appPrdList[0].Application_Product_Parent__c = appPrdCheque.Id;
                appPrdList[0].IsMainProduct__c = true;
                update appPrdList[0];
            }
            //then create the second product item for overdraft and link that to the second check acc if
            //existing product item has been linked
            else if(appPrdList.size() > 1 && appPrdCheque != null) {*/
            if(appPrdList.size() >= 0 && appPrdCheque != null) {
                //add child overdraft product item & link child overdraft product item to parent cheque product
                appPrdOverdraft.Application_Product_Parent__c = appPrdCheque.Id;
                appPrdOverdraft.Opportunity_Product_Id__c = appPrdCheque.Opportunity__c; //appPrdList[0].Opportunity__c;
                appPrdOverdraft.Opportunity__c = appPrdCheque.Opportunity__c; //appPrdList[0].Opportunity__c;
                insert appPrdOverdraft;
            }
            return appPrdOverdraft;
        }
        catch (Exception ex) {
            return null;
        }
    }

    private static Map<String,String> addOpportunityLineItem(String oppId, String productName, String lineItemParentId, Application_Product__c apc, Application__c app) {
        if(!isError) {
            List<OpportunityLineItem> oppLinItemList = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
            Product2 prod = new ProductsSelector().selectByName(productName);

            //if(prod != null && isNotNullOrEmpty(oppLinItemList)) {
            if(prod != null) {
                // Insert new Opportunity Product
                OpportunityLineItem opportunityLineItem = new OpportunityLineItem();
                opportunityLineItem.OpportunityId = app.Opportunity__c;
                opportunityLineItem.Product2Id = prod.Id;
                opportunityLineItem.TotalPrice = 0;
                opportunityLineItem.Quantity = 1;
                opportunityLineItem.PricebookEntryId = Sys_Utilities_General.getPriceBookEntryId(prod.Id);
                opportunityLineItem.Parent_Opportunity_Line_Item_Id__c = (lineItemParentId != null ? lineItemParentId : null);
                opportunityLineItem.Application__c = (app != null ? app.Id : null);
                opportunityLineItem.Account_Number__c = (apc.Account_Number__c != null ? String.valueOf(apc.Account_Number__c) : apc.Temp_Account_Number__c);

                try {
                    insert opportunityLineItem;
                    apc.Opportunity_Product_Id__c = opportunityLineItem.Id;
                    mapStatus.put('opportunityLineItemId', opportunityLineItem.Id);

                    update apc; //link Opp Line Item to Application product
                    mapStatus.put('Status', 'Cheque And Overdraft Saved Successfully!');
                }
                catch (Exception ex) {
                    mapStatus.put('Status', 'Cheque And Overdraft Opportunity Line Item Save Failed!: ' + ex.getDmlMessage(0));
                }

                //link first overdraft line item to parent cheque line item
                /*if(oppLinItemList != null && oppLinItemList.size() == 1) {
                    oppLinItemList[0].Parent_Opportunity_Line_Item_Id__c = opportunityLineItem.Id;
                    try {
                        update oppLinItemList;
                    }
                    catch (Exception ex) {
                        mapStatus.put('Status', 'Cheque And Overdraft Opportunity Line Item Save Failed!: ' + ex.getDmlMessage(0));
                    }
                }*/
            }
            else {
                isError = true;
                mapStatus.put('Status', 'Cheque And Overdraft Product Doesnt exist!');
            }
        }
        return mapStatus;
    }

    private static Application_Product__c assignObjectData(CurChequeAndOverdraft curOutput, ChequeAndOverdraft newOutput, String oppId, Id OverdraftId) {
        Application_Product__c appPrd = new Application_Product__c();
        appPrd.Opportunity_Product_Id__c = oppId;
        appPrd.Opportunity__c = oppId;

        if(OverdraftId == null) {
            appPrd.Id = (newOutput == null ? curOutput.Id : newOutput.Id);
            appPrd.Product_State__c = (newOutput == null ? 'Existing' : 'New');
            appPrd.Product_Name__c = 'Cheque';
            appPrd.Account_Balance__c = (curOutput == null ? null : Decimal.valueOf(curOutput.SevAccountBalance.removeStart('R ')));
            appPrd.Account_Number__c = (curOutput == null ? null : Decimal.valueOf(encryptDecryptString(curOutput.SevEncrytepAccountNumber, false)));
            appPrd.Current_Overdraft_Limit__c = (curOutput == null ? null : curOutput.SevCurrentODLimit.removeStart('R ')=='null'?null:Decimal.valueOf(curOutput.SevCurrentODLimit.removeStart('R ')));
            appPrd.Expiry_Date__c = (curOutput == null ? null : (curOutput.SevExpiryDate == '0' || curOutput.SevExpiryDate == null ? null : Date.parse(getFormatedDate(curOutput.SevExpiryDate))));
            appPrd.Review_Date__c = (curOutput == null ? null : (curOutput.SevFacilityReviewDate == '0' || curOutput.SevFacilityReviewDate == null ? null : Date.parse(getFormatedDate(curOutput.SevFacilityReviewDate))));
            appPrd.Restrictive_Hold__c = (curOutput == null ? null : curOutput.SevRestrictiveHold);
            appPrd.Product_Type__c = (newOutput == null ? curOutput.SevAccountTypeCode : newOutput.ChequeProductType);
            //appPrd.Product_Name__c = (appPrd.Product_Type__c == null ? null : getProductTypeName(String.valueOf(appPrd.Product_Type__c).right(2)));
            appPrd.Enforced_Reducing_Limit__c = (newOutput == null ? curOutput.EnforcedReducingLimit : null);
            appPrd.Current_Once_Of_Amount__c = (curOutput == null ? null : curOutput.SevCurrentOnceOffAmount);
            appPrd.Current_Reduction_Amount__c = (curOutput == null ? null : curOutput.SevCurrentReductionAmount);

        }
        else {
            appPrd.Id = OverdraftId;
            appPrd.Product_Name__c = 'Overdraft';
            appPrd.Application_Product_Parent__c = (newOutput == null ? curOutput.Id : newOutput.Id);
            appPrd.Alternative_Fund_Code__c = (newOutput == null ? curOutput.AlternativeFundCode : newOutput.AlternativeFundCode);
            //W:12376 Adding Field mapping to be sent to PCO
            appPrd.Existing_Alternative_Fund_Indicator__c = (newOutput == null ? curOutput.SevAlternativeFundIndicator : newOutput.AlternativeFundCode);
            appPrd.Existing_Alternative_Fund_Code__c = (newOutput == null ? curOutput.SevAlternativeFundCode : newOutput.AlternativeFundCode);// adding as string as per confirmation from Santjie
            appPrd.Alternative_Fund_Indicator__c = (newOutput == null ? curOutput.AlternativeFundIndicator : newOutput.AlternativeFundIndicator);
            appPrd.Campaign_Code__c = (newOutput == null ? curOutput.CampaignCode : newOutput.CampaignCode);
            appPrd.Limit_Type__c = (newOutput == null ? curOutput.LimitType : newOutput.LimitType);
            appPrd.Once_Off_Amount__c = (newOutput == null ? curOutput.OnceOffAmount : newOutput.OnceOffAmount);
            appPrd.Once_Off_Date__c = (newOutput == null ? curOutput.OnceOffDate : newOutput.OnceOffDate);
            appPrd.Product_Amount__c = (newOutput == null ? curOutput.OverdraftLimitNewAmount : newOutput.OverdraftLimitNewAmount);
            appPrd.Overdraft_Purpose_Other__c = (newOutput == null ? curOutput.OverdraftPurposeOther : newOutput.OverdraftPurposeOther);
            appPrd.Overdraft_Purpose__c = (newOutput == null ? curOutput.OverdraftPurpose : newOutput.OverdraftPurpose);
            appPrd.Reduction_Amount__c = (newOutput == null ? curOutput.ReductionAmount : newOutput.ReductionAmount);
            appPrd.Reduction_Date__c = (newOutput == null ? curOutput.ReductionDate : newOutput.ReductionDate);
            appPrd.Reduction_Frequency__c = (newOutput == null ? curOutput.ReductionFrequency : newOutput.ReductionFrequency);
            appPrd.Secured_By_Mortgage_Bond__c = (newOutput == null ? curOutput.SecuredByMortgageBond : newOutput.SecuredByMortgageBond);

            List<Map<String,String>> varData = (newOutput == null ? curOutput.VariableData : newOutput.VariableData);

            if(varData != null) {
                for(Map<String,String> varItem : varData) {
                    String vId = varItem.get('Id');
                    if(vId == '1') {
                        appPrd.Variable_Amount_1__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_1__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '2') {
                        appPrd.Variable_Amount_2__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_2__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '3') {
                        appPrd.Variable_Amount_3__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_3__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '4') {
                        appPrd.Variable_Amount_4__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_4__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '5') {
                        appPrd.Variable_Amount_5__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_5__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '6') {
                        appPrd.Variable_Amount_6__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_6__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '7') {
                        appPrd.Variable_Amount_7__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_7__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '8') {
                        appPrd.Variable_Amount_8__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_8__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '9') {
                        appPrd.Variable_Amount_9__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_9__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '10') {
                        appPrd.Variable_Amount_10__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_10__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '11') {
                        appPrd.Variable_Amount_11__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_11__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                    if(vId == '12') {
                        appPrd.Variable_Amount_12__c = (varItem.get('VariableAmount') == null ? null : Decimal.valueOf(varItem.get('VariableAmount')));
                        appPrd.Variable_Date_12__c = (varItem.get('VariableDate') == null ? null : Date.parse(getFormatedDate(varItem.get('VariableDate'))));
                    }
                }
            }
        }

        return appPrd;
    }

    private static List<Map<String,String>> assignVariableData(Application_Product__c appPrd) {
        Date futD = Date.today().addYears(1);
        return new List<Map<String,String>>{(new Map<String,String>{'Id'=> '1','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_1__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_1__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '2','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_2__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_2__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '3','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_3__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_3__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '4','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_4__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_4__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '5','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_5__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_5__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '6','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_6__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_6__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '7','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_7__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_7__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '8','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_8__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_8__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '9','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_9__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_9__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '10','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_10__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_10__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '11','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_11__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_11__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                           ,(new Map<String,String>{'Id'=> '12','VariableAmount'=> String.valueOf(appPrd.Variable_Amount_12__c),'VariableDate'=> String.valueOf(appPrd.Variable_Date_12__c),'MinDate' => String.valueOf(Date.today()),'MaxDate' => String.valueOf(futD.addDays(-1))})
                                        };
    }

    /**
     * @description method to get linked client accounts data from service
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppId
     * @param user
     * @return ChequeServicesOrchestration_Resp_IB_v1
    **/
    public static ChequeServicesOrchestration_Resp_IB_v1 getBasicAccountDetailsService(String oppId, User user){
        Application__c app = new ApplicationsSelector().selectByOpportunityId(oppId)[0];

        if(Test.isRunningTest()) {
            ChequeServicesOrchestration_IH_v1_Test.orchestrationTestMock();
        }

        if(account.CIF__c != null && app.Accounts_Orchestration_JSON__c != null) {
            //Just to test, remove dummy data when done
            //ChequeServicesOrchestration_Req_IB_v1 req = ChequeServicesOrchestration_Req_IB_v1.createDummyRequest();
            //ChequeServicesOrchestration_Resp_IB_v1 resp = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(account.CIF__c, req.accntnbr, req.siteCode, req.maxret);
            //ChequeServicesOrchestration_Resp_IB_v1 resp = ChequeServicesOrchestration_IH_v1.chequeServicesOrchestration(account.CIF__c,'0',user.SiteCode__c, '0');
			//ChequeServicesOrchestration_Resp_IB_v1 resp = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(ChequeServicesOrchestration_Resp_IB_v1.createDummyResponse(), ChequeServicesOrchestration_Resp_IB_v1.class);
            ChequeServicesOrchestration_Resp_IB_v1 resp = (ChequeServicesOrchestration_Resp_IB_v1) JSON.deserialize(app.Accounts_Orchestration_JSON__c, ChequeServicesOrchestration_Resp_IB_v1.class);

            if(resp.CQgetBasicAcctDetailsV7Responses != null) {
                return resp;
            }
        }

        return null;
    }

    /**
     * @description method to get client overdraft data from service
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param accountNbr
     * @param processingSite
     * @param processingSiteType
     * @param tellerNbr
     * @param agencyCode
     * @param agencyType
     * @param controllerNbr
     * @param corpCode
     * @return CQgetOverdraftDetailsV4_Resp_IB_v1
    **/
    public static CQgetOverdraftDetailsV4_Resp_IB_v1 getOverdraftDetailsService(String accountNbr, String processingSite, String processingSiteType, String tellerNbr, String agencyCode, String agencyType, String controllerNbr, String corpCode) {
        if(Test.isRunningTest()) {
            CQgetOverdraftDetailsV4_IH_v1_Test.overdraftTestMock();
        }

        //Just to test, remove dummy data when done
        CQgetOverdraftDetailsV4_Req_IB_v1 dummyBeanParent = CQgetOverdraftDetailsV4_Req_IB_v1.createDummyRequest();
        CQgetOverdraftDetailsV4_Req_IB_v1.Cqh478i dummyBean = dummyBeanParent.CQgetOverdraftDetailsV4.cqh478i;
        //CQgetOverdraftDetailsV4_Resp_IB_v1 resp = CQgetOverdraftDetailsV4_IH_v1.CQgetOverdraftDetailsV4(accountNbr, dummyBean.processingSite, dummyBean.processingSiteType, dummyBean.tellerNbr, dummyBean.agencyCode, dummyBean.agencyType, dummyBean.controllerNbr, dummyBean.corpCode);
        CQgetOverdraftDetailsV4_Resp_IB_v1 resp = CQgetOverdraftDetailsV4_IH_v1.CQgetOverdraftDetailsV4(accountNbr, processingSite, processingSiteType, dummyBean.tellerNbr, agencyCode, agencyType, controllerNbr, corpCode);

        if(resp.statusCode == 200) {
            if(resp.CQgetOverdraftDetailsV4Response != null) {
                return resp;
            }
        }

        return null;
    }

    /**
     * @description method to get client conduct data from service
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param accountNbr
     * @param branchCode
     * @param user
     * @return CQgetClientConductV3_Resp_IB_v1
    **/
    public static CQgetClientConductV3_Resp_IB_v1 getClientConductDetailsService(String accountNbr, String branchCode, User user) {
        if(Test.isRunningTest()) {
            CQgetClientConductV3_IH_v1_Test.conductTestMock();
        }

        //Just to test, remove dummy data when done
        CQgetClientConductV3_Req_IB_v1 dummyBeanParent = CQgetClientConductV3_Req_IB_v1.createDummyRequest();
        CQgetClientConductV3_Req_IB_v1.Cqh482i dummyBean = dummyBeanParent.CQgetClientConductV3.cqh482i;
        //CQgetClientConductV3_Resp_IB_v1 resp = CQgetClientConductV3_IH_v1.CQgetClientConductV3(accountNbr, branchCode, dummyBean.branchSiteType, dummyBean.tellerCode, dummyBean.siteTypeAgency, dummyBean.supervisorCode, dummyBean.agencyCode, dummyBean.corpCode);
        CQgetClientConductV3_Resp_IB_v1 resp = CQgetClientConductV3_IH_v1.CQgetClientConductV3(accountNbr, user.SiteCode__c, user.SiteType__c, dummyBean.tellerCode, user.SiteType__c, (user.Supervisor__c == null ? '0' : user.Supervisor__c), user.SiteCode__c, user.Division__c);

        if(resp.statusCode == 200) {
            if(resp.CQgetClientConductV3Response != null) {
                return resp;
            }
        }

        return null;
    }

    /**
     * @description method to Encrypt/Decrypt strings, e.g account number
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param inputStr
     * @param encrypt
     * @return string
    **/
    public static string encryptDecryptString(String inputStr, Boolean encrypt) {

        //Use generateAesKey to generate the private key
        addCryptoKey();
        Blob cryptoKey = EncodingUtil.base64Decode(Encrypt_Decrypt__c.getOrgDefaults().Crypto_Key__c);

        if(encrypt) {
            // Generate the data to be encrypted.
            Blob data = Blob.valueOf(inputStr);

            // Encrypt the data and have Salesforce.com generate the initialization vector
            Blob encryptedData = Crypto.encryptWithManagedIV('AES256', cryptoKey, data);

            return EncodingUtil.base64Encode(encryptedData);
        }
        else {

            // Generate the data to be encrypted.
            Blob encryptedData = EncodingUtil.base64Decode(inputStr);

            // Decrypt the data
            Blob decryptedData = Crypto.decryptWithManagedIV('AES256', cryptoKey, encryptedData);
            return decryptedData.toString();
        }
    }

    /**
     * @description mehtod to run Triad and Exposures services
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param oppID
    **/
    public static void getTriadExposureData(String oppID) {
        TriadController.getApplicationTriad(oppID);
        ApplicationExposuresRiskController.getApplicationRiskExposuresfromService(oppID);
        ExposureRiskIdentifierController.getApplicationRiskIdentifiersfromService(oppID);

        //ExposureController.getApplicationExposuresFuture(oppID);
        //ExposureController.getApplicationExposures(oppID);
    }

    /**
     * @description method to add crypto key settings to org
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
    **/
    @AuraEnabled
    public static void addCryptoKey() {
        //Set up Crypto key if not there AES256
        if(Encrypt_Decrypt__c.getOrgDefaults().Crypto_Key__c == null) {
            Blob key = Crypto.generateAesKey(256);
            String keyString = EncodingUtil.base64Encode(key);

            Encrypt_Decrypt__c encryptionSettings = new Encrypt_Decrypt__c();
            encryptionSettings.Crypto_Key__c = keyString;

            try{
                insert encryptionSettings;
            }
            catch(DmlException ex) {
                throw new AuraException('Crypto Key Insert Failed::: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }
    }

    /**
     * @description method to dynamically create picklist items
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param objectName
     * @param fieldName
     * @return List<Dictionery>
    **/
    public static List<Dictionery> createPickListItems(SObject objectName, String fieldName) {
        List<Dictionery> options = new List<Dictionery>();
        options.add(new Dictionery('--Please Select--','',true));

        Schema.DescribeFieldResult fieldResult = objectName.getSObjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
        List<Schema.PicklistEntry> plEntryList = fieldResult.getPicklistValues();

        for(Schema.PicklistEntry plEntry : plEntryList) {
            if(plEntry.active) {
                options.add(new Dictionery(plEntry.label, plEntry.value, false));
            }
        }
        return options;
    }

    /**
     * @description method to formatte string date to DateTime type
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param inputDate
     * @return String
    **/
    public static String getFormatedDate(String inputDate) {
        if(inputDate != null) {
            String stringDate = '';
            if(inputDate.length() >= 10) {
                stringDate = inputDate.substring(0,4) + '/' + inputDate.substring(5,7) + '/' + inputDate.substring(8,10);
            }
            else if(inputDate.length() == 8) {
                stringDate = inputDate.substring(0,4) + '/' + inputDate.substring(4,6) + '/' + inputDate.substring(6,8);
            }
            return (stringDate.equals('9999/99/99') ? '2099/01/01' : stringDate);
        }

        return inputDate;
    }

    /**
     * @description method to get product type name
     * @author englarmerdge.mongwe@absa.africa | 2020-07-03
     * @param prodList
     * @param priceList
     * @param accountType
     * @return String
    **/
    public static String getProductTypeName(List<Product2> prodList, List<Price_Scheme__c> priceList, String accountType) {
        String productName = 'No Product Name';

        for(Price_Scheme__c prod : priceList) {
            if(prod.Product_Code__c != null && accountType != null) {
                if(prod.Product_Code__c.right(3).contains(accountType)) {
                    productName = prod.Product_Name__c;
                    break;
                }
            }
        }

        if(productName == 'No Product Name') {
            for(Product2 prod : prodList) {
                if(prod.ProductCode != null && accountType != null) {
                    if(prod.ProductCode.right(3).contains(accountType)) {
                        productName = prod.Name;
                        break;
                    }
                }
            }
        }

        return productName;
    }

    private static Decimal getDateDifference(String inputDate) {
        if(inputDate.length() > 2) {

            string stringDate = inputDate.substring(0,4) + '/' + inputDate.substring(4,6) + '/' + inputDate.substring(6,8);

            Date sDate = Date.parse(stringDate);
            Integer syy = sDate.year();
            Integer smm = sDate.month();
            Integer sdd = sDate.day();

            Integer eyy = Date.today().year();
            Integer emm = Date.today().month();
            Integer edd = Date.today().day();

            Date startDate = Date.newInstance(syy, smm, sdd);
            Date endDate = Date.newInstance(eyy, emm, edd);
            Integer numberDaysDue = startDate.daysBetween(endDate);

            return numberDaysDue;
        }

        return null;
    }

    private static String getProductTypeCode(List<Product2> prodList, String accountTypeName) {
        String productCode = '';

        for(Product2 prod : prodList) {
            if(prod.Name != null && accountTypeName != null) {
                if(prod.Name.equalsIgnoreCase(accountTypeName)) {
                    productCode = prod.ProductCode;
                    break;
                }
            }
        }

        return productCode;
    }

    /**
	 * @description Adding this method to reset the whole Cheque&OD selection to start fresh with new Accounts
     * Defect Id : W-011314
	 * @author //Saurabh | 2021/04/23
	 * @param accountType
	 * @return Boolean
	**/
    public static Boolean isInProductCode(String accountType) {
        List<String> cheqList = new List<String>{'03','16','18','19','21','26','76','77','32','33','37','48'};
        return cheqList.contains(accountType);
    }

    private static Boolean isNotNullOrEmpty(List<sObject> objList) {
        return (objList != null && objList.size() > 0);
    }

    private static SObject upsertRecord(sObject obj) {
        if(obj != null) {
            upsert obj;
            return obj;
        }
        return null;
    }

    private static void deleteRecord(sObject obj) {
        if(obj != null) {
            delete obj;
        }
    }

    private static void deleteRecordList(List<sObject> obj) {
        if(obj != null && obj.size() > 0) {
            delete obj;
        }
    }

    /**
     * @description Adding this method to reset the whole Cheque&OD selection to start fresh with new Accounts
     * W-011314
     * @author Saurabh.Pandey@absa.africa | 2021/04/23
     * @param oppId
     * @return Boolean
    **/
    @AuraEnabled
    public static Boolean deleteSelectedConductAndFacilityAccount(Id oppId ) {
        Boolean isResetDone = false;
        //Delete Application_Product for Cheque and OD, OLI and Conduct Account
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppId);
        List<sobject> recordsToDelete = new List<sobject>();
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);
        List<Application_Financial_Conduct__c> appFinConList = new ApplicationFinancialConductSelector().selectByApplicationId(app.Id);
        List<OpportunityLineItem> oppLinItemList = [SELECT Id, Product2.Name, OpportunityId, Name FROM OpportunityLineItem WHERE OpportunityId =:oppId
                                                    AND (Product2.Name = 'Business Evolve' OR Product2.Name = 'Overdraft')];

        if(!oppLinItemList.isEmpty()) {
            recordsToDelete.addall(oppLinItemList);
        }
        for(Application_Product__c apc : appPrdList) {
            if(apc.Product_Name__c =='Cheque' || apc.Product_Name__c =='Overdraft' || apc.Product_Name__c == '') {
                recordsToDelete.add(apc);
            }
        }

        //add conduct Accounts
        recordsToDelete.addall(appFinConList);
        try{
            if(!recordsToDelete.isEmpty()) {
                delete recordsToDelete;
                isResetDone = True;
            }
        }
        catch(DmlException ex) {
            throw new AuraException('Conduct/Facility Account deletion Failed::: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }

        return isResetDone;
    }
}