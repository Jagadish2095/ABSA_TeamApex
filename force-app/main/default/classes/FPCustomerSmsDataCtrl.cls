public class FPCustomerSmsDataCtrl {

    public String PDFData {get;set;}
    public string sdomainUrl {get;set;}
    public JSON2Apex responseB {get;set;}

    public class JSON2Apex {

        public String timeCaptured;
        public String noOfLines;
        public List<Comments> comments;
    }
        public class Comments {
            public String commentLineNo;
            public String commentText;
        }
        public static JSON2Apex parse(String PDFData) {
            return (JSON2Apex) System.JSON.deserialize(PDFData, JSON2Apex.class);
        }

    /*
    public static FromJson parse(string PDFData) {
        FromJson responseB = (FromJson) System.JSON.deserialize(PDFData,FromJson.class);
        system.debug('comments'+responseB);
        return responseB;
    }
	 public static List<FromJson> parse(String PDFData) {
        system.debug((List<FromJson>) System.JSON.deserialize(PDFData, List<FromJson>.class));
		return (List<FromJson>) System.JSON.deserialize(PDFData, List<FromJson>.class);
	}
       */
     public  FPCustomerSmsDataCtrl(){
        string sfurl= URL.getSalesforceBaseUrl().getHost().replace('--c.visualforce.com','.lightning.force.com');
          sdomainUrl = 'https://'+ sfurl;
          //responseB = (JSON2Apex) System.JSON.deserialize(PDFData, JSON2Apex.class);
    }
         public PageReference downloadPDF(){
             System.PageReference pageRef = new System.PageReference('/apex/FPCustomerSmsPDFGenerator');

             //ensure pdf downloads and is assigned with defined name
             pageRef.getHeaders().put('content-disposition', 'attachment; filename=CommentsPDF.pdf');

             return pageRef;
         }
         public PageReference downloadword(){
             System.PageReference pageRef = new System.PageReference('/apex/FPCustomerSmsWordGenerator');

             //ensure pdf downloads and is assigned with defined name
             pageRef.getHeaders().put('content-disposition', 'attachment; filename=commentsWord.doc');

             return pageRef;
         }
}
