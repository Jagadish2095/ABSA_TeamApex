/**
* @description Controller for ROA component
* @author  Celliers Inggs
* @created 2020-10-02
* Edit Paul du Randt
* Edit André Pietersen
* @last modified on  : 2021-11-09
* @last modified by  : 
* Modifications Log
* Ver   Date         Author                        Modification
* 1.0   2021-06-14   PaulJohn.duRand@absa.africa   Last Question fix and PMD refactor
* 1.1   2021-06-18   PaulJohn.duRand@absa.africa   W-013133 ROA fix for Checkbox questions removes answers for previous answers fix
* 1.2   2021-08-11   Diksha.Wasekar@absa.africa    W-014279 Product Selection story for Voice without ROA questions
*/

public without sharing class ROAController {
private static Boolean LogOutput = true;

/**
* @description ROANextQuestion
*/
public class ROANextQuestion {
    public String QuestionId;
    public String QuestionText;
    public String AnswerType;
    public ROANextQuestionAnswer[] Answers;
    public String NextStage;
    public String PreviousAnswers;
    public String RecommendedProducts;
    public String QuestionTracker;
    public Boolean hasValue;
}

/**
* @description ROANextQuestionAnswer
*/
public class ROANextQuestionAnswer implements Comparable {
    public String AnswerId;
    public String AnswerText;

    /**
* @description compare used for sorting
* @param compareTo object to compare to
* @return 0 for equal , 1 greater and -1 for less
*/
    public Integer compareTo(Object compareTo) {
        ROANextQuestionAnswer compareToEmp = (ROANextQuestionAnswer) compareTo;
        Integer compactedAnswer = getValueFromString(compareToEmp.answerText);
        Integer currentAnswer = getValueFromString(answerText);
        if (compactedAnswer == currentAnswer) {
            return 0;
        }
        if (currentAnswer > compactedAnswer) {
            return 1;
        }
        return -1;
    }

    /**
* @description Used to sort the branch *  @... by Brian Maswanganyi (ZA)
* @description Used to sort the branch
* @param text value to convert
* @return value as integer
*/
    private Integer getValueFromString(String text) {
        if (text.contains('-') || text.contains('+')) {
            text = text.remove('R');
            text = text.remove('+');
            String[] parts = text.split('-');
            if (parts.size() > 0) {
                try {
                    return Integer.valueOf(parts[0].trim());
                } catch (Exception ex) {
                    //System.debug(ex);
                    return 0;
                }
            }
        }
        return 0;
    }
}

/**
* @description ROAAnswer
*/
public class ROAAnswer {
    public string AnswerId;
    public string AnswerType;
    public string QuestionId;
    public Boolean IsSelected;
    public string[] RecommendedProducts;
    public integer sequenceNumber;
}

/**
* @description  Method to return create and return OpportunityId and ApplicationId
* @param accountID
* @param productCode
* @param productType
* @param flowname
* @param listOfQuestions
* @return Map<String, String>
*/
@AuraEnabled
public static Map<String, String> getNewOpportunity(string accountID, string productCode, string productType, string flowname, String listOfQuestions) {
    ROAProduct__c productDetails = [
        SELECT ProductId__c, Description__c, Code__c, PackageChargeOption__c
        FROM ROAProduct__c
        WHERE ProductId__c = :productCode
    ];
    listOfQuestions = listOfQuestions ==null?'': listOfQuestionsIdToText(listOfQuestions); // Added by SMATH 21 Oct 2021
    return SalesProcessBase.createOpportunityWithLineItemsRoa(accountId, productDetails.Code__c, productType, flowname, listOfQuestions);
}

/**
* @description  This function keeps track of the Questions and Answers of the ROA application
* @param answerId
* @param currentQuestionId
* @param possibleAnswers
* @param sequenceNumber
* @param questionTracker
* @return List<ROAAnswer>
*/
public static List<ROAAnswer> keepTrack(
    string answerId,
    string currentQuestionId,
    string[] possibleAnswers,
    Integer sequenceNumber,
    string questionTracker
) {
    List<String> answerIds = answerId.split(',');
    ROAQuestion__c currentQuestion = new ROAQuestion__c();
    if (currentQuestionId != null) {
        List<ROAQuestion__c> currentQuestions = [SELECT AnswerType__c FROM ROAQuestion__c WHERE QuestionId__c = :currentQuestionId];
        currentQuestion = currentQuestions.get(0);
    }
    List<ROAAnswer> ListOfAnswers = new List<ROAAnswer>();
    if (questionTracker != null) {
        ListOfAnswers = (List<ROAAnswer>) JSON.deserialize(questionTracker, List<ROAAnswer>.class);
    }
    //Skip type of payment for Transactional savings
    if (currentQuestionId != 'TRANSACTIONAL_SAVINGS_WHICH_PRICING_OPTION_WOULD_YOU_PREFER') {
        for (String possibleAnswer : possibleAnswers) {
            if (answerIds.size() > 1) {
                //Check if currentQuestionId is in list -> if not add it, else change answers
                for (ROAAnswer answer : ListOfAnswers) {
                    if (currentQuestionId == answer.QuestionId) {
                        if (answerIds.contains(answer.AnswerId)) {
                            answer.IsSelected = true;
                        } else {
                            answer.IsSelected = false;
                        }
                    }
                }
            } else {
                ROAAnswer ROAAnswer = new ROAAnswer();
                if (answerIds.contains(possibleAnswer)) {
                    ROAAnswer.QuestionId = currentQuestionId;
                    ROAAnswer.AnswerId = possibleAnswer;
                    ROAAnswer.sequenceNumber = sequenceNumber;
                    ROAAnswer.IsSelected = true;
                    ROAAnswer.AnswerType = currentQuestion != null ? currentQuestion.AnswerType__c : '';
                } else {
                    ROAAnswer.QuestionId = currentQuestionId;
                    ROAAnswer.AnswerId = possibleAnswer;
                    ROAAnswer.sequenceNumber = sequenceNumber;
                    ROAAnswer.IsSelected = false;
                    ROAAnswer.AnswerType = currentQuestion != null ? currentQuestion.AnswerType__c : '';
                }
                ListOfAnswers.add(ROAAnswer);
            }
        }
    }
    return ListOfAnswers;
}

/**
* @description  This function is called to get the next Roa Question
* @param answerId
* @param currentQuestionId
* @param possibleAnswers
* @param sequenceNumber
* @param questionTracker
* @return string
*/
@AuraEnabled
public static string getNextQuestion(string answerId, string currentQuestionId, string[] possibleAnswers, Integer sequenceNumber, string questionTracker) {
    ROANextQuestion result = new ROANextQuestion();
    result.hasValue = false;
    List<String> answerIds = answerId.split(',');
    List<ROAAnswer> ListOfAnswers = keepTrack(answerId, currentQuestionId, possibleAnswers, sequenceNumber, questionTracker);
    result.QuestionTracker = JSON.serialize(ListOfAnswers);
    List<ROAAnswer__c> currentAnswerList = [
        SELECT AnswerId__c, NextQuestion__c, AnswerList__c, NextStage__c, RecommendedProducts__c
        FROM ROAAnswer__c
        WHERE AnswerId__c = :answerIds[0]
    ];
    if (currentAnswerList.size() != 0) {
        ROAAnswer__c currentAnswer = currentAnswerList.get(0);
        if (currentAnswer.NextQuestion__c != null) {
            List<ROAQuestion__c> nextQuestions = [
                SELECT QuestionId__c, QuestionText__c, AnswerType__c
                FROM ROAQuestion__c
                WHERE QuestionId__c = :currentAnswer.NextQuestion__c
            ];
            ROAQuestion__c nextQuestion = nextQuestions.get(0);
            result.QuestionId = nextQuestion.QuestionId__c;
            result.QuestionText = nextQuestion.QuestionText__c;
            result.AnswerType = nextQuestion.AnswerType__c;
            result.NextStage = currentAnswer.NextStage__c;
            result.hasValue = true;
            result.Answers = new List<ROANextQuestionAnswer>();

            List<ROAAnswer__c> tempAnswerList = [
                SELECT AnswerId__c, AnswerText__c
                FROM ROAAnswer__c
                WHERE AnswerId__c IN :currentAnswer.AnswerList__c.split(',')
            ];
            for (ROAAnswer__c answer : tempAnswerList) {
                ROANextQuestionAnswer newAnswer = new ROANextQuestionAnswer();
                newAnswer.answerId = answer.AnswerId__c;
                newAnswer.AnswerText = answer.AnswerText__c;
                result.Answers.add(newAnswer);
            }
            if (
                currentAnswer.NextStage__c == 'END_ROA' ||
                currentAnswer.NextStage__c == 'PRODUCT_TAKEUP' ||
                currentAnswer.NextStage__c == 'PRODUCT_BASKET'
            ) {
                Set<String> recommendedProducts = new Set<String>();
                Set<String> productsToBeRemoved = new Set<String>();

                List<ROAAnswer__c> listOfAllProducts = [SELECT RecommendedProducts__c, AnswerId__c FROM ROAAnswer__c];

                //Get Recommended Products for each answer
                for (ROAAnswer answer : ListOfAnswers) {
                    answer.RecommendedProducts = new List<String>();
                    for (ROAAnswer__c fulllistAnswer : listOfAllProducts) {
                        if (answer.AnswerId == fulllistAnswer.AnswerId__c && fulllistAnswer.RecommendedProducts__c != null) {
                            answer.RecommendedProducts = fulllistAnswer.RecommendedProducts__c.split(',');
                            break;
                        }
                    }
                }
                //Determine recommended products by getting list of recommended products from answers selected
                // and a list of recommended products from answers not selected. Then remove non selected
                // recommended products
                for (ROAAnswer answer : ListOfAnswers) {
                    List<ROAAnswer> answersWithSameQuestion = new List<ROAAnswer>();
                    String parentQuestion = answer.QuestionId;
                    for (ROAAnswer innerAnswer : ListOfAnswers) {
                        if (innerAnswer.QuestionId == parentQuestion) {
                            answersWithSameQuestion.add(innerAnswer);
                        }
                    }
                    Set<String> innerRecommendedProducts = new Set<String>();
                    Set<String> innerProductsToBeRemoved = new Set<String>();
                    for (ROAAnswer childSelectedAnswer : answersWithSameQuestion) {
                        if (childSelectedAnswer.IsSelected) {
                            for (String product : childSelectedAnswer.RecommendedProducts) {
                                innerRecommendedProducts.add(product);
                            }
                        }
                    }
                    for (ROAAnswer childNotSelectedAnswer : answersWithSameQuestion) {
                        if (!childNotSelectedAnswer.IsSelected) {
                            for (String product : childNotSelectedAnswer.RecommendedProducts) {
                                if (!innerRecommendedProducts.contains(product)) {
                                    innerProductsToBeRemoved.add(product);
                                }
                            }
                        }
                    }
                    recommendedProducts.addAll(innerRecommendedProducts);
                    productsToBeRemoved.addAll(innerProductsToBeRemoved);
                }
                recommendedProducts.removeAll(productsToBeRemoved);
                String joinedString = String.join(new List<String>(recommendedProducts), ',');
                result.RecommendedProducts = joinedString;
            } else {
                //Skip type of payment for Transactional savings
                if (nextQuestion.QuestionId__c == 'TRANSACTIONAL_SAVINGS_WHICH_PRICING_OPTION_WOULD_YOU_PREFER') {
                    string skipAnswerID = result.Answers.get(0).AnswerId;
                    return getNextQuestion(skipAnswerID, nextQuestion.QuestionId__c, possibleAnswers, sequenceNumber, questionTracker);
                }
            }
        }
        else if (
            currentAnswer.NextStage__c == 'END_ROA' ||
            currentAnswer.NextStage__c == 'PRODUCT_TAKEUP' ||
            currentAnswer.NextStage__c == 'PRODUCT_BASKET'
        ) {
            Set<String> recommendedProducts = new Set<String>();
            Set<String> productsToBeRemoved = new Set<String>();

            List<ROAAnswer__c> listOfAllProducts = [SELECT RecommendedProducts__c, AnswerId__c FROM ROAAnswer__c];

            //Get Recommended Products for each answer
            for (ROAAnswer answer : ListOfAnswers) {
                answer.RecommendedProducts = new List<String>();
                for (ROAAnswer__c fulllistAnswer : listOfAllProducts) {
                    if (answer.AnswerId == fulllistAnswer.AnswerId__c && fulllistAnswer.RecommendedProducts__c != null) {
                        answer.RecommendedProducts = fulllistAnswer.RecommendedProducts__c.split(',');
                        break;
                    }
                }
            }
            //Determine recommended products by getting list of recommended products from answers selected
            // and a list of recommended products from answers not selected. Then remove non selected
            // recommended products
            for (ROAAnswer answer : ListOfAnswers) {
                List<ROAAnswer> answersWithSameQuestion = new List<ROAAnswer>();
                String parentQuestion = answer.QuestionId;
                for (ROAAnswer innerAnswer : ListOfAnswers) {
                    if (innerAnswer.QuestionId == parentQuestion) {
                        answersWithSameQuestion.add(innerAnswer);
                    }
                }
                Set<String> innerRecommendedProducts = new Set<String>();
                Set<String> innerProductsToBeRemoved = new Set<String>();
                for (ROAAnswer childSelectedAnswer : answersWithSameQuestion) {
                    if (childSelectedAnswer.IsSelected) {
                        for (String product : childSelectedAnswer.RecommendedProducts) {
                            innerRecommendedProducts.add(product);
                        }
                    }
                }
                for (ROAAnswer childNotSelectedAnswer : answersWithSameQuestion) {
                    if (!childNotSelectedAnswer.IsSelected) {
                        for (String product : childNotSelectedAnswer.RecommendedProducts) {
                            if (!innerRecommendedProducts.contains(product)) {
                                innerProductsToBeRemoved.add(product);
                            }
                        }
                    }
                }
                recommendedProducts.addAll(innerRecommendedProducts);
                productsToBeRemoved.addAll(innerProductsToBeRemoved);
            }
            recommendedProducts.removeAll(productsToBeRemoved);
            String joinedString = String.join(new List<String>(recommendedProducts), ',');
            result.RecommendedProducts = joinedString;
            result.hasValue = true;
            result.NextStage = currentAnswer.NextStage__c;
            result.Answers = new List<ROANextQuestionAnswer>();
            result.QuestionId = currentQuestionId;
        }
    }
    if (result.Answers != null) {
        result.Answers.sort();
    }
    return JSON.serialize(result);
}

/**
* @description  This function is called to get replace Questions and answers ID's with text
* @param listOfQuestions
* @return string
*/
public static string listOfQuestionsIdToText(string listOfQuestions) {
    List<ROAQuestion__c> questions = [SELECT QuestionId__c, QuestionText__c, AnswerType__c FROM ROAQuestion__c];
    List<ROAAnswer__c> answers = [SELECT AnswerId__c, AnswerText__c FROM ROAAnswer__c];
    List<ROAAnswer> listOfQuestionsAndAnswers = (List<ROAAnswer>) JSON.deserialize(listOfQuestions, List<ROAAnswer>.class);
    for (ROAAnswer roaAnswer : listOfQuestionsAndAnswers) {
        for (ROAQuestion__c question : questions) {
            if (roaAnswer.QuestionId == question.QuestionId__c) {
                roaAnswer.QuestionId = question.QuestionText__c;
                break;
            }
        }
        for (ROAAnswer__c answer : answers) {
            if (roaAnswer.AnswerId == answer.AnswerId__c) {
                roaAnswer.AnswerId = answer.AnswerText__c;
                break;
            }
        }
    }
    return JSON.serialize(listOfQuestionsAndAnswers);
}

/**
* @description  Method to getrecommendedProducts without ROA questions
* @param answerId
* @return string
*/
@AuraEnabled
public static string getrecommendedProducts(string answerId) {
    List<ROAAnswer__c> ListAnswerProducts = [select RecommendedProducts__c from ROAAnswer__c where AnswerId__c = :answerId];
    List<string> recommendedprodlst =new List<string>();
    ROAAnswer__c answerProducts = ListAnswerProducts.get(0);
    if (answerProducts.RecommendedProducts__c != null) {
        recommendedprodlst = answerProducts.RecommendedProducts__c.split(',');
    }
    String RecommendedProducts = String.join(new List<String>(recommendedprodlst), ','); // to convert list in string
    return RecommendedProducts;

}



}