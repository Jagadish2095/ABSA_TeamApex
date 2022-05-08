/* 
* Integration Handler for ABF Get Account Status Info
* @author Ketelo Makalela
* Created 2020/11/25
*/
public class ABFgetAccountStatusInfoV1_Req_IB_V1 extends Base_IB{
    
    //public  ABFgetAccountStatusInfoV1 ABFgetAccountStatusInfoV1;
    
   // public class ABFgetAccountStatusInfoV1{
        public String channel;
        public String application;
        public String trace;
        public String msgLanguage;
        public String msgTarget;
        public String corpCode;
        public String accountNbr;
   // }
    public static ABFgetAccountStatusInfoV1_Req_IB_V1 createDummyRequest() {
        
        ABFgetAccountStatusInfoV1_Req_IB_V1 requestBean = new ABFgetAccountStatusInfoV1_Req_IB_V1();
        
       // ABFgetAccountStatusInfoV1_Req_IB_V1.ABFgetAccountStatusInfoV1 ABFgetAccountStatusInfoV1  = new ABFgetAccountStatusInfoV1_Req_IB_V1.ABFgetAccountStatusInfoV1();
         ABFgetAccountStatusInfoV1_Req_IB_V1 ABFgetAccountStatusInfoV1  = new ABFgetAccountStatusInfoV1_Req_IB_V1();
        ABFgetAccountStatusInfoV1.channel = 'Salesforce';
        ABFgetAccountStatusInfoV1.application = 'Salesforce';
        ABFgetAccountStatusInfoV1.trace = 'Y';
        ABFgetAccountStatusInfoV1.msgLanguage = 'E';
        ABFgetAccountStatusInfoV1.msgTarget = 'STD';
        ABFgetAccountStatusInfoV1.corpCode = 'ABS';
        ABFgetAccountStatusInfoV1.accountNbr = '3001537580';
        
        //requestBean.ABFgetAccountStatusInfoV1 = ABFgetAccountStatusInfoV1;
        requestBean = ABFgetAccountStatusInfoV1;
        return requestBean; 
    }   
}