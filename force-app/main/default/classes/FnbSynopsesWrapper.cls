/**
 * @description       :
 * @author            : André Pietersen (IQ Business)
 * @modified on  : 2021-08-11
 * @modified by  : André Pietersen (IQ Business)
 * @modified on  : 2021-09-29
 * @modified by  : Brian Maswanganyi
 **/
public class FnbSynopsesWrapper {
	/**
	 * @description Product
	 * @author André Pietersen (IQ Business) | 2021-08-11
	 **/
	public class Product {
		@AuraEnabled
		public String Code;
		@AuraEnabled
		public String Description;
		@AuraEnabled
		public String ProductId;
		@AuraEnabled
		public String Synopsis;
		@AuraEnabled
		public String PackageChargeOption;
		@AuraEnabled
		public String RecommendedIncome;
		@AuraEnabled
		public String MonthlyFee;
		@AuraEnabled
		public String ChequeFee;
		@AuraEnabled
		public String CreditCardFee;
		@AuraEnabled
		public String FacilityFee;
		@AuraEnabled
		public String PdfUrl;
		@AuraEnabled
		public Boolean IsSelected;
		@AuraEnabled
		public Boolean IsAvailableForSelection;

		/**
		 * @description Product
		 * @author André Pietersen (IQ Business) | 2021-08-11
		 **/
		public Product() {
		}
	}
}