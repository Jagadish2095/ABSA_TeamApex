/* 
* Integration Handler for ABF Update Agreement Details Info
* @author Gulafsha
* Created 2020/12/01
*/
public class ABFupdAgreementDetailsV2_Req_IB_V1 extends Base_IB{
    
    
    
    public nbsapdpi nbsapdpi;
    public nbsmsgi nbsmsgi;
    public plpa05i plpa05i;
    
    public class nbsapdpi{
        public string channel;
        public string application;
        public string trace;
    }
    public class nbsmsgi{
        public string msgLanguage;
        public string msgTarget;
        public finalMsgId finalMsgId;
    }
    public class finalMsgId{
        public String finalMsgClass;
        public String finalMsgCode;
    }
    /*public class finalMsgClass{

}
public class finalMsgCode{

}*/
    public class plpa05i{
        public string corpCode;
        public string branchCode;
        public string accountNbr;
        public string contractEffectiveDate;
        public string marketSector;
        public string electronicTransferReq;
        public string employerCode;
        public string securityReqInd;
        public string permitWithdrawalInd;
        public String cpfMarketerCode;
        public string welcomePrintLetter;
        public string agencyCode;
        public string tellerCode;
        public string supervisorCode;
        public string branchSiteType;
        public string siteTypeAgency;
        public string creditLife;
        public String schemeType;
        public string schemeCode;
        public string autoCapiAdvAmt;
    }
     public static ABFupdAgreementDetailsV2_Req_IB_V1 createDummyRequest() {
        
        ABFupdAgreementDetailsV2_Req_IB_V1 requestBean = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2_Req_IB_V1 ABFupdAgreementDetailsV2  = new ABFupdAgreementDetailsV2_Req_IB_V1();
        ABFupdAgreementDetailsV2.nbsapdpi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsapdpi();
        ABFupdAgreementDetailsV2.nbsmsgi = new ABFupdAgreementDetailsV2_Req_IB_V1.nbsmsgi();
        ABFupdAgreementDetailsV2.plpa05i = new ABFupdAgreementDetailsV2_Req_IB_V1.plpa05i();
        ABFupdAgreementDetailsV2.nbsapdpi.channel = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.application = 'Salesforce';
        ABFupdAgreementDetailsV2.nbsapdpi.trace = 'Y';
         
        ABFupdAgreementDetailsV2.nbsmsgi.msgLanguage = 'E';
        ABFupdAgreementDetailsV2.nbsmsgi.msgTarget = 'STD';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId = new ABFupdAgreementDetailsV2_Req_IB_V1.finalMsgId(); 
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgClass = '';
        ABFupdAgreementDetailsV2.nbsmsgi.finalMsgId.finalMsgCode = '';
       
      
      
        ABFupdAgreementDetailsV2.plpa05i.corpCode = 'ABS';
        ABFupdAgreementDetailsV2.plpa05i.branchCode = '1334';
    	ABFupdAgreementDetailsV2.plpa05i.accountNbr = '3001534477';
    	ABFupdAgreementDetailsV2.plpa05i.contractEffectiveDate = '20201209';
    	ABFupdAgreementDetailsV2.plpa05i.marketSector = '000';
    	ABFupdAgreementDetailsV2.plpa05i.electronicTransferReq = 'Y';
        ABFupdAgreementDetailsV2.plpa05i.employerCode = '5037348';
    	ABFupdAgreementDetailsV2.plpa05i.securityReqInd = 'N';
    	ABFupdAgreementDetailsV2.plpa05i.permitWithdrawalInd = 'Y';
    	ABFupdAgreementDetailsV2.plpa05i.cpfMarketerCode = '';
    	ABFupdAgreementDetailsV2.plpa05i.welcomePrintLetter = 'Y';
        ABFupdAgreementDetailsV2.plpa05i.agencyCode = '034';
    	ABFupdAgreementDetailsV2.plpa05i.tellerCode = '12345';
    	ABFupdAgreementDetailsV2.plpa05i.supervisorCode = '12345';
    	ABFupdAgreementDetailsV2.plpa05i.branchSiteType = '034';
    	ABFupdAgreementDetailsV2.plpa05i.siteTypeAgency = '034';
        ABFupdAgreementDetailsV2.plpa05i.creditLife = '0';// 0
    	ABFupdAgreementDetailsV2.plpa05i.schemeType = '';//''
    	ABFupdAgreementDetailsV2.plpa05i.schemeCode = '0';//0
    	ABFupdAgreementDetailsV2.plpa05i.autoCapiAdvAmt = 'N';//N
       
        requestBean = ABFupdAgreementDetailsV2;
        
        return requestBean;
        
    }
}