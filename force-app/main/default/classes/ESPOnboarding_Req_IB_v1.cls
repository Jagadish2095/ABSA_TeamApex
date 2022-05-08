/**
* Apex Integration Request Bean class for ESP Onboarding service
* @author  Manoj Danthala : Absa
* @since   2019-02-27
*
**/
public class ESPOnboarding_Req_IB_v1{
    
    public String Requester;
	public Integer FunctionType;
	public String RequesterReference;
	public String Payload;
	
	public class Payload{
        public String Firstname;
        public String LastName;
        public String BankerABNumber;
        public String IdRegNumber;
        public String EntityType;
        public String ContactNumber;
        public Products[] Products;
    }
    
    public class Products{
        public String Group_x;
        public String Product;
    }

}