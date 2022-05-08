public class ROTAddCustomer_Req_IB_v1 extends Base_IB {
public AddCustomer AddCustomer;
	public class customer{
        public String Description;
        public String EffectiveEndDate;
        public String EffectiveStartDate;
        public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String IsEffectiveEndDateInfinity;
		public String CustomerKey;
	}
	public class AddCustomer{
		public customer customer;
		public String user;
	}
    public static ROTAddCustomer_Req_IB_v1 createDummyRequest(){
        ROTAddCustomer_Req_IB_v1 requestBean = new ROTAddCustomer_Req_IB_v1(); 
        requestBean.AddCustomer = new ROTAddCustomer_Req_IB_v1.AddCustomer();
        requestBean.AddCustomer.customer = new ROTAddCustomer_Req_IB_v1.customer();
        requestBean.AddCustomer.customer.Description = 'JB Pillar';
        requestBean.AddCustomer.customer.EffectiveEndDate = '2024-02-06T00:00:00';
        requestBean.AddCustomer.customer.EffectiveStartDate = '2024-01-21T00:00:00';
        requestBean.AddCustomer.customer.GroupRestrictionClusterID = 'ABS';
        requestBean.AddCustomer.customer.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.AddCustomer.customer.IsEffectiveEndDateInfinity = 'true';
        requestBean.AddCustomer.customer.CustomerKey = 'CTMETRO001';
        requestBean.AddCustomer.user = '?';
        return requestBean;
    }
}