/**
 * @author Jaco de Lange
 * @since 2021-02-03
 **/
public class GBgetCmsLimitsDetV1_Request {    
    public static Boolean GBgetCmsLimitsDetV1_Request (string clientCode) {
        
            string getCmsLimitsReq;
        	string checkrespBody;
        	Boolean highLimitcheck = false;
        	           
            getCmsLimitsReq = '{' ;     
            getCmsLimitsReq = getCmsLimitsReq+'"GBgetCmsLimitsDetV1": {';
            getCmsLimitsReq = getCmsLimitsReq+'"nbsapdpo": {';   
            getCmsLimitsReq = getCmsLimitsReq+'"channel": "salesforce",';
            getCmsLimitsReq = getCmsLimitsReq+'"application": "salesforce",';
            getCmsLimitsReq = getCmsLimitsReq+'"trace": "Y"';  
            getCmsLimitsReq = getCmsLimitsReq+'},';  
            getCmsLimitsReq = getCmsLimitsReq+'"nbsmsgi": {';
            getCmsLimitsReq = getCmsLimitsReq+'"msgLanguage": "E",';
            getCmsLimitsReq = getCmsLimitsReq+'"msgTarget": "STD",';
            getCmsLimitsReq = getCmsLimitsReq+'"finalMsgId": {';   
            getCmsLimitsReq = getCmsLimitsReq+'"finalMsgClass":"",';   
            getCmsLimitsReq = getCmsLimitsReq+'"finalMsgCode":""'; 
            getCmsLimitsReq = getCmsLimitsReq+'}';
            getCmsLimitsReq = getCmsLimitsReq+'},';  
            getCmsLimitsReq = getCmsLimitsReq+'"gsb012i": {';  
            getCmsLimitsReq = getCmsLimitsReq+'"clientCode":"'+clientCode+'"';  
            getCmsLimitsReq = getCmsLimitsReq+'}';  
            getCmsLimitsReq = getCmsLimitsReq+'}';
            getCmsLimitsReq = getCmsLimitsReq+'}';    
                
            system.debug ('JSON serialize :: ' + (getCmsLimitsReq));                 
                    
        	if (!Test.isRunningTest()){
                system.debug('Before HTTP Call out!');
                checkrespBody = runCallout(getCmsLimitsReq, 'https://Absa330762.jitterbit.eu/rbservicesenvironmentuat/1.0/api/GBgetCmsLimitsDetV1', 'PUT');               
            }  
        	else{
                runCallout(getCmsLimitsReq,'https:', 'PUT');
            	checkrespBody = '{"GBgetCmsLimitsDetV1Response": {"nbsapdpo": {"version": null,"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": null},"nbsmsgo3": {"version": null,"sysErrTxt": null,"nbrUserMsgs": "0","nbrUserErrs": "0"},"gsb012o": {"noOfOccurences": "1","limitDetail": [{"indGrpLim": "I","typeOfLim": "P","prodOrComb": "CHEQ","status": "P","contBranch": "3840","contOffTyp": "CM","contOffNum": "1","crac": "0","limArrangement": "L","oram": "20","limitAmount": "0","credBalRange": "0","limExpDate": "20210101","dateApproved": "20200526","reviewDate": "20210101","reduceCycle": "N","reduceDate": "0","reduceAmount": "0","onceoffRedAmt": "0","onceoffRedDate": "0","forCurrUnit": null,"forLimAmount": "0","daylimAmount": "0","daylimExpDate": "0","prevAction": "A","emplPrevAct": "212520","datePrevAct": "20200526",           "empnamePrevAct": "C.F","mamt": "0","appFuncPrevAct": "A","emplAppPrevAct": "598305","appDatePrevAct": "20200526","empnameAppPrev": "A.J","vind": "Y"}]}}}';
        	}
            CBgetCmsLimitsDetV1_Response res = (CBgetCmsLimitsDetV1_Response) JSON.deserialize(checkrespBody, CBgetCmsLimitsDetV1_Response.class);	
        	system.debug ('CBgetCmsLimitsDetV1_Response :: ' + res);
        
        if (res.GBgetCmsLimitsDetV1Response.Gsb012o.limitDetail[0].indGrpLim!=null || 
            res.GBgetCmsLimitsDetV1Response.Gsb012o.limitDetail[0].prodOrComb!=null){
            	highLimitcheck = true;
        }        
        	return highLimitcheck;
    }
    
    public static string runCallout(string body, string url, string method) {
        httpRequest req = new httpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setHeader('content-type','application/json');
        req.setTimeout(60000);
        if (body!='') req.setBody(body);
        system.debug ('HTTP callout request :: ' + req);
        Http http = new Http();
        	HttpResponse res = new HttpResponse();       
            	if (!Test.isRunningTest()){
                    try{
                        res = http.send(req);
                    }
                    catch (Exception e){
                        system.debug('HTTP Callout failed :: ' + e.getMessage());
                    }                	
            	}
        	system.debug('Message Return Body for CBgetCmsLimitsDetV1 service :: ' + res.getBody());
        	if (res.getBody() !=null && res.getstatusCode() == 200){
            	return res.getBody();
        	}
        	else{
            	return null;
        	}        
    } 
}