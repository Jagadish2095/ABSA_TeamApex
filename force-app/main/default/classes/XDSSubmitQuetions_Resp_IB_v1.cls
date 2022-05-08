/**
 * Apex Integration Response Bean class for XDSGetQuetions service
 * @author  Madhava Palla : Absa
 * @since   2019-09-15
 *
 **/

public class XDSSubmitQuetions_Resp_IB_v1 extends Base_IB {

    @auraEnabled public  String Message;
    @auraEnabled public  Integer StatusCode;
    @auraEnabled public  String StatusMessage;

    @auraEnabled public  AuthenticationHistory authenticationHistory;
    @auraEnabled public  Boolean blockingEnabledFlag;
    @auraEnabled public  Boolean isUserBlocked;
    @auraEnabled public  Boolean otpenabled;
    @auraEnabled public  Boolean otpstatus;
    @auraEnabled public  Boolean personalQuestionsenabled;
    @auraEnabled public  Boolean referToFraud;
    @auraEnabled public  Boolean safpsindicator;
    @auraEnabled public  Decimal authenticatedPerc;
    @auraEnabled public  Decimal requiredAuthenticatedPerc;
    @auraEnabled public  fraudReasons fraudReasons;
    @auraEnabled public  Integer actionedBySystemUserID;
    @auraEnabled public  Integer blockid;
    @auraEnabled public  Integer currentQuestionNum;
    @auraEnabled public  Integer noofAttemptsRemaining;
    @auraEnabled public  Integer questionTimeout;
    @auraEnabled public  Integer subscriberAuthenticationID;
    @auraEnabled public  Integer subscriberID;
    @auraEnabled public  Integer totalQuestionPointValue;
    @auraEnabled public  Questions questions;
    @auraEnabled public  String authenticationComment;
    @auraEnabled public  String authenticationDate;
    @auraEnabled public  String authenticationStatusInd;
    @auraEnabled public  String authenticationStatusReason;
    @auraEnabled public  String authenticationTypeInd;
    @auraEnabled public  String birthDate;
    @auraEnabled public  String blockingReason;
    @auraEnabled public  String consumerAccountAgeMessage;
    @auraEnabled public  String encryptedReferenceNo;
    @auraEnabled public  String enquiryid;
    @auraEnabled public  String enquiryresultid;
    @auraEnabled public  String errorMessage;
    @auraEnabled public  String firstName;
    @auraEnabled public  String gender;
    @auraEnabled public  String haDeaseasedStatus;
    @auraEnabled public  String haFirstName;
    @auraEnabled public  String haIDIssuedDate;
    @auraEnabled public  String haIDNo;
    @auraEnabled public  String haSecondName;
    @auraEnabled public  String haSurname;
    @auraEnabled public  String idno;
    @auraEnabled public  String otpnotGeneratedReason;
    @auraEnabled public  String otpvalue;
    @auraEnabled public  String passportNo;
    @auraEnabled public  String processAction;
    @auraEnabled public  String referenceNo;
    @auraEnabled public  String repeatAuthenticationMessage;
    @auraEnabled public  String safpsmessage;
    @auraEnabled public  String surname;
    @auraEnabled public  String voidorFraudReason;
    @auraEnabled public  VoidReasons voidReasons;

    public class Answers {
        @auraEnabled public  List < AnswerDocument > answerDocument;
    }

    public class AnswerDocument {
        @auraEnabled public  Boolean isEnteredAnswerYN;
        @auraEnabled public  Integer answerID;
        @auraEnabled public  String answer;
    }

    public class AuthenticationHistory {
        @auraEnabled public  List < AuthenticationHistoryDocument > authenticationHistoryDocument;
    }

    public class AuthenticationHistoryDocument {
        @auraEnabled public  String authenticationPerc;
        @auraEnabled public  String authenticationStatus;
        @auraEnabled public  String bureauDate;
        @auraEnabled public  String cellularNumber;
        @auraEnabled public  String emailAddress;
        @auraEnabled public  String subscriberName;
    }

    public class FraudReasons {
        @auraEnabled public  List < FraudReasonsDocument > fraudReasonsDocument;
    }

    public class FraudReasonsDocument {
        @auraEnabled public  Boolean isEnteredReasonYN;
        @auraEnabled public  Integer fraudReasonID;
        @auraEnabled public  String fraudReason;
    }

    public class Questions {
        @auraEnabled public  List < QuestionDocument > questionDocument;
    }

    public class QuestionDocument {
        @auraEnabled public  Answers answers;
        @auraEnabled public  Integer productAuthenticationQuestionID;
        @auraEnabled public  Integer questionPointValue;
        @auraEnabled public  Integer requiredNoOfAnswers;
        @auraEnabled public  String answerStatusInd;
        @auraEnabled public  String question;
    }

    public class VoidReasons {
        @auraEnabled public  List < VoidReasonsDocument > voidReasonsDocument;
    }

    public class VoidReasonsDocument {
        @auraEnabled public  Boolean isEnteredReasonYN;
        @auraEnabled public  Integer voidReasonID;
        @auraEnabled public  String voidReason;
    }

    public static XDSSubmitQuetions_Resp_IB_v1 DummyRequestForXDSVerification1() {
        XDSSubmitQuetions_Resp_IB_v1 responseBean = new XDSSubmitQuetions_Resp_IB_v1();
        responseBean.actionedBySystemUserID = 1213;
        responseBean.authenticatedPerc = 11;
        responseBean.authenticationComment = 'na';
        responseBean.authenticationStatusInd = 'na';
        responseBean.authenticationStatusReason = 'block';
        responseBean.authenticationTypeInd = 'BB';
        responseBean.birthDate = '2019-08-20';
        responseBean.blockid = 2122;
        responseBean.blockingEnabledFlag = true;
        responseBean.blockingReason = 'blocked';
        responseBean.errorMessage = 'Error Message';

        //responseBean.day='12';
        // responseBean.localPart='000';
        responseBean.currentQuestionNum = 1;
        responseBean.firstName = 'FFF';
        responseBean.consumerAccountAgeMessage = 'mmmm';
        responseBean.gender = 'kkk';
        //responseBean.comment='adsd';
        // responseBean.haCauseOfDeath='ASSS';
        responseBean.idno = '12121';

        responseBean.isUserBlocked = true;
        responseBean.personalQuestionsenabled = true;
        responseBean.passportNo = '12321';
        responseBean.questionTimeout = 11;
        responseBean.otpvalue = '121';

        responseBean.otpstatus = true;
        responseBean.referToFraud = true;
        responseBean.otpnotGeneratedReason = 'wewq';
        responseBean.referenceNo = '212';
        responseBean.otpenabled = true;
        responseBean.repeatAuthenticationMessage = 'wewq';
        responseBean.noofAttemptsRemaining = 122;
        responseBean.requiredAuthenticatedPerc = 122;
        //  responseBean.secondName='wewq';
        responseBean.subscriberAuthenticationID = 122;
        responseBean.safpsmessage = 'wewq';
        responseBean.subscriberID = 122;
        responseBean.safpsindicator = true;
        responseBean.surname = 'wewq';
        responseBean.totalQuestionPointValue = 122;
        responseBean.haDeaseasedStatus = 'Test';
        responseBean.encryptedReferenceNo = 'Test';
        // responseBean.haDeaseasedDate='Test';
        responseBean.haFirstName = 'Test';
        responseBean.haIDIssuedDate = 'Test';
        responseBean.haIDNo = 'Test';
        responseBean.haSecondName = 'Test';
        responseBean.authenticationStatusReason = 'Test';
        responseBean.haSurname = 'Test';
        // responseBean.questions
        XDSSubmitQuetions_Resp_IB_v1.questions que = new XDSSubmitQuetions_Resp_IB_v1.Questions();
        XDSSubmitQuetions_Resp_IB_v1.questionDocument queDoc = new XDSSubmitQuetions_Resp_IB_v1.QuestionDocument();
        queDoc.answerStatusInd = 'Test';
        queDoc.questionPointValue = 10;
        queDoc.question = 'test';
        queDoc.requiredNoOfAnswers = 1;
        queDoc.productAuthenticationQuestionID = 1;
        return responseBean;
    }
}