/**
 * @description       :
 * @author            : Mradul Maheshwari
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id           : W-005674
 **/
public with sharing class CalculatorRequest_IU_v1 {
	/**
	 * @description mapRequestFields
	 * @author Mradul Maheshwari | 08-18-2021
	 * @param  accountNumber
	 * @param  advanceAmount
	 * @return CalculatorRequest_Req_IB_v1
	 **/
	public static CalculatorRequest_Req_IB_v1 mapRequestFields(String accountNumber, String advanceAmount) {
		CalculatorRequest_Req_IB_v1 requestbean = new CalculatorRequest_Req_IB_v1();
		requestBean.accountNumber = accountNumber.replaceFirst('^0+', '').leftPad(11, '0');
		requestBean.advanceAmount = advanceAmount;
		requestBean.systemId = 'Salesforce';
		return requestBean;
	}
}