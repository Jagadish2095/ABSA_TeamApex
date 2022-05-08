/**
 * @description Integration Utility for ServiceCustomerEligibility Service
 * @author  Kabelo Aphane
 * @date    16/04/2021
 * @updated Koketso Mpshane 30/04/2021
 */
public class ServiceCustomerEligibility_IU_V1 {
    /**
	 * @description mapRequestFields method
	 * @param SPID
	 * @param Phonenumber
	 * @param accType
	 * @param amount
	 * @param retrievalRefNumber
	 * @return ServiceCustomerEligibility_Req_IB_V1
	 */
	public static ServiceCustomerEligibility_Req_IB_V1 mapRequestFields(
		String SPID,
		String Phonenumber,
		String accType,
		String amount,
		String retrievalRefNumber
	) {
		ServiceCustomerEligibility_Req_IB_V1 requestBean = new ServiceCustomerEligibility_Req_IB_V1();
		requestBean.SPID = SPID;
		requestBean.Phonenumber = Phonenumber;
		requestBean.AcctTyp = accType;
		requestBean.Amount = amount;
		requestBean.CurrencyCode = '710';
		requestBean.RetrievalReferenceNumber = retrievalRefNumber;
		requestBean.TermID = Label.MobileTopUpServiceTermID;
		requestBean.CardAccptrID = Label.MobileTopUpServiceCardAccptrID;
		requestBean.CardAccptrNameLocation = Label.MobileTopUpServiceCardAccptrNameLocation;

		return requestBean;
	}
}