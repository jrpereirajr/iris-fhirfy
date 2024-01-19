 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-fhirfy)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fhirfy&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fhirfy)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fhirfy&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fhirfy)

# IRIS-FHIRfy

IRIS-FHIRfy is a project aimed at simplifying healthcare data interoperability by helping developer to understand and design the workflow from the input data. Leveraging the power of InterSystems IRIS Interoperability and LLMs (Language Model Models), this project offers a seamless solution for converting raw data into the HL7 FHIR (Fast Healthcare Interoperability Resources) standard.

## Motivation

FHIR, or Fast Healthcare Interoperability Resources, plays a pivotal role in healthcare interoperability by offering a standardized framework for exchanging healthcare data. It defines a set of data formats and APIs that enable seamless sharing of patient information, clinical data, and administrative details across various healthcare systems. FHIR's importance lies in its ability to enhance data accessibility, improve care coordination, and facilitate the development of innovative healthcare applications.

Healthcare data is incredibly diverse, ranging from structured electronic health records (EHRs) to unstructured patient notes, images, and sensor data. This diversity poses a significant challenge for interoperability development. Integrating disparate data sources and ensuring they adhere to FHIR standards can be complex and time-consuming, often requiring extensive manual effort and expertise.

InterSystems IRIS, with its powerful interoperability capabilities, emerges as a valuable tool for addressing these challenges. IRIS provides a robust platform for data integration, transformation, and routing, making it easier to handle the variety of healthcare data formats. Its ability to connect disparate systems and support FHIR standards natively makes it a natural choice for healthcare interoperability projects.

The motivation behind the IRIS-FHIRfy project stems from recognizing the critical need to simplify the conversion of raw healthcare data into the FHIR format. By leveraging the capabilities of InterSystems IRIS and Language Model Models (LLMs), such as advanced natural language processing, IRIS-FHIRfy aims to empower developers with a streamlined solution. This project seeks to expedite the process of converting diverse healthcare data sources into FHIR, reducing development effort and accelerating the adoption of FHIR standards in healthcare applications.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 

### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install fhir-server"
```

This will install FHIR server in FHIRSERVER namespace.

Or call the following for installing programmatically:
```
set sc=$zpm("install fhir-server")
```
### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/intersystems-community/iris-fhirfy.git
```

Open the terminal in this directory and run:

```
$ docker-compose up -d
```

## Patient data
The template goes with 5 preloaded patents in [/data/fhir](https://github.com/intersystems-community/iris-fhir-server-template/tree/master/data/fhir) folder which are being loaded during [docker build](https://github.com/intersystems-community/iris-fhir-server-template/blob/8bd2932b34468f14530a53d3ab5125f9077696bb/iris.script#L26)
You can generate more patients doing the following. Open shel terminal in repository folder and call:
```
#./synthea-loader.sh 10
```
this will create 10 more patients in data/fhir folder.
Then open IRIS terminal in FHIRSERVER namespace with the following command:
```
docker-compose exec iris iris session iris -U FHIRServer
```
and call the loader method:
```
FHIRSERVER>d ##class(fhirtemplate.Setup).LoadPatientData("/irisdev/app/output/fhir","FHIRSERVER","/fhir/r4")
```

with using the [following project](https://github.com/intersystems-community/irisdemo-base-synthea)

## Testing FHIR R4 API

Open URL http://localhost:32783/fhir/r4/metadata
you should see the output of fhir resources on this server

## Testing Postman calls
Get fhir resources metadata
GET call for http://localhost:32783/fhir/r4/metadata
<img width="881" alt="Screenshot 2020-08-07 at 17 42 04" src="https://user-images.githubusercontent.com/2781759/89657453-c7cdac00-d8d5-11ea-8fed-71fa8447cc45.png">

Open Postman and make a GET call for the preloaded Patient:
http://localhost:32783/fhir/r4/Patient/1
<img width="884" alt="Screenshot 2020-08-07 at 17 42 26" src="https://user-images.githubusercontent.com/2781759/89657252-71606d80-d8d5-11ea-957f-041dbceffdc8.png">

## Testing FHIR API calls in simple frontend APP

the very basic frontend app with search and get calls to Patient and Observation FHIR resources could be found here:
http://localhost:32783/fhirUI/FHIRAppDemo.html
or from VSCode ObjectScript menu:
<img width="616" alt="Screenshot 2020-08-07 at 17 34 49" src="https://user-images.githubusercontent.com/2781759/89657546-ea5fc500-d8d5-11ea-97ed-6fbbf84da655.png">

While open the page you will see search result for female anemic patients and graphs a selected patient's hemoglobin values:
<img width="484" alt="Screenshot 2020-08-06 at 18 51 22" src="https://user-images.githubusercontent.com/2781759/89657718-2b57d980-d8d6-11ea-800f-d09dfb48f8bc.png">

## Contributing

We welcome contributions from the open-source community. Whether you're a developer, data scientist, or healthcare expert, your expertise can help us advance healthcare interoperability. Feel free to open issues, submit pull requests, or engage in discussions.

## License

Iris-FHIRfy is released under the MIT license. See the [LICENSE](./LICENSE) file for more details.

## Troubleshooting
**ERROR #5001: Error -28 Creating Directory /usr/irissys/mgr/FHIRSERVER/**
If you see this error it probably means that you ran out of space in docker.
you can clean up it with the following command:
```
docker system prune -f
```
And then start rebuilding image without using cache:
```
docker-compose build --no-cache
```
and start the container with:
```
docker-compose up -d
```

This and other helpful commands you can find in [dev.md](https://github.com/intersystems-community/iris-fhirfy/blob/cd7e0111ff94dcac82377a2aa7df0ce5e0571b5a/dev.md)
