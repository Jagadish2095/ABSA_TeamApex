/**
 * @description       : Class for Exposure Component
 * @author            : englarmerdge.mongwe@absa.africa
 * @group             :
 * @last modified on  : 06-24-2021
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-10-26   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class ExposureController {
    private static List<Application_Exposure__c> appExposureList = new List<Application_Exposure__c>();
    private static List<Application_Exposure_Cash_and_Investment__c> cashInvList = new List<Application_Exposure_Cash_and_Investment__c>();
    private static List<Application_Profile__c> newAppProfList = new List<Application_Profile__c>();
    private static Map<String,List<Object>> mapData = new Map<String,List<Object>>();

    /**
     * @description CashAndInvestment wrapper class
    **/
    public class CashAndInvestment {
        /** @description property Id */
        @auraEnabled public Id Id { get;set; }
        /** @description property ClientName */
        @auraEnabled public String ClientName { get;set; }
        /** @description property ClientCode */
        @auraEnabled public String ClientCode { get;set; }
        /** @description property Product */
        @auraEnabled public String Product { get;set; }
        /** @description property CashAndInvestments */
        @auraEnabled public Decimal CashAndInvestments { get;set; }
        /** @description property LastRefreshDate */
        @auraEnabled public Datetime LastRefreshDate { get;set; }
        /** @description property IsFirstNameVis */
        @auraEnabled public Boolean IsFirstNameVis { get;set; }
        /** @description property IsFirstCodeVis */
        @auraEnabled public Boolean IsFirstCodeVis { get;set; }
        /** @description property IsSubTotal */
        @auraEnabled public Boolean IsSubTotal { get;set; }


        /** @description constructor */
        public CashAndInvestment() {
            Id = null;
            ClientName = null;
            ClientCode = null;
            Product = null;
            CashAndInvestments = null;
            LastRefreshDate = null;
            IsFirstNameVis = false;
            IsFirstCodeVis = false;
            IsSubTotal = false;
        }
    }

    /*@Future(callout = true)
    public static void getExposurePerClientCode(String clientCode, String clientName, Id appId) {
        List<Application_Exposure__c> appExpList = new ApplicationExposureSelector().getApplicationExposure(clientCode, appId);
        List<Application_Exposure_Cash_and_Investment__c> appCashInv = new ApplicationExposureCashInvSelector().getAppCashInvestByCientCode(clientCode, appId);

        if(appExpList.size() == 0) {
            GetExposures_Resp_IB_v1 response = getExposuresService(clientCode);

            if(response != null) {
                Application_Exposure__c appExp;
                Application_Exposure_Cash_and_Investment__c appExpCash;

                if(response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.prodDetail != null) {
                    for(GetExposures_Resp_IB_v1.ProdDetail var : response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.prodDetail) {

                        if(var.productOrTotal != '' && var.productOrTotal != 'CLIENT TOT' && var.productOrTotal != 'ORDINARY') {
                            appExp = new Application_Exposure__c();
                            appExp.Application__c = appId;
                            appExp.Client_Name__c = clientName;
                            appExp.Client_Code__c = clientCode;
                            appExp.Exposure_Data_Type__c = 'Product';
                            appExp.Product__c = var.productOrTotal;
                            appExp.Exposure__c = String.valueof(var.exposure);
                            appExp.subIndicator__c = var.subHeaderInd;

                            if(var.arrearsInd == 'A') {
                                appExp.Arrears__c = String.valueof(var.excessArrears);
                                appExp.Excess__c = '0';
                            }
                            else {
                                appExp.Excess__c = String.valueof(var.excessArrears);
                                appExp.Arrears__c = '0';
                            }

                            appExp.Installment__c = String.valueof(var.installment);
                            appExp.Liability__c = String.valueof(var.liability);
                            appExp.Limit__c = String.valueof(var.limit_Z);
                            appExposureList.add(appExp);
                        }
                        else if(var.productOrTotal == 'CLIENT TOT') {
                            appExp = new Application_Exposure__c();
                            appExp.Application__c = appId;
                            appExp.Client_Name__c = clientName;
                            appExp.Client_Code__c = clientCode;
                            appExp.Exposure_Data_Type__c = 'Client Profile Product Total';
                            appExp.Product__c = var.productOrTotal;
                            appExp.Exposure__c = String.valueof(var.exposure);
                            appExp.subIndicator__c = var.subHeaderInd;

                            if(var.arrearsInd == 'A') {
                                appExp.Arrears__c = String.valueof(var.excessArrears);
                                appExp.Excess__c = '0';
                            }
                            else {
                                appExp.Excess__c = String.valueof(var.excessArrears);
                                appExp.Arrears__c = '0';
                            }

                            appExp.Installment__c = String.valueof(var.installment);
                            appExp.Liability__c = String.valueof(var.liability);
                            appExp.Limit__c = String.valueof(var.limit_Z);
                            appExposureList.add(appExp);
                        }
                    }

                    if(appCashInv == null || appCashInv.size() == 0) {
                        GetExposures_Resp_IB_v1.GSB001O_OUTPUT_FIELDS var = response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS;

                        appExpCash = new Application_Exposure_Cash_and_Investment__c();
                        appExpCash.Application__c = appId;
                        appExpCash.Client_Name__c = clientName;
                        appExpCash.Client_Code__c = clientCode;
                        appExpCash.Pens_Back_Prepaid__c = var.pensBackPrePaid;
                        appExpCash.Participation_Bond__c = var.participationBond;
                        appExpCash.Over_Control_SIte__c = var.overControlSite;
                        appExpCash.Other_Available_Cash__c = var.otherCash ;
                        appExpCash.Notice_of_Deposits__c = var.noticeDeposits;
                        appExpCash.Mortgage_Prepaid__c = var.mortgagePrePaid;
                        appExpCash.Fleet_In_Credit__c = var.fleetInCredit;
                        appExpCash.Fleet_Cash_Advance__c = var.fleetCashAdvance;
                        appExpCash.Customer_Investment_Account__c = var.custInvestAcc;
                        appExpCash.Credit_Card__c = var.creditCard;
                        appExpCash.CPF_Prepaid__c = var.cpfPrePaid;
                        appExpCash.Term_Deposits__c = var.termDeposits;
                        appExpCash.Control_Branch__c = var.controlBranch;
                        appExpCash.Savings__c = var.savings;
                        appExpCash.AFC_In_Credit__c = var.afcInCredit;
                        appExpCash.Cheque_In_Credit__c = decimal.valueOf(var.cheqInCredit);

                        appExpCash.Client_Total__c = var.pensBackPrePaid + var.participationBond +  var.overControlSite + var.otherCash + var.noticeDeposits +
                            var.mortgagePrePaid + var.fleetInCredit + var.fleetCashAdvance + var.custInvestAcc + var.creditCard +  var.cpfPrePaid +
                            var.termDeposits + var.controlBranch + var.savings + var.afcInCredit +  decimal.valueOf(var.cheqInCredit);
                        cashInvList.add(appExpCash);
                    }
                }
            }

            if(isNotNullOrEmpty(appExposureList)) {
                saveExposures(false);
            }

            if(isNotNullOrEmpty(cashInvList)) {
                saveExposures(true);
            }
        }
    }*/

    /**
     * @description @future method to get Exposure Per ClientCode
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param clientCodesNames
     * @param appId
     * @param oppID
    **/
    @Future(callout = true)
    public static void getExposurePerClientCode(Map<String,String> clientCodesNames, Id appId, Id oppID) {
        for (String code :clientCodesNames.keyset()) {
            String clientCode = code;
            String clientName = clientCodesNames.get(code);

            List<Application_Exposure__c> appExpList = new ApplicationExposureSelector().getApplicationExposure(clientCode, appId);
            List<Application_Exposure_Cash_and_Investment__c> appCashInv = new ApplicationExposureCashInvSelector().getAppCashInvestByCientCode(clientCode, appId);

            if(appExpList.size() == 0) {
                GetExposures_Resp_IB_v1 response = getExposuresService(clientCode);

                if(response != null) {
                    Application_Exposure__c appExp;
                    Application_Exposure_Cash_and_Investment__c appExpCash;

                    if(response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.prodDetail != null) {
                        for(GetExposures_Resp_IB_v1.ProdDetail var : response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS.prodDetail) {

                            if(var.productOrTotal != '' && var.productOrTotal != 'CLIENT TOT'
                                && var.productOrTotal != 'ORDINARY' && var.productOrTotal != 'ASSET BASE'
                                && var.productOrTotal != 'MORTG FIN') {
                                appExp = new Application_Exposure__c();
                                appExp.Application__c = appId;
                                appExp.Client_Name__c = clientName;
                                appExp.Client_Code__c = clientCode;
                                appExp.Exposure_Data_Type__c = 'Product';
                                appExp.Product__c = var.productOrTotal;
                                appExp.Exposure__c = String.valueof(var.exposure);
                                appExp.subIndicator__c = var.subHeaderInd;

                                if(var.arrearsInd == 'A') {
                                    appExp.Arrears__c = String.valueof(var.excessArrears);
                                    appExp.Excess__c = '0';
                                }
                                else {
                                    appExp.Excess__c = String.valueof(var.excessArrears);
                                    appExp.Arrears__c = '0';
                                }

                                appExp.Installment__c = String.valueof(var.installment);
                                appExp.Liability__c = String.valueof(var.liability);
                                appExp.Limit__c = String.valueof(var.limit_Z);
                                appExposureList.add(appExp);
                            }
                            else if(var.productOrTotal == 'CLIENT TOT') {
                                appExp = new Application_Exposure__c();
                                appExp.Application__c = appId;
                                appExp.Client_Name__c = clientName;
                                appExp.Client_Code__c = clientCode;
                                appExp.Exposure_Data_Type__c = 'Client Profile Product Total';
                                appExp.Product__c = var.productOrTotal;
                                appExp.Exposure__c = String.valueof(var.exposure);
                                appExp.subIndicator__c = var.subHeaderInd;

                                if(var.arrearsInd == 'A') {
                                    appExp.Arrears__c = String.valueof(var.excessArrears);
                                    appExp.Excess__c = '0';
                                }
                                else {
                                    appExp.Excess__c = String.valueof(var.excessArrears);
                                    appExp.Arrears__c = '0';
                                }

                                appExp.Installment__c = String.valueof(var.installment);
                                appExp.Liability__c = String.valueof(var.liability);
                                appExp.Limit__c = String.valueof(var.limit_Z);
                                appExposureList.add(appExp);
                            }
                        }

                        if(appCashInv == null || appCashInv.size() == 0) {
                            GetExposures_Resp_IB_v1.GSB001O_OUTPUT_FIELDS var = response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS;

                            appExpCash = new Application_Exposure_Cash_and_Investment__c();
                            appExpCash.Application__c = appId;
                            appExpCash.Client_Name__c = clientName;
                            appExpCash.Client_Code__c = clientCode;
                            appExpCash.Pens_Back_Prepaid__c = var.pensBackPrePaid;
                            appExpCash.Participation_Bond__c = var.participationBond;
                            appExpCash.Over_Control_SIte__c = var.overControlSite;
                            appExpCash.Other_Available_Cash__c = var.otherCash ;
                            appExpCash.Notice_of_Deposits__c = var.noticeDeposits;
                            appExpCash.Mortgage_Prepaid__c = var.mortgagePrePaid;
                            appExpCash.Fleet_In_Credit__c = var.fleetInCredit;
                            appExpCash.Fleet_Cash_Advance__c = var.fleetCashAdvance;
                            appExpCash.Customer_Investment_Account__c = var.custInvestAcc;
                            appExpCash.Credit_Card__c = var.creditCard;
                            appExpCash.CPF_Prepaid__c = var.cpfPrePaid;
                            appExpCash.Term_Deposits__c = var.termDeposits;
                            appExpCash.Control_Branch__c = var.controlBranch;
                            appExpCash.Savings__c = var.savings;
                            appExpCash.AFC_In_Credit__c = var.afcInCredit;
                            appExpCash.Cheque_In_Credit__c = decimal.valueOf(var.cheqInCredit);

                            appExpCash.Client_Total__c = var.pensBackPrePaid + var.participationBond +  /*var.overControlSite +*/ var.otherCash + var.noticeDeposits +
                                var.mortgagePrePaid + var.fleetInCredit + var.fleetCashAdvance + var.custInvestAcc + var.creditCard +  var.cpfPrePaid +
                                var.termDeposits + /*var.controlBranch +*/ var.savings + var.afcInCredit +  decimal.valueOf(var.cheqInCredit);
                            cashInvList.add(appExpCash);
                        }
                    }
                }
            }
        }

        if(isNotNullOrEmpty(appExposureList)) {
            saveExposures(false);
        }

        if(isNotNullOrEmpty(cashInvList)) {
            saveExposures(true);
        }
    }

    /**
     * @description @future method to get and Save ExposureA ggregations
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param appId
     * @param oppID
    **/
    //@Future(callout = true)
    public static void getAndSaveExposureAggregations(Id appId, Id oppID) {
        appExposureList = new ApplicationExposureSelector().getApplicationExposureProduct(appId);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(appId);
        newAppProfList = orderedProfilesList(appProfileList, oppID);

        List<Application_Exposure__c> appExpList = new List<Application_Exposure__c>();
        String clientName = '';
        GetProductExposureAggre_Resp_IB_v1 resBean = getExposuresAggreService();

        //iterate response and save data
        if(resBean != null) {
            for(GetProductExposureAggre_Resp_IB_v1.client client : resBean.client) {

                Application_Exposure__c appExp;
                clientName = client.name;

                for(GetProductExposureAggre_Resp_IB_v1.Aggregation aggr: client?.aggregation) {
                    appExp = new Application_Exposure__c();
                    appExp.Application__c = appId;
                    appExp.Name = appId;
                    appExp.Exposure_Data_Type__c = (aggr.type_z == null ? 'Product Type Total' : aggr.type_z); //remind rob and team to bring back this field
                    appExp.Client_Name__c = clientName;
                    appExp.Liability__c = String.valueOf(aggr.liability);
                    appExp.Exposure__c = String.valueOf(aggr.exposure);
                    appExp.Limit__c = String.valueOf(aggr.limit_z);
                    appExp.Excess__c = String.valueOf(aggr.excess);
                    appExp.Arrears__c = String.valueOf(aggr.arrears);
                    appExp.Installment__c = String.valueOf(aggr.installment);
                    appExpList.add(appExp);
                }

                for(GetProductExposureAggre_Resp_IB_v1.clientProfile clientProfile : client.clientProfile) {

                    for(GetProductExposureAggre_Resp_IB_v1.aggregation aggregation : clientProfile.aggregation) {
                        appExp = new Application_Exposure__c();
                        appExp.Application__c = appId;
                        appExp.Name = appId;
                        appExp.Liability__c = String.valueOf(aggregation.liability);
                        appExp.Exposure__c = String.valueOf(aggregation.exposure);
                        appExp.Limit__c = String.valueOf(aggregation.limit_z);
                        appExp.Excess__c = String.valueOf(aggregation.excess);
                        appExp.Arrears__c = String.valueOf(aggregation.arrears);
                        appExp.Installment__c = String.valueOf(aggregation.installment);
                        appExp.Client_Code__c = clientProfile.clientCode;
                        appExp.Client_Name__c = client.name;
                        appExp.Exposure_Data_Type__c = aggregation.type_z;
                        appExpList.add(appExp);
                    }
                }
            }
        }

        try{
            insert appExpList;
        }
        catch(Exception ex) {
            throw new AuraException('Save Exposures Aggregation failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    /**
     * @description @future method to get Application Exposures Future CallQueue
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param AppProfileids
    **/
    public static void getApplicationExposuresFutureCallQueue(Set<id> AppProfileids) {
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfilesbyId(AppProfileids);
        String clientCode;
        Id appId = appProfileList[0].Application__c;
        Id oppID = appProfileList[0].Application__r.Opportunity__c;
        Map<String,String> clientCodes = new Map<String,String>();

        newAppProfList = orderedProfilesList(appProfileList, oppID);

        if(isNotNullOrEmpty(newAppProfList)) {
            Boolean grpExpDone = GroupExposuresCTRL.getInvokeGroupExposureFromServiceFuture(newAppProfList,appId);
            if(grpExpDone) {
                Integer countBatch = 0;
                for(Application_Profile__c appProfile : newAppProfList) {
                    countBatch++;
                    clientCodes.put(appProfile.Client_CIF_Code__c, appProfile.Client_Name__c);

                    if(Math.mod(countBatch,2) == 0 && appProfileList.size() > 1) {
                        getExposurePerClientCode(clientCodes,appId,oppID);
                        clientCodes.clear();
                        countBatch = 0;
                    }

                    //getExposurePerClientCode(appProfile.Client_CIF_Code__c,appProfile.Client_Name__c,appId);
                }
                if(Math.mod(countBatch,2) == 1 && appProfileList.size() > 1) {
                    getExposurePerClientCode(clientCodes,appId,oppID);
                }
            }
        }
    }

    /**
     * @description method to get Application Exposure From Service
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param oppID
    **/
    private static void getApplicationExposureFromService(Id oppID) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        Map<String,String> clientCodes = new Map<String,String>();

        newAppProfList = orderedProfilesList(appProfileList, oppID);

        if(isNotNullOrEmpty(newAppProfList)) {
            Boolean grpExpDone = GroupExposuresCTRL.getInvokeGroupExposureFromServiceFuture(newAppProfList,app.Id);
            if(grpExpDone) {
                for(Application_Profile__c appProfile : newAppProfList) {
                    //clientCodes.put(appProfile.Client_CIF_Code__c, appProfile.Client_Name__c);
                    //getExposurePerClientCode(appProfile.Client_CIF_Code__c,appProfile.Client_Name__c,app.Id);
                }
                //getExposurePerClientCode(clientCodes,app.Id,oppID);
            }
        }
    }

    /**
     * @description method to get Application Exposures Future
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param oppID
     * @return Map<String, String>
    **/
    @AuraEnabled
    public static Map<String,String> getApplicationExposuresFuture(Id oppID) {
        getApplicationExposureFromService(oppID);
        return (new Map<String,String>{'Status' => 'getApplicationExposureFromService Evoked'});
    }

    /**
     * @description method to get Application Exposures
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param oppID
     * @return Map<String, List<Object>>
    **/
    @AuraEnabled
    public static Map<String,List<Object>> getApplicationExposures(Id oppID) {
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        appExposureList = new ApplicationExposureSelector().getApplicationExposureProduct(app.Id);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        newAppProfList = orderedProfilesList(appProfileList, oppID);

        if(isNotNullOrEmpty(appExposureList)) {
            Integer clientCodeCount = getClientCodeCount(app.Id);
            Boolean allExposuresDone = false;
            List<Application_Exposure__c> appExpTotalList;

            if(clientCodeCount == newAppProfList.size()) {
                appExpTotalList = new ApplicationExposureSelector().getApplicationExposureProductTypeTotal(app.Id);

                if(!isNotNullOrEmpty(appExpTotalList)) {
                    getAndSaveExposureAggregations(app.Id,oppID);
                }
                allExposuresDone = true;
            }

            if(isNotNullOrEmpty(appExpTotalList)) {
                allExposuresDone = GroupExposuresCTRL.getAndSaveGroupExposureAggregations(oppID,app.Id);
            }

            if(allExposuresDone) {
                List<Application_Exposure__c> appExpList = new ApplicationExposureSelector().getAllApplicationExposure(app.Id);
                List<Application_Exposure_Total_Group__c> appGrpExpTotList = new ApplicationsTotalGroupSelector().getApplicationTotalGroup(app.Id,'Total Group Exposure');

                if(isNotNullOrEmpty(appExpList) && isNotNullOrEmpty(appGrpExpTotList)) {
                    mapData.put('ApplicationExposures', appExpList);
                    mapData.put('AppExpFutMethodDone', (new List<Map<String,String>>{(new Map<String,String>{'IsMethodLoaded' => 'true'})}));
                }

                PowerCurveController.setValidationFields(oppID, 'Exposure', true);
            }
        }

        return mapData;
    }

    /**
     * @description method to set Validation after PCO service call
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param oppID
    **/
    @AuraEnabled
    public static void setValidation(Id oppID) {
        PowerCurveController.setValidationFields(oppID, 'Exposure', true);
    }

    /**
     * @description method to get Cash And Investments
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param oppID
     * @return Map<String, List<Object>>
    **/
    @AuraEnabled
    public static Map<String,List<Object>> getCashAndInvestments(Id oppID) {
        Map<String,List<Object>> responseMap = new Map<String,List<Object>>();
        Application__c app = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(app.Id);
        List<Application_Profile__c> newAppProfList = orderedProfilesList(appProfileList, oppID);
        List<Application_Exposure_Cash_and_Investment__c> appExpCashInvList = new ApplicationExposureCashInvSelector().getAllApplicationExposureCashInvestByAppId(app.Id);

        List<CashAndInvestment> cashAndInvList = new List<CashAndInvestment>();
        if(appExpCashInvList != null && appExpCashInvList.size() > 0) {
            String clientName, prevIdRegNumer = null;
            CashAndInvestment cashAndInv;
            List<String> cashAndPrdList = cashAndInvestmentProduct();
            Integer countNotice = 1; Decimal SubTotal = 0.00, Total = 0.00;

            for(Application_Profile__c appProfile : newAppProfList) {
                if((prevIdRegNumer  != null) && prevIdRegNumer != appProfile.Related_to_Client_ID_or_Reg_Number__c) {
                    if(clientName != '' && cashAndInvList.size() > 0) {
                        Total = addSubTotalDetails(cashAndInv, cashAndInvList, SubTotal, Total);
                        SubTotal = 0.00;
                    }
                }
                String appType = appProfile.Applicant_Type__c;
                if(appType == 'Main Applicant') {
                    clientName = appProfile.Client_Name__c;
                    prevIdRegNumer = appProfile.Related_to_Client_ID_or_Reg_Number__c;
                }

                if(appType == 'Principal') {
                    clientName = appProfile.Client_Name__c;
                    prevIdRegNumer = appProfile.Related_to_Client_ID_or_Reg_Number__c;
                }

                for(Application_Exposure_Cash_and_Investment__c output : appExpCashInvList) {
                    if(appProfile.Client_CIF_Code__c == output.Client_Code__c) {
                        for(Integer i = 0; i < cashAndPrdList.size(); i++) {
                            cashAndInv = new CashAndInvestment();
                            cashAndInv.Id = output.Id;
                            cashAndInv.ClientName = clientName;
                            cashAndInv.ClientCode = output.Client_Code__c;
                            cashAndInv.LastRefreshDate = output.LastModifiedDate;
                            Map<String,String> mapOut = getProductAndAmount('Application_Exposure_Cash_and_Investment__c', cashAndPrdList[i], output);

                            if(mapOut != null && !mapOut.isEmpty()) {
                                cashAndInv.Product = String.valueOf(mapOut.get('Product'));
                                cashAndInv.CashAndInvestments = Decimal.valueOf(mapOut.get('Value'));
                            }
                            if(cashAndInv.Product == 'Notice of Deposits' && countNotice >= 1) {
                                countNotice++;
                                cashAndInv.IsFirstNameVis = ((appType == 'Main Applicant' || appType == 'Principal') ? true : false);
                                cashAndInv.IsFirstCodeVis = true;
                            }

                            cashAndInvList.add(cashAndInv);
                        }

                        SubTotal = SubTotal + output.Client_Total__c;
                    }
                }
            }

            Total = addSubTotalDetails(cashAndInv, cashAndInvList, SubTotal, Total);

            responseMap.put('appExposuresCashInvest', cashAndInvList);
            responseMap.put('Total', (new List<Decimal>{Total}));
        }

        return responseMap;
    }

    /**
     * @description Adding Method to Load CMS fields
     * @author Saurabh.Pandey@absa.africa | 2020-10-23
     * @param oppID
     * @return String
    **/
    @AuraEnabled
    public static String loadExposureCMSRecordID(String oppID) {
        Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(oppID);
        List<Application_Profile__c> appProfileList = new ApplicationProfileSelector().getApplicationProfiles(application.Id);
        String mainApplicantClientCode='' ;

        for(Application_Profile__c appProf : appProfileList) {
            mainApplicantClientCode = appProf.Client_CIF_Code__c;
            if(appProf.Applicant_Type__c == 'Main Applicant') {
                mainApplicantClientCode = appProf.Client_CIF_Code__c;
                break;
            }
        }

        Application_Exposure_Total_Group__c aeTGRRecord = new ApplicationsTotalGroupSelector().getCMSFields(application.Id,mainApplicantClientCode);
        //will have to put some more checks here
        if(aeTGRRecord != null) {
            return aeTGRRecord.id;
        }
        else{
            return null;
        }
    }

    /**
     * @description method to get Exposures From Service
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param clientCode
     * @return GetExposures_Resp_IB_v1
    **/
    public static GetExposures_Resp_IB_v1 getExposuresService(String clientCode) {
        if(Test.isRunningTest()) {
            GetExposures_IH_v1_Test.exposuresTestMock();
        }

        GetExposures_Resp_IB_v1 response = GetExposures_IH_v1.GetExposures(clientCode);
        if(response.statusCode == 200) {
            if(response.GSB001O.GSB001O.GSB001O_OUTPUT_FIELDS != null) {
                return response;
            }
        }

        return null;
    }

    /**
     * @description method to get Exposures Aggregation From Service
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @return GetProductExposureAggre_Resp_IB_v1
    **/
    public static GetProductExposureAggre_Resp_IB_v1 getExposuresAggreService() {
        if(Test.isRunningTest()) {
            GetProductExposureAggre_IH_v1_Test.productExpTestMock();
        }

        GetProductExposureAggre_Req_IB_v1 reqBean = GetProductExposureAggre_IU_v1.mapRequestFields(appExposureList,newAppProfList);
        GetProductExposureAggre_Resp_IB_v1 response = GetProductExposureAggre_IH_v1.getProductExposure(reqBean);

        if(response.statusCode == 200) {
            if(response.client != null) {
                return response;
            }
        }

        return null;
    }

    /**
     * @description method to ordered Profiles List
     * @author englarmerdge.mongwe@absa.africa | 2020-10-26
     * @param appProfile
     * @param oppId
     * @return List<Application_Profile__c>
    **/
    public static List<Application_Profile__c> orderedProfilesList(List<Application_Profile__c> appProfile, Id oppId) {
        Account account = new AccountsSelector().selectIndvByOpportunityIdNew(oppId);
        //String RegNo = '199001151523';
        String clientReg = (account.Registration_Number__c == null ? account.Company_Registration_Number__c : account.Registration_Number__c);
        String RegNo = (clientReg == null ? (account.Passport_Number__pc == null? account.ID_Number__pc : account.Passport_Number__pc) : clientReg);  //SIT

        List<Application_Profile__c> newAppProfList = new List<Application_Profile__c> ();
        List<Application_Profile__c> newMainAssoClientCodesList = new List<Application_Profile__c>();
        List<Application_Profile__c> newPrincipalsList = new List<Application_Profile__c>();

        for(Application_Profile__c appProf : appProfile) {

            if(appProf.Applicant_Type__c == 'Main Applicant') {
                newAppProfList.add(appProf);
            }

            if((appProf.Applicant_Type__c == 'Principal' || appProf.Applicant_Type__c == 'Spouse') && appProf.Client_CIF_Code__c != null) {
                newPrincipalsList.add(appProf);
            }

            //getAssociatedClientCodes
            if(appProf.Related_to_Client_ID_or_Reg_Number__c == RegNo && appProf.Applicant_Type__c == null && appProf.Client_CIF_Code__c != null) {
                newMainAssoClientCodesList.add(appProf);
            }
        }

        //add Associated Clients to Main Client
        for(Application_Profile__c appR:newMainAssoClientCodesList) {
            newAppProfList.add(appR);
        }

        //add Principals
        for(Application_Profile__c appPrinProf: newPrincipalsList) {
            newAppProfList.add(appPrinProf);

            //newPrinAssoClientCodesList
            for(Application_Profile__c appProf: appProfile) {
                if(appPrinProf.Related_to_Client_ID_or_Reg_Number__c == appProf.Related_to_Client_ID_or_Reg_Number__c
                    && appProf.Applicant_Type__c == null && appProf.Client_CIF_Code__c != null) {
                    newAppProfList.add(appProf);
                }
            }
        }

        return newAppProfList;
    }

    private static Integer getClientCodeCount(Id appId) {
        appExposureList = new ApplicationExposureSelector().getAllApplicationExposure(appId);
        String dataType = StringConstants.APPLICATION_EXPOSURE_EXPOSURE_DATA_TYPE_CLIENT_PROFILE_PRODUCT_TOTAL;
        Integer clientCodes = 0;
        for(Application_Exposure__c appExp : appExposureList) {
            if(appExp.Exposure_Data_Type__c == dataType) {
                clientCodes++;
            }
        }
        return clientCodes;
    }

    private static void saveExposures(Boolean isCashAndInvest) {
        try{
            if(isCashAndInvest) {
                upsert cashInvList;
            }
            else {
                upsert appExposureList;
            }
        }
        catch(Exception ex) {
            throw new AuraException('Save Exposures failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    private static Map<String,String> getProductAndAmount(String type, String product, Application_Exposure_Cash_and_Investment__c appExpCashInv) {

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        for (String fieldName: fieldMap.keySet()) {
            String label = fieldMap.get(fieldName).getDescribe().getLabel();

            if(product == label) {
                Map<String, Object> fieldsToValue = appExpCashInv.getPopulatedFieldsAsMap();
                String value = String.valueOf(fieldsToValue.get(String.valueOf(fieldMap.get(fieldName))));

                return (new Map<String,String>{'Product' => product, 'Value' => value });
            }
        }
        return null;
    }

    private static Decimal addSubTotalDetails(CashAndInvestment cashAndInv, List<CashAndInvestment> cashAndInvList, Decimal SubTotal, Decimal Total) {
        cashAndInv = new CashAndInvestment();
        cashAndInv.Product = 'SubTotal';
        cashAndInv.CashAndInvestments = SubTotal;
        cashAndInv.IsSubTotal = true;
        cashAndInvList.add(cashAndInv);
        Total = Total + SubTotal;
        return Total;
    }

    private static List<String> cashAndInvestmentProduct() {
        return (new List<String>{
                                'Notice of Deposits',
                                'Savings',
                                'Customer Investment Account',
                                'Fleet in Credit',
                                'Mortgage Prepaid',
                                'Other Available Cash',
                                /*'Over Control Site',
                                'Control Branch',*/
                                'CPF Prepaid',
                                'AFC in Credit',
                                'Term Deposits',
                                'Cheque In Credit',
                                'Credit Card',
                                'Fleet Cash Advance',
                                'Pens Back Prepaid',
                                'Participation Bond'}
        );
    }

    private static Boolean isNotNullOrEmpty(List<sObject> objList) {
        return objList != null && objList.size() > 0;
    }
}