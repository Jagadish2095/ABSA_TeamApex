/**
 * @description Response Integration Bean for AccountSearch Service
 * @author Sourabh Yadav
 * @created 2021-08-17
 */
public with sharing class AccountSearch_Resp_IB_v1 extends Base_IB {
	/*
    public class PrimaryOwnerAddress {
        public String addressLine1 {get;set;} 
        public Object addressLine2 {get;set;} 
        public String addressLine3 {get;set;} 
        public String city {get;set;} 
        public Object county {get;set;} 
        public Object state {get;set;} 
        public String postalCode {get;set;} 
        public String countryCode {get;set;} 
        
    }
    */
	@AuraEnabled
	public String message;
	/**
	 * @description CurrentBalance
	 * @author Sourabh Yadav
	 * @created 2021-08-17
	 */
	public class CurrentBalance {
		@AuraEnabled
		public Double amount;
		@AuraEnabled
		public Object currencyRefCode;
	}

	/** 
	 * @description Data
	 * @author Sourabh Yadav
	 * @created 2021-08-17
	 */
	public class Data {
		 @AuraEnabled public Boolean includedInConsumerBalance;
		 @AuraEnabled public Integer accountAgencyIdentifier;
         @AuraEnabled public Integer primaryOwnerAgencyIdentifier;
		/* public String creditorExternalAccountId {get;set;} 
        public String creditorReferenceId {get;set;} 
        public String primaryOwnerFirstName {get;set;} 
        public String primaryOwnerLastName {get;set;} 
        public String primaryOwnerSsnIdentifier {get;set;} 
        public String primaryOwnerHomePhone {get;set;}
        public Object chargeOffDate {get;set;} 
        public Object receiver {get;set;} 
        public Creditor creditor {get;set;} */
		@AuraEnabled
		public CurrentBalance currentBalance;
		/* public PrimaryOwnerAddress primaryOwnerAddress {get;set;} 
        public Long primaryOwnerDateOfBirth {get;set;} 
        public String creditorAccountLegacyIdentifier {get;set;} 
        public Object commercialName {get;set;} 
        public String commercialContactName {get;set;} 
        public String businessKey {get;set;} */
	}

	@AuraEnabled
	public Integer total;
	@AuraEnabled
	public String status;
	@AuraEnabled
	public List<Data> data;
	@AuraEnabled
	public String statusMessage;
	@AuraEnabled
	public Integer statusCode;
}