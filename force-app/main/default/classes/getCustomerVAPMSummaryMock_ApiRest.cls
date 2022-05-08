@isTest
global class getCustomerVAPMSummaryMock_ApiRest implements HttpCalloutMock{

	Private String typeTest;
	global getCustomerVAPMSummaryMock_ApiRest(final String typeTest){
		this.typeTest = typeTest;
	}

	global HttpResponse respond(HttpRequest request){
		//Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');
		if(typeTest == StringConstants.POSITIVE_STRING){
			String sampleResponse = '{"GetCustomerVapmSummaryResponse": {"GetCustomerVapmSummaryResult": {"IsSuccess": "1", "ResultCode": "Success","CustomerVapmSummary": {"CustomerVapmSummaryDto": [{"CustomerGroupLeaderKey": "IMSOLUT018","CustomerKey": "AMSYSTE020","CustomerValue2MonthsAgo": "-4688.1","CustomerValueLastMonth": "5963.8","GroupValue2MonthsAgo": "-8785.24","GroupValueLast12Months": "-48852.52","GroupValueLast24Months": "-534668.79","GroupValueLastMonth": "1777.87","InformationDate": "2018-12-31T00:00:00","ItemCode": "VAPM","ItemDesc": "VAPM"}]}}}}';
			response.setBody(sampleResponse);
			response.setStatusCode(200);
		}else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
	}

}