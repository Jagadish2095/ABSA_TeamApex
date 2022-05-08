/**
 * @description       : VASRewardHelper
 * @author            : Clifford Willers : ABSA (IQ Business)
 * @last modified on  : 2021-09-10
 * @last modified by  : André Pietersen (IQ Business)
 **/
public class VASRewardHelper implements IProductSystemService {
	/**
	 * @description ApplyReward
	 * @author Clifford Willers : ABSA (IQ Business)
	 * @param vro
	 * @return String
	 **/
	@AuraEnabled
	public static String ApplyReward(String vro) {
		VasRewardsObject details = (VasRewardsObject) JSON.deserialize(vro, VasRewardsObject.class);
		NewMemberRegistration_Req_IB_v1 requestBean = getRequestBean(details);
		//NewMemberRegistration_Req_IB_v1 requestBean = NewMemberRegistration_Req_IB_v1.createDummyRequest();
		NewMemberRegistration_Resp_IB_v1 responsebean = NewMemberRegistration_IH_v1.NewMemberRegistration(requestBean);
		if (responsebean != null) {
			try {
				if (!Test.isRunningTest()) {
					if (responsebean.NewMemberRegistrationResponse.NewMemberRegistrationResult.MembershipNumber != null) {
						Application__c app = [
							SELECT Id, Absa_Reward_MembershipNumber__c, Absa_Rewards_Debit_Day__c, Absa_Rewards_Fee__c
							FROM Application__c
							WHERE Opportunity__c = :details.oppId
						];
						app.Absa_Reward_MembershipNumber__c = responsebean.NewMemberRegistrationResponse.NewMemberRegistrationResult.MembershipNumber;
						app.Absa_Rewards_Fee__c = details.monthlyRewardsFeeValue;
						app.Absa_Rewards_Debit_Day__c = details.rewardDateDebitedValue;
						update app;
					}
				}
			} catch (Exception ex) {
				throw new AuraHandledException('Something went wrong: ' + ex.getMessage() + ' : ' + responsebean.message);
			}
		}

		return responsebean.serialize(responsebean);
	}

	/**
	 * @description getMemberAddress
	 * @author Clifford Willers : ABSA (IQ Business)
	 * @param recordId
	 * @param addressType
	 * @return NewMemberRegistration_Req_IB_v1.MemberAddress
	 **/
	public static NewMemberRegistration_Req_IB_v1.MemberAddress getMemberAddress(String recordId, String addressType) {
		NewMemberRegistration_Req_IB_v1.MemberAddress memberAddress = new NewMemberRegistration_Req_IB_v1.MemberAddress();
		List<Address__c> addressData = new AddressesSelector().selectByAccountAndType(recordId, addressType);
		if (!addressData.isEmpty() && addressData.size() > 0 && addressData != null) {
			memberAddress.AddressLine1 = addressData.get(0).Shipping_Street__c == null ? '' : addressData.get(0).Shipping_Street__c;
			memberAddress.AddressLine2 = '';
			memberAddress.Suburb = addressData.get(0).Shipping_Suburb__c == null ? '' : addressData.get(0).Shipping_Suburb__c;
			memberAddress.City = addressData.get(0).Shipping_City__c == null ? '' : addressData.get(0).Shipping_City__c;
			memberAddress.PostalCode = addressData.get(0).Shipping_Zip_Postal_Code__c == null ? '0' : addressData.get(0).Shipping_Zip_Postal_Code__c;
		} else {
			memberAddress.AddressLine1 = '';
			memberAddress.AddressLine2 = '';
			memberAddress.Suburb = '';
			memberAddress.City = '';
			memberAddress.PostalCode = '0';
		}
		return memberAddress;
	}

	/**
	 * @description getRequestBean
	 * @author Clifford Willers : ABSA (IQ Business)
	 * @param details
	 * @return NewMemberRegistration_Req_IB_v1
	 **/
	public static NewMemberRegistration_Req_IB_v1 getRequestBean(VasRewardsObject details) {
		NewMemberRegistration_Req_IB_v1 requestBean = new NewMemberRegistration_Req_IB_v1();
		Account selectedAccount = new AccountsSelector().selectAllById(details.accountID);
		NewMemberRegistration_Req_IB_v1.MemberAddress postalAddress = getMemberAddress(details.accountID, 'Postal');
		NewMemberRegistration_Req_IB_v1.MemberAddress physicalAddress = getMemberAddress(details.accountID, 'Physical Address');
		String languageTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(
			StringConstants.CIF_STRING,
			StringConstants.FIELD_LANGUAGE,
			selectedAccount.Language__c,
			StringConstants.OUTBOUND_RECORD_TYPE
		);

		List<User> userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		requestBean.NewMemberRegistration = new NewMemberRegistration_Req_IB_v1.NewMemberRegistration();
		requestBean.NewMemberRegistration.source = 'F';
		requestBean.NewMemberRegistration.RegisterMember = new NewMemberRegistration_Req_IB_v1.RegisterMember();
		requestBean.NewMemberRegistration.RegisterMember.ClientKey = selectedAccount.CIF__c;
		requestBean.NewMemberRegistration.RegisterMember.FirstName = selectedAccount.FirstName;
		requestBean.NewMemberRegistration.RegisterMember.Surname = selectedAccount.LastName;
		requestBean.NewMemberRegistration.RegisterMember.Title = returnEmptyString(selectedAccount.Titles__pc);
		requestBean.NewMemberRegistration.RegisterMember.IdentityDocumentNumber = selectedAccount.ID_Number__pc;
		requestBean.NewMemberRegistration.RegisterMember.IdentityDocumentType = returnZero(selectedAccount.ID_Type__pc);
		requestBean.NewMemberRegistration.RegisterMember.HomeLanguage = '1';
		requestBean.NewMemberRegistration.RegisterMember.WorkTelephoneNumber = selectedAccount.Employer_Phone__c;
		requestBean.NewMemberRegistration.RegisterMember.CellNumber = selectedAccount.PersonMobilePhone;
		requestBean.NewMemberRegistration.RegisterMember.FaxNumber = returnZero(selectedAccount.Fax);
		requestBean.NewMemberRegistration.RegisterMember.EmailAddress = selectedAccount.PersonEmail;
		requestBean.NewMemberRegistration.RegisterMember.BankingSector = '';
		requestBean.NewMemberRegistration.RegisterMember.BankTelClientIndicator = '';
		requestBean.NewMemberRegistration.RegisterMember.Gender = returnEmptyString(selectedAccount.Gender__pc);
		requestBean.NewMemberRegistration.RegisterMember.CorrespondenceLanguage = 'CLAENG';
		requestBean.NewMemberRegistration.RegisterMember.DeceasedEstateHold = 'N';
		requestBean.NewMemberRegistration.RegisterMember.DeceasedSpouseHold = 'N';
		requestBean.NewMemberRegistration.RegisterMember.DateOfBirth = returnZero(String.valueOf(selectedAccount.PersonBirthDate));
		requestBean.NewMemberRegistration.RegisterMember.DateVerified = '';
		requestBean.NewMemberRegistration.RegisterMember.OccupationCode = selectedAccount.Occupation_Category__pc;
		requestBean.NewMemberRegistration.RegisterMember.OccupationStatus = selectedAccount.Occupation_Status__pc;
		requestBean.NewMemberRegistration.RegisterMember.OccupationLevel = selectedAccount.Occupation_Level__pc;
		requestBean.NewMemberRegistration.RegisterMember.SbuSegmentIndicator = '';
		requestBean.NewMemberRegistration.RegisterMember.SbuSubSegment = '';
		requestBean.NewMemberRegistration.RegisterMember.DebitOrderFrequency = 'Monthly';
		requestBean.NewMemberRegistration.RegisterMember.DebitOrderDay = details.rewardDateDebitedValue;
		requestBean.NewMemberRegistration.RegisterMember.PreferredStatementNotificationMethod = 'NOMEMA';
		requestBean.NewMemberRegistration.RegisterMember.MarketingConsentTel = String.valueOf(selectedAccount.Is_Marketing_Consent_Phone__c);
		requestBean.NewMemberRegistration.RegisterMember.MarketingConsentPost = String.valueOf(selectedAccount.Is_Marketing_Consent_Post__c);
		requestBean.NewMemberRegistration.RegisterMember.MarketingConsentCell = String.valueOf(selectedAccount.Is_Marketing_Consent_SMS__c);
		requestBean.NewMemberRegistration.RegisterMember.MarketingConsentEmail = String.valueOf(selectedAccount.Is_Marketing_Consent_Email__c);
		requestBean.NewMemberRegistration.RegisterMember.PostalAddress = postalAddress;
		requestBean.NewMemberRegistration.RegisterMember.PhysicalAddress = physicalAddress;
		requestBean.NewMemberRegistration.RegisterMember.DebitOrderAccountNumber = details.rewardDebitedFromValue;
		requestBean.NewMemberRegistration.RegisterMember.DebitOrderAccountProduct = details.rewardDebitAccountType;
		requestBean.NewMemberRegistration.RegisterMember.DebitOrderAccountProductType =  details.rewardDebitProductType;
		requestBean.NewMemberRegistration.RegisterMember.RegistrationSiteCode = userRec[0].SiteCode__c;
		requestBean.NewMemberRegistration.RegisterMember.RegistrationEmployee = userRec[0].EmployeeNumber;
		return requestBean;
	}

	/**
	 * @description returnEmptyString
	 * @author André Pietersen (IQ Business) | 2021-08-31
	 * @param value
	 * @return String
	 **/
	private static String returnEmptyString(String value) {
		return value = value == null ? '' : value;
	}

	/**
	 * @description returnZero
	 * @author André Pietersen (IQ Business) | 2021-08-31
	 * @param value
	 * @return String
	 **/
	private static String returnZero(String value) {
		return value = value == null ? '0' : value;
	}

	/**
	 * @description callProductSystem
	 * @author André Pietersen (IQ Business) | 2021-08-31
	 * @param productId
	 * @return ProductSystemDetails
	 **/
	public static ProductSystemDetails callProductSystem(string productId) {
		RewardsGetlookups_Req_IB_v1 requestBean = new RewardsGetlookups_Req_IB_v1();
		requestBean.rewardsGetlookupsRequest = new RewardsGetlookups_Req_IB_v1.RewardsGetlookupsRequest();
		requestBean.rewardsGetlookupsRequest.getLookups = new RewardsGetlookups_Req_IB_v1.GetLookups();

		requestBean.rewardsGetlookupsRequest.getLookups.source = 'SF';

		RewardsGetlookups_Resp_IB_v1 responseBean = RewardsGetlookups_IH_v1.rewardsGetlookups(requestBean);

		if (responseBean.GetLookupsResponse != null && responseBean.GetLookupsResponse.GetLookupsResult.DebitOrderAmounts.NonStaffMonthlyFee != null) {
			decimal monthlyFee = Decimal.valueOf(responseBean.GetLookupsResponse.GetLookupsResult.DebitOrderAmounts.NonStaffMonthlyFee);
			ProductSystemDetails productSystemDetails = new ProductSystemDetails();
			productSystemDetails.ProductId = productId;
			productSystemDetails.UnitPrice = monthlyFee;
			productSystemDetails.Description = null;

			return productSystemDetails;
		}
		return null;
	}

	/**
	 * @description getRewardsMonthlyFee
	 * @author André Pietersen (IQ Business) | 2021-08-31
	 * @return string
	 **/
	@AuraEnabled
	public static string getRewardsMonthlyFee() {
		try {
			Product2 product = [SELECT Id, Name FROM Product2 WHERE Name = 'Absa Rewards'];
			PricebookEntry priceBookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Product2Id = :product.Id];
			String monthlyFee = String.ValueOf(priceBookEntry.UnitPrice);

			return monthlyFee;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}


	/**
	 * @description getAccountsLinkedToCustomer
	 * @param opportunityId
	 * @param ccApplicationNum
	 * @return List<RewardAccount>
	 **/
	@AuraEnabled
	public static List<VasRewardsObject> getAccountsLinkedToCustomer(String opportunityId, String ccApplicationNum){

		List<VasRewardsObject> accountOptions = new List<VasRewardsObject>();

		User userRec = [
			SELECT Id, SiteCode__c, SiteType__c, Teller_Operator_Code__c, AB_Number__c, EmployeeNumber
			FROM USER
			WHERE Id = :UserInfo.getUserId()
		];

		Opportunity opportunity = [
			SELECT Id, CIF_Number__c
			FROM opportunity 
			WHERE Id = :opportunityId
		];

		CIgetAcctLinkedToClientCodeV3_Req_IB_v1 requestBean = new CIgetAcctLinkedToClientCodeV3_Req_IB_v1();
        
        requestBean.channel = 'SALESFORCE';
        requestBean.application = 'Salesforce';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget = 'STD';
        requestBean.finalMsgClass = '';
        requestBean.finalMsgCode = '';
        requestBean.clientcd = opportunity.CIF_Number__c;
        requestBean.accntnbr = '0';
        requestBean.maxret = '0';
        requestBean.restart = '';
        requestBean.siteCode = userRec.SiteCode__c; 

		CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode(requestBean);

		if(responseBean != null && responseBean.cip047o != null){
			for(CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.OutputTable accountItem : responseBean.cip047o.outputTable ){
				
				if(accountItem.productType == 'CQ' || accountItem.productType == 'SA' || accountItem.productType == 'CC'){
					
					VasRewardsObject account = new VasRewardsObject();
					account.rewardDebitedFromValue = String.valueOf(Long.valueOf(accountItem.oaccntnbr));

					if(accountItem.productType == 'CQ'){
						account.AccountName = account.rewardDebitedFromValue + ' - Cheque';
						account.rewardDebitProductType = 'Cheque';
						account.rewardDebitAccountType = 'C';
					}
					else if(accountItem.productType == 'SA'){
						account.AccountName = account.rewardDebitedFromValue + ' - Savings';
						account.rewardDebitProductType = 'Savings';
						account.rewardDebitAccountType = 'S';
					}
					else{
						account.AccountName = account.rewardDebitedFromValue + ' - Credit Card';
						account.rewardDebitProductType = 'Credit Card';
						account.rewardDebitAccountType = 'CC';
					}

					accountOptions.add(account);
				}
			}
		}

		if(ccApplicationNum != ''){
			VasRewardsObject account = new VasRewardsObject();
			account.rewardDebitedFromValue = ccApplicationNum;
			account.AccountName = ccApplicationNum + ' - Credit Card';
			account.rewardDebitProductType = 'Credit Card';
			account.rewardDebitAccountType = 'CC';
			accountOptions.add(account);
		}

		return accountOptions;
	}

	/**
	 * @description VasRewardsObject
	 * @author André Pietersen (IQ Business) | 2021-08-31
	 **/
	public class VasRewardsObject {
		@AuraEnabled
		public String AccountName;
		@AuraEnabled
		public String oppId;
		@AuraEnabled
		public String accountID;
		@AuraEnabled
		public String rewardDebitedFromValue;
		@AuraEnabled
		public String rewardDateDebitedValue;
		@AuraEnabled
		public String monthlyRewardsFeeValue;
		@AuraEnabled
		public String rewardDebitAccountType;
		@AuraEnabled
		public String rewardDebitProductType;
	}
}