/**
 * @description ECM_IH_V1Test Description
 *
 */
@isTest
public class ECM_IH_V1Test{
	@isTest
	public static void shouldLoginWithValidCredentials(){
		insertSettings();
		String body = '{"LoginResult" : {"Status" : "OK", "Details" : "null"}, "Token" : "1234567890"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		ECM_LoginResult_IB_V1 result = ECM_IH_V1.login('DGOLSDB', 'DEV_TestUser', 'D3vT#sting');
		System.assertNotEquals(null, result);
		System.assertEquals('OK', result.LoginResult.Status);
		System.assertEquals('1234567890', result.Token);
		Test.stopTest();
	}

	// @isTest
	//public static void shouldNotLoginWithInvalidCredentials() {
	//}
	@isTest
	public static void shouldLogoutToken(){
		insertSettings();
		String token = '1234567890';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		ECM_LogoutResult_IB_V1 result = ECM_IH_V1.logout(token);
		System.assert(result != null);
		System.assert(result.status == 'Ok');
		System.assert(result.detail == 'detail');
		Test.stopTest();
	}

	@isTest
	public static void shouldGetItemTypeWithValidName(){
		insertSettings();
		String token = '1234567890';
		String name = 'Will';
		String body = '{"getItemTypeResult" : {"Status" : "Ok", "Detail" : "detail"}}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		ECM_GetItemTypeResult_IB_V1 result = ECM_IH_V1.getItemType(token, name);
		System.assert(result != null);
		System.assert(result.getItemTypeResult != null);
		System.assert(result.getItemTypeResult.status == 'Ok');
		System.assert(result.getItemTypeResult.detail == 'detail');
		Test.stopTest();
	}

	@isTest
	public static void shouldNotGetItemTypeWithInvalidName(){
		insertSettings();
		String token = '1234567890';
		String name = 'Will';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		system.assertNotEquals(null, ECM_IH_V1.getItemType(token, name));
		Test.stopTest();
	}

	@isTest
	public static void shouldGetItemTypesWithValidToken(){
		insertSettings();
		String token = '1234567890';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		system.assertNotEquals(null, ECM_IH_V1.getItemTypes(token));
		Test.stopTest();
	}

	@isTest
	public static void shouldNotGetItemTypeWithInvalidToken(){
		insertSettings();
		String token = '1234567890';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		system.assertNotEquals(null, ECM_IH_V1.getItemTypes(token));
		Test.stopTest();
	}

	@isTest
	public static void shouldGetDocumentWithValidPid(){
		insertSettings();
		String token = '1234567890';
		String pid = '1234567890';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		system.assertNotEquals(null, ECM_IH_V1.getDocument(token, pid));
		Test.stopTest();
	}

	@isTest
	public static void shouldNotGetDocumentWithInvalidPid(){
		insertSettings();
		String token = '1234567890';
		String pid = '1234567890';
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		system.assertNotEquals(null, ECM_IH_V1.getDocument(token, pid));
		Test.stopTest();
	}

	@isTest
	public static void shouldUploadDocumentToEcm(){
		insertSettings();
		String body = '{"Status" : "Ok", "Detail" : "detail"}';
		Test.setMock(HttpCalloutMock.class, new ECM_Mock_ApiRest(body));
		Test.startTest();
		ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
		ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
		request.Token = 'd2CyAwniCWSOJvqJSi+fhNoaYuBMPWLoyG9wetxzSJeeCdwEONWDCl1vygfQ1E9oHvg+9CKckSuI@!@!@!@r@!@!@!@nAJjCR7afQw==';
		request.ItemType = 'Will';
		request.FileName = 'another-test.txt';
		request.addFieldValue('WillNo', '098765');
		request.addFieldValue('FilingDate', '12/12/2018');
		request.addFieldValue('IdNr', '8511135841180');
		request.Data = EncodingUtil.base64Encode(Blob.valueOf('test'));
		req.AddRequest = request;
		system.assertNotEquals(null, ECM_IH_V1.addDocument(req));
		Test.stopTest();
	}

	@isTest
	public static void testBeans(){
		insertSettings();
		ECM_GetItemTypesResult_IB_V1 result = new ECM_GetItemTypesResult_IB_V1();
		result.getItemTypesResult = new ECM_GetItemTypesResult_IB_V1.GetItemTypesResult();
		result.getItemTypesResult.status = 'Ok';
		result.getItemTypesResult.detail = 'Details';
		//
		ECM_GetItemTypesResult_IB_V1.ECM_Field field = new ECM_GetItemTypesResult_IB_V1.ECM_Field();
		field.name = 'name';
		field.Type = 'type';
		field.size = 'size';
		field.nullable = 'nullable';
		field.unique = 'unique';
		field.description = 'description';
		//
		ECM_GetItemTypesResult_IB_V1.ECM_ItemType itemType = new ECM_GetItemTypesResult_IB_V1.ECM_ItemType();
		itemType.name = '';
		itemType.description = '';
		itemType.Fields = null;
		//
		ECM_AddResult_IB_V1.getExample();
		//
		ECM_LogoutResult_IB_V1.getExample();
		//
		ECM_GetResult_IB_V1.getExample();
		//
		ECM_GetItemTypesRequest_IB_V1.getExample();
		system.assertNotEquals(null, ECM_GetItemTypeRequest_IB_V1.getExample());
	}

    /**
     * @description insertSettings description
     *
     */
	public static void insertSettings(){
		List<String> endpoints = new List<String>();
		endpoints.add('ECM Query Path');
		endpoints.add('ECM Authenication Path');
		endpoints.add('ECM Add Path');
		endpoints.add('ECM Logout Path');
		endpoints.add('ECM GetItemType Path');
		endpoints.add('ECM Get Path');
		endpoints.add('ECM GetItemTypes Path');
		IntegrationTestDataFactory.insertIntegrationSettings('API Manager', endpoints);
		IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
	}

    /**
     * @description ECM_Mock_ApiRest Description
     *
     */
	public class ECM_Mock_ApiRest implements HttpCalloutMock{
/**
 * @description description
 */
        public String body{ get; set; }
/**
 * @description ECM_Mock_ApiRest description
 *
 */
		public ECM_Mock_ApiRest(){
		}
/**
 * @description ECM_Mock_ApiRest description
 *
 * @param body (String): body
 */
		public ECM_Mock_ApiRest(String body){
			this.body = body;
		}
/**
 * @description respond
 * @param request
 * @return HTTPResponse
 */
		public HTTPResponse respond(HTTPRequest request){
			HTTPResponse response = new HTTPResponse();
			response.setStatusCode(200);
			response.setBody(body);
			response.setHeader('Content-Type', 'application/json');
			return response;
		}
	}
}