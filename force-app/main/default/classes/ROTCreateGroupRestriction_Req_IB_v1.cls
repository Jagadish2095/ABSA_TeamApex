public class ROTCreateGroupRestriction_Req_IB_v1 extends Base_IB  {
	public class GroupRestriction {
		public String ClusterID;
		public String Description;
		public String ObjectID;
	}

	public CreateGroupRestriction CreateGroupRestriction;

	public class CreateGroupRestriction {
		public GroupRestriction groupRestriction;
		public String user;
	}
    
    public static ROTCreateGroupRestriction_Req_IB_v1 createDummyRequest(){
        ROTCreateGroupRestriction_Req_IB_v1 requestBean = new ROTCreateGroupRestriction_Req_IB_v1();
        requestBean.CreateGroupRestriction = new ROTCreateGroupRestriction_Req_IB_v1.CreateGroupRestriction();
        requestBean.CreateGroupRestriction.groupRestriction = new ROTCreateGroupRestriction_Req_IB_v1.GroupRestriction(); 
        requestBean.CreateGroupRestriction.groupRestriction.ClusterID = 'ABS';
        requestBean.CreateGroupRestriction.groupRestriction.Description = 'JB Pillar';
        requestBean.CreateGroupRestriction.groupRestriction.ObjectID = 'CQGR0009-ABS';
        requestBean.CreateGroupRestriction.user = '';
        return requestBean;
    }
}