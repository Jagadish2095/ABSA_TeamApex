/**
* @description EcmDocuments
* @author  Khaliq Abdul
* @created 2021-02-04
*/
public without sharing class EcmDocuments {
		/**
* @description UploadMSG
*/
		public String UploadMSG;
		public String ECMPID;
		public String DocumentType;
		public String DocumentSubType;
		public String DocumentGUID;
		public String DocumentCode;
    /**
* @description parse
* @param json
* @return EcmDocuments
*/
	public static EcmDocuments parse(String json) {
		return (EcmDocuments) System.JSON.deserialize(json, EcmDocuments.class);
	}

}