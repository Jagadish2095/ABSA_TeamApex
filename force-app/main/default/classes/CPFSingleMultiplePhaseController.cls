/**
* @description Controller for CPFSingleMultiplePhaseSection Component
* @author  Diksha Wasekar
* @version v1.0
* @since   2021-04-20
*/
public class CPFSingleMultiplePhaseController{
    /**
* @description Method to get Application_Product_CPF__c rec
* @param oppId
* @return Application_Product_CPF__c
*/
    @AuraEnabled
    public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        return appPrdctCpf;
    }
    
    /**
* @description Method to udpate Application_Product_CPF__c rec
* @param oppId
* @param multiplephaseapplicable
* @return Application_Product_CPF__c
*/
    @AuraEnabled
    public static Application_Product_CPF__c updateAppPrdctcpf(Id oppId, string multiplephaseapplicable){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        try{
            if (appPrdctCpf != null){
                appPrdctCpf.Multiple_phases_applicable__c = multiplephaseapplicable;
                appPrdctCpf.id = appPrdctCpf.Id;
            }
            update appPrdctCpf;
            if (multiplephaseapplicable == 'No'){
                List<Application_Phase_CPF__c> dellistPhaselst =new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(appPrdctCpf.Id ,'Multiple Phase');
                if (!dellistPhaselst.isEmpty() && !dellistPhaselst.isEmpty() && dellistPhaselst.size() > 0){
                    delete dellistPhaselst;
                }
            } else{
                List<Application_Phase_CPF__c> dellistPhaselst =new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(appPrdctCpf.Id ,'Single Phase');
                if (!dellistPhaselst.isEmpty() && !dellistPhaselst.isEmpty() && dellistPhaselst.size() > 0){
                    delete dellistPhaselst;
                }
            }
            
            return appPrdctCpf;
        }  catch(Exception e){
            System.debug('Exception Occured' + e.getMessage() + 'At Line number' + e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }

    }
    
    /**
* @description Method to udpate Application_Product_CPF__c rec
* @param oppId
* @param earlytermfees
* @param latebondreg
* @param cancellationacceptclause
* @param breakagecost
* @return Application_Product_CPF__c
*/
    @AuraEnabled
    public static Application_Product_CPF__c updateAppPrdctcpfPhase(Id oppId, Decimal earlytermfees, string latebondreg, string cancellationacceptclause, string breakagecost){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        try{
            if (appPrdctCpf != null){
                appPrdctCpf.id = appPrdctCpf.Id;
                appPrdctCpf.Early_termination_fee_during_development__c = earlytermfees;
                appPrdctCpf.Late_bond_registration_penalty__c = latebondreg;
                appPrdctCpf.Cancellation_after_acceptance_clause__c = cancellationacceptclause;
                appPrdctCpf.Are_breakage_costs_applicable__c = breakagecost;
            }
            update appPrdctCpf;
            return appPrdctCpf;
        } catch (Exception e){
            system.debug(e.getMessage());
            return null;
        }
    }
    
    /**
* @description Method to get LIST<Application_Financial_Account__c>
* @param oppId
* @param multiplephaseapplicable
* @return LIST<Application_Financial_Account__c>
*/
    @AuraEnabled
    public static LIST<Application_Financial_Account__c> getAppFinAccfRec(Id oppId, string multiplephaseapplicable){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        LIST<Application_Financial_Account__c> appfinAccList = [Select id, Name, Application__c, Account_Number__c, Existing_Account_Number__c, Existing_Number__c, Application_Product_CPF__c, Outstanding_Balance__c, Account_to_be_closed__c, Balance_as_at__c, Phase_Number__c
                                                                from Application_Financial_Account__c
                                                                where Application_Product_CPF__r.id = :appPrdctCpf.Id and Application_Product_CPF__r.Multiple_phases_applicable__c = :multiplephaseapplicable];
        
        //Commenting out selector as it is giving errors in deployment by diksha
        //new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
        return appfinAccList;
    }
    
    
    /**
* @description Method to get list of Application_Phase_CPF__c
* @param oppId
* @param Type
* @return List<Application_Phase_CPF__c>
*/
    @AuraEnabled
    public static List<Application_Phase_CPF__c> getApphaseCpfRec(Id oppId, string Type){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        List<Application_Phase_CPF__c> appPhaseRecLst = new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(appPrdctCpf.Id, Type);
        //[select id, name,Drawdown_amount__c,Retention_amount__c,Other_amounts_included_in_total_facility__c from Application_Phase_CPF__c where Application_Product_CPF__c=:appPrdctCpf.Id and Type__c='Multiple Phase' ];
        return appPhaseRecLst;
    }
    
    /**
* @description Method to get list of Application_Fees__c
* @param oppId
* @param Type
* @param multiplephaseapplicable
* @return List<Application_Fees__c>
*/
    @AuraEnabled
    public static List<Application_Fees__c> getApplicationFeesRec(Id oppId, string Type, string multiplephaseapplicable){
        List<Application__c> app = new ApplicationsSelector().selectByOpportunityId(oppId);
        Application_Product_CPF__c appPrdctCpf = new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
        List<Application_Fees__c> AppFeeslist =new ApplicationFeesSelector().selectByAppFeeswithtypeandmultiplephaseapplicable(appPrdctCpf.Id,Type,multiplephaseapplicable);
        //new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,Type);
        return AppFeeslist;
    }
    
    /**
* @description Method to insert Application_Phase_CPF__c with type single
* @param appProductCpfId
* @param multiplephaseapplicable
* @param appPhaseCpfRecSingleId
* @param objData
* @param FacAcclist
* @param otherfeesdetaillist
* @param otherfeeslst
* @return Application_Phase_CPF__c
*/
    @AuraEnabled
    public static Application_Phase_CPF__c insertSinglePhaseCPFRec(Id appProductCpfId, string multiplephaseapplicable, Id appPhaseCpfRecSingleId, String objData, List<Application_Financial_Account__c> FacAcclist, List<Application_Fees__c> otherfeesdetaillist, List<Application_Fees__c> otherfeeslst){
        try{
        Application_Phase_CPF__c appPhaseRec = new Application_Phase_CPF__c();
        appPhasecpf responseBean = new appPhasecpf();
        responseBean = (appPhasecpf)JSON.deserialize(objData, appPhasecpf.class);
        if (appProductCpfId != null){
            
            appPhaseRec.Id = appPhaseCpfRecSingleId;
            appPhaseRec.Drawdown_amount__c = responseBean.drawdownamtsingle;
            appPhaseRec.Retention_amount__c = responseBean.retentionamtsingle;
            appPhaseRec.Include_balance_on_existing_account__c = responseBean.balexistingacctsingle;
            appPhaseRec.Include_VAT_on_charges__c = responseBean.vatonchargessingle;
            appPhaseRec.Other_amounts_included_in_total_facility__c = responseBean.otheramountsincludedintotalfacilitysingle;
            appPhaseRec.Type__c = 'Single Phase';
            appPhaseRec.Application_Product_CPF__c = appProductCpfId;
            appPhaseRec.Drawdown_amount__c = responseBean.drawdownamtsingle;
            appPhaseRec.Final_repayment_date__c = responseBean.finalrepaymentdatesingle;
            appPhaseRec.Date_of_final_repayment__c = responseBean.dateofFinalrepaymentsingle;
            appPhaseRec.Number_of_periods_months__c = responseBean.numberofPeriodsMonthssingle;
            appPhaseRec.Interest_rate_basis__c = responseBean.interestratebasissingle;
            appPhaseRec.Net_margin__c = responseBean.netmarginsingle;
            appPhaseRec.All_in_risk_margin__c = responseBean.allinriskmarginsingle;
            appPhaseRec.Fixed_rate_period__c = responseBean.fixedrateperiodsingle;
            appPhaseRec.Prime_rate_margin__c = responseBean.primeratemarginsingle;
            appPhaseRec.Margin__c = responseBean.marginsingle;
            appPhaseRec.Repayment_options_during_development__c = responseBean.repaymentoptionssingle;
            appPhaseRec.Interest_service_frequency__c = responseBean.interestservicefreqsingle;
            appPhaseRec.Final_instalment_amount__c = responseBean.finalinstalmentamtsingle;
            appPhaseRec.Interest_only_period__c = responseBean.interestonlyperiodsingle;
            appPhaseRec.Free_flow_option__c = responseBean.freeflowoptionsingle;
            appPhaseRec.Practical_Completion_Date__c = responseBean.practicaldatesingle;
            appPhaseRec.Development_period_months__c = responseBean.devperiodmnthssingle;
            appPhaseRec.Cancellation_fee_payable__c = string.valueOf(responseBean.cancellationfeessingle);
            appPhaseRec.Admin_fee__c = responseBean.AdminFeesingle;
            appPhaseRec.Admin_fee_amount__c = responseBean.adminAmtsingle;
            appPhaseRec.Payable__c = responseBean.payablesingle;
            appPhaseRec.Include_admin_fee_in_total_facility__c = responseBean.IncludeAminTotFacilitysingle;
            appPhaseRec.Account_type__c = responseBean.accTypesingle;
            appPhaseRec.Restructure_fee__c = string.valueOf(responseBean.restruFeesingle);
            appPhaseRec.Commitment_fee__c = string.valueOf(responseBean.commFeesingle);
            appPhaseRec.Valuation_fee__c = responseBean.ValuationFeesingle;
            appPhaseRec.Valuation_fee_amount__c = responseBean.ValfeeAmtsingle;
            appPhaseRec.Include_admin_fee_in_total_facility2__c = responseBean.IncludeAminTotFacility2single;
            appPhaseRec.Prepayment_fee__c = responseBean.PrePaymentFeesingle;
            appPhaseRec.Early_prepayment_fee_year_1__c = responseBean.earlyPrepFeeYr1single;
            appPhaseRec.Early_prepayment_fee_year_2__c = responseBean.earlyPrepFeeYr2single;
            appPhaseRec.Early_prepayment_fee_year_3__c = responseBean.earlyPrepFeeYr3single;
            appPhaseRec.Other_fees_applicable__c = responseBean.otherfeesapplicablevalfeesingle;
            appPhaseRec.Drawdown_inspection_fee__c = responseBean.drawdowninspectionfeesingle;
            appPhaseRec.Drawdown_inspection_fee_cur__c = responseBean.drawdowninspfeesingle;
            appPhaseRec.Capital_Repayments__c = responseBean.captialrepaysingle;
            appPhaseRec.Capitalised_Interest__c = responseBean.capitalinterestsingle;
            
            List<Application_Financial_Account__c> dellistappFinAct = new List<Application_Financial_Account__c>();
            dellistappFinAct = [select id, name, Application__c, Account_Number__c, Existing_Number__c, Existing_Account_Number__c, Application_Product_CPF__c, Outstanding_Balance__c, Account_to_be_closed__c, Balance_as_at__c
                                from Application_Financial_Account__c
                                where Application_Product_CPF__c = :appProductCpfId and Application_Product_CPF__r.Multiple_phases_applicable__c = :multiplephaseapplicable];
            //Commenting out selector as it is giving errors in deployment by diksha
            //new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
            if (!dellistappFinAct.isEmpty()){
                delete dellistappFinAct;
            }
            for (Application_Financial_Account__c finobj : FacAcclist){
                finobj.Id = null;
                finobj.Application_Product_CPF__c = appProductCpfId;
            }
            insert FacAcclist;
            
            List<Application_Fees__c> dellist = new List<Application_Fees__c>();
            dellist = new ApplicationFeesSelector().selectByAppFeeswithtypeandmultiplephaseapplicable(appProductCpfId,'Facility',multiplephaseapplicable);
            //dellist = [select id, name, Fees_description__c, Application_Product_CPF__c, Fees_value__c from Application_Fees__c where Application_Product_CPF__c = :appProductCpfId AND Type__c = 'Facility' And Application_Product_CPF__r.Multiple_phases_applicable__c = :multiplephaseapplicable];
            if (!dellist.isEmpty() && !dellist.isEmpty() && dellist.size() > 0){
                delete dellist;
            }
            for (Application_Fees__c otherfeesobj : otherfeesdetaillist){
                otherfeesobj.Id = null;
                otherfeesobj.Application_Product_CPF__c = appProductCpfId;
                otherfeesobj.Type__c = 'Facility';
            }
            insert otherfeesdetaillist;
            
            List<Application_Fees__c> dellistotherfees = new List<Application_Fees__c>();
            dellistotherfees = new ApplicationFeesSelector().selectByAppFeeswithtypeandmultiplephaseapplicable(appProductCpfId,'Fees Details',multiplephaseapplicable);
            // dellistotherfees = [select id, name, Fees_description__c, Application_Product_CPF__c, Fees_value__c from Application_Fees__c where Application_Product_CPF__c = :appProductCpfId AND Type__c = 'Fees Details' And Application_Product_CPF__r.Multiple_phases_applicable__c = :multiplephaseapplicable];
            if (!dellistotherfees.isEmpty() && !dellistotherfees.isEmpty() && dellistotherfees.size() > 0){
                delete dellistotherfees;
            }
            for (Application_Fees__c otherfeesobj : otherfeeslst){
                otherfeesobj.Id = null;
                otherfeesobj.Application_Product_CPF__c = appProductCpfId;
                otherfeesobj.Type__c = 'Fees Details';
            }
            insert otherfeeslst;
        }
        upsert appPhaseRec;
        return appPhaseRec;
        }
        catch(Exception e){
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
    }
    
    /**
* @description Method to insert Application_Phase_CPF__c with type multiple
* @param appProductCpfId
* @param multiplephaseapplicable
* @param MultiplePhaselist
* @return List<Application_Phase_CPF__c>
*/
    @AuraEnabled
    public static List<Application_Phase_CPF__c> insertMultiplePhaseCPFRec(Id appProductCpfId, string multiplephaseapplicable, List<Application_Phase_CPF__c> MultiplePhaselist){
        try{
        Application_Phase_CPF__c appPhaseRec = new Application_Phase_CPF__c();
        List<Application_Phase_CPF__c> dellistPhaselst =new ApplicationPhasesCPFSelector().selectByAppPhasewithtype(appProductCpfId ,'Multiple Phase');
        if (!dellistPhaselst.isEmpty() && !dellistPhaselst.isEmpty() && dellistPhaselst.size() > 0){
            delete dellistPhaselst;
        }
        
        for (Application_Phase_CPF__c multiPhaseobj : MultiplePhaselist){
            multiPhaseobj.Id = null;
            multiPhaseobj.Application_Product_CPF__c = appProductCpfId;
            multiPhaseobj.Type__c = 'Multiple Phase';
            
        }
        insert MultiplePhaselist;
        return MultiplePhaselist;
        }
        catch(Exception e){
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
    }
    
    /**
    * @description 
    * @author  | 2021-08-04 
    * @param appFinRectoDel 
    **/
    @AuraEnabled
    public static void delAppFinRec(Id appFinRectoDel){
        List<Application_Financial_Account__c> dellistappFinAct = new List<Application_Financial_Account__c>();
        dellistappFinAct = [select Id, name, Application__c, Account_Number__c, Existing_Number__c, Existing_Account_Number__c, Application_Product_CPF__c, Outstanding_Balance__c, Account_to_be_closed__c, Balance_as_at__c, Phase_Number__c
                            from Application_Financial_Account__c
                            where Id=:appFinRectoDel];
        if (!dellistappFinAct.isEmpty() && !dellistappFinAct.isEmpty() && dellistappFinAct.size() > 0){
            delete dellistappFinAct;
        }
    }
    
    /**
    * @description 
    * @author  | 2021-08-04 
    * @param appOtherFeesId 
    **/
    @AuraEnabled
    public static void delAppFeesRec(Id appOtherFeesId){
        
        List<Application_Fees__c> dellistotherfees = new List<Application_Fees__c>();
        dellistotherfees = [select Id, name, Fees_description__c, Application_Product_CPF__c, Fees_value__c
                            from Application_Fees__c
                            where Id=:appOtherFeesId];
        if (!dellistotherfees.isEmpty() && !dellistotherfees.isEmpty() && dellistotherfees.size() > 0){
            delete dellistotherfees;
        }
    }
    
    
    /**
* @description 1st wrapper to save Phase with AppproductcpfId.
*
*/
    public class wrapAppCPFRecWrap2lst{
        @auraEnabled
        /**
* @description appProdCPFobj
*/
        public Application_Product_CPF__c appProdCPFobj{ get; set; }
        
        @auraEnabled
        /**
* @description wrapper2lst
*/
        public List<wrapPhaseRecFaciFeeslst> wrapper2lst{ get; set; }
        
        @auraEnabled
        /**
* @description newMultiplePhase
*/
        public List<Application_Phase_CPF__c> newMultiplePhase{ get; set; }
        
        @auraEnabled
        /**
* @description newMultiplePhase
*/
        public Application_Phase_CPF__c accItem{ get; set; }
    }
    
    /**
* @description 2nd wrapper to save AppFaci Acct and Fees Recs with single Phase Rec.
*
*/
    public class wrapPhaseRecFaciFeeslst{
        @auraEnabled
        /**
* @description accItem
*/
        public Application_Phase_CPF__c accItem{ get; set; }
        
        @auraEnabled
        /**
* @description newFacilityAccountMulti
*/
        public List<Application_Financial_Account__c> newFacilityAccountMulti{ get; set; }
        
        @auraEnabled
        /**
* @description newFeesOtherFaciMulti
*/
        public List<Application_Fees__c> newFeesOtherFaciMulti{ get; set; }
        
        @auraEnabled
        /**
* @description newFeesOtherFeesMulti
*/
        public List<Application_Fees__c> newFeesOtherFeesMulti{ get; set; }
    }
    
    /**
*  @description Wrapper Class To Map the response from field values
*/
    public class appPhasecpf{
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String vatonchargessingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String balexistingacctsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String otheramountsincludedintotalfacilitysingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String repaymentoptionssingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal drawdownamtsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal retentionamtsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String interestratebasissingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String primeratemarginsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal marginsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String interestonlyperiodsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal finalinstalmentamtsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String freeflowoptionsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String interestservicefreqsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String finalrepaymentdatesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Date dateofFinalrepaymentsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal numberofPeriodsMonthssingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal netmarginsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal allinriskmarginsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal fixedrateperiodsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Date practicaldatesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal devperiodmnthssingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal cancellationfeessingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String AdminFeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal adminAmtsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String payablesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String IncludeAminTotFacilitysingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String accTypesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal restruFeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal commFeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String ValuationFeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal ValfeeAmtsingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String IncludeAminTotFacility2single{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String PrePaymentFeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal earlyPrepFeeYr1single{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal earlyPrepFeeYr2single{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal earlyPrepFeeYr3single{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String otherfeesapplicablevalfeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public String drawdowninspectionfeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal drawdowninspfeesingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal captialrepaysingle{ get; set; }
        
        /**
*  @description Wrapper Class fields to Map to Application Phase obj
*/
        @auraEnabled
        public Decimal capitalinterestsingle{ get; set; }
    }
}