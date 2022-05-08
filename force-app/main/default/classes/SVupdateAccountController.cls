/**
 *@description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   05-03-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class SVupdateAccountController {
	public static List<User> userP;
	public static Opportunity opportunity;
	public static OpportunityLineItem opportunityLineItem;
	public static Account account;

	/**
	 * @description updateAccountOpeningDetails
	 * @return string
	 * @param opportunityId
	 * @param accountNumber
	 * @param brokerNumber
	 * @param openReasonCode
	 * @param accountname
	 * @param clientCode
	 * @param depositType
	 */
	@AuraEnabled
	public static string updateAccountOpeningDetails(
		String opportunityId,
		String accountNumber,
		String brokerNumber,
		String openReasonCode,
		String accountname,
		String clientCode,
		String depositType
	) {
		account = new AccountsSelector().selectByOpportunityId(opportunityId);
		userP = new UsersSelector().userwithSiteCode(UserInfo.getUserId());

		SVupdateAccount_Req_IB_v1 requestBean = new SVupdateAccount_Req_IB_v1().getNewInstance();
		requestBean.SVSP09I = new SVupdateAccount_Req_IB_v1.SVSP09I();
		requestBean.SVSP09I.SVSP09I_INPUT_AREA = new SVupdateAccount_Req_IB_v1.SVSP09I_INPUT_AREA();
		// system.debug('name ' +accountname );
		//system.debug('accountNumber ' +accountNumber);
		requestBean.NBSAPDPI.NBSAPLI.channel = 'SALESFORCE';
		requestBean.NBSAPDPI.NBSAPLI.application = 'SALESFORCE';
		requestBean.NBSAPDPI.NBSAPLI.trace = 'N';
		requestBean.MSGI.NBSMSGI.messageLanguage = 'E';
		requestBean.MSGI.NBSMSGI.messageTarget = 'STD';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.accountNumber = accountNumber;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.savingsDepositType =  depositType;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.openReasonCode = openReasonCode;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.accountName = accountname;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.groupSchemeCode = '0';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.homeEmployPlanCode = '  ';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.grantType = '0';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.specialAccountType = 'N';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.brokerSource = '';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.brokerNumber = ''; //use the one from the screen
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.crpCode = clientCode;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.divisionCode = 'ABS';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.workStation = 'AA';
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.branchCode = userP[0].SiteCode__c;
		// system.debug('name1 ' +userP[0].SiteCode__c );
		//system.debug('name2 ' +userP[0].SiteType__c );
		//system.debug('name3 ' +userP[0].Teller_Operator_Code__c );
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.agencyCode = userP[0].SiteCode__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.agencySiteType = userP[0].SiteType__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.tellerCode = userP[0].Teller_Operator_Code__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.supervisorCode = '0'; //userP[0].Supervisor__c;
		requestBean.SVSP09I.SVSP09I_INPUT_AREA.branchSiteType = userP[0].SiteType__c;

		try {
			string retuncode = '';

			SVupdateAccount_Resp_IB_v1 responseBean = SVupdateAccountOpeningDetailsV2.updateAccountOpeningDetails(requestBean);
			
			if (
				responseBean != null &&
				responseBean.nBSMSGO != null &&
				responseBean.nBSMSGO.nBSMSGO3 != null &&
				responseBean.nBSMSGO.nBSMSGO3.messageEntry != null &&
				(!String.isBlank(responseBean.nBSMSGO.nBSMSGO3.messageEntry[0].messageText))
			) {
				retuncode = 'Error ' + responseBean.nBSMSGO.nBSMSGO3.messageEntry[0].messageText;
			
			} else //(responseBean != null && responseBean.NBSAPDPO != null && responseBean.NBSAPDPO.NBSAPLO != null && responseBean.NBSAPDPO.NBSAPLO.returnCode != null){
			{
				retuncode = 'success'; //String.valueOf(responseBean.NBSAPDPO.NBSAPLO.returnCode);
				
			}
			return retuncode;
		} catch (Exception e) {
			throw e;
		}
	}
}