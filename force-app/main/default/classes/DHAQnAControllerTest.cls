/**
 * @description Integration Test Class for DHAQnAController
 * @author  Koketso Mpshane
 * @date    09/11/2021
 */
@isTest
public class DHAQnAControllerTest {

	static String ClientIdNumber = '7710256047181';
	static String PositiveDecision = 'Yes Cert Correct';
	static String NegativeDecision = 'No Cert Incorrect';
	static String Template = 'DHA Unit Test';
	static Integer ActualCount = 0;
	static String ActualValue = '';
	static Integer ExpectedCount = 0;
	static String ExpectedValue = '';
	static Date CloseDate = Date.today();
	static String Stage = 'New';

	/**
	 * @description dataCreation
	 */
	@testSetup
	static void dataCreation() {

		Account Client = AccountTDF.addIndividualClient('Individual', 'vcAccount');
        Client.ID_Number__pc = ClientIdNumber;
        update Client;

        Questionnaire_Template__c template = DHAQnAControllerTDF.addQuestionnaireTemplate(Template);
		Questionnaire_Question__c q1 = DHAQnAControllerTDF.addQuestionnaireQuestion(template.Id, PositiveDecision, 'Yes, certificate detail is correct');
		Questionnaire_Question__c q2 = DHAQnAControllerTDF.addQuestionnaireQuestion(template.Id, NegativeDecision, 'No, certificate detail is not correct');
	}


	/**
	 * @description Method to test Hanis Service
	 */
	@IsTest
	static void testCallHanisService() {

        Test.setMock(HttpCalloutMock.class, new HanisValidate_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list < String > {
            StringConstants.HANIS_VALIDATE
        });

		Test.startTest();

		String dhaQnA = DHAQnAController.callHanisService('8911270127087');
        System.assert(dhaQnA.startsWith('{'), 'Assert failed');

		Test.stopTest();
	}

	/** W-016515
	* @description
	* @author Lehlohonolo.Matsoso@absa.africa | 2022-03-02
	**/
	@IsTest
	static void submitDhaAttestDecisionTest() {
		Account Client  = [SELECT Id FROM Account LIMIT 1];

		Test.startTest();
		ExpectedCount = 0;
		ActualCount = [SELECT count() FROM Questionnaire_Answer__c];
		System.assertEquals(ExpectedCount, ActualCount);

		ExpectedCount = 2; // an anwser for each question, 2 in this case
		DHAQnAController.submitDhaAttestDecision(Template, Client.Id, PositiveDecision.replaceAll(' ',''));
		ActualCount = [SELECT count() FROM Questionnaire_Answer__c];

		System.assertEquals(ExpectedCount, ActualCount);

		DHAQnAController.submitDhaAttestDecision(Template, Client.Id, PositiveDecision.replaceAll(' ',''));

		// count shouldn't increase
		System.assertEquals(ExpectedCount, ActualCount);

		Test.stopTest();
	}

}