@isTest
public class CBgetCmsLimitsDetV1_ResponseTest {
    
    static testMethod void testParse() {
		String json = '{"GBgetCmsLimitsDetV1Response": {"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": null,"sysErrTxt": null,"nbrUserMsgs": "0","nbrUserErrs": "0"},"gsb012o": {"noOfOccurences": "1","limitDetail": [{"indGrpLim": "I","typeOfLim": "P","prodOrComb": "CHEQ","status": "P","contBranch": "3840","contOffTyp": "CM","contOffNum": "1","crac": "0","limArrangement": "L","oram": "20","limitAmount": "0","credBalRange": "0","limExpDate": "20210101","dateApproved": "20200526","reviewDate": "20210101","reduceCycle": "N","reduceDate": "0","reduceAmount": "0","onceoffRedAmt": "0","onceoffRedDate": "0","forCurrUnit": null,"forLimAmount": "0","daylimAmount": "0","daylimExpDate": "0","prevAction": "A","emplPrevAct": "212520","datePrevAct": "20200526",           "empnamePrevAct": "C.F","mamt": "0","appFuncPrevAct": "A","emplAppPrevAct": "598305","appDatePrevAct": "20200526","empnameAppPrev": "A.J","vind": "Y"}]}}}';
		CBgetCmsLimitsDetV1_Response obj = CBgetCmsLimitsDetV1_Response.parse(json);
		System.assert(obj != null);
        
        GBgetCmsLimitsDetV1_Request.GBgetCmsLimitsDetV1_Request('002');
	}
}