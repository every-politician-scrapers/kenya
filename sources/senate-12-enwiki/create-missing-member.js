const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = (label,party,gender) => {
  mem = {
    value: meta.position,
    qualifiers: {
      P2937: meta.term.id,
      P4100: party,
    },
    references: { P854: meta.source }
  }

  claims = {
    P31: { value: 'Q5' }, // human
    P106: { value: 'Q82955' }, // politician
    P39: mem,
  }
  if(gender == 'male')   claims['P21'] = 'Q6581097';
  if(gender == 'female') claims['P21'] = 'Q6581072';

  return {
    type: 'item',
    labels: { en: label },
    descriptions: { en: 'Kenyan politician' },
    claims: claims,
  }
}
