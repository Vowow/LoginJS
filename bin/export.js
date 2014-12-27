require('coffee-script/register')

var argv = require('minimist')(process.argv.slice(2));
var myexport = require('../lib/export');
var db = require('../lib/db');
var client = db("./DB", {
  valueEncoding: 'json'
});
if (argv.help) {
  console.log("Pour utiliser la fonction d'import il faut ajouter l'argument --format suivi de csv ou json\n"
  + "exemple : node bin/start --format csv\n" + "ceci va importer dans la base de donner un fichier csv");
}
else if (argv.format == "csv") {
  var output, firstname, i, j, lastname, max, password, username;
  output = [];
  client.users.getAll(function(outputBdd) {

    i = 0;
    j = parseInt(outputBdd.length / 4);
    max = outputBdd.length - j;
    m=0
    while (m<outputBdd.length){
      m++;
    }
    while (i < max) {
      username = outputBdd[0][0];
      lastname = outputBdd[1][1];
      firstname = outputBdd[2][1];
      password = outputBdd[3][1];
      email = outputBdd[4][0];
          output.push([username,firstname,lastname,email,password]);

      i = i + 4
    }
    expt = myexport(output, "csv");
    console.log("L'export a été réalisé avec succès\nLa base de donnée est dans le dossier DB");
    return expt.exportUser(output);

  });
}
else if (argv.format == "json") {
  var output, firstname, i, j, lastname, max, password, username;
  output = [];
  client.users.getAll(function(outputBdd) {

    i = 0;
    j = parseInt(outputBdd.length / 4);
    max = outputBdd.length - j;
    m=0
    while (m<outputBdd.length){
      m++;
    }
    while (i < max) {
      username = outputBdd[0][0];
      lastname = outputBdd[1][1];
      firstname = outputBdd[2][1];
      password = outputBdd[3][1];
      email = outputBdd[4][0];
      var item = {
        "username": username,
        "email": email,
        "password": password,
        "firstname": firstname,
        "lastname": lastname
      };

      output.push(item);

      i = i + 4
    }
    expt = myexport(output, "json");
    console.log("L'export a été réalisé avec succès\nLa base de donnée est dans le dossier DB");
    return expt.exportUser(output);

  });
}
else {
  console.log("Erreur : veuillez indiquer un format valide, consulter l'aide (--help)")
}
