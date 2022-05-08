/*
 * Controller class for the AvafDebitOrderDetails component
 * @author Danie Booysen
 * @created 2020-11-19
 */
public  class AvafDebitOrderDetailsController {

    //Method called via init on AvafPartnerBankingDetails cmp
    //returns the response from the AvafGetDebitOrderDetails_IH_v1 Service
    //@author Danie Booysen
    @AuraEnabled
    public static AvafGetDebitOrderDetails_Resp_IB_v1 DebitOrderDetails(String avafAccount){
        AvafGetDebitOrderDetails_Resp_IB_v1 response = AvafGetDebitOrderDetails_IH_v1.AvafGetDebitOrderDetails(avafAccount);
        return response;
    }

    //Method called via init on AvafPartnerBankingDetails cmp
    //returns the response from the AvafGetPartner Service
    //@author Danie Booysen
    @AuraEnabled
    public static AvafGetPartner_Resp_IB_v1 PartnerDetails(String avafAccount){
        AvafGetPartner_Resp_IB_v1 response = AvafGetPartner_IH_v1.AvafGetPartner(avafAccount);
        return response;
    }

    //Method called via update debit order action on the AvafPartnerBankingDetails cmp
    //returns the response from the AvafChangeDebitOrder Service
    //@author Danie Booysen
    @AuraEnabled
    public static AvafChangeDebitOrder_Resp_IB_v1 UpdateDebitOrderDetails(String avafAccount, String debitOrder, String collectionDay, String collectionStartDate, String collectionEndDate, String collectionAmount, String collectionBankId, String bankAccount){
        AvafChangeDebitOrder_Resp_IB_v1 response = AvafChangeDebitOrder_IH_v1.AvafChangeDebitOrder(avafAccount, debitOrder, collectionDay, collectionStartDate, collectionEndDate, collectionAmount, collectionBankId, bankAccount);
        return response;
    }

    //Method called via init on AvafPartnerBankingDetails cmp
    //returns the response from the AvafGetBankDetails Service
    //@author Jason Quevauvilliers
    @AuraEnabled
    public static AvafGetBankDetails_Resp_IB_v1 getPartnerBankingDetails(String businessPartnerNumber) {
        AvafGetBankDetails_Resp_IB_v1 responseBean = AvafGetBankDetails_IH_v1.AvafGetBankDetails(businessPartnerNumber);
        return responseBean;
    }

    //Method to Validate new Banking Details
    //returns the response from the CheckDigitVerification Service
    //@author Jason Quevauvilliers
    @AuraEnabled
    public static CheckDigitVerification_Resp_IB_v1 validateBankingDetails(String accountNumber, String branchNumber, String accountType) {
        CheckDigitVerification_Resp_IB_v1 responseBean = CheckDigitVerification_IH_v1.checkDigitVerification(accountNumber, branchNumber, accountType, 'DR', '', '0', 'SF', 'SF', 'E', 'STD', 'Y');
        return responseBean;
    }

    //Method to Add a new Partner Bank Details
    //returns the response from the AvafAddBankDetails Service
    //@author Jason Quevauvilliers
    @AuraEnabled
    public static AvafAddBankDetails_Resp_IB_v1 addPartnerBankingDetails(String businessPartnerNumber, String accountNumber, String branchNumber, String accountType) {
        AvafAddBankDetails_Resp_IB_v1 responseBean = AvafAddBankDetails_IH_v1.AvafAddBankDetails(businessPartnerNumber, null, null, null, accountNumber, accountType, branchNumber, 'ZA');
        return responseBean;
    }
}