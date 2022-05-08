/**
 * @description
* Apex Integration Request Bean class for CCIssueV2 service
* @author  Mbuyiseni Mbhokane 
* @since   2020-09-17
* @Updated by: Thomas Dry
* @Updated :2021-04-13 added GetInstance() for static and system values
**/
public class CCIssueV2_Req_IB_v2 extends Base_IB{
/**
 * @description NBSAPDPI
*/
	public NBSAPDPI NBSAPDPI;
	public NBSMSGI NBSMSGI;
	public CCS311I CCS311I;
/**
 * @description NBSAPDPI
*/
	public class NBSAPDPI {
		public InputHeader inputHeader;
	}
/**
 * @description InputHeader
*/
	public class InputHeader {
		public String channelName;
		public String applicationName;
		public String traceIndicator;
	}
/**
 * @description InputHeader
*/

	public class NBSMSGI {
		public InputErrorMessage inputErrorMessage;
	}
/**
 * @description InputErrorMessage
*/

	public class InputErrorMessage {
		public String errorMessageLanguage;
		public String errorMessageTarget;
	}
/**
 * @description InpuCCS311ItErrorMessage
*/

	public class CCS311I {
		public InputCopybook inputCopybook;
	}
/**
 * @description InputCopybook
*/

	public class InputCopybook {
		public String tellerCode;
		public String workStation;
		public String supervisor;
		public String branchCode;
		public String agencyCode;
		public String cardReqdIndicator;
		public String persIndicator;
		public String persName;
		public String cardNumber;
		public String clientCode;
		public String brandNumber;
		public String prodCode;
		public String issueBranch;
		public String autoLink;
		public String nomCheq;
		public String nomSavs;
		public String nomCred;
		public String pinReqdIndicator;
		public String cardFee;
		public String lostFee;
		public String blindIndicator;
		public String idPspIndicator;
		public String idPspNumber;
		public String cardTypeIndicator;
	}
/**
 * @description GetInstance
 * @return CCIssueV2_Req_IB_v2
*/

	public static CCIssueV2_Req_IB_v2 GetInstance()
    {
		CCIssueV2_Req_IB_v2 requestBean = new CCIssueV2_Req_IB_v2();

		requestBean.NBSAPDPI = new CCIssueV2_Req_IB_v2.NBSAPDPI();
		requestBean.NBSAPDPI.inputHeader = new  CCIssueV2_Req_IB_v2.inputHeader();

		requestBean.NBSMSGI = new CCIssueV2_Req_IB_v2.NBSMSGI();
		requestBean.NBSMSGI.inputErrorMessage = new CCIssueV2_Req_IB_v2.inputErrorMessage();

		requestBean.CCS311I = new CCIssueV2_Req_IB_v2.CCS311I();
		requestBean.CCS311I.inputCopybook = new CCIssueV2_Req_IB_v2.inputCopybook();

        //get the current user
        User currentUser = new UsersSelector().selectById(Userinfo.getUserId());      
        
        requestBean.NBSAPDPI.inputHeader.channelName = 'I';
        requestBean.NBSAPDPI.inputHeader.applicationName = 'BDP';
        requestBean.NBSAPDPI.inputHeader.traceIndicator = 'N';		

        requestBean.NBSMSGI.inputErrorMessage.errorMessageLanguage = 'E';
        requestBean.NBSMSGI.inputErrorMessage.errorMessageTarget = 'BDP';

		requestBean.CCS311I.inputCopybook.tellerCode = currentUser.Teller_Operator_Code__c;
		requestBean.CCS311I.inputCopybook.supervisor = currentUser.Supervisor__c;
		requestBean.CCS311I.inputCopybook.branchCode = currentUser.SiteCode__c;
		requestBean.CCS311I.inputCopybook.agencyCode = currentUser.SiteCode__c;
		requestBean.CCS311I.inputCopybook.issueBranch = currentUser.SiteCode__c;

        return requestBean;
    }    
/**
 * @description createDummyRequest
 * @return CCIssueV2_Req_IB_v2
*/
	public static CCIssueV2_Req_IB_v2 createDummyRequest() {

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

		return requestBean;
	}
}