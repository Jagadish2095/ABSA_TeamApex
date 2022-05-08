/**
*
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
*
**/
public class CCIssueV2_IU_v2 {

    public static CCIssueV2_Req_IB_v2 mapRequestFields(String agencyCode, String cardReqdIndicator, String persIndicator, String persName, String cardNumber, String clientCode, String brandNumber,
                                                       String prodCode, String autoLink, String nomCheq, String nomSavs, String nomCred, String pinReqdIndicator, String cardFee, String lostFee,
                                                       String idPspIndicator, String idPspNumber, String cardTypeIndicator){

        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());

        CCIssueV2_Req_IB_v2 requestBean = new CCIssueV2_Req_IB_v2();
		CCIssueV2_Req_IB_v2.NBSAPDPI nbsapdpiBean = new CCIssueV2_Req_IB_v2.NBSAPDPI();
		CCIssueV2_Req_IB_v2.NBSMSGI nbsmsgiBean = new CCIssueV2_Req_IB_v2.NBSMSGI();
		CCIssueV2_Req_IB_v2.CCS311I ccs311iBean = new CCIssueV2_Req_IB_v2.CCS311I();

		CCIssueV2_Req_IB_v2.InputHeader inputHeaderBean = new CCIssueV2_Req_IB_v2.InputHeader();
		CCIssueV2_Req_IB_v2.InputErrorMessage inputErrorMsgBean = new CCIssueV2_Req_IB_v2.InputErrorMessage();
		CCIssueV2_Req_IB_v2.InputCopybook inputCopyBookBean = new CCIssueV2_Req_IB_v2.InputCopybook();

		inputHeaderBean.applicationName = 'BDP';
		inputHeaderBean.channelName = 'BDP';
		inputHeaderBean.traceIndicator = 'Y';
		nbsapdpiBean.inputHeader = inputHeaderBean;
		requestBean.NBSAPDPI = nbsapdpiBean;

		inputErrorMsgBean.errorMessageLanguage = 'E';
		inputErrorMsgBean.errorMessageTarget = 'STD';
		nbsmsgiBean.inputErrorMessage = inputErrorMsgBean;
		requestBean.NBSMSGI = nbsmsgiBean;

        inputCopyBookBean.tellerCode = currentUser.Teller_Operator_Code__c;
        inputCopyBookBean.workStation = '99';
        inputCopyBookBean.supervisor = currentUser.Supervisor__c;
        inputCopyBookBean.branchCode = currentUser.SiteCode__c;
        inputCopyBookBean.agencyCode = agencyCode;//'9998';
        inputCopyBookBean.cardReqdIndicator = 'N';//cardReqdIndicator;//'a';
        inputCopyBookBean.persIndicator = persIndicator;//'c';
        inputCopyBookBean.persName = persName;//'Glen Johnston';
        inputCopyBookBean.cardNumber = cardNumber;//'1537396144';
        inputCopyBookBean.clientCode = clientCode;//'nubbosnuvi';
        inputCopyBookBean.brandNumber = brandNumber;//'23036';
        inputCopyBookBean.prodCode = prodCode;//'99997';
        inputCopyBookBean.issueBranch = currentUser.SiteCode__c;
        inputCopyBookBean.autoLink = 'N';//autoLink;//'j';
        inputCopyBookBean.nomCheq = nomCheq;//'7174038554';
        inputCopyBookBean.nomSavs = nomSavs;//'2377208853';
        inputCopyBookBean.nomCred = nomCred;//'7520643645';
        inputCopyBookBean.pinReqdIndicator = pinReqdIndicator;//'w';
        inputCopyBookBean.cardFee = cardFee;//'i';
        inputCopyBookBean.lostFee = lostFee;//'m';
        inputCopyBookBean.blindIndicator = 'N';//'b';//get the correct indicator
        inputCopyBookBean.idPspIndicator = idPspIndicator;//'6806334573903872';
        inputCopyBookBean.idPspNumber = idPspNumber;//'294363810758656';
        inputCopyBookBean.cardTypeIndicator = cardTypeIndicator;//'w';
        ccs311iBean.inputCopybook = inputCopyBookBean;
		requestBean.CCS311I = ccs311iBean;

		return requestBean;
    }
}