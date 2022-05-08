/** 
 * @description Request Integration Bean for SubmitXDSQuestions Service
 * @author Sudhakar Reddy
 * @created 23 SEP 2021 
 */
public class  XDSSubmitQuestions_Req_IB_v2 extends Base_IB {
    /** 
     * @description AuthenticationHistory
    */
    public class AuthenticationHistory {
        public List<AuthenticationHistoryDocument> authenticationHistoryDocument;
    }

    /**
     * @description Answers
    */
    public class Answers {
        public List<AnswerDocument> answerDocument;
    }

    /**
     * @description VoidReasons
    */
    public class VoidReasons {
        public List<VoidReasonsDocument> voidReasonsDocument;
    }

    public String abNumber;
    public String agentId;
    public AuthenticationDocument authenticationDocument;
    public String comments;
    public String department;
    public String extension;
    public String processAction;
    public XdsMetadata xdsMetadata;

    /**
     * @description XdsMetadata
    */
    public class XdsMetadata {
        public String agentId;
        public String cifKey;
        public String sessionId;
    }

    /**
     * @description AuthenticationHistoryDocument
    */
    public class AuthenticationHistoryDocument {
        public String bureauDate;
        public String subscriberName;
        public String cellularNumber;
        public String authenticationStatus;
        public String authenticationPerc;
        public String emailAddress;
    }

    /**
     * @description FraudReasonsDocument
    */
    public class FraudReasonsDocument {
        public Integer fraudReasonID;
        public String fraudReason;
        public Boolean isEnteredReasonYN;
    }

    /**
     * @description AuthenticationDocument
    */
    public class AuthenticationDocument {
        public Integer subscriberID;
        public Integer subscriberAuthenticationID;
        public Long authenticationDate;
        public String authenticationStatusInd;
        public String authenticationTypeInd;
        public String referenceNo;
        public Integer totalQuestionPointValue;
        public Double requiredAuthenticatedPerc;
        public Double authenticatedPerc;
        public String repeatAuthenticationMessage;
        public Integer actionedBySystemUserID;
        public String firstName;
        public Object secondName;
        public String surname;
        public Object passportNo;
        public String birthDate;
        public String gender;
        public String haFirstName;
        public String haSecondName;
        public String haSurname;
        public String haIDNo;
        public String haDeaseasedStatus;
        public Object haDeaseasedDate;
        public Object haCauseOfDeath;
        public String haIDIssuedDate;
        public String consumerAccountAgeMessage;
        public String encryptedReferenceNo;
        public String authenticationComment;
        public Boolean isUserBlocked;
        public Boolean personalQuestionsenabled;
        public Boolean blockingEnabledFlag;
        public Boolean referToFraud;
        public Integer blockid;
        public String blockingReason;
        public Integer questionTimeout;
        public String errorMessage;
        public String voidorFraudReason;
        public Integer noofAttemptsRemaining;
        public String authenticationStatusReason;
        public Questions questions;
        public AuthenticationHistory authenticationHistory;
        public VoidReasons voidReasons;
        public Object personalQuestions;
        public FraudReasons fraudReasons;
        public Boolean safpsindicator;
        public Boolean otpstatus;
        public Boolean otpenabled;
        public String otpnotGeneratedReason;
        public String otpvalue;
        public String safpsmessage;
        public String idno;
    }

    /**
     * @description FraudReasons
    */
    public class FraudReasons {
        public List<FraudReasonsDocument> fraudReasonsDocument;
    }

    /**
     * @description QuestionDocument
    */
    public class QuestionDocument {
        public Integer productAuthenticationQuestionID;
        public String question;
        public String answerStatusInd;
        public Integer questionPointValue;
        public Integer requiredNoOfAnswers;
        public Answers answers;
    }

    /**
     * @description AnswerDocument
    */
    public class AnswerDocument {
        public Integer answerID;
        public String answer;
        public Boolean isEnteredAnswerYN;
    }

    /**
     * @description Questions
    */
    public class Questions {
        public List<QuestionDocument> questionDocument;
    }

    /**
     * @description VoidReasonsDocument
    */
    public class VoidReasonsDocument {
    }

    /**
     * @description createDummyRequest
     * @return XDSSubmitQuestions_Req_IB_v2
    */
    public static XDSSubmitQuestions_Req_IB_v2 createDummyRequest() {
		XDSSubmitQuestions_Req_IB_v2 requestBean = new XDSSubmitQuestions_Req_IB_v2();
		requestBean.abNumber = '7011';
		requestBean.authenticationDocument = new AuthenticationDocument();
		requestBean.agentId = '7710256047181';
		requestBean.comments = '';

		return requestBean;
	}


}