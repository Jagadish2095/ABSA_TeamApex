public class ROTDateAdjustSchemeNodes_Req_IB_v1 extends Base_IB {
    public DateAdjustSchemeNodes DateAdjustSchemeNodes;
    public class nodes{
        public List<DateAdjustmentNodeModel> DateAdjustmentNodeModel;
    }
    public class DateAdjustSchemeNodes{
        public String user;
        public nodes nodes;
    }
    public class DateAdjustmentNodeModel{
        public String NewEffectiveStartDate;
        public String GroupRestrictionObjectID;
        public String IsEffectiveEndDateInfinity;
        public String GroupRestrictionClusterID;
        public String NewEffectiveEndDate;
        public String EntityType;
        public String ObjectID;
        public String EffectiveStartDate;
    }
    
    public static ROTDateAdjustSchemeNodes_Req_IB_v1 createDummyRequest(){
        ROTDateAdjustSchemeNodes_Req_IB_v1 requestBean = new ROTDateAdjustSchemeNodes_Req_IB_v1(); 
        requestBean.DateAdjustSchemeNodes= new ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustSchemeNodes();
        requestBean.DateAdjustSchemeNodes.nodes = new ROTDateAdjustSchemeNodes_Req_IB_v1.nodes();
        requestBean.DateAdjustSchemeNodes.user = 'ABCDD';
        requestBean.DateAdjustSchemeNodes.nodes.DateAdjustmentNodeModel = new List<ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel>();
        ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel request  = new ROTDateAdjustSchemeNodes_Req_IB_v1.DateAdjustmentNodeModel();
        request.NewEffectiveStartDate  = '2021-03-06T00:00:00';
        request.GroupRestrictionObjectID  = 'CQGR0002-JUAT';
        request.IsEffectiveEndDateInfinity  = 'true';
        request.GroupRestrictionClusterID  = 'ABS';
        request.NewEffectiveEndDate  = '2021-02-06T00:00:00';
        request.EntityType  = 'ExcludedAccount';
        request.ObjectID  = 'CASH DEPOSITS';
        request.EffectiveStartDate  = '2021-02-10T00:00:00';
        requestBean.DateAdjustSchemeNodes.nodes.DateAdjustmentNodeModel.add(request);
        return requestBean;
    }    
}