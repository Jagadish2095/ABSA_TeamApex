/**
 * @description Branch Credit Card Referral Controller
 * @author  Clifford Willers
 * @created 2020-09-18
 */
public without sharing class BranchCreditCardReferralController {
    /**
    * @description callApplicationInformation
    * @return string
    * @param applicationNumber
    */
    @AuraEnabled
    public static String callApplicationInformation(string applicationNumber)
    {
        return JSON.serialize(CCApplicationServiceHelper.getApplicationInformation(applicationNumber));
    }

}