/**
 * @description Apex controller class for the Aura bundle VoiceCustomerPersonalInfoUpdate.
 * @author Simangaliso Mathenjwa
 * @since 2022-02-04
 */
public class VoiceCustomerPersonalInfoUpdateCTRL {
    /**
	 * @description Method to get set Gender and DOB from Account Id
	 * @param accountId
	 */
    @AuraEnabled
    public static void setIdDerivedGenderAndDob(String accountId) {
        BranchCIFSalesforceSyncHelper.setIdDerived(accountId);
    }
}