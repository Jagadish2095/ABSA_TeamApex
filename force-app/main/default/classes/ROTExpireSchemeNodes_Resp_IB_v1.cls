/**
* Descripton: Wrapper class for ExpireSchemeNodes Service Response.
* Class Name: ROTExpireSchemeNodes_Resp_IB_v1
* @author  	: Manish
* @since   	: 2021-1-19
**/
public class ROTExpireSchemeNodes_Resp_IB_v1 extends Base_IB{
    public ROTExpireSchemeNodes_Resp_IB_v1(){}
    public ExpireSchemeNodesResponse ExpireSchemeNodesResponse;
    public class ExpireSchemeNodesResponse{
		public ExpireSchemeNodesResult ExpireSchemeNodesResult;
	}
    public class ExpireSchemeNodesResult{
		public String PageToken;
		public String CurrentPage;
		public String Tag;
		public String IsCurrentPageTheLast;
		public String SystemErrorMessage;
		public Records Records;
		public String HasValidationErrors;
		public String TotalRecords;
		public String HasSystemError;
		public String HasErrors;
	}
    public class Records{
		public list<SchemeNodeOperationResult> SchemeNodeOperationResult;
	}
    public class SchemeNodeOperationResult{
		public String ErrorMessage;
		public String EntityType;
		public String GroupRestrictionClusterID;
		public String EffectiveStartDate;
		public String GroupRestrictionObjectID;
		public String Abandoned;
		public String ObjectID;
		public String Success;
		public String SchemeNodeID;
	}		
}