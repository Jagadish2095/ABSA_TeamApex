/*
 * Request Integration Bean for ExergyPolicyGetCover Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */

public class ExergyPolicyGetCover_Resp_IB_v1 extends Base_IB {

  @AuraEnabled  public String status;
  @AuraEnabled  public Integer statusCode;
  @AuraEnabled  public String message;

  	public class Policy_GetClientExposureExergyResult {
		@AuraEnabled public String TotalCover; 
		@AuraEnabled public String TotalCoverAvailable;
		@AuraEnabled public String ValidationMessage; 
	}
	
	public class ExceptionDetail {
	
		public Object HelpLink; 
		//public InnerException_Z InnerException; 
		public Object Message; 
		public Object StackTrace; 
		public Object Type_Z; // in json: Type
	}
	
	public class ResponseHeader {
		public String TransId; 
		public String SourceTransId;
		public Result Result; 
	}
	
	@AuraEnabled public Envelope Envelope;
	
	/*public class InnerException_Z {
		public Object HelpLink; 
		public Object Message ; 
		public Object StackTrace ; 
		public Object Type_Z ; // in json: Type

	}*/
	
	public class Fault {
		public Object faultcode;
		public Object faultstring; 
		public Detail detail; 

	}
	
	public class Policy_GetClientExposureExergyResponse {
		@AuraEnabled public Policy_GetClientExposureExergyResult Policy_GetClientExposureExergyResult; 
		public String pstrValidationMessage; 
	}
	
	public class ResponseMessage {
		public String ActivityId; 
		@AuraEnabled public Policy_GetClientExposureExergyResponse Policy_GetClientExposureExergyResponse; 
		public Fault Fault; 
	}
	
	public class Envelope {
		@AuraEnabled public Body Body; 
	}
	
	public class Body {
		public ResponseHeader ResponseHeader; 
		@AuraEnabled public ResponseMessage ResponseMessage; 
	}
	
	public class Detail {
		public ExceptionDetail ExceptionDetail; 
	}
	
	public class Result {
		public String code; 
		public String status; 
		public String message;
	}
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"Type":', '"Type_Z":');
    }
}