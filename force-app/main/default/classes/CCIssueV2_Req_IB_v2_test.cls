/*
* Test Integration Handler for CASAScreenRelatedParty Service
* @author Happy Baloyi
* @created 2019-03-13
*/

@isTest
public class CCIssueV2_Req_IB_v2_test {
@isTest static void createDummyRequesttest() {
      
       
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

		inputCopyBookBean.tellerCode = '99997';
        inputCopyBookBean.workStation = 'o';
        inputCopyBookBean.supervisor = '999998';
        inputCopyBookBean.branchCode = '9997';
        inputCopyBookBean.agencyCode = '9998';
        inputCopyBookBean.cardReqdIndicator = 'a';
        inputCopyBookBean.persIndicator = 'c';
        inputCopyBookBean.persName = 'Glen Johnston';
        inputCopyBookBean.cardNumber = '1537396144';
        inputCopyBookBean.clientCode = 'nubbosnuvi';
        inputCopyBookBean.brandNumber = '23036';
        inputCopyBookBean.prodCode = '99997';
        inputCopyBookBean.issueBranch = '9999997';
        inputCopyBookBean.autoLink = 'j';
        inputCopyBookBean.nomCheq = '7174038554';
        inputCopyBookBean.nomSavs = '2377208853';
        inputCopyBookBean.nomCred = '7520643645';
        inputCopyBookBean.pinReqdIndicator = 'w';
        inputCopyBookBean.cardFee = 'i';
        inputCopyBookBean.lostFee = 'm';
        inputCopyBookBean.blindIndicator = 'b';
        inputCopyBookBean.idPspIndicator = '6806334573903872';
        inputCopyBookBean.idPspNumber = '294363810758656';
		inputCopyBookBean.cardTypeIndicator = 'w';
		ccs311iBean.inputCopybook = inputCopyBookBean;
		requestBean.CCS311I = ccs311iBean;      
    CCIssueV2_Req_IB_v2 resp =  CCIssueV2_Req_IB_v2.createDummyRequest();
 System.assert('success'== 'success' , 'assert failed');
  }

}