/**
 * @description       : Class for GeneralQualitativeInformation Component
 * @author            : englarmerdge.mongwe@absa.africa
 * @last modified on  : 2021-07-12
 * @last modified by  : englarmerdge.mongwe@absa.africa
 * Modifications Log
 * Ver   Date         Author                            Modification
 * 1.0   2020-07-31   englarmerdge.mongwe@absa.africa   Initial Version
**/
public class GeneralQualitativeInformationController {
    /**
     * @description method to get GQ infomation from object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-31
     * @param oppId
     * @param tempName
     * @return List<Map<String, Object>>
    **/
    @AuraEnabled
    public static List<Map<String,Object>> getQuestionsAndAnswers(Id oppId, String tempName) {
        List<Map<String,Object>> mapDataList = new List<Map<String,Object>>();
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        Questionnaire_Template__c quesTem = new QuestionnaireTemplateSelector().selectByName(tempName);
        List<Questionnaire_Question__c> quesList = (quesTem != null ? new QuestionnaireQuestionSelector().selectByTemplateId(quesTem.Id) : null);
        List<Questionnaire_Answer__c> answerList = (appList != null ? new QuestionnaireAnswerSelector().selectByApplicationId(appList[0].Id) :null);

        if(quesList.size() > 0 && quesList != null){

            for(Questionnaire_Question__c ques : quesList) {
                Map<String,Object> mapData = new Map<String,Object>();
                mapData.put('Id',ques.Id);
                mapData.put('TemplateId',ques.Questionnaire_Template__c);
                mapData.put('Question',ques.Question__c);
                mapData.put('QuestionLabel',ques.Question_Label__c);
                mapData.put('IncludeComment',ques.Include_Comment__c);
                mapData.put('Section',ques.Section__c);
                mapData.put('DefaultAnswer',ques.Default_Answer__c);
                mapData.put('AnswerOptions',ques.Answer_Options__c);
                mapData.put('AnswerType',ques.Answer_Type__c);
                mapData.put('AnswerControlType',ques.Answer_Control_Type__c);

                if(answerList.size() > 0) {
                    for(Questionnaire_Answer__c answer : answerList) {
                        if(ques.Id == answer.Questionnaire_Question__c) {
                            mapData.put('Answer', answer.Answer__c);

                            if(ques.Include_Comment__c) {
                                mapData.put('Comment', answer.Comment__c);
                            }
                            break;
                        }
                    }
                }
                else {
                    mapData.put('Answer', '');
                    if(ques.Include_Comment__c) {
                        mapData.put('Comment', '');
                    }
                }
                mapDataList.add(mapData);
            }

            return mapDataList;
        }

        return null;
    }

    /**
     * @description method to check for borrowing powers
     * @author himanshu.nimje@absa.africa | 2021-06-02
     * @param oppId
     * @param qqQAndAObj
     * @return Boolean
    **/
    @AuraEnabled
    public static Boolean checkBorrowingPowers(Id oppId, String qqQAndAObj) {
        Boolean isBorrowingPowerSaved = false;
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Questionnaire_Answer__c> qAnswerList = (appList != null ? new QuestionnaireAnswerSelector().selectByApplicationId(appList[0].Id) : null);
        List<Object> qqQAndAList = (List<Object>)JSON.deserializeUntyped(qqQAndAObj);

        if(qqQAndAList != null && qqQAndAList.size() > 0) {
            List<Questionnaire_Answer__c> answerList = new List<Questionnaire_Answer__c>();

            for(Object objItem : qqQAndAList) {
                Map<String,Object> mapObj = (Map<String, Object>)objItem;
                Id quesId = String.valueOf(mapObj.get('Id'));
                String section = String.valueOf(mapObj.get('Section'));

                if(qAnswerList.size() > 0) {
                    for(Questionnaire_Answer__c answer : qAnswerList) {
                        if(quesId == answer.Questionnaire_Question__c) {
                            if(answer.Questionnaire_Question__r.Question__c == 'Borrowing Power Limit') {
                                isBorrowingPowerSaved = (answer.Answer__c == 'Limited - Fixed Amount' || answer.Answer__c == 'Limited - Other' || answer.Answer__c == 'Unlimited' ? true : false);
                            }
                        }
                    }
                }
            }
        }

        return isBorrowingPowerSaved;
    }

    /**
     * @description method to save GQ information to object
     * @author englarmerdge.mongwe@absa.africa | 2020-07-31
     * @param oppId
     * @param qqQAndAObj
     * @return String
    **/
    @AuraEnabled
    public static String saveGeneralQualitativeInformation(Id oppId, String qqQAndAObj) {
        List<Application__c> appList = new ApplicationsSelector().selectByOpportunityId(oppId);
        List<Questionnaire_Answer__c> qAnswerList = (appList != null ? new QuestionnaireAnswerSelector().selectByApplicationId(appList[0].Id) : null);
        List<Object> qqQAndAList = (List<Object>)JSON.deserializeUntyped(qqQAndAObj);
        Boolean isBorrowingPowerSaved = false;

        if(qqQAndAList != null && qqQAndAList.size() > 0) {
            List<Questionnaire_Answer__c> answerList = new List<Questionnaire_Answer__c>();

            for(Object objItem : qqQAndAList) {
                Map<String,Object> mapObj = (Map<String, Object>)objItem;
                Id quesId = String.valueOf(mapObj.get('Id'));
                String section = String.valueOf(mapObj.get('Section'));

                if(qAnswerList.size() > 0) {
                    for(Questionnaire_Answer__c answer : qAnswerList) {
                        if(quesId == answer.Questionnaire_Question__c) {
                            answer.Related_Opportunity__c = oppId;
                            answer.Related_Application__c = appList[0].Id;
                            answer.Answer__c = String.valueOf(mapObj.get('Answer'));
                            answer.Answer_Data_Type__c = String.valueOf(mapObj.get('AnswerType'));
                            answer.Questionnaire_Template__c = String.valueOf(mapObj.get('TemplateId'));

                            Boolean IncludeComment = Boolean.valueOf(mapObj.get('IncludeComment'));

                            if(IncludeComment) {
                                answer.Comment__c = String.valueOf(mapObj.get('Comment'));
                            }

                            if(answer.Questionnaire_Question__r.Question__c == 'Borrowing Power Limit') {

                                isBorrowingPowerSaved = (answer.Answer__c == 'Limited - Fixed Amount' || answer.Answer__c == 'Limited - Other' || answer.Answer__c == 'Unlimited' ? true : false);
                            }

                            answerList.add(answer);
                        }
                    }
                }
                else {
                    Questionnaire_Answer__c quesAnswer = new Questionnaire_Answer__c();
                    quesAnswer.Related_Opportunity__c = oppId;
                    quesAnswer.Related_Application__c = appList[0].Id;
                    quesAnswer.Questionnaire_Question__c = String.valueOf(mapObj.get('Id'));
                    quesAnswer.Answer__c = String.valueOf(mapObj.get('Answer'));
                    quesAnswer.Answer_Data_Type__c = String.valueOf(mapObj.get('AnswerType'));
                    quesAnswer.Questionnaire_Template__c = String.valueOf(mapObj.get('TemplateId'));

                    Boolean IncludeComment = Boolean.valueOf(mapObj.get('IncludeComment'));

                    if(IncludeComment) {
                        quesAnswer.Comment__c = String.valueOf(mapObj.get('Comment'));
                    }


                    // if(quesAnswer.Questionnaire_Question__r.Question__c == 'Borrowing Power Limit') {
                    isBorrowingPowerSaved = (quesAnswer.Answer__c == 'Limited - Fixed Amount' || quesAnswer.Answer__c == 'Limited - Other' || quesAnswer.Answer__c == 'Unlimited' ? true : false);
                    // }
                    answerList.add(quesAnswer);
                }
            }

            try {
                upsert answerList;
                isBorrowingPowerSaved = checkBorrowingPowers(oppId, qqQAndAObj); // W-011265
                if(answerList != null) {

                    PowerCurveController.setValidationFields(oppId, 'General_Qualitative', true);
                    if(isBorrowingPowerSaved) {
                        PowerCurveController.setValidationFields(oppId, 'Borrowing_Power', true);

                    }
                }
            }
            catch (Exception ex) {
                return 'GeneralQualitativeInformation Update Failed: ' + ex.getDmlMessage(0);
            }
            return 'General Qualitative Information Udated Successfully';
        }
        else {
            return 'No Questionnaire Answer Record Found';
        }
    }
}