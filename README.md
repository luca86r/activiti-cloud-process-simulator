*Moved to https://github.com/intesys/activiti-cloud-process-simulator*

# activiti-cloud-process-simulator
Simula l'esecuzione di un processo con Activiti Cloud

# Il processo
Il BPMN d'esempio è relativo al processo di recruitment di una software house.

## Attori
- Ufficio HR (gruppo "hr"); rappresenta l'ufficio per le risorse umane; si compone dei seguenti utenti:
	+ hr_user_1 
	+ hr_user_2
	+ hr_user_3
- Ufficio Tecnico (gruppo "tech"); rappresenta l'insieme delle persone con un profilo tecnico; si compone dei seguenti utenti:
	+ tech_user_1
	+ tech_user_2
- Responsabile delle risorse umane (utente "hr_manager").

Tutti gli utenti coinvolti nella simulazione hanno la stessa passowrd: "password".

## BPMN
Nella simulazione sono presenti due versioni di processo.

### Versione "simple"
![BPMN versione simple](https://raw.githubusercontent.com/luca86r/activiti-cloud-process-simulator/main/runtime-bundle/src/main/resources/processes/recruiting-hr-simple.svg "BPMN versione simple")


### Versione "complex"
![BPMN versione complex](https://raw.githubusercontent.com/luca86r/activiti-cloud-process-simulator/main/runtime-bundle/src/main/resources/processes/recruiting-hr-complex.svg "BPMN versione complex")


# Architettura
L'architettura del simulatore è la seguente:
![Architettura](https://github.com/luca86r/activiti-cloud-process-simulator/raw/main/components_diagram.png "Architettura")


# Configurazione ed esecuzione
La procedura di configurazione ed esecuzione del simulatore è strutturata per un ambiente Linux ma può essere facilmente replicata anche su macOS e Windows (quest'ultimo ad esempio mediante WSL).

## Requisiti
Per configurare ed eseguire il simulatore è necessario avere installato e configurato i seguenti software:
- docker
- docker-compose
- maven
- openjdk v11
- browser web (es. Firefox)

## Preparativi
- Clonare il presente repository git.
- Identificare un IP da usare per la configurazione del simulatore; per permettere la corretta comunicazione tra i container definiti nella simulazione è necessario definire un IP (non localhost o 127.0.0.1); questo IP potrebbe ad esempio essere quello dell'interfaccia di rete LAN o wireless. Negli successivi step di configurazione configurare questo IP ad ogni occorrenza della stringa *CLUSTER_IP_CHANGEME*.

## Build runtime-bundle
Compilare e generare l'immagine docker del runtime bundle mediante i seguenti comandi:
```bash
cd activiti-cloud-process-simulator
cd runtime-bundle
mvn clean package
```

## Avvio container di supporto alla simulazione
```bash
cd activiti-cloud-process-simulator
cd docker-compose

# Modificare il file .env sostituendo l'IP del cluster al posto della stringa CLUSTER_IP_CHANGEME
vi .env

# Avvio della configurazione docker-compose
docker compose up -d
```

## Avvio simulatore jmeter
Avviare la simulazione jmeter.
Lo script "run_jmeter.sh" permette l'avvio della simulazione e la configurazione dei seguenti parametri:
- "-i": imposta l'IP del cluster di servivi docker
- "-h": imposta il numero di utenti da usare per l'ufficio HR (da 0 a 3)
- "-t": imposta il numero di utenti da usare per l'ufficio tecnico (da 0 a 2); l'impostazione di un valore > 0 istruisce lo script jmeter ad usare la versione BPMN "complex".

```bash
cd activiti-cloud-process-simulator
cd jmeter
./run_jmeter.sh -i CLUSTER_IP_CHANGEME -h 1 -t 0
```

## Configurazione dashboard grafana
- Accesso alla UI di grafana: da browser web, accedere al link [](http://CLUSTER_IP_CHANGEME/grafana)
- Login con le credenziali di default (admin:admin)
- Aggiungere un nuovo datasource:
	+ Navigare su: [http://CLUSTER_IP_CHANGEME/grafana/datasources](http://CLUSTER_IP_CHANGEME/grafana/datasources)
	+ Click "Add data source"
	+ Selezionare il tipo di datasource "PostgreSQL"
	+ Impostare i parametri:
		* Host: activiti-postgres:5432
		* Database: activitidb
		* User: activiti
		* Password: mypassword
		* TLS/SSL Mode: disable
	+ Click su "Save & test" verificando il messaggio di conferma "Database Connection OK"
- Aggiugnere la dashboard del simulatore:
	+ Navigare su: [http://CLUSTER_IP_CHANGEME/grafana/dashboards](http://CLUSTER_IP_CHANGEME/grafana/dashboards)
	+ Click "New -> Import"
	+ Click "Upload JSON file"
	+ Selezionare il file "dashboard.json" contenuto alla path "./activiti-cloud-process-simulator/grafana"
	+ Click "Import"
