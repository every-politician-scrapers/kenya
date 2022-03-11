const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, party, constituency, start_date, end_date) => {
  qualifier = {
    P2937: meta.term.id,
  }
  if(start_date)   qualifier['P580']  = start_date
  if(end_date)     qualifier['P582']  = end_date
  if(party)        qualifier['P4100'] = party
  if(constituency) qualifier['P768']  = constituency

  return {
    id,
    claims: {
      P39: {
        value: meta.position,
        qualifiers: qualifier,
        references: { P4656: meta.source }
      }
    }
  }
}
