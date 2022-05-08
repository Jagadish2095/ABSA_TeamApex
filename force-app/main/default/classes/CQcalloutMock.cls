global class CQcalloutMock implements HttpCalloutMock{

    public String responseBody;
    public Integer statusCode;
    
    public CQcalloutMock(String responseBody, Integer statusCode) {
        this.responseBody = responseBody;
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest request) {


        String status = statusCode == 200 ? 'OK' : 'Bad Request';


        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(statusCode);

        response.setStatus(status);


        return response;
    }
}