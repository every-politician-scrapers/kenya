module.exports = (county, name) => {
  claims = {
    P31:   'Q294414', // instance of: public office
    P279:  'Q111233853',
    P1001: county
  }

  return {
    type: 'item',
    labels: { en: `Deputy Governor of ${name}` },
    claims: claims
  }
}
