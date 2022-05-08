/**
 * @description       : Controller class for CreditCardNewAccounts aura component
 * @author            : ephetehe.mokgopanyane@tetrad.co.za
 * @last modified on  : 2021-06-11
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-11   ephetehe.mokgopanyane@tetrad.co.za   Initial Version
 **/

public class CreditCardNewAccountsCtrl {
	/**
	 * @description delete Account
	 * @author ephetehe.mokgopanyane@tetrad.co.za | 2021-06-11
	 * @param appProductId
	 * @return Boolean
	 **/
	@AuraEnabled(Cacheable=false)
	public static Boolean deleteAccount(Id appProductId) {
		Boolean deletion = false;
		Application_Product__c appProduct = new Application_Product__c();
		appProduct.Id = appProductId;

		try {
			delete appProduct;
			deletion = true;
		} catch (Exception exc) {
			throw new AuraHandledException(String.valueOf(exc));
		}

		return deletion;
	}
}