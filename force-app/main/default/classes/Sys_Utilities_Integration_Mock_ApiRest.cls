/*
 * Generic and reusable Mock ApiRest class
 * @author Prashant Jain
 * @created 2020-05-22
 */

@isTest
global class Sys_Utilities_Integration_Mock_ApiRest implements HttpCalloutMock {
    private String requestBody;
    private String typeTest;

    global Sys_Utilities_Integration_Mock_ApiRest(final String typeTest, final String requestBody) {
        this.typeTest = typeTest;
		this.requestBody = requestBody;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, StringConstants.APPLICATION_JSON_STRING);

        if (String.isNotBlank(requestBody)) {
            response.setBody(requestBody);
        } else {
            response.setBody('{}');
        }

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setStatusCode(400);
        } else if (typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
            response.setStatusCode(500);
        }
        return response;
    }

    global static StaticResourceCalloutMock getStaticResourceCalloutMock(String typeTest, String staticResourceName) {
        StaticResourceCalloutMock staticResourceCalloutMock = new StaticResourceCalloutMock();
        staticResourceCalloutMock.setStaticResource(staticResourceName);
        staticResourceCalloutMock.setHeader(StringConstants.CONTENT_TYPE_STRING, StringConstants.APPLICATION_JSON_STRING);

        if (typeTest == StringConstants.POSITIVE_STRING) {
            staticResourceCalloutMock.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            staticResourceCalloutMock.setStatusCode(400);
        } else if (typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS) {
            staticResourceCalloutMock.setStatusCode(500);
        }
        return staticResourceCalloutMock;
    }
}