require('coffee-script/register')

var argv = require('minimist')(process.argv.slice(2));

if (argv.help) {
  console.log("Pour utiliser la fonction d'import il faut ajouter l'argument --format suivi de csv ou json\n"
  	+ "exemple : node bin/start --format csv\n" + "ceci va importer dans la base de donner un fichier csv");
}
else if (argv.format == "csv") {
var importCSV, impdb, db, format;
importCSV = require('../lib/import');
db = require('../lib/db');
global.mydb = db("./DB", {
  valueEncoding: 'json'
});
format = "csv";
impdb = importCSV(mydb, format);
impdb.importUser();
}
else if (argv.format == "json") {
  var importCSV, impdb, db, format;
  importCSV = require('../lib/import');
  db = require('../lib/db');
  global.mydb = db("./DB", {
    valueEncoding: 'json'
  });
  format = "json";
  impdb = importCSV(mydb, format);
  impdb.importUser();
}
else {
	console.log("Erreur : veuillez indiquer un format valide, consulter l'aide (--help)")
}
