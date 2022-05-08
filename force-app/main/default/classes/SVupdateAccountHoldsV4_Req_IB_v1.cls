public class SVupdateAccountHoldsV4_Req_IB_v1 extends Base_IB{
    
    public SVupdateAccountHoldsV4 SVupdateAccountHoldsV4{get;set;}
    
    public class SVupdateAccountHoldsV4 {
        public nbsapdpi nbsapdpi{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public svsp42i svsp42i{get;set;} 
    }
    public class nbsapdpi{
        public String channel;
        public String application;
        public String trace;
    }
    
    public class nbsmsgi{
        public String msgTarget{get;set;}
        public String msgLanguage{get;set;}
     
    }
    
    public class svsp42i{
        public String accountNbr;
        public String savingsDepositType;
        public String chargeInd;
        public String frozenInd;
        public String stoppedInd;
        public String dormantInd;
        public String semiDormantInd;
        public String exclEstateInd;
        public String exclInslvntInd;
        public String courtOrderInd;
        public String signingAuthInd;
        public String monitorActivityInd;
        public String badDebtInd;
        public String potBadDebtInd;
        public String legalActionInd;
        public String nonResidentInd;
        public String lostBookInd;
        public String blockedInd;
        public String offlineEnqInd;
        public String offlEnqFrDt;
        public String securityMessageInd;
        public String securityNumber;
        public String exceedMaxBalInd;
        public String restricHoldInd;
        public String wtiCountry;
        public String rbaEddHold;
        public String divisionCode;
        public String workStation;
        public String branchCode;
        public String agencyCode;
        public String agencySiteType;
        public String tellerCode;
        public String supervisorCode;
        public String branchSiteType;
        
    }
    
 public SVupdateAccountHoldsV4_Req_IB_v1 createDummy(){
        SVupdateAccountHoldsV4_Req_IB_v1 requestBean = new SVupdateAccountHoldsV4_Req_IB_v1();
        SVupdateAccountHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new SVupdateAccountHoldsV4_Req_IB_v1.nbsapdpi ();
        SVupdateAccountHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiRequest = new SVupdateAccountHoldsV4_Req_IB_v1.nbsmsgi ();
        SVupdateAccountHoldsV4_Req_IB_v1.svsp42i svsp42iRequest = new SVupdateAccountHoldsV4_Req_IB_v1.svsp42i ();
        
        
        
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';
     
        svsp42iRequest.accountNbr = '9050986380';
        svsp42iRequest.savingsDepositType = 'S';
        svsp42iRequest.chargeInd = 'N';
        svsp42iRequest.frozenInd = 'N';
        svsp42iRequest.stoppedInd = 'N';
        svsp42iRequest.dormantInd = 'N';
        svsp42iRequest.semiDormantInd = 'N';
        svsp42iRequest.exclEstateInd = 'N';
        svsp42iRequest.exclInslvntInd = 'N';
        svsp42iRequest.courtOrderInd = 'N';
        svsp42iRequest.signingAuthInd = 'N';
        svsp42iRequest.monitorActivityInd = 'N';
        svsp42iRequest.badDebtInd = 'N';
        svsp42iRequest.potBadDebtInd = 'N';
        svsp42iRequest.legalActionInd = 'N';
        svsp42iRequest.nonResidentInd = 'N';
        svsp42iRequest.lostBookInd = 'N';
        svsp42iRequest.blockedInd = 'N';
        svsp42iRequest.offlineEnqInd = 'N';
        svsp42iRequest.offlEnqFrDt = '0';
        svsp42iRequest.securityMessageInd = 'N';
        svsp42iRequest.securityNumber = '0';
        svsp42iRequest.exceedMaxBalInd = 'N';
        svsp42iRequest.restricHoldInd = 'N';
        svsp42iRequest.wtiCountry = 'N';
        svsp42iRequest.rbaEddHold = 'N';
        svsp42iRequest.divisionCode = 'B';
        svsp42iRequest.workStation = '99';
        svsp42iRequest.branchCode = '8089';
        svsp42iRequest.agencyCode = '034';
        svsp42iRequest.agencySiteType = '034';
        svsp42iRequest.tellerCode = '25698';
        svsp42iRequest.supervisorCode = '25699';
        svsp42iRequest.branchSiteType = '034';

     
     return requestBean;
   
 
    }

}