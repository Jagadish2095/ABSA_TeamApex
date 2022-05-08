/* 
* Integration Handler for ABF Get Account Status Info
* @author Ketelo Makalela
* Created 2020/11/25
*/
public class ABFgetAccountStatusInfoV1_Resp_IB_V1 extends Base_IB{
  //  public ABFgetAccountStatusInfoV1Response ABFgetAccountStatusInfoV1Response;
  //  public class ABFgetAccountStatusInfoV1Response{
        @AuraEnabled public nbsapdpo nbsapdpo;
        @AuraEnabled public nbsmsgo nbsmsgo;
        @AuraEnabled public plpa18o plpa18o;
  //  }
    
    public class nbsapdpo{
        @AuraEnabled public String Version;
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String serviceVersion;
        @AuraEnabled public String echoKey;
        
    }
    
    public class nbsmsgo{
        @AuraEnabled public String version;
        @AuraEnabled public String sysErrTxt;
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String nbrUserErrs;
        @AuraEnabled public String msgEntry;
        
    }
    
    public class plpa18o{
        @AuraEnabled public String applicationNbr;
        @AuraEnabled public String clientNameLine1;
        @AuraEnabled public String clientNameLine2;
        @AuraEnabled public String clientAddress;
        @AuraEnabled public String originalLoanAmount;
        @AuraEnabled public String contractTerm;
        @AuraEnabled public String repaymentFrequency;
        @AuraEnabled public String firstRepaymentAmt;
        @AuraEnabled public String lastRepaymentAmt;
        @AuraEnabled public String firstInstalmentDate;
        @AuraEnabled public String accountStatus;
        @AuraEnabled public String msgEmandateNumberntry;
    }
}