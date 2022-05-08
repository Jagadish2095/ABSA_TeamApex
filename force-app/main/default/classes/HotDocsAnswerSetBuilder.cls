public class HotDocsAnswerSetBuilder {
	
	private AnswerSet answerSet;
	AnswerBuilder answerBuilder;
	
	public HotDocsAnswerSetBuilder title(String title) {
		if (answerSet == null) {
			answerSet = new AnswerSet();
		}
		answerSet.title = title;
		return this;
	}
	
	public HotDocsAnswerSetBuilder version(String version) {
		if (answerSet == null) {
			answerSet = new AnswerSet();
		}
		answerSet.version = version;
		return this;
	}
	
	public AnswerBuilder answers() {
		if (answerBuilder == null) {
			answerBuilder = new AnswerBuilder(this);
		}
		return this.answerBuilder;
	}
	
	public String build() {
		String result = '';
		result += '<AnswerSet title=\'' + answerSet.title + '\' version=\'' + answerSet.version + '\'>';
		for (Answer a : answerSet.answers) {
			result += '<Answer name=\'' + (a.name == null ? '' : a.name.escapeXml()) + '\'>';
			if (a.rpt) {
				result += '<RptValue>';
			}
			if (a.typeValue == TypeValue.MCValue ) {
				for (String val : a.values) {
					result += '<MCValue><SelValue>' + (val == null ? '' : val.escapeXml()) + '</SelValue></MCValue>';
				}
			} else {
				for (String val : a.values) {
					result += '<' + a.typeValue + '>' + (val == null ? '' : val.escapeXml()) + '</' + a.typeValue + '>';
				}
			}
			if (a.rpt) {
				result += '</RptValue>';
			}
			result += '</Answer>';
		}
		result += '</AnswerSet>';
		return result;
	}
	
	public String buildJson() {
		JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
    	gen.writeStringField('Title', answerSet.title);
    	gen.writeStringField('Description', answerSet.title);
    	gen.writeStringField('AnswerSetContent', build());
        gen.writeEndObject();
        return gen.getAsString();
	}
	
	public String buildJson(String answers) {
		JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
    	gen.writeStringField('Title', answerSet.title);
    	gen.writeStringField('Description', answerSet.title);
    	gen.writeStringField('AnswerSetContent', String.isBlank(answers) ? build() : answers);
        gen.writeEndObject();
        return gen.getAsString();
	}
	
	public class AnswerSet {
		String title;
		String version;
		List<Answer> answers = new List<Answer>();
	}
	
	public class Answer {
		
		public Boolean rpt;
		public String value;
		public TypeValue typeValue;
		public String name;
		public List<String> values = new List<String>();
		
		public Answer(Boolean rpt, String value, TypeValue typeValue, String name) {
			this.rpt = rpt;
			this.values.add(value);
			this.typeValue = typeValue;
			this.name = name;
		}
	}
	
	public enum TypeValue {		
		TextValue, NumValue, DateValue, TFValue, MCValue
	}
	
	public class AnswerBuilder {
		
		HotDocsAnswerSetBuilder parent;
		
		public AnswerBuilder(HotDocsAnswerSetBuilder parent) {
			this.parent = parent;
		}
		
		public AnswerBuilder answer(String name, String value, Boolean rpt, TypeValue typeValue ) {
			Answer a = null;
			for (Answer ans : this.parent.answerSet.answers) {
				if (ans.name == name) {
					a = ans;
					break;
				}
			}
			if (a == null) {
				a = new Answer(rpt, value, typeValue, name);
				this.parent.answerSet.answers.add(a);
			} else {
				a.values.add(value);
			}
			return this;
		}
		
		public HotDocsAnswerSetBuilder answerSet() {
			return this.parent;
		}
		
	}
}