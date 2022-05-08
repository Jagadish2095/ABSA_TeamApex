/**
 * @description       : Test class for ROA Controller
 * @author            : Celliers Inggs
 * @last modified on  : 2021-11-08
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author                        Modification
 * 1.0   2021-06-14   PaulJohn.duRand@absa.africa
 * 1.1   2021-06-18   PaulJohn.duRand@absa.africa   W-013133 ROA fix for Checkbox questions removes answers for previous answers fix
 * 1.2   2021-08-11   Diksha.Wasekar@absa.africa    W-014279 Product Selection story for Voice without ROA questions
 **/
@isTest
public class ROAControllerTest {
	@isTest
	static void testGetNextQuestion() {
		ROAQuestion__c question1 = new ROAQuestion__c();
		question1.AnswerType__c = 'dropdown';
		question1.QuestionId__c = 'PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME';
		question1.QuestionText__c = 'How much is your monthly income?';
		insert question1;

		ROAQuestion__c question2 = new ROAQuestion__c();
		question2.AnswerType__c = 'radio';
		question2.QuestionId__c = 'PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY';
		question2.QuestionText__c = 'Can you afford the financial product?';
		insert question2;

		ROAAnswer__c answer1 = new ROAAnswer__c();
		answer1.AnswerId__c = 'PACKAGES_NO_FIXED_INCOME';
		answer1.AnswerList__c = 'PACKAGES_YES_PRODUCTS,PACKAGES_NO_PRODUCTS';
		answer1.AnswerText__c = 'No';
		answer1.NextQuestion__c = 'PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS';
		answer1.NextStage__c = 'ROA';
		answer1.RecommendedProducts__c = '';
		insert answer1;

		ROAAnswer__c answer2 = new ROAAnswer__c();
		answer2.AnswerId__c = 'PACKAGES_YES_FIXED_INCOME';
		answer2.AnswerList__c = 'PACKAGES_YES_PRODUCTS,PACKAGES_NO_PRODUCTS';
		answer2.AnswerText__c = 'Yes';
		answer2.NextQuestion__c = 'PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS';
		answer2.NextStage__c = 'ROA';
		answer2.RecommendedProducts__c = '';
		insert answer2;

		ROAAnswer__c answer3 = new ROAAnswer__c();
		answer3.AnswerId__c = 'PACKAGES_R4000_TO_R24999';
		answer3.AnswerList__c = 'PACKAGES_YES_I_CAN_AFFORD,PACKAGES_NO_I_CAN_NOT_AFFORD';
		answer3.AnswerText__c = 'R4000 - R24999';
		answer3.NextQuestion__c = 'PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY';
		answer3.NextStage__c = 'END_ROA';
		answer3.RecommendedProducts__c = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE';
		insert answer3;

		ROAAnswer__c answer4 = new ROAAnswer__c();
		answer4.AnswerId__c = 'PACKAGES_NO_PRODUCTS';
		answer4.AnswerList__c = 'PACKAGES_R4000_TO_R24999,PACKAGES_R25000_TO_R62499,PACKAGES_R62500_PLUS';
		answer4.AnswerText__c = 'No';
		answer4.NextQuestion__c = 'PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME';
		answer4.NextStage__c = 'ROA';
		answer4.RecommendedProducts__c = '';
		insert answer4;

		ROAAnswer__c answer5 = new ROAAnswer__c();
		answer5.AnswerId__c = 'PACKAGES_R25000_TO_R62499';
		answer5.AnswerList__c = 'PACKAGES_YES_I_CAN_AFFORD,PACKAGES_NO_I_CAN_NOT_AFFORD';
		answer5.AnswerText__c = 'R25000 - R62499';
		answer5.NextQuestion__c = 'PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY';
		answer5.NextStage__c = 'END_ROA';
		answer5.RecommendedProducts__c = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
		insert answer5;

		ROAAnswer__c answer6 = new ROAAnswer__c();
		answer6.AnswerId__c = 'PACKAGES_YES_PRODUCTS';
		answer6.AnswerList__c = 'PACKAGES_SAVINGS_OR_INVESTMENTS,PACKAGES_TRANSACTIONAL,PACKAGES_CHEQUES,PACKAGES_LENDING,PACKAGES_INSURANCE,PACKAGES_NO_I_CAN_NOT_AFFORD';
		answer6.AnswerText__c = 'Yes';
		answer6.NextQuestion__c = 'PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE';
		answer6.NextStage__c = 'ROA';
		answer6.RecommendedProducts__c = '';
		insert answer6;

		ROAAnswer__c answer7 = new ROAAnswer__c();
		answer7.AnswerId__c = 'PACKAGES_R62500_PLUS';
		answer7.AnswerList__c = 'PACKAGES_YES_I_CAN_AFFORD,PACKAGES_NO_I_CAN_NOT_AFFORD';
		answer7.AnswerText__c = 'R62500+';
		answer7.NextQuestion__c = 'PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY';
		answer7.NextStage__c = 'END_ROA';
		answer7.RecommendedProducts__c = 'ABSA_CURRENT_ACCOUNT_GOLD_PACKAGE,ABSA_CURRENT_ACCOUNT_PREMIUM_PACKAGE';
		insert answer7;

		string answerId = 'PACKAGES_R4000_TO_R24999';
		string currentQuestionId = 'PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME';
		List<String> possibleAnswers = new List<String>{ 'PACKAGES_R25000_TO_R62499', 'PACKAGES_R4000_TO_R24999', 'PACKAGES_R62500_PLUS' };
		Integer sequenceNumber = 3;
		string questionTracker = '[{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_FIXED_INCOME"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_FIXED_INCOME"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_PRODUCTS"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_PRODUCTS"}]';
		Test.startTest();
		String result = ROAController.getNextQuestion(answerId, currentQuestionId, possibleAnswers, sequenceNumber, questionTracker);
        String recommendedProd = ROAController.getrecommendedProducts(answerId);
		Test.stopTest();
		System.assert(result != null, 'Test Working');
	}

    @isTest
	static void testStokvelGetNextQuestion() {
		ROAQuestion__c question1 = new ROAQuestion__c();
		question1.AnswerType__c = 'radio';
		question1.QuestionId__c = 'WHICH_PRODUCTS_ARE_INTERESTED_IN';
		question1.QuestionText__c = 'Which products(s) are you interested in?';
		insert question1;

		ROAQuestion__c question2 = new ROAQuestion__c();
		question2.AnswerType__c = 'radio';
		question2.QuestionId__c = 'SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS';
		question2.QuestionText__c = 'How would you want to contribute towards your savings?';
		insert question2;

        ROAQuestion__c question3 = new ROAQuestion__c();
		question2.AnswerType__c = 'radio';
		question2.QuestionId__c = 'SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS';
		question2.QuestionText__c = 'How do you want to access your invested funds?';
		insert question3;

		ROAAnswer__c answer1 = new ROAAnswer__c();
		answer1.AnswerId__c = 'SAVINGS_OR_INVESTMENT';
		answer1.AnswerList__c = 'SHARIAH_COMPLAINT,TAX_FREE_PRODUCTS,STAFF_PRODUCTS,GENERAL_SAVINGS_AND_INVESTMENTS_PRODUCTS';
		answer1.AnswerText__c = 'Savings/Investment';
		answer1.NextQuestion__c = 'WHICH_PRODUCTS_ARE_INTERESTED_IN';
		answer1.NextStage__c = 'ROA';
		answer1.RecommendedProducts__c = '';
		insert answer1;

		ROAAnswer__c answer2 = new ROAAnswer__c();
		answer2.AnswerId__c = 'GENERAL_SAVINGS_AND_INVESTMENTS_PRODUCTS';
		answer2.AnswerList__c = 'A_ONCE_OFF_LUMP_SUM,A_ONCE_OFF_LUMP_SUM_WITH_REGULAR_CONTRIBUTION,A_REGULATOR_CONTRIBUTION';
		answer2.AnswerText__c = 'General savings and investment products';
		answer2.NextQuestion__c = 'SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS';
		answer2.NextStage__c = 'ROA';
		answer2.RecommendedProducts__c = '';
		insert answer2;

		ROAAnswer__c answer3 = new ROAAnswer__c();
		answer3.AnswerId__c = 'A_REGULATOR_CONTRIBUTION';
		answer3.AnswerList__c = 'GET_ACCESS_TO_ALL_MY_FUNDS_WHENEVER_REQUIRED,GET_ACCESS_TO_A_PORTION_OF_MY_FUNDS_WHENEVER_REQUIRED,GIVE_NOTICE_WHEN_I_NEED_FUNDS,GET_FUNDS_AT_MATURITY';
		answer3.AnswerText__c = 'A regular contribution';
		answer3.NextQuestion__c = 'SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS';
		answer3.NextStage__c = 'ROA';
		answer3.RecommendedProducts__c = 'ABSA_CLUB,NOTICE_SELECT,ISLAMIC_TARGET_SAVE,ABSA_TRAVEL_CLUB,GROCERY_CLUB';
		insert answer3;

		ROAAnswer__c answer4 = new ROAAnswer__c();
		answer4.AnswerId__c = 'GET_ACCESS_TO_ALL_MY_FUNDS_WHENEVER_REQUIRED';
		answer4.AnswerList__c = '';
		answer4.AnswerText__c = 'Get access to all my funds whenever required';
		answer4.NextQuestion__c = '';
		answer4.NextStage__c = 'END_ROA';
		answer4.RecommendedProducts__c = 'ABSA_CLUB,ABSA_TRAVEL_CLUB,GROCERY_CLUB';
		insert answer4;

		string answerId = 'GET_ACCESS_TO_ALL_MY_FUNDS_WHENEVER_REQUIRED';
		string currentQuestionId = '';
		List<String> possibleAnswers = new List<String>{ 'PACKAGES_R25000_TO_R62499', 'PACKAGES_R4000_TO_R24999', 'PACKAGES_R62500_PLUS' };
		Integer sequenceNumber = 3;
		string questionTracker = '[{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"TAX_FREE_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"STAFF_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":true,"answerType":"radio","answerId":"GENERAL_SAVINGS_AND_INVESTMENTS_PRODUCTS"},{"sequenceNumber":1,"recommendedProducts":null,"questionId":"WHICH_PRODUCTS_ARE_INTERESTED_IN","isSelected":false,"answerType":"radio","answerId":"SHARIAH_COMPLAINT"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":true,"answerType":"radio","answerId":"A_REGULATOR_CONTRIBUTION"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":false,"answerType":"radio","answerId":"A_ONCE_OFF_LUMP_SUM"},{"sequenceNumber":2,"recommendedProducts":null,"questionId":"SAVINGS_HOW_WOULD_YOU_WANT_TO_CONTRIBUTE_TOWARDS_YOUR_SAVINGS","isSelected":false,"answerType":"radio","answerId":"A_ONCE_OFF_LUMP_SUM_WITH_REGULAR_CONTRIBUTION"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GET_FUNDS_AT_MATURITY"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GET_ACCESS_TO_A_PORTION_OF_MY_FUNDS_WHENEVER_REQUIRED"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":true,"answerType":"radio","answerId":"GET_ACCESS_TO_ALL_MY_FUNDS_WHENEVER_REQUIRED"},{"sequenceNumber":3,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":"GIVE_NOTICE_WHEN_I_NEED_FUNDS"},{"sequenceNumber":4,"recommendedProducts":null,"questionId":"SAVINGS_HOW_DO_YOU_WANT_TO_ACCESS_YOUR_INVESTED_FUNDS","isSelected":false,"answerType":"radio","answerId":""}]]';
		Test.startTest();
		String result = ROAController.getNextQuestion(answerId, currentQuestionId, possibleAnswers, sequenceNumber, questionTracker);
		Test.stopTest();
		System.assert(result != null, 'Test Working');
	}

	@isTest
	static void testSortingOfValues() {
		List<ROAController.ROANextQuestionAnswer> nextQuestin = new List<ROAController.ROANextQuestionAnswer>();
		ROAController.ROANextQuestionAnswer nextQuestion1 = new ROAController.ROANextQuestionAnswer();
		nextQuestion1.answerId = '01';
		nextQuestion1.answerText = 'R15000 - R249999';
		nextQuestin.add(nextQuestion1);
		ROAController.ROANextQuestionAnswer nextQuestion2 = new ROAController.ROANextQuestionAnswer();
		nextQuestion2.answerId = '02';
		nextQuestion2.answerText = 'R0 - R2 999';
		nextQuestin.add(nextQuestion2);
		ROAController.ROANextQuestionAnswer nextQuestion3 = new ROAController.ROANextQuestionAnswer();
		nextQuestion3.answerId = '03';
		nextQuestion3.answerText = 'R1000 - R100000';
		nextQuestin.add(nextQuestion3);
		ROAController.ROANextQuestionAnswer nextQuestion4 = new ROAController.ROANextQuestionAnswer();
		nextQuestion4.answerId = '04';
		nextQuestion4.answerText = 'R0 - R2 999';
		nextQuestin.add(nextQuestion4);
		Test.startTest();
		nextQuestin.sort();
		System.assertEquals(nextQuestin[0].AnswerId, '02', 'First is 2');
		Test.stopTest();
	}

	@isTest
	static void listOfQuestionsIdToTextTest() {
		Test.startTest();
		String result = ROAController.listOfQuestionsIdToText(
			'[{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_FIXED_INCOME"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_FIXED_INCOME"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_PRODUCTS"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_PRODUCTS"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_CHEQUES"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_INSURANCE"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_LENDING"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_SAVINGS_OR_INVESTMENTS"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":true,"AnswerType":"checkbox","AnswerId":"PACKAGES_TRANSACTIONAL"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_R25000_TO_R62499"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_R4000_TO_R24999"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_R62500_PLUS"},{"sequenceNumber":6,"RecommendedProducts":null,"QuestionId":"PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY","IsSelected":false,"AnswerType":"radio","AnswerId":"PACKAGES_NO_I_CAN_NOT_AFFORD"},{"sequenceNumber":6,"RecommendedProducts":null,"QuestionId":"PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY","IsSelected":true,"AnswerType":"radio","AnswerId":"PACKAGES_YES_I_CAN_AFFORD"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_UNDERSTAND_THE_FINANCIAL_PRODUCT_YOU_WANT_TO_BUY","IsSelected":false,"AnswerType":"radio","AnswerId":"PACKAGES_NO_I_DONT_UNDERSTAND"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_UNDERSTAND_THE_FINANCIAL_PRODUCT_YOU_WANT_TO_BUY","IsSelected":true,"AnswerType":"radio","AnswerId":"PACKAGES_YES_I_UNDERSTAND"}]'
		);
		Test.stopTest();
		System.assert(result != null, 'Test Working');
	}
    @isTest
	static void listOfQuestionsIdToTextNeagtiveTest() {
		Test.startTest();
		String result = ROAController.listOfQuestionsIdToText(
			'[{"sequenceNumber":10,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_FIXED_INCOME"},{"sequenceNumber":1,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_HAVE_A_FIXED_INCOME","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_FIXED_INCOME"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_NO_PRODUCTS"},{"sequenceNumber":2,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_ALREADY_HAVE_ANY_OTHER_FINANCIAL_PRODUCTS_AT_ANY_OTHER_INSTITUTIONS","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_YES_PRODUCTS"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_CHEQUES"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_INSURANCE"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_LENDING"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":false,"AnswerType":"checkbox","AnswerId":"PACKAGES_SAVINGS_OR_INVESTMENTS"},{"sequenceNumber":3,"RecommendedProducts":null,"QuestionId":"PACKAGES_WHICH_PRODUCTS_DO_YOU_HAVE","IsSelected":true,"AnswerType":"checkbox","AnswerId":"PACKAGES_TRANSACTIONAL"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_R25000_TO_R62499"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":false,"AnswerType":"dropdown","AnswerId":"PACKAGES_R4000_TO_R24999"},{"sequenceNumber":4,"RecommendedProducts":null,"QuestionId":"PACKAGES_HOW_MUCH_IS_YOUR_MONTHLY_INCOME","IsSelected":true,"AnswerType":"dropdown","AnswerId":"PACKAGES_R62500_PLUS"},{"sequenceNumber":6,"RecommendedProducts":null,"QuestionId":"PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY","IsSelected":false,"AnswerType":"radio","AnswerId":"PACKAGES_NO_I_CAN_NOT_AFFORD"},{"sequenceNumber":6,"RecommendedProducts":null,"QuestionId":"PACKAGES_CAN_YOU_AFFORD_THE_FINANCIAL_PRODUCT_THAT_YOU_WANT_TO_BUY","IsSelected":true,"AnswerType":"radio","AnswerId":"PACKAGES_YES_I_CAN_AFFORD"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_UNDERSTAND_THE_FINANCIAL_PRODUCT_YOU_WANT_TO_BUY","IsSelected":false,"AnswerType":"radio","AnswerId":"PACKAGES_NO_I_DONT_UNDERSTAND"},{"sequenceNumber":7,"RecommendedProducts":null,"QuestionId":"PACKAGES_DO_YOU_UNDERSTAND_THE_FINANCIAL_PRODUCT_YOU_WANT_TO_BUY","IsSelected":true,"AnswerType":"radio","AnswerId":"PACKAGES_YES_I_UNDERSTAND"}]'
		);
		Test.stopTest();
		System.assert(result != null, 'Test Working');
	}
}