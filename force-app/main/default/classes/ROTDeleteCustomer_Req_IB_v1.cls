public class ROTDeleteCustomer_Req_IB_v1 extends Base_IB {
public DeleteCustomer DeleteCustomer;
	public class DeleteCustomer{
		public String user;
		public customer customer;
	}
	public class customer{
		public String CustomerKey;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String EffectiveStartDate;
	}
    public static ROTDeleteCustomer_Req_IB_v1 createDummyRequest(){
        ROTDeleteCustomer_Req_IB_v1 requestBean = new ROTDeleteCustomer_Req_IB_v1(); 
        requestBean.DeleteCustomer = new ROTDeleteCustomer_Req_IB_v1.DeleteCustomer();
       
        requestBean.DeleteCustomer.customer = new ROTDeleteCustomer_Req_IB_v1.customer();
        requestBean.DeleteCustomer.customer.EffectiveStartDate = '2021-01-07T00:00:00';
        requestBean.DeleteCustomer.customer.GroupRestrictionClusterID = 'ABS';
        requestBean.DeleteCustomer.customer.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.DeleteCustomer.customer.CustomerKey = 'CTMETRO001';
         requestBean.DeleteCustomer.user = '?';
        return requestBean;
    }
}