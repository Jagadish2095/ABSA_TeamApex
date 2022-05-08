/*
 * Request Integration Bean for LAUpdateBankingDetailsV3_Req_IB_v1 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */
public class LAUpdateBankingDetailsV3_Req_IB_v1 extends Base_IB {
    public LAupdateBankingDetailsV3 LAupdateBankingDetailsV3;

    public class LAupdateBankingDetailsV3 {
        public Nbsapdpi nbsapdpi;
        public La950p5i la950p5i;
    }

    public class Nbsapdpi {
        public String channel;
        public String application;
        public String trace;
    }

    public class La950p5i {
        public String action;
        public String clientCode;
        public String policyNumber;
        public String businessSourceIndicator;
        public String sourceOfIncome;
        public String sourceOfFund;
        public Date changeEffectiveDate;
        public String changeType;
        public String paymentMethod;
        public String accountholderName;
        public String accountType;
        public String divisionCode;
        public String bankAccountNumber;
        public String bankBranch;
        public String paymentFrequency;
        public String signedDebitOrder;
        public String combinedDebitOrderInstruction;
        public String premiumCollectionDate;
        public String premiumCollectionDay;
        public String bankName;
        public String amount;
        public String bankUpdateIndicator;
        public String onceoffInstructionIndicator;
    }

    public override void setIntegrationTranslations() {

        integrationTranslationsMap = new Map<String, String>();
        integrationTranslationsMap.put('LAupdateBankingDetailsV3.la950p5i.accountType', 'CIF;Account Type');
    }

    public static LAUpdateBankingDetailsV3_Req_IB_v1 createDummyRequest() {
        LAUpdateBankingDetailsV3_Req_IB_v1 requestBean = new LAUpdateBankingDetailsV3_Req_IB_v1();
        requestBean.LAUpdateBankingDetailsV3 = new LAUpdateBankingDetailsV3_Req_IB_v1.LAUpdateBankingDetailsV3();
        requestBean.LAUpdateBankingDetailsV3.Nbsapdpi = new LAUpdateBankingDetailsV3_Req_IB_v1.Nbsapdpi();
        requestBean.LAUpdateBankingDetailsV3.La950p5i = new LAUpdateBankingDetailsV3_Req_IB_v1.La950p5i();

        requestBean.LAUpdateBankingDetailsV3.Nbsapdpi.channel = 'BDP';
        requestBean.LAUpdateBankingDetailsV3.Nbsapdpi.application = 'BDP';
        requestBean.LAUpdateBankingDetailsV3.Nbsapdpi.trace = 'Y';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.action = 'M';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.clientCode = '1234';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.policyNumber = '6633725447';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.businessSourceIndicator = 'AO';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.sourceOfIncome = '0';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.sourceOfFund = '0';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.changeEffectiveDate = System.today().toStartOfMonth();
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.changeType = 0;
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.paymentMethod = 0;
        requestBean.LAUpdateBankingDetailsV3.La950p5i.accountholderName = 'test';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.accountType = 'Cheque';
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.divisionCode = 0;
        requestBean.LAUpdateBankingDetailsV3.La950p5i.bankAccountNumber = '7876554';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.bankBranch = '470098';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.paymentFrequency = '8';
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.signedDebitOrder = 0;
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.combinedDebitOrderInstruction = 0;
        //requestBean.LAUpdateBankingDetailsV3.La950p5i.premiumCollectionDate = 0;
        requestBean.LAUpdateBankingDetailsV3.La950p5i.premiumCollectionDay = '15';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.bankName = 'ABSA';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.amount = '0';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.bankUpdateIndicator = '0';
        requestBean.LAUpdateBankingDetailsV3.La950p5i.onceoffInstructionIndicator = '0';

        return requestBean;
    }
}