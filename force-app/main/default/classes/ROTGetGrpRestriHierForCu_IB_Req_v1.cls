public class ROTGetGrpRestriHierForCu_IB_Req_v1 extends Base_IB {
    
	public GetGroupRestrictionHierarchiesForCustomer GetGroupRestrictionHierarchiesForCustomer;

	public class GetGroupRestrictionHierarchiesForCustomer {
		public String customerKey;
		public String forestType;
		public String user;
	}
    
    public static ROTGetGrpRestriHierForCu_IB_Req_v1 createDummyRequest(){
        ROTGetGrpRestriHierForCu_IB_Req_v1 requestBean = new ROTGetGrpRestriHierForCu_IB_Req_v1();
        requestBean.GetGroupRestrictionHierarchiesForCustomer = new ROTGetGrpRestriHierForCu_IB_Req_v1.GetGroupRestrictionHierarchiesForCustomer();
        requestBean.GetGroupRestrictionHierarchiesForCustomer.customerKey = 'CTMETRO001';
        requestBean.GetGroupRestrictionHierarchiesForCustomer.forestType = 'Staging';
        requestBean.GetGroupRestrictionHierarchiesForCustomer.user = 'SALESFORCE';
        return requestBean;
        
    }
    
    
}