/**
 * @description Apex Class DigitalHoldUpdate
 * @author  Mbuyiseni Mbhokane
 * @version v1.0
 * @since   2020-01-31
 * @updated 2021-05-27
 *
 */
public class DigitalHoldUpdate {
	private Id opportunityId;
	private String accountNumberP;
	public static Boolean isSuccess = false;
	private static final String FULFILL_PRODUCT = 'Fulfill Product';
	private static final String CHEQUE = 'Cheque';
	private static final String SAVINGS = 'Savings';
	private static final String NO = 'N';

	public static Map<Opportunity, List<Sys_Log_Integration__c>> mapOppDigitalHoldLogs = new Map<Opportunity, List<Sys_Log_Integration__c>>();
	/**
	 * @description digitalHoldUpdateCall changed enqueue job to static method
	 * @param getOpportunity
	 * @return Map<Opportunity,List<Sys_Log_Integration__c>>
	 */
	public static Map<Opportunity, List<Sys_Log_Integration__c>> digitalHoldUpdateCall(Opportunity getOpportunity) {
		//Get opportunityLineItem
		if (getOpportunity.Id != null) {
			OpportunityLineItem opportunityProduct = new OpportunityLineItemsSelector().selectByOppId(getOpportunity.Id, 1);

			if (opportunityProduct != null) {
				//Call service for Cheque
				if (!String.isBlank(opportunityProduct.Policy_number__c) && opportunityProduct.Product2.family.containsIgnoreCase(CHEQUE)) {
					//call update holds method
					Map<CQupdAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4(
						opportunityProduct.Policy_number__c,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO,
						NO
					);
					if (!responseMap.isEmpty()) {
						CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (new List<CQupdAcctHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];

						//response logs list
						List<Sys_Log_Integration__c> responseLogs = responseMap.values()[0];

						//List to upsert the logs
						List<Sys_Log_Integration__c> createSysLogs = new List<Sys_Log_Integration__c>();

						//get the digital hold message to be populated to an opportunity.
						List<Opportunity> getDigitaMsg = new OpportunitiesSelector().selectByOpportunityId(getOpportunity.id);

						if (responseBean != null) {
							if (responseBean.statusCode == 200) {
								//Indicator to check if it should call domicile change service or not.
								isSuccess = true;

								//this field is used on the validation rule.
								getDigitaMsg[0].DigitalHoldSuccess__c = true;

								//Get the message
								getDigitaMsg[0].Digital_Hold_Response__c = String.isNotBlank(responseBean.CQupdAcctHoldsV4Response.nbsmsgo3.msgEntry.msgTxt)
									? responseBean.CQupdAcctHoldsV4Response.nbsmsgo3.msgEntry.msgTxt
									: responseBean.CQupdAcctHoldsV4Response.cqh525o.confirmationDetails.get(0).details;
							} else {
								//get message
								getDigitaMsg[0].Digital_Hold_Response__c = responseBean.message;

								//Change the opportunity back when the service fails
								getDigitaMsg[0].StageName = FULFILL_PRODUCT;
							}

							//Looping through the returned logs
							for (Sys_Log_Integration__c resLog : responseLogs) {
								resLog.Status__c = responseBean.message;
								resLog.Status_Code__c = responseBean.statusCode;
								resLog.Response__c = JSON.serialize(responseBean);
								createSysLogs.add(resLog);
							}

							if ((!createSysLogs.isEmpty()) && (createSysLogs != null)) {
								try {
									//Upsert createSysLogs;
									//update getDigitaMsg;
									mapOppDigitalHoldLogs.put(getDigitaMsg[0], createSysLogs);
								} catch (DmlException e) {
									System.debug('The following exception has occurred: ' + e.getMessage());
								}
							}
						}
					}
				}

				//Call service for Savings
				System.debug('opportunityProduct.Policy_number__c: ' + opportunityProduct.Policy_number__c);
				if (!String.isBlank(opportunityProduct.Policy_number__c) && opportunityProduct.Product2.family.containsIgnoreCase(SAVINGS)) {
					String offlEnqFrDt = '0';
					String securityNumber = '0';

					try {
						//Get the Running user - Sipho Mbulawa 07/02/2021
						User runningUser = new UsersSelector().selectById(Userinfo.getUserId());
						System.debug('***********SITE CODE : ' + runningUser.SiteCode__c);
						System.debug('***********TELLER CODE : ' + runningUser.Teller_Operator_Code__c);
						System.debug('***********SUPERVISOR CODE : ' + runningUser.Supervisor__c);

						//Call the service Method
						Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> savingsResponseMap = SVupdateAccountHoldsV4_IH_v1.callTosvupdateaccountholdsV4(
							opportunityProduct.Policy_number__c,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							NO,
							offlEnqFrDt,
							NO,
							securityNumber,
							NO,
							runningUser.SiteCode__c,
							runningUser.Teller_Operator_Code__c,
							runningUser.Supervisor__c
						);
						System.debug('savingsResponseMap : ' + savingsResponseMap);

						if ((!savingsResponseMap.isEmpty()) && (savingsResponseMap != null)) {
							//Get the response
							SVupdateAccountHoldsV4_Resp_IB_v1 savingsResponseBean = (new List<SVupdateAccountHoldsV4_Resp_IB_v1>(
								savingsResponseMap.keySet()
							))[0];
							System.debug('savingsResponseBean: ' + savingsResponseBean);

							//Get the logs
							List<Sys_Log_Integration__c> savingsResponseLogs = savingsResponseMap.values()[0];

							System.debug('savingsResponseLogs : ' + savingsResponseLogs);
							//List to upsert the logs
							List<Sys_Log_Integration__c> savingsLogsUpsert = new List<Sys_Log_Integration__c>();

							//get the digital hold message to be populated to an opportunity.
							List<Opportunity> savingsOpportunity = new OpportunitiesSelector().selectByOpportunityId(getOpportunity.Id);

							if (savingsResponseBean != null) {
								System.debug('savingsResponseBean.statusCode : ' + savingsResponseBean.statusCode);

								if (savingsResponseBean.statusCode == 200) {
									//Indicator to check if it should call domicile change service or not.
									isSuccess = true;
									savingsOpportunity[0].DigitalHoldSuccess__c = true;
									savingsOpportunity[0]
										.Digital_Hold_Response__c = savingsResponseBean.SVupdateAccountHoldsV4Response.nbsmsgo3.msgEntry.msgTxt;
								} else {
									//testing success
									isSuccess = true;
									savingsOpportunity[0].Digital_Hold_Response__c = savingsResponseBean.message;

									//Change the opportunity back when the service fails
									savingsOpportunity[0].StageName = FULFILL_PRODUCT;
								}

								for (Sys_Log_Integration__c serResLog : savingsResponseLogs) {
									serResLog.Status__c = savingsResponseBean.message;
									serResLog.Status_Code__c = savingsResponseBean.statusCode;
									serResLog.Response__c = JSON.serialize(savingsResponseBean);
									savingsLogsUpsert.add(serResLog);
								}

								System.debug('savingsLogsUpsert : ' + savingsLogsUpsert);
								//check null
								if ((!savingsLogsUpsert.isEmpty()) && (savingsLogsUpsert != null)) {
									//upsert savingsLogsUpsert;
									//update savingsOpportunity;
									mapOppDigitalHoldLogs.put(savingsOpportunity[0], savingsLogsUpsert);
								}
							}
						}
					} catch (Exception exc) {
						System.debug('Exception Occured' + exc.getMessage() + 'At Line number' + exc.getLineNumber());
					}
				}
			}
		}

		System.debug('isSuccess : ' + isSuccess);

		/*if(isSuccess){
            if(!Test.isRunningTest() ){
               //Call the domicile change
                //System.enqueueJob(new DomicileChange(opportunityId));
            }
        }*/
		return mapOppDigitalHoldLogs;
	}
}