/**
 * @description       : ROASyncSchedule
 * @author            : Celliers Inggs
 * @last modified on  : 2021-11-15
 * @last modified by  : 
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-07-07   André Pietersen (IQ Business)   Changed to future method
 * 1.1   2021-11-03   André Pietersen (IQ Business)   Implemented StringBody class
 **/
global class ROASyncSchedule implements Schedulable {
	/**
	 * @description
	 * @author Celliers Inggs
	 * @param ctx
	 **/
	global void execute(SchedulableContext ctx) {
		processROASync();
	}

	/**
	 * @description processROASync
	 * @author Celliers Inggs
	 **/
	@future(callout=true)
	public static void processROASync() {
		string response = ROAQuestionAnswerService_IH_v1.getROAQuestionAnswerBody();
		ROAData data = (ROAData) JSON.deserializeStrict(response, ROAData.class);
		if (data.errorCode != null) {
			return;
		}
		List<ROAQuestion__c> questionList = new List<ROAQuestion__c>();

		for (string id : data.Questions.keySet()) {
			Question question = data.Questions.get(id);
			ROAQuestion__c newQuestion = new ROAQuestion__c();
			newQuestion.QuestionId__c = question.QuestionId.Id;
			newQuestion.QuestionText__c = question.QuestionText;
			newQuestion.AnswerType__c = ConvertAnswerType(question.AnswerType);

			questionList.add(newQuestion);
		}

		List<ROAAnswer__c> answerList = new List<ROAAnswer__c>();
		for (string id : data.Answers.keySet()) {
			Answer answer = data.Answers.get(id);
			ROAAnswer__c newAnswer = new ROAAnswer__c();
			//newAnswer.Name = answer.AnswerId.Id.substring(0,80);
			newAnswer.AnswerId__c = answer.AnswerId.Id;
			newAnswer.AnswerText__c = answer.AnswerText;
			newAnswer.NextStage__c = convertNextStage(answer.NextStage);
			newAnswer.RecommendedProducts__c = getIdListString(answer.RecommendedProducts);

			if (answer.NextQuestion != null) {
				newAnswer.NextQuestion__c = answer.NextQuestion.QuestionId.Id;
				newAnswer.AnswerList__c = getIdListString(answer.NextQuestion.Answers);
			}

			answerList.add(newAnswer);
		}

		List<ROAProduct__c> productList = new List<ROAProduct__c>();
		for (string id : data.Products.keySet()) {
			Product product = data.Products.get(id);
			ROAProduct__c newProduct = new ROAProduct__c();
			//newProduct.Name = product.ProductId.Id.substring(0,80);
			newProduct.ProductId__c = product.ProductId.Id;
			newProduct.Description__c = product.Description;
			newProduct.Code__c = product.Code;
			newProduct.PackageChargeOption__c = product.PackageChargeOption;

			productList.add(newProduct);
		}
		List<ROAQuestion__c> oldQuestions = [SELECT id FROM ROAQuestion__c];
		delete oldQuestions;
		insert questionList;
        //Added filter to stop deleting Voice Products.
        String voiceProducts= System.Label.Transactional_Voice_Products;
        List<String> voiceproductsplit = new List<String>(voiceProducts.split(';'));
        List<ROAAnswer__c> oldAnswers = [SELECT id FROM ROAAnswer__c where AnswerId__c not in:(voiceproductsplit) ];
		delete oldAnswers;
		insert answerList;

		List<ROAProduct__c> oldProducts = [SELECT id FROM ROAProduct__c];
		delete oldProducts;
		insert productList;
	}

	/**
	 * @description getIdListString
	 * @author Celliers Inggs
	 * @param inputList
	 * @return string
	 **/
	private static string getIdListString(List<ObjectId> inputList) {
		string stringList = '';
		integer count = 0;
		for (ObjectId item : inputList) {
			count++;
			if (count == 1) {
				stringList = stringList + item.Id;
			} else {
				stringList = stringList + ',' + item.Id;
			}
		}

		return stringList;
	}

	/**
	 * @description ConvertNextStage
	 * @author Celliers Inggs
	 * @param input
	 * @return string
	 **/
	private static string convertNextStage(string input) {
		switch on input {
			when '0' {
				return 'ROA';
			}
			when '1' {
				return 'END_ROA';
			}
			when '2' {
				return 'POST_ROA';
			}
			when '3' {
				return 'END_APP';
			}
			when '4' {
				return 'PRODUCT_TAKEUP';
			}
			when '5' {
				return 'PRODUCT_BASKET';
			}
			when else {
				return input;
			}
		}
	}

	/**
	 * @description convertAnswerType
	 * @author Celliers Inggs
	 * @param input
	 * @return string
	 **/
	private static string convertAnswerType(string input) {
		switch on input {
			when '0' {
				return 'dropdown';
			}
			when '1' {
				return 'checkbox';
			}
			when '2' {
				return 'radio';
			}
			when '3' {
				return 'rate';
			}
			when else {
				return input;
			}
		}
	}

	/**
	 * @description ROAData
	 */
	public class ROAData {
		public string status;
		public string message;
		public string errorCode;
		public Integer statusCode;
		public string fault;
		Map<string, Answer> Answers;
		NextQuestion InitialQuestion;
		Map<string, Product> Products;
		Map<string, Question> Questions;
	}

	/**
	 * @description Question
	 */
	public class Question {
		public ObjectId QuestionId;
		public string QuestionText;
		public string AnswerType;
	}

	/**
	 * @description ObjectId
	 */
	public class ObjectId {
		public string Id;
	}

	/**
	 * @description NextQuestion
	 */
	public class NextQuestion {
		public ObjectId QuestionId;
		public ObjectId[] Answers;
	}

	/**
	 * @description Answer
	 */
	public class Answer {
		public ObjectId AnswerId;
		public string AnswerText;
		public NextQuestion NextQuestion;
		public string NextStage;
		public ObjectId[] RecommendedProducts;
	}

	/**
	 * @description Product
	 */
	public class Product {
		public ObjectId ProductId;
		public string Description;
		public string Code;
		public string PackageChargeOption;
	}
}