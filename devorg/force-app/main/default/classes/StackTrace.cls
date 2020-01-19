public class StackTrace {
    public static String getCurrrentLine(String trace)
    {
    	return trace.substringAfter(':');
	}
    public static String getClassName(String trace)
	{
    	return trace.substringBefore(':').substringBeforeLast('.');
	}
	public static String getCurrrentMethod(String trace)
	{
    	return trace.substringBefore(':').substringAfterLast('.');
	}

}