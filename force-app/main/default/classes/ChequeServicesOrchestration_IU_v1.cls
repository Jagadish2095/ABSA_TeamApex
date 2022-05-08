/**
 * @description       : Integration Utility for ChequeServicesOrchestration Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-11
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2020-08-04   Englarmerdge Mongwe   Initial Version
 **/

public class ChequeServicesOrchestration_IU_v1 {
	/**
	 * @description Creates a request bean
	 * @author Englarmerdge Mongwe | 2021-06-11
	 * @param clientCd
	 * @param productFamilies
	 * @param accountNumber
	 * @param siteCode
	 * @param maxRet
	 * @return ChequeServicesOrchestration_Req_IB_v1
	 **/
	public static ChequeServicesOrchestration_Req_IB_v1 mapRequestFields(
		String clientCd,
		String productFamilies,
		String accountNumber,
		String siteCode,
		String maxRet
	) {
		ChequeServicesOrchestration_Req_IB_v1 requestBean = new ChequeServicesOrchestration_Req_IB_v1();

		requestBean.channel = StringConstants.SALESFORCE_STRING;
		requestBean.application = StringConstants.SALESFORCE_STRING;
		requestBean.trace = 'Y';

		requestBean.msgLanguage = 'E';
		requestBean.msgTarget = 'STD';

		requestBean.restart = '';
		requestBean.finalMsgCode = '';
		requestBean.finalMsgClass = '';

		requestBean.clientcd = clientCd;
		requestBean.accntnbr = accountNumber;
		requestBean.siteCode = siteCode;
		requestBean.maxret = maxRet;
		requestBean.productFamilies = generateProductFamilies(productFamilies);

		return requestBean;
	}

	/**
	 * @description Generate Product Families
	 * @author Englarmerdge Mongwe | 2021-06-11
	 * @param productFamilies
	 * @return List<String>
	 **/
	public static List<String> generateProductFamilies(String productFamilies) {
		List<String> productFamilyCodes = new List<String>();

		for (String productFamily : productFamilies.split(',')) {
            productFamilyCodes.add('CQ');
            //Cheque Product should always be sent as default
			if (productFamily.equalsIgnoreCase('Credit Card')) {
				productFamilyCodes.add('CA');
			}
			else if (productFamily.equalsIgnoreCase('Cheque & Overdraft') || !productFamilyCodes.contains('CQ')) {
				productFamilyCodes.add('CQ');
			}
            else if(productFamily.equalsIgnoreCase('Bank Guarantee')){
                productFamilyCodes.add('LD');
            }
		}

		return productFamilyCodes;
	}
}