/**
* Descripton: Wrapper class for DeleteSchemeNodes Service response.
* Class Name: ROTDeleteSchemeNodes_Resp_IB_v1
* @author  	: Srinivas
* Further modified by Manish as per latest response on 25-01-2021
**/
public class ROTDeleteSchemeNodes_Resp_IB_v1 extends Base_IB  {
    public DeleteSchemeNodesResponse DeleteSchemeNodesResponse;
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
	public class SchemeNodeOperationResult{
		public String EffectiveStartDate;
		public String GroupRestrictionObjectID;
		public String GroupRestrictionClusterID;
		public String ObjectID;
		public String ErrorMessage;
		public String SchemeNodeID;
		public String EntityType;
		public String Success;
		public String Abandoned;
	}
	public class Records{
		public list<SchemeNodeOperationResult> SchemeNodeOperationResult;
	}
	public class MemberNames{
		public list<string1> string1;
	}
	public class Information{
		public list<ServiceInformationResult> ServiceInformationResult;
	}
	public class DeleteSchemeNodesResult{
		public String CurrentPage;
		public ValidationErrors ValidationErrors;
		public String Tag;
		public String IsCurrentPageTheLast;
		public String SystemErrorMessage;
		public String PageToken;
		public Information Information;
		public Records Records;
		public String HasValidationErrors;
		public String TotalRecords;
		public String HasSystemError;
		public String HasErrors;
	}
	public class DeleteSchemeNodesResponse{
		public DeleteSchemeNodesResult DeleteSchemeNodesResult;
	}
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"string":', '"string1":');
    }
    /*public DeleteSchemeNodesResponse DeleteSchemeNodesResponse;
	public class Tag{
		public Boolean nil;
	}
	public class PageToken{
		public Boolean nil;
	}
	public class DeleteSchemeNodesResult{
		public String Records;
		public PageToken PageToken;
		public Boolean IsCurrentPageTheLast;
		public String SystemErrorMessage;
		public String Information;
		public Tag Tag;
		public Boolean HasValidationErrors;
		public Integer TotalRecords;
		public Boolean HasSystemError;
		public String ValidationErrors;
		public Boolean HasErrors;
		public Integer CurrentPage;
	}
	public class DeleteSchemeNodesResponse{
		public DeleteSchemeNodesResult DeleteSchemeNodesResult;
	}*/
}