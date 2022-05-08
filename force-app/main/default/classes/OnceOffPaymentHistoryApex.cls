/**
*@description Controller used by the OnceOffPaymentHistory lightning components
*
* @author  Danie Booysen
* @version v1.0
* @since   2021-03-18
*/
public class OnceOffPaymentHistoryApex {

    /**
    *@description Method that gets the historical once off payments made against an account
    *
    * @param selectedAccountNumber - the account number to retrieve the once off payments from
    * @return MBlistInstPerSourceAccV1_Resp_IB_v1 - the full response from the service
    */
    @AuraEnabled
    public static MBlistInstPerSourceAccV1_Resp_IB_v1 OOPTransactionHistory(String selectedAccountNumber){
        return MBlistInstPerSourceAccV1_IH_v1.MBlistInstructionsPerSourceAccV1('', selectedAccountNumber, 'OOP');
    }
}