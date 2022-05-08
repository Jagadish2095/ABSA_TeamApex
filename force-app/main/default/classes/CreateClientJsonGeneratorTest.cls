@IsTest
public class CreateClientJsonGeneratorTest {
    
    @IsTest
    public static void shouldGenerateJson() {
		String request = '{"CIcreateClientV12":{"nbsmsgi":{"msgTarget":"STD","msgLanguage":"E","finalMsgId":{"finalMsgCode":"","finalMsgClass":""}},"nbsapdpi":{"trace":"N","channel":"SALESFORCE","application":"Salesforce"},"cib003i":{"workTelephone":"2323233","workTelCode":"075","titleCode":"1","tellerLastChanged":"0000003","surname":"DE BRUIN","secondaryCard":"Y","prefrdCommtionMthd":"2","postlTown":"MIDRAND","postlCodeRsa":"1682","postlAddrLine2":"MIDRAND","postlAddrLine1":"PO BOX 50709","physicalTown":"HOUGHTON","physicalPostal":"2198","physicalAddrType":"10","physicalAdd2":"HOUGHTON","physicalAdd1":"40 EIGHTH STREET","occupationStatus":"4","occupationCode":"0","occupancyType":"0","language":"E","initials":"KP","idType":"1","idNumber":"4907195029089","homeTelephone":"9335343","homeTelCode":"073","homeLanguage":"E","gender":"1","foreignTaxData":[],"firstNames":"TEST","emailAddress":"tracy@cloudsmiths.co.za","countryOfOrigin":"SO003","countryOfBirth":"SO003","countryEntOprtData":[],"clientType":"101","clientNationality":"SOU01","cellphone":"0752323233","casaRefNum":"121168548","birthDate":"19490719","agriData":[]}}}';
		CreateClientCIF_Req_IB_v1 obj = (CreateClientCIF_Req_IB_v1) JSON.deserialize(request, CreateClientCIF_Req_IB_v1.class);
		System.assertNotEquals(obj, null);
        System.debug(JSON.serialize(obj, true));
		CreateClientJsonGenerator cj = new CreateClientJsonGenerator();
		String s = cj.toString(obj);
        System.assertNotEquals(s, null);
		System.debug(s);
    }
}