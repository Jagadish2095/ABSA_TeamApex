/**
 * @description Controller class for DLVoucherDetails cmp
 * @author Jason Quevauvilliers
 * @created 2021-03-02
 */
public without sharing class DLVoucherDetailsController {
	/**
	 * @description calls the DLGetPaymentHistoryForCustomer service
	 * @param cifCode
	 * @param idNumber
	 * @return DLGetPaymentHistoryForCustomer_Resp_IBv1
	 */
	@AuraEnabled
	public static DLGetPaymentHistoryForCustomer_Resp_IBv1 getVoucherDetails(String cifCode, String idNumber) {
		DLGetPaymentHistoryForCustomer_Resp_IBv1 responseBean = DLGetPaymentHistoryForCustomer_IH_v1.getPaymentHistory(cifCode, idNumber);
		return responseBean;
	}

	/**
	 * @description calls the DLGetPaymentHistoryForCustomer service
	 * @param cifCode
	 * @return List<DLGetExceptionReport_Resp_IB_v1.CustomerDigitalLifestyleException_cls>
	 */
	@AuraEnabled
	public static List<DLGetExceptionReport_Resp_IB_v1.CustomerDigitalLifestyleException_cls> getExceptionReport(String cifCode) {
		DLGetExceptionReport_Resp_IB_v1 responseBean = DLGetExceptionReport_IH_v1.getExceptionReport(cifCode);
		return responseBean.customerDigitalLifestyleException;
	}

	/**
	 * @description Saves the selected vouchers as related objects Voucher__c
	 * @param caseId
	 * @param selectedVouchers
	 * @return String
	 */
	@AuraEnabled
	public static String attachVouchersToCase(String caseId, String selectedVouchers) {
		List<Voucher__c> vouchersToInsert = new List<Voucher__c>();
		List<DLGetPaymentHistoryForCustomer_Resp_IBv1.PaymentHistory_cls> voucherList = (List<DLGetPaymentHistoryForCustomer_Resp_IBv1.PaymentHistory_cls>) JSON.deserialize(
			selectedVouchers,
			List<DLGetPaymentHistoryForCustomer_Resp_IBv1.PaymentHistory_cls>.class
		);
		for (DLGetPaymentHistoryForCustomer_Resp_IBv1.PaymentHistory_cls voucher : voucherList) {
			Voucher__c newVoucher = new Voucher__c();
			newVoucher.Name = voucher.voucherDescription;
			newVoucher.Amount__c = Decimal.valueOf(voucher.voucherPaymentAmount);
			newVoucher.Date_of_Purchase__c = Date.valueOf(voucher.dateCreated);
			newVoucher.Voucher_Expiry_Date__c = Date.valueOf(voucher.voucherExpiryDate);
			newVoucher.Order_Number__c = voucher.paymentReference;
			newVoucher.Purchase_Status__c = voucher.transactionStatus;
			newVoucher.Account_Number__c = voucher.sourceAccountNumber;
			newVoucher.Case__c = caseId;
			vouchersToInsert.add(newVoucher);
		}
		try {
			insert vouchersToInsert;
			return 'SUCCESS';
		} catch (Exception e) {
			return 'ERROR ' + e.getMessage() + ' ' + e.getStackTraceString();
		}
	}
}