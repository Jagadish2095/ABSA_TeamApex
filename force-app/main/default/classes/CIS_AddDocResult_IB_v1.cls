/**
 * @description       : Add Document Result class for CIS
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 2021-11-11
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log
 * Ver   Date         Author              Modification
 * 1.0   2021-05-24   Mohammed Junaid U   Initial Version
**/

public class CIS_AddDocResult_IB_v1 extends Base_IB{

    public String Pid;
    public AddResult AddResult;
    public OcrDocResults OcrDocResults;
    /**
     * @description
     */
	public class OcrDocResults{
		public String ClientName;
		public String TypeOfIdDocument;
		public String StreetName;
		public String PlaceOfBirth;
		public String City;
		public String DateOfDeath;
		public String Suburb;
		public String FathersIdNumber;
		public String PostalCode;
		public String FathersSurname;
		public String AIorPORStatus;
		public String FathersName;
		public String Details;
		public String MothersIdNumber;
		public String ConfidenceMessage;
		public String MothersSurname;
		public String AcctNr;
		public String MothersName;
		public String average_accuracy;
		public String ExpiryDate;
		public String cause_of_death;
		public String NameAndSurname;
		public String child_date_of_birth;
		public String Gender;
		public String child_id_number;
		public String FacialRecognitionResult;
		public String coordinates_x1;
		public String Confidence;
		public String coordinates_x2;
		public String ContryOfBirth;
		public String coordinates_y1;
		public String DateOfIssue;
		public String coordinates_y2;
		public String DateOfBirth;
		public String country_of_birth;
		public String Surname;
		public String dataRef;
		public String Name;
		public String PORDate;
		public String IdNumber;
		public String date_of_birth;
		public String DocumentPID;
		public String date_of_issue;
		public String DocumentURL;
		public String id_number;
		public String DocumentTypeDescription;
		public String initials;
		public String DocumentSubType;
		public String sex;
		public String DocumentType;
		public String error;
		public String IdNr;
		public String facialMatch;
		public String CIFNr;
		public String facialResult;
		public String BusinessUnit;
		public String NameCheckDHA;
		public String TransactionNature;
		public String names;
		public Boolean ImagingProcessingRequired;
		public String nationality;
		public Boolean IsFromGoldenSource;
		public String PlaceofDeath;
		public String DocumentUploadDate;
		public String SurnameCheckDHA;
		public String VerificationStatus;
		public String type;
		public String IdentificationType;
		public String weighted_accuracy;
		public String DocumentGUID;
		public String Date_Validity;
		public String DocumentStore;
		public String DocumentName;
		public String DocumentContext;
		public String MimeType;
		public String SUIN;
		public String DocPackType;
		public String Origin;
		public String CaseName;
		public String CaseAddress;
		public String CaseSurname;
	}
    /**
     * @description
     */
    public class AddResult {
        public String Status;
    	public String Detail;
    }
    /**
     * @description contructor
     */
    public CIS_AddDocResult_IB_v1(){}
}