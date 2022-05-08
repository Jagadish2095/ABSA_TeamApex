/**
* Apex Integration Request Bean class for CMS Banker Info service
* @author  Diksha Wasekar : Absa
* @Created Date:  2019-09-07
* 
*
**/


public class CMSGetBankerInfo_Req_IB_V1 extends Base_IB

{

   public string channel;
   public string application;
   public string trace;
   public string msgLanguage;
   public string msgTarget;
   public string clientCode;
    
    
    public CMSGetBankerInfo_Req_IB_V1 creatDummyRequest(){
        
        
        CMSGetBankerInfo_Req_IB_V1 reqBean= new CMSGetBankerInfo_Req_IB_V1();
        
        reqBean.application='BDP';
        reqBean.channel='BDP';
        reqBean.msgLanguage='E';
        reqBean.msgTarget='STD';
        reqBean.trace='Y';
        reqBean.clientCode='DFARIML001';
        
        return reqBean;
        
        
        
        
    }
    
    
    

}