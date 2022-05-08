/*
 * ExergyLoginController class for Generating Session ID
 * @author chandra Bhushan Singh
 * @created 2021-02-09
 */

public class ExergyLoginController {
    public static String getSessionId() {

        if (Cache.Session.contains('local.Customer1Cache.exergySessionId')) {
            return (String) Cache.Session.get('local.Customer1Cache.exergySessionId');

        } else {
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.convertToHex(b);
            String guid = h.SubString(0, 8) + '-' + h.SubString(8, 12) + '-' + h.SubString(12, 16) + '-' + h.SubString(16, 20) + '-' + h.substring(20);
            ExergyLogin_Resp_IB_v1 response = ExergyLogin_IH_v1.exergyLogin(guid);

            if (response != null && response.LoginResponse != null && response.LoginResponse.LoginResult != null) {
                if (response.statusCode != 200 || Integer.valueOf(response.LoginResponse.LoginResult) != 0) {
                    throw new AuraHandledException('Exergy login failed. Response: ' + JSON.serialize(response));
                }
            }


            Cache.Session.put('local.Customer1Cache.exergySessionId', guid);

            return guid;
        }
    }
}