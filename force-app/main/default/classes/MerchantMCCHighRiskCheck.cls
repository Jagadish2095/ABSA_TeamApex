public class MerchantMCCHighRiskCheck {
    // @author Himani Joshi: 20200720
    // Method that gets a lists of High Risk MCC's
    @AuraEnabled
    public static List<High_Risk_MCC__mdt> getHighRiskMCCs() {
        return Sys_Utilities_Metadata.getHighRiskMCC();
    }
}