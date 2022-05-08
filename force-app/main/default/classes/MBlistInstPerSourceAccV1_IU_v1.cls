/**
 * @description Integration Utility class for MBlistInstructionsPerSourceAccV1 Service
 * @author Chandra Bhushan
 * @created 2020-03-12
 */

public class MBlistInstPerSourceAccV1_IU_v1 {

    /**
	 * @description mapRequestFields method to map data
	 * @param cifKey
     * @param sourceAccount
     * @param instrType
	 * @return MBlistInstPerSourceAccV1_Req_IB_v1
	 */
    public static MBlistInstPerSourceAccV1_Req_IB_v1 mapRequestFields(String  cifKey, String sourceAccount, String instrType) {
        MBlistInstPerSourceAccV1_Req_IB_v1 requestBean = new MBlistInstPerSourceAccV1_Req_IB_v1();
        requestBean.NBSAPDPI = new MBlistInstPerSourceAccV1_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new MBlistInstPerSourceAccV1_Req_IB_v1.NBSMSGI();
		requestBean.MBS326I = new MBlistInstPerSourceAccV1_Req_IB_v1.MBS326I();
		requestBean.NBSAPDPI.InputHeaders = new MBlistInstPerSourceAccV1_Req_IB_v1.InputHeaders();
		requestBean.NBSMSGI.InputErrorMessage = new MBlistInstPerSourceAccV1_Req_IB_v1.InputErrorMessage();
		requestBean.MBS326I.InputCopybook = new MBlistInstPerSourceAccV1_Req_IB_v1.InputCopybook();
        requestBean.NBSAPDPI.InputHeaders.channelName  = 'SALESFOR';
		requestBean.NBSAPDPI.InputHeaders.applicationName  = 'SALESFOR';
		requestBean.NBSAPDPI.InputHeaders.traceIndicator  = 'Y';
        requestBean.NBSMSGI.InputErrorMessage.errorMessageLanguage = 'E';
        requestBean.NBSMSGI.InputErrorMessage.errorMessageTarget = 'STD';
        requestBean.MBS326I.InputCopybook.channel = 'SALESFOR';
        requestBean.MBS326I.InputCopybook.maxRetrieve = 50;
        requestBean.MBS326I.InputCopybook.processIndicator = '';
        requestBean.MBS326I.InputCopybook.origType = '';
        requestBean.MBS326I.InputCopybook.origStatus = '';
        requestBean.MBS326I.InputCopybook.altTieb = 0;
        requestBean.MBS326I.InputCopybook.cifKey = cifKey;
        requestBean.MBS326I.InputCopybook.tieb = 0;
        requestBean.MBS326I.InputCopybook.instrType = instrType;
        requestBean.MBS326I.InputCopybook.instrNumber = 0;
        requestBean.MBS326I.InputCopybook.multiNumber = 0;
        requestBean.MBS326I.InputCopybook.instrStatus = 'CURRENT';
        requestBean.MBS326I.InputCopybook.sourceAccount = sourceAccount;

        return requestBean;
    }
}