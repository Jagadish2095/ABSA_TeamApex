/**
* Descripton: Wrapper class for UpdateCustomer Service Request.
* Class Name: ROTUpdateCustomer_Req_IB_v1
* @author  	: Manish
**/
public class ROTUpdateCustomer_Req_IB_v1 extends Base_IB{

    public UpdateCustomer UpdateCustomer;
	
    public class UpdateCustomer{
		public String user;
		public Customer customer;
	}
	public class Customer{
		public String IsEffectiveEndDateInfinity;
		public String GroupRestrictionClusterID;
		public String GroupRestrictionObjectID;
		public String EffectiveStartDate;
		public String CustomerKey;
		public String EffectiveEndDate;
		public String OriginalEffectiveStartDate;
		public String Description;
	}
    
    public static ROTUpdateCustomer_Req_IB_v1 createDummyRequest(){
        ROTUpdateCustomer_Req_IB_v1 requestBean = new ROTUpdateCustomer_Req_IB_v1();
        requestBean.UpdateCustomer =  new ROTUpdateCustomer_Req_IB_v1.UpdateCustomer();
        requestBean.UpdateCustomer.customer = new ROTUpdateCustomer_Req_IB_v1.Customer();
        requestBean.UpdateCustomer.customer.Description = 'JB Pillar';
        requestBean.UpdateCustomer.customer.EffectiveEndDate = '2021-02-06T00:00:00';
        requestBean.UpdateCustomer.customer.EffectiveStartDate = '2021-01-07T00:00:00';
        requestBean.UpdateCustomer.customer.GroupRestrictionClusterID = 'ABS';
        requestBean.UpdateCustomer.customer.GroupRestrictionObjectID = 'CQGR0002-JUAT';
        requestBean.UpdateCustomer.customer.IsEffectiveEndDateInfinity = 'true';
        requestBean.UpdateCustomer.customer.CustomerKey = 'CTMETRO001';
        requestBean.UpdateCustomer.customer.OriginalEffectiveStartDate = '2021-01-07T00:00:00';
        requestBean.UpdateCustomer.user = '?';
        return requestBean;  
    }
}