## Archimista Web

Archimista Web pubblica le tue descrizioni archivistiche prodotte con Archimista.

Demo: [http://archimistaweb.codexcoop.it](http://archimistaweb.codexcoop.it)

## Requisiti

* Ruby 2.1.5
* Rails 3.2.21
* Sphinx 2.2.5 (motore di ricerca testuale)
* Database Archimista 1.2.1 in MySQL >= 5.1
* Webserver configurato per applicazioni Rails

## Installazione

Creare un file di configurazione per il database: config/database.yml.

Installare le dipendenze Rails:

    bundle install

Attivare il motore di ricerca testuale:

    rake thinking_sphinx:configure
    rake thinking_sphinx:rebuild

## Crediti

Archimista Web è sviluppato da [Codex Società Cooperativa](http://www.codexcoop.it), su incarico del Politecnico di Milano.

## Licenza

Archimista Web è rilasciato sotto licenza GNU General Public License v2.0 o successive.
