const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (id, constituency, party) => {
  qualifier = {
    P2937: meta.term.id,
  }
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
