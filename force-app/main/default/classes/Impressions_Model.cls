/**
*@description Impressions_Model
*Apex Class Impressions_Model
* @author  
* @version v1.0
* @since   
*
*/
public class Impressions_Model {
    
    /**
    *@description CreatePDFSignatureRequestEventInput
    * @author 
    * @since   
    *
    */
	
	public class CreatePDFSignatureRequestEventInput {
      /**
     * @description 
     */
	  public String title { get; set; }
       /**
     * @description 
     */
	  public String surname { get; set; }
       /**
     * @description 
     */
	  public String sender { get; set; }
       /**
     * @description 
     */
	  public String docName { get; set; }
         /**
     * @description 
     */
	  public String docType { get; set; }
         /**
     * @description 
     */
	  public String email { get; set; }
         /**
     * @description 
     */
	  public Boolean silent { get; set; }
         /**
     * @description 
     */
	  public String emailNotifications { get; set; }
         /**
     * @description 
     */
	  public String schedule { get; set; }
         /**
     * @description 
     */
	  public Boolean disableWebSigning { get; set; }
         /**
     * @description 
     */
	  public String mobile { get; set; }
         /**
     * @description 
     */
	  public String language { get; set; }
	  /** custom return JSON Dictionary */
         /**
     * @description 
     */
	  public CustomSignatoryOptions custom { get; set; }
         /**
     * @description 
     */
	  public String doc { get; set; }

      /** 
    * @description getExample
    * @param 
    * @return CreatePDFSignatureRequestEventInput
    */
	  public CreatePDFSignatureRequestEventInput getExample() {
	         CreatePDFSignatureRequestEventInput example = new CreatePDFSignatureRequestEventInput ();
	         example.title = 'aeiou';
	         example.surname = 'aeiou';
	         example.sender = 'aeiou';
	         example.docName = 'aeiou';
	         example.docType = 'aeiou';
	         example.email = 'aeiou';
	         example.silent = false;
	         example.emailNotifications = 'aeiou';
	         example.schedule = 'aeiou';
	         example.disableWebSigning = false;
	         example.mobile = 'aeiou';
	         example.language = 'aeiou';
	         example.custom = new CustomSignatoryOptions().getExample();
	         example.doc = 'aeiou';
	         return example;
	  }

	}
    /**
    *@description CreatePDFSignatureRequestEventOutput
    * @author 
    * @since   
    *
    */
	public class CreatePDFSignatureRequestEventOutput {
	   /**
     * @description 
     */
	  public String status { get; set; }
         /**
     * @description 
     */
	  public String requestID { get; set; }
         /**
     * @description 
     */
	  public String message { get; set; }
	
	 /** 
    * @description getExample
    * @param 
    * @return CreatePDFSignatureRequestEventOutput
    */
	  public CreatePDFSignatureRequestEventOutput getExample() {
	         CreatePDFSignatureRequestEventOutput example = new CreatePDFSignatureRequestEventOutput ();
	         example.status = 'aeiou';
	         example.requestID = 'aeiou';
	         example.message = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description CreateInlinePDFSignatureRequestEventInput
    * @author 
    * @since   
    *
    */
	public class CreateInlinePDFSignatureRequestEventInput {
	   /**
     * @description 
     */
	  public Integer stepCount { get; set; }
         /**
     * @description 
     */
	  public String sender { get; set; }
         /**
     * @description 
     */
	  public String signType { get; set; }
         /**
     * @description 
     */
	  public String returnEmail { get; set; }
         /**
     * @description 
     */
	  public String docName { get; set; }
         /**
     * @description 
     */
	  public String docType { get; set; }
         /**
     * @description 
     */
	  public Signatory[] signatories { get; set; }
         /**
     * @description 
     */
	  public String doc { get; set; }
         /**
     * @description 
     */
	  public String regTemplate { get; set; }
         /**
     * @description 
     */
	  public String deadline { get; set; }
	
	 /** 
    * @description getExample
    * @param 
    * @return CreateInlinePDFSignatureRequestEventInput
    */
	  public CreateInlinePDFSignatureRequestEventInput getExample() {
	         CreateInlinePDFSignatureRequestEventInput example = new CreateInlinePDFSignatureRequestEventInput ();
	         example.stepCount = 1;
	         example.sender = 'aeiou';
	         example.signType = 'aeiou';
	         example.returnEmail = 'aeiou';
	         example.docName = 'aeiou';
	         example.docType = 'aeiou';
	         example.signatories = null;
	         example.doc = 'aeiou';
	         example.regTemplate = 'aeiou';
	         example.deadline = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description CreateInlinePDFSignatureRequestEventOutput
    * @author 
    * @since   
    *
    */
	public class CreateInlinePDFSignatureRequestEventOutput {
	   /**
     * @description 
     */
	  public String status { get; set; }
         /**
     * @description 
     */
	  public String workflowID { get; set; }
         /**
     * @description 
     */
	  public SignatureRequest[] requests { get; set; }
	
	  /** 
    * @description getExample
    * @param 
    * @return CreateInlinePDFSignatureRequestEventOutput
    */
	  public CreateInlinePDFSignatureRequestEventOutput getExample() {
	         CreateInlinePDFSignatureRequestEventOutput example = new CreateInlinePDFSignatureRequestEventOutput ();
	         example.status = 'aeiou';
	         example.workflowID = 'aeiou';
	         example.requests = null;
	         return example;
	  }
	
	}
	/**
    *@description SignatureRequest
    * @author 
    * @since   
    *
    */
	public class SignatureRequest {
         /**
     * @description 
     */
		public String id { get; set; }
         /**
     * @description 
     */
		public String email { get; set; }
	}
	/**
    *@description EmailTemplatePUTInput
    * @author 
    * @since   
    *
    */
	public class EmailTemplatePUTInput {
	 /**
     * @description 
     */
	  public String name { get; set; }
         /**
     * @description 
     */
	  public String template { get; set; }
	
	 
	  /** 
    * @description getExample
    * @param 
    * @return EmailTemplatePUTInput
    */
	  public EmailTemplatePUTInput getExample() {
	         EmailTemplatePUTInput example = new EmailTemplatePUTInput ();
	         example.name = 'aeiou';
	         example.template = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description EmailTemplateOutput
    * @author 
    * @since   
    *
    */
	public class EmailTemplateOutput {
	   /**
     * @description 
     */
	  public String status { get; set; }
         /**
     * @description 
     */
	  public String message { get; set; }
	
	  /** 
    * @description getExample
    * @param 
    * @return EmailTemplateOutput
    */
	  public EmailTemplateOutput getExample() {
	         EmailTemplateOutput example = new EmailTemplateOutput ();
	         example.status = 'aeiou';
	         example.message = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description RemoveDocOutput
    * @author 
    * @since   
    *
    */
	public class RemoveDocOutput {
	   /**
     * @description 
     */
	  public String status { get; set; }
         /**
     * @description 
     */
	  public String message { get; set; }
	
	  /** 
    * @description getExample
    * @param 
    * @return RemoveDocOutput
    */
	  public RemoveDocOutput getExample() {
	         RemoveDocOutput example = new RemoveDocOutput ();
	         example.status = 'aeiou';
	         example.message = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description CreateSignatureWorkflowInputStep
    * @author 
    * @since   
    *
    */
	public class CreateSignatureWorkflowInputStep {
	   /**
     * @description 
     */
	  public Integer id { get; set; }
         /**
     * @description 
     */
	  public String condition { get; set; }
         /**
     * @description 
     */
	  public String[] requestIDList { get; set; }
         /**
     * @description 
     */
      public String surname { get; set; } // W-13540
	
	 /** 
    * @description getExample
    * @param 
    * @return CreateSignatureWorkflowInputStep
    */
	  public CreateSignatureWorkflowInputStep getExample() {
	         CreateSignatureWorkflowInputStep example = new CreateSignatureWorkflowInputStep ();
	         example.id = 1;
	         example.condition = 'aeiou';
	         example.requestIDList = null;
	         return example;
	  }
	
	}
	/**
    *@description CreateSignatureWorkflowInput
    * @author 
    * @since   
    *
    */
	public class CreateSignatureWorkflowInput {
	   /**
     * @description 
     */
	  public Integer batchCount { get; set; }
         /**
     * @description 
     */
	  public String[] batchRequestIDList { get; set; }
      /**
     * @description 
     */
	  public String emailNotifications { get; set; }
        /**
     * @description 
     */
	  public Integer stepCount { get; set; }
        /**
     * @description 
     */
	  public CreateSignatureWorkflowInputStep[] steps { get; set; }
	
	 /** 
    * @description getExample
    * @param 
    * @return CreateSignatureWorkflowInput
    */
	  public CreateSignatureWorkflowInput getExample() {
	         CreateSignatureWorkflowInput example = new CreateSignatureWorkflowInput ();
	         example.batchCount = 1;
	         example.batchRequestIDList = null;
	         example.emailNotifications = 'aeiou';
	         example.stepCount = 1;
	         example.steps = null;
	         return example;
	  }
	
	}
	/**
    *@description CreateSignatureWorkflowOutput
    * @author 
    * @since   
    *
    */
	public class CreateSignatureWorkflowOutput {
	  /**
     * @description 
     */
	  public String status { get; set; }
        /**
     * @description 
     */
	  public String workflowID { get; set; }
        /**
     * @description 
     */
	  public String reason { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return CreateSignatureWorkflowOutput
    */
	  public CreateSignatureWorkflowOutput getExample() {
	         CreateSignatureWorkflowOutput example = new CreateSignatureWorkflowOutput ();
	         example.status = 'aeiou';
	         example.workflowID = 'aeiou';
	         example.reason = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description AuthenticationIntentOutput
    * @author 
    * @since   
    *
    */
	public class AuthenticationIntentOutput {
      /**
     * @description 
     */
	  public String status { get; set; }
        /**
     * @description 
     */
	  public Object message { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return AuthenticationIntentOutput
    */
	  public AuthenticationIntentOutput getExample() {
	         AuthenticationIntentOutput example = new AuthenticationIntentOutput ();
	         example.status = 'aeiou';
	         example.message = null;
	         return example;
	  }
	
	}
	/**
    *@description AuthenticationStatusOutput
    * @author 
    * @since   
    *
    */
	public class AuthenticationStatusOutput {
	  /**
     * @description 
     */
	  public Boolean intentApplied { get; set; }
        /**
     * @description 
     */
	  public String intentStatus { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return AuthenticationStatusOutput
    */
	  public AuthenticationStatusOutput getExample() {
	         AuthenticationStatusOutput example = new AuthenticationStatusOutput ();
	         example.intentApplied = false;
	         example.intentStatus = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description SMSNotifyAuthenticationIntentInput
    * @author 
    * @since   
    *
    */
	public class SMSNotifyAuthenticationIntentInput {
     /**
     * @description 
     */
	  public String message { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return SMSNotifyAuthenticationIntentInput
    */
	  public SMSNotifyAuthenticationIntentInput getExample() {
	         SMSNotifyAuthenticationIntentInput example = new SMSNotifyAuthenticationIntentInput ();
	         example.message = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description SMSNotifyAuthenticationIntentOutput
    * @author 
    * @since   
    *
    */
	public class SMSNotifyAuthenticationIntentOutput {
	  /**
     * @description 
     */
	  public String status { get; set; }
        /**
     * @description 
     */
	  public String message { get; set; }
        /**
     * @description 
     */
	  public String txID { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return SMSNotifyAuthenticationIntentOutput
    */
	  public SMSNotifyAuthenticationIntentOutput getExample() {
	         SMSNotifyAuthenticationIntentOutput example = new SMSNotifyAuthenticationIntentOutput ();
	         example.status = 'aeiou';
	         example.message = 'aeiou';
	         example.txID = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description SigningDeferredInput
    * @author 
    * @since   
    *
    */
	public class SigningDeferredInput {
	  /**
     * @description 
     */
	  public Boolean addLtv { get; set; }
        /**
     * @description 
     */
	  public Object[] sigs { get; set; }
        /**
     * @description 
     */
	  public Object formFields { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return SigningDeferredInput
    */
	  public SigningDeferredInput getExample() {
	         SigningDeferredInput example = new SigningDeferredInput ();
	         example.addLtv = false;
	         example.sigs = null;
	         example.formFields = null;
	         return example;
	  }
	
	}
	/**
    *@description SigningDeferredOutput
    * @author 
    * @since   
    *
    */
	public class SigningDeferredOutput {
	  /**
     * @description 
     */
	  public String status { get; set; }
        /**
     * @description 
     */
	  public String reason { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return SigningDeferredOutput
    */
	  public SigningDeferredOutput getExample() {
	         SigningDeferredOutput example = new SigningDeferredOutput ();
	         example.status = 'aeiou';
	         example.reason = 'aeiou';
	         return example;
	  }
	
	}
    /**
    *@description SignatureAuditDocOutput
    * @author 
    * @since   
    *
    */
	public class SignatureAuditDocOutput {
	  /**
     * @description 
     */
	  public String requestID { get; set; }
        
      /**
     * @description 
     */
	  public Integer count { get; set; }
        /**
     * @description 
     */
	  public AuditItem[] items { get; set; }
        /**
     * @description 
     */
	  public Doc doc { get; set; }
	
	 /** 
    * @description getExample
    * @param 
    * @return SignatureAuditDocOutput
    */
	  public SignatureAuditDocOutput getExample() {
	         SignatureAuditDocOutput example = new SignatureAuditDocOutput ();
	         example.requestID = 'aeiou';
	         example.count = 1;
	         example.items = null;
	         example.doc = null;
	         return example;
	  }
	
	}
	/**
    *@description SignatureAuditOutput
    * @author 
    * @since   
    *
    */
	public class SignatureAuditOutput {
	  /**
     * @description 
     */
	  public String requestID { get; set; }
        /**
     * @description 
     */
	  public Integer count { get; set; }
        /**
     * @description 
     */
	  public AuditItem[] items { get; set; }
	
	
	 /** 
    * @description getExample
    * @param 
    * @return SignatureAuditOutput
    */
	  public SignatureAuditOutput getExample() {
	         SignatureAuditOutput example = new SignatureAuditOutput ();
	         example.requestID = 'aeiou';
	         example.count = 1;
	         example.items = null;
	         return example;
	  }
	
	}
	/**
    *@description DesignDocInput
    * @author 
    * @since   
    *
    */
	public class DesignDocInput {
	  /**
     * @description 
     */
	  public String type { get; set; }
        /**
     * @description 
     */
	  public String prefix { get; set; }
        /**
     * @description 
     */
	  public Object formFields { get; set; }
        /**
     * @description 
     */
	  public Object[] sigs { get; set; }
        /**
     * @description 
     */
	  public String doc { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return DesignDocInput
    */
	  public DesignDocInput getExample() {
	         DesignDocInput example = new DesignDocInput ();
	         example.type = 'aeiou';
	         example.prefix = 'aeiou';
	         example.formFields = null;
	         example.sigs = null;
	         example.doc = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description DesignDocOutput
    * @author 
    * @since   
    *
    */
	public class DesignDocOutput {
	  /**
     * @description 
     */
	  public Object rules { get; set; }
        /**
     * @description 
     */
	  public String status { get; set; }
        /**
     * @description 
     */
	  public String doc { get; set; }
        /**
     * @description 
     */
	  public String message { get; set; }
	 /** 
    * @description getExample
    * @param 
    * @return DesignDocOutput
    */
	
	  public DesignDocOutput getExample() {
	         DesignDocOutput example = new DesignDocOutput ();
	         example.rules = null;
	         example.status = 'aeiou';
	         example.doc = 'aeiou';
	         example.message = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description DocusignPayloadInput
    * @author 
    * @since   
    *
    */
	public class DocusignPayloadInput {
	
	
	/** 
    * @description getExample
    * @param 
    * @return DocusignPayloadInput
    */
	  public DocusignPayloadInput getExample() {
	         DocusignPayloadInput example = new DocusignPayloadInput ();
	         return example;
	  }
	
	}
	/**
    *@description GetRolesInput
    * @author 
    * @since   
    *
    */
	public class GetRolesInput {
	  /**
     * @description 
     */
	  public String extension { get; set; }
        /**
     * @description 
     */
	  public String doc { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return GetRolesInput
    */
	  public GetRolesInput getExample() {
	         GetRolesInput example = new GetRolesInput ();
	         example.extension = 'aeiou';
	         example.doc = 'aeiou';
	         return example;
	  }
	
	}
	/**
    *@description GetRolesOutput
    * @author 
    * @since   
    *
    */
	public class GetRolesOutput {
	   /**
     * @description 
     */
	  public String status { get; set; }
         /**
     * @description 
     */
	  public Object tags { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return GetRolesOutput
    */
	  public GetRolesOutput getExample() {
	         GetRolesOutput example = new GetRolesOutput ();
	         example.status = 'aeiou';
	         example.tags = null;
	         return example;
	  }
	
	}
   /**
    *@description CustomSignatoryOptions
    * @author 
    * @since   
    *
    */
	public class CustomSignatoryOptions {
	 /**
     * @description 
     */
	  public String returnType { get; set; }
         /**
     * @description 
     */
        
	  public String regTemplate { get; set; }
         /**
     * @description 
     */
	  public String returnTemplate { get; set; }
         /**
     * @description 
     */
	  public String returnEmail { get; set; }
         /**
     * @description 
     */
	  public String challenge { get; set; }
         /**
     * @description 
     */
	  public String callbackMethod { get; set; }
         /**
     * @description 
     */
	  public Object callbackHeaders { get; set; }
         /**
     * @description 
     */
	  public Object callbackPayload { get; set; }
         /**
     * @description 
     */
	  public String callbackEndpoint { get; set; }
         /**
     * @description 
     */
	  public String docPassword { get; set; }
         /**
     * @description 
     */
	  public Object watermark { get; set; }
         /**
     * @description 
     */
	  public Object security { get; set; }
         /**
     * @description 
     */
	  public Object coc { get; set; }
	  /** 
    * @description getExample
    * @param 
    */
	  public CustomSignatoryOptions() {
	  	//this.security = new Empty();
	  	//this.callbackHeaders = new Empty();
	  	//this.callbackPayload = new Empty();
	  }
	
	 /** 
    * @description getExample
    * @param 
    * @return CustomSignatoryOptions
    */
	  public CustomSignatoryOptions getExample() {
	         CustomSignatoryOptions example = new CustomSignatoryOptions ();
	         example.returnType = 'aeiou';
	         example.regTemplate = 'aeiou';
	         example.returnTemplate = 'aeiou';
	         example.returnEmail = 'aeiou';
	         example.challenge = 'aeiou';
	         example.callbackMethod = 'aeiou';
	         example.callbackHeaders = null;
	         example.callbackPayload = null;
	         example.callbackEndpoint = 'aeiou';
	         example.docPassword = 'aeiou';
	         example.watermark = null;
	         example.security = null;
	         example.coc = null;
	         return example;
	  }
	
	}
    /**
    *@description RulesOutput
    * @author 
    * @since   
    *
    */
	public class RulesOutput {
	  /**
     * @description 
     */
	  public Object[] formfields { get; set; }
         /**
     * @description 
     */
	  public Integer sigCount { get; set; }
	
	/** 
    * @description getExample
    * @param 
    * @return RulesOutput
    */
	  public RulesOutput getExample() {
	         RulesOutput example = new RulesOutput ();
	         example.formfields = null;
	         example.sigCount = 1;
	         return example;
	  }
	
	}
	/**
    *@description Signatory
    * @author 
    * @since   
    *
    */
	public class Signatory {
		 /**
     * @description 
     */
		public String title { get; set; }
         /**
     * @description 
     */
		public String surname { get; set; }
         /**
     * @description 
     */
		public String mobile { get; set; }
         /**
     * @description 
     */
		public String email { get; set; }
		/**
     * @description 
     */
		public String emailBody { get; set; }
    /**
     * @description 
     */
		public CustomSignatoryOptions custom { get; set; }
         /**
     * @description 
     */
        public Integer order { get; set; } //W-012954
	}
	/**
    *@description AuditItem
    * @author 
    * @since   
    *
    */
	public class AuditItem {
		 /**
     * @description 
     */
		public String EventStatus { get; set; }
         /**
     * @description 
     */
		public String LastUpdated { get; set; }
		
	}
	/**
    *@description Doc
    * @author 
    * @since   
    *
    */
	public class Doc {
         /**
     * @description 
     */
		public String status { get; set; }
         /**
     * @description 
     */
		public String data { get; set; }
	}
	
	/**
	 * @description A dummy class to model empy objects
	 */
	public class Empty {
		
	}
	/**
    *@description Doc
    * @author 
    * @since   
    *
    */
	public class SignatoryWrapper {	
         /**
     * @description 
     */
        public Integer order { get; set; }//W-12954
         /**
     * @description 
     */
		public Integer index { get; set; }
         /**
     * @description 
     */
		public String signedStatus { get; set; }
         /**
     * @description 
     */
		public Signatory signatory { get; set; }
         /**
     * @description 
     */
		public String method { get; set; }
         /**
     * @description 
     */
		public String requestId { get; set; }
         /**
     * @description 
     */
		public Boolean next { get; set; }
         /**
     * @description 
     */
		public List<AuditItem> listOfSigAuditResponse { get; set; }
         /**
     * @description 
     */
		public String title { get; set; }
         /**
     * @description 
     */
		public String surname { get; set; }
         /**
     * @description 
     */
		public String mobile { get; set; }
         /**
     * @description 
     */
		public String email { get; set; }
	}
	/**
    *@description AnonymousTokenResponse
    * @author 
    * @since   
    *
    */
	public class AnonymousTokenResponse {
		/**
     * @description 
     */
		public String status { get; set; }
		/**
     * @description 
     */
		public String username { get; set; }
		/**
     * @description 
     */
		public String viewerpath { get; set; }
		/**
     * @description 
     */
		public String token { get; set; }
		/**
     * @description 
     */
		public String message { get; set; }
	}
	/**
    *@description WorkflowAuditOutput
    * @author 
    * @since   
    *
    */
	public class WorkflowAuditOutput {
		/**
     * @description 
     */
		public Integer count { get; set; }
		/**
     * @description 
     */
		public List<WorkflowAuditOutputItem> items { get; set; }
		/**
     * @description 
     */
		public String workflowID { get; set; }
		
		/**
     * @description 
     */
		public String filename { get; set; }
	}
	
	/**
	 * @description This class implements comparable so that collections of these objects
	 * can be sorted. This will sort by order of ascending @code{Step}.
	 *
	 */
	public class WorkflowAuditOutputItem implements Comparable {
         /**
     * @description 
     */
		public Integer Step { get; set; }
         /**
     * @description 
     */
		public String SignatureRequestID { get; set; }
         /**
     * @description 
     */
		public String EventStatus { get; set; }
         /**
     * @description 
     */
		public String LastUpdated { get; set; }
         
		// additional properties not in the service
		 /**
     * @description 
     */
		public String fullname { get; set; }
         /**
     * @description 
     */
		public List<AuditItem> auditItems { get; set; }
         /**
     * @description 
     */
		public String method { get; set; }
		/** 
    * @description getExample
    * @param other
    * @return Integer
    */
		public Integer compareTo(Object other) {
			WorkflowAuditOutputItem o = (WorkflowAuditOutputItem) other;
			return Step - o.Step;
		}
	}
}