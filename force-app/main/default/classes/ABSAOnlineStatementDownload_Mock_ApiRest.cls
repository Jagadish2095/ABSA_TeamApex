/*
 * Mock ApiRest Bean for ABSAOnlineStatementSearch service
 * @author Srikanth N
 * @created 2019-09-16
 */

@IsTest
global class  ABSAOnlineStatementDownload_Mock_ApiRest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        return null;
    }
}