/*
* Integration Utility Bean for create and link account
* @author Almas Aleem:Absa  
* @created 2020-12-07
*/
public class ABFCreateAndLinkAccount_IU_v1 {
    public static ABFCreateAndLinkAccount_Req_IB_v1 mapRequestFields(User user,String clientCode){
        
       ABFCreateAndLinkAccount_Req_IB_v1 requestBean = new ABFCreateAndLinkAccount_Req_IB_v1();
    requestBean.nbsapdpi = new ABFCreateAndLinkAccount_Req_IB_v1.Nbsapdpi();
    requestBean.nbsapdpi.application='DP';
    requestBean.nbsapdpi.channel ='DP';
    requestBean.nbsapdpi.trace ='N';
    
    requestBean.nbsmsgi = new ABFCreateAndLinkAccount_Req_IB_v1.Nbsmsgi();
    requestBean.nbsmsgi.msgLanguage ='E';
    requestBean.nbsmsgi.msgTarget='STD';
    requestBean.nbsmsgi.finalMsgId = new ABFCreateAndLinkAccount_Req_IB_v1.FinalMsgId();
    requestBean.nbsmsgi.finalMsgId.finalMsgClass ='';
    requestBean.nbsmsgi.finalMsgId.finalMsgCode='';
    
    requestBean.plpa00i = new ABFCreateAndLinkAccount_Req_IB_v1.Plpa00i();
    requestBean.plpa00i.clientCode = clientCode;
    requestBean.plpa00i.corpCode = 'ABS';
    requestBean.plpa00i.productCode = '5016'; //is product code fixed?
    requestBean.plpa00i.applicationNbr = '0';
    requestBean.plpa00i.branchCode = user.SiteCode__c==null ? '6522': user.SiteCode__c;
    requestBean.plpa00i.siteTypeAgency = user.SiteType__c ==null? '034':user.SiteType__c;
    requestBean.plpa00i.agencyCode = user.SiteType__c ==null? '08198':user.SiteType__c;
    requestBean.plpa00i.tellerCode = '001560';
    requestBean.plpa00i.workstationNbr = '0';
    requestBean.plpa00i.supervisorCode = user.Supervisor__c ==null ?'001560' :user.Supervisor__c;
    requestBean.plpa00i.marketersCode = '0';
    requestBean.plpa00i.branchSiteType = user.SiteType__c ==null? '034':user.SiteType__c;
    requestBean.plpa00i.sourceOfFunds1 = '0';
    requestBean.plpa00i.sourceOfFunds2 = '';
    requestBean.plpa00i.sourceOfFunds3 = '';
    requestBean.plpa00i.sourceOfFunds4 = '';
    requestBean.plpa00i.sourceOfFunds5 = '';
    requestBean.plpa00i.eddRiskHoldInd = '';
    requestBean.plpa00i.accOrigChannel = '';                             

	return requestBean;                                                        
   }                                                 
}