public class Prediction_Req_IB_v1 extends Base_IB{
    public String caseId;
    public String caseNo;
    public String status;
    public String serviceTypeId;
    public String suppliedEmail;
    public String subject;
    public String description;
    public String serviceGroup;
    
    public static Prediction_Req_IB_v1 createDummyRequest(){
        Prediction_Req_IB_v1 requestBean = new Prediction_Req_IB_v1();
        requestBean.caseId = '36765432';
        requestBean.caseNo = '';
        requestBean.status = 'New';
        requestBean.serviceTypeId = '';
        requestBean.suppliedEmail = 'User@notabsa.com';  
        requestBean.subject = 'Test';
        requestBean.description = 'Test';
        requestBean.serviceGroup = 'AP Queries';
        return requestBean;
    }
}