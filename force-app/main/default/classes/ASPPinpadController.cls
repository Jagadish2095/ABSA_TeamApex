/**
 * @description       : ASPPinpadController
 * @author            : Paul du Randt
 * @last modified on  : 2021-10-07
 * @last modified by  : André Pietersen (IQ Business)
 **/

public class ASPPinpadController {
	/**
	 * @description GetPinPadRequestMetadata
	 * @author Paul du Randt
	 * @param PinpadFunction
	 * @param RecordId
	 * @return String
	 **/
	@AuraEnabled
	public static String GetPinPadRequestMetadata(String PinpadFunction, String RecordId) {
		String RequestJson;
		switch on PinpadFunction {
			when 'ONUSandNOUS' {
				ASPPinPadRequest ONUSandNOUSRequest = new ASPPinPadRequest();
				ONUSandNOUSRequest.Function = PinpadFunction;
				ASPPinpadController.PopulateONUSandNOUSRequest(RecordId, ONUSandNOUSRequest);
				RequestJson = JSON.serialize(ONUSandNOUSRequest);
			}
			when 'NewEPin' {
                ASPPinPadRequest NewEPinRequest = new ASPPinPadRequest();
				NewEPinRequest.Function = PinpadFunction;
				RequestJson = JSON.serialize(NewEPinRequest);
			}
		}
		return RequestJson;
	}

	/**
	 * @description PopulateONUSandNOUSRequest
	 * @author Paul du Randt
	 * @param paymnetplanid
	 * @param ONUSandNOUSrequest
	 **/
	public static void PopulateONUSandNOUSRequest(string paymnetplanid, ASPPinPadRequest ONUSandNOUSrequest) {
		Payment_Plan__c paymentplan = [SELECT Id, Application__c, Reference__c, Amount__c, Account_Number__c FROM Payment_Plan__c WHERE id = :paymnetplanid];
		ONUSandNOUSrequest.ContractReference = paymentplan.Reference__c;
		ONUSandNOUSrequest.ContractAccount = paymentplan.Account_Number__c;
		ONUSandNOUSrequest.ContractMaximunAmount = String.valueOf(paymentplan.Amount__c);

		Application__c application = [SELECT Account__c FROM Application__c WHERE id = :paymentplan.Application__c];
		Account account = [SELECT ID_Number__pc FROM Account WHERE id = :application.Account__c];
		ONUSandNOUSrequest.ContractDebtorID = account.ID_Number__pc;
	}
}