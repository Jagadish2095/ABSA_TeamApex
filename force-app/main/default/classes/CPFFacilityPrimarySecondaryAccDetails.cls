/**
*  @description Extension Controller for CPFFeeDetails Component
* @author  Haritha P : Absa
* @version v1.0
* @since   2021-1-02
*/
public class CPFFacilityPrimarySecondaryAccDetails {

    /**
    *  @description Method to get the Application_Product_CPF__c rec.
    *  @param oppId
    *  @return Application_Product_CPF__c
    */
    @AuraEnabled
    public static Application_Product_CPF__c getAppProdctCpfRec(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    return appPrdctCpf;
    }
    /**
    *  @description Method to get all the opportunity products
    *  @param oppId
    *  @return List<OpportunityLineItem>
    */
    @AuraEnabled
    public static List<OpportunityLineItem> getprodName(Id oppId) {
    List<OpportunityLineItem> opplineitemlst =new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
    return opplineitemlst;
    }
    /**
    *  @description Method to get List<Application_Financial_Account__c>
    *  @param oppId
    *  @return List<Application_Financial_Account__c>
    */
    @AuraEnabled
    public static LIST<Application_Financial_Account__c> getAppFinAccfRec(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    LIST<Application_Financial_Account__c> appfinAccList =[Select id,Name,Application__c,Account_Number__c,Existing_Account_Number__c,Existing_Number__c,Application_Product_CPF__c,Outstanding_Balance__c,Account_to_be_closed__c,Balance_as_at__c from Application_Financial_Account__c where Application_Product_CPF__r.id=:appPrdctCpf.Id ];
    //Commenting out selector as it is giving errors in deployment by diksha
    //new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
    return appfinAccList;
    
    }
    
    /**
    *  @description Method to get update Application_Product_CPF__c
    *  @param recId
    *  @param drawdownamount
    *  @param retentionamount
    *  @param IsvatfacilityApplicable
    *  @param IsIncludeVAToncharges
    *  @param Isotheramountsincludedintotalfacility
    *  @param DifferenceclauseapplicableoptionGiven
    *  @param amountofexistingmortgage
    *  @param Remainingavailableamount
    *  @param IncludebalanceonexistingaccountoptionGiven
    *  @param FacAcclist
    *  @param accounttobeclosedoptn
    *  @param capitalinterest
    *  @return Application_Product_CPF__c
    */
    @AuraEnabled
    public static Application_Product_CPF__c updateAppPrdctcpf(Id recId,Decimal drawdownamount,Decimal retentionamount,
                                    string IsvatfacilityApplicable,Boolean IsIncludeVAToncharges,
                                    string Isotheramountsincludedintotalfacility,
                                    string DifferenceclauseapplicableoptionGiven,
                                    Decimal amountofexistingmortgage,Double Remainingavailableamount,
                                    string IncludebalanceonexistingaccountoptionGiven,
                                    List<Application_Financial_Account__c> FacAcclist,string accounttobeclosedoptn,Decimal capitalinterest
                                    ) {
                                        Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
                                        try{
                                            if(appPrdctCpf!=null){
    
                                                appPrdctCpf.Drawdown_amount__c= drawdownamount;
                                                appPrdctCpf.Retention_amount__c=retentionamount;
                                                appPrdctCpf.Amount_of_existing_register_mortgage_bon__c=amountofexistingmortgage;
                                                appPrdctCpf.Remaining_available_amount__c=Remainingavailableamount;
                                                if(IsvatfacilityApplicable =='Yes'){
                                                    appPrdctCpf.Is_VAT_facility_applicable__c='Yes';
                                                }else if(IsvatfacilityApplicable =='No'){
                                                    appPrdctCpf.Is_VAT_facility_applicable__c='No';
                                                }
                                                if(IsIncludeVAToncharges ==true){
                                                    appPrdctCpf.Include_VAT_on_charges__c='Yes';
                                                }else if(IsIncludeVAToncharges ==false){
                                                    appPrdctCpf.Include_VAT_on_charges__c='No';
                                                }
                                                if(Isotheramountsincludedintotalfacility =='Yes'){
                                                    appPrdctCpf.Other_amounts_included_in_total_facility__c='Yes';
                                                }else if(Isotheramountsincludedintotalfacility =='No'){
                                                    appPrdctCpf.Other_amounts_included_in_total_facility__c='No';
                                                }
                                                if(DifferenceclauseapplicableoptionGiven =='None'){
                                                    appPrdctCpf.Difference_clause_applicable__c='None';
                                                }else if(DifferenceclauseapplicableoptionGiven =='Standard Clause'){
    
                                                    appPrdctCpf.Difference_clause_applicable__c='Standard Clause';
                                                }else if(DifferenceclauseapplicableoptionGiven =='Payout In Tranches'){
                                                    appPrdctCpf.Difference_clause_applicable__c='Payout In Tranches';
                                                }
                                                if(IncludebalanceonexistingaccountoptionGiven =='Y'){
                                                    appPrdctCpf.Include_balance_on_existing_account__c='Yes';
                                                }else if(IncludebalanceonexistingaccountoptionGiven =='N'){
                                                    appPrdctCpf.Include_balance_on_existing_account__c='No';
                                                }
                                                appPrdctCpf.Capitalised_Interest__c=capitalinterest;
                                                update appPrdctCpf;
                                                List<Application_Financial_Account__c> dellist = new  List<Application_Financial_Account__c>();
                                                dellist = [select id,name,Application__c,Account_Number__c,Existing_Number__c,Existing_Account_Number__c,Application_Product_CPF__c,Outstanding_Balance__c,Account_to_be_closed__c,Balance_as_at__c from Application_Financial_Account__c where Application_Product_CPF__c =: appPrdctCpf.Id];
                                                //Commenting out selector as it is giving errors in deployment by diksha
                                                //new ApplicationFinancialAccountSelector().selectByAppPrdctId(appPrdctCpf.Id);
                                                if(!dellist.isEmpty()) {
                                                    delete dellist;
                                                }
                                                for(Application_Financial_Account__c finobj : FacAcclist) {
                                                    finobj.Id= null;
                                                    finobj.Application_Product_CPF__c=appPrdctCpf.Id;
                                                    if(accounttobeclosedoptn == 'Yes'){
                                                        finobj.Account_to_be_closed__c='Yes';
                                                    }else if(accounttobeclosedoptn == 'No'){
                                                        finobj.Account_to_be_closed__c='No';
                                                    }
                                                }
                                                insert FacAcclist;
                                            }
                                            return appPrdctCpf;
                                        }catch(Exception e){
                                            system.debug(e.getMessage());
                                            return null;
                                        }
                                    }
    /**
    *  @description Method to get update Application_Product_CPF__c
    *  @param recId
    *  @param secondaryaccoptionGiven
    *  @param interestratebasis
    *  @param repaymentoption
    *  @param primeratemargin
    *  @param margin
    *  @param IncluderepaymentscheduleoptionGiven
    *  @param Instalmentamount
    *  @param numberofperiodsfrstdrawn
    *  @param term
    *  @param finalrepaymentdate
    *  @param dateofFinalrepayment
    *  @param numberofPeriodsMonths
    *  @param netmargin
    *  @param allinriskmargin
    *  @param fixedrateperiod
    *  @param interestonlyperiods
    *  @param startingsteppedinstal
    *  @param escalatingper
    *  @param instalmentperiods
    *  @param Interestservicefreq
    *  @param finalinstalamt
    *  @param equalinstalments
    *  @return Application_Product_CPF__c
    */
    @AuraEnabled
    public static Application_Product_CPF__c updateFacilityRepaymentsec(Id recId,string secondaryaccoptionGiven,string interestratebasis,string repaymentoption,
                                            string primeratemargin,Decimal margin,string IncluderepaymentscheduleoptionGiven,
                                            Decimal Instalmentamount,Decimal numberofperiodsfrstdrawn,Decimal term,
                                            string finalrepaymentdate,Date dateofFinalrepayment,
                                            Decimal numberofPeriodsMonths,Decimal netmargin,
                                            Decimal allinriskmargin, Decimal fixedrateperiod,Decimal interestonlyperiods,
                                            Decimal startingsteppedinstal,Decimal escalatingper,String instalmentperiods,
                                            String Interestservicefreq,Decimal finalinstalamt,Decimal equalinstalments) {
                                                Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
    
                                                try{
                                                    if(appPrdctCpf!=null){
                                                        if(secondaryaccoptionGiven=='Y'){
                                                            appPrdctCpf.Secondary_Account_Applicable__c='Yes';
                                                        }else if(secondaryaccoptionGiven=='N'){
                                                            appPrdctCpf.Secondary_Account_Applicable__c='No';
                                                        }
                                                        if(IncluderepaymentscheduleoptionGiven=='Y'){
                                                            appPrdctCpf.Include_repayment_schedule__c='Yes';
                                                        }else if(IncluderepaymentscheduleoptionGiven=='N'){
                                                            appPrdctCpf.Include_repayment_schedule__c='No';
                                                        }
                                                        appPrdctCpf.Interest_rate_basis__c= interestratebasis;
                                                        system.debug('repaymentoptions'+repaymentoption);
                                                        appPrdctCpf.Repayment_options__c= repaymentoption;
                                                        if(primeratemargin=='Plus per annum'){
                                                            appPrdctCpf.Prime_rate_margin__c='Plus per annum';
                                                        }else if(primeratemargin=='Minus per annum'){
                                                            appPrdctCpf.Prime_rate_margin__c='Minus per annum';
                                                        }else if(primeratemargin=='NO MARGIN'){
                                                            appPrdctCpf.Prime_rate_margin__c='NO MARGIN';
                                                        }
                                                        //appPrdctCpf.Prime_rate_margin__c=primeratemargin;
                                                        appPrdctCpf.Margin__c=margin;
                                                        appPrdctCpf.Instalment_amount__c=Instalmentamount;
                                                        appPrdctCpf.Number_of_periods_after_first_drawdown__c= numberofperiodsfrstdrawn;
                                                        appPrdctCpf.Term__c=term;
                                                        if(finalrepaymentdate=='Date'){
                                                            appPrdctCpf.Final_repayment_date__c='Date';
                                                        }else if(finalrepaymentdate=='Date After First Drawdown'){
                                                            appPrdctCpf.Final_repayment_date__c='Date After First Drawdown';
                                                        }else if(finalrepaymentdate=='Date After Signature'){
                                                            appPrdctCpf.Final_repayment_date__c='Date After Signature';
                                                        }
                                                        //appPrdctCpf.Final_repayment_date__c=finalrepaymentdate;
                                                        appPrdctCpf.Date_of_final_repayment__c=dateofFinalrepayment;
                                                        appPrdctCpf.Number_of_periods_months__c=numberofPeriodsMonths;
                                                        appPrdctCpf.Net_margin__c= netmargin;
                                                        appPrdctCpf.All_in_risk_margin__c=allinriskmargin;
                                                        appPrdctCpf.Fixed_rate_period__c=fixedrateperiod;
                                                        appPrdctCpf.Interest_Only_Period__c=interestonlyperiods;
                                                        appPrdctCpf.Starting_Stepped_Instalment__c=startingsteppedinstal;
                                                        appPrdctCpf.Escalating_Perc__c=escalatingper;
                                                        appPrdctCpf.Instalment_periods__c=instalmentperiods;
                                                        appPrdctCpf.Interest_service_frequency__c=Interestservicefreq;
                                                        appPrdctCpf.Final_Instalment_Amount__c=finalinstalamt;
                                                        appPrdctCpf.Equal_Instalments__c=equalinstalments;
    
                                                        update appPrdctCpf;
                                                    }
                                                    return appPrdctCpf;
                                                }catch(Exception e){
                                                    system.debug(e.getMessage());
                                                    return null;
                                                }
                                            }
    //Added by Haritha Primary repayment requirment section 20210106
    /**
    *  @description Method to get update Application_Repayment_Account_CPF__c
    *  @param recId
    *  @param secondaryaccoption
    *  @param interestratebasis
    *  @param repaymentoption
    *  @param primeratemargin
    *  @param margin
    *  @param IncluderepaymentscheduleoptionGiven
    *  @param Instalmentamount
    *  @param numberofperiodsfrstdrawn
    *  @param term
    *  @param finalrepaymentdate
    *  @param dateofFinalrepayment
    *  @param numberofPeriodsMonths
    *  @param Repaymenttype
    *  @param netmargin
    *  @param allinriskmargin
    *  @param fixedrateperiod
    *  @param interestonlyperiods
    *  @param startingsteppedinstal
    *  @param escalatingper
    *  @param instalmentperiods
    *  @param Interestservicefreq
    *  @param finalinstalamt
    *  @param primaryequalinstalments
    *  @param appPrimaryRecId
    *  @return Application_Repayment_Account_CPF__c
    */
    @AuraEnabled
    public static Application_Repayment_Account_CPF__c insertPrimaryRepaymentsection(Id recId,string secondaryaccoption,string interestratebasis,string repaymentoption,
                                                            string primeratemargin,Decimal margin,
                                                            string IncluderepaymentscheduleoptionGiven,Decimal Instalmentamount,Decimal numberofperiodsfrstdrawn,
                                                            Decimal term,string finalrepaymentdate,Date dateofFinalrepayment,Decimal numberofPeriodsMonths,
                                                            string Repaymenttype,Decimal netmargin,
                                                            Decimal allinriskmargin, Decimal fixedrateperiod,Decimal interestonlyperiods,Decimal startingsteppedinstal,Decimal escalatingper,String instalmentperiods,
                                                            String Interestservicefreq,Decimal finalinstalamt,Decimal primaryequalinstalments,Id appPrimaryRecId) {
                                                            List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
                                                                Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
                                                                Application_Repayment_Account_CPF__c  AppRepaymentAccRec = new Application_Repayment_Account_CPF__c();
                                                                try{
                                                                    if(appPrdctCpf!=null){
    
                                                                        List<Application_Repayment_Account_CPF__c> dellist = new ApplicationRepaymentAccountCPFSelector().selectByAppPrdctIdAndType(appPrdctCpf.Id ,Repaymenttype);
                                                                        if(!dellist.isEmpty()) {
                                                                            delete dellist;
                                                                        }
                                                                        AppRepaymentAccRec.Id=null;//appPrimaryRecId;
                                                                        AppRepaymentAccRec.Application_Product_CPF__c =appPrdctCpf.Id;
                                                                        AppRepaymentAccRec.Interest_rate_basis__c=interestratebasis;
                                                                        AppRepaymentAccRec.Repayment_options__c= repaymentoption;
                                                                        AppRepaymentAccRec.Prime_rate_margin__c=primeratemargin;
                                                                        AppRepaymentAccRec.Margin__c=margin;
                                                                        AppRepaymentAccRec.Include_repayment_schedule__c=IncluderepaymentscheduleoptionGiven;
                                                                        AppRepaymentAccRec.Instalment_amount__c=Instalmentamount;
                                                                        AppRepaymentAccRec.Number_of_periods_after_first_drawdown__c=numberofperiodsfrstdrawn;
                                                                        AppRepaymentAccRec.Term__c=term;
                                                                        AppRepaymentAccRec.Final_repayment_date__c=finalrepaymentdate;
                                                                        AppRepaymentAccRec.Date_of_final_repayment__c=dateofFinalrepayment;
                                                                        AppRepaymentAccRec.Number_of_periods_months__c=numberofPeriodsMonths;
                                                                        AppRepaymentAccRec.Type__c=Repaymenttype;//'primary';
                                                                        AppRepaymentAccRec.Net_margin__c= netmargin;
                                                                        AppRepaymentAccRec.All_in_risk_margin__c=allinriskmargin;
                                                                        AppRepaymentAccRec.Fixed_rate_period__c=fixedrateperiod;
                                                                        AppRepaymentAccRec.Interest_Only_Period__c=interestonlyperiods;
                                                                        AppRepaymentAccRec.Starting_Stepped_Instalment__c=startingsteppedinstal;
                                                                        AppRepaymentAccRec.Escalating_Perc__c=escalatingper;
                                                                        AppRepaymentAccRec.Instalment_periods__c=instalmentperiods;
                                                                        AppRepaymentAccRec.Interest_service_frequency__c=Interestservicefreq;
                                                                        AppRepaymentAccRec.Final_Instalment_Amount__c=finalinstalamt;
                                                                        AppRepaymentAccRec.Equal_Instalments__c=primaryequalinstalments;
    
                                                                    }
                                                                    insert AppRepaymentAccRec;
 
                                                                   // upsert AppRepaymentAccRec;
                                                                    if(secondaryaccoption=='Y')
                                                                        appPrdctCpf.Secondary_Account_Applicable__c='Yes';
                                                                    update appPrdctCpf;
                                                                    return AppRepaymentAccRec;
                                                                }catch(Exception e){
                                                                    system.debug(e.getMessage());
                                                                    return null;
                                                                }
                                                            }
    //Added by Diksha Primary repayment requirment section 20210106
    /**
    *  @description Method to get update Application_Repayment_Account_CPF__c
    *  @param recId
    *  @param secondaryAcctRepaymentlst
    *  @param isPrimary
    *  @param secondaryaccoptionGiven
    *  @return list<Application_Repayment_Account_CPF__c>
    */
    @AuraEnabled
    public static list<Application_Repayment_Account_CPF__c> InsertNewSecondaryAcctRepayementRecCpf(Id recId,List<Application_Repayment_Account_CPF__c> secondaryAcctRepaymentlst, boolean isPrimary ,string secondaryaccoptionGiven) {
    
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(recId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    try{
    if(appPrdctCpf!=null){
    List<Application_Repayment_Account_CPF__c> dellist = new ApplicationRepaymentAccountCPFSelector().selectByAppPrdctIdAndType(appPrdctCpf.Id ,'secondary');
    if(!dellist.isEmpty()) {
    delete dellist;
    }
    for(Application_Repayment_Account_CPF__c secondaryAcctRepayment : secondaryAcctRepaymentlst) {
    secondaryAcctRepayment.Id= null;
    secondaryAcctRepayment.Application_Product_CPF__c=appPrdctCpf.Id;
    if(isPrimary == false){
    secondaryAcctRepayment.Type__c='secondary';
    }
    }
    insert secondaryAcctRepaymentlst;
    if(secondaryaccoptionGiven=='Y')
    appPrdctCpf.Secondary_Account_Applicable__c='Yes';
    update appPrdctCpf;
    
    }
    return secondaryAcctRepaymentlst;
    }catch(Exception e){
    throw new AuraHandledException('Application Secondary Account Repayment Record not inserted'+e.getMessage());
    }
    }
    /**
    *  @description Method to get Application_Repayment_Account_CPF__c list
    *  @param oppId
    *  @return LIST<Application_Repayment_Account_CPF__c>
    *  Added by Diksha Primary repayment requirment section 20210106
    */
    @AuraEnabled
    public static LIST<Application_Repayment_Account_CPF__c> getSecondaryAcctRepaymentRec(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    LIST<Application_Repayment_Account_CPF__c> secondaryAcctRepaymentList = new ApplicationRepaymentAccountCPFSelector().selectByAppPrdctIdAndType(appPrdctCpf.Id ,'secondary');
    return secondaryAcctRepaymentList;
    
    }
    /**
    *  @description Method to get Application_Repayment_Account_CPF__c rec.
    *  @param oppId
    *  @return Application_Repayment_Account_CPF__c
    *  Added by Haritha Primary repayment requirment section 20210106
    */
    @AuraEnabled
    public static Application_Repayment_Account_CPF__c getPrimaryAcctRepaymentRec(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    LIST<Application_Repayment_Account_CPF__c> primaryAcctRepaymentList = new ApplicationRepaymentAccountCPFSelector().selectByAppPrdctIdAndType(appPrdctCpf.Id ,'primary');
    if(primaryAcctRepaymentList.size() > 0){
    return primaryAcctRepaymentList[0];
    }else{
    return null;
    }
    
    }
    
    /**
    *  @description Method to dummyRefresh.
    */
    @AuraEnabled
    public static void dummyRefresh() {
    //this is a dummy refresh
    }
    /**
    *  @description Method to get Application__c rec.
    *  @param oppId
    *  @return Application__c
    */
    @AuraEnabled
    public static Application__c getApplicationRec(Id oppId) {
    List<Application__c> applst= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application__c app= new ApplicationsSelector().selectById(applst[0].Id);
    return applst[0];
    }
    
    /**
    *  @description Method to get update Application__c
    *  @param oppId
    *  @param recId
    *  @param Parent
    *  @param Istheparentalsoaguarantor
    *  @param parentName
    *  @param regincorporationnumb
    *  @param numberOfBorrowerSignatureRequired
    *  @param numberOfDaysForBorrowerToAcceptOf
    *  @param changeOfControlParty
    *  @return Application__c
    */
    @AuraEnabled
    public static Application__c updateBorrowerInfo(Id oppId,Id recId,string Parent,string Istheparentalsoaguarantor,string parentName,string regincorporationnumb,decimal numberOfBorrowerSignatureRequired,string numberOfDaysForBorrowerToAcceptOf,string changeOfControlParty) {
    Application__c app= new ApplicationsSelector().selectById(recId);
    try{
    app.Id=recId;
    app.Parent__c=Parent;
    app.Is_the_parent_also_a_guarantor__c=Istheparentalsoaguarantor;
    app.Name__c=parentName;
    app.Registration_incorporation_numb__c=regincorporationnumb;
    app.Required_numof_signatories_to_give_instr__c=numberOfBorrowerSignatureRequired;
    app.Number_of_days_for_Borrower_to_accept_of__c=numberOfDaysForBorrowerToAcceptOf;
    app.Change_of_control_party__c=changeOfControlParty;
    update app;
    return app;
    }
    catch(Exception e){
    throw new AuraHandledException('Application Record not updated'+e.getMessage());
    }
    }
    /**
    *  @description Method to insert List<Application_Fees__c> with Facility Type.
    *  @param recId
    *  @param otherfeesdetaillist
    *  @return List<Application_Fees__c>
    */
    @AuraEnabled
    public static List<Application_Fees__c> OtherFeesDetailUpdate(Id recId,List<Application_Fees__c> otherfeesdetaillist) {
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectById(recId);
    try{
    if(appPrdctCpf!=null){
    List<Application_Fees__c> dellist = new  List<Application_Fees__c>();
    dellist = new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,'Facility');
    // dellist = [select id,name,Fees_description__c,Application_Product_CPF__c,Fees_value__c from Application_Fees__c where Application_Product_CPF__c =: appPrdctCpf.Id AND Type__c='Facility' ORDER BY Name ASC];
    if(!dellist.isEmpty() && !dellist.isEmpty() && dellist.size()>0) {
    delete dellist;
    }
    for(Application_Fees__c otherfeesobj : otherfeesdetaillist) {
    otherfeesobj.Id= null;
    otherfeesobj.Application_Product_CPF__c=appPrdctCpf.Id;
    otherfeesobj.Type__c='Facility';
    }
    insert otherfeesdetaillist;
    
    }
    return otherfeesdetaillist;
    }catch(Exception e){
    system.debug(e.getMessage());
    return null;
    }
    }
    /**
    *  @description Method to get List<Application_Fees__c> with Facility Type.
    *  @param oppId
    *  @return List<Application_Fees__c>
    */
    @AuraEnabled
    public static List<Application_Fees__c> getApplicationFeesRec(Id oppId) {
    List<Application__c> app= new ApplicationsSelector().selectByOpportunityId(oppId);
    Application_Product_CPF__c appPrdctCpf= new ApplicationProductCPFSelector().selectByAppId(app[0].Id);
    List<Application_Fees__c> AppFeeslist = new ApplicationFeesSelector().selectByAppFeeswithtype(appPrdctCpf.Id,'Facility');
    return AppFeeslist;
    }
    }