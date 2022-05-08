/**
 * @description       : Login Result class for CIS
 * @author            : Mohammed Junaid U
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   05-25-2021   Mohammed Junaid U   Initial Version
**/

public class CIS_LoginResult_IB_V1 extends Base_IB{

    public LoginResult LoginResult;
    public String Token;

    /**
     * @description
     */
    public class LoginResult {

        public String Status;
        public String Detail;
    }
    /**
     * @description constructor
     */
    public CIS_LoginResult_IB_V1(){}

}