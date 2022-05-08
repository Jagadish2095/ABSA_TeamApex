/**
 * @description       : Controller class for ApplicationAIPS aura component
 * @author            : Ephetehe Mokgopanyane
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Ephetehe Mokgopanyane   Initial Version
 **/

public class ApplicationAIPSCTRL {
	/**
	 * @description gets AIPS data from service if it is available in Salesforce or returns AIPS data in Salesforce
	 * @author Ephetehe Mokgopanyane | 2021-06-12
	 * @param opportunityId
	 * @return Map<String, Object>
	 **/
	@AuraEnabled(Cacheable=false)
	public static Map<String, Object> getAipsData(Id opportunityId) {
		Map<String, Object> errorMap = new Map<String, Object>();
		Application__c application = new ApplicationsSelector().selectByCreditOpportunityId(opportunityId);

		if (application != null) {
			if (application.AIPS__c == null) {
				String effectiveDate = String.valueOf(System.today().format()).replace('/', '');
				IPlistNCARatesV1_Req_IB_v1 requestBean = generateJsonRequest(effectiveDate);
				IPlistNCARatesV1_Resp_IB_v1 responseBean = IPlistNCARatesV1_IH_v1.IPlistNCARatesV1(requestBean);

				if (responseBean != null) {
					if (responseBean.IPlistNCARatesV1Response != null) {
						if (responseBean.IPlistNCARatesV1Response.nbsmsgo3 != null) {
							if (responseBean.IPlistNCARatesV1Response.nbsmsgo3.nbrUserMsgs == 0) {
								application.AIPS__c = JSON.serialize(responseBean);

								try {
									update application;
								} catch (Exception exc) {
									system.debug('error ' + exc);
								}

								return translateJSONResponse(responseBean);
							} else {
								errorMap.put('Error', responseBean.statusCode);
								return errorMap;
							}
						}
					}
				}
			} else {
				return translateJSONResponse((IPlistNCARatesV1_Resp_IB_v1) JSON.deserialize(application.AIPS__c, IPlistNCARatesV1_Resp_IB_v1.class));
			}
		}

		return null;
	}

	/**
	 * @description
	 * @author Ephetehe Mokgopanyane | 2021-06-12
	 * @param application
	 * @return Map<String, Object>
	 **/
	public static Map<String, Object> getAipsData(Application__c application) {
		Map<String, Object> errorMap = new Map<String, Object>();

		if (application != null) {
			if (application.AIPS__c == null) {
				String effectiveDate = String.valueOf(System.today().format()).replace('/', '');
				IPlistNCARatesV1_Req_IB_v1 requestBean = generateJsonRequest(effectiveDate);
				IPlistNCARatesV1_Resp_IB_v1 responseBean = IPlistNCARatesV1_IH_v1.IPlistNCARatesV1(requestBean);

				if (responseBean != null) {
					if (responseBean.IPlistNCARatesV1Response != null) {
						if (responseBean.IPlistNCARatesV1Response.nbsmsgo3 != null) {
							if (responseBean.IPlistNCARatesV1Response.nbsmsgo3.nbrUserMsgs == 0) {
								application.AIPS__c = JSON.serialize(responseBean);

								try {
									update application;
								} catch (Exception exc) {
									system.debug('error ' + exc);
								}

								return translateJSONResponse(responseBean);
							} else {
								errorMap.put('Error', responseBean.statusCode);
								return errorMap;
							}
						}
					}
				}
			} else {
				return translateJSONResponse((IPlistNCARatesV1_Resp_IB_v1) JSON.deserialize(application.AIPS__c, IPlistNCARatesV1_Resp_IB_v1.class));
			}
		}

		return null;
	}

	/**
	 * @description changes the aips data into an easily useable format
	 * @author Ephetehe Mokgopanyane | 2021-06-12
	 * @param responseBean
	 * @return Map<String, Object>
	 **/
	private static Map<String, Object> translateJSONResponse(IPlistNCARatesV1_Resp_IB_v1 responseBean) {
		IPlistNCARatesV1_Resp_IB_v1.IPlistNCARatesV1Response ipListNCARatesV1Response = responseBean.IPlistNCARatesV1Response;
		IPlistNCARatesV1_Resp_IB_v1.Ipb100o ipb100o = ipListNCARatesV1Response.ipb100o;

		Map<String, Object> applicationAIPS = new Map<String, Object>();
		applicationAIPS.put('creditFacilitiesMax', ipb100o.ncaMaxifeeCfMax);
		applicationAIPS.put('creditFacilitiesNext', ipb100o.ncaMaxifeeCfNext);
		applicationAIPS.put('creditFacilitiesTP', ipb100o.ncaMaxifeeCfPerc);
		applicationAIPS.put('creditFacilitiesFirst', ipb100o.ncaMaxifeeCfFirst);
		applicationAIPS.put('creditFacilitiesMaxSF', ipb100o.ncaMaxfeeCfMaxsf);
		applicationAIPS.put('creditFacilitiesMDIR', ipb100o.ncaMaxrateCfMaxdr);
		applicationAIPS.put('mortgageAgreementsMDIR', ipb100o.ncaMaxrateMaMaxdr);
		applicationAIPS.put('mortgageAgreementsFirst', ipb100o.ncaMaxifeeMaFirst);
		applicationAIPS.put('mortgageAgreementsMaxSF', ipb100o.ncaMaxfeeMaMaxsf);
		applicationAIPS.put('mortgageAgreementsMax', ipb100o.ncaMaxifeeMaMax);
		applicationAIPS.put('mortgageAgreementsNext', ipb100o.ncaMaxifeeMaNext);
		applicationAIPS.put('mortgageAgreementsTP', ipb100o.ncaMaxifeeMaPerc);
		applicationAIPS.put('otherCreditAgreementsFirst', ipb100o.ncaMaxifeeOcaFirst);
		applicationAIPS.put('otherCreditAgreementsMaxSF', ipb100o.ncaMaxfeeOcaMaxsf);
		applicationAIPS.put('otherCreditAgreementsMax', ipb100o.ncaMaxifeeOcaMax);
		applicationAIPS.put('otherCreditAgreementsMDIR', ipb100o.ncaMaxrateOcaMaxdr);
		applicationAIPS.put('otherCreditAgreementsNext', ipb100o.ncaMaxifeeOcaNext);
		applicationAIPS.put('otherCreditAgreementsTP', ipb100o.ncaMaxifeeOcaPerc);
		applicationAIPS.put('primeRate', ipb100o.primeRate);
		applicationAIPS.put('repurchaseRate', ipb100o.repurchaseRate);
		applicationAIPS.put('shortTermCreditTransactionsFirst', ipb100o.ncaMaxifeeStctFirst);
		applicationAIPS.put('shortTermCreditTransactionsMaxSF', ipb100o.ncaMaxfeeStctMaxsf);
		applicationAIPS.put('shortTermCreditTransactionsMax', ipb100o.ncaMaxifeeStctMax);
		applicationAIPS.put('shortTermCreditTransactionsMDIR', ipb100o.ncaMaxrateStctMaxdr);
		applicationAIPS.put('shortTermCreditTransactionsNext', ipb100o.ncaMaxifeeStctNext);
		applicationAIPS.put('shortTermCreditTransactionsTP', ipb100o.ncaMaxifeeStctPerc);
		applicationAIPS.put('unsecuredCreditTransactionsFirst', ipb100o.ncaMaxifeeUctFirst);
		applicationAIPS.put('unsecuredCreditTransactionsMaxSF', ipb100o.ncaMaxfeeUctMaxsf);
		applicationAIPS.put('unsecuredCreditTransactionsMax', ipb100o.ncaMaxifeeUctMax);
		applicationAIPS.put('unsecuredCreditTransactionsMDIR', ipb100o.ncaMaxrateUctMaxdr);
		applicationAIPS.put('unsecuredCreditTransactionsNext', ipb100o.ncaMaxifeeUctNext);
		applicationAIPS.put('unsecuredCreditTransactionsTP', ipb100o.ncaMaxifeeUctPerc);

		return applicationAIPS;
	}

	/**
	 * @description
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @param effectiveDate
	 * @return IPlistNCARatesV1_Req_IB_v1
	 **/
	public static IPlistNCARatesV1_Req_IB_v1 generateJsonRequest(String effectiveDate) {
		IPlistNCARatesV1_Req_IB_v1 requestBean = new IPlistNCARatesV1_Req_IB_v1();
		IPlistNCARatesV1_Req_IB_v1.IPlistNCARatesV1 IPlistNCARatesV1 = new IPlistNCARatesV1_Req_IB_v1.IPlistNCARatesV1();

		IPlistNCARatesV1_Req_IB_v1.Ipb100i Ipb100i = new IPlistNCARatesV1_Req_IB_v1.Ipb100i();
		Ipb100i.brandCode = 'ABS';
		Ipb100i.effectiveDate = effectiveDate;
		IPlistNCARatesV1_Req_IB_v1.Nbsapdpi Nbsapdpi = new IPlistNCARatesV1_Req_IB_v1.Nbsapdpi();
		Nbsapdpi.application = '';
		Nbsapdpi.channel = '';
		Nbsapdpi.trace = 'N';
		IPlistNCARatesV1_Req_IB_v1.FinalMsgId FinalMsgId = new IPlistNCARatesV1_Req_IB_v1.FinalMsgId();
		FinalMsgId.finalMsgClass = '';
		FinalMsgId.finalMsgCode = '';

		IPlistNCARatesV1_Req_IB_v1.Nbsmsgi Nbsmsgi = new IPlistNCARatesV1_Req_IB_v1.Nbsmsgi();
		Nbsmsgi.msgLanguage = 'E';
		Nbsmsgi.msgTarget = 'STD';
		Nbsmsgi.finalMsgId = FinalMsgId;

		IPlistNCARatesV1.ipb100i = Ipb100i;
		IPlistNCARatesV1.nbsapdpi = Nbsapdpi;
		IPlistNCARatesV1.nbsmsgi = Nbsmsgi;
		requestBean.IPlistNCARatesV1 = IPlistNCARatesV1;

		return requestBean;
	}
}