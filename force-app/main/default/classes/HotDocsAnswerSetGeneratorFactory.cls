public class HotDocsAnswerSetGeneratorFactory {
	
	public static HotDocsAnswerSetGenerator getInstance(String generator, Map<String, Object> context, String answers) {
		Type t = Type.forName(generator);
		HotDocsAnswerSetGenerator gen = (HotDocsAnswerSetGenerator) t.newInstance();
		gen.setContext(context);
		gen.setAnswers(answers);
		return gen;
	}
}