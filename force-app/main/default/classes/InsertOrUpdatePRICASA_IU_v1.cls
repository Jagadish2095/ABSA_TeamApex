/*
 * Integration Utilities Bean for InsertOrUpdatePRICASA Service
 * @author
 * @updated 2019-03-16 - Pitso (InceptionDate addition)
 * @updated 2019-10-10 - Vladimir (5 new priContact fields)
 * @updated 2020-04-17 - Pitso (W-004283 - EPP_INC0864081 - Commission reflecting on Performance Model)
 */
/**
 * @description mapRequestFields
 *
 *
 */
public class InsertOrUpdatePRICASA_IU_v1 {
	/**
	 * @description mapRequestFields
	 * @param accP (Account)
	 * @param opportunityP (Opportunity)
	 * @param userP (User)
	 * @param quoteP (Quote)
	 * @return Return InsertOrUpdatePRICASA_Req_IB_v1
	 */
	public static InsertOrUpdatePRICASA_Req_IB_v1 mapRequestFields(Account accP, Opportunity opportunityP, User userP, Quote quoteP) {
		InsertOrUpdatePRICASA_Req_IB_v1 bean = new InsertOrUpdatePRICASA_Req_IB_v1();

		List<InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI_Contact> priContactList = new List<InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI_Contact>();
		InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI_Contact priContact = new InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI_Contact();
		priContact.IsPrimaryMVG = 'Y'; //hard-coded constant value
		priContact.ContactIdenInformation = accP.ID_Number__pc;
		priContact.ContactIdenType = accP.ID_Type__pc;
		//Vladimir start
		priContact.ContactFirstName = accP.FirstName;
		priContact.ContactLastName = accP.LastName;
		if (accP.PersonHomePhone != '' && accP.PersonHomePhone != null) {
			priContact.ContactHomePhone = formatPhoneNumber(accP.PersonHomePhone);
		}
		if (accP.Phone != '' && accP.Phone != null) {
			priContact.ContactWorkPhone = formatPhoneNumber(accP.Phone);
		}
		if (accP.PersonMobilePhone != '' && accP.PersonMobilePhone != null) {
			priContact.ContactMobilePhone = formatPhoneNumber(accP.PersonMobilePhone);
		}
		//Vladimir end
		priContactList.add(priContact);

		InsertOrUpdatePRICASA_Req_IB_v1.cls_ListOfPRI_contact listOfPriCls = new InsertOrUpdatePRICASA_Req_IB_v1.cls_ListOfPRI_contact();
		listOfPriCls.PRI_Contact = priContactList;

		List<InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI> priList = new List<InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI>();
		InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI pri = new InsertOrUpdatePRICASA_Req_IB_v1.cls_PRI();
		pri.CommissionBrokerCode = userP.Advisor_Code__c;
		//Pitso start
		//pri.ExpectedCommission = string.valueOf(quoteP.Commission_1st_Year__c + quoteP.Commission_2nd_Year__c);
		if (opportunityP.Product_Interest__r.Product__c == 'STI')
			pri.ExpectedCommission = '0';
		else
			pri.ExpectedCommission = string.valueOf(quoteP.Commission_1st_Year__c);
		//Pitso end
		if (opportunityP.Policy_Income_Type__c != null && opportunityP.Product_Interest__r.Product__c == 'STI')
			pri.PolicyIncomeTypeCode = '54';
		else
			pri.PolicyIncomeTypeCode = '1'; //hard-coded constant value
		System.debug('opportunityP.Policy_Inception_Date__c' + opportunityP.Policy_Inception_Date__c);
		if (opportunityP.Product_Interest__r.Product__c == 'STI' && opportunityP.Policy_Inception_Date__c != null) {
			DateTime Policy_Inception_Raw = opportunityP.Policy_Inception_Date__c;
			pri.InceptionDate = Policy_Inception_Raw.format('MM/dd/yyyy');
		} else {
			DateTime Commencement_Date_Raw = opportunityP.Commencement_Date__c;
			pri.InceptionDate = Commencement_Date_Raw.format('MM/dd/yyyy');
		}
		if (opportunityP.Product_Interest__r.Product__c == 'STI' && opportunityP.Product_Provider__c != null) {
			String providerCode;
			if (opportunityP.Product_Provider__c == 'AIC- ABSA Insurance Company')
				providerCode = '110';
			else if (opportunityP.Product_Provider__c == 'AIC/WEBSURE')
				providerCode = '267';
			else if (opportunityP.Product_Provider__c == 'AIC/PLATINUM INSURE WEBSURE')
				providerCode = '112';
			else if (opportunityP.Product_Provider__c == 'AUTO&GENERAL INSURANCE CO')
				providerCode = '121';
			pri.ProductProviderCode = providerCode;
		} else
			pri.ProductProviderCode = '002'; //hard-coded constant value
		if (opportunityP.Product_Interest__r.Product__c == 'STI' && opportunityP.STI_Policy_Number__c != null)
			pri.PolicyNumber = opportunityP.STI_Policy_Number__c;
		pri.ProposalNumber = opportunityP.SyncedQuoteId;
		pri.SourceCode = '999999'; //hard-coded constant value
		pri.ListOfPRI_Contact = listOfPriCls;
		priList.add(pri);

		InsertOrUpdatePRICASA_Req_IB_v1.cls_ListOfPRI priListCls = new InsertOrUpdatePRICASA_Req_IB_v1.cls_ListOfPRI();
		priListCls.PRI = priList;

		InsertOrUpdatePRICASA_Req_IB_v1.cls_OperationalDetail operationalDetail = new InsertOrUpdatePRICASA_Req_IB_v1.cls_OperationalDetail();
		operationalDetail.BusinessProcess = 'Estate Provider Plan'; //hard-coded constant value
		operationalDetail.CASAAnalystComments = accP.CASA_Analyst_Comments__pc;
		operationalDetail.CASAReferenceNumber = accP.CASA_Reference_Number__pc;
		operationalDetail.CASAScreeningDate = String.valueOf(accP.CASA_Screening_Date__pc);
		operationalDetail.CASAScreeningStatus = accP.CASA_Screening_Status__pc;
		operationalDetail.RiskProfilingDate = string.valueOf(opportunityP.Risk_Rating_Date__c);
		operationalDetail.RiskProfilingStatus = opportunityP.Risk_Rating__c;
		operationalDetail.Source = 'Salesforce'; //hard-coded constant value

		InsertOrUpdatePRICASA_Req_IB_v1.cls_InsertOrUpdatePRICASA_Input PRICASA = new InsertOrUpdatePRICASA_Req_IB_v1.cls_InsertOrUpdatePRICASA_Input();
		PRICASA.ListOfPRI = priListCls;
		PRICASA.OperationalDetail = operationalDetail;

		bean.InsertOrUpdatePRICASA_Input = PRICASA;

		System.debug('bean: ' + bean);

		return bean;
	}
	/**
	 * @description mapResponseFields
	 * @param respP (HttpResponse)
	 *
	 * @return Return InsertOrUpdatePRICASA_Req_IB_v1
	 */
	public static InsertOrUpdatePRICASA_Resp_IB_v1 mapResponseFields(HttpResponse respP) {
		System.debug('respP.getBody(): ' + respP.getBody());
		InsertOrUpdatePRICASA_Resp_IB_v1 responseBean = (InsertOrUpdatePRICASA_Resp_IB_v1) JSON.deserialize(
			respP.getBody(),
			InsertOrUpdatePRICASA_Resp_IB_v1.class
		);
		responseBean.status = respP.getStatus();
		responseBean.statusCode = respP.getStatusCode();
		System.debug('responseBean: ' + responseBean);
		return responseBean;
	}
	/** 
    * @description mapFailedResponseFields
    * @param statusCodeP (Integer)
    * @param statusP (String)
    * @param messageP (String)
    
    * @return Return InsertOrUpdatePRICASA_Req_IB_v1
    */
	public static InsertOrUpdatePRICASA_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP) {
		InsertOrUpdatePRICASA_Resp_IB_v1 responseBean = new InsertOrUpdatePRICASA_Resp_IB_v1();
		responseBean.status = statusP;
		responseBean.statusCode = statusCodeP;
		responseBean.errormsg = messageP;

		return responseBean;
	}

	/** 
    * @description formatPhoneNumber
    * @param unformatedPhoneNumber (string)
   
    
    * @return Return string
    */
	private static string formatPhoneNumber(string unformatedPhoneNumber) {
		String formatedPhoneNumber = unformatedPhoneNumber.deleteWhitespace();
		return formatedPhoneNumber;
	}
}