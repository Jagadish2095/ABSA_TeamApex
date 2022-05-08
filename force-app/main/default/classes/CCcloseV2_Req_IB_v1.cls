/*
* Request Integration Bean for CCcloseV2 Service
* @author Lulu Rankwe
* @created 19-03-2020
*/
public class CCcloseV2_Req_IB_v1 {
    
    public String channel{get;set;}
    public String application{get;set;}
    public String trace{get;set;}
    public String msgLanguage{get;set;}
    public String msgTarget{get;set;}  
    public String workStation{get;set;}
    public String tellerCode{get;set;}
    public String supervisor{get;set;}  
    public String branchCode{get;set;}  
    public String combiNbr{get;set;}  
    public String reason{get;set;}  
    public String subReason{get;set;}
    
    
    public CCcloseV2_Req_IB_v1 createDummy(){
        CCcloseV2_Req_IB_v1 reqBean = new CCcloseV2_Req_IB_v1();
        
        reqBean.channel = 'BDP';
        reqBean.application = 'BDP';
        reqBean.trace = 'Y';
        reqBean.msgLanguage = '';
        reqBean.msgTarget = '';     
        reqBean.workStation = '';
        reqBean.tellerCode = '';
        reqBean.supervisor ='';
        reqBean.branchCode = '';
        reqBean.combiNbr = '';
        reqBean.reason = '';
        reqBean.subReason = '';
        
        
        
        return reqBean;
    }

}