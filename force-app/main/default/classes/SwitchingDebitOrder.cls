/**
 * @description       : SwitchingDebitOrder class
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-17   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment
**/
public class SwitchingDebitOrder{
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String serviceProvider {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String refAccountNumber {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String dueDate {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String frequency {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String amount {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String fixvar {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String action {get; set;}
    /**
 	* @description accountId
 	*/
	@AuraEnabled public String opportunityId {get; set;}
    /**
 	* @description accountId
 	*/
    @AuraEnabled public String pendingDebitOrderId {get; set;}
}