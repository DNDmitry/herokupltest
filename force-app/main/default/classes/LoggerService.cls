public class LoggerService {
    public static String debug()
    {
        String trace = new DmlException().getStackTraceString().substringAfter('\n');
		system.debug('::::::::::' + trace);        
        String result = StackTrace.getClassName(trace) + ' ' + StackTrace.getCurrrentMethod(trace)+ ' ' + StackTrace.getCurrrentLine(trace);
        return result;
    }

}