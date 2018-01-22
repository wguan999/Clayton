public class HtmlToText {
    public static string convert(string html) {
        return html.replaceAll('<[bB][rR].*?/>', '\n')
                   .replaceAll('<[pP].*?/>', '\n\n')
                   .replaceAll('<[iI][mM][gG].*?[iI][mM][gG]>', '')
                   .replaceAll('<.*?>','')
                   .unescapeHtml4();
    }
}