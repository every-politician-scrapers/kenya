const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,constituency,party) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P2937: meta.term.id,
      P4100: party,
    },
    references: { P4656: meta.source }
  }
  if(party)   mem['qualifiers']['P768'] = party

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }

  return {
    type: 'item',
    labels: { en: label },
    descriptions: { en: 'Kenyan politician' },
    claims: claims,
  }
}
