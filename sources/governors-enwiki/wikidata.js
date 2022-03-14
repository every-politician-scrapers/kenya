module.exports = function () {
  return `SELECT ?county ?countyLabel ?governor ?governorLabel ?start
    WHERE {
      ?county wdt:P31 wd:Q269218 ; wdt:P1313 ?office .
      OPTIONAL {
        ?governor p:P39 ?ps .
        ?ps ps:P39 ?office ; pq:P580 ?start .
        OPTIONAL { ?ps pq:P582 ?end }
        FILTER (!BOUND(?end) || (?end >= NOW()))
      }
      SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
    }
    # ${new Date().toISOString()}
    ORDER BY ?countyLabel ?governorLabel ?start`
}
