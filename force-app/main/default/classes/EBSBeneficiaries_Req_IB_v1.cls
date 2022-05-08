/**
 * @description Integration Request Bean for EBSBeneficiaries Service
 * @author Koketso Mpshane
 * @created 2021-07-19
 */
public class EBSBeneficiaries_Req_IB_v1 extends Base_IB {
    
    public String cifKey;
	public String sourceAccount;
    
    /**
	 * @description method used for dummy request
	 * @return EBSBeneficiaries_Req_IB_v1
	 */
	public static EBSBeneficiaries_Req_IB_v1 createDummyRequest() {
		EBSBeneficiaries_Req_IB_v1 requestBean = new EBSBeneficiaries_Req_IB_v1();
		requestBean.cifKey = 'JINPIX 001';
		requestBean.sourceAccount = '04483850000192464';

		return requestBean;
	}

}