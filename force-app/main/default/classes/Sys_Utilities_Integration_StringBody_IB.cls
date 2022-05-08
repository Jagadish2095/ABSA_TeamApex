/*
 * Request/Response Bean for setting Request/Response payloads as String rather than JSON
 * @author  Paul John du Randt : ABSA (IQ Business)
 * @version v1.0
 * @Added   2020-12-11
 *
 * This bean class can be used in situations where the request/response payload is text
 * and not JSON. It would be used in the integrationServiceCall method when a response
 * or request beans should be text and not serialized/deserialized to an object/JSON.
 *
 * 1. To set a custom string as the request body, create an instance of
 *    Sys_Utilities_Integration_StringBody_IB class and store the required custom string in the
 *    body variable. This would cause the contents of the body variable to be used as the
 *    request body rather than the serialized JSON.
 *
 * 2. To receive a custom string as the response body, pass Sys_Utilities_Integration_StringBody_IB.class
 *    as the apexTypeP when calling integrationServiceCall method. This would cause the received
 *    response body to be stored in the body variable rather than deserializing the string.
 */

public class Sys_Utilities_Integration_StringBody_IB extends Base_IB {
    public String body;
}