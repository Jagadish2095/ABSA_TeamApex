/**
  * @description this class used to like: Generate Account Number for savings/Cheque, Send welcome package
  * @version v1.0
  * @since   2020-01-31
  *
  */
  public class productOnboardingController{
	/** 
   * @description getAccountByOppId
   * @param oppId
   * @return String
   */
   @AuraEnabled
   public static String getAccountByOppId(Id oppId){

	   Opportunity opp = new Opportunity();
	   opp = [select Id, Account.Name, Account.Client_Group__c, Entity_Type__c
			  from Opportunity
			  where id = :oppId];

	   Account account = new Account();
	   String json = '';

	   if (opp.Account.Client_Group__c == 'SOLE TRADER CLIENT' || opp.Entity_Type__c == 'Sole Trader'){
		   //account = [SELECT Id, AccountNumber,Phone,Active_Email__c,FinServ__PrimaryContact__r.FirstName,FinServ__PrimaryContact__r.LastName,Language__c FROM Account WHERE Id =: opp.AccountId];
		   Id accountId = [SELECT Id
						   FROM Account
						   WHERE Id = :opp.AccountId].Id;
		//15225 added : Contact_Method__c
						   Contact contact = [SELECT Id, AccountId, Phone, Email, FirstName, LastName, Communication_Language__c,Contact_Method__c
							  FROM Contact
							  WHERE AccountId = :accountId];

		 json = '{"AccId":"' + contact.AccountId + '", "Phone":"' + contact.Phone + '","Active_Email__c":"' + contact.Email + '","FirstName":"' + contact.FirstName + '","LastName":"' + contact.LastName + '","PreferredLanguage":"' + contact.Communication_Language__c + '","PreferredContact":"' + contact.Contact_Method__c + '"}';
	   } else{
		json = '{"AccId":"", "Phone":"","Active_Email__c":"","FirstName":"","LastName":"","PreferredLanguage":"","PreferredContact":""}';
	   }

	   return json;
   }
   /** 
   * @description addEstatementDetails
   * @param jsonString
   * @return String
   */
   @AuraEnabled
   public static String addEstatementDetails(String jsonString){

	   String msg = '';
	   Integer err = 0;

	   try{
		   Map<String, Object> obj = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

		   String oppId = (String)obj.get('oppId');
		   String deliveryMethodVal = (String)obj.get('deliveryMethodVal');
		   String statementFrequencyVal = (String)obj.get('statementFrequencyVal');
		   String statementDayOfMonthVal = (String)obj.get('statementDayOfMonthVal');
		   String accountStreamVal = (String)obj.get('accountStreamVal');
		   Boolean duplicateStatementsVal = (Boolean)obj.get('duplicateStatementsVal');
		   String deliveryInstructionVal = (String)obj.get('deliveryInstructionVal');


		   Application__c applicationData = new Application__c();

		   List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
		   List<OpportunityLineItem> oppProduct = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

		   if (String.isBlank(oppProduct[0].Policy_Number__c)){
			   err++;
			   msg += '\n Account or Policy Number is empty';
		   }
		   if (String.isBlank(userRec[0].SiteCode__c)){
			   err++;
			   msg += '\n SiteCode is empty';
		   }
		   if (String.isBlank(userRec[0].Teller_Operator_Code__c)){
			   err++;
			   msg += '\n TellerCode is empty';
		   }
		   if (String.isBlank(oppProduct[0].Product_Family__c)){
			   err++;
			   msg += '\n Product_Family__c is empty';
		   }
		   if (String.isBlank(userRec[0].Email)){
			   err++;
			   msg += '\n Email is empty';
		   }

		   if (err == 0){

			   String requests = 'B';
			   String site = userRec[0].SiteCode__c;
			   String teller = userRec[0].Teller_Operator_Code__c;
			   String email = userRec[0].Email;
			   String accountNumber = oppProduct[0].Policy_Number__c;
			   String product = oppProduct[0].Product_Family__c;

			   if (product == 'Cheque'){
				   product = 'CQ';
			   }
			   if (product == 'Savings'){
				   product = 'SA';
			   }
			   if (product == 'Personal Loan'){
				   product = 'PL';
			   }
			   if (product == 'Home Loan'){
				   product = 'HL';
			   }
			   if (product == 'Credit card'){
				   product = 'CA';
			   }
			   if (product == 'AVAF'){
				   product = 'FV';
			   }

			   ApplicationsSelector applicationSelector = new ApplicationsSelector();
			   List<Application__c> appList = applicationSelector.selectByOpportunityId(oppId);

			   EImaintainESDDetailsV3_IH_v1.sImaintainESDDetailsV3(requests, site, teller, accountNumber, product, email);

			   if (appList != null && appList.size() > 0){

				   applicationData = appList[0];
				   applicationData.Delivery_Method__c = deliveryMethodVal;
				   applicationData.Statement_Frequency__c = statementFrequencyVal;
				   applicationData.Statement_Day_of_the_month__c = statementDayOfMonthVal;
				   applicationData.Account_Stream__c = accountStreamVal;
				   applicationData.Duplicate_Statement__c = duplicateStatementsVal;
				   applicationData.Delivery_Instruction__c = deliveryInstructionVal;
				   update applicationData;
			   } else{

				   applicationData.Opportunity__c = oppId;
				   applicationData.Delivery_Method__c = deliveryMethodVal;
				   applicationData.Statement_Frequency__c = statementFrequencyVal;
				   applicationData.Statement_Day_of_the_month__c = statementDayOfMonthVal;
				   applicationData.Account_Stream__c = accountStreamVal;
				   applicationData.Duplicate_Statement__c = duplicateStatementsVal;
				   applicationData.Delivery_Instruction__c = deliveryInstructionVal;
				   insert applicationData;

			   }


		   }

	   } catch (exception exp){
		   String error = exp.getMessage();
	   }

	   return err + '' + msg;
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
   public static String updateApplication(String TransactionalAccount, String AccountAccess, String ForeignServices, 
										  String SurplusCash, String BorrowingRequimentGeneral, String BorrowingrequimentAssestAcquisition, 
										  String ProtectionOfServices,String ProtectionOfServicesBusiness, String ProductsAndServices,
										  String Title, String FirstName, String Surname, 
										  Date Signing_Date, Id applicationId){
	   String returnReponse = null;
	   ApplicationsSelector applicationSelector = new ApplicationsSelector();
	   Application__c appRec = applicationSelector.selectById(applicationId);

	   if (appRec != null){
		   appRec.Transactional_Account__c = TransactionalAccount;
		   appRec.Account_Access__c = AccountAccess;
		   appRec.Foreign_Services__c = ForeignServices;
		   appRec.Surplus_Cash__c = SurplusCash;
		   appRec.Borrowing_Requiment_General__c = BorrowingRequimentGeneral;
		   appRec.Borrowing_requiment_Assest_Acquisition__c = BorrowingrequimentAssestAcquisition;
		   appRec.Protection_Of_Services__c = ProtectionOfServices;
		   appRec.Protection_Of_Services_Business__c = ProtectionOfServicesBusiness;
		   appRec.Products_And_Services__c = ProductsAndServices;
		   appRec.Title__c = Title;
		   appRec.FirstNameSignature__c = FirstName;
		   appRec.SurnameSignature__c = Surname;
		   appRec.Signing_Date__c = Signing_Date;
		   try{
			   update appRec;
			   returnReponse = 'Updated the application record';
		   } catch (exception e){
			   returnReponse = 'Failed to update record';
		   }
		   return returnReponse;
	   } else{
		   return null;
	   }
   }

   /*
	@AuraEnabled
	public static string updateNotifyMe(String AllTransactionType,String Payment,String Withdrawal, String Deposit, String ReturnedTransactions,
	String ScheduledTransaction, Date NotificationTime, String MinimumAmount, String BalanceUpdate,
	String SpecificDay,Id oppId)
	{
	String returnReponse = null;
	ApplicationsSelector applicationSelector = new ApplicationsSelector();
	List<Application__c> appRecList = applicationSelector.selectByOpportunityId(oppID);
	Application__c appRec = new Application__c();

	if(appRecList != null && appRecList.size() > 0){
	appRec = appRecList[0];
	appRec.All_transaction_type__c = AllTransactionType;
	appRec.Payment__c = Payment;
	appRec.Withdrawal__c = Withdrawal;
	appRec.Deposit__c = Deposit;
	appRec.Returned_Transactions__c = ReturnedTransactions;
	appRec.Scheduled_transaction__c = ScheduledTransaction;
	appRec.Notification_time__c = NotificationTime;
	appRec.Minimum_amount__c = MinimumAmount;
	appRec.Balance_update__c = BalanceUpdate;
	appRec.Specific_day__c   = SpecificDay;
	try{
	update appRec;
	returnReponse = 'Updated the application record';
	}catch(exception exp){
	returnReponse = String.valueOf('Failed to update record');
	}
	} else{
	appRec.Opportunity__c = oppID;
	appRec.All_transaction_type__c = AllTransactionType;
	appRec.Payment__c = Payment;
	appRec.Withdrawal__c = Withdrawal;
	appRec.Deposit__c = Deposit;
	appRec.Returned_Transactions__c = ReturnedTransactions;
	appRec.Scheduled_transaction__c = ScheduledTransaction;
	appRec.Notification_time__c = NotificationTime;
	appRec.Minimum_amount__c = MinimumAmount;
	appRec.Balance_update__c = BalanceUpdate;
	appRec.Specific_day__c   = SpecificDay;

	try{
	insert appRec;
	returnReponse = 'Inserted the application record';
	}catch(exception exp){
	returnReponse = String.valueOf('Failed to Inserted record ' + exp.getMessage());
	}
	}
	return returnReponse;
	}

	private static Boolean noRow(String response){
	return (response == 'List has no rows for assignment to SObject');
	}
	*/
   
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
   public static string updateNotifyMe(String Name, String Surname, String ActiveEmail, String PreferredContact, 
                                       String PreferredLanguage,String AllTransactionType, String Payment,
                                       String Withdrawal, String Deposit, 
									   String ReturnedTransactions, String ScheduledTransaction,
                                       String NotificationTime, String MinimumAmount, String MinimumAmount1, 
                                       String BalanceUpdate, String SpecificDay,String Purchases, Id oppId){

	   String msg = '';
	   Integer err = 0;
	   String oppAccountId = '';

	   try{

		   List<OpportunityLineItem> oppProduct = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

		   Opportunity opp = new Opportunity();
		   List<Opportunity> oppList= new OpportunitiesSelector().selectByOpportunityId(oppId);
           opp = oppList[0];
		   
		   oppAccountId = opp.AccountId;

		   //account = [SELECT Id,Phone, AccountNumber,RecordTypeId,FinServ__PrimaryContact__r.FirstName,FinServ__PrimaryContact__r.LastName,Active_Email__c,Language__c FROM Account WHERE Id =: opp.AccountId];

		   User user = new User();
		   user = new UsersSelector().selectById(UserInfo.getUserId());
		   
		   String placeholderName = Name;
		   String placeholderLanguage = PreferredLanguage;
		   String placeholderEmail = ActiveEmail;
		   String placeholderPhone = PreferredContact;

		   if (String.isBlank(opp.CIF_Number__c)){
			   err++;
			   msg += '\nCIF is empty';
		   }
		   if (String.isBlank(oppProduct[0].Policy_Number__c)){
			   err++;
			   msg += '\nAccount Number is empty';
		   }
		   //if(String.isBlank(oppProduct[0].Contact_Person__c)){err++; msg += '\nContact Person is empty';}
		   if (String.isBlank(oppProduct[0].Product_Family__c)){
			   err++;
			   msg += '\nProduct Family is empty';
		   }
		   if (String.isBlank(user.SiteCode__c)){
			   err++;
			   msg += '\nSiteCode is empty';
		   }
		   if (String.isBlank(user.Teller_Operator_Code__c)){
			   err++;
			   msg += '\nTellerCode is empty';
		   }
		   if (PreferredContact == NULL){
			   err++;
			   msg += '\nPhone is empty';
		   }
		   if (ActiveEmail == NULL){
			   err++;
			   msg += '\nEmail is empty';
		   }
		   if (MinimumAmount1 == NULL){
			   err++;
			   msg += '\nMinimum Amount is empty';
		   }

		   if (err == 0){

			   String CIF = opp.CIF_Number__c;
			   String accountNumber = oppProduct[0].Policy_Number__c;
			   String siteCode = user.SiteCode__c;
			   String tellerCode = user.Teller_Operator_Code__c;
			   String recipName = placeholderName;
			   String language = 'E';//placeholderLanguage;
			   String email = placeholderEmail;
			   String cellPhone = placeholderPhone;
			   String sbuCd = 'B';
			   String contactPref = 'S';//oppProduct[0].Contact_Person__c;
			   String product = oppProduct[0].Product_Family__c;
			   String prodArea = product.toUpperCase();//W-13694
			   boolean payment1 = (Payment == 'Yes') ? true : false;
			   boolean withDrawal1 = (Withdrawal == 'Yes') ? true : false;
			   boolean deposit1 = (Deposit == 'Yes') ? true : false;
			   boolean transfer = false;
			   boolean returned = (ReturnedTransactions == 'Yes') ? true : false;
			   boolean scheduled = (ScheduledTransaction == 'Yes') ? true : false;
			   boolean purchase = false; 
			   //String notifyTimes = NotificationTime != null ? NotificationTime.format() : ''; //W-13694
			   String notifyTimes = NotificationTime;//W-13694
			   String balanceUpdates = BalanceUpdate;
			   String minimumCash = MinimumAmount1;
			   nQcreateNewOrAddRecipientV2_IH_v2.nQcreateNewOrAddRecipientV2(CIF, accountNumber, siteCode, tellerCode, sbuCd, recipName, contactPref, language, email, cellPhone, prodArea, payment1, withDrawal1, deposit1, transfer, returned, scheduled,purchase, notifyTimes, balanceUpdates, minimumCash);
			   msg += '\nService went Successfully';


		   } else{
			  return null; 
		   }
		   //End of err value

		   if (err == 0){

			   ApplicationsSelector applicationSelector = new ApplicationsSelector();
			   List<Application__c> appRecList = applicationSelector.selectByOpportunityId(oppId);
			   Application__c appRec = new Application__c();

			   if (appRecList != null && appRecList.size() > 0){

				   appRec = appRecList[0];
				   appRec.All_transaction_type__c = AllTransactionType;
				   appRec.Payment__c = Payment;
				   appRec.Withdrawal__c = Withdrawal;
				   appRec.Deposit__c = Deposit;
				   appRec.Returned_Transactions__c = ReturnedTransactions;
				   appRec.Scheduled_transaction__c = ScheduledTransaction;
				   //W-13694 : Anka Ganta
					appRec.Notification_time_Window__c = NotificationTime;
                    //appRec.Notification_time__c = NotificationTime;
				   appRec.Minimum_amount__c = MinimumAmount;
				   appRec.Minimum_Amount1__c = Decimal.valueOf(MinimumAmount1);
				   appRec.Balance_update__c = BalanceUpdate;
				   appRec.Specific_day__c = SpecificDay;
				   appRec.Preferred_Email__c = ActiveEmail;
				   appRec.Purchases__c = Purchases;//15225
				   update appRec;
				   msg += '\nUpdated successfully';

			   } else{

				   appRec.Opportunity__c = oppId;
				   appRec.All_transaction_type__c = AllTransactionType;
				   appRec.Payment__c = Payment;
				   appRec.Withdrawal__c = Withdrawal;
				   appRec.Deposit__c = Deposit;
				   appRec.Returned_Transactions__c = ReturnedTransactions;
				   appRec.Scheduled_transaction__c = ScheduledTransaction;
				   //W-13694 : Anka Ganta
					//appRec.Notification_time__c = NotificationTime; 
					appRec.Notification_time_Window__c = NotificationTime; 
				   appRec.Minimum_amount__c = MinimumAmount;
				   appRec.Minimum_Amount1__c = Decimal.valueOf(MinimumAmount1);
				   appRec.Balance_update__c = BalanceUpdate;
				   appRec.Specific_day__c = SpecificDay;
				   appRec.Preferred_Email__c = ActiveEmail;
				   appRec.Purchases__c = Purchases;//15225
				   insert appRec;
				   msg += 'Saved successfully';

			   }


			   //Id accountId = [SELECT Id FROM Account WHERE Id=:oppId].Id;

		   }
		   //End of err value

	   } catch (exception exp){
		   err++;
	   }
	   try{

		   if (err == 0){
			   List<Contact> con = [SELECT Id
									FROM Contact
									WHERE AccountId = :oppAccountId
									LIMIT 1];
			   Contact contact = new Contact();
			   if (con.size() > 0){

				   contact = con[0];

				   contact.FirstName = Name;
				   contact.LastName = Surname;
				   contact.Email = ActiveEmail;
				   contact.Contact_Method__c = PreferredContact;
				   contact.Communication_Language__c = PreferredLanguage;
				   update contact;
				   msg += 'Contact updated successfully';

			   } else{

				   contact.AccountId = oppAccountId;
				   contact.FirstName = Name;
				   contact.LastName = Surname;
				   contact.Email = ActiveEmail;
				   contact.Phone = PreferredContact;
				   contact.Communication_Language__c = PreferredLanguage;
				   insert contact;
				   msg += 'Contact Created successfully';

			   }

		   }

	   } catch (exception exp){
		   err++;
	   }

	   return err + '' + msg;
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
   public static String updateInternetBanking(String AccountToBeDebitedMonthlyWithTheCost, String CombiRecordNumber, String NumberOfAuthorisations,
											  String NumberOfMainUsers, String FeeStructureCode, String AbsaOnlineForBusiness, String CellPhoneBanking,
											  String TelephoneBanking, String Notifyme, String FundsTransfer, String BillPayments, String OwnDefinedPayments,
											  String FutureDatedPayments, String StopOrderPayments, Id oppID){
	   String returnReponse = null;
	   ApplicationsSelector applicationSelector = new ApplicationsSelector();
	   List<Application__c> appRecList = applicationSelector.selectByOpportunityId(oppID);
	   Application__c appRec = new Application__c();

	   if (appRecList != null && appRecList.size() > 0){
		   appRec = appRecList[0];
		   appRec.Account_to_be_debited_monthly_with_the_c__c = AccountToBeDebitedMonthlyWithTheCost;
		   appRec.Number_of_authorisations_that_will_be_re__c = NumberOfAuthorisations;
		   appRec.Number_of_main_users__c = NumberOfMainUsers;
		   appRec.Fee_Structure_code__c = FeeStructureCode;
		   appRec.Absa_online_for_business_BIB__c = AbsaOnlineForBusiness;
		   appRec.Cell_phone_banking__c = CellPhoneBanking;
		   appRec.Telephone_banking__c = TelephoneBanking;
		   appRec.Notifyme__c = Notifyme;
		   appRec.Funds_transfer__c = FundsTransfer;
		   appRec.Bill_payments__c = BillPayments;
		   appRec.Own_defined_payments__c = OwnDefinedPayments;
		   appRec.Future_dated_payments__c = FutureDatedPayments;
		   appRec.Stop_order_payments__c = StopOrderPayments;

		   try{
			   update appRec;
			   returnReponse = 'Updated the application record';
		   } catch (exception exp){
			   returnReponse = String.valueOf('Failed to Updated record ' + exp.getMessage());
		   }
	   } else{
		   appRec.Opportunity__c = oppID;
		   appRec.Account_to_be_debited_monthly_with_the_c__c = AccountToBeDebitedMonthlyWithTheCost;
		   appRec.Number_of_authorisations_that_will_be_re__c = NumberOfAuthorisations;
		   appRec.Number_of_main_users__c = NumberOfMainUsers;
		   appRec.Fee_Structure_code__c = FeeStructureCode;
		   appRec.Absa_online_for_business_BIB__c = AbsaOnlineForBusiness;
		   appRec.Cell_phone_banking__c = CellPhoneBanking;
		   appRec.Telephone_banking__c = TelephoneBanking;
		   appRec.Notifyme__c = Notifyme;
		   appRec.Funds_transfer__c = FundsTransfer;
		   appRec.Bill_payments__c = BillPayments;
		   appRec.Own_defined_payments__c = OwnDefinedPayments;
		   appRec.Future_dated_payments__c = FutureDatedPayments;
		   appRec.Stop_order_payments__c = StopOrderPayments;
		   try{
			   insert appRec;
			   returnReponse = 'Inserted the application record';
		   } catch (Exception exp){
			   returnReponse = String.valueOf('Failed to Inserted record ' + exp.getMessage());
		   }
	   }
	   return returnReponse;
   }

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

	   AccountContactRelationSelector accountApplicationSelector = new AccountContactRelationSelector();

	   AccountContactRelation accnRel;
	   FinServ__AccountAccountRelation__c accAccRelList;

	   String stringId = acrId;

	   
	   If (stringId.startsWith('07k')){
		   AccountContactRelation accnRel1 = accountApplicationSelector.selectbyAccountContactRelationId(acrId);
		   accnRel = accnRel1;
	   } Else{
		   FinServ__AccountAccountRelation__c accAccRelList1 = new AccountAccountRelationSelector().selectbyAccAccRelId(acrId);
		   accAccRelList = accAccRelList1;

	   }

	   
	   Map<String, String> mapObj = new Map<String, String>();

	   if (!isEmpty(accnRel)){
		   mapObj.put('Id', accnRel.Id);
		   mapObj.put('AccountId', accnRel.AccountId);
		   mapObj.put('ContactId', accnRel.ContactId);
		   mapObj.put('FirstName', accnRel.Contact.FirstName);
		   mapObj.put('LastName', accnRel.Contact.LastName);
		   mapObj.put('IDNumber', accnRel.Contact.ID_Number__c == null ? '0' : accnRel.Contact.ID_Number__c);
		   mapObj.put('CASAReferenceNumber', accnRel.Account.CASA_Reference_Number__c);
		   mapObj.put('CIF', accnRel.Account.CIF__c);
		   mapObj.put('Type', accnRel.Account.Type);
		   mapObj.put('CASAScreeningStatus', accnRel.Account.CASA_Screening_Status__c);
		   mapObj.put('Nationality', accnRel.Contact.Nationality__c);
		   mapObj.put('Phone', accnRel.Contact.Phone);
		   mapObj.put('Birthdate', String.valueOf(accnRel.Contact.Birthdate));
		   mapObj.put('SharePercentage', string.valueOf(accnRel.Share_Percentage__c));
		   mapObj.put('Roles', accnRel.Roles);
		   mapObj.put('StartDate', String.valueOf(accnRel.StartDate));
		   mapObj.put('CASAScreeningDate', String.valueOf(accnRel.Account.CASA_Screening_Date__c));
		   mapObj.put('ClientName', accnRel.Account.Name);
	   }
	   if (!isEmpty(accAccRelList)){
		   mapObj.put('Id', accAccRelList.Id);
		   mapObj.put('AccountId', accAccRelList.FinServ__RelatedAccount__c);
		   mapObj.put('IDNumber', accAccRelList.FinServ__RelatedAccount__r.Registration_Number__c);
		   mapObj.put('CASAReferenceNumber', accAccRelList.FinServ__RelatedAccount__r.CASA_Reference_Number__c);
		   mapObj.put('CIF', accAccRelList.FinServ__RelatedAccount__r.CIF__c);
		   mapObj.put('Type', accAccRelList.FinServ__RelatedAccount__r.Type);
		   mapObj.put('CASAScreeningStatus', accAccRelList.FinServ__RelatedAccount__r.CASA_Screening_Status__c);
		   //  mapObj.put('Nationality', accAccRelList.FinServ__RelatedAccount__r.Nationality__c);
		   //  mapObj.put('Phone', accnRel.Contact.Phone);
		   // mapObj.put('Birthdate', String.valueOf(accnRel.Contact.Birthdate));
		   mapObj.put('SharePercentage', string.valueOf(accAccRelList.Shareholding_Percentage__c));
		   mapObj.put('Roles', accAccRelList.Roles__c);
		   //  mapObj.put('StartDate', String.valueOf(accAccRelList.FinServ__StartDate__c));
		   mapObj.put('CASAScreeningDate', String.valueOf(accAccRelList.FinServ__RelatedAccount__r.CASA_Screening_Date__c));
		   mapObj.put('ClientName', accAccRelList.FinServ__RelatedAccount__r.Name);
	   }
	   return mapObj;
   }
	/** 
   * @description updateOpportunityAndApplication
   * @param OpportunityId
   * @param applicationRecord
   * @return String
   */
   @AuraEnabled
   public static String updateOpportunityAndApplication(Id OpportunityId, Application__c applicationRecord){
	   String returnReponse = null;
	   Set<Id> oppId = new Set<Id>();
	   oppId.add(OpportunityId);
	   List<Opportunity> opportunityLst = new OpportunitiesSelector().selectById(oppId);

	   if (opportunityLst != null && opportunityLst.size() > 0){
		   //Update Opportunity Status
		   if (applicationRecord.Decision__c == 'Request New Terms'){
			   opportunityLst[0].StageName = 'Price Negotiation';
		   } else{
			   opportunityLst[0].StageName = 'Declined';
		   }
		   update opportunityLst[0];
		   upsert applicationRecord;
	   }
	   return applicationRecord.Id;
   }
	/** 
   * @description getApplicationProducts
   * @param oppId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getApplicationProducts(Id oppId){
	   Opportunity oppRec = new OpportunitiesSelector().selectByOppId(oppId);

	   if (oppRec.StageName == 'Apply Product'){
		   oppRec.StageName = 'Fulfill Product';
		   try{
			   update oppRec;
		   } catch (Exception e){
			   String excepMSg = e.getMessage();
		   }
	   }

	   return [select Id, name, policy_number__c, Product_Family__c, Opportunity.StageName, Opportunity.ExecutionLayerRequestID__c
			   from OpportunityLineItem
			   where opportunityid = :oppId];
	   /*   System.debug('opp id'+ oppId);
		String returnReponse = null;
		Set<Id> oppSetId = new Set<Id>();
		oppSetId.add(oppId);
		System.debug('opp id'+ oppId);
	   // List<opportunitylineitem> opportunityLst =  new  OpportunityLineItemsSelector().selectByOppId( oppid ,1);
		OpportunityLineItem oppproduct= new  OpportunityLineItemsSelector().selectByOppId( oppid ,1);
		if(oppproduct != null) {
		oppproduct = [select id,Name from OpportunityLineItem where Opportunityid =: oppId Limit 1];
		}
		return oppproduct; */
   }

   /** 
   * @description getPricingSchemesByProduct : W-004843 
   * @param oppId
   * @return List<Price_Scheme__c>
   */
   @AuraEnabled
   public static List<Price_Scheme__c> getPricingSchemesByProduct(Id oppId){
	   OpportunityLineItemsSelector oppSelector = new OpportunityLineItemsSelector();
	   OpportunityLineItem oli = oppSelector.selectByOppId(oppId, 1);
	   List<Price_Scheme__c> pricingSchemeList;
	   if (oli.Product2.Family != null && oli.product2.Name != null){
		   PriceSchemesSelector ps = new PriceSchemesSelector();
		   pricingSchemeList = ps.selectByProductFamilyProductName(oli.Product2.Family, oli.product2.Name, oli.product2.ProductCode);
	   }
	   return pricingSchemeList;
   }
   /** 
   * @description getAccount
   * @param oppId
   * @return Account
   */
   @AuraEnabled
   public static Account getAccount(Id oppId){
	   AccountsSelector aSelector = new AccountsSelector();
	   return aSelector.selectByOpportunityId(oppId);
   }
   /** 
   * @description getRelatedParties
   * @param oppId
   * @param submitForCasa
   * @return <Map<String, Object>>
   */
   @AuraEnabled
   public static List<Map<String, Object>> getRelatedParties(Id oppId, Boolean submitForCasa){
	   AccountsSelector aSelector = new AccountsSelector();
	   Account acccount = aSelector.selectByOpportunityId(oppId);
	   List<Map<String, Object>> listParties = new List<Map<String, Object>>();
	   List<AccountContactRelation> accnRelList = new AccountContactRelationSelector().selectbyAccount(acccount.Id);
	   List<FinServ__AccountAccountRelation__c> accAccRelList = new AccountAccountRelationSelector().selectbyLevel0RelatedParty(acccount.Id, acccount.Id);
	   List<AccountContactRelation> UBOList = new AccountContactRelationSelector().selectUBOContacts(acccount.Id, 'Yes');
	   Map<String, String> partiesInList = new Map<String, String>();

	   
	   if (accnRelList != null && accnRelList.size() > 0){

		   for (AccountContactRelation accnRel : accnRelList){
			   If (!partiesInList.containsKey(accnRel.ContactId)){
				   Map<String, Object> mapObj = new Map<String, Object>();
				   mapObj.put('Id', accnRel.Id);
				   mapObj.put('AccountId', accnRel.AccountId);
				   mapObj.put('ContactId', accnRel.ContactId);
				   mapObj.put('FirstName', accnRel.Contact.FirstName);
				   mapObj.put('LastName', accnRel.Contact.LastName);
				   mapObj.put('IDNumber', accnRel.Contact.ID_Number__c);
				   mapObj.put('CIF', accnRel.Account.CIF__c);
				   mapObj.put('Nationality', accnRel.Contact.Nationality__c);
				   mapObj.put('Birthdate', String.valueOf(accnRel.Contact.Birthdate));
				   mapObj.put('SharePercentage', string.valueOf(accnRel.Share_Percentage__c));
				   mapObj.put('CIF', accnRel.Account.CIF__c);
				   mapObj.put('Roles', accnRel.Roles);
				   mapObj.put('Phone', accnRel.Account.Phone);

				   if (submitForCasa == true){
					   mapObj.put('CASAReferenceNumber', accnRel.Contact.CASA_Reference_Number__c);
					   mapObj.put('CASAScreeningStatus', accnRel.Contact.CASA_Screening_Status__c);
				   }
				   partiesInList.put(accnRel.ContactId, accnRel.ContactId);
				   listParties.add(mapObj);
			   }
		   }
	   }

	   if (accAccRelList != null && accAccRelList.size() > 0){
		   for (FinServ__AccountAccountRelation__c accnRel : accAccRelList){
			   If (!partiesInList.containsKey(accnRel.FinServ__RelatedAccount__c)){
				   Map<String, Object> mapObj = new Map<String, Object>();
				   mapObj.put('Id', accnRel.Id);
				   mapObj.put('AccountId', accnRel.FinServ__RelatedAccount__r.Name);
				   mapObj.put('Acc', accnRel.FinServ__RelatedAccount__r.Name);
				   mapObj.put('SharePercentage', string.valueOf(accnRel.Shareholding_Percentage__c));
				   mapObj.put('Roles', accnRel.Roles__c);

				   if (submitForCasa == true){
					   mapObj.put('CASAReferenceNumber', accnRel.FinServ__RelatedAccount__r.CASA_Reference_Number__c);
					   mapObj.put('CASAScreeningStatus', accnRel.FinServ__RelatedAccount__r.CASA_Screening_Status__c);
				   }
				   partiesInList.put(accnRel.FinServ__RelatedAccount__c, accnRel.FinServ__RelatedAccount__c);
				   listParties.add(mapObj);
			   }
		   }
	   }
	   return listParties;
   }
   /** 
   * @description getApplicationRecord
   * @param opportunityId
   * @return Application__c
   */
   @AuraEnabled
   public static Application__c getApplicationRecord(Id opportunityId){
	   //Get Application Linked to the Opportunity based on Product
	   List<Application__c> applicationLst = new ApplicationsSelector().selectByOpportunityOnboardId(opportunityId);

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
	   String returnReponse = null;
	   Set<Id> oppId = new Set<Id>();
	   oppId.add(OpportunityId);
	   
	   List<Opportunity> opportunityLst = new OpportunitiesSelector().selectById(oppId);
	   if (opportunityLst != null && opportunityLst.size() > 0){
		   //    opportunityLst[0].StageName = 'Fulfill Product';
		   update applicationRecord;
		   update opportunityLst[0];
	   }
	   return returnReponse;
   }

   /** 
   * @description getApplicationDetails : Saurabh W-003227
   * @param oppId
   * @return Application__c
   */
   @AuraEnabled
   public static Application__c getApplicationDetails(Id oppId){
	   try{
		   List<Application__c> appList = new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
		   Application__c app = new Application__c();
		   if (!appList.isEmpty() && appList != Null){
			   //As per the current UI we can only display one application hence taking only one
			   app = appList[0];
		   }
		   return app;
	   } catch (QueryException e){
		   // "Convert" the exception into an AuraHandledException
		   throw new AuraHandledException('Something went wrong: ' + e.getMessage());
	   }
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
											   Date value7, Double value8, Double value9, String value10, Double value11, String value12, 
											   string value13, string productPurposeText, Id value14, String value15, String value16, 
											   String value17, Integer value18){
		 //

	   Application__c appRec = [SELECT Id, Purpose_of_Account__c, Purpose_of_Account_Text__c, Rand_value_of_credits_per_month__c, Rand_value_of_debits_per_month__c, Reason_for_debit_orders__c, Product_Usage_Description__c, Number_of_supplier_payments_per_month__c, Number_of_staff_members__c, Number_of_debits_per_month__c, Where_are_the_suppliers_located__c, Account_Activity_Calculator__c, Where_will_the_credits_be_coming_from__c, Charge_Type__c, Charge_Capitalization_Type__c, Charge_Capitalization_Frequency__c, Charge_Capitalization_Date__c
								FROM Application__c
								where Id = :value14];

	   appRec.Purpose_of_Account__c = value1;
	   appRec.Expected_number_of_credits_per_month__c = value2;
	   appRec.Rand_value_of_credits_per_month__c = value3;
	   appRec.Credits_received_via__c = value4;
	   appRec.Where_will_the_credits_be_coming_from__c = value5;
	   appRec.Number_of_staff_members__c = value6;
	   appRec.Payment_date_of_staff__c = value7;
	   appRec.Number_of_debits_per_month__c = value8;
	   appRec.Number_of_supplier_payments_per_month__c = value9;
	   appRec.Where_are_the_suppliers_located__c = value10;
	   appRec.Rand_value_of_debits_per_month__c = value11;
	   appRec.Reason_for_debit_orders__c = value12;
	   appRec.Product_Usage_Description__c = value13;
	   appRec.Account_Activity_Calculator__c = value13;
	   appRec.Purpose_of_Account_Text__c = productPurposeText;
	   appRec.Charge_Type__c = value15;
	   appRec.Charge_Capitalization_Type__c = value16;
	   appRec.Charge_Capitalization_Frequency__c = value17;
	   appRec.Charge_Capitalization_Date__c = value18;
	   update appRec;
	   string Success = 'updated the application record';
	   return Success; //better handing and return @saurabh
   }
   /** 
   * @description updateApplicationDetails
   * @param requireChequeCard
   * @param requireDepositBook
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
   * @param applicationId
   * @return String
   */
   @AuraEnabled
   public static string updateApplicationDetails(Boolean requireChequeCard, Boolean requireDepositBook, String sourceOfFunds, 
												 Boolean redirectFees,String transferCreditInterestToAccount, String transferAdminFeeToAccount,
												 String transferCashDepositFeeToAccount,String transferCommitmentFeeToAccount, String transferDebitInterestToAccount,
												 String transferServiceFeeToAccount,String transferTaxLevyToAccount, String transferTransactionFeeToAccount, 
												 String transferIncomingUnpaidItemsToAccount,String deliveryMethod, String statementFrequency, 
												 String statementDayOfMonth, String accountStream,String deliveryInstruction, 
										   /* W-13221 String accrualDayOfMonth, String capitilisationDayOfWeek,String capitilisationDayOfMonth, 
												 String accrualDayOfWeek, String chargeType,String chargeCapitalType, 
												 String chargeFreq, Integer chargeCapDate,*/ Id applicationId){
		 // thabo check for values coming here most of them were null while testing
	   String returnReponse = null;
	   Application__c appRec = [SELECT Cheque_Card_Required__c, Deposit_Book_Required__c, Source_of_Funds_Savings__c, Re_Direct_Fees__c, Transfer_credit_interest_to_account__c, Transfer_admin_fee_to_account__c, Transfer_commitment_fee_to_account__c, Transfer_debit_interest_to_account__c, Transfer_service_fee_to_account__c, Transfer_tax_levy_to_account__c, Transfer_transaction_fee_to_account__c, Transfer_incoming_unpaid_items_to_accoun__c, Delivery_Method__c, Statement_Frequency__c, Statement_Day_of_the_month__c, Account_Stream__c, Delivery_Instruction__c, Accrual_Day_of_Month__c, Capitilisation_Day_of_Week__c, Capitilisation_Day_of_Month__c, Charge_Capitalization_Date__c, Charge_Type__c, Charge_Capitalization_Type__c, Charge_Capitalization_Frequency__c, Accrual_Day_of_Week__c
								FROM Application__c
								where Id = :applicationId];
	   
	   //appRec.Cheque_Card_Required__c = requireChequeCard;  //commented due to value error @thabo to take a look
	   //appRec.Deposit_Book_Required__c = requireDepositBook; //commented due to value error
	   appRec.Delivery_Method__c = deliveryMethod;
	   appRec.Statement_Frequency__c = statementFrequency;
	   appRec.Source_of_Funds_Savings__c = sourceOfFunds;
	   appRec.Statement_Day_of_the_month__c = statementDayOfMonth;
	   appRec.Account_Stream__c = accountStream;
	   appRec.Delivery_Instruction__c = deliveryInstruction;
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
		   update appRec;
		   returnReponse = 'updated the application record';
	   } catch (exception e){
		   returnReponse = 'Failed to update record';
	   }
	   return returnReponse;
   }
	/**
	* @description  method to create ROA Question records as QuestionnaireRecords
	* @author Manish.battu@absa.africa | 2021-07-24
	* @param oppId  - Opportunity Id
	* @param questionsMap - Questions Map
	* @return List<Questionnaire_Answer__c> - return created response
	**/
	
	@AuraEnabled
    public static List<Questionnaire_Answer__c> createQuestionnaireRecords(Id oppId, Map<String, String> questionsMap) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(OppId);
        List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
        List<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
        List<Questionnaire_Answer__c> newQAnswerRecList =new List<Questionnaire_Answer__c> ();
        List<Questionnaire_Answer__c> oldQAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application__c=:app[0].Id AND Questionnaire_Template__r.Name='Onboarding Record Of Advice' ];
        if (!oldQAnswerRecList.isEmpty()){
            delete oldQAnswerRecList;
        }
        for (Questionnaire_Question__c qqname : questionnames){
            Questionnaire_Answer__c qqanswer=new Questionnaire_Answer__c();
            qqanswer.Questionnaire_Question__c = qqname.Id;
            qqanswer.Questionnaire_Template__c=qqname.Questionnaire_Template__c;
            qqanswer.Related_Opportunity__c=OppId;
            qqanswer.Related_Application__c=app[0].Id;
            qqanswer.Answer__c = questionsMap.get(qqname.Question_Label__c);
            qqanswer.Answer_Data_Type__c=qqname.Answer_Type__c;
            newQAnswerRecList.add(qqanswer);
        }
        insert newQAnswerRecList;
        return newQAnswerRecList;
    }

	/**
	* @description
	* @author Manish.battu@absa.africa | 2021-07-23
	* @param oppId - Opportunity Id
	* @return List<Questionnaire_Answer__c> - Questionnaire_Answers
	**/
	@AuraEnabled
	public static List<Questionnaire_Answer__c> getQuestionnaireRecordlist(Id oppId) {
		Opportunity opp = new OpportunitiesSelector().selectByOppId(OppId);
		List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
   		List<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
    	List<Questionnaire_Answer__c> QAnswerRecList=  new List<Questionnaire_Answer__c> ();
        QAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application__c=:app[0].Id AND Questionnaire_Template__r.Name='Onboarding Record Of Advice'];
        return QAnswerRecList;
	}

	/**
	* @description 
	* @author vineel.rudroju@absa.africa | 2021-11-30 
	* @param ParentId 
	* @param flag 
	**/
	@AuraEnabled
	public static void updateProductInterest(Id ParentId, Boolean flag ){
       

		List<Application__c> appUpdateList = new List<Application__c>();
                for(Application__c appRecord : [SELECT Id, Opportunity__c, Product_Interest__c FROM Application__c WHERE Opportunity__c =:ParentId]){
				if(flag == true){
                    appRecord.Product_Interest__c = 'Protect your Employees'; //Picklist Value
                    appUpdateList.add(appRecord);
                }else {
                    appRecord.Product_Interest__c = ''; //Picklist Value
                    appUpdateList.add(appRecord);                    
                }
				
            }	 
            update appUpdateList;	 
		
    }
	/** 
   * @description updateApplicationROADetails used to Update ROA Information T Senkomane
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
   * @param applicationId
   * @return String 
   */
   @AuraEnabled
   public static string updateApplicationROADetails(Date delegatesMeetingDate, String delegatesAtMeeting, Double netAssetValue, 
													String currentSituation, String currentProductXP, String needsOrObjectives,
													String typicalmacroOrSectorial, String othermacroOrSectorial, String generalNotes,
													String priorProduct, String productConsidered, String productRecommended,
													String reasonNotRecommended, String presentationName, String presentationGroupName, 
													Date presentationDate, String presentationLocation, String presentationFolioNo,
													String firstName, String surname, String designation, 
													Date dateVal, String adviseGiven, String underSupervision,
													String isReplacingProduct, Id applicationId){
	   String returnReponse = null;
	   Application__c appRec = [SELECT Delegates_at_Meeting__c, Net_Asset_Value__c, Current_Situation__c, Current_Finacial_Product_Experience__c, Needs_or_Objectives__c, Macro_or_Sectorial_Firm__c, Other_Macro_or_Sectorial_Comments__c, General_Notes__c, Did_Client_Select_Product__c, Produts_Considered__c, Product_Recommended_to_Client__c, Reason_why_Recommended_not_Recommended__c, Presentation_Name__c, Presentation_Group_Name__c, Presentation_Date__c, Presentation_Location__c, Presentation_Folio_Number__c, First_Name__c, Surname__c, Designation__c, Date__c, Advice_Given__c, Client_Under_Supervision__c, Replacing_an_Existing_Product__c, Delegates_Meeting_Date__c
								FROM Application__c
								where Id = :applicationId];

	   
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
		   returnReponse = 'updated the application ROA record';
	   } catch (exception e){
		   returnReponse = 'Failed to update record';
	   }
	   return returnReponse;
   }
	
   /**
   * @description sendWelcomePackage
   * @param oppid 
   * @return boolean 
   **/
   @AuraEnabled
   public static boolean sendWelcomePackage(Id oppid){
	   try{
		   Opportunity oppRec = new OpportunitiesSelector().selectByOppId(oppid);
		   Account accRec = new AccountsSelector().selectById(oppRec.AccountId);
		   OpportunityLineItem oppProduct = new OpportunityLineItemsSelector().selectByOppId(oppRec.id, 1);
		   /*if(oppRec.StageName !='Completed'){
			oppRec.StageName='Completed';
			update oppRec;
			}*/
		   Id targetObjectId = [Select id, Email
								from Contact
								where Email != ''
								limit 1].Id;
		   EmailTemplate Template = [Select id, htmlvalue
									 from EmailTemplate
									 where name = 'WelcomePackage'
									 LIMIT 1];
		   String htmlbody = Template.HtmlValue;
		   if (accRec.Name != null && oppProduct.policy_number__c != null)
			   htmlbody = htmlBody.replace('{!Opportunity.Account}', accRec.Name);
		   htmlbody = htmlBody.replace('{!OpportunityLineItem.Policy_Number__c}', oppProduct.policy_number__c);
		   htmlbody = htmlBody.replace('{!OpportunityLineItem.Description}', oppProduct.Product2.Name);// added for product name
		   htmlbody = htmlBody.replace('{!TODAY()}', '' + string.valueOf(system.today()));
		   string emailaddress;
		   if (accRec.Preferred_Communication_Method__c == 'Email' || accRec.Preferred_Communication_Method__pc == 'Email'){
			   emailaddress = accRec.Preferred_Communication_Info__c;
		   }
		   List<Messaging.SingleEmailMessage> constructEmail = composeEmail(oppRec.id, targetObjectId, 'WelcomePackage', emailaddress, htmlbody,'Welcome Package');
		   Messaging.SingleEmailMessage email = constructEmail.get(0);
		   return true;
		   //   String htmlBody = email.getHTMLBody();
		   //   htmlBody = htmlBody.replace('{!Opportunity.Account}', accRec.Name).replace('{!OpportunityLineItem.Policy_Number__c}', oppProduct.policy_number__c).replace('{!TODAY()}', ''+date.valueOf(system.today()));
	   } catch (exception excp){
		   String expMsg =  excp.getMessage();
		   return false;
		}
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
   public static List<Messaging.SingleEmailMessage> ComposeEmail(Id whatId, Id targetObjectId, String templateName, string emailaddress, 
																 string htmlbody,String subject){
	   // Construct the list of emails we want to send

	   List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
	   //  list<OrgWideEmailAddress> owea =new OrgWideEmailAddressesSelector().selectAAActivity();

	   Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
	   msg.setTemplateId([SELECT Id
						  FROM EmailTemplate
						  WHERE DeveloperName = :templateName].Id);
	   msg.setWhatId(whatId);
	   msg.setTargetObjectId(targetObjectId);
	   msg.setToAddresses(new List<String>{emailAddress});
	   msg.setTreatTargetObjectasRecipient(false);
	   msg.setHtmlBody(htmlbody);
	   msg.setSaveAsActivity(true);
	   msg.setSubject(subject);
	   //   msg.setOrgWideEmailAddressId(owea.get(0).Id);
	   Set<String> orgemailaddress = new Set<String>();
	   orgemailaddress.add('businessbankingservices@absa.africa');
	   List<OrgWideEmailAddress> orgwideaddress = new OrgWideEmailAddressesSelector().selectByAddress(orgemailaddress);
	   if (!orgwideaddress.isEmpty()){
		   msg.setOrgWideEmailAddressId(orgwideaddress[0].id);
	   }
	   lstMsgs.add(msg);
	   try{
		   Messaging.sendEmail(lstMsgs);
	   } catch (exception e){
		   // "Convert" the exception into an AuraHandledException
		   String expMsg =  e.getMessage();
		}
	   return lstMsgs;
   }
   
   /** 
   * @description getCurrentUserDetail
   * @return List<User>
   */
   @AuraEnabled
   public static List<User> getCurrentUserDetail(){
	   return [SELECT Id, FirstName, LastName, Email, SiteCode__c, MobilePhone, Teller_Operator_Code__c, AB_Number__c, Business_Area__c
			   FROM User
			   WHERE Id = :UserInfo.getUserId()];
   }

		
   /** 
   * @description updateSavingsAccountGeneral updating Application record with General savings account information /*Haritha W-003257,W-003823
   * @param oppid
   * @param applicationRecord
   * @return String
   */
   @AuraEnabled
   public static string updateSavingsAccountGeneral(Id oppid, string applicationRecord){
	   try{
		   savingsgeneralaccwrapper wr = (savingsgeneralaccwrapper)System.JSON.deserialize(applicationRecord, savingsgeneralaccwrapper.class);
		   Application__c appRec = new ApplicationsSelector().selectById(wr.id);
		   if (appRec != null){
			   appRec.Meeting_Of__c = wr.MeetingOf;
			   appRec.Meeting_Held_At__c = wr.MeetingHeldAt;
			   appRec.Meeting_Date__c = wr.MeetingDate;
			   appRec.Extract_signed_date__c = wr.Extractsigneddate;
			   appRec.Total_number_of_accounts_to_be_Open__c = wr.Totalnumofaccountstobeopened;
			   appRec.Req_NumOf_signs_to_Open_Close_Accounts__c = wr.Requirednumberofsignatoriestoopencloseaccounts;
			   appRec.Required_numof_signatories_to_give_instr__c = wr.Requirednumofsignatoriestogiveinstructions;
			   appRec.Source_of_Funds_Savings__c = wr.SourceofFundssavings;
			   appRec.Comments_on_explanation_given_for_Source__c = wr.CommentsonexplanationgivenforSourceoffunds;
			   //appRec.Customer_Region__c = wr.CustomerRegion; //added by Manish for W-010115
			  // appRec.Is_there_a_Transfer_to_be_performed_for__c = wr.IsThereAnyTPFTP; //added by Manish for W-010115
			   
			   Update appRec;
		   }
		   return 'SUCCESS';
	   } catch (Exception e){
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
	   List<String> sourceOfFundsVals = app[0].Source_of_Funds_Savings__c != null ? app[0].Source_of_Funds_Savings__c.split(';') : new List<String>();//Added by Chandra against W-004996 dated 20/6/2020
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
   /*	if (userRec[0].SiteCode__c != null){
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
	   
	   if (!rbaEddRatingTranslatedMap.isEmpty() && rbaEddRatingTranslatedMap != null){
		   rbaEddRating = rbaEddRatingTranslatedMap.get(rbaEddRating);
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
			   try{
				   if (AcctnumberCQ != null){
					   AcctnumberCQ.Price_Scheme_Code__c =  PriceSchemeCode;
                        update AcctnumberCQ;
				   }
				   dspr.AccountNumber = AcctnumberCQ.Policy_Number__c;
			   } catch (Exception e){
				   throw new AuraHandledException('Error: ' + errorMessage);
			   }
		   } else if (oppproduct.Product2.family == 'SAVINGS'){
			   opportunityLineItem UpdatedLineItem = getAccountNumber(opp.id, oppproduct.Id, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEddRating);//Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
			   try{
				   if (UpdatedLineItem != null)
					   update UpdatedLineItem;
				   dspr.AccountNumber = UpdatedLineItem.Policy_Number__c;
			   } catch (Exception e){
				   throw new AuraHandledException('Error: ' + errorMessage);
			   }
		   }
	   }

	   displayproductList.add(dspr);
	   return displayproductList;
   }
   /** 
   * @description fetchAccountDetails
   * @param accountId
   * @return Account
   */
   @AuraEnabled
   public static Account fetchAccountDetails(String accountId){
	   return [Select Id, FirstName, LastName, PersonEmail, Phone, ID_Number__pc
			   From Account
			   Where Id = :accountId
			   LIMIT 1];
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
   public static OpportunityLineItem callCQcreateAcct(Integer accountNbr, Integer openSite, Integer controlSite, 
													  String cifKey, Integer tellerNbr, Integer controllerNbr, 
													  Integer workstationNbr, Integer product, Integer applicationNbr,
													  String controlSiteType, String openSiteType, Integer effectiveDate,
													  Integer marketersCode, String provChqBookInd, String cbpSchemeCode,
													  Integer cbpPrimaryAccount, String srcOfFnds1, String srcOfFnds2, 
													  String srcOfFnds3, String srcOfFnds4, String srcOfFnds5,
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
   
   //Added By Srikanth
   
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
	   
	   Opportunity currentOpp = new OpportunitiesSelector().selectByOpptId(oppId);
	   OpportunityLineItem lineItem = new OpportunityLineItem(Id = oppProductId);
	   List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);
	   
	   SVcreateLinkSavingsDepAccount_Resp_IB_v2 response = new SVcreateLinkSavingsDepAccount_Resp_IB_v2();
	   
	   response = SVcreateLinkSavingsDepAccount_IH_v2.callToSVcreateLinkSavingsDepAccount(oppId, oppProductId, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEddRating);
	   
	   
	   //if (response.statusCode != 200){
		   //if (response.SVcreateLinkSavingsNoticeDepAccountV6Response != null && response.SVcreateLinkSavingsNoticeDepAccountV6Response.nbsmsgo3 != null && response.SVcreateLinkSavingsNoticeDepAccountV6Response.nbsmsgo3.sysErrTxt != null){
			   //  returnMessage = ''+response.SVcreateLinkSavingsNoticeDepAccountV6Response.nbsmsgo3.sysErrTxt;
			   //} else{
			   //      returnMessage =''+ response.statusMessage;
			    //}
	  // } else
	  	if(response.statusCode == 200){
		   //lineItem.Policy_Number__c = response.SVcreateLinkSavingsNoticeDepAccountV6Response.svpp15o.accountNumber.replaceFirst('^0+', '');
		   lineItem.Policy_Number__c = String.ValueOf(response.SVcreateLinkSavingsNoticeDepAccountV6Response.svpp15o.accountNumber);
		   
		   //TdB - Create Regulatory Financal Account Record
		   Regulatory_Financial_Account__c financialProduct = new Regulatory_Financial_Account__c();
		   financialProduct.Account__c = null;
		   financialProduct.Account_Number__c = lineItem.Policy_Number__c;
		   financialProduct.Purpose_of_Account__c = '';
		   financialProduct.Purpose_of_Account_Text__c = '';
		   financialProduct.Source_of_Funds__c = '';
		   financialProduct.Account_Activity_Calculator__c = '';
		   financialProduct.Credits_Received_via_EFT_Cash_etc__c = '';
		   financialProduct.Where_will_the_Credits_be_Coming_from__c = '';
		   financialProduct.Number_of_Staff_Members__c = 0;
		   financialProduct.Payment_Date_of_Staff__c = null;
		   financialProduct.Where_are_the_Suppliers_Located__c = '';
		   financialProduct.Reason_for_Debit_Orders__c = '';
		   
		   //  acc =  response.SVcreateLinkSavingsNoticeDepAccountV6Response.svpp15o.accountNumber;
		   // update acc;  // not to update here after calling CQ then updated together
	   }
	   return lineItem;
   }
   
	/** 
   * @description showopplineitem
   * @param oppid
   * @param productid
   * @return opportunitylineitem
   */
   @AuraEnabled
   public static opportunitylineitem showopplineitem(Id oppid, Id productid){
	   opportunitylineitem oppproduct = new OpportunityLineItemsSelector().selectByOppId(oppid, 1);
	   return oppproduct;
   }
   
   
	/** 
   * @description changeAccountDomicile //Mbuyiseni Mbhokane: Added the domicile change Method
   * @param accNumber
   * @param bankerSiteCode
   * @return string
   */
   @AuraEnabled
   public static string changeAccountDomicile(string accNumber, string bankerSiteCode){
	   
	   User currentUser = new UsersSelector().selectById(Userinfo.getUserId());
	   try{
		   Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CqUpdAcctDomicileChangev2_IH_v1.CqUpdAcctDomicileChangev2(accNumber, bankerSiteCode, System.Label.ElectronicSiteForAccount, '9999999', '9999999'); // passing Old site Code and User Teller Codes as static as per SA Comments
		   CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean = (new List<CqUpdAcctDomicileChangev2_Resp_IB_v1>(responseMap.keySet()))[0];
		   //Logging the request
		   List<Sys_Log_Integration__c> CqUpdAcctDomicileChangev2Logs = responseMap.values()[0];
		   if (CqUpdAcctDomicileChangev2Logs != null && !CqUpdAcctDomicileChangev2Logs.isEmpty()){
			   Insert CqUpdAcctDomicileChangev2Logs;
		   }
		   // Insert logs if its present
		   
		   String messageText; //to store Service Response message
		   if ((responseBean != Null) && (responseBean.statusCode == 200)){
			   messageText = responseBean.CQupdAcctDomicileChangeV2Response.Nbsmsgo.msgEntry.msgTxt;
			   } else{
			   messageText = 'Change Domicile Site Code failed';
		   }
		   return messageText;
	   } catch (Exception exc){
		   throw new AuraHandledException('Something went wrong: ' + exc.getMessage());
	   }
   }
   
   /** 
   * @description getApplicationProductsV2 
   * @param oppId
   * @param oppLineId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getApplicationProductsV2(Id oppId, String oppLineId){
	   Opportunity oppRec = new OpportunitiesSelector().selectByOppId(oppId);
	   
	   if (oppRec.StageName == 'Apply Product'){
		   oppRec.StageName = 'Fulfill Product';
		   try{
			   update oppRec;
		   } catch (Exception e){
				String expMsg =  e.getMessage();
			}
	   }
	   
	   return [select Id, name, policy_number__c, Product_Family__c, Opportunity.StageName, Opportunity.ExecutionLayerRequestID__c
			   from OpportunityLineItem
			   where OpportunityId = :oppId
			   LIMIT 1];
	   /*   System.debug('opp id'+ oppId);
String returnReponse = null;
Set<Id> oppSetId = new Set<Id>();
oppSetId.add(oppId);
System.debug('opp id'+ oppId);
// List<opportunitylineitem> opportunityLst =  new  OpportunityLineItemsSelector().selectByOppId( oppid ,1);
OpportunityLineItem oppproduct= new  OpportunityLineItemsSelector().selectByOppId( oppid ,1);
if(oppproduct != null) {
oppproduct = [select id,Name from OpportunityLineItem where Opportunityid =: oppId Limit 1];
}
return oppproduct; */
   }
   
   /** 
   * @description updateProductPriceScheme //added by Lesibe
   * @param oppId
   * @param selectedSchemeCode
   * @return String
   */
   @AuraEnabled
   public static String updateProductPriceScheme(Id oppId,String selectedSchemeCode){
	   
	   String msg = '';
	   try{
		   OpportunityLineItemsSelector oppSelector = new OpportunityLineItemsSelector();
		   OpportunityLineItem oli = oppSelector.selectByOppId(oppId,1);
		   
		   OpportunityLineItem oppLineItem = new OpportunityLineItem();
		   
		   oppLineItem = oli;
		   oppLineItem.Fee_Structure_Code__c 	= selectedSchemeCode;
		   
		   
		   update oppLineItem;
		   msg = 'Updated Successfully';
	   }
	   catch(Exception e){
		   msg = 'Message :'+ e.getMessage()+'\n Line No. :'+ e.getLineNumber();
	   }
	   
	   
	   return msg;
	   
	   
   }    
   
   //Added by Mbuyiseni
   // @AuraEnabled
   /*public static String listPrefProductForClient(String clientCode,String inpAccntNbr){

	String returnedProducts;

	try{
	CClistPrefProductForClientV2_Req_IB_v1 requestBean = CClistPrefProductForClientV2_IU_v1.mapRequestFields(clientCode,inpAccntNbr);
	CClistPrefProductForClientV2_Resp_IB_v1 productResponseBean = CClistPrefProductForClientV2_IH_v1.cclistprefproductsforclient(requestBean);

	if(productResponseBean !=null && productResponseBean.statusCode == 200){
   //get the product options
	CClistPrefProductForClientV2_Resp_IB_v1.Ccp317o ccp317o = productResponseBean.CClistPrefProductsForClientV2Response.Ccp317o;
	returnedProducts = productResponseBean.serialize(ccp317o.prdProdLst);
	System.debug('Response : ' + ccp317o.prdProdLst);
	}else{
	System.debug('response' + productResponseBean.serialize(productResponseBean));
	}
	}catch(Exception e){
	System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
	throw new AuraHandledException('Something went wrong: '+ e.getMessage());
	}

	System.debug('returnedProducts : ' + returnedProducts);

	return returnedProducts;
	}*/
   
	/** 
   * @description getOpportunityLineItems //added by Mbuyiseni
   * @param opportunityId
   * @return List<Map<String, String>>
   */
   @AuraEnabled
   public static List<Map<String, String>> getOpportunityLineItems(Id opportunityId){

	   List<Map<String, String>> oppLineItems = new List<Map<String, String>>();
	   //get the opportunity product
	   List<OpportunityLineItem> opportunityLineItems = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
	   for (OpportunityLineItem opportunityLineItem : opportunityLineItems){
		   oppLineItems.add(new Map<String, String>{'value' => opportunityLineItem.Id, 'label' => opportunityLineItem.ProductCode});
	   }
	   return oppLineItems;
   }

   /** 
   * @description getOpportunityLineItemDetails //added by Mbuyiseni
   * @param opportunityId
   * @return List<OpportunityLineItem>
   */
   @AuraEnabled
   public static List<OpportunityLineItem> getOpportunityLineItemDetails(Id opportunityId){
	   List<OpportunityLineItem> opportunityLineItemDetails = new OpportunityLineItemsSelector().selectByOpportunityId(opportunityId);
	   return opportunityLineItemDetails;
   }
   /** 
   * @description getOppLineItem
   * @param oppid
   * @param componentFamily
   * @return opportunitylineitem
   */
   @AuraEnabled
   public static opportunitylineitem getOppLineItem(Id oppid, String componentFamily){
	   List<opportunitylineitem> oppproductList = new OpportunityLineItemsSelector().selectByOpportunityId(oppid);
	   for (opportunitylineitem oppLine : oppproductList){
		   if (oppline.Product_Family__c == componentFamily){
			   return oppLine;
		   }
	   }
	   return null;
   }
   /** 
   * @description getPricingSchemesByProductV2
   * @param oppId
   * @param oppLineId
   * @return List<Price_Scheme__c>
   */
   @AuraEnabled
   public static List<Price_Scheme__c> getPricingSchemesByProductV2(Id oppId, String oppLineId){
	   OpportunityLineItemsSelector oppSelector = new OpportunityLineItemsSelector();
	   Map<Id, OpportunityLineItem> checkList = new Map<Id, OpportunityLineItem>(oppSelector.selectByOpportunityId(oppId));
	   Map<String, String> productNameMap = new Map<String, String>();
	   List<Price_Scheme__c> pricingSchemeList;
	   String productName;
	   For (OpportunityLineItem productLoop : checkList.values()){
		   If (productLoop.Product_Name__c.Contains('Business Evolve') && !productLoop.Product_Name__c.Contains('Package')){
			   productName = productLoop.Product_Name__c;
		   }
		   productNameMap.put(productLoop.Product_Name__c, productLoop.Id);
	   }
	   If (productNameMap.containsKey(productName)){
		   PriceSchemesSelector ps = new PriceSchemesSelector();
		   pricingSchemeList = ps.selectByProductFamilyProductName('', checkList.get(productNameMap.get(productName)).product2.Name, checkList.get(productNameMap.get(productName)).ProductCode);
	   }
	   
	   /*
		OpportunityLineItem oli = oppSelector.selectById(oppLineId)[0];
		System.debug('oli++'+oli.Product2.Family + '--' + oli.product2.Name + '--' +oli.product2.ProductCode);

		if(oli.Product2.Family != null && oli.product2.Name != null){
	   //pricingSchemeList = [SELECT Id,Name, Scheme_Code__c, Product_Family__c, Product_Name__c,Product_Code__c FROM Price_Scheme__c where Product_Family__c =:oli.Product2.Family AND Product_Name__c =: oli.product2.Name AND Product_Code__c =:oli.ProductCode];
		PriceSchemesSelector ps = new PriceSchemesSelector();
		pricingSchemeList= ps.selectByProductFamilyProductName(oli.Product2.Family,oli.product2.Name,oli.product2.ProductCode);
		}
		System.debug('pricingSchemeList++'+pricingSchemeList);

		*/
	   return pricingSchemeList;
   }
   /** 
   * @description getOppDataV2
   * @param oppId
   * @param PriceSchemeCode
   * @param oppLineId
   * @return List<DisplayProducts>
   */
   @AuraEnabled
   public static List<DisplayProducts> getOppDataV2(String oppId, String PriceSchemeCode, String oppLineId){

	   Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
	   Account acc = new AccountsSelector().selectByOpportunityId(oppId);
	   List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());
	   oppproduct = new OpportunityLineItemsSelector().selectById(oppLineId)[0];
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
	   if (!rbaEddRatingTranslatedMap.isEmpty() && rbaEddRatingTranslatedMap != null){
		   rbaEddRating = rbaEddRatingTranslatedMap.get(rbaEddRating);
		   }

	   List<DisplayProducts> displayproductList = new List<DisplayProducts>();
	   DisplayProducts dspr = new DisplayProducts();
	   dspr.Client = acc.Name;
	   dspr.Account = oppproduct.Name;
	   if (oppproduct.Policy_Number__c != '' && oppproduct.Policy_Number__c != null){
		   dspr.AccountNumber = oppproduct.Policy_Number__c;
	   } else if (String.isBlank(oppproduct.Policy_Number__c)){
		   if (oppproduct.Product2.family == 'cheque' && openSite != null && controlSite != null && cifKey != null && tellerNbr != null && product != null && srcOfFnds1 != null){
			   //system.assertEquals(oppproduct.Policy_Number__c, '1232');
			   //Calling Cheque Service to get the account number
			   opportunityLineItem AcctnumberCQ = callCQcreateAcct(accountNbr, openSite, controlSite, cifKey, tellerNbr, controllerNbr, workstationNbr, product, applicationNbr, controlSiteType, openSiteType, effectiveDate, marketersCode, provChqBookInd, cbpSchemeCode, cbpPrimaryAccount, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, digitalChannel, rbaEdd);
			   try{
				   if (AcctnumberCQ != null){
                        AcctnumberCQ.Price_Scheme_Code__c =  PriceSchemeCode;
                        update AcctnumberCQ;
                    }
				   dspr.AccountNumber = AcctnumberCQ.Policy_Number__c;
			   } catch (Exception e){
				   throw new AuraHandledException('Error: ' + errorMessage);
			   }
		   } else if (oppproduct.Product2.family == 'SAVINGS'){
			   opportunityLineItem UpdatedLineItem = getAccountNumber(opp.id, oppproduct.Id, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, rbaEddRating);//Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
			   try{
				   if (UpdatedLineItem != null)
					   update UpdatedLineItem;
				   dspr.AccountNumber = UpdatedLineItem.Policy_Number__c;
			   } catch (Exception e){
				   throw new AuraHandledException('Error: ' + errorMessage);
			   }
		   }
	   }

	   displayproductList.add(dspr);
	   return displayproductList;
   }
  
   //added by Mbuyiseni
   /*@AuraEnabled
	public static String cclistCombiBrandsForPrefProd(String prodType, String prodCode){

	String productBrandLst;

	try{
	CClistCombiBrandsForPrefProdV1_Req_IB_v1 combiRequestBean = CClistCombiBrandsForPrefProdV1_IU_v1.mapRequestFields(prodType, prodCode);
	CClistCombiBrandForPrefProdV1_Resp_IB_v1 combiResponseBean = CClistCombiBrandsForPrefProdV1_IH_v1.cclistcombibrandsforpreferredproduct(combiRequestBean);
	if(combiResponseBean != null && combiResponseBean.statusCode == 200){
	CClistCombiBrandForPrefProdV1_Resp_IB_v1.Ccp306o ccp306o = combiResponseBean.Wsd_CClistCombiBrandsForPreferredProductV1Response.ccp306o;
	productBrandLst = combiResponseBean.serialize(ccp306o.prdBrandDetails.prdBrandLst);
	System.debug('product list : '+ productBrandLst);
	}else{
	System.debug('response' + combiResponseBean.serialize(combiResponseBean));
	}
	}catch(Exception exc){
	System.debug('Exception Occured'+exc.getMessage()+ 'At Line number'+exc.getLineNumber());
	throw new AuraHandledException('Something went wrong: '+ exc.getMessage());
	}
	return productBrandLst;
	}
   //added by Mbuyiseni
	@AuraEnabled
	public static String ccissue(){
	String combiNumber;
	try{
	CCIssueV2_Req_IB_v1 ccissueRequestBean = CCIssueV2_IU_v1.mapRequestFields();
	CCIssueV2_Resp_IB_v1 ccissusResponseBean = CCIssueV2_IH_v1.ccissue(ccissueRequestBean);
	if(ccissusResponseBean != null && ccissusResponseBean.statusCode == 200){
	CCIssueV2_Resp_IB_v1.Ccp311o ccp311o = ccissusResponseBean.CCIssueV2Response.ccp311o;
	if(String.isNotBlank(ccissusResponseBean.serialize(ccp311o.combiNbr)) && ccissusResponseBean.serialize(ccp311o.combiNbr) != null){
	combiNumber = ccissusResponseBean.serialize(ccp311o.combiNbr);
	System.debug('combi card number: '+ combiNumber);
	}else{
	combiNumber = 'No Combi Card Number Returned';
	}
	}else{
	System.debug('response' + ccissusResponseBean.serialize(ccissusResponseBean));
	}
	}catch(Exception e){
	System.debug('Exception Occured'+e.getMessage()+ 'At Line number'+e.getLineNumber());
	throw new AuraHandledException('Something went wrong: '+ e.getMessage());
	}
	return combiNumber;
	}*/
   //Added by Sandile, for case Management to pass applicationId

   /** 
   * @description getApplicationId
   * @param recordId
   * @param componentFamily
   * @return String
   */
   @AuraEnabled
   public static String getApplicationId(String recordId, String componentFamily){

	   List<OpportunityLineItem> oppProduct = new OpportunityLineItemsSelector().selectByOpportunityId(recordId);
	   String AppId = '';
	   List<String> idList = new List<String>();

	   for (OpportunityLineItem opplineItem : oppProduct){

		   if (opplineItem.Product_Family__c == componentFamily){
				idList.add(opplineItem.Id);
			   /*AppId = [Select Id, Opportunity_Product_Id__c
						from Application_Product__c
						where Opportunity_Product_Id__c = :opplineItem.Id].Id;*/

		   }
		   

	   }
	   AppId = [Select Id, Opportunity_Product_Id__c
						from Application_Product__c
						where Opportunity_Product_Id__c IN :idList LIMIT 1].Id;
	   return AppId;
   }
   
   
}