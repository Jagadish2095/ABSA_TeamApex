/**
 * @description Integration Utility for ServiceAccountAdjustment Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 30/04/2021
 */
public class ServiceAccountAdjustment_IU_V1 {
	/**
	 * @description mapRequestFields method
	 * @param SPID
	 * @param Phonenumber
	 * @param accType
	 * @param accNumber
	 * @param amount
	 * @param retrievalRefNumber
	 * @return ServiceAccountAdjustment_Req_IB_V1
	 */
	public static ServiceAccountAdjustment_Req_IB_V1 mapRequestFields(
		String SPID,
		String Phonenumber,
		String accType,
		String accNumber,
		String amount,
		String retrievalRefNumber
	) {
		ServiceAccountAdjustment_Req_IB_V1 requestBean = new ServiceAccountAdjustment_Req_IB_V1();
		requestBean.SPID = SPID;
		requestBean.Phonenumber = Phonenumber;
		requestBean.AcctTyp = accType;
		requestBean.AccNumber = AccNumber;
		requestBean.Amount = amount;
		requestBean.CurrencyCode = '710';
		requestBean.RetrievalReferenceNumber = retrievalRefNumber;
		requestBean.TermID = Label.MobileTopUpServiceTermID;
		requestBean.CardAccptrID = Label.MobileTopUpServiceCardAccptrID;
		requestBean.CardAccptrNameLocation = Label.MobileTopUpServiceCardAccptrNameLocation;

		return requestBean;
	}
}