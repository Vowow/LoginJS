require('coffee-script/register')

var argv = require('minimist')(process.argv.slice(2));

if (argv.help) {
  console.log("Pour utiliser la fonction d'import il faut ajouter l'argument --format suivi de csv ou json\n"
  	+ "exemple : node bin/start --format csv\n" + "ceci va importer dans la base de donner un fichier csv");
}
else if (argv.format == "csv") {
var importCSV, impdb, db;
importCSV = require('../lib/import');
db = require('../lib/db');
global.mydb = db("./DB", {
  valueEncoding: 'json'
});
impdb = importCSV(mydb);
impdb.importUser();
//mydb.close();
}
else if (argv.format == "json") {
	console.log("json")
}
else {
	console.log("Erreur : veuillez indiquer un format valide, consulter l'aide (--help)")
}