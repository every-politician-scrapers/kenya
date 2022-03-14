module.exports = (id, position, startdate, enddate) => {
  qualifier = {
    P580: '2013-03-27',
    P582: '2017-08-08',
  }

  if(startdate) qualifier['P580'] = startdate
  if(enddate)   qualifier['P582'] = enddate

  return {
    id,
    claims: {
      P39: {
        value: position,
        qualifiers: qualifier,
        references: {
          P4656: 'https://en.wikipedia.org/w/index.php?title=Counties_of_Kenya&oldid=793482520',
          P813: new Date().toISOString().split('T')[0],
        }
      }
    }
  }
}
