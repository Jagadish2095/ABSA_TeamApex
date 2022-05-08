/**
 * @description       : InvClientVerificationController
 * @author            : Vinod.Thupakula@absa.africa
 * @last modified on  : 2021-11-12
 * @last modified by  : Vinod.Thupakula@absa.africa
**/
public class InvClientVerificationController {
    /**
     * @description getUserAccess
     * @param oppId
     * @return Boolean
     **/
	@AuraEnabled
    public static Boolean getUserAccess(Id oppId){
        return InvestmentOppUtility.getRecordAccess(oppId);
    }
}