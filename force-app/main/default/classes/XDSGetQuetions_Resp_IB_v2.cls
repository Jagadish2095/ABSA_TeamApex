/**
 * @description       : XDS Question 2.3
 * @author            : Lehlohonolo.Matsoso@absa.africa
 * @last modified on  : 2021-11-09
 * @last modified by  : Lehlohonolo.Matsoso@absa.africa
**/
public class XDSGetQuetions_Resp_IB_v2 extends Base_IB{
    /**
     * @description AuthenticationHistory
    */
    public class AuthenticationHistory {
        @AuraEnabled public List<AuthenticationHistoryDocument> authenticationHistoryDocument;
    }

    /**
     * @description Answers
    */
    public class Answers {
        @AuraEnabled public List<AnswerDocument> answerDocument;
    }

    /**
     * @description VoidReasons
    */
    public class VoidReasons {
        @AuraEnabled public List<ErrorList> voidReasonsDocument;
    }

    @AuraEnabled public Boolean errors;
    @AuraEnabled public List<ErrorList> errorList;
    @AuraEnabled public AuthenticationDocument authenticationDocument;

    /**
     * @description ErrorList
    */
    public class ErrorList {
        @AuraEnabled public String field;
		@AuraEnabled public String description;
    }

    /**
     * @description AuthenticationHistoryDocument
    */
    public class AuthenticationHistoryDocument {
        @AuraEnabled public String bureauDate;
        @AuraEnabled public String subscriberName;
        @AuraEnabled public String cellularNumber;
        @AuraEnabled public String authenticationStatus;
        @AuraEnabled public String authenticationPerc;
        @AuraEnabled public String emailAddress;
    }

    /**
     * @description AnswerDocument
    */
    public class AnswerDocument {
        @AuraEnabled public Integer answerID;
        /**
         *@description answerIdString
        */
        @AuraEnabled public String answerIdString
        {
            get{ return String.valueOf(answerID);}
        }

        @AuraEnabled public String answer;
        @AuraEnabled public Boolean isEnteredAnswerYN;
    }

    /**
     * @description Questions
    */
    public class Questions {
        @AuraEnabled public List<QuestionDocument> questionDocument;
    }

    /**
     * @description FraudReasonsDocument
    */
    public class FraudReasonsDocument {
        @AuraEnabled public Integer fraudReasonID;
        @AuraEnabled public String fraudReason;
        @AuraEnabled public Boolean isEnteredReasonYN;
    }

    /**
     * @description AuthenticationDocument
    */
    public class AuthenticationDocument {
        @AuraEnabled public Integer subscriberID;
        @AuraEnabled public Integer subscriberAuthenticationID;
        @AuraEnabled public Long authenticationDate;
        @AuraEnabled public String authenticationStatusInd;
        @AuraEnabled public String authenticationTypeInd;
        @AuraEnabled public String referenceNo;
        @AuraEnabled public Integer totalQuestionPointValue;
        @AuraEnabled public Double requiredAuthenticatedPerc;
        @AuraEnabled public Double authenticatedPerc;
        @AuraEnabled public String repeatAuthenticationMessage;
        @AuraEnabled public Integer actionedBySystemUserID;
        @AuraEnabled public String firstName;
        @AuraEnabled public Object secondName;
        @AuraEnabled public String surname;
        @AuraEnabled public Object passportNo;
        @AuraEnabled public String birthDate;
        @AuraEnabled public String gender;
        @AuraEnabled public String haFirstName;
        @AuraEnabled public String haSecondName;
        @AuraEnabled public String haSurname;
        @AuraEnabled public String haIDNo;
        @AuraEnabled public String haDeaseasedStatus;
        @AuraEnabled public Object haDeaseasedDate;
        @AuraEnabled public Object haCauseOfDeath;
        @AuraEnabled public String haIDIssuedDate;
        @AuraEnabled public String consumerAccountAgeMessage;
        @AuraEnabled public String encryptedReferenceNo;
        @AuraEnabled public String authenticationComment;
        @AuraEnabled public Boolean isUserBlocked;
        @AuraEnabled public Boolean personalQuestionsenabled;
        @AuraEnabled public Boolean blockingEnabledFlag;
        @AuraEnabled public Boolean referToFraud;
        @AuraEnabled public Integer blockid;
        @AuraEnabled public String blockingReason;
        @AuraEnabled public Integer questionTimeout;
        @AuraEnabled public String errorMessage;
        @AuraEnabled public String voidorFraudReason;
        @AuraEnabled public Integer noofAttemptsRemaining;
        @AuraEnabled public String authenticationStatusReason;
        @AuraEnabled public Questions questions;
        @AuraEnabled public AuthenticationHistory authenticationHistory;
        @AuraEnabled public VoidReasons voidReasons;
        @AuraEnabled public Object personalQuestions;
        @AuraEnabled public FraudReasons fraudReasons;
        @AuraEnabled public Boolean safpsindicator;
        @AuraEnabled public Boolean otpstatus;
        @AuraEnabled public Boolean otpenabled;
        @AuraEnabled public String otpnotGeneratedReason;
        @AuraEnabled public String otpvalue;
        @AuraEnabled public String safpsmessage;
        @AuraEnabled public String idno;
    }

    /**
     * @description FraudReasons
    */
    public class FraudReasons {
        @AuraEnabled public List<FraudReasonsDocument> fraudReasonsDocument;
    }

    /**
     * @description QuestionDocument
    */
    public class QuestionDocument {
        @AuraEnabled public Integer productAuthenticationQuestionID;
        @AuraEnabled public String question;
        @AuraEnabled public String answerStatusInd;
        @AuraEnabled public Integer questionPointValue;
        @AuraEnabled public Integer requiredNoOfAnswers;
        @AuraEnabled public Answers answers;
    }

}