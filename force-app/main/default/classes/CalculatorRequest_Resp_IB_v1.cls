/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class CalculatorRequest_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public CalculatorResults calculatorResults;
	/**
	 * @description       : CalculatorResults
	 * @author            : Mradul Maheshwari
	 **/
	public class CalculatorResults {
		@AuraEnabled
		public List<CalculatorResult> calculatorResult;
	}
	/**
	 * @description       : CalculatorResult
	 * @author            : Mradul Maheshwari
	 **/
	public class CalculatorResult {
		@AuraEnabled
		public Integer newCalculatedInstalmentsNo;
		@AuraEnabled
		public Integer newContractEndDate;
		@AuraEnabled
		public Double newResidual;
		@AuraEnabled
		public Double newInstalment;
		@AuraEnabled
		public Integer newTerm;
		@AuraEnabled
		public String restructureType;
	}
}