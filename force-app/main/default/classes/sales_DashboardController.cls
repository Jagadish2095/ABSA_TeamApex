public class sales_DashboardController{
    
    public class DataObj{
        
        public String country_of_birth; 
        public String nationality;
        public String marital_status;
        public String id_type;
        public String customer_type;
        public Date id_date_issued;
        public String gender;
        public Date date_of_birth;
        public String home_language;
        public String full_name;
        public String contact_number;
        public String social_grant;
        public String does_client_havepostmatric_qualification;
        public String post_matric_qualification;
        //
        public String marital_contract; 
        public integer dependents; 
        public String relationship; 
        public String communication_language; 
        public boolean insolvent; 
        public String debt_counseling; 
        public date fica_date_identified;
        public boolean verify_client; 
        public String title; 
        public String residential_address;
        public date current_address_since;
        public String residential_address_country;
        public String residential_status;
        public double outstanding_bond;
        public double realistic_market_value;
        public String section_129_notice_delivery_address;
        public String postal_address_line_1_3;
        public String town_city_foreign_country;
        public String postal_code;
        public String work_telephone_number;
        public String home_telephone_number;
        public String work_fax_number;
        public String home_fax_number;
        public String cellphone_number;
        public String email_address;
        public String preffered_communication_channel;
        public boolean credit_worthiness;
        public boolean absa_group_electronic;
        public String email;
        public String sms;
        public String occupational_status;
        public String employment_sector;
        public String occupation;
        public String occupation_code;
        public String occupation_level;
        public double monthly_income;
        public String source_of_income;
        public integer frequency_of_income;
        public date current_employment_since;
        public boolean client_banks_with_absa;
        public String employers_name;
        public String empl_postal_address_line_1_3;
        public String empl_town_city_foreign_country;
        public String empl_postal_code;
        public boolean client_registed_for_income_tax;
        public String sa_income_tax_number;
        public String reason_sa_income_tax_number_not_given;
        public boolean client_registered_for_foreign_income_tax;
        public String foreign_income_tax_number;
        public String reason_foreign_income_tax_num_not_given;
        public boolean i_accept_terms_and_conditions;
        public String application_number;
        public String purpose_of_loan;
        public String other;
        public String race_indicator;
        public integer number_of_payments;
        public String initiation_fee_payment_method;
        public double additional_loan_amount;
        public double settlement_other_products;
        public double total_amount;
        public String payment_type;
        public integer payment_frequency;
        public boolean absa_credit_life;
        public double groceries;
        public double domestic_garderner_worker_etc;
        public double telephone_cellphone;
        public double education_school_loan_repayment;
        public double transport_petrol_excl_vehicle_finance;
        public double insurance_and_funeral_policies;
        public double security;
        public double rental;
        public double maintenance;
        public double entertainment;
        public String specify_other_expenses;
        public double amount;
        public double necessary_expenses;
        public double gross_income;
        public double salary_deductions;
        public double net_salary_income_month_1;
        public double net_salary_income_month_2;
        public double net_salary_income_month_3;
        public double salary_deducted_fixed_debit;
        public double other_additional_income;
        public double total_net_monthly_income;
        public double bond_mortgage;
        public double loan_overdraft;
        public double credit_cards;
        public double asset_and_finance_repayment;
        public double retail_accounts;
        public double other_debt_repayment;
        public double total_dept_repayment;
        public double total_monthly_expenses;
        public double surplus_shortage;
        public double municipal_levies_rates_taxes_water_light;
        public double rental_income;
        public String casa_reference;
        
        public double final_loan_amount;
        public String final_decision;
        public String reason;
        public date first_payment_date;
        public boolean request_a_quote_to_be_issued;
        public String id_number;
        public String appl;
        
        public date id_type_date_issued;
        public String casa;
        public String csa_number;
        public String user;        
    
    }
    
    /*******************************************************************************************************************/    
	/* @author: Joshua */
    @AuraEnabled 
    public static String loadStaticResource(){   
        
        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = 'sales_Utilities' LIMIT 1];
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            //If has NamespacePrefix
            prefix += '__';
        }
        //Get the path of Utilities.js file in Zip static resource
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + 'sales_Utilities/Utilities.js'; 
        PageReference pg = new PageReference( srPath );
        String body = pg.getContent().toString();
        
        
        return body;
    } 

    /*******************************************************************************************************************/    
	/* @author: MK 1st service */
    @AuraEnabled 
    public static ResponseObj ciGetClientDetailsByIDNumber(String IdNumber,String clientData){   
        
        List<Sales_Client_Profile__c> retObj = sales_DashboardController.getClientDetailsSOQl(IdNumber);
        
        Object client;
        if(retObj.size() > 0){
            client= (Object)retObj;
        }else{
            List<Sales_Client_Profile__c> scp = new List<Sales_Client_Profile__c>();
            client= (Object)scp;
        }
                                     
        //String clientData1 = '{"NBSAPDPI": {"NBSAPLI": {"consumerChannel": "SALESFORCE","providerApplication": "DIVE","trace": ""}},"NBSMSGI": {"NBSMSGI": {"messageLanguage": "E","messageTarget": "STD"}},"inputCopybookClssidi": {"inputDetails": {"idNumber": "'+IdNumber+'","idDocumentType": 0,"cifClientGroup": "I","cifClientType": 0,"maxRecordsToRetrieve": 15,"restartSearchPosition": "","siteCode": 8196}}}';
        ResponseObj res = sales_DashboardController.CommonAPICallout('cigetclientdetailsbyidnov20api/CIgetClientDetailsByIDNOV20','POST', clientData,'DataPowerCIF'); 
		 
        if(res.IsSuccess){
            DataMap dm = (DataMap)res.Data;	
            dm.dataMap.put('sfResp', client);            
            return new ResponseObj(dm);    
        }else{
             return res;     
        }
    }          
     
    /* @author : Joshua 2nd service */
    @AuraEnabled 
    public static ResponseObj ciGetClientInfo(String clientData){
		 return sales_DashboardController.CommonAPICallout('cigetclientdetailsv20api/CIgetClientDetailsV20','POST', clientData,'DataPowerCIF');         
    }                 
    
	/* @author Joshua 3rd service a*/
    @AuraEnabled
    public static ResponseObj wqcasascreenprimaryclient(String clientData) {
        string clientData1 = '{"channel":"SALESFORCE","application":"DIVE","trace":"Y","firstName":"SHAUN","surnameComp":"ABSA TEST","idType":"1","idRegNo":"8506058128180","clientTypeGrp":"I","dob":"19850605","nationality":"SOU01","town":"","territory":"","cntryOfRes":"SO003","cntryOfBirth":"SO003","registerCity":"","countryPassport":"","headofficeTown":"","headofficeCntry":"","headofficeOtherCntry1":"","headofficeOtherCntry2":"","headofficeOtherCntry3":"","headofficeOtherCntry4":"","headofficeOtherCntry5":"","sbu":"61","originatingSys":"SALESFORCE","branch":"004927","teller":"ABRB745"}';
		return sales_DashboardController.CommonAPICallout('wqcasascreenprimaryclientv7','POST', clientData1, 'Jitterbit');         
    }   
    
	/* @author Rakesh 4th service*/
    @AuraEnabled 
    public static ResponseObj wqriskprofileclientv7(String clientData) {        
        return sales_DashboardController.CommonAPICallout('wqriskprofileclientv7','POST', clientData, 'Jitterbit');                   
    }
    
    /* @author Rakesh 5th service*/
     @AuraEnabled 
    public static ResponseObj wqgetcasadocumentsbyrefnov1(String clientData){
         return sales_DashboardController.CommonAPICallout('wqgetcasadocumentsbyrefnov1','POST', clientData,'Jitterbit');          
    }
    
 	/* @author Rakesh 6th service*/
    @AuraEnabled
    public static ResponseObj WQconfirmDocumentReceipt(String clientData) {
        return sales_DashboardController.CommonAPICallout('wqconfirmdocumentreceiptv2','POST', clientData,'Jitterbit');    
    }    
    
 	/* @author MK 7th CIF service*/
    @AuraEnabled
    public static ResponseObj updateCIF(String clientData) {
         return sales_DashboardController.CommonAPICallout('update','POST', clientData,'DataPowerCIFUpdate');  
    }         
     
    /* @author Thabo 8th CIF service*/
	@AuraEnabled
    public static ResponseObj validateClientDetails(String clientData) {
        return sales_DashboardController.CommonAPICallout('validate','POST', clientData, 'DataPowerValidate');                  
    }    
    
	/* @author Thabo and Percy  1st scoring service*/    
    @auraEnabled
    public static ResponseObj getApplicationNum(string clientData) { 
		//String clientData = '{"SJMgenerateApplicationNumberV2":{"nbsapdpi":{"channel":"SALESFORCE","application":"DIVE","trace":"Y"},"nbsmsgi":{"msgLanguage":"E","msgTarget":"STD","finalMsgClass":"","finalMsgCode":""},"sjp304i":{"origin":"B","corpCode":"ABS","branchCode":"8392","branchSiteType":"034","agencyCode":"8392","agencySiteType":"034","tellerCode":"2693","supervisorCode":"0","clientCode":"BAILVP 001","prodCde":"ACSP","consultEmplNo":"1072376"}}}';       	
        return sales_DashboardController.CommonAPICallout('sjmgenerateapplicationnumberv2','POST', clientData,'Jitterbit');    
    }
    
    /* @author Thabo & Percy 2nd scoring service*/  
    @AuraEnabled
    public static ResponseObj initiateApplication(String clientData) {
		return sales_DashboardController.CommonAPICallout('sjminitiateapplicationv1','POST', clientData, 'Jitterbit');         
    }
    
    /* @author Thabo and Percy 3rd scoring service*/  
    @AuraEnabled
    public static ResponseObj submitApplication(String clientData){
		 return sales_DashboardController.CommonAPICallout('sjmsubmitapplicationv1','POST', clientData,'Jitterbit');         
    }    
    
    /* @author Thabo and Percy 4rd scoring service Name: SJMgetDuplicateApplicationsV1*/  
    @AuraEnabled 
    public static ResponseObj getDuplicateApplications(String clientData){
     return sales_DashboardController.CommonAPICallout('sjmgetduplicateapplicationsv1','POST', clientData,'Jitterbit');         
    } 
     
    /* @author Thabo and Percy 5rd scoring service Name: SJMgetPLSettlementAccountsV2 - V 3.0.0*/ 
	@AuraEnabled
    public static ResponseObj getplsettlementaccountsv2api(String clientData){
       return sales_DashboardController.CommonAPICallout('sjmgetplsettlementaccountsv2api/SJMgetPLSettlementAccountsV2','POST', clientData,'DataPowerCP_INTEGRATION');           
    }    
    
    /* @author Thabo and Percy 6rd scoring service Name: SJMsubmitSettlementAcctsV3 - V 4.0.0 */     
    @AuraEnabled 
    public static ResponseObj sjmsubmitsettlementacctsv3(String clientData){   
	  // String body = '{"SJMsubmitSettlementAcctsV3":{"nbsapdpi":{"channel":"Salesforce","application":"Dive","trace":"Y"},"nbsmsgi":{"msgLanguage":"E","msgTarget":"STD","finalMsgId":{"finalMsgClass":"","finalMsgCode":""}},"sjp300i":{"applicationNo":"42001742077","financeType":"1","settlementAccounts":[{"settAccountNumber":"1122","settCorp":"11"},{"settAccountNumber":"1122","settCorp":"11"}],"rlAccountNumber":"1122","corpCode":"ABS","branchCode":"8392","branchSiteType":"034","agencyCode":"8394","agencySiteType":"034","tellerCode":"2693","supervisorCode":"0"}}}';        
       return sales_DashboardController.CommonAPICallout('sjmsubmitsettlementacctsv3','POST', clientData,'Jitterbit');        
    } 
    
    /* @author Thabo and Percy 7rd scoring service Name: SJMsubmitPLInfoV3 - V 4.0. 0 */  
    @AuraEnabled 
    public static ResponseObj submitPLInfo(String clientData){
        // String body = '{"SJMsubmitPLInfoV4":{"nbsapdpi":{"channel":"Salesforce","application":"Dive","trace":"Y"},"nbsmsgi":{"msgLanguage":"E","msgTarget":"STD","finalMsgId":{"finalMsgClass":"","finalMsgCode":""}},"sjb301di":{"applicationNo":"42001742077","financeType":"1","purposeOfLoan":"1","purposeOfLoanRsn":"","additLoanAmnt":"100","loanExposure5":"1","paymType":"","noOfPaymts":"1","skipPayment":"1","initiationFeePaym":"1","paymFreq":"M","paymentMethod":"1","creditLifeInd":"","corpCode":"ABS","branchCode":"8392","branchSiteType":"034","agencyCode":"8392","agencySiteType":"034","tellerCode":"2693","supervisorCode":"0","amlrSelected":"","balanceTransferInst":"1","scndCreditLife":""}}}';
       
      return sales_DashboardController.CommonAPICallout('sjmsubmitplinfov4','POST', clientData,'Jitterbit');         
    }        
    
    /* @author Thabo and Percy 8rd scoring service Name: SJMsubmitCreditLifePolicyInfoV1 */      
    @AuraEnabled 
    public static ResponseObj submitCreditLifePolicyInfoV1(String clientData) {        
        return sales_DashboardController.CommonAPICallout('sjmsubmitcreditlifepolicyinfov1','POST', clientData, 'Jitterbit');                   
    }    
    
    /* @author Rakesh 9th sequence in scoring Name:SJMgetCMSSMSInfoV2 */ 
    @AuraEnabled
    public static ResponseObj sjmgetCMSSMSInfo(string clientData) {
        return sales_DashboardController.CommonAPICallout('sjmgetcmssmsinfov2api/SJMgetCMSSMSInfoV2','POST', clientData,'DataPowerCP_INTEGRATION');   
    }

    /* @author Rakesh 10th sequence in scoring Name:SJMsubmitCMSContinuationProcessV1 */ 
    @AuraEnabled 
    public static ResponseObj submitCMSContinuationProcess(string clientData) {
		return sales_DashboardController.CommonAPICallout('sjmsubmitcmscontinuationprocessv1api/SJMsubmitCMSContinuationProcessV1','POST', clientData,'DataPowerCP_RBB');   
    }
    
    
   /* @author Rakesh * * service, 11th sequence in scoring, Name:SJMsaveTRIADAgreementV1 */  
    @AuraEnabled
	public static ResponseObj saveTRIADAgreement(string clientData) {
		return sales_DashboardController.CommonAPICallout('sjmsavetriadagreementv1','POST', clientData,'Jitterbit');   
    }
    
    /* @author Rakesh 12th sequence in scoring, Name:SJMgetClientCreditInfoMaintV2 */  
    @AuraEnabled
	public static ResponseObj getClientCreditInfomaint(string clientData) {        
         return sales_DashboardController.CommonAPICallout('sjmgetclientcreditinfomaintv2','POST', clientData,'Jitterbit');  
    }
    
     /* @author Rakesh 13th sequence in scoring, Name:SJMsubmitClientDetailV1 */  
     @AuraEnabled
	public static ResponseObj submitClientDetail(string clientData) { 
        return sales_DashboardController.CommonAPICallout('sjmsubmitclientdetailv1','POST', clientData,'Jitterbit'); 
    }
      
    /* @author Rakesh 14th sequence in scoring, Name:SJMgetExpensesV6 */  
    @auraEnabled
    public static ResponseObj getExpenses(string clientData) {
        return sales_DashboardController.CommonAPICallout('sjmgetexpensesv6','POST', clientData,'Jitterbit');  
    }
    
     /* @author Rakesh 15th sequence in scoring, Name:SJMsubmitExpenseV6 */      
     @AuraEnabled
    public static ResponseObj submitExpense(String clientData) {
         return sales_DashboardController.CommonAPICallout('sjmsubmitexpensev6/SJMsubmitExpenseV6','POST', clientData,'DataPowerCP_RBB'); 
    }
    
     /* @author Rakesh 16th sequence in scoring, Name:SJMgetFinancialDetailsV1 */      
    @AuraEnabled 
    public static ResponseObj sjmgetfinancialdetailsv1(String clientData){
         return sales_DashboardController.CommonAPICallout('sjmgetfinancialdetailsv1','POST', clientData,'Jitterbit');  
    }
    
    /* @author Joshua, 17st scoring Name: SJMsaveFinancialDetailsV1*/    
    @AuraEnabled
    public static ResponseObj saveFinancialDetails(String clientData) {      
        return sales_DashboardController.CommonAPICallout('sjmsavefinancialdetailsv1','POST', clientData, 'Jitterbit'); 
    }
    
    /* @author Joshua, 18st scoring Name: , Name:SJMprocessBlazeAdvisorV2 */    
    @AuraEnabled
    public static ResponseObj processBlazeAdvisor(String clientData) {
        return sales_DashboardController.CommonAPICallout('sjmprocessblazeadvisorv2','POST', clientData, 'Jitterbit'); 
    }
    
    /* @author Joshua,  19th scoring Name: SJMgetCreditBureaDetailsV1*/    
    @AuraEnabled
    public static ResponseObj getCreditBureauDetails(string clientData) {
        return sales_DashboardController.CommonAPICallout('sjmgetcreditbureaudetailsv1api/SJMgetCreditBureauDetailsV1','POST', clientData, 'DataPowerCP_RBB');       
    }

    /* @author Joshua, 20th scoring*/ 
    @AuraEnabled
    public static ResponseObj saveCreditBureaDetails(String clientData) {
        return sales_DashboardController.CommonAPICallout('sjmsavecreditbureaudetailsv1api/SJMsaveCreditBureauDetailsV1','POST', clientData, 'DataPowerCP_INTEGRATION'); 
    }
    
    /* @author Joshua, Unknown th scoring*/ 
    @AuraEnabled
    public static ResponseObj relinkCreditBureauDetails(String clientData) {
        return sales_DashboardController.CommonAPICallout('sjmrelinkcreditbureaudetailsv1api/SJMrelinkCreditBureauDetailsV1','POST', clientData, 'DataPowerCP_RBB'); 
    }
    
    /* @author Joshua, 21st scoring*/ 
    @AuraEnabled
    public static ResponseObj getPLScoringResult(String clientData) {
       return sales_DashboardController.CommonAPICallout('sjmgetplscoringresultv1','POST', clientData, 'Jitterbit');           
    }
    
   /* @author Joshua, 22nd scoring*/ 
    @AuraEnabled
    public static ResponseObj savePLScoringResult(String clientData) {
        return sales_DashboardController.CommonAPICallout('sjmsaveplscoringresultv1','POST', clientData, 'Jitterbit');         
    }     
        
    /* @author Joshua, 23rd scoring*/ 
    @AuraEnabled
    public static ResponseObj getQuoteDetail(string clientData) {
         return sales_DashboardController.CommonAPICallout('sjmgetquotedetailv2api/SJMgetQuoteDetailV2','POST', clientData, 'DataPowerCP_INTEGRATION');       
    }
    
    /* @author Joshua, 24th scoring*/ 
    @AuraEnabled
    public static ResponseObj submitQuoteDetail(String clientData) {
        return sales_DashboardController.CommonAPICallout('sjmsubmitquotedetailv2','POST', clientData, 'Jitterbit'); 
    }
        
    @AuraEnabled 
    public static ResponseObj NHlistAcctsLinkedToAClientV1(String clientData){        
       	return sales_DashboardController.CommonAPICallout('nhlistacctslinkedtoaclientv1','POST', clientData,'Jitterbit');    		
    }

    @auraEnabled
    public static List<Sales_Client_Profile__c>  getClientDetailsSOQl(String IdNumber){
        //String recordId = 'a1X3E0000007hpxUAA'; 
        List<Sales_Client_Profile__c> profile = [SELECT id,ID_Number__c,Title__c,ID_Type__c,ID_Date_Issued__c,Place_Of_Residence__c,
                                                 Customer_Type__c,Gender__c,Date_Of_Birth__c,Country_Of_Birth__c,Nationality__c,
                                                 Marital_Status__c,Marital_Contract__c,Home_Language__c,Dependents__c,Full_Name__c, 
                                                 Relationship__c,Contact_Number__c,Communication_Language__c,Insolvent__c,Social_Grant__c,
                                                 Debt_Counseling__c,Does_Client_HavePostMatric_Qualification__c,Post_Matric_Qualification__c,
                                                 FICA_Date_Identified__c,Verify_Client__c,Residential_Address__c,Current_Address_Since__c,
                                                 Residential_Address_Country__c,Residential_Status__c,Outstanding_Bond__c,Realistic_Market_Value__c,
                                                 Section_129_Notice_Delivery_Address__c,Postal_Address_Line_1_3__c,Town_City_Foreign_Country__c,
                                                 Postal_Code__c,Work_Telephone_Number__c,Home_Telephone_Number__c,Work_Fax_Number__c,
                                                 Home_Fax_Number__c,Cellphone_Number__c,Email_Address__c,Preffered_Communication_Channel__c,
                                                 Credit_Worthiness__c,ABSA_Group_Electronic__c,Voice_Recording__c,Email__c,SMS__c,
                                                 Occupational_Status__c,Employment_Sector__c,Occupation__c,Occupation_Code__c,
                                                 Occupation_Level__c,Monthly_Income__c,Source_Of_Income__c,Frequency_Of_Income__c,
                                                 Current_Employment_Since__c,Client_Banks_With_ABSA__c,Employers_Name__c,
                                                 Empl_Postal_Address_Line_1_3__c,Empl_Town_City_Foreign_Country__c,Empl_Postal_Code__c,
                                                 Client_Registed_For_Income_Tax__c,SA_Income_Tax_Number__c,Reason_SA_Income_Tax_Number_Not_Given__c,
                                                 Client_Registered_For_Foreign_Income_Tax__c,Foreign_Income_Tax_Number__c,
                                                 Reason_Foreign_Income_Tax_Num_Not_Given__c,name,Surname__c,Initials__c,  
                                                 
                                                 (SELECT id,name,
                                                  Products__c,I_Accept_Terms_And_Conditions__c,Application_Number__c,Puporse_Of_Loan__c,
                                                  Other__c,Race_Indicator__c,Number_Of_Payments__c,Initiation_Fee_Payment_Method__c,Additional_Loan_Amount__c,
                                                  Settlement_Other_Products__c,Total_Amount__c,Payment_Type__c,Payment_Frequency__c,ABSA_Credit_Life__c,
                                                  Groceries__c,Domestic_Garderner_Worker_etc__c,Telephone_Cellphone__c,Education_School_Loan_Repayment__c,
                                                  Transport_Petrol_Excl_Vehicle_Finance__c,Insurance_And_Funeral_Policies__c,Municipal_Levies_Rates_taxes_water_light__c,
                                                  Security__c,Rental__c,Maintenance__c,Entertainment__c,Specify_Other_Expenses__c,Amount__c,Necessary_Expenses__c,                                                  
                                                  Gross_Income__c,Salary_Deductions__c,Net_Salary_income_Month_1__c,Net_Salary_income_Month_2__c,
                                                  Net_Salary_income_Month_3__c,Salary_Deducted_Fixed_Debit__c,Rental_Income__c,Other_Additional_Income__c,
                                                  Total_Net_Monthly_Income__c,Bond_Mortgage__c,Loan_Overdraft__c,Credit_Cards__c,Asset_And_Finance_Repayment__c,
                                                  Retail_Accounts__c,Other_Debt_Repayment__c,Total_Dept_Repayment__c, Total_Monthly_Expenses__c,
                                                  Surplus_Shortage__c,Casa_Reference__c,Final_Loan_Amount__c,Final_Decision__c,Reason__c,First_Payment_Date__c,
                                                  Request_A_Quote_To_Be_Issued__c,Product__c                                             
                                                  FROM  Application__r order BY CreatedDate DESC LIMIT 1),                                                 
                                                 (select id,CSA_number__c from  Casa_Reference__r),
                                                 (select id from  Call_History__r) 
                                                 from Sales_Client_Profile__c where ID_Number__c =: IdNumber];
        if(profile.size()>0){
            if(profile[0].Application__r.size()>0){
                profile[0].Application_Record_ID__c = profile[0].Application__r[0].Id;
            }
        }
        System.debug(profile);    
        return profile;
    }    

    @auraEnabled
    public static List<Sales_Client_Profile__c>  getClientProfile(String IdNumber){
        //String recordId = 'a1X3E0000007hpxUAA';
        List<Sales_Client_Profile__c> profile = [SELECT id,ID_Number__c,Title__c,ID_Type__c,ID_Date_Issued__c,Place_Of_Residence__c,
                                                 Customer_Type__c,Gender__c,Date_Of_Birth__c,Country_Of_Birth__c,Nationality__c,
                                                 Marital_Status__c,Marital_Contract__c,Home_Language__c,Dependents__c,Full_Name__c, 
                                                 Relationship__c,Contact_Number__c,Communication_Language__c,Insolvent__c,Social_Grant__c,
                                                 Debt_Counseling__c,Does_Client_HavePostMatric_Qualification__c,Post_Matric_Qualification__c,
                                                 FICA_Date_Identified__c,Residential_Address__c,Current_Address_Since__c,
                                                 Residential_Address_Country__c,Residential_Status__c,Outstanding_Bond__c,Realistic_Market_Value__c,
                                                 Section_129_Notice_Delivery_Address__c,Postal_Address_Line_1_3__c,Town_City_Foreign_Country__c,
                                                 Postal_Code__c,Work_Telephone_Number__c,Home_Telephone_Number__c,Work_Fax_Number__c,
                                                 Home_Fax_Number__c,Cellphone_Number__c,Email_Address__c,Preffered_Communication_Channel__c,
                                                 Credit_Worthiness__c,ABSA_Group_Electronic__c,Voice_Recording__c,Email__c,SMS__c,
                                                 Occupational_Status__c,Employment_Sector__c,Occupation__c,Occupation_Code__c,
                                                 Occupation_Level__c,Monthly_Income__c,Source_Of_Income__c,Frequency_Of_Income__c,
                                                 Current_Employment_Since__c,Client_Banks_With_ABSA__c,Employers_Name__c,
                                                 Empl_Postal_Address_Line_1_3__c,Empl_Town_City_Foreign_Country__c,Empl_Postal_Code__c,
                                                 Client_Registed_For_Income_Tax__c,SA_Income_Tax_Number__c,Reason_SA_Income_Tax_Number_Not_Given__c,
                                                 Client_Registered_For_Foreign_Income_Tax__c,Foreign_Income_Tax_Number__c,
                                                 Reason_Foreign_Income_Tax_Num_Not_Given__c,name,Surname__c,Initials__c,                                                   
                                                 
                                                 (SELECT id,name,
                                                  Products__c,I_Accept_Terms_And_Conditions__c,Application_Number__c,Puporse_Of_Loan__c,
                                                  Other__c,Race_Indicator__c,Number_Of_Payments__c,Initiation_Fee_Payment_Method__c,Additional_Loan_Amount__c,
                                                  Settlement_Other_Products__c,Total_Amount__c,Payment_Type__c,Payment_Frequency__c,ABSA_Credit_Life__c,
                                                  Groceries__c,Domestic_Garderner_Worker_etc__c,Telephone_Cellphone__c,Education_School_Loan_Repayment__c,
                                                  Transport_Petrol_Excl_Vehicle_Finance__c,Insurance_And_Funeral_Policies__c,Municipal_Levies_Rates_taxes_water_light__c,
                                                  Security__c,Rental__c,Maintenance__c,Entertainment__c,Specify_Other_Expenses__c,Amount__c,Necessary_Expenses__c,                                                  
                                                  Gross_Income__c,Salary_Deductions__c,Net_Salary_income_Month_1__c,Net_Salary_income_Month_2__c,
                                                  Net_Salary_income_Month_3__c,Salary_Deducted_Fixed_Debit__c,Rental_Income__c,Other_Additional_Income__c,
                                                  Total_Net_Monthly_Income__c,Bond_Mortgage__c,Loan_Overdraft__c,Credit_Cards__c,Asset_And_Finance_Repayment__c,
                                                  Retail_Accounts__c,Other_Debt_Repayment__c,Total_Dept_Repayment__c, Total_Monthly_Expenses__c,
                                                  Surplus_Shortage__c,Casa_Reference__c,Final_Loan_Amount__c,Final_Decision__c,Reason__c,First_Payment_Date__c,
                                                  Request_A_Quote_To_Be_Issued__c,Product__c                                             
                                                  FROM  Application__r order BY CreatedDate DESC LIMIT 1),
                                                 
                                                 (SELECT id,CSA_number__c from  Casa_Reference__r),
                                                 (SELECT id FROM  Call_History__r) 
                                                 FROM Sales_Client_Profile__c WHERE ID_Number__c =: IdNumber];
        if(profile.size()>0){
            if(profile[0].Application__r.size()>0){
                profile[0].Application_Record_ID__c = profile[0].Application__r[0].Id;
            }
        }
        System.debug(profile);    
        return profile;
    }    
    
    @AuraEnabled
    public static ResponseObj getUserInfo() { 
        DataMap obj = new DataMap();        
        List<Object> usr =  [select Name, Firstname, Lastname, Email, AB_Number__c,EmployeeNumber,Teller_Operator_Code__c,Username, DBS_Dashboard_Do_Not_Show__c,LastLoginDate,Station_ID__c from User where Username =: UserInfo.getUserName()];
        String getLabelName = Label.sales_Support;
        obj.dataMap = new Map <String, Object> {
                'user' => usr,
                'support' => getLabelName                
        };
       return new ResponseObj(obj); 
    }
    
    @AuraEnabled
     public static ResponseObj  saveApplication(String clientData) { 
             try{
            Map<String, Object> meta = (Map<String, Object>) JSON.deserializeUntyped(clientData);
            
            String profRecId = (String) meta.get('profile_record_id');
            String applRecId = (String) meta.get('applcation_record_id'); 
            
            String id_date_issued = (String) meta.get('id_date_issued');        
            String date_of_birth = (String) meta.get('date_of_birth');
            String fica_date_identified =  (String) meta.get('fica_date_identified');        
            String current_address_since =  (String) meta.get('current_address_since');
            String current_employment_since =  (String) meta.get('current_employment_since'); 
            String first_payment_date =  (String) meta.get('first_payment_date');
            
            
            Date idDateIssued =(!String.isBlank(id_date_issued)) ?  date.parse(id_date_issued) : null;  
            Date dateOfBirth =(!String.isBlank(date_of_birth)) ?    date.parse(date_of_birth) : null;  
            Date ficaDateIdentified =(!String.isBlank(fica_date_identified)) ?  date.parse(fica_date_identified) : null;  
            Date currentAddressSince = (!String.isBlank(current_address_since)) ?   date.parse(current_address_since) : null;  
            Date currentEmplSince = (!String.isBlank(current_employment_since)) ? date.parse(current_employment_since) : null;  
            Date firstPaymentDate = (!String.isBlank(first_payment_date)) ? date.parse(first_payment_date) : null;     
            
            
                        
            Sales_Client_Profile__c profile = new Sales_Client_Profile__c(    
                ID_Number__c = (String) meta.get('id_number'), 
                Title__c= (String) meta.get('title_value'),
                ID_Type__c = (String) meta.get('id_type_value'),
                ID_Date_Issued__c = idDateIssued,
                Place_Of_Residence__c = (String) meta.get('place_of_residence'),
                Customer_Type__c = (String) meta.get('customer_type'),
                Gender__c= (String) meta.get('gender'),
                Date_Of_Birth__c = dateOfbirth,
                Country_Of_Birth__c = (String) meta.get('country_of_birth'),
                Nationality__c= (String) meta.get('nationality'),
                Marital_Status__c= (String) meta.get('marital_status'),
                Marital_Contract__c= (String) meta.get('marital_contract'),
                Home_Language__c= (String) meta.get('home_language'),
                Dependents__c= (String) meta.get('dependents'),
                Full_Name__c= (String) meta.get('first_names'),
                Relationship__c= (String) meta.get('relationship'),
                Contact_Number__c= (String) meta.get('contact_number'),
                Communication_Language__c= (String) meta.get('communication_language'),
                Insolvent__c= (String) meta.get('insolvent'),
                Social_Grant__c= (String) meta.get('social_grant'),
                Debt_Counseling__c = (String) meta.get('debt_counseling'),
                Does_Client_HavePostMatric_Qualification__c= (String) meta.get('does_client_havepostmatric_qualification'),
                Post_Matric_Qualification__c= (String) meta.get('post_matric_qualification'),
                FICA_Date_Identified__c= ficaDateIdentified,
                Verify_Client__c = (String) meta.get('verify_client_label_1'),            
                Residential_Address__c= (String) meta.get('residential_address'),
                Current_Address_Since__c= currentAddressSince,
                Residential_Address_Country__c= (String) meta.get('residential_address_country'),
                Residential_Status__c= (String) meta.get('residential_status'),
                Outstanding_Bond__c= (Double) meta.get('outstanding_bond'),
                Realistic_Market_Value__c = (Double) meta.get('realistic_market_value'),
                Section_129_Notice_Delivery_Address__c = (String) meta.get('section_129_notice_delivery_address'),
                Postal_Address_Line_1_3__c = (String) meta.get('postal_address_line_1_3'),
                Town_City_Foreign_Country__c= (String) meta.get('town_city_foreign_country'),
                Postal_Code__c = (String) meta.get('postal_code'),
                Work_Telephone_Number__c= (String) meta.get('work_telephone'),
                Home_Telephone_Number__c = (String) meta.get('home_telephone'),
                Work_Fax_Number__c  = (String) meta.get('work_fax_number'),
                Home_Fax_Number__c =(String) meta.get('home_fax_number'),
                Cellphone_Number__c = (String) meta.get('cellphone_number'),
                Email_Address__c = (String) meta.get('email_address'),
                Preffered_Communication_Channel__c=(String) meta.get('preffered_communication_channel'),
                Credit_Worthiness__c= (Boolean) meta.get('credit_worthiness'),
                ABSA_Group_Electronic__c= (Boolean) meta.get('absa_group_electronic'),
                Voice_Recording__c= (Boolean) meta.get('voice_recording'),
                Email__c= (Boolean) meta.get('email'),
                SMS__c = (Boolean) meta.get('sms'),            
                Occupational_Status__c= (String) meta.get('occupational_status'),
                Employment_Sector__c= (String) meta.get('employment_sector'),
                Occupation__c= (String) meta.get('occupation'),
                Occupation_Code__c= (String) meta.get('occupation_code'),
                Occupation_Level__c= (String) meta.get('occupation_level'),
                Monthly_Income__c= (String) meta.get('monthly_income'),
                Source_Of_Income__c= (String) meta.get('source_of_income'),
                Frequency_Of_Income__c= (String) meta.get('frequency_of_income'),
                Current_Employment_Since__c= currentEmplSince, 
                Client_Banks_With_ABSA__c= (String) meta.get('client_banks_with_absa'),
                Employers_Name__c= (String) meta.get('employers_name'),
                Empl_Postal_Address_Line_1_3__c= (String) meta.get('empl_postal_address_line_1_3'),
                Empl_Town_City_Foreign_Country__c= (String) meta.get('empl_town_city_foreign_country'),
                Empl_Postal_Code__c= (String) meta.get('empl_postal_code'),
                Client_Registed_For_Income_Tax__c= (String) meta.get('client_registed_for_income_tax'),
                SA_Income_Tax_Number__c= (String) meta.get('sa_income_tax_number'),
                Reason_SA_Income_Tax_Number_Not_Given__c= (String) meta.get('reason_sa_income_tax_number_not_given'),
                Client_Registered_For_Foreign_Income_Tax__c= (String) meta.get('client_registered_for_foreign_income_tax'),
                Foreign_Income_Tax_Number__c= (String) meta.get('foreign_income_tax_number'), 
                Reason_Foreign_Income_Tax_Num_Not_Given__c= (String) meta.get('reason_foreign_income_tax_num_not_given'),
                Title_Text__c = (String) meta.get('title_label'),
                Initials__c = (String) meta.get('initials'), 
                Surname__c = (String) meta.get('surname_comp'), 
                ID_Type_Text__c = (String) meta.get('id_type_label'),
                Place_Of_Residence_Text__c = (String) meta.get('place_of_residence_label'),
                Customer_Type_Text__c = (String) meta.get('customer_type_label'),
                Gender_Text__c = (String) meta.get('gender_label'),
                Country_Of_Birth_Text__c = (String) meta.get('country_of_birth_label'),
                Nationality_Text__c = (String) meta.get('nationality_label'),
                Marital_Status_Text__c = (String) meta.get('marital_status_label'),
                Marital_Contract_Text__c = (String) meta.get('marital_contract_label'),
                Home_Language_Text__c = (String) meta.get('home_language_label'),
                Nkin_Surame__c = (String) meta.get('nkin_surame_label'),
                Nkin_Full_Names__c = (String) meta.get('nkin_full_names_label'),
                Nkin_Email_Address__c = (String) meta.get('nkin_email_address_label'),
                Relationship_Text__c = (String) meta.get('relationship_label'),
                Communication_Language_Text__c = (String) meta.get('communication_language_label'),
                Post_Matric_Qualification_Text__c = (String) meta.get('post_matric_qualification_label'),
                Residential_Address_Country_Text__c = (String) meta.get('residential_address_country_label'),
                Residential_Status_Text__c = (String) meta.get('residential_status_label'),
                Section_129_Notice_Delivery_Address_Text__c =(String) meta.get('section_129_notice_delivery_address_label'),
                Preffered_Communication_Channel_Text__c = (String) meta.get('preffered_communication_channel_label'),
                Occupational_Status_Text__c = (String) meta.get('occupational_status_label'),
                Employment_Sector_Text__c = (String) meta.get('employment_sector_label'),
                Occupation_Code_Text__c = (String) meta.get('occupation_code_label'),
                Occupation_Level_Text__c = (String) meta.get('occupation_level_label'),
                Monthly_Income_Text__c = (String) meta.get('monthly_income_label'),
                Source_Of_Income_Text__c = (String) meta.get('source_of_income_label'),
                Frequency_Of_Income_Text__c = (String) meta.get('frequency_of_income_label'),
                Casa_Reference_Number__c = (String) meta.get('casa_reference'),
                Credit_Worthiness_Text__c = (String) meta.get('credit_worthiness_text'),
                ABSA_Group_Electronic_Text__c = (String) meta.get('absa_group_electronic_text'),
                Voice_Recordin_Text__c = (String) meta.get('voice_recording_text'),
                Email_Text__c = (String) meta.get('email_text'),
                SMS_Text__c = (String) meta.get('sms_text'),
                Insolvent_Text__c= (String) meta.get('insolvent_text'),
                Social_Grant_Text__c= (String) meta.get('social_grant_text'),
                Debt_Counseling_Text__c = (String) meta.get('debt_counseling_text'),
                Does_Client_HavePostMatric_Qual_Text__c= (String) meta.get('does_client_havepostmatric_qualification_text')
                );
            
            
            Sales_Application__c application = new Sales_Application__c
                (Products__c= (String) meta.get('products'),
                 I_Accept_Terms_And_Conditions__c= (Boolean) meta.get('i_accept_terms_and_conditions'),
                 Application_Number__c = (String) meta.get('application_number'),
                 Puporse_Of_Loan__c= (String) meta.get('purpose_of_loan'),
                 Other__c = (String) meta.get('other'),
                 Race_Indicator__c = (String) meta.get('race_indicator'),
                 Number_Of_Payments__c =(String) meta.get('number_of_payments'),
                 Initiation_Fee_Payment_Method__c =(String) meta.get('initiation_fee_payment_method'),
                 Additional_Loan_Amount__c =  (Double) meta.get('additional_loan_amount'),
                 Settlement_Other_Products__c= (String) meta.get('settlement_other_products'),
                 Total_Amount__c= (Double) meta.get('total_amount'),
                 Payment_Type__c = (String) meta.get('payment_type'),
                 Payment_Frequency__c = (String) meta.get('payment_frequency'),
                 ABSA_Credit_Life__c=(String) meta.get('absa_credit_life'),
                 Groceries__c = (Double) meta.get('groceries'),
                 Domestic_Garderner_Worker_etc__c = (Double) meta.get('domestic_garderner_worker_etc'),
                 Telephone_Cellphone__c = (Double) meta.get('telephone_cellphone'),
                 Education_School_Loan_Repayment__c = (Double) meta.get('education_school_loan_repayment'),
                 Transport_Petrol_Excl_Vehicle_Finance__c = (Double) meta.get('transport_petrol_excl_vehicle_finance'),
                 Insurance_And_Funeral_Policies__c=(Double) meta.get('insurance_and_funeral_policies'),
                 Municipal_Levies_Rates_taxes_water_light__c=(Double) meta.get('municipal_levies_rates_taxes_water_light'),
                 Security__c=(Double) meta.get('security'),
                 Rental__c=(Double) meta.get('rental'),
                 Maintenance__c=(Double) meta.get('maintenance'),
                 Entertainment__c=(Double) meta.get('entertainment'),
                 Specify_Other_Expenses__c=(String) meta.get('specify_other_expenses'),
                 Amount__c=(Double) meta.get('amount'),
                 Necessary_Expenses__c=(Double) meta.get('necessary_expenses'),
                 Gross_Income__c=(Double) meta.get('gross_income'),
                 Salary_Deductions__c=(Double) meta.get('salary_deductions'),
                 Net_Salary_income_Month_1__c=(Double) meta.get('net_salary_income_month_1'),
                 Net_Salary_income_Month_2__c=(Double) meta.get('net_salary_income_month_2'),
                 Net_Salary_income_Month_3__c=(Double) meta.get('net_salary_income_month_3'),
                 Salary_Deducted_Fixed_Debit__c=(Double) meta.get('salary_deducted_fixed_debit'),
                 Rental_Income__c=(Double) meta.get('rental_income'),
                 Other_Additional_Income__c=(Double) meta.get('other_additional_income'),
                 Total_Net_Monthly_Income__c=(Double) meta.get('total_net_monthly_income'),
                 Bond_Mortgage__c=(Double) meta.get('bond_mortgage'),
                 Loan_Overdraft__c=(Double) meta.get('loan_overdraft'),
                 Credit_Cards__c=(Double) meta.get('credit_cards'),
                 Asset_And_Finance_Repayment__c=(Double) meta.get('asset_and_finance_repayment'),
                 Retail_Accounts__c= (Double) meta.get('retail_accounts'),
                 Other_Debt_Repayment__c= (Double) meta.get('other_debt_repayment'), 
                 Total_Dept_Repayment__c=(Double) meta.get('total_dept_repayment'),
                 Total_Monthly_Expenses__c= (Double) meta.get('total_monthly_expenses'),
                 Surplus_Shortage__c=(Double) meta.get('surplus_shortage'),             
                 Casa_Reference__c=null,
                 Final_Loan_Amount__c=(Double) meta.get('final_loan_amount'),
                 Final_Decision__c=(String) meta.get('final_decision'),
                 Reason__c=(String) meta.get('reason'),
                 First_Payment_Date__c=firstPaymentDate,
                 Request_A_Quote_To_Be_Issued__c=(String) meta.get('request_a_quote_to_be_issued'));
            
            if(String.isBlank(profRecId)){ 
                system.debug('profile insert: '+profile);
                insert profile;    
                profile.Id = profile.Id;  
                
                if(String.IsBlank(applRecId)){
                    system.debug('application insert: '+application);
                    application.Client__c = profile.Id;
                    insert application;
                    
                    system.debug('application update: '+application);
                    profile.Application_Record_ID__c = application.Id;
                    application.Id = application.Id;
                    update application; 
                }
            }else{
                profile.Id = profRecId;
                system.debug('profile update: '+profile);
                system.debug('Appl ID: '+applRecId);
                update profile; 
                
                if(String.IsBlank(applRecId)){
                    system.debug('application insert: '+application);
                    application.Client__c = profRecId;
                    insert application;
                    
                    system.debug('application update: '+application);
                    profile.Application_Record_ID__c = application.Id;
                    application.Id = application.Id;
                    update application;
                }else{
                    system.debug('application update: '+application);
                    profile.Application_Record_ID__c = application.Id;
                    application.Id = applRecId;
                    update application; 
                }                  
            }                               
        	DataMap dm = new DataMap();
        	List<Sales_Client_Profile__c> clientInfo = sales_DashboardController.getClientProfile((String) meta.get('id_number'));
                 if(clientInfo.size()>0){
                     dm.dataMap.put('sfResp', clientInfo);    
                 }
            
                return new ResponseObj(dm);   
         }catch (Exception e){             
            return new ResponseObj(false, e.getMessage()); 
         }
     }

    public class DataMap{
        @AuraEnabled public Map <String, Object> dataMap;
        public DataMap() {
            dataMap = new Map <String, Object>();
        }                
    }
    
    public class ResponseObj {
        @AuraEnabled public Boolean IsSuccess { get; set; }
        @AuraEnabled public String Message { get; set; }
        @AuraEnabled public Object Data { get; set; }
        
        public ResponseObj(Boolean isSuccess, String msg){
            this.IsSuccess = isSuccess;
            this.Message = msg;
            this.Data = null;
        }
        
        public ResponseObj(Object data){
            this.IsSuccess = true;
            this.Message = null;
            this.Data = data;
        }
    }
    
   /* public static HttpRequest setAuthentication(String authType, String urlExt, HttpRequest request){

				//DataPower Customer Portfolio auth
            	if(authType=='DataPowerCP_RBB' || authType=='DataPowerCP_INTEGRATION'){ 
                    
                    if(authType=='DataPowerCP_RBB'){
                        request.setEndpoint('https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/rbb/'+urlExt); 
                    }else if(authType=='DataPowerCP_INTEGRATION'){
                        request.setEndpoint('https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/integration/'+urlExt);
                    }
                	                         
                    request.setHeader('X-IBM-Client-Secret', 'X5iM4tV7qJ2uG7wJ0bV5iU2sS5gJ1pA7aI3bS8xV6oK8gX3qT4');
                    request.setHeader('X-IBM-Client-Id', '5fc57ea1-0816-4384-96e6-66429d57eb2c');
                    User usr = [select AB_Number__c from User where Username =: UserInfo.getUserName()];               
                    request.setHeader('userid', usr.AB_Number__c);
                    request.setHeader('applicationid', 'DIVE');
                    request.setHeader('deviceid', 'Browser');  
                    system.debug('DataPowerCP auth');
                } 
        
            	//Datapower customer infomation file auth
                if(authType=='DataPowerCIF' || authType=='DataPowerValidate'){
	
			        request.setEndpoint('https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/rbb/'+urlExt);      
                    request.setHeader('X-IBM-Client-Secret','O0uQ3lK5pE3uR0qO6oC1cG3tO8wX8uW3wC0fC1fF2xP4bI4bY2');
                    request.setHeader('X-IBM-Client-Id','6649833a-9c3c-4c87-b6f4-301aeb4d208c');
                    if (authType=='DataPowerCIF'){
                    	request.setHeader('TellerId','ABRB745');      
                    	request.setHeader('DeviceId','Browser');
                    	request.setHeader('BranchId','8196');
                    	request.setHeader('ApplicationId','DIVE');
                    	request.setHeader('branch','8196'); //for 1st service
             			system.debug('DataPowerCIF auth');                              
                	}  
              		else if(authType=='DataPowerValidate'){               
                		request.setHeader('CLIENT-GROUP','individual');
                		request.setHeader('SYSTEM-ID','DIVE');   
                    }
                }                      
            	if(authType=='Jitterbit'){
                    request.setEndpoint('https://absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/'+urlExt);
                    request.setHeader('User', 'DIVE');
                    string token = sales_DashboardController.auth();
                    request.setHeader('Authorization', 'Bearer ' + token);        
                    system.debug('Jitterbit auth : '+token);
            	}       
                if(authType=='DataPowerCIFUpdate'){
                    //request.setMethod('POST');
                    request.setEndpoint('https://esb.ext.api.uat.absa.co.za/enterprise-ext-uat/ext/rbb/update');
                    request.setHeader('Content-Type','application/json');
                    request.setHeader('X-IBM-Client-Secret','O0uQ3lK5pE3uR0qO6oC1cG3tO8wX8uW3wC0fC1fF2xP4bI4bY2');
                    request.setHeader('X-IBM-Client-Id','6649833a-9c3c-4c87-b6f4-301aeb4d208c');
                    request.setHeader('CLIENT-GROUP','individual');
                    request.setHeader('SYSTEM-ID','DIVE');   
                }
            return request; 
        }*/
    
      
     public static HttpRequest setAuthentication(String authType, String urlExt, HttpRequest request){

        Integration_API__c auth = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'DataPowerSales'];
		Integration_API__c auth_integr = [Select Base_URL__c, Client_ID__c, Client_Secret__c, Environment__c from Integration_API__c where Name = 'DataPowerCP_INTEGRATION'];
        User usr = [select AB_Number__c from User where Username =: UserInfo.getUserName()];
       
        String upperCase_Ab_Number = (usr.AB_Number__c).toUppercase();   //Release 1 Hot fix on 19th Nov deployment
         
         
         
        Map<Id, Sales_Authentication__c> headersMap = new Map<Id, Sales_Authentication__c>([Select Id, applicationid__c, BranchId__c, CLIENT_GROUP__c,
                    deviceid__c, Name, SYSTEM_ID__c, TellerId__c from Sales_Authentication__c]);
        
        Sales_Authentication__c header_dpcif;
                    Sales_Authentication__c header_dpcpi;
        			Sales_Authentication__c header_dpval;
                         
                    for(Id key : headersMap.keySet()){
                        Sales_Authentication__c sauth = headersMap.get(key);
                        
                        if(sauth.Name == 'DataPowerCIF'){
                            header_dpcif = sauth;                        
	                    }
                        if(sauth.Name == 'DataPowerCIFUpdate'){
                          	header_dpcpi = sauth; 
                        }
                        if(sauth.Name == 'DataPowerValidate'){
                            header_dpval = sauth; 
                        }                       
                    }
        
            	if(authType=='DataPowerCP_RBB' || authType=='DataPowerCP_INTEGRATION'){ 
                    
                    if(authType=='DataPowerCP_RBB'){
                        system.debug(' ---- '+auth.Base_URL__c);                        
                    	request.setEndpoint(auth.Base_URL__c+urlExt);                           
                    }else if(authType=='DataPowerCP_INTEGRATION'){                                              
                        request.setEndpoint(auth_integr.Base_URL__c+urlExt);
                    }
                    request.setHeader('X-IBM-Client-Secret', auth_integr.Client_Secret__c  );   
                    request.setHeader('X-IBM-Client-Id', auth_integr.Client_ID__c  ); 
                    // need to change ab number to upper case 
                   // request.setHeader('userid', usr.AB_Number__c);
                    request.setHeader('userid', upperCase_Ab_Number); //Release 1 Hot fix on 19th Nov deployment
                    
                    request.setHeader('applicationid', header_dpcif.applicationid__c);
                    request.setHeader('deviceid', header_dpcif.deviceid__c);                     
                    system.debug('DataPowerCP auth');
                } 
        
            	//Datapower customer infomation file auth.
                if(authType=='DataPowerCIF' || authType=='DataPowerValidate'){
                    request.setEndpoint(auth.Base_URL__c+urlExt);  
                    request.setHeader('X-IBM-Client-Secret',auth.Client_Secret__c);
                    request.setHeader('X-IBM-Client-Id', auth.Client_ID__c);
                    
                    if (authType=='DataPowerCIF'){
                    	//request.setHeader('TellerId', usr.AB_Number__c);
                        request.setHeader('TellerId', upperCase_Ab_Number);    //Release 1 Hot fix on 19th Nov deployment                                     	
                        request.setHeader('DeviceId', header_dpcif.deviceid__c);  
                        request.setHeader('BranchId', header_dpcif.BranchId__c);                     	
                        request.setHeader('ApplicationId', header_dpcif.applicationid__c);
                        request.setHeader('branch', header_dpcif.BranchId__c);
             			system.debug('DataPowerCIF auth');                              
                	}  
              		else if(authType=='DataPowerValidate'){ 
                        request.setHeader('CLIENT-GROUP', header_dpval.CLIENT_GROUP__c);
                        request.setHeader('SYSTEM-ID', header_dpval.SYSTEM_ID__c);
                    }
                }                      
            	if(authType=='Jitterbit'){
                    Integration_API__c jb = [Select Base_Url__c,  Client_ID__c from Integration_API__c where Name =: 'JitterbitAbsa330762'];                    
                    request.setEndpoint(jb.Base_Url__c+urlExt);
                    request.setHeader('User', jb.Client_ID__c);                    
                    string token = sales_DashboardController.auth();
                    request.setHeader('Authorization', 'Bearer ' + token);        
                    system.debug('Jitterbit auth : '+token);
            	}       
                if(authType=='DataPowerCIFUpdate'){
                    request.setEndpoint(auth.Base_URL__c+urlExt);
                    //request.setHeader('TellerId', usr.AB_Number__c);//Added by Rakesh on 10-11-2020
                    request.setHeader('TellerId', upperCase_Ab_Number);
                    request.setHeader('X-IBM-Client-Secret', auth.Client_Secret__c  );
                    request.setHeader('X-IBM-Client-Id', auth.Client_ID__c  );
                    request.setHeader('CLIENT-GROUP', header_dpval.CLIENT_GROUP__c);  
                    request.setHeader('SYSTEM-ID', header_dpval.SYSTEM_ID__c); 
                }
            return request; 
        }
    
     public static ResponseObj CommonAPICallout(String urlExt, String method, String json_body, String authType){ 
           
        try {                	            
   			Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setTimeout(30000);            
            request.setHeader('Content-Type', 'application/json');            
            sales_DashboardController.setAuthentication(authType,urlExt,request); 
            request.setMethod(method); 			

            request.setBody(json_body);
            HttpResponse response = http.send(request); 
            
            DataMap obj = new DataMap();
            obj.dataMap = new Map <String, Object> {
                'getBody' => response.getBody(),
                'getStatus' => response.getStatus(),
                'getStatusCode' => response.getStatusCode()
            };
                
            System.debug('\n API Name: '+urlExt+'\n getStatusCode: ' + response.getStatusCode()+ '\n getStatus: '+response.getStatus()+'\n getBody: '+response.getBody());     
            return new ResponseObj(obj);
		}catch (Exception e) {
            System.debug('ERROR==> ' + e);
            return new ResponseObj(false, e.getMessage());
        }            
    }
     
   /*
 	@AuraEnabled
    public static String auth(){    
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');//change
        
        String devToken =  (String) orgCache.get('devToken');  
        String tokenTime =  (String) orgCache.get('tokenTime');
        
        Http http = new Http(); 
        HttpRequest req = new HttpRequest(); 
        req.setTimeout(30000);
        req.setEndpoint('https://absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/auth/token');
        req.setHeader('grant_type', 'password');
        req.setHeader('client_id', 'salesforce-api');
        req.setHeader('username','salesforce');
        req.setHeader('password','P@ssword01');
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        
        String thebody = 'grant_type=password&client_id=salesforce-api&username=salesforce&password=P@ssword01';
        req.setBody(thebody);
        
        HttpResponse res;
        String authToken;
        Long minutesElapsed = 0;
        
        //Calculate minutes in numbers
        if(tokenTime!=null){
            DateTime timeVal = DateTime.valueOf(tokenTime);
            DateTime timeNow = System.now();
            Long timeNum = (timeNow.getTime() - timeVal.getTime()) / 60000;  //1800 sec
            minutesElapsed = timeNum;
        }
        
        System.debug('Minutes Elapsed::: '+minutesElapsed);
        
        if(devToken == null || tokenTime==null || minutesElapsed > 20){ // also add that if time has expired
            res = http.send(req);
            Map<String, Object> deserializeObj = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            authToken = (string)deserializeObj.get('access_token');
            
            orgCache.put('devToken', authToken); 
            DateTime currTime = System.now();
            orgCache.put('tokenTime', String.valueOf(currTime));   
            system.debug('If part::: '+authToken);
            system.debug('date::: '+tokenTime);
        }else{
            authToken = devToken;
            system.debug('Else part::: '+devToken);
            system.debug('date::: '+tokenTime);
        }
        return authToken;
    } */
    
     
    // don't delete if it is in Pocd1 or Dev3d need to use the below
    @AuraEnabled
    public static String auth(){    
        //Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.Chewy');//change
        Cache.OrgPartition  orgCache = Cache.Org.getPartition('local.DBSDashboard');
        String devToken =  (String) orgCache.get('devToken');  
        String tokenTime =  (String) orgCache.get('tokenTime');        
       
        String authToken;
        Long minutesElapsed = 0;
        
        //Calculate minutes in numbers
        if(tokenTime!=null){
            DateTime timeVal = DateTime.valueOf(tokenTime);
            DateTime timeNow = System.now();
            Long timeNum = (timeNow.getTime() - timeVal.getTime()) / 60000;  //1800 sec
            minutesElapsed = timeNum;
        }
        
        System.debug('Minutes Elapsed::: '+minutesElapsed);
        
        if(devToken == null || tokenTime==null || minutesElapsed > 20){ // also add that if time has expired                         
            JitterbitAuthResponse auth = JitterbitAuth_IH_V1.authenticate2();            
            authToken = auth.token;
            
            orgCache.put('devToken', authToken); 
            DateTime currTime = System.now();
            orgCache.put('tokenTime', String.valueOf(currTime));   
            //system.debug('If part::: '+authToken);
            system.debug('date::: '+tokenTime);
        }else{
            authToken = devToken;
            system.debug('Else part::: '+devToken);
            system.debug('date::: '+tokenTime);
        }
        return authToken;
    } 

    @AuraEnabled 
    public static void downloadPDF(String recordId){
         if(!String.isBlank(recordId)){
            List<Attachment> atts = [SELECT Id FROM Attachment where ParentId =: recordId];
            if(atts.size() > 0){
                delete atts;
            }        
            PageReference pref = Page.SalesCustomerAgreement;
        	pref.getParameters().put('id',recordId);
            Blob b; 
            if(Test.isRunningTest()){
                b = Blob.valueOf('Unit test');
            }else{
                b = pref.getContentAsPDF();  
            }
                                 
        	Attachment attach = new Attachment();
            attach.Name = 'Details.pdf'; 
            if(Test.isRunningTest()){
                attach.Body = Blob.valueOf('Unit test');
            } else{
                attach.Body = pref.getContent();  
            }           
             
        	attach.parentId=recordId;
        	insert attach; 
        }
    } 
    
        
}