/**
* Descripton: Wrapper class for ExpireSchemeNodes Service Request.
* Class Name: ROTExpireSchemeNodes_Req_IB_v1
* @author  	: Manish
* @since   	: 2021-1-19
**/
public class ROTExpireSchemeNodes_Req_IB_v1 extends Base_IB{

    public ExpireSchemeNodes ExpireSchemeNodes;
	
	public class ExpireSchemeNodes{
		public String user;
		public nodes nodes;
	}
    public class nodes{
		public list<ExpireNodeModel> ExpireNodeModel;
	}
	public class ExpireNodeModel{
		public String ObjectID;
		public String ExpiryDate;
		public String GroupRestrictionClusterID;
		public String EntityType;
		public String GroupRestrictionObjectID;
		public String EffectiveStartDate;
	}
    
    public static ROTExpireSchemeNodes_Req_IB_v1 createDummyRequest(){
        ROTExpireSchemeNodes_Req_IB_v1 requestBean = new ROTExpireSchemeNodes_Req_IB_v1();
        requestBean.ExpireSchemeNodes = new ROTExpireSchemeNodes_Req_IB_v1.ExpireSchemeNodes();
        requestBean.ExpireSchemeNodes.user = '?';
        requestBean.ExpireSchemeNodes.nodes = new ROTExpireSchemeNodes_Req_IB_v1.nodes();
        requestBean.ExpireSchemeNodes.nodes.ExpireNodeModel = new List<ROTExpireSchemeNodes_Req_IB_v1.ExpireNodeModel>();
        ExpireNodeModel req = new ExpireNodeModel();
        req.EffectiveStartDate = '2019-06-26T00:00:00';
        req.EntityType = 'Account';
        req.ExpiryDate = '2021-03-06T00:00:00';
        req.GroupRestrictionClusterID = 'ABS';
        req.GroupRestrictionObjectID ='CQGR0002-JUAT';
        req.ObjectID = '4047081344';
        requestBean.ExpireSchemeNodes.nodes.ExpireNodeModel.add(req);
        return requestBean;
    }
}