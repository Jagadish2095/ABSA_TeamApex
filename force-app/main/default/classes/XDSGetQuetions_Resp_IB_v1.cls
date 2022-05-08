/**
 * Apex Integration Response Bean class for XDSGetQuetions service
 * @author  Madhava Palla : Absa
 * @since   2019-08-20
 *
 **/

public class XDSGetQuetions_Resp_IB_v1 extends Base_IB {

     @ auraEnabled public String Message;
     @ auraEnabled public Integer StatusCode;
     @ auraEnabled public String StatusMessage;

     @ auraEnabled public AuthenticationHistory authenticationHistory;
     @ auraEnabled public Boolean blockingEnabledFlag;
     @ auraEnabled public Boolean isUserBlocked;
     @ auraEnabled public Boolean otpenabled;
     @ auraEnabled public Boolean otpstatus;
     @ auraEnabled public Boolean personalQuestionsenabled;
     @ auraEnabled public Boolean referToFraud;
     @ auraEnabled public Boolean safpsindicator;
     @ auraEnabled public Decimal authenticatedPerc;
     @ auraEnabled public Decimal requiredAuthenticatedPerc;
     @ auraEnabled public fraudReasons fraudReasons;
     @ auraEnabled public Integer actionedBySystemUserID;
     @ auraEnabled public Integer blockid;
     @ auraEnabled public Integer currentQuestionNum;
     @ auraEnabled public Integer noofAttemptsRemaining;
     @ auraEnabled public Integer questionTimeout;
     @ auraEnabled public Integer subscriberAuthenticationID;
     @ auraEnabled public Integer subscriberID;
     @ auraEnabled public Integer totalQuestionPointValue;
     @ auraEnabled public Questions questions;
     @ auraEnabled public String authenticationComment;
     @ auraEnabled public String authenticationDate;
     @ auraEnabled public String authenticationStatusInd;
     @ auraEnabled public String authenticationStatusReason;
     @ auraEnabled public String authenticationTypeInd;
     @ auraEnabled public String birthDate;
     @ auraEnabled public String blockingReason;
     @ auraEnabled public String consumerAccountAgeMessage;
     @ auraEnabled public String encryptedReferenceNo;
     @ auraEnabled public String enquiryid;
     @ auraEnabled public String enquiryresultid;
     @ auraEnabled public String errorMessage;
     @ auraEnabled public String firstName;
     @ auraEnabled public String gender;
     @ auraEnabled public String haDeaseasedStatus;
     @ auraEnabled public String haFirstName;
     @ auraEnabled public String haIDIssuedDate;
     @ auraEnabled public String haIDNo;
     @ auraEnabled public String haSecondName;
     @ auraEnabled public String haSurname;
     @ auraEnabled public String idno;
     @ auraEnabled public String otpnotGeneratedReason;
     @ auraEnabled public String otpvalue;
     @ auraEnabled public String passportNo;
     @ auraEnabled public String processAction;
     @ auraEnabled public String referenceNo;
     @ auraEnabled public String repeatAuthenticationMessage;
     @ auraEnabled public String safpsmessage;
     @ auraEnabled public String surname;
     @ auraEnabled public String voidorFraudReason;
     @ auraEnabled public VoidReasons voidReasons;

    public class Answers {
         @ auraEnabled public List < AnswerDocument > answerDocument;
    }

    public class AnswerDocument {
         @ auraEnabled public Boolean isEnteredAnswerYN;
         @ auraEnabled public Integer answerID;
         @ auraEnabled public String answer;
    }

    public class AuthenticationHistory {
         @ auraEnabled public List < AuthenticationHistoryDocument > authenticationHistoryDocument;
    }

    public class AuthenticationHistoryDocument {
         @ auraEnabled public String authenticationPerc;
         @ auraEnabled public String authenticationStatus;
         @ auraEnabled public String bureauDate;
         @ auraEnabled public String cellularNumber;
         @ auraEnabled public String emailAddress;
         @ auraEnabled public String subscriberName;
    }

    public class FraudReasons {
         @ auraEnabled public List < FraudReasonsDocument > fraudReasonsDocument;
    }

    public class FraudReasonsDocument {
         @ auraEnabled public Boolean isEnteredReasonYN;
         @ auraEnabled public Integer fraudReasonID;
         @ auraEnabled public String fraudReason;
    }

    public class Questions {
         @ auraEnabled public List < QuestionDocument > questionDocument;
    }

    public class QuestionDocument {
         @ auraEnabled public Answers answers;
         @ auraEnabled public Integer productAuthenticationQuestionID;
         @ auraEnabled public Integer questionPointValue;
         @ auraEnabled public Integer requiredNoOfAnswers;
         @ auraEnabled public String answerStatusInd;
         @ auraEnabled public String question;
    }

    public class VoidReasons {
         @ auraEnabled public List < VoidReasonsDocument > voidReasonsDocument;
    }

    public class VoidReasonsDocument {
         @ auraEnabled public Boolean isEnteredReasonYN;
         @ auraEnabled public Integer voidReasonID;
         @ auraEnabled public String voidReason;
    }

    public static XDSGetQuetions_Resp_IB_v1 DummyRequestForXDSVerification() {
        XDSGetQuetions_Resp_IB_v1 responseBean = new XDSGetQuetions_Resp_IB_v1();
        responseBean.processAction = 'Authenticate';
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
        return responseBean;
    }
}