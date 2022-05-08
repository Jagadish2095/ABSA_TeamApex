/**
*@description Controller used by the BeneficiarySelection lightning components
*
* @author  Danie Booysen
* @version v1.0
* @since   2021-03-25
*/
public class BeneficiarySelectionApex {

    /**
    *@description Method that gets the beneficiaries for a selected combi card account number
    *
    * @param selectedCombiAccountNumber - the combi card account number to retrieve the beneficiaries from
    * @return MBlistInstPerSourceAccV1_Resp_IB_v1 - the full response from the service
    */
    @AuraEnabled
    public static MBlistInstPerSourceAccV1_Resp_IB_v1 getBeneficiaries(String selectedCombiAccountNumber){
        return MBlistInstPerSourceAccV1_IH_v1.MBlistInstructionsPerSourceAccV1('', selectedCombiAccountNumber, 'VP');
    }
}