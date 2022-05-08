/**
 * @description Extension Controller for OnboardingFraudRiskScreening Lightning Component
 *
 * @author Manoj Danthala : Absa
 * @version v1.0
 * @since   2021-06-11
 *
 */
public class OnboardingFraudRiskController {
	@AuraEnabled

    /**
	 * @description Call the Fraud Screening Service
	 * @param recordId
	 * @return String
	 */
	public static String callFraudRiskScreening(String recordId) {
		String returnMessage = 'SUCCESS';
		try {
			List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(recordId);

			if (opportunityList[0].Fraud_Status__C != 'Valid') {
				InstinctRiskFraud_Res_IB_v1 responseBean = InstinctRiskFraud_IH_v1.InstinctRiskFraud(opportunityList[0]);
				String fraudStatusResp = responseBean.InstinctFraudCheck_XMLStringResponse.InstinctFraudCheck_XMLStringResult;
				System.debug('Fraud responseBean====>' + fraudStatusResp);
				//String fraudRespAlert = fraudStatusResp.subStringBetween('<Fraud_Alert>','</Fraud_Alert>');
				//String fraudRespAction = fraudStatusResp.subStringBetween('<Action_Taken>','</Action_Taken>');

				DOM.Document doc = new DOM.Document();
				doc.load(fraudStatusResp);
				Dom.XMLNode OutputSchemaNode = doc.getRootElement();
				Dom.XMLNode outputNode = OutputSchemaNode.getChildElement('Output', null);
				System.debug('Fraud_Alert====>' + outputNode.getChildElement('Fraud_Alert', null).getText());
				System.debug('Action_Taken====>' + outputNode.getChildElement('Action_Taken', null).getText());
				System.debug('Error_Code====>' + outputNode.getChildElement('Error_Code', null).getText());
				String fraudRespAlert = outputNode.getChildElement('Fraud_Alert', null).getText();
				String fraudRespAction = outputNode.getChildElement('Action_Taken', null).getText();
				String errorCode = outputNode.getChildElement('Error_Code', null).getText();

				if (errorCode != '') {
					returnMessage = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
						'Fraud Risk',
						'Fraud Risk Error Code',
						errorCode,
						'Outbound'
					);
				} else {
					//UPDATE OPPORTUNITY RECORD WITH FRAUD STATUS
					String fraudAlertInternalValue = '';
					String fraudActionInternalValue = '';

					if (fraudRespAlert != '')
						fraudAlertInternalValue = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
							'Fraud Risk',
							'Fraud Risk Alert',
							fraudRespAlert,
							'Outbound'
						);
					if (fraudRespAction != '')
						fraudActionInternalValue = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(
							'Fraud Risk',
							'Fraud Risk Action',
							fraudRespAction,
							'Outbound'
						);

					System.debug('fraudAlertInternalValue>>>' + fraudAlertInternalValue);
					System.debug('fraudActionInternalValue>>>' + fraudActionInternalValue);
					if (!opportunityList.isEmpty() && opportunityList != null) {
						opportunityList[0].FraudRiskAlert__c = fraudAlertInternalValue;
						opportunityList[0].FraudRiskActionTaken__c = fraudActionInternalValue;
						opportunityList[0].Fraud_Status__c = 'Valid';
						update opportunityList;
					}

					List<Account> accounts = new AccountsSelector().selectCasaFieldsById(opportunityList[0].AccountId, 1);
					System.debug('accounts===--------' + accounts);
					if (!accounts.isEmpty() && accounts != null) {
						accounts[0].FraudRiskAlert__c = fraudAlertInternalValue;
						accounts[0].FraudRiskActionTaken__c = fraudActionInternalValue;
						accounts[0].Fraud_Status__c = 'Valid';
						update accounts;
					}
				}
			}

			System.debug('returnMessage===>' + returnMessage);
			return returnMessage;
		} catch (Exception e) {
			System.debug('Something went wrong: ' + e.getMessage() + ' Line: ' + e.getLineNumber());
			//throw new AuraHandledException('Something went wrong: '+e.getMessage());
		}
		return null;
	}

    /**
	 * @description Get Translations 
	 * @param 
	 * @return List<Integration_Translation__c>
	 */
	public static List<Integration_Translation__c> getTranslations() {
		List<Integration_Translation__c> translations = [
			SELECT Id, External_Value__c, Internal_Value__c
			FROM Integration_Translation__c
			WHERE System_Name__c = 'Fraud Risk'
		];
		return translations;
	}

    /**
	 * @description Get Opportunity Record
	 * @param recordId
	 * @return Opportunity
	 */
	@AuraEnabled
	public static Opportunity getOpportunityData(String recordId) {
		System.debug('Opportunity Record Id==>' + recordId);
		try {
			List<Opportunity> oppList = new OpportunitiesSelector().selectByOpportunityId(recordId);
			Account accounts = new AccountsSelector().selectByOpportunityId(recordId);
            if(oppList[0].FraudRiskAlert__c == 'Clean' && accounts.SPM_Platform_Type__c != null){
               oppList[0].StageName = 'Provide and Record Client Advice'; 
               update oppList[0];
            }
			return oppList[0];
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
}