public class ROTUpdateGroupRestriction_IB_Req_v1 extends Base_IB  {
    
	public class GroupRestriction {
		public String ClusterID;
		public String Description;
		public String ObjectID;
	}

	public class UpdateGroupRestriction {
		public GroupRestriction groupRestriction;
		public String user;
	}

	public UpdateGroupRestriction UpdateGroupRestriction;
    
    public static ROTUpdateGroupRestriction_IB_Req_v1 createDummyRequest(){
        ROTUpdateGroupRestriction_IB_Req_v1 response = new ROTUpdateGroupRestriction_IB_Req_v1();
		response.UpdateGroupRestriction = new ROTUpdateGroupRestriction_IB_Req_v1.UpdateGroupRestriction();
        response.UpdateGroupRestriction.groupRestriction = new ROTUpdateGroupRestriction_IB_Req_v1.GroupRestriction();
        response.UpdateGroupRestriction.groupRestriction.ClusterID = 'ABS';
        response.UpdateGroupRestriction.groupRestriction.Description = 'JB Pillar';
        response.UpdateGroupRestriction.groupRestriction.ObjectID = 'CQGR0001-ABS';
        response.UpdateGroupRestriction.user = '?';
        return response;
    }
}