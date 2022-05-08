/**
 * @description PackageProductController
 * @author  Clifford Willers : ABSA (IQ Business)
 * @created 2020-10-29
 */
public without sharing class PackageProductController {
    /**
    * @description callActionQuotation
    * @return String
    * @param accountID
    * @param newCreditLimit
    * @param wkFiid
    * @param wkAcctProd
    * @param wkAcctType
    */
    @AuraEnabled
    public static String callActionQuotation(String accountID, String newCreditLimit, String wkFiid, String wkAcctProd, String wkAcctType)
    {
        return CreditCardHelper.getActionQuotation(accountID, newCreditLimit, wkFiid, wkAcctProd, wkAcctType);
    }
    /**
    * @description callCompleteOne
    * @return String
    * @param applicationId
    * @param applicationNumber
    * @param lockVersionId
    * @param creditLifeRequired
    * @param cardProdSubProdGroupId
    * @param creditLimitApproved
    * @param creditLimitSelected
    * @param noticeDelivery
    * @param annualCreditLimitIncreases
    */
    @AuraEnabled
    public static String callCompleteOne(Id applicationId, string applicationNumber, string lockVersionId, string creditLifeRequired, string cardProdSubProdGroupId, string creditLimitApproved, string creditLimitSelected, string noticeDelivery, String annualCreditLimitIncreases)
    {
        return JSON.serialize(CCApplicationServiceHelper.applyComplete1(applicationId, applicationNumber, lockVersionId, creditLifeRequired, cardProdSubProdGroupId, creditLimitApproved, creditLimitSelected, noticeDelivery, annualCreditLimitIncreases));
    }
}