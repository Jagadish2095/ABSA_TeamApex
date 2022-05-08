/**
* 
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CClistPrefProductForClientV2_IU_v2 {

    public static CClistPrefProductForClientV2_Req_IB_v2 mapRequestFields(String clientCode, String accountNumber, String cardType) {

        //get current user details
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        CClistPrefProductForClientV2_Req_IB_v2 requestBean = new CClistPrefProductForClientV2_Req_IB_v2();
		CClistPrefProductForClientV2_Req_IB_v2.NBSAPDPI nbsapdpiBean = new CClistPrefProductForClientV2_Req_IB_v2.NBSAPDPI();
		CClistPrefProductForClientV2_Req_IB_v2.NBSMSGI nbsmsgiBean = new CClistPrefProductForClientV2_Req_IB_v2.NBSMSGI();
		CClistPrefProductForClientV2_Req_IB_v2.CCS317I ccs317iBean = new CClistPrefProductForClientV2_Req_IB_v2.CCS317I();

		CClistPrefProductForClientV2_Req_IB_v2.InputHeaders inputHeaderBean = new CClistPrefProductForClientV2_Req_IB_v2.InputHeaders();
		CClistPrefProductForClientV2_Req_IB_v2.InputErrorMessage inputErrorMsgBean = new CClistPrefProductForClientV2_Req_IB_v2.InputErrorMessage();
		CClistPrefProductForClientV2_Req_IB_v2.InputCopybook inputCopyBookBean = new CClistPrefProductForClientV2_Req_IB_v2.InputCopybook();

		inputHeaderBean.applicationName = 'BDP';
		inputHeaderBean.channelName = 'BDP';
		inputHeaderBean.traceIndicator = 'Y';
		nbsapdpiBean.inputHeaders = inputHeaderBean;
		requestBean.NBSAPDPI = nbsapdpiBean;

		inputErrorMsgBean.errorMessageLanguage = 'E';
		inputErrorMsgBean.errorMessageTarget = 'STD';
		nbsmsgiBean.inputErrorMessage = inputErrorMsgBean;
		requestBean.NBSMSGI = nbsmsgiBean;

		inputCopyBookBean.accountNumber = accountNumber;//'263404026';
		inputCopyBookBean.cardType = cardType;//'C';
		inputCopyBookBean.clientCode = clientCode;
		inputCopyBookBean.functionIndicator = 'N';
		inputCopyBookBean.tellerCode = currentUser.Teller_Operator_Code__c;//'99998';
		ccs317iBean.inputCopybook = inputCopyBookBean;
		requestBean.CCS317I = ccs317iBean;

        return requestBean;
        
        
    }
}