/**
* Apex Integration Mock response class for CMS  Integration service
* @author  Diksha Wasekar : Absa
* @since   2019-09-07
*
**/

@isTest
global class CMSServiceMock_ApiRest implements HttpCalloutMock{
    
    Private String typeTest;
    
    global CMSServiceMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    global HttpResponse respond(HttpRequest request){
    //Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');
         if(typeTest == StringConstants.POSITIVE_STRING)
        {
			response.setBody('{"Body":{"GBlistCmsContOffPerClntV2Response":{"gsp019o":{"contOffDet":[{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"CM","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"PB","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"WP","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"BM","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"CA","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"TB","indvGroup":"I","branchCode":"8838"},{"coEmployeeNum":"9016067","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"0","businessSubSeg":"","businessSeg":"","overallControl":"0","divisionCode":"AAS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"8","contOffType":"BB","indvGroup":"I","branchCode":"9729"},{"coEmployeeNum":"66990","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"0","businessSubSeg":"","businessSeg":"","overallControl":"0","divisionCode":"AAS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"55","contOffType":"FP","indvGroup":"I","branchCode":"9729"},{"coEmployeeNum":"9052048","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"0","businessSubSeg":"","businessSeg":"","overallControl":"0","divisionCode":"AAS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"20","contOffType":"SBMM","indvGroup":"I","branchCode":"9729"},{"coEmployeeNum":"2697052","exposurePolicy":"","groupReviewDate":"0","franchisorCode":"7","businessSubSeg":"F","businessSeg":"M","overallControl":"7554","divisionCode":"ABS","dateApproved":"16082007","appByEmployee":"9008837","lastAction":"A","dateCreated":"16082007","capByEmployee":"598305","contOffNum":"96","contOffType":"RM","indvGroup":"I","branchCode":"8838"}],"noOfOccurences":"4"},"nbsmsgo3":{"nbrUserErrs":"0","nbrUserMsgs":"0","sysErrTxt":"","version":""},"nbsapdpo":{"echoKey":"","serviceVersion":"BUSO002","reasonCode":"0","returnCode":"0","version":""}}}}');
            response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING)
        {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
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