/*
* Integration Request Bean for ABFgetAndCalcConfDetailV4 Service 
* @author Himanshu Nimje
* @created 2020-11-28
*/
public class ABFgetAndCalcConfDetailV4_Req_IB_V1 extends Base_IB {
    
    
    public NBSAPDPI NBSAPDPI;
    public MSGI MSGI;
    public PLPA01I PLPA01I;
    
    public class NBSAPDPI{
        public NBSAPLI  NBSAPLI;
    }
    public class NBSAPLI{
        public String  NBNAPLI_CHANNEL;
        public String NBNAPLI_APPLICATION;
        public String NBNAPLI_TRACE;
    }
    
    public class MSGI{
        public NBSMSGI  NBSMSGI;
    }
    public class NBSMSGI{
        public String  NBNMSGI_MSG_LANGUAGE;
        public String NBNMSGI_MSG_TARGET;
        
    }
    
    public class PLPA01I{
        public PLPA01Iz  PLPA01I;
    }
    public class PLPA01Iz{
        public String  corpCode;
        public String  branchCode;
        public String  accountNbr;
        public String  contractEffectiveDate;
        public String  marketSector;
        public String  electronicTransferReq;
        public String  employerCode;
        public String  securityReqInd;
        public String  permitWithdrawalInd;
        public String  cpfMarketerCode;
        public String  welcomePrintLetter;
        public String  autoCapiAdvAmt;
        public String  TermLoanType;
        public String  mandateNumber;
        public String  selectLoanPurposes;
        public String  selectSchemeType;
        public String  selectPaymentMethod;
        public String  selectAgreementCategory;
        public String  selectFinanceType;
        
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"PLPA01I":', '"PLPA01Iz":');
        
        
    }
    
    
    public static ABFgetAndCalcConfDetailV4_Req_IB_V1 createDummyRequest() {
        
        ABFgetAndCalcConfDetailV4_Req_IB_V1 requestBean = new ABFgetAndCalcConfDetailV4_Req_IB_V1();
        
        ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPDPI NBSAPDPI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPDPI();
        
        ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPLI NBSAPLI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSAPLI();
        NBSAPLI.NBNAPLI_CHANNEL = 'Salesforce';
        NBSAPLI.NBNAPLI_APPLICATION='Salesforce';
        NBSAPLI.NBNAPLI_TRACE = 'Y';
        
        ABFgetAndCalcConfDetailV4_Req_IB_V1.MSGI MSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.MSGI();
        ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSMSGI NBSMSGI = new ABFgetAndCalcConfDetailV4_Req_IB_V1.NBSMSGI();
        NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
        NBSMSGI.NBNMSGI_MSG_TARGET='STD';
        
        
        ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01I PLPA01I = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01I();
        ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01Iz PLPA01Iz = new ABFgetAndCalcConfDetailV4_Req_IB_V1.PLPA01Iz();
        PLPA01Iz.corpCode='ABS';
        PLPA01Iz.branchCode ='3045';
        PLPA01Iz.accountNbr='3001535059';
        PLPA01Iz.contractEffectiveDate='20201103';
        PLPA01Iz.marketSector='000';
        PLPA01Iz.electronicTransferReq='Y';
        PLPA01Iz.employerCode='5037348';
        PLPA01Iz.securityReqInd='N';
        PLPA01Iz.permitWithdrawalInd='Y';
        PLPA01Iz.cpfMarketerCode='';
        PLPA01Iz.welcomePrintLetter='Y';
        PLPA01Iz.autoCapiAdvAmt='Y';
        PLPA01Iz.TermLoanType='TLN';
        
        NBSAPDPI.NBSAPLI=NBSAPLI;
        MSGI.NBSMSGI=NBSMSGI;
        PLPA01I.PLPA01I=PLPA01Iz;
        
        
        
        requestBean.NBSAPDPI = NBSAPDPI;
        requestBean.MSGI = MSGI;
        requestBean.PLPA01I = PLPA01I;
        
        return requestBean;
        
    }
    
    
}