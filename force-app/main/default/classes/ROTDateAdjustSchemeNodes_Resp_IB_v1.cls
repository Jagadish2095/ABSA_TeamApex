public class ROTDateAdjustSchemeNodes_Resp_IB_v1 extends Base_IB {
    //constructor
    public ROTDateAdjustSchemeNodes_Resp_IB_v1(){}
    public DateAdjustSchemeNodesResponse DateAdjustSchemeNodesResponse;
	public class ValidationErrors{
		public list<ServiceValidationResult> ServiceValidationResult;
	}
	public class string1{
		public String string1;
	}
	public class ServiceValidationResult{
		public MemberNames MemberNames;
		public String Message;
		public String MessageCode;
	}
	public class ServiceInformationResult{
		public String MessageCode;
		public String Message;
	}
	public class SchemeNodeDateAdjustmentResult{
		public String EntityType;
		public String ObjectID;
		public String GroupRestrictionObjectID;
		public String SchemeNodeID;
		public String GroupRestrictionClusterID;
		public String Success;
		public String ErrorMessage;
		public String NewParentSchemeNodeID;
		public String EffectiveStartDate;
		public String NewSchemeNodeID;
		public String Abandoned;
	}
	public class Records{
		public list<SchemeNodeDateAdjustmentResult> SchemeNodeDateAdjustmentResult;
	}
	public class MemberNames{
		public list<string1> string1;
	}
	public class Information{
		public list<ServiceInformationResult> ServiceInformationResult;
	}
	public class DateAdjustSchemeNodesResult{
		public String IsCurrentPageTheLast;
		public ValidationErrors ValidationErrors;
		public String Tag;
		public String CurrentPage;
		public String SystemErrorMessage;
		public String PageToken;
		public Information Information;
		public Records Records;
		public String HasValidationErrors;
		public String TotalRecords;
		public String HasSystemError;
		public String HasErrors;
	}
	public class DateAdjustSchemeNodesResponse{
		public DateAdjustSchemeNodesResult DateAdjustSchemeNodesResult;
	}
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"string":', '"string1":');
    }
    
    /*public DateAdjustSchemeNodesResponse DateAdjustSchemeNodesResponse;
	public class Tag{
		public Boolean nil;
	}
	public class PageToken{
		public Boolean nil;
	}
	public class DateAdjustSchemeNodesResult{
		public String Records;
		public String PageToken;
		public String IsCurrentPageTheLast;
		public String SystemErrorMessage;
		public String Information;
		public String Tag;
		public String HasValidationErrors;
		public Integer TotalRecords;
		public String HasSystemError;
		public String ValidationErrors;
		public String HasErrors;
		public Integer CurrentPage;
	}
	public class DateAdjustSchemeNodesResponse{
		public DateAdjustSchemeNodesResult DateAdjustSchemeNodesResult;
	}*/

}