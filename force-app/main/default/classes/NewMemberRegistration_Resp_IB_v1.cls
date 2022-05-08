/*
* Response Integration Bean for NewMemberRegistration Service
* @author Khaliq Abdul
* @created 2020-11-02
*/
public class NewMemberRegistration_Resp_IB_v1 extends Base_IB {
    
    //@AuraEnabled
    public String status;
    public Integer statusCode;
    public String message;
    public NewMemberRegistrationResponse NewMemberRegistrationResponse;
    public NewMemberRegistrationResult NewMemberRegistrationResult;
    
    public class NewMemberRegistrationResponse{
        public NewMemberRegistrationResult NewMemberRegistrationResult;
        
    }
    
    public class NewMemberRegistrationResult{
        public String MembershipNumber;
        public MethodResponse MethodResponse;            
    }
    
    public class MethodResponse {
        public String ErrorCode;
        public String ErrorReferenceNumber;
        public String ErrorMessage;
        public String DetailedError;
    }
    
    public static NewMemberRegistration_Resp_IB_v1 dummyResponse(){
        NewMemberRegistration_Resp_IB_v1 responseBean = new NewMemberRegistration_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        NewMemberRegistration_Resp_IB_v1.MethodResponse methodResponse = new NewMemberRegistration_Resp_IB_v1.MethodResponse();
        methodResponse.ErrorCode= 'E0007';
        methodResponse.ErrorReferenceNumber  = 'd247c253-ca74-4f5a-a340-3c2b35ced1cb';
        methodResponse.ErrorMessage  = 'E000703_Existing active membership found for client key ABBSC  001 and/or identity 4701165169185';
        methodResponse.DetailedError  = 'E000703_Existing active membership found for client key ABBSC  001 and/or identity 4701165169185 \n\terror ref=d247c253-ca74-4f5a-a340-3c2b35ced1cb';
        
        NewMemberRegistration_Resp_IB_v1.NewMemberRegistrationResponse NewMemberRegistrationResponsebean = new NewMemberRegistration_Resp_IB_v1.NewMemberRegistrationResponse();
        NewMemberRegistration_Resp_IB_v1.NewMemberRegistrationResult NewMemberRegistrationResultbean=new NewMemberRegistration_Resp_IB_v1.NewMemberRegistrationResult(); 
        NewMemberRegistrationResultbean.MembershipNumber='';
        NewMemberRegistrationResultbean.MethodResponse = methodResponse;
        NewMemberRegistrationResponsebean.NewMemberRegistrationResult=NewMemberRegistrationResultbean;
        responseBean.NewMemberRegistrationResponse = NewMemberRegistrationResponsebean;
        
        return responseBean;
    }
}