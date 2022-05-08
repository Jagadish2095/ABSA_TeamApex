/*
 * Mock ApiRest Bean for ABSAOnlineStatementDetailsSearch service
 * @author Srikanth N
 * @created 2019-09-16
 */

@IsTest
global class  ABSAOnlineStatementSearch_Mock_ApiRest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        return null;
    }
}