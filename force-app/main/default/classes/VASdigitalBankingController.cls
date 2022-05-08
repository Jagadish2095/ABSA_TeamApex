/**
 * @description       : VASdigitalBankingController
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-11-19
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-24   André Pietersen (IQ Business)   Initial Version
 **/

public without sharing class VASdigitalBankingController {
	public static String feeStructure;
	public static Account acc;
	public static Opportunity opp;
	public static OpportunityLineItem oppproduct;
	public static List<User> userRec;
	public static List<Application__c> app;
	public static Application_Product__c appProd;

	/**
	 * @description checkForInternetBanking
	 * @author André Pietersen (IQ Business) | 2021-06-24
	 * @param oppId
	 * @return Boolean
	 **/
	@AuraEnabled
	public static Boolean checkForInternetBanking(String oppId) {
		setOpportunityDetails(oppId);
		try {
			IBgetClientDetailsV1_Req_IB_v1 requestBean = new IBgetClientDetailsV1_Req_IB_v1();

			IBgetClientDetailsV1_Req_IB_v1.nbsapdpi nbsapdpiRequest = new IBgetClientDetailsV1_Req_IB_v1.nbsapdpi();
			nbsapdpiRequest.application = 'SF';
			nbsapdpiRequest.channel = 'SF';
			nbsapdpiRequest.trace = 'N';

			IBgetClientDetailsV1_Req_IB_v1.nbsmsgi nbsmsgiRequest = new IBgetClientDetailsV1_Req_IB_v1.nbsmsgi();
			nbsmsgiRequest.msgLanguage = 'E';
			nbsmsgiRequest.msgTarget = 'STD';

			IBgetClientDetailsV1_Req_IB_v1.finalMsgId finalMsgIdRequest = new IBgetClientDetailsV1_Req_IB_v1.finalMsgId();
			finalMsgIdRequest.finalMsgClass = '';
			finalMsgIdRequest.finalMsgCode = '';

			IBgetClientDetailsV1_Req_IB_v1.nhs293i nhs293iRequest = new IBgetClientDetailsV1_Req_IB_v1.nhs293i();
			nhs293iRequest.accessAccount = oppproduct.Policy_Number__c;
			nhs293iRequest.branch = userRec[0].SiteCode__c;
			nhs293iRequest.subBranch = '0';
			nhs293iRequest.siteType = userRec[0].SiteType__c;
			nhs293iRequest.teller = userRec[0].Teller_Operator_Code__c;
			nhs293iRequest.manager = '0';
			nhs293iRequest.agencyCode = '0';
			nhs293iRequest.workstation = 'WS';
			nhs293iRequest.supervisor = '0';

			IBgetClientDetailsV1_Req_IB_v1.IBgetClientDetailsV1 ibGetClientDetailsV1bean = new IBgetClientDetailsV1_Req_IB_v1.IBgetClientDetailsV1();
			ibGetClientDetailsV1bean.nbsapdpi = nbsapdpiRequest;
			ibGetClientDetailsV1bean.nbsmsgi = nbsmsgiRequest;
			ibGetClientDetailsV1bean.nhs293i = nhs293iRequest;

			requestBean.IBgetClientDetailsV1 = ibGetClientDetailsV1bean;
			IBgetClientDetailsV1_Resp_IB_v1 responseBean = IBgetClientDetailsV1_IH_v1.IBgetClientDetails(requestBean);

			if (responseBean != null) {
				String registeredForInternet = responseBean.IBgetClientDetailsV1Response.nhs400o.registeredForInternet;
				//System.debug(JSON.serialize(responseBean.IBgetClientDetailsV1Response.nhs400o));
				if (registeredForInternet == 'Y') {
					return true;
				}
			}
			return false;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	/**
	 * @description getAccountPhone
	 * @author Angelina
	 * @param opportunityId
	 * @return String
	 **/
	@AuraEnabled
	public static String getAccountPhone(String opportunityId) {
		Account account = new AccountsSelector().selectByOpportunityId(opportunityId);
		return account.Phone;
	}

	/**
	 * @description enableInternetBanking
	 * @author André Pietersen (IQ Business) | 2021-06-24
	 * @param ibo
	 * @return String
	 **/
	@AuraEnabled
	public static String enableInternetBanking(String ibo) {
		String result = '';
		InternetBankingObject details = (InternetBankingObject) JSON.deserialize(ibo, InternetBankingObject.class);
		//System.debug(details);
		setOpportunityDetails(details.oppId);
		try {
			IBgetRegistrationDetailsV1_Req_v1 requestbeanGRD = new IBgetRegistrationDetailsV1_Req_v1();
			IBgetRegistrationDetailsV1_Req_v1.IBgetRegistrationDetailsV1 ibGetRegistrationDetailsV1bean = new IBgetRegistrationDetailsV1_Req_v1.IBgetRegistrationDetailsV1();
			IBgetRegistrationDetailsV1_Req_v1.finalMsgId finalMsgIdbean = new IBgetRegistrationDetailsV1_Req_v1.finalMsgId();
			IBgetRegistrationDetailsV1_Req_v1.nhp292i nhp292iBean = new IBgetRegistrationDetailsV1_Req_v1.nhp292i();
			IBgetRegistrationDetailsV1_Req_v1.nbsmsgi nbsmsgibean = new IBgetRegistrationDetailsV1_Req_v1.nbsmsgi();
			IBgetRegistrationDetailsV1_Req_v1.nbsapdpi nbsapdpibean = new IBgetRegistrationDetailsV1_Req_v1.nbsapdpi();

			nhp292iBean.subBranch = 'F';
			nhp292iBean.branch = userRec[0].SiteCode__c;
			nhp292iBean.siteType = userRec[0].SiteType__c;
			nhp292iBean.manager = '';
			nhp292iBean.teller = userRec[0].Teller_Operator_Code__c;
			nhp292iBean.agencyCode = '0';
			nhp292iBean.accessAccount = oppproduct.Policy_Number__c;
			nhp292iBean.supervisor = '';
			nhp292iBean.serviceType = 'I';
			nhp292iBean.workstation = '';

			finalMsgIdbean.finalMsgClass = '';
			finalMsgIdbean.finalMsgCode = '';

			nbsmsgibean.msgTarget = 'STD';
			nbsmsgibean.msgLanguage = 'E';
			nbsmsgibean.finalMsgId = finalMsgIdbean;

			nbsapdpibean.trace = 'N';
			nbsapdpibean.application = 'SF';
			nbsapdpibean.channel = 'SF';
			ibGetRegistrationDetailsV1bean.nhp292i = nhp292iBean;
			ibGetRegistrationDetailsV1bean.nbsmsgi = nbsmsgiBean;
			ibGetRegistrationDetailsV1bean.nbsapdpi = nbsapdpiBean;
			requestbeanGRD.IBgetRegistrationDetailsV1 = ibGetRegistrationDetailsV1bean;
			IBgetRegistrationDetailsV1_Resp_v1 responseBeanGRD = IBgetRegistrationDetailsV1_IH_v1.IBgetRegistrationDetailsV1(requestbeanGRD);

			feeStructure = responseBeanGRD.IBgetRegistrationDetailsV1Response.nhp292o.feeStructure;

			IBupdIBRegistrationDetailsV2_Req_IB_v1 requestBeanURD = new IBupdIBRegistrationDetailsV2_Req_IB_v1();
			requestBeanURD.IBupdIBRegistrationDetailsV2 = new IBupdIBRegistrationDetailsV2_Req_IB_v1.IBupdIBRegistrationDetailsV2();

			IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsapdpi nbsapdpi = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsapdpi();
			nbsapdpi.channel = 'SF';
			nbsapdpi.application = 'SF';
			nbsapdpi.trace = 'N';
			requestBeanURD.IBupdIBRegistrationDetailsV2.nbsapdpi = nbsapdpi;

			IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsmsgi nbsmsgi = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nbsmsgi();
			nbsmsgi.msgLanguage = 'E';
			nbsmsgi.msgTarget = 'STD';

			IBupdIBRegistrationDetailsV2_Req_IB_v1.FinalMsgId finalMsgId = new IBupdIBRegistrationDetailsV2_Req_IB_v1.FinalMsgId();
			finalMsgId.finalMsgClass = '';
			finalMsgId.finalMsgCode = '';
			requestBeanURD.IBupdIBRegistrationDetailsV2.nbsmsgi = nbsmsgi;
			requestBeanURD.IBupdIBRegistrationDetailsV2.nbsmsgi.finalMsgId = finalMsgId;

			IBupdIBRegistrationDetailsV2_Req_IB_v1.Nhp295i nhp295i = new IBupdIBRegistrationDetailsV2_Req_IB_v1.Nhp295i();
			nhp295i.branch = userRec[0].SiteCode__c;
			nhp295i.subBranch = 'F';
			nhp295i.siteType = userRec[0].SiteType__c;
			nhp295i.teller = userRec[0].Teller_Operator_Code__c;
			nhp295i.manager = '';
			nhp295i.agencyCode = '0';
			nhp295i.workstation = '';
			nhp295i.supervisor = '';
			nhp295i.accessAccount = oppproduct.Policy_Number__c;
			nhp295i.combiCardNumber = appProd.Debit_Card_Number__c;
			nhp295i.clientType = details.isStokvel ? 'B' : 'I';
			nhp295i.serviceType = 'I';
			nhp295i.numOfAuthRequired = details.numberOfAuths;
			nhp295i.operatorSystemEnabled = 'Y';
			nhp295i.feeStructure = feeStructure;
			nhp295i.costAccount = oppproduct.Policy_Number__c;
			nhp295i.salesEmployeeNumber = userRec[0].EmployeeNumber;
			nhp295i.ussdCellNumber = details.rvnCellphone;
			requestBeanURD.IBupdIBRegistrationDetailsV2.nhp295i = nhp295i;

			IBupdIBRegistrationDetailsV2_Resp_IB_v2 responseBeanURD = IBupdIBRegistrationDetailsV2_IH_v1.IBupdIBRegistrationDetailsV3(requestBeanURD);
			if (responseBeanURD != null && !Test.isRunningTest()) {
				if (responseBeanURD.Fault != null) {
					return result = responseBeanURD.Fault.faultstring;
				} else {
					if (
						(responseBeanURD.IBupdIBRegistrationDetailsV2Response != null) &&
						(responseBeanURD.IBupdIBRegistrationDetailsV2Response.nbsmsgo3 != null) &&
						((responseBeanURD.IBupdIBRegistrationDetailsV2Response.nbsmsgo3.nbrUserMsgs != null))
					)
						if (responseBeanURD.IBupdIBRegistrationDetailsV2Response.nbsmsgo3.nbrUserErrs == 0) {
							return result = 'SUCCESS';
						} else {
							return result = responseBeanURD.IBupdIBRegistrationDetailsV2Response.nbsmsgo3.msgEntry[0].msgTxt;
						}
				}
			}

			return result = 'FAILED';
		} catch (Exception e) {
			// system.debug('Error Message: ' + e.getMessage() + 'Error Cause: ' + e.getCause() + 'Error Where: ' + e.getLineNumber());
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description maintainUserDetails
	 * @author Willy Zuvana (Absa) | 2021-07-08
	 * @param ibo
	 * @return string
	 */
	@AuraEnabled
	public static String maintainUserDetails(String ibo) {
		InternetBankingObject details = (InternetBankingObject) JSON.deserialize(ibo, InternetBankingObject.class);
		setOpportunityDetails(details.oppId);
		String result;
		try {
			IBmaintainUserDetailsV1_Req_IB_v1 requestBean = new IBmaintainUserDetailsV1_Req_IB_v1();
			List<IBmaintainUserDetailsV1_Req_IB_v1.UserDetail> userDetailBeanList = new List<IBmaintainUserDetailsV1_Req_IB_v1.UserDetail>();

			for (InternetBankingUsersObject user : details.users) {
				IBmaintainUserDetailsV1_Req_IB_v1.UserDetail userDetailBean = new IBmaintainUserDetailsV1_Req_IB_v1.UserDetail();
				userDetailBean.option = 'A';
				userDetailBean.userNumber = user.userNumber;
				userDetailBean.userName = user.username;
				userDetailBean.userId = user.idNumber;
				userDetailBean.language = 'E';
				userDetailBeanList.add(userDetailBean);
			}

			requestBean.IBmaintainUserDetailsV1 = new IBmaintainUserDetailsV1_Req_IB_v1.IBmaintainUserDetailsV1();

			requestBean.IBmaintainUserDetailsV1.nbsapdpi = new IBmaintainUserDetailsV1_Req_IB_v1.Nbsapdpi();
			requestBean.IBmaintainUserDetailsV1.nbsapdpi.channel = 'SF';
			requestBean.IBmaintainUserDetailsV1.nbsapdpi.application = 'SF';
			requestBean.IBmaintainUserDetailsV1.nbsapdpi.trace = 'N';

			requestBean.IBmaintainUserDetailsV1.nbsmsgi = new IBmaintainUserDetailsV1_Req_IB_v1.Nbsmsgi();
			requestBean.IBmaintainUserDetailsV1.nbsmsgi.msgLanguage = 'E';
			requestBean.IBmaintainUserDetailsV1.nbsmsgi.msgTarget = 'STD';

			requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId = new IBmaintainUserDetailsV1_Req_IB_v1.FinalMsgId();
			requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId.finalMsgClass = '';
			requestBean.IBmaintainUserDetailsV1.nbsmsgi.finalMsgId.finalMsgCode = '';

			requestBean.IBmaintainUserDetailsV1.nhp299i = new IBmaintainUserDetailsV1_Req_IB_v1.Nhp299i();
			requestBean.IBmaintainUserDetailsV1.nhp299i.branch = userRec[0].SiteCode__c;
			requestBean.IBmaintainUserDetailsV1.nhp299i.subBranch = 'F';
			requestBean.IBmaintainUserDetailsV1.nhp299i.siteType = userRec[0].SiteType__c;
			requestBean.IBmaintainUserDetailsV1.nhp299i.teller = userRec[0].Teller_Operator_Code__c;
			requestBean.IBmaintainUserDetailsV1.nhp299i.manager = '';
			requestBean.IBmaintainUserDetailsV1.nhp299i.agencyCode = '0';
			requestBean.IBmaintainUserDetailsV1.nhp299i.workstation = '';
			requestBean.IBmaintainUserDetailsV1.nhp299i.supervisor = '';
			requestBean.IBmaintainUserDetailsV1.nhp299i.accessAccount = oppproduct.Policy_Number__c;
			requestBean.IBmaintainUserDetailsV1.nhp299i.numberOfUserEntries = string.valueof(userDetailBeanList.size());
			requestBean.IBmaintainUserDetailsV1.nhp299i.userDetail = userDetailBeanList;

			IBmaintainUserDetailsV1_Resp_IB_v1 responseBean = IBmaintainUserDetailsV1_IH_v1.IBmaintainUserDetailsV1(requestBean);

			if (responseBean != null && !Test.isRunningTest()) {
				String nbrUserErrsReturn = responseBean.IBmaintainUserDetailsV1Response.nbsmsgo.nbrUserErrs;
				if (nbrUserErrsReturn == '0') {
					for (InternetBankingUsersObject user : details.users) {
						String rvnResult = setRvnMethod(user);
						if (rvnResult != 'SUCCESS') {
							return rvnResult;
						}
					}

					if (details.isStokvel) {
						String limitResult = setLimitation();
						if (limitResult != 'SUCCESS') {
							return limitResult;
						}
					}
					return result = 'SUCCESS';
				} else {
					return result = responseBean.IBmaintainUserDetailsV1Response.nbsmsgo.msgEntry[0].msgTxt;
				}
			}
			return result = 'FAILED';
		} catch (Exception e) {
			// system.debug('Error Message: ' + e.getMessage() + 'Error Cause: ' + e.getCause() + 'Error Where: ' + e.getLineNumber());
			throw new AuraHandledException(e.getMessage());
		}
	}
	/**
	 * @description setRvnMethod
	 *@param user
	 *@return  string
	 */
	public static String setRvnMethod(InternetBankingUsersObject user) {
		String result;
		try {
			IBupdIBUserNotificationDetailsV1_Req_IB requestBean = new IBupdIBUserNotificationDetailsV1_Req_IB();
			IBupdIBUserNotificationDetailsV1_Req_IB.IBupdIBUserNotificationDetailsV1 iBupdIBUserNotificationDetailsV1Bean = new IBupdIBUserNotificationDetailsV1_Req_IB.IBupdIBUserNotificationDetailsV1();
			IBupdIBUserNotificationDetailsV1_Req_IB.finalMsgId finalMsgIdbean = new IBupdIBUserNotificationDetailsV1_Req_IB.finalMsgId();

			IBupdIBUserNotificationDetailsV1_Req_IB.nbsapdpi nbsapdpibean = new IBupdIBUserNotificationDetailsV1_Req_IB.nbsapdpi();
			nbsapdpibean.trace = 'N';
			nbsapdpibean.application = 'SF';
			nbsapdpibean.channel = 'SF';

			IBupdIBUserNotificationDetailsV1_Req_IB.nbsmsgi nbsmsgibean = new IBupdIBUserNotificationDetailsV1_Req_IB.nbsmsgi();
			finalMsgIdbean.finalMsgClass = '';
			finalMsgIdbean.finalMsgCode = '';

			nbsmsgibean.msgTarget = 'STD';
			nbsmsgibean.msgLanguage = 'E';
			nbsmsgibean.finalMsgId = finalMsgIdbean;

			IBupdIBUserNotificationDetailsV1_Req_IB.nhp297i nhp297iBean = new IBupdIBUserNotificationDetailsV1_Req_IB.nhp297i();

			nhp297iBean.branch = userRec[0].SiteCode__c;
			nhp297iBean.subBranch = '';
			nhp297iBean.siteType = userRec[0].SiteType__c;
			nhp297iBean.teller = userRec[0].Teller_Operator_Code__c;
			nhp297iBean.manager = '0';
			nhp297iBean.agencyCode = '0';
			nhp297iBean.workstation = 'LA';
			nhp297iBean.supervisor = '0';
			nhp297iBean.accessAccount = oppproduct.Policy_Number__c;
			nhp297iBean.userNumber = user.userNumber;
			nhp297iBean.cellphoneNumber = user.cellphoneNumber;
			nhp297iBean.faxCode = '';
			nhp297iBean.faxNumber = '';
			nhp297iBean.email = '';
			nhp297iBean.rvnNotifyMethod = 'S';
			nhp297iBean.alertNotifyMethod = 'S';
			nhp297iBean.popNotifyMethod = 'S';
			nhp297iBean.generalNotifyMethod = 'S';
			nhp297iBean.reminderNotifyMethod = 'S';

			iBupdIBUserNotificationDetailsV1Bean.nbsapdpi = nbsapdpiBean;
			iBupdIBUserNotificationDetailsV1Bean.nbsmsgi = nbsmsgibean;
			iBupdIBUserNotificationDetailsV1Bean.nhp297i = nhp297iBean;
			requestBean.IBupdIBUserNotificationDetailsV1 = iBupdIBUserNotificationDetailsV1Bean;
			IBupdIBUserNotificationDetailsV1_Resp_IB responseBean = IBupdIBUserNotificationDetailsV1_IH_v1.IBupdIBUserNotificationDetailsV1(requestBean);
			if (responseBean != null && !Test.isRunningTest()) {
				String nbrUserErrsReturn = responseBean.IBupdIBUserNotificationDetailsV1Response.nbsmsgo.nbrUserErrs;
				if (nbrUserErrsReturn == '0') {
					return result = 'SUCCESS';
				} else {
					//System.debug('Error: '+responseBean.IBupdIBUserNotificationDetailsV1Response.nbsmsgo.msgEntry[0].msgTxt);
					return result = responseBean.IBupdIBUserNotificationDetailsV1Response.nbsmsgo.msgEntry[0].msgTxt;
				}
			}
			return result = 'FAILED';
		} catch (Exception e) {
			//system.debug('Error Message: ' + e.getMessage() + 'Error Cause: ' + e.getCause() + 'Error Where: ' + e.getLineNumber());
			//throw new AuraHandledException(e.getMessage());
			return result = 'FAILED';
		}
	}
/**
  * @description setLimitation
  * @return string
 */
	public static String setLimitation() {
		String result;
		try {
			IBupdIBLimitsV2_Req_IB_v1 requestBean = new IBupdIBLimitsV2_Req_IB_v1();
			IBupdIBLimitsV2_Req_IB_v1.IBupdIBLimitsV2 IBupdIBLimitsV2Bean = new IBupdIBLimitsV2_Req_IB_v1.IBupdIBLimitsV2();
			IBupdIBLimitsV2_Req_IB_v1.finalMsgId finalMsgIdbean = new IBupdIBLimitsV2_Req_IB_v1.FinalMsgId();
			IBupdIBLimitsV2_Req_IB_v1.nhp297i nhp297iBean = new IBupdIBLimitsV2_Req_IB_v1.Nhp297i();
			IBupdIBLimitsV2_Req_IB_v1.nbsmsgi nbsmsgibean = new IBupdIBLimitsV2_Req_IB_v1.Nbsmsgi();
			IBupdIBLimitsV2_Req_IB_v1.nbsapdpi nbsapdpibean = new IBupdIBLimitsV2_Req_IB_v1.Nbsapdpi();

			nhp297iBean.branch = userRec[0].SiteCode__c;
			nhp297iBean.subBranch = '';
			nhp297iBean.siteType = userRec[0].SiteType__c;
			nhp297iBean.teller = userRec[0].Teller_Operator_Code__c;
			nhp297iBean.manager = '0';
			nhp297iBean.agencyCode = '0';
			nhp297iBean.workstation = 'LA';
			nhp297iBean.supervisor = '0';
			nhp297iBean.accessAccount = oppproduct.Policy_Number__c;
			nhp297iBean.fundTransferLimit = '100000';
			nhp297iBean.stopOrderLimit = '100000';
			nhp297iBean.accountPaymentLimit = '100000';
			nhp297iBean.ownDefinedLimit = '100000';
			nhp297iBean.futureDatedLimit = '100000';
			nhp297iBean.securityOption = 'Y';
			nhp297iBean.uFundTransferLim = '5000';
			nhp297iBean.uAccPayDayLim = '5000';
			nhp297iBean.uAccPayMnthLim = '3000';
			nhp297iBean.uAbsaListedMnthLim = '0';
			nhp297iBean.uOnceoffDayLim = '100000';
			nhp297iBean.uOnceoffMnthLim = '100000';
			nhp297iBean.uAirtimeDayLim = '0';
			nhp297iBean.uAirtimeMnthLim = '0';
			nhp297iBean.uElecDayLim = '0';
			nhp297iBean.uElecMnthLim = '0';
			nhp297iBean.uCashsendDayLim = '0';
			nhp297iBean.uCashsendMnthLim = '0';
			nhp297iBean.uCntclessMnthLim = '0';

			finalMsgIdbean.finalMsgClass = '';
			finalMsgIdbean.finalMsgCode = '';

			nbsmsgibean.msgTarget = 'STD';
			nbsmsgibean.msgLanguage = 'E';
			nbsmsgibean.finalMsgId = finalMsgIdbean;

			nbsapdpibean.trace = 'N';
			nbsapdpibean.application = 'SF';
			nbsapdpibean.channel = 'SF';
			IBupdIBLimitsV2Bean.nhp297i = nhp297iBean;
			IBupdIBLimitsV2Bean.nbsmsgi = nbsmsgiBean;
			IBupdIBLimitsV2Bean.nbsapdpi = nbsapdpiBean;
			requestBean.IBupdIBLimitsV2 = IBupdIBLimitsV2Bean;
			IBupdIBLimitsV2_Resp_IB_v1 responseBean = IBupdIBLimitsV2_IH_v1.IBupdIBLimitsV2(requestBean);
			if (responseBean != null && !Test.isRunningTest()) {
				String nbrUserErrsReturn = responseBean.IBupdIBLimitsV2Response.nbsmsgo3.nbrUserErrs;
				if (nbrUserErrsReturn == '0') {
					return result = 'SUCCESS';
				} else {
					//System.debug('Error: '+responseBean.IBupdIBLimitsV2Response.nbsmsgo3.sysErrTxt);
					return result = responseBean.IBupdIBLimitsV2Response.nbsmsgo3.sysErrTxt;
				}
			}
			return result = 'FAILED';
		} catch (Exception e) {
			//	system.debug('Error Message: ' + e.getMessage() + 'Error Cause: ' + e.getCause() + 'Error Where: ' + e.getLineNumber());
			return 'Error';
			//	throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description setOpportunityDetails
	 * @author André Pietersen (IQ Business) | 2021-06-24
	 * @param oppId
	 * 
	 **/
	@AuraEnabled
	public static void setOpportunityDetails(String oppId) {
		opp = new OpportunitiesSelector().selectByOpptId(oppId);
		acc = new AccountsSelector().selectByOpportunityId(oppId);
		userRec = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		List<OpportunityLineItem> oppproducts = new OpportunityLineItemsSelector().selectByOpportunityId(oppId);

		//find first cheque item linked to opportunity
		for (OpportunityLineItem o : oppproducts) {
			if (o.Product_Family__c == 'Savings' || o.Product_Family__c == 'Cheque') {
				oppproduct = o;
				break;
			}
		}

		app = new ApplicationsSelector().selectByOpportunityBranchId(oppId);
		appProd = [SELECT Debit_Card_Number__c FROM Application_Product__c WHERE Opportunity__c = :oppId AND Opportunity_Product_Id__c = :oppproduct.Id];
	}
	/**
	 * @description getRelatedPartyDetails
	 * @author Happy Baloyi
	 * @param oppId
	 *  @return List<SObject>
	 **/

	@AuraEnabled
	public static List<InternetBankingUsersObject> getRelatedPartiesDetails(String oppId) {
		try {
			acc = new AccountsSelector().selectByOpportunityId(oppId);
			List<InternetBankingUsersObject> wrapperList = new List<InternetBankingUsersObject>();

			for (AccountContactRelation contactRelations : [
				SELECT Contact.FirstName, Contact.LastName, Contact.ID_Number__c, Contact.MobilePhone
				FROM AccountContactRelation
				WHERE AccountId = :acc.Id
			]) {
				InternetBankingUsersObject wrapper = new InternetBankingUsersObject();
				wrapper.username = contactRelations.Contact.FirstName + ' ' + contactRelations.Contact.LastName;
				wrapper.idNumber = contactRelations.Contact.ID_Number__c;
				wrapper.cellphoneNumber = contactRelations.Contact.MobilePhone;
				wrapperList.add(wrapper);
			}

			return wrapperList;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}

	/**
	 * @description InternetBankingUsersObject Description
	 */
	@TestVisible
	public class InternetBankingUsersObject {
		@AuraEnabled
		public String username;
		@AuraEnabled
		public String idNumber;
		@AuraEnabled
		public String userNumber;
		@AuraEnabled
		public String cellphoneNumber;
	}
	/**
	 * @description InternetBankingObject  Description
	 */
	
	@TestVisible
	public class InternetBankingObject {
		public Boolean isStokvel;
		public String oppId;
		public String rvnCellphone;
		public String numberOfAuths;
		public List<InternetBankingUsersObject> users;
	}
}