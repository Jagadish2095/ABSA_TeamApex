/**
* Apex Integration Request Bean class for XDSGetQuestions Service
* @author  Madhava Palla : Absa
* @since   2019-08-20
*
**/
public class XDSGetQuetions_Req_IB_v1 {
    public string idNumber;
    public string surname;
    
     public XDSGetQuetions_Req_IB_v1 creatDummyRequest(){
        
        
        XDSGetQuetions_Req_IB_v1 reqBean= new XDSGetQuetions_Req_IB_v1();
        
        reqBean.idNumber='7108095432088';
        reqBean.surname='Sizwe';
        
        return reqBean;
        
    }
    
}