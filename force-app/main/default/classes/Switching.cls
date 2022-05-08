/**
 * @description       : Switching class
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-17   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
 **/

public class Switching {
	/**
	 * @description accountId
	 */
	@AuraEnabled
	public String accountId { get; set; }
	/**
	 * @description opportunityId
	 */
	@AuraEnabled
	public String opportunityId { get; set; }
	/**
	 * @description accountId
	 */
	@AuraEnabled
	public Boolean isSalary { get; set; }
	/**
	 * @description isDebitOrder
	 */
	@AuraEnabled
	public Boolean isDebitOrder { get; set; }
	/**
	 * @description pendingSalarySwitchId
	 */
	@AuraEnabled
	public String pendingSalarySwitchId { get; set; }

	//Salary fields
	/**
	 * @description previousAccountHolder
	 */
	@AuraEnabled
	public String previousAccountHolder { get; set; }
	/**
	 * @description previousAccountNumber
	 */
	@AuraEnabled
	public String previousAccountNumber { get; set; }
	/**
	 * @description previousBank
	 */
	@AuraEnabled
	public String previousBank { get; set; }
	/**
	 * @description previousAccountType
	 */
	@AuraEnabled
	public String previousAccountType { get; set; }
	/**
	 * @description employer
	 */
	@AuraEnabled
	public String employer { get; set; }
	/**
	 * @description datePaid
	 */
	@AuraEnabled
	public String datePaid { get; set; }

	//Debit order fields
	/**
	 * @description debitOrders
	 */
	@AuraEnabled
	public String debitOrders { get; set; }
}