/**
  * @description this class used to like: Generate Account Number for savings/Cheque, Send welcome package
  * @version v1.0
  * @since   2020-01-31
  *
  */
  public class BusinessEvolveChequeProdVpl2Con{
    /** 
   * @description getAccountByOppId
   * @param oppId
   * @return String
   */
   @AuraEnabled
   public static String getAccountByOppId(Id oppId){
      return productOnboardingController.getAccountByOppId(oppId);
   
   }
   /** 
   * @description addEstatementDetails
   * @param jsonString
   * @return String
   */
   @AuraEnabled
   public static String addEstatementDetails(String jsonString){
       return productOnboardingController.addEstatementDetails(jsonString);
   }
    /** 
   * @description updateApplication
   * @param TransactionalAccount
   * @param AccountAccess
   * @param ForeignServices
   * @param SurplusCash
   * @param BorrowingRequimentGeneral
   * @param BorrowingrequimentAssestAcquisition
   * @param ProtectionOfServices
   * @param ProtectionOfServicesBusiness
   * @param ProductsAndServices
   * @param Title
   * @param FirstName
   * @param Surname
   * @param Signing_Date
   * @param applicationId
   * @return String
   */
   @AuraEnabled
   public static String updateApplication(String TransactionalAccount, String AccountAccess, String ForeignServices, String SurplusCash, 
                                          String BorrowingRequimentGeneral, String BorrowingrequimentAssestAcquisition, 
                                          String ProtectionOfServices, String ProtectionOfServicesBusiness, String ProductsAndServices,
                                          String Title, String FirstName, String Surname, Date Signing_Date, Id applicationId){
        return productOnboardingController.updateApplication(TransactionalAccount, AccountAccess, ForeignServices, SurplusCash, 
                                           BorrowingRequimentGeneral, BorrowingrequimentAssestAcquisition, 
                                           ProtectionOfServices, ProtectionOfServicesBusiness, ProductsAndServices,
                                            Title, FirstName, Surname, Signing_Date, applicationId);
   }

    /** 
   * @description updateNotifyMe
   * @param Name
   * @param Surname
   * @param ActiveEmail
   * @param PreferredContact
   * @param PreferredLanguage
   * @param AllTransactionType
   * @param Payment
   * @param Withdrawal
   * @param Deposit
   * @param ReturnedTransactions
   * @param ScheduledTransaction
   * @param NotificationTime
   * @param MinimumAmount
   * @param MinimumAmount1
   * @param BalanceUpdate
   * @param SpecificDay
   * @param Purchases
   * @param oppId
   * @return String
   */
   @AuraEnabled
   public static string updateNotifyMe(String Name, String Surname, String ActiveEmail, String PreferredContact, String PreferredLanguage,
                                       String AllTransactionType, String Payment, String Withdrawal, String Deposit,
                                       String ReturnedTransactions, String ScheduledTransaction, String NotificationTime, 
                                       String MinimumAmount, String MinimumAmount1, String BalanceUpdate, 
                                       String SpecificDay, String Purchases,
                                       Id oppId){
        return productOnboardingController.updateNotifyMe(Name, Surname, ActiveEmail, PreferredContact,PreferredLanguage,
        AllTransactionType, Payment, Withdrawal, Deposit,
        ReturnedTransactions,  ScheduledTransaction,NotificationTime, 
        MinimumAmount, MinimumAmount1, BalanceUpdate, SpecificDay, Purchases,
        oppId);
   }
   /** 
   * @description updateInternetBanking
   * @param AccountToBeDebitedMonthlyWithTheCost
   * @param CombiRecordNumber
   * @param NumberOfAuthorisations
   * @param NumberOfMainUsers
   * @param FeeStructureCode
   * @param AbsaOnlineForBusiness
   * @param CellPhoneBanking
   * @param TelephoneBanking
   * @param Notifyme
   * @param FundsTransfer
   * @param BillPayments
   * @param OwnDefinedPayments
   * @param FutureDatedPayments
   * @param StopOrderPayments
   * @param oppID
   * @return String
   */
   @AuraEnabled
   public static String updateInternetBanking(String AccountToBeDebitedMonthlyWithTheCost, String CombiRecordNumber, 
                                              String NumberOfAuthorisations, String NumberOfMainUsers, 
                                              String FeeStructureCode, String AbsaOnlineForBusiness, 
                                              String CellPhoneBanking, String TelephoneBanking, String Notifyme, 
                                              String FundsTransfer, String BillPayments, String OwnDefinedPayments, 
                                              String FutureDatedPayments, String StopOrderPayments, Id oppID){
       return productOnboardingController.updateInternetBanking(AccountToBeDebitedMonthlyWithTheCost, CombiRecordNumber, 
                                              NumberOfAuthorisations,  NumberOfMainUsers, 
                                              FeeStructureCode,  AbsaOnlineForBusiness, 
                                               CellPhoneBanking,  TelephoneBanking, Notifyme, 
                                              FundsTransfer,  BillPayments,  OwnDefinedPayments, 
                                               FutureDatedPayments,  StopOrderPayments, oppID);
   }
   /** 
   * @description isEmpty
   * @param objectToCheck
   * @return Boolean
   */
   
   private static Boolean isEmpty(sObject objectToCheck){
       return (objectToCheck == null);
   }
   /** 
   * @description getSelectedRelatedParty
   * @param acrId
   * @return Map<String, Object>
   */
   @AuraEnabled
   public static Map<String, Object> getSelectedRelatedParty(Id acrId){
      return productOnboardingController.getSelectedRelatedParty(acrId);
   
   }
   /** 
   * @description updateOpportunityAndApplication
   * @param OpportunityId
   * @param applicationRecord
   * @return String
   */
   @AuraEnabled
   public static String updateOpportunityAndApplication(Id OpportunityId, Application__c applicationRecord){
       return productOnboardingController.updateOpportunityAndApplication(OpportunityId,applicationRecord);
   }
    /** 
   * @description getApplicationProducts
   * @param oppId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getApplicationProducts(Id oppId){
       return productOnboardingController.getApplicationProducts(oppId);
   }

   /** 
   * @description getPricingSchemesByProduct : W-004843 
   * @param oppId
   * @return List<Price_Scheme__c>
   */
   @AuraEnabled
   public static List<Price_Scheme__c> getPricingSchemesByProduct(Id oppId){
       return productOnboardingController.getPricingSchemesByProduct(oppId);
   }
   /** 
   * @description getAccount
   * @param oppId
   * @return Account
   */
   @AuraEnabled
   public static Account getAccount(Id oppId){
       return productOnboardingController.getAccount(oppId);
   }
    /** 
   * @description getRelatedParties
   * @param oppId
   * @param submitForCasa
   * @return <Map<String, Object>>
   */
   @AuraEnabled
   public static List<Map<String, Object>> getRelatedParties(Id oppId, Boolean submitForCasa){
       return productOnboardingController.getRelatedParties(oppId,submitForCasa);
   }
    /** 
   * @description getApplicationRecord
   * @param opportunityId
   * @return Application__c
   */
   @AuraEnabled
   public static Application__c getApplicationRecord(Id opportunityId){
       return productOnboardingController.getApplicationRecord(opportunityId);
   }
   /** 
   * @description getApplicationRecord : W-14960 : Anka new changes
   * @param opportunityId
   * @return Application_Product__c
   */
   @AuraEnabled
   public static Application_Product__c getApplicationProductRecord(Id opportunityId){
       //Get Application Linked to the Opportunity based on Product
       List<Application_Product__c> applicationLst = new ApplicationProductSelector().selectIdsByOpportunityId(opportunityId);

       if (!applicationLst.isEmpty() && applicationLst.size() > 0 && applicationLst != null){
           return applicationLst[0];
           
       } else{
           return null;
       }
   }
    /** 
   * @description acceptProductTerms
   * @param OpportunityId
   * @param applicationRecord
   * @return String
   */
   @AuraEnabled
   public static String acceptProductTerms(Id OpportunityId, Application__c applicationRecord){
        return productOnboardingController.acceptProductTerms(OpportunityId,applicationRecord);
   }

   /** 
   * @description getApplicationDetails : Saurabh W-003227
   * @param oppId
   * @return Application__c
   */
   @AuraEnabled
   public static Application__c getApplicationDetails(Id oppId){
       return productOnboardingController.getApplicationDetails(oppId);
   }

   /** 
   * @description saveApplicationDetails : Saurabh W-003227
   * @param value1
   * @param value2
   * @param value3
   * @param value4
   * @param value5
   * @param value6
   * @param value7
   * @param value8
   * @param value9
   * @param value10
   * @param value11
   * @param value12
   * @param value13
   * @param productPurposeText
   * @param value14
   * @param value15
   * @param value16
   * @param value17
   * @param value18
   * @return string
   */
   @AuraEnabled
   public static string saveApplicationDetails(String value1, Double value2, Double value3, string value4, String value5, Double value6,
                                               Date value7, Double value8, Double value9, String value10, Double value11, 
                                               String value12, string value13, 
                                               string productPurposeText, Id value14,String value15, String value16, 
                                               String value17, Integer value18){
         

       return productOnboardingController.saveApplicationDetails( value1,  value2,  value3,  value4,  value5,  value6,
                                                value7,  value8,  value9,  value10,  value11, 
                                                value12,  value13,  productPurposeText,  value14,
                                                 value15,  value16,  value17,  value18);
   }
 
   /** 
   * @description updateApplicationDetails W-14960 : Anka new changes
   * @param purposeofAccP
   * @param purposeofAccTextP
   * @param accActivityCal
   * @param sourceOfFunds
   * @param redirectFees
   * @param transferCreditInterestToAccount
   * @param transferAdminFeeToAccount
   * @param transferCashDepositFeeToAccount
   * @param transferCommitmentFeeToAccount
   * @param transferDebitInterestToAccount
   * @param transferServiceFeeToAccount
   * @param transferTaxLevyToAccount
   * @param transferTransactionFeeToAccount
   * @param transferIncomingUnpaidItemsToAccount
   * @param deliveryMethod
   * @param statementFrequency
   * @param statementDayOfMonth
   * @param accountStream
   * @param deliveryInstruction
   * @param applicationProductId
   * @return String
   */
   @AuraEnabled
   public static string updateApplicationDetails(String  purposeofAccP, String purposeofAccTextP,String accActivityCal, String sourceOfFunds,
                                                 Boolean redirectFees, String transferCreditInterestToAccount, 
                                                 String transferAdminFeeToAccount, 
                                                 String transferCashDepositFeeToAccount,
                                                 String transferCommitmentFeeToAccount,
                                                 String transferDebitInterestToAccount, 
                                                 String transferServiceFeeToAccount, 
                                                 String transferTaxLevyToAccount, 
                                                 String transferTransactionFeeToAccount, 
                                                 String transferIncomingUnpaidItemsToAccount, String deliveryMethod, 
                                                 String statementFrequency, String statementDayOfMonth, String accountStream, 
                                                 String deliveryInstruction,Id applicationProductId){
         // thabo check for values coming here most of them were null while testing
       String returnReponse = null;
       //Application__c appRec = [SELECT Cheque_Card_Required__c, Deposit_Book_Required__c, Source_of_Funds_Savings__c, Re_Direct_Fees__c, Transfer_credit_interest_to_account__c, Transfer_admin_fee_to_account__c, Transfer_commitment_fee_to_account__c, Transfer_debit_interest_to_account__c, Transfer_service_fee_to_account__c, Transfer_tax_levy_to_account__c, Transfer_transaction_fee_to_account__c, Transfer_incoming_unpaid_items_to_accoun__c, Delivery_Method__c, Statement_Frequency__c, Statement_Day_of_the_month__c, Account_Stream__c, Delivery_Instruction__c, Accrual_Day_of_Month__c, Capitilisation_Day_of_Week__c, Capitilisation_Day_of_Month__c, Charge_Capitalization_Date__c, Charge_Type__c, Charge_Capitalization_Type__c, Charge_Capitalization_Frequency__c, Accrual_Day_of_Week__c
                                //FROM Application__c
                                //where Id = :applicationId];
        /*Application_Product__c appRec = [SELECT Purpose_of_Account__c,Purpose_of_Account_Text__c,Account_Activity_Calculator__c,Source_of_Funds_Savings__c, Re_Direct_Fees__c, 
                                         Transfer_credit_interest_to_account__c, Transfer_admin_fee_to_account__c, Transfer_commitment_fee_to_account__c, Transfer_debit_interest_to_account__c, Transfer_service_fee_to_account__c, Transfer_tax_levy_to_account__c,
                                         Transfer_transaction_fee_to_account__c, Transfer_incoming_unpaid_items_to_accoun__c,
                                          Delivery_Method__c, Statement_Frequency__c, Statement_Day_of_the_month__c, 
                                         Account_Stream__c, Accrual_Day_of_Month__c, 
                                         Capitilisation_Day_of_Week__c, Capitilisation_Day_of_Month__c, 
                                         Charge_Capitalization_Date__c, Charge_Type__c, Charge_Capitalization_Type__c,
                                         Charge_Capitalization_Frequency__c, Accrual_Day_of_Week__c,Application__c,
                                         Application__r.Opportunity__c
                                FROM Application_Product__c
                                where Id = :applicationProductId]; */
       Application_Product__c appRec = new ApplicationProductSelector().selectApplicationProductById(applicationProductId);
       //system.debug('>>>' + appRec);
       //system.debug('deliveryMethod' + deliveryMethod);

       //appRec.Cheque_Card_Required__c = requireChequeCard;  //commented due to value error @thabo to take a look
       //appRec.Deposit_Book_Required__c = requireDepositBook; //commented due to value error
       
       appRec.Purpose_of_Account__c = purposeofAccP;
       appRec.Purpose_of_Account_Text__c = purposeofAccTextP;
       appRec.Account_Activity_Calculator__c  = accActivityCal;                                      
                                                     
       appRec.Delivery_Method__c = deliveryMethod;
       appRec.Statement_Frequency__c = statementFrequency;
       appRec.Source_of_Funds_Savings__c = sourceOfFunds;
       appRec.Statement_Day_of_the_month__c = statementDayOfMonth;
       appRec.Account_Stream__c = accountStream;
       //appRec.Delivery_Instruction__c = deliveryInstruction;
       //W-13221                                                        
       /*appRec.Accrual_Day_of_Month__c = accrualDayOfMonth;
       appRec.Capitilisation_Day_of_Week__c = capitilisationDayOfWeek;
       appRec.Capitilisation_Day_of_Month__c = capitilisationDayOfMonth;
       appRec.Accrual_Day_of_Week__c = accrualDayOfWeek;*/

       //Changes Start for W-004995 by Chandra dated 12/06/2020
       appRec.Re_Direct_Fees__c = redirectFees;
       appRec.Transfer_credit_interest_to_account__c = transferCreditInterestToAccount;
       appRec.Transfer_admin_fee_to_account__c = transferAdminFeeToAccount;
       appRec.Transfer_cash_deposit_fee_to_account__c = transferCashDepositFeeToAccount;
       appRec.Transfer_commitment_fee_to_account__c = transferCommitmentFeeToAccount;
       appRec.Transfer_debit_interest_to_account__c = transferDebitInterestToAccount;
       appRec.Transfer_service_fee_to_account__c = transferServiceFeeToAccount;
       appRec.Transfer_tax_levy_to_account__c = transferTaxLevyToAccount;
       appRec.Transfer_transaction_fee_to_account__c = transferTransactionFeeToAccount;
       appRec.Transfer_incoming_unpaid_items_to_accoun__c = transferIncomingUnpaidItemsToAccount;
       //Changes end for W-004995 by Chandra dated 12/06/2020

       //Changes Start for W-004989 by Gopi dated 16/06/2020
       //W-13221
     /*appRec.Charge_Type__c = chargeType;
       appRec.Charge_Capitalization_Type__c = chargeCapitalType;
       appRec.Charge_Capitalization_Frequency__c = chargeFreq;
       appRec.Charge_Capitalization_Date__c = chargeCapDate;*/

       // need to do better handling of exception and return response @thabo
       try{
           //system.debug('appRec' + appRec);
           update appRec;
           updateApplicationRec(appRec);
           returnReponse = 'updated the application record';
           
       } catch (exception e){
           returnReponse = 'Failed to update record';
       }
       return returnReponse;
   }

   /** 
   * @description updateApplicationROADetails used to Update ROA Information T Senkomane : W-14960 : Anka new change
   * @param delegatesMeetingDate
   * @param delegatesAtMeeting
   * @param netAssetValue
   * @param currentSituation
   * @param currentProductXP
   * @param needsOrObjectives
   * @param typicalmacroOrSectorial
   * @param othermacroOrSectorial
   * @param generalNotes
   * @param priorProduct
   * @param productConsidered
   * @param productRecommended
   * @param reasonNotRecommended
   * @param presentationName
   * @param presentationGroupName
   * @param presentationDate
   * @param presentationLocation
   * @param presentationFolioNo
   * @param firstName
   * @param surname
   * @param designation
   * @param dateVal
   * @param adviseGiven
   * @param underSupervision
   * @param isReplacingProduct
   * @param applicationProductId
   * @return String 
   */
   @AuraEnabled
   public static string updateApplicationROADetails(Date delegatesMeetingDate, String delegatesAtMeeting, 
                                                    Double netAssetValue, String currentSituation, 
                                                    String currentProductXP, String needsOrObjectives, 
                                                    String typicalmacroOrSectorial, String othermacroOrSectorial, 
                                                    String generalNotes, String priorProduct, 
                                                    String productConsidered, String productRecommended,
                                                    String reasonNotRecommended, String presentationName, 
                                                    String presentationGroupName, Date presentationDate, 
                                                    String presentationLocation, String presentationFolioNo, 
                                                    String firstName, String surname, String designation,
                                                    Date dateVal, String adviseGiven, String underSupervision, 
                                                    String isReplacingProduct, Id applicationProductId){
       String returnReponse = null;
       /*Application__c appRec = [SELECT Delegates_at_Meeting__c, Net_Asset_Value__c, Current_Situation__c, Current_Finacial_Product_Experience__c, Needs_or_Objectives__c, Macro_or_Sectorial_Firm__c, Other_Macro_or_Sectorial_Comments__c, General_Notes__c, Did_Client_Select_Product__c, Produts_Considered__c, Product_Recommended_to_Client__c, Reason_why_Recommended_not_Recommended__c, Presentation_Name__c, Presentation_Group_Name__c, Presentation_Date__c, Presentation_Location__c, Presentation_Folio_Number__c, First_Name__c, Surname__c, Designation__c, Date__c, Advice_Given__c, Client_Under_Supervision__c, Replacing_an_Existing_Product__c, Delegates_Meeting_Date__c
                                FROM Application__c
                                where Id = :applicationId];*/
       /*Application_Product__c appRec = [SELECT Delegates_at_Meeting__c, Net_Asset_Value__c, Current_Situation__c, Current_Finacial_Product_Experience__c, Needs_or_Objectives__c, Macro_or_Sectorial_Firm__c, Other_Macro_or_Sectorial_Comments__c, General_Notes__c, Did_Client_Select_Product__c, Produts_Considered__c, Product_Recommended_to_Client__c, Reason_why_Recommended_not_Recommended__c, Presentation_Name__c, Presentation_Group_Name__c, Presentation_Date__c, Presentation_Location__c, Presentation_Folio_Number__c, First_Name__c, Surname__c, Designation__c, Date__c, Advice_Given__c, Client_Under_Supervision__c, Replacing_an_Existing_Product__c, Delegates_Meeting_Date__c
                                FROM Application_Product__c
                                where Id = :applicationProductId];*/
       Application_Product__c appRec = new ApplicationProductSelector().selectApplicationProductById(applicationProductId);                                                 

       //system.debug('>>>' + appRec);

       appRec.Delegates_Meeting_Date__c = delegatesMeetingDate;
       appRec.Delegates_at_Meeting__c = delegatesAtMeeting;
       appRec.Net_Asset_Value__c = netAssetValue;
       appRec.Current_Situation__c = currentSituation;
       appRec.Current_Finacial_Product_Experience__c = currentProductXP;
       appRec.Needs_or_Objectives__c = needsOrObjectives;
       appRec.Macro_or_Sectorial_Firm__c = typicalmacroOrSectorial;
       appRec.Other_Macro_or_Sectorial_Comments__c = othermacroOrSectorial;
       appRec.General_Notes__c = generalNotes;
       appRec.Did_Client_Select_Product__c = priorProduct;
       appRec.Produts_Considered__c = productConsidered;
       appRec.Product_Recommended_to_Client__c = productRecommended;
       appRec.Reason_why_Recommended_not_Recommended__c = reasonNotRecommended;
       appRec.Presentation_Name__c = presentationName;
       appRec.Presentation_Group_Name__c = presentationGroupName;
       appRec.Presentation_Date__c = presentationDate;
       appRec.Presentation_Location__c = presentationLocation;
       appRec.Presentation_Folio_Number__c = presentationFolioNo;
       appRec.First_Name__c = firstName;
       appRec.Surname__c = surname;
       appRec.Designation__c = designation;
       appRec.Date__c = dateVal;
       appRec.Replacing_an_Existing_Product__c = isReplacingProduct;
       appRec.Client_Under_Supervision__c = underSupervision;
       appRec.Advice_Given__c = adviseGiven;
       try{
           update appRec;
           updateApplicationProdROADetails(appRec);
           returnReponse = 'updated the application ROA record';
       } catch (exception e){
           returnReponse = 'Failed to update record';
       }
       return returnReponse;
   }
   /** 
   * @description updateApplicationProdROADetails
   * @param appProdRec
   */
   public static void updateApplicationProdROADetails(Application_Product__c appProdRec){
       if(appProdRec != null){
           Application__c appRec = new Application__c();
           appRec.Id = appProdRec.Application__c;
           appRec.Delegates_Meeting_Date__c = appProdRec.Delegates_Meeting_Date__c;
           appRec.Delegates_at_Meeting__c = appProdRec.Delegates_at_Meeting__c;
           appRec.Net_Asset_Value__c = appProdRec.Net_Asset_Value__c;
           appRec.Current_Situation__c = appProdRec.Current_Situation__c;
           appRec.Current_Finacial_Product_Experience__c = appProdRec.Current_Finacial_Product_Experience__c;
           appRec.Needs_or_Objectives__c = appProdRec.Needs_or_Objectives__c;
           appRec.Macro_or_Sectorial_Firm__c = appProdRec.Macro_or_Sectorial_Firm__c;
           appRec.Other_Macro_or_Sectorial_Comments__c = appProdRec.Other_Macro_or_Sectorial_Comments__c;
           appRec.General_Notes__c = appProdRec.General_Notes__c;
           appRec.Did_Client_Select_Product__c = appProdRec.Did_Client_Select_Product__c;
           appRec.Produts_Considered__c = appProdRec.Produts_Considered__c;
           appRec.Product_Recommended_to_Client__c = appProdRec.Product_Recommended_to_Client__c;
           appRec.Reason_why_Recommended_not_Recommended__c = appProdRec.Reason_why_Recommended_not_Recommended__c;
           appRec.Presentation_Name__c = appProdRec.Presentation_Name__c ;
           appRec.Presentation_Group_Name__c = appProdRec.Presentation_Group_Name__c;
           appRec.Presentation_Date__c = appProdRec.Presentation_Date__c;
           appRec.Presentation_Location__c = appProdRec.Presentation_Location__c;
           appRec.Presentation_Folio_Number__c = appProdRec.Presentation_Folio_Number__c;
           appRec.First_Name__c = appProdRec.First_Name__c;
           appRec.Surname__c = appProdRec.Surname__c;
           appRec.Designation__c = appProdRec.Designation__c;
           appRec.Date__c = appProdRec.Date__c;
           appRec.Replacing_an_Existing_Product__c = appProdRec.Replacing_an_Existing_Product__c;
           appRec.Client_Under_Supervision__c = appProdRec.Client_Under_Supervision__c;
           appRec.Advice_Given__c = appProdRec.Advice_Given__c;
           update appRec;
       }
       
       
   }
   /** 
   * @description sendWelcomePackage
   * @param oppid
   */
   @AuraEnabled
   public static void sendWelcomePackage(Id oppid){
       productOnboardingController.sendWelcomePackage(oppid);
   }
   /** 
   * @description ComposeEmail
   * @param whatId
   * @param targetObjectId
   * @param templateName
   * @param emailaddress
   * @param htmlbody
   * @param subject
   * @return List<Messaging.SingleEmailMessage>
   */
   public static List<Messaging.SingleEmailMessage> ComposeEmail(Id whatId, Id targetObjectId, String templateName, 
                                                                 string emailaddress, string htmlbody,String subject){
       return productOnboardingController.ComposeEmail(whatId, targetObjectId, templateName, 
                                                                 emailaddress, htmlbody,subject);
   }

   /** 
   * @description getCurrentUserDetail
   * @return List<User>
   */
   @AuraEnabled
   public static List<User> getCurrentUserDetail(){
       return productOnboardingController.getCurrentUserDetail();
   }
 
   /** 
   * @description updateSavingsAccountGeneral updating Application record with General savings account information : W-14960 : Anka new changes
   * @param oppid
   * @param applicationProdRecord
   * @return String
   */
   @AuraEnabled
   public static string updateSavingsAccountGeneral(Id oppid, string applicationProdRecord){
       try{
           savingsgeneralaccwrapper wr = (savingsgeneralaccwrapper)System.JSON.deserialize(applicationProdRecord, savingsgeneralaccwrapper.class);
           //Application__c appRec = new ApplicationsSelector().selectById(wr.id);
           //system.debug('wr_1022_'+wr.Id);
           Application_Product__c appProdRec = new ApplicationProductSelector().selectApplicationProductById(wr.id);
           
           if (appProdRec != null){
               appProdRec.Meeting_Of__c = wr.MeetingOf;
               appProdRec.Purpose_of_Account__c = wr.purposeOfAccount;
               appProdRec.Purpose_of_Account_Text__c = wr.purposeOfAccountText;
               appProdRec.Account_Activity_Calculator__c = wr.accountActivityCalculator;
               appProdRec.Meeting_Held_At__c = wr.MeetingHeldAt;
               appProdRec.Meeting_Date__c = wr.MeetingDate;
               appProdRec.Extract_signed_date__c = wr.Extractsigneddate;
               appProdRec.Total_number_of_accounts_to_be_Open__c = wr.Totalnumofaccountstobeopened;
               appProdRec.Req_NumOf_signs_to_Open_Close_Accounts__c = wr.Requirednumberofsignatoriestoopencloseaccounts;
               //appRec.Required_numof_signatories_to_give_instr__c = wr.Requirednumofsignatoriestogiveinstructions;
               appProdRec.Source_of_Funds_Savings__c = wr.SourceofFundssavings;
               //system.debug('wr.SourceofFundssavings ' + wr.SourceofFundssavings);
               appProdRec.Comments_on_explanation_given_for_Source__c = wr.CommentsonexplanationgivenforSourceoffunds;
               appProdRec.Customer_Region__c = wr.CustomerRegion; //added by Manish for W-010115
               appProdRec.Is_there_a_Transfer_to_be_performed_for__c = wr.IsThereAnyTPFTP; //added by Manish for W-010115
               Update appProdRec;
           }
           return 'SUCCESS';
       } catch (Exception e){
           //system.debug(e.getMessage());
           return 'FAILURE';
       }
   }

   /** 
   * @description getOppData Added by diksha for genrating AcctNumber for Chq & Savings: PriceSchemeCode : W-005411 - ANKA GANTA : 2020-08-11
   * @param oppId
   * @param PriceSchemeCode
   * @return List<DisplayProducts>
   */
   public static OpportunityLineItem oppproduct;
   @AuraEnabled
   public static List<DisplayProducts> getOppData(String oppId, String PriceSchemeCode){

       Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
       Account acc = new AccountsSelector().selectByOpportunityId(oppId);
       List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
       oppproduct = new OpportunityLineItemsSelector().selectByOppId(oppId, 1);
       List<Application__c> app = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
       Map<String, string> sourceOfFundTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName(StringConstants.CHEQUE_SERVICE_OR_SAVINGS, StringConstants.DIRECTION_OUTBOUND);//Added by Chandra against W-004996 dated 25/6/2020
       List<String> sourceOfFundsVals = app[0].Source_of_Funds_Savings__c.split(';');//Added by Chandra against W-004996 dated 20/6/2020
       List<Electronic_Site__mdt> electronicSites = new List<Electronic_Site__mdt>([SELECT Id, DeveloperName, Label, Site_Code__c
                                                                                    FROM Electronic_Site__mdt]);

       String srcOfFnds1 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds2 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds3 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds4 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds5 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String errorMessage = '';

       //Determine electronic site based on Business Unit
       Integer electronicsite = 0;
   /*   if (userRec[0].SiteCode__c != null){
           electronicsite = Integer.ValueOf(userRec[0].SiteCode__c);
       } */
       
      //string electronicsite = System.Label.ElectronicSiteForAccount; diksha 12/3/2020
      
       if(acc.Business_Unit__c == 'Wealth Banking' || acc.Business_Unit__c == 'WIMI' || acc.Business_Unit__c == 'Private Banking') {
           electronicsite = Integer.ValueOf(userRec[0].SiteCode__c);
       } else {
           electronicsite = Integer.ValueOf(System.Label.ElectronicSiteForAccount);
       }


       Integer accountNbr = 0;
       Integer openSite = electronicsite;  //electronicsite;
       Integer controlSite = electronicsite;       //opp.site__r.site_code__c;
       String cifKey = opp.CIF_Number__c;
       Integer tellerNbr = 0;
       if (userRec[0].Teller_Operator_Code__c != null){
           tellerNbr = Integer.ValueOf(userRec[0].Teller_Operator_Code__c);
       }
       Integer controllerNbr = 999999;
       Integer workstationNbr = 0;
       Integer product = 0;
       if (oppproduct.ProductCode != null){
           product = Integer.ValueOf(oppproduct.ProductCode);
       }
       Integer applicationNbr = 0;
       String controlSiteType = '034';
       String openSiteType = '034';
       Integer marketersCode = 0;
       Integer effectiveDate = Integer.ValueOf((string.valueof(System.today())).replace('-', ''));
       if (userRec[0].EmployeeNumber != null){
           marketersCode = Integer.ValueOf(userRec[0].EmployeeNumber); //'0' Added by Diksha 17/08/2020
       }
       String provChqBookInd = 'N';
       String cbpSchemeCode = PriceSchemeCode;//Added by Anka Ganta :W-005411
       Integer cbpPrimaryAccount = 0;

       //Changes Start for W-004996 by Chandra dated 20/06/2020
       if (sourceOfFundsVals.size() >= 1 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[0]))){
           srcOfFnds1 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[0]);
       }
       if (sourceOfFundsVals.size() >= 2 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[1]))){
           srcOfFnds2 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[1]);
       }
       if (sourceOfFundsVals.size() >= 3 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[2]))){
           srcOfFnds3 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[2]);
       }
       if (sourceOfFundsVals.size() >= 4 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[3]))){
           srcOfFnds4 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[3]);
       }
       if (sourceOfFundsVals.size() >= 5 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[4]))){
           srcOfFnds5 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[4]);
       }
       //Changes end for W-004996 by Chandra dated 20/06/2020

       String digitalChannel = 'B';
       String rbaEdd = '';
       //Adding for Savings
       String rbaEddRating = opp.Risk_Rating__c;
       Map<String, string> rbaEddRatingTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName('Savings', 'Outbound');//Added by Diksha for Savings dated 20/7/2020
       //system.debug('rbaEddRatingTranslatedMap' + rbaEddRatingTranslatedMap);

       if (!rbaEddRatingTranslatedMap.isEmpty() && rbaEddRatingTranslatedMap != null){
           rbaEddRating = rbaEddRatingTranslatedMap.get(rbaEddRating);
           //system.debug('String rbaEddRating' + rbaEddRating);
       }

       List<DisplayProducts> displayproductList = new List<DisplayProducts>();
       DisplayProducts dspr = new DisplayProducts();
       dspr.Client = acc.Name;
       dspr.Account = oppproduct.Name;
       if (oppproduct.Policy_Number__c != '' && oppproduct.Policy_Number__c != null){
           dspr.AccountNumber = oppproduct.Policy_Number__c;
       } else if (String.isBlank(oppproduct.Policy_Number__c)){
           if (oppproduct.Product2.family == 'cheque' && openSite != null && controlSite != null && cifKey != null && tellerNbr != null && product != null && srcOfFnds1 != null){
               opportunityLineItem AcctnumberCQ = callCQcreateAcct(accountNbr, openSite, controlSite, cifKey, tellerNbr, controllerNbr, workstationNbr, product, applicationNbr, controlSiteType, openSiteType, effectiveDate, marketersCode, provChqBookInd, cbpSchemeCode, cbpPrimaryAccount, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, digitalChannel, rbaEdd);
               //system.debug('AcctnumberCQ' + AcctnumberCQ);
               try{
                   if (AcctnumberCQ != null){
                        AcctnumberCQ.Price_Scheme_Code__c =  PriceSchemeCode;
                        update AcctnumberCQ;
                    }
                   dspr.AccountNumber = AcctnumberCQ.Policy_Number__c;
               } catch (Exception e){
                   //system.debug('Error Message :' + e.getMessage()+'Error Cause :' + e.getCause()+'Error Where:' + e.getLineNumber());
                   throw new AuraHandledException('Error: ' + errorMessage);
               }
           } else if (oppproduct.Product2.family == 'SAVINGS'){
               opportunityLineItem UpdatedLineItem = getAccountNumber(opp.id, oppproduct.Id, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEddRating);//Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
               try{
                   if (UpdatedLineItem != null)
                       update UpdatedLineItem;
                   dspr.AccountNumber = UpdatedLineItem.Policy_Number__c;
               } catch (Exception e){
                   //system.debug('Error Message :' + e.getMessage()+'Error Cause :' + e.getCause()+'Error Where:' + e.getLineNumber());
                   throw new AuraHandledException('Error: ' + errorMessage);
               }
           }
       }

       displayproductList.add(dspr);
       //system.debug('displayproductList' + displayproductList);
       return displayproductList;
   }
   /** 
   * @description fetchAccountDetails
   * @param accountId
   * @return Account
   */
   @AuraEnabled
   public static Account fetchAccountDetails(String accountId){
       return productOnboardingController.fetchAccountDetails(accountId);
   }

   /** 
   * @description callCQcreateAcct TdB - 06/11/2020 Change service to use CQcreateAndLinkAccountV8
   * @param accountNbr
   * @param openSite
   * @param controlSite
   * @param cifKey
   * @param tellerNbr
   * @param controllerNbr
   * @param workstationNbr
   * @param product
   * @param applicationNbr
   * @param controlSiteType
   * @param openSiteType
   * @param effectiveDate
   * @param marketersCode
   * @param provChqBookInd
   * @param cbpSchemeCode
   * @param cbpPrimaryAccount
   * @param srcOfFnds1
   * @param srcOfFnds2
   * @param srcOfFnds3
   * @param srcOfFnds4
   * @param srcOfFnds5
   * @param digitalChannel
   * @param rbaEdd
   * @return OpportunityLineItem
   */
   public static OpportunityLineItem callCQcreateAcct(Integer accountNbr, Integer openSite, Integer controlSite, String cifKey, Integer tellerNbr, 
                                                      Integer controllerNbr, Integer workstationNbr, Integer product, Integer applicationNbr, 
                                                      String controlSiteType, String openSiteType, Integer effectiveDate, Integer marketersCode,
                                                      String provChqBookInd, String cbpSchemeCode, Integer cbpPrimaryAccount, 
                                                      String srcOfFnds1, String srcOfFnds2, String srcOfFnds3, 
                                                      String srcOfFnds4, String srcOfFnds5, 
                                                      String digitalChannel, String rbaEdd){
        try{
            String errorMessage = '';

            CQcreateAndLinkAccountV8_Req_IB_v1 requestBean = new CQcreateAndLinkAccountV8_Req_IB_v1();
            requestBean.NBSAPDPI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSAPDPI();
            requestBean.NBSAPDPI.NBSAPLI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSAPLI();
            requestBean.MSGI = new CQcreateAndLinkAccountV8_Req_IB_v1.MSGI();
            requestBean.MSGI.NBSMSGI = new CQcreateAndLinkAccountV8_Req_IB_v1.NBSMSGI();
            requestBean.CQS411I = new CQcreateAndLinkAccountV8_Req_IB_v1.CQS411I();
            requestBean.CQS411I.CQN411I_INPUT_AREA = new CQcreateAndLinkAccountV8_Req_IB_v1.CQN411I_INPUT_AREA();

            requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
            requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
            requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'N';

            requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
            requestBean.MSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

            requestBean.CQS411I.CQN411I_INPUT_AREA.accountNbr = accountNbr;
            requestBean.CQS411I.CQN411I_INPUT_AREA.openSite = openSite;
            requestBean.CQS411I.CQN411I_INPUT_AREA.controlSite = controlSite;
            requestBean.CQS411I.CQN411I_INPUT_AREA.cifKey = cifKey;
            requestBean.CQS411I.CQN411I_INPUT_AREA.tellerNbr = tellerNbr;
            requestBean.CQS411I.CQN411I_INPUT_AREA.controllerNbr = controllerNbr;
            requestBean.CQS411I.CQN411I_INPUT_AREA.workstationNbr = workstationNbr;
            requestBean.CQS411I.CQN411I_INPUT_AREA.product = product;
            requestBean.CQS411I.CQN411I_INPUT_AREA.applicationNbr = applicationNbr;
            requestBean.CQS411I.CQN411I_INPUT_AREA.controlSiteType = controlSiteType;
            requestBean.CQS411I.CQN411I_INPUT_AREA.openSiteType = openSiteType;
            requestBean.CQS411I.CQN411I_INPUT_AREA.effectiveDate = effectiveDate;
            requestBean.CQS411I.CQN411I_INPUT_AREA.marketersCode = marketersCode;
            requestBean.CQS411I.CQN411I_INPUT_AREA.provChqBookInd = provChqBookInd;
            requestBean.CQS411I.CQN411I_INPUT_AREA.cbpSchemeCode = cbpSchemeCode;
            requestBean.CQS411I.CQN411I_INPUT_AREA.cbpPrimaryAccount = cbpPrimaryAccount;
            requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds1 = srcOfFnds1;
            requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds2 = srcOfFnds2;
            requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds3 = srcOfFnds3;
            requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds4 = srcOfFnds4;
            requestBean.CQS411I.CQN411I_INPUT_AREA.SourceOfFunds5 = srcOfFnds5;
            requestBean.CQS411I.CQN411I_INPUT_AREA.digitalChannel = digitalChannel;
            requestBean.CQS411I.CQN411I_INPUT_AREA.rbaEdd = rbaEdd;
            requestBean.CQS411I.CQN411I_INPUT_AREA.odRequired = 'N';
            CQcreateAndLinkAccountV8_Resp_IB_v1 responseBean = CQcreateAndLinkAccountV8_IH_v1.CQcreateAndLinkAccountV8(requestBean);
            if (responseBean != null && responseBean.CQS411O != null && responseBean.CQS411O.outputErrorMessage != null && responseBean.CQS411O.outputErrorMessage.AccountNbrOut != null && responseBean.CQS411O.outputErrorMessage.AccountNbrOut != 0){
                Long accountnumber = responseBean.CQS411O.outputErrorMessage.AccountNbrOut;
                oppproduct.Policy_Number__c = String.valueOf(accountnumber).replaceFirst('^0+', '');
                oppproduct.Account_Opening_Date__c = System.today(); // W-007746 - Tinashe Shoko
            } else if (responseBean != null && responseBean.MSGO != null && responseBean.MSGO.NBSMSGO3 != null && responseBean.MSGO.NBSMSGO3.NBNMSGO3_MSG_ENTRY != null){
                for (CQcreateAndLinkAccountV8_Resp_IB_v1.NBNMSGO3_MSG_ENTRY eachError : responseBean.MSGO.NBSMSGO3.NBNMSGO3_MSG_ENTRY){
                    errorMessage = errorMessage + eachError.NBNMSGO3_MSG_TXT + ' ';
                }
            } else{
                errorMessage = 'Exception Occured with CQcreateAndLinkAccountV8, please contact your System Admin ';
            }
            if (errorMessage != null && errorMessage != ''){
                String m = 'Exception Occured, CQcreateAndLinkAccountV8 Service : ' + errorMessage;
                AuraHandledException e = new AuraHandledException(m);
                e.setMessage(m);
                throw e;
            }
        } catch (Exception exc){
            throw new AuraHandledException(exc.getMessage());
        }
        return oppproduct;
    }

 /** 
   * @description DisplayProducts Wrapper Class To display product in Account Information
   */
   public class DisplayProducts{
       /** 
      * @description 
      * @return String
       */
       @auraEnabled
       public String Client{ get; set; }
       /** 
      * @description 
      * @return String
       */
       @auraEnabled
       public String Account{ get; set; }
       /** 
      * @description 
      * @return String
       */
       @auraEnabled
       public string AccountNumber{ get; set; }
   }
   
   /** 
   * @description getAccountNumber : savings account //Added By Srikanth
   * @param oppId
   * @param oppProductId
   * @param srcOfFnds1
   * @param srcOfFnds2
   * @param srcOfFnds3
   * @param srcOfFnds4
   * @param srcOfFnds5
   * @param rbaEddRating
   * @return OpportunityLineItem
   */
   @AuraEnabled
   public static OpportunityLineItem getAccountNumber(String oppId, String oppProductId, String srcOfFnds1, 
                                                      String srcOfFnds2, String srcOfFnds3, String srcOfFnds4, 
                                                      String srcOfFnds5, String rbaEddRating){
       
     return productOnboardingController.getAccountNumber( oppId,  oppProductId,  srcOfFnds1, 
                                                       srcOfFnds2,  srcOfFnds3,  srcOfFnds4, 
                                                       srcOfFnds5,  rbaEddRating);
   }
   /** 
   * @description showopplineitem
   * @param oppid
   * @param productid
   * @return opportunitylineitem
   */
   @AuraEnabled
   public static opportunitylineitem showopplineitem(Id oppid, Id productid){
      return productOnboardingController.showopplineitem( oppid, productid);
   }
    
   /** 
   * @description changeAccountDomicile //Mbuyiseni Mbhokane: Added the domicile change Method
   * @param accNumber
   * @param bankerSiteCode
   * @return string
   */
   @AuraEnabled
   public static string changeAccountDomicile(string accNumber, string bankerSiteCode){
       return productOnboardingController.changeAccountDomicile(accNumber, bankerSiteCode);
   }
   /** 
   * @description getApplicationProductsV2 
   * @param oppId
   * @param oppLineId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getApplicationProductsV2(Id oppId, String oppLineId){
     return productOnboardingController.getApplicationProductsV2(oppId, oppLineId);
   }
   /** 
   * @description updateProductPriceScheme //added by Lesibe
   * @param oppId
   * @param selectedSchemeCode
   * @return String
   */
   @AuraEnabled
   public static String updateProductPriceScheme(Id oppId,String selectedSchemeCode){
       
       return productOnboardingController.updateProductPriceScheme(oppId, selectedSchemeCode);
   }    
   
   /** 
   * @description getOpportunityLineItems //added by Mbuyiseni
   * @param opportunityId
   * @return List<Map<String, String>>
   */
   @AuraEnabled
   public static List<Map<String, String>> getOpportunityLineItems(Id opportunityId){

     return productOnboardingController.getOpportunityLineItems(opportunityId);
   }

   /** 
   * @description getOpportunityLineItemDetails //added by Mbuyiseni
   * @param opportunityId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getOpportunityLineItemDetails(Id opportunityId){
       return productOnboardingController.getOpportunityLineItemDetails(opportunityId);
   }
   /** 
   * @description getOppLineItem
   * @param oppid
   * @param componentFamily
   * @return opportunitylineitem
   */
   @AuraEnabled
   public static opportunitylineitem getOppLineItem(Id oppid, String componentFamily){
       return productOnboardingController.getOppLineItem(oppid,componentFamily);
   }

   /** 
   * @description getPricingSchemesByProductV2
   * @param oppId
   * @param oppLineId
   * @return List<Price_Scheme__c>
   */
   @AuraEnabled
   public static List<Price_Scheme__c> getPricingSchemesByProductV2(Id oppId, String oppLineId){
        return productOnboardingController.getPricingSchemesByProductV2(oppId,oppLineId);
   }
    /** 
   * @description getPricingSchemesByProductV2
   * @param oppId
   * @param PriceSchemeCode
   * @param oppLineId
   * @return List<Price_Scheme__c>
   */
   @AuraEnabled
   public static List<DisplayProducts> getOppDataV2(String oppId, String PriceSchemeCode, String oppLineId){

       Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
       Account acc = new AccountsSelector().selectByOpportunityId(oppId);
       List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
       oppproduct = new OpportunityLineItemsSelector().selectById(oppLineId)[0];
       //system.debug('++-=-=-++-=-=-=Inside GetOppoDataV2 oppproduct -=-= ' + oppproduct);
       List<Application__c> app = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
       //system.debug('++-=-=-++-=-=-=Inside GetOppoDataV2 app-=-= ' + app);
       Map<String, string> sourceOfFundTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName(StringConstants.CHEQUE_SERVICE_OR_SAVINGS, StringConstants.DIRECTION_OUTBOUND);//Added by Chandra against W-004996 dated 25/6/2020
       List<String> sourceOfFundsVals = app[0].Source_of_Funds_Savings__c?.split(';');//Added by Chandra against W-004996 dated 20/6/2020
       List<Electronic_Site__mdt> electronicSites = new List<Electronic_Site__mdt>([SELECT Id, DeveloperName, Label, Site_Code__c
                                                                                    FROM Electronic_Site__mdt]);

       String srcOfFnds1 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds2 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds3 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds4 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String srcOfFnds5 = '';//Added by Chandra against W-004996 dated 20/6/2020
       String errorMessage = '';

       //Determine electronic site based on Business Unit
       Integer electronicsite = 0;
       //string electronicsite = System.Label.ElectronicSiteForAccount;
       for (Electronic_Site__mdt eachSite : electronicSites){
           if (acc.Business_Unit__c == eachSite.DeveloperName){
               if (eachSite.Site_Code__c != null){
                   electronicsite = Integer.ValueOf(eachSite.Site_Code__c);
               }
           } else if (eachSite.DeveloperName == 'Default'){
               if (eachSite.Site_Code__c != null){
                   electronicsite = Integer.ValueOf(eachSite.Site_Code__c);
               }
           }
       }

       Integer accountNbr = 0;
       Integer openSite = electronicsite;  //electronicsite;
       Integer controlSite = electronicsite;       //opp.site__r.site_code__c;
       String cifKey = opp.CIF_Number__c;
       Integer tellerNbr = 0;
       if (userRec[0].Teller_Operator_Code__c != null){
           tellerNbr = Integer.ValueOf(userRec[0].Teller_Operator_Code__c);
       }
       Integer controllerNbr = 999999;
       Integer workstationNbr = 0;
       Integer product = Integer.ValueOf(oppproduct.ProductCode);
       Integer applicationNbr = 0;
       String controlSiteType = '034';
       String openSiteType = '034';
       Integer effectiveDate = Integer.ValueOf((string.valueof(System.today())).replace('-', ''));
       Integer marketersCode = 0;
       if (userRec[0].EmployeeNumber != null){
           marketersCode = Integer.ValueOf(userRec[0].EmployeeNumber);
       }
       String provChqBookInd = 'N';
       String cbpSchemeCode = PriceSchemeCode;//Added by Anka Ganta :2020-08-11
       Integer cbpPrimaryAccount = 0;

       //Changes Start for W-004996 by Chandra dated 20/06/2020
       if(sourceOfFundsVals!=null){  //added null check
       if (sourceOfFundsVals.size() >= 1 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[0]))){
           srcOfFnds1 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[0]);
       }
       if (sourceOfFundsVals.size() >= 2 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[1]))){
           srcOfFnds2 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[1]);
       }
       if (sourceOfFundsVals.size() >= 3 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[2]))){
           srcOfFnds3 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[2]);
       }
       if (sourceOfFundsVals.size() >= 4 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[3]))){
           srcOfFnds4 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[3]);
       }
       if (sourceOfFundsVals.size() >= 5 && String.isNotEmpty(sourceOfFundTranslatedMap.get(sourceOfFundsVals[4]))){
           srcOfFnds5 = sourceOfFundTranslatedMap.get(sourceOfFundsVals[4]);
       }
       }     
       //Changes end for W-004996 by Chandra dated 20/06/2020

       String digitalChannel = 'B';
       String rbaEdd = '';
       //Adding for Savings
       String rbaEddRating = opp.Risk_Rating__c;
       Map<String, string> rbaEddRatingTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName('Savings', 'Outbound');//Added by Diksha for Savings dated 20/7/2020
       //system.debug('rbaEddRatingTranslatedMap' + rbaEddRatingTranslatedMap);
       if (!rbaEddRatingTranslatedMap.isEmpty() && rbaEddRatingTranslatedMap != null){
           rbaEddRating = rbaEddRatingTranslatedMap.get(rbaEddRating);
           //system.debug('String rbaEddRating' + rbaEddRating);
       }

       List<DisplayProducts> displayproductList = new List<DisplayProducts>();
       DisplayProducts dspr = new DisplayProducts();
       dspr.Client = acc.Name;
       dspr.Account = oppproduct.Name;
       if (oppproduct.Policy_Number__c != '' && oppproduct.Policy_Number__c != null){
           dspr.AccountNumber = oppproduct.Policy_Number__c;
       } else if (String.isBlank(oppproduct.Policy_Number__c)){
           //system.debug('openSite --' + openSite + '&&--controlSite--' + controlSite + ' --&&--cifKey--' + cifKey + '--&&--tellerNbr--' + tellerNbr + '--&&-- product--' + product + '--&&-- srcOfFnds1--' + srcOfFnds1);
           if (oppproduct.Product2.family == 'cheque' && openSite != null && controlSite != null && cifKey != null && tellerNbr != null && product != null && srcOfFnds1 != null){
               //system.assertEquals(oppproduct.Policy_Number__c, '1232');
               //system.debug('Inside Cheque service to call ');
               //Calling Cheque Service to get the account number
               opportunityLineItem AcctnumberCQ = callCQcreateAcct(accountNbr, openSite, controlSite, cifKey, tellerNbr, controllerNbr, workstationNbr, product, applicationNbr, controlSiteType, openSiteType, effectiveDate, marketersCode, provChqBookInd, cbpSchemeCode, cbpPrimaryAccount, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, digitalChannel, rbaEdd);
               //system.debug('Service call to cheque to get account number' + AcctnumberCQ);
               try{
                   if (AcctnumberCQ != null){
                        AcctnumberCQ.Price_Scheme_Code__c =  PriceSchemeCode;
                        update AcctnumberCQ;
                    }
                   dspr.AccountNumber = AcctnumberCQ.Policy_Number__c;
               } catch (Exception e){
                   //system.debug('Error Message :' + e.getMessage()+'Error Cause :' + e.getCause()+'Error Where:' + e.getLineNumber());
                   throw new AuraHandledException('Error: ' + errorMessage);
               }
           } else if (oppproduct.Product2.family == 'SAVINGS'){
               opportunityLineItem UpdatedLineItem = getAccountNumber(opp.id, oppproduct.Id, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEddRating);//Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
               //system.debug('Inside getOppDataV2 Saving service call - Return res from getAccountNumber ' + UpdatedLineItem);
               try{
                   if (UpdatedLineItem != null)
                       update UpdatedLineItem;
                   dspr.AccountNumber = UpdatedLineItem.Policy_Number__c;
               } catch (Exception e){
                   //system.debug('Error Message :' + e.getMessage()+'Error Cause :' + e.getCause()+'Error Where:' + e.getLineNumber());
                   throw new AuraHandledException('Error: ' + errorMessage);
               }
           }
       }

       displayproductList.add(dspr);
       //system.debug('displayproductList' + displayproductList);
       return displayproductList;
   }
   /** 
   * @description getApplicationId
   * @param recordId
   * @param componentFamily
   * @return Application_Product__c
   */
   @AuraEnabled
   public static Application_Product__c getApplicationId(String recordId, String componentFamily){
        List<OpportunityLineItem> oppProduct = new OpportunityLineItemsSelector().selectByOpportunityId(recordId);
        List<Application_Product__c> AppPrds = new List<Application_Product__c>();
        List<String> idList = new List<String>();

        for (OpportunityLineItem opplineItem : oppProduct){
            if (opplineItem.Product_Family__c == componentFamily){
                 idList.add(opplineItem.Id);
            }
        }
        AppPrds = new ApplicationProductSelector().selectApplicationProductByOpportunityProductIds(idList);
        return AppPrds[0];
    }
 
   /** 
   * @description getApplicationId : W-14960 : Anka new changes
   * @param appProdRec 
   */
   public static void updateApplicationRec(Application_Product__c appProdRec){
      
       if(appProdRec != null ){
           Application__c appRec = new Application__c(); 
           appRec.Id = appProdRec.Application__c;
           //system.debug('appRec.Id+'+appRec.Id);
           appRec.Purpose_of_Account__c = appProdRec.Purpose_of_Account__c;
           appRec.Purpose_of_Account_Text__c = appProdRec.Purpose_of_Account_Text__c;
           
           appRec.Delivery_Method__c = appProdRec.Delivery_Method__c;
           appRec.Statement_Frequency__c = appProdRec.Statement_Frequency__c;
           appRec.Source_of_Funds_Savings__c = appProdRec.Source_of_Funds_Savings__c;
           appRec.Statement_Day_of_the_month__c = appProdRec.Statement_Day_of_the_month__c;
           appRec.Account_Stream__c = appProdRec.Account_Stream__c;
           
           appRec.Re_Direct_Fees__c = appProdRec.Re_Direct_Fees__c ;
           appRec.Transfer_credit_interest_to_account__c = appProdRec.Transfer_credit_interest_to_account__c;
           appRec.Transfer_admin_fee_to_account__c = appProdRec.Transfer_admin_fee_to_account__c;
           appRec.Transfer_cash_deposit_fee_to_account__c = appProdRec.Transfer_cash_deposit_fee_to_account__c;
           appRec.Transfer_commitment_fee_to_account__c = appProdRec.Transfer_commitment_fee_to_account__c ;
           appRec.Transfer_debit_interest_to_account__c = appProdRec.Transfer_debit_interest_to_account__c;
           appRec.Transfer_service_fee_to_account__c = appProdRec.Transfer_service_fee_to_account__c ;
           appRec.Transfer_tax_levy_to_account__c = appProdRec.Transfer_tax_levy_to_account__c;
           appRec.Transfer_transaction_fee_to_account__c = appProdRec.Transfer_transaction_fee_to_account__c;
           appRec.Transfer_incoming_unpaid_items_to_accoun__c = appProdRec.Transfer_incoming_unpaid_items_to_accoun__c;
           appRec.Account_Activity_Calculator__c = appProdRec.Account_Activity_Calculator__c;   
           update appRec;
       }
       
       }
    
    /**
    * @description
    * @author Manish.battu@absa.africa | 2021-07-23
    * @param oppId - Opportunity Id
    * @param appProdId - Application Product Id
    * @return List<Questionnaire_Answer__c> - Questionnaire_Answers
    **/
    @AuraEnabled
    public static List<Questionnaire_Answer__c> getQuestionnaireRecordlist(Id oppId, Id appProdId) {
        Opportunity opp = new OpportunitiesSelector().selectByOppId(OppId);
        List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
        List<Questionnaire_Answer__c> QAnswerRecList=  new List<Questionnaire_Answer__c> ();
        QAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application_Product__c=:appProdId AND Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
        return QAnswerRecList; 
    }
    /**
    * @description  method to create ROA Question records as QuestionnaireRecords
    * @author Manish.battu@absa.africa | 2021-07-24
    * @param oppId  - Opportunity Id
    * @param appProdId  - Application product Id
    * @param questionsMap - Questions Map
    * @return List<Questionnaire_Answer__c> - return created response
    **/
    @AuraEnabled
    public static List<Questionnaire_Answer__c> createQuestionnaireRecords(Id oppId, Id appProdId, Map<String, String> questionsMap) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(OppId);
        List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
        List<Questionnaire_Answer__c> newQAnswerRecList =new List<Questionnaire_Answer__c> ();
        List<Questionnaire_Answer__c> oldQAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c,Related_Application_Product__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application_Product__c=:appProdId AND Questionnaire_Template__r.Name='Onboarding Record Of Advice' ];
        if (!oldQAnswerRecList.isEmpty()){
            delete oldQAnswerRecList;
        }
        for (Questionnaire_Question__c qqname : questionnames){
            Questionnaire_Answer__c qqanswer=new Questionnaire_Answer__c();
            qqanswer.Questionnaire_Question__c = qqname.Id;
            qqanswer.Questionnaire_Template__c=qqname.Questionnaire_Template__c;
            qqanswer.Related_Opportunity__c=OppId;
            qqanswer.Related_Application_Product__c=appProdId;
            qqanswer.Answer__c = questionsMap.get(qqname.Question_Label__c);
            qqanswer.Answer_Data_Type__c=qqname.Answer_Type__c;
            newQAnswerRecList.add(qqanswer);
        }
        insert newQAnswerRecList;
        return newQAnswerRecList;
    }
    /**
    * @description 
    * @author Manish.battu@absa.africa | 2021-09-09 
    * @param appProdId 
    * @param underSupervision 
    * @param adviseGiven 
    * @return Application_Product__c 
    **/
    @AuraEnabled
    public static Application_Product__c updateROAInformation(Id appProdId, String underSupervision, String adviseGiven) {
        Application_Product__c appProd = new Application_Product__c();
        appProd.Id = appProdId;
        appProd.Client_Under_Supervision__c = underSupervision;
        appProd.Advice_Given__c = adviseGiven;
        update appProd;
        return appProd;
    }
    /**
    * @description  updateOpportunityProduct
    * @param oppProdId  - OpportunitylineItem Id
    * @param priceSchemeCode - priceSchemeCode
    * @return OpportunityLineItem
    **/
    @AuraEnabled
    public static OpportunityLineItem updateOpportunityProduct(Id oppProdId, String priceSchemeCode) {
        OpportunityLineItem oppProd = new OpportunityLineItem();
        oppProd.Id = oppProdId;
        oppProd.Price_Scheme_Code__c = priceSchemeCode;
        update oppProd;
        return oppProd;
    }
}