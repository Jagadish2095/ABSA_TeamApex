/**
 * @description Controller to send various letter requests
 * @author  Chandra Bhushan Singh : Absa
 * @version v2.0
 * @since   2020-11-04
 */
public class AvafSettlementQuoteController {
	/**
	 * @description Method to send Settlement Quote
	 * @param accountId String
	 * @param accountNumber String
	 * @param email String
	 * @return String
	 */
	@AuraEnabled
	public static String sendAvafSettlementQuote(String accountId, String accountNumber, String email) {
		AccountsSelector accountSelector = new AccountsSelector();
		Account caseAccount = accountSelector.selectAllById(accountId);
		AvafSettlementQuote_Resp_IB_v1 responseBean = AvafSettlementQuote_IH_v1.settlementQuoteRequest(
			caseAccount.ID_Number__pc,
			email,
			caseAccount.FirstName,
			accountNumber,
			caseAccount.LastName
		);
		if (responseBean.statusCode == 200 || responseBean.statusCode == 202) {
			return 'success';
		} else {
			return responseBean.message;
		}
	}
	/**
	 * @description Method to send Paid Up Letter
	 * @param accountId String
	 * @param accountNumber String
	 * @param email String
	 * @return String
	 */
	@AuraEnabled
	public static String sendPaidUpLetter(String accountId, String accountNumber, String email) {
		AccountsSelector accountSelector = new AccountsSelector();
		Account caseAccount = accountSelector.selectAllById(accountId);
		AvafPaidUpLetterRequest_Resp_IB_v1 responseBean = AvafPaidUpLetterRequest_IH_v1.avafPaidUpLetter(
			caseAccount.ID_Number__pc,
			email,
			caseAccount.FirstName,
			accountNumber,
			caseAccount.LastName
		);
		if (responseBean.statusCode == 200 || responseBean.statusCode == 202) {
			return 'success';
		} else {
			return responseBean.message;
		}
	}
	/**
	 * @author  Bhanumurty Rayala : Absa
	 * @User Story	W-009261: Copy NATIS
	 * @created   2021-03-11
	 * @description Method to send Copy NATIS
	 * @param accountId String
	 * @param accountNumber String
	 * @param email String
	 * @return String
	 */
	@AuraEnabled
	public static String sendCopyNatisLetter(String accountId, String accountNumber, String email) {
		AccountsSelector accountSelector = new AccountsSelector();
		Account caseAccount = accountSelector.selectAllById(accountId);
		AVAFCopyOfNatis_Resp_IB_v1 responseBean = AVAFCopyOfNatis_IH_v1.avafCopyOfNatis(
			caseAccount.ID_Number__pc,
			email,
			caseAccount.FirstName,
			accountNumber,
			caseAccount.LastName
		);
		if (responseBean.statusCode == 200 || responseBean.statusCode == 202) {
			return 'success';
		} else {
			return responseBean.message;
		}
	}
}