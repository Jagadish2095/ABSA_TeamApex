@isTest
global class GetClientHoldsMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global GetClientHoldsMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
      
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"CImaintainHoldsV5Response":{"nbsapdpo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004","echoKey":""},"nbsmsgo3":{"version":"","sysErrTxt":"","nbrUserMsgs":"0","nbrUserErrs":"0"},"cip045o":{"rcode":"0","omessage":"","nclta521":"2301","ttlea521":"0","cinta521":"","surna521":"NOZENZO (PTY) LTD","idrq026d":"Y","dest026d":"Y","dsps026d":"Y","iest026d":"Y","cura026d":"N","cphy026d":"N","cemp026d":"N","gadd026d":"N","apdb026d":"N","apdt026d":"0","codb026d":"N","codt026d":"0","mcom026d":"N","ocst026d":"0","ibrAffected":"N","inBusinessRescue":"N","placedBy":"0","dateBusRescueIss":"0","clcdo":"NOZENZO001","secia521":"N","chnoa521":"0","idCnt":"0","forensicHoldOut":"Y","finCrimeHoldOut":"Y","clntAgrmntIssuedOut":"N"}}}');
            response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING)
        {
         response.setBody('{     "CImaintainHoldsV5Response": {         "nbsapdpo": {             "version": "",             "returnCode": "0",             "reasonCode": "0",             "serviceVersion": "BUSO004",             "echoKey": ""         },         "nbsmsgo3": {             "version": "",             "sysErrTxt": "*EXCEPTION* 09/09/2019  9:29:04. EXCP CODE: 0001. IN PGM: RZPMG0C .   LABEL/SECTION: GRA000  . CALLING PGM: NBM102D .                       PROCESS ID: CIM045D                       .                           message target in -RZNGEN-MSG-TARGET- (?   ) is undefined in MG. Input in \"RZSGEN\" of Message Class/Code: CLSMGC01/0167.                   ",             "nbrUserMsgs": "1",             "nbrUserErrs": "1",             "msgEntry": {                 "msgClass": "RZSMGAB",                 "msgCode": "0003",                 "msgErrInd": "E",                 "msgTxt": "A technical/system error has occured ."             }         },         "cip045o": {             "rcode": "0",             "omessage": "",             "nclta521": "0",             "ttlea521": "0",             "cinta521": "",             "surna521": "",             "idrq026d": "",             "dest026d": "",             "dsps026d": "",             "iest026d": "",             "cura026d": "",             "cphy026d": "",             "cemp026d": "",             "gadd026d": "",             "apdb026d": "",             "apdt026d": "0",             "codb026d": "",             "codt026d": "0",             "mcom026d": "",             "ocst026d": "0",             "ibrAffected": "",             "inBusinessRescue": "",             "placedBy": "0",             "dateBusRescueIss": "0",             "clcdo": "",             "secia521": "",             "chnoa521": "0",             "idCnt": "0",             "forensicHoldOut": "",             "finCrimeHoldOut": "",             "clntAgrmntIssuedOut": ""         }     } }' );
        response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING_Hold)
        {
           response.setBody( '{  	"CImaintainHoldsV5Response": {  		"nbsapdpo": {  			"version": "",  			"returnCode": "0",  			"reasonCode": "0",  			"serviceVersion": "BUSO004",  			"echoKey": ""  		},  		"nbsmsgo3": {  			"version": "",  			"sysErrTxt": "",  			"nbrUserMsgs": "0",  			"nbrUserErrs": "0"  		},  		"cip045o": {  			"rcode": "0",  			"omessage": "",  			"nclta521": "2301",  			"ttlea521": "0",  			"cinta521": "",  			"surna521": "NOZENZO (PTY) LTD",  			"idrq026d": "N",  			"dest026d": "N",  			"dsps026d": "N",  			"iest026d": "N",  			"cura026d": "N",  			"cphy026d": "N",  			"cemp026d": "N",  			"gadd026d": "N",  			"apdb026d": "N",  			"apdt026d": "0",  			"codb026d": "N",  			"codt026d": "0",  			"mcom026d": "N",  			"ocst026d": "0",  			"ibrAffected": "N",  			"inBusinessRescue": "N",  			"placedBy": "0",  			"dateBusRescueIss": "0",  			"clcdo": "NOZENZO001",  			"secia521": "N",  			"chnoa521": "0",  			"idCnt": "0",  			"forensicHoldOut": "N",  			"finCrimeHoldOut": "Y",  			"clntAgrmntIssuedOut ": "N "  		}  	}  }'   );
            response.setStatusCode(400);
        }
        else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS)
        {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response; 
    }
}