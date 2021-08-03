xquery version "3.1";

module namespace xoai="https://ulb.tu-darmstadt.de/ns/xoai";

declare namespace rest   = "http://exquery.org/ns/restxq";



declare
  %rest:GET
  %rest:path("xoai/{$request}")
  %rest:query-param("verb", "{$verb}", "GetRecord")
  %rest:query-param("set", "{$set}", "")
  %rest:query-param("identifier", "{$identifier}", "")
  function xoai:getOAI ( $request as xs:string, $verb as xs:string*, $set as xs:string*, $identifier as xs:string* )  {
    let $url := util:unescape-uri($request, "utf-8"),
        $id := util:unescape-uri($identifier, "utf-8")
    
    return switch ( $verb )
      case "ListRecords"
        return xoai:ListRecords($url, $set)
      case "GetRecord"
        return xoai:GetRecord($url, $id)
      default return <error>Unknown verb: {$verb}</error>
};

declare function xoai:ListRecords ( $url, $set ) {
  true()
};

declare function xoai:GetRecord ( $url, $identifier ) {
  true()
};
