xquery version "3.1";

module namespace xoai="https://ulb.tu-darmstadt.de/ns/xoai";

declare namespace oai    = "http://www.openarchives.org/OAI/2.0/";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace rest   = "http://exquery.org/ns/restxq";

import module namespace hc      = "http://expath.org/ns/http-client"   at "java:org.expath.exist.HttpClientModule";

declare
  %rest:GET
  %rest:path("xoai/listRecords")
  %rest:query-param("url", "{$url}", "")
  %rest:query-param("set", "{$set}", "")
  function xoai:listRecords ( $url as xs:string*, $set as xs:string*) as element() {
  let $host := util:unescape-uri($url, "utf-8"),
      $results := xoai:requestListRecords($host, $set, "")
  
  return
    <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
      { $results[1]/oai:responseDate, $results[1]/oai:request }
      <ListRecords>
        { $results//oai:record }
      </ListRecords>
    </OAI-PMH>
};

declare %private function xoai:requestListRecords ( $host as xs:string*, $set as xs:string*, $token as xs:string* ) as element()* {
  let $requestUrl := if ( string-length($token) gt 0 )
    then $host || "?verb=ListRecords&amp;resumptionToken=" || $token
    else $host || "?verb=ListRecords&amp;set=" || $set || "&amp;metadataPrefix=mets"
  
  let $request := <hc:request method="GET" href="{$requestUrl}" />,
      $response := hc:send-request($request)/oai:OAI-PMH,
      $newToken := $response//oai:resumptionToken
  
  return if ( $newToken )
    then ($response, xoai:requestListRecords($host, "", $newToken))
    else $response
};
