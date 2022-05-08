/*
* Response  implemention for Create  Service for package linking
* @author Satya Boyenepalli
* @created 2021-03-02
*/
public class Create_Resp_IB_v1 extends Base_IB {
    public String status;
    public String message;
    public List<Errors> errors;
    public Content content;    
    
    public class Errors {
        public String type;
        public String sourceSystem;
        public String reason;
    }
    public class Content {
        public String packageId;
        public String chequeAccountNumber;
        public String creditAccountNumber;
        public String packageType;
        public String pricingSchemeCode;
    }
    
    public static Create_Resp_IB_v1 dummyResponse(){
    Create_Resp_IB_v1 responsebean = new  Create_Resp_IB_v1();
     responsebean.Errors  = new   List<Errors>();
     
     responsebean.Content = new Create_Resp_IB_v1.Content();
    responsebean.Content.packageId='210319115000373522';
    responsebean.Content.chequeAccountNumber='4048374003';
    responsebean.Content.creditAccountNumber='04550270024348018';
    responsebean.Content.packageType='GOLD';
    responsebean.Content.pricingSchemeCode='CQT01S03';
    return responsebean;
        
    }
    
    
}