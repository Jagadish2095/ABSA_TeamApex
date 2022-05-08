/**
* Descripton: Wrapper class for DeleteSchemeNodes Service Request.
* Class Name: ROTDeleteSchemeNodes_Req_IB_v1
* @author  	: Srinivas
* Further modified by Manish as per latest request on 25-01-2021
**/
public class ROTDeleteSchemeNodes_Req_IB_v1 extends Base_IB {
    public DeleteSchemeNodes DeleteSchemeNodes;
    public class nodes{
        //public DeleteSchemeNodeModel DeleteSchemeNodeModel;
        public List<DeleteSchemeNodeModel> DeleteSchemeNodeModel; // updated by Manish 
    }
    public class DeleteSchemeNodes{
        public String user;
        public nodes nodes;
    }
    public class DeleteSchemeNodeModel{
        public String ObjectID;
        public String GroupRestrictionObjectID;
        public String GroupRestrictionClusterID;
        public String EntityType;
        public String EffectiveStartDate;
    }
    
    public static ROTDeleteSchemeNodes_Req_IB_v1 createDummyRequest(){
        ROTDeleteSchemeNodes_Req_IB_v1 requestBean = new ROTDeleteSchemeNodes_Req_IB_v1(); 
        requestBean.DeleteSchemeNodes = new ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodes();
         
        requestBean.DeleteSchemeNodes.nodes = new ROTDeleteSchemeNodes_Req_IB_v1.nodes();
        requestBean.DeleteSchemeNodes.nodes.DeleteSchemeNodeModel = new List<ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel>();
        
        ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel request = new ROTDeleteSchemeNodes_Req_IB_v1.DeleteSchemeNodeModel();
        request.ObjectID = 'ABS';
        request.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        request.GroupRestrictionClusterID = 'ABS';
        request.EntityType = 'ExcludedAccount';
        request.EffectiveStartDate = '2021-01-20T00:00:00';
        requestBean.DeleteSchemeNodes.nodes.DeleteSchemeNodeModel.add(request);
        
        requestBean.DeleteSchemeNodes.user ='?';
        return requestBean;
    }
}