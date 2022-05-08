public class ROTDeleteGroupRestriction_IB_Req_v1 extends Base_IB{
    
    public DeleteGroupRestriction DeleteGroupRestriction;
    public class groupRestriction{
        public String ObjectID;
        public String ClusterID;
    }
    
    public class DeleteGroupRestriction{
        public String user;
        public groupRestriction groupRestriction;
        
    }
    
    public static ROTDeleteGroupRestriction_IB_Req_v1 createDummyRequest(){
        ROTDeleteGroupRestriction_IB_Req_v1 requestBean = new ROTDeleteGroupRestriction_IB_Req_v1(); 
        requestBean.DeleteGroupRestriction = new ROTDeleteGroupRestriction_IB_Req_v1.DeleteGroupRestriction();
        requestBean.DeleteGroupRestriction.groupRestriction = new ROTDeleteGroupRestriction_IB_Req_v1.groupRestriction();
        requestBean.DeleteGroupRestriction.groupRestriction.ObjectID='CQGR0002-JUAT';
        requestBean.DeleteGroupRestriction.groupRestriction.ClusterID='ABS';
        requestBean.DeleteGroupRestriction.user = 'NNBBHH';
        return requestBean;
    }
    
}