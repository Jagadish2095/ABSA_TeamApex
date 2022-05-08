/**
 * @description       :
 * @author            : Khaliq Abdul 
 * 1.0   18-10-2021   Khaliq Abdul   Initial Version
 **/
public without sharing class EcmDocumentList {
/**
 * @description       : DocumentList
 */
  
public class DocumentList {
		public String UploadMSG;
		public String ECMPID;
		public String DocumentType;
		public String DocumentSubType;
		public String DocumentGUID;
		public String DocumentCode;
	}

	public List<DocumentList> DocumentList;

	/**
 * @description       : parse
 * @param ecmDocs
 * @return EcmDocumentList
 */
	public static EcmDocumentList parse(String ecmDocs) {
		return (EcmDocumentList) JSON.deserialize(ecmDocs, EcmDocumentList.class);
	}
}