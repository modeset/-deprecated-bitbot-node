# wit has been slightly trained to locate search terms. this could be expanded on for
#   local_search_query (eg. flower shop, places to eat)
#   wikipedia_search_query
#   wolfram_search_query
# ideas
#   if you ask the bot a question that isn't understood, or is mapped to searching, it would hit the various endpoints
#   and display the results.


#function FirstGoogleImage($term) {
#$url	= "http://images.google.com/images?hl=en&tbs=isch%3A1&sa=1&q=$term&btnG=Search&aq=f&aqi=&aql=&oq=&gs_rfai=&start=0";
#if (function_exists('curl_init')) {
#$ch		= curl_init($url);
#  @curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)');
#  @curl_setopt($ch, CURLOPT_HEADER, 0);
#  @curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
#  @curl_setopt($ch, CURLOPT_REFERER, 'http://www.google.com/');
#  $str	= @curl_exec($ch);
#}
#else { $str	= @file_get_contents($url); }
#preg_match('/<img src=http:\/\/(.*).gstatic.com\/images\?q=tbn:(.*):(.*) /iU', $str, $matches);
#return rawurldecode(rawurldecode($matches[3]));
#}
