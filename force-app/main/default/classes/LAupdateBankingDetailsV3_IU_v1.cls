/*
 * Integration utility for LAUpdateBankingDetailsV3 Service
 * @author Humbelani Denge
 * @created 2020-10-09
 */
public class LAupdateBankingDetailsV3_IU_v1 {
    public static LAUpdateBankingDetailsV3_Req_IB_v1 mapRequestFields(String clientCode, String policyNumber, String bankName, String sourceOfIncome, String sourceOfFund, String bankAccountNo, String accountHolderName, String collectionDay, String frequency, String accountType, String branchCode, String amount){
        LAUpdateBankingDetailsV3_Req_IB_v1 requestBean = new LAUpdateBankingDetailsV3_Req_IB_v1();
        requestBean.LAupdateBankingDetailsV3 = new LAUpdateBankingDetailsV3_Req_IB_v1.LAupdateBankingDetailsV3();
        requestBean.LAupdateBankingDetailsV3.la950p5i = new LAUpdateBankingDetailsV3_Req_IB_v1.La950p5i();
        requestBean.LAupdateBankingDetailsV3.nbsapdpi = new LAUpdateBankingDetailsV3_Req_IB_v1.Nbsapdpi();

        requestBean.LAupdateBankingDetailsV3.la950p5i.bankName = bankName;
        requestBean.LAupdateBankingDetailsV3.la950p5i.bankAccountNumber = bankAccountNo;
        requestBean.LAupdateBankingDetailsV3.la950p5i.premiumCollectionDay = collectionDay;
        requestBean.LAupdateBankingDetailsV3.la950p5i.premiumCollectionDate = collectionDay;
        requestBean.LAupdateBankingDetailsV3.la950p5i.accountholderName = accountHolderName;
        requestBean.LAupdateBankingDetailsV3.la950p5i.accountType = accountType;
        requestBean.LAupdateBankingDetailsV3.la950p5i.bankBranch = branchCode;
        requestBean.LAupdateBankingDetailsV3.la950p5i.changeType = 'BAN';
        requestBean.LAupdateBankingDetailsV3.la950p5i.paymentMethod = 'DO';
        requestBean.LAupdateBankingDetailsV3.la950p5i.signedDebitOrder = 'Y';
        requestBean.LAupdateBankingDetailsV3.la950p5i.amount = amount;
        requestBean.LAupdateBankingDetailsV3.la950p5i.sourceOfIncome = sourceOfIncome;
        requestBean.LAupdateBankingDetailsV3.la950p5i.sourceOfFund = sourceOfFund; 
        requestBean.LAupdateBankingDetailsV3.la950p5i.paymentFrequency = frequency;
        requestBean.LAupdateBankingDetailsV3.la950p5i.policyNumber = policyNumber.replaceFirst('^0+', '');
        requestBean.LAupdateBankingDetailsV3.la950p5i.action = 'M';
        requestBean.LAupdateBankingDetailsV3.la950p5i.clientCode = clientCode;
        requestBean.LAupdateBankingDetailsV3.la950p5i.businessSourceIndicator = 'AO';
        requestBean.LAupdateBankingDetailsV3.la950p5i.changeEffectiveDate = System.today().toStartOfMonth();
        requestBean.LAupdateBankingDetailsV3.la950p5i.bankUpdateIndicator = 'N';
        requestBean.LAupdateBankingDetailsV3.la950p5i.onceoffInstructionIndicator = 'N';
        requestBean.LAupdateBankingDetailsV3.nbsapdpi.channel = 'BDP';
        requestBean.LAupdateBankingDetailsV3.nbsapdpi.application = 'BDP';
        requestBean.LAupdateBankingDetailsV3.nbsapdpi.trace = 'Y';

        return requestBean;
    }
}